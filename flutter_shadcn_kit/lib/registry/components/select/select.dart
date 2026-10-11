// The `select` component: a single-selection dropdown picker. The trigger
// reuses the `button` variant table and the popover primitive, the popup
// rows come from `primitives/select_popup.dart`, and the surface/search
// field are the `menu` and `input` components.
//
// Clean break: the old `ControlledSelect`, `SelectController` and the
// `SelectPopup`/`SelectItemButton` family are gone. The widget is controlled
// (`value` + `onChanged`); rows are `SelectItem`s. Multi selection is the
// sibling `multi_select` component.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/geometry.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/clickable.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover_controller.dart';
import '../../primitives/select_popup.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../input/input.dart';
import '../menu/menu.dart';
import 'select_style.dart';

export 'select_style.dart';

/// Builds the trigger content of the selected value.
typedef SelectValueBuilder<T> = Widget Function(BuildContext context, T value);

/// Builds the popup rows for a search query (null when the query is empty).
typedef SelectItemsBuilder =
    FutureOr<List<Widget>> Function(BuildContext context, String? query);

/// Maps an item activation onto the next selection; returning the current
/// value leaves the selection unchanged.
typedef SelectValueSelectionHandler<T> =
    T? Function(T? oldValue, Object? value, bool selected);

/// Tests whether [test] is part of the current selection.
typedef SelectValueSelectionPredicate<T> =
    bool Function(T? value, Object? test);

/// A single-selection dropdown picker: the trigger shows [itemBuilder]'s
/// rendering of [value] (or [placeholder] while [value] is null). Tapping
/// opens a popover of [items] (or the asynchronous [builder], which enables
/// a search field); picking a row reports through [onChanged], and forms see
/// the value through `FormValueSupplier`.
class Select<T> extends StatefulWidget {
  /// Creates a dropdown picker.
  const Select({
    super.key,
    required this.itemBuilder,
    this.value,
    this.onChanged,
    this.enabled,
    this.placeholder,
    this.items,
    this.builder,
    this.searchPlaceholder,
    this.focusNode,
    this.expandIcon = const Icon(LucideIcons.chevronsUpDown),
    this.canUnselect = false,
    this.autoClose = true,
    this.popupConstraints,
    this.valueSelectionHandler,
    this.valueSelectionPredicate,
    this.theme,
  });

  /// Builds the trigger content of the selected value.
  final SelectValueBuilder<T> itemBuilder;

  /// The selected value; null shows [placeholder].
  final T? value;

  /// Called with the next selection; null disables the select.
  final ValueChanged<T?>? onChanged;

  /// Overrides the enabled state; null means `onChanged != null`.
  final bool? enabled;

  /// Shown in the trigger while [value] is null.
  final Widget? placeholder;

  /// The popup rows; ignored when [builder] is set.
  final FutureOr<List<Widget>>? items;

  /// Builds the popup rows for a search query; enables the search field.
  final SelectItemsBuilder? builder;

  /// Placeholder of the search field (shown when [builder] is set).
  final Widget? searchPlaceholder;

  /// Trigger focus node.
  final FocusNode? focusNode;

  /// Trigger trailing icon; null hides it.
  final Widget? expandIcon;

  /// Whether picking the selected value clears the selection.
  final bool canUnselect;

  /// Whether picking a value closes the popup. Default: true (single
  /// selection); `multi_select` passes false so the popup stays open.
  final bool autoClose;

  /// Popup size constraints; null resolves `SelectTheme.constraints`, then
  /// 192-320 wide and 240 high. The popup is always trigger-wide.
  final BoxConstraints? popupConstraints;

  /// Custom selection mapping; null is single selection.
  final SelectValueSelectionHandler<T>? valueSelectionHandler;

  /// Custom selection test; null is `value == test`.
  final SelectValueSelectionPredicate<T>? valueSelectionPredicate;

  /// Widget-leg theme override, merged over the component/app/defaults legs.
  final SelectTheme? theme;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>>
    with FormValueSupplier<T, Select<T>> {
  final PopoverController _popover = PopoverController();
  late final ValueNotifier<T?> _value = ValueNotifier<T?>(widget.value);
  FocusNode? _ownedFocus;
  FocusNode get _focus =>
      widget.focusNode ?? (_ownedFocus ??= FocusNode(debugLabel: 'Select'));

  bool get _enabled => widget.enabled ?? widget.onChanged != null;

  bool get _searching => widget.builder != null;
  @override
  void initState() {
    super.initState();
    formValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant Select<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      formValue = widget.value;
      // The popup's rows listen to _value; syncing during this build would
      // mark them dirty mid-build, so the sync lands on the next frame.
      final T? next = widget.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _value.value = next;
        }
      });
    }
    if (!_enabled) {
      _popover.close();
    }
  }

  @override
  void dispose() {
    _popover.dispose();
    _ownedFocus?.dispose();
    _value.dispose();
    super.dispose();
  }

  @override
  void didReplaceFormValue(T value) => widget.onChanged?.call(value);
  bool _isSelected(Object? test) =>
      (widget.valueSelectionPredicate ?? singleSelectionPredicate<T>)(
        _value.value,
        test,
      );
  void _onItem(Object? item, bool selected) {
    if (!selected && !widget.canUnselect) {
      if (widget.autoClose) {
        _popover.close();
      }
      return;
    }
    final T? next = (widget.valueSelectionHandler ?? singleSelectionHandler<T>)(
      _value.value,
      item,
      selected,
    );
    if (next != _value.value) {
      _value.value = next;
      widget.onChanged?.call(next);
      formValue = next;
    }
    if (widget.autoClose) {
      _popover.close();
    }
  }

  SelectData _data() => (
    enabled: _enabled,
    hasSelection: _value.value != null,
    isSelected: _isSelected,
    onChanged: _onItem,
  );
  SelectTheme _style(BuildContext context) =>
      resolveComponentStyle<SelectTheme, SelectTheme>(
        context,
        widget: widget.theme,
        select: (t) => t,
        defaults: selectDefaults,
      );

  void _open() {
    _popover
        .show<void>(
          context: context,
          // Below the trigger's start edge; the popup hugs the widest
          // option and is never narrower than the trigger.
          alignment: AlignmentDirectional.topStart,
          anchorAlignment: AlignmentDirectional.bottomStart,
          offset: const Offset(0, 4),
          widthConstraint: PopoverConstraint.anchorMinSize,
          builder: (context) => ComponentTheme<SelectTheme>(
            data: _style(context),
            child: ListenableBuilder(
              listenable: _value,
              builder: (context, _) => Data<SelectData>.inherit(
                data: _data(),
                child: _popup(context),
              ),
            ),
          ),
        )
        .then((_) {
          if (mounted) {
            _focus.requestFocus();
          }
        });
  }

  /// The popup body: menu surface, optional search field, resolved rows.
  Widget _popup(BuildContext context) {
    final SelectTheme style = _style(context);
    return SelectPopupBody(
      items: widget.items,
      builder: widget.builder,
      constraints: widget.popupConstraints ?? style.constraints,
      searchField: _searching
          ? (context, controller) => Input(
              controller: controller,
              autofocus: true,
              decoration: const BoxDecoration(color: Color(0x00000000)),
              border: Border.fromBorderSide(BorderSide.none),
              padding: const EdgeInsetsDensity.pxSymmetric(
                horizontal: 12,
                vertical: 12,
              ),
              placeholder: widget.searchPlaceholder,
            )
          : null,
      spacer: _searching ? const MenuSeparator() : null,
      surface: (context, content) => MenuPopup(
        theme: style.popup,
        children: <Widget>[
          MenuGroup(
            autofocus: !_searching,
            onDismissed: _popover.close,
            children: <Widget>[content],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final SelectTheme style = _style(context);
    final bool enabled = _enabled;
    final ButtonVariant variant = style.variant ?? ButtonVariant.outline;
    final ButtonVariantStyle trigger = const ButtonVariantStyle(
      padding: selectDefaultTriggerPadding,
    ).merge(style.trigger).merge(buttonDefaults.forVariant(variant)!);

    Color? colorFor(StateValue<ThemedColor>? value, Set<WidgetState> states) =>
        value?.resolve(states)?.resolve(ambient.colors);
    Decoration decorationFor(Set<WidgetState> states) {
      final Color? borderColor = colorFor(trigger.borderColor, states);
      final double borderWidth = trigger.borderWidth ?? 1;
      return BoxDecoration(
        color: colorFor(trigger.background, states),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: borderWidth),
        borderRadius: ambient.borderRadiusMd,
      );
    }

    final T? selected = widget.value;
    final Widget valueContent = selected != null
        ? widget.itemBuilder(context, selected)
        : widget.placeholder ?? const SizedBox.shrink();
    // A painted border adds layout; reserve it in the 36px total.
    final EdgeInsets resolvedPadding = resolveEdgeInsets(
      trigger.padding ?? selectDefaultTriggerPadding,
      ambient.density.baseContentPadding * ambient.scaling,
    ).resolve(Directionality.of(context));
    final double borderWidth = trigger.borderColor == null
        ? 0
        : trigger.borderWidth ?? 1;
    return Data<SelectData>.inherit(
      data: _data(),
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: IntrinsicWidth(
          child: Clickable(
            enabled: enabled,
            focusNode: _focus,
            onPressed: enabled ? _open : null,
            decoration: WidgetStateProperty.resolveWith(decorationFor),
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
              insetBorder(resolvedPadding, borderWidth),
            ),
            textStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                fontSize: 14,
                color: colorFor(trigger.foreground, states),
              ),
            ),
            iconTheme: WidgetStateProperty.resolveWith(
              (states) => IconThemeData(
                size: 16,
                color: colorFor(trigger.foreground, states),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    36 -
                    math.max(resolvedPadding.top, borderWidth) -
                    math.max(resolvedPadding.bottom, borderWidth),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(child: valueContent),
                  if (widget.expandIcon != null) ...<Widget>[
                    Gap(ambient.spacing.sm),
                    widget.expandIcon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One selectable popup row. Place it in [Select.items] or build it from
/// [Select.builder]; traversal, hover focus and the check indicator come
/// from the shared select row.
class SelectItem<T> extends StatelessWidget {
  /// Creates a select row.
  const SelectItem({
    super.key,
    required this.value,
    required this.child,
    this.enabled = true,
  });

  /// The value this row selects.
  final T value;

  /// Row content.
  final Widget child;

  /// Whether the row can be activated (on top of the select's own state).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final SelectData? data = Data.maybeOf<SelectData>(context);
    final bool selected = data?.isSelected(value) ?? false;
    final SelectTheme style = resolveComponentStyle<SelectTheme, SelectTheme>(
      context,
      select: (t) => t,
      defaults: selectDefaults,
    );
    return SelectRow(
      selected: selected,
      // shadcn reserves `pr-8` for the check on every option, so rows never
      // shift when the first value is picked.
      reserveIndicator: true,
      enabled: enabled && (data?.enabled ?? true),
      padding: style.itemPadding ?? selectDefaultItemPadding,
      onPressed: () => data?.onChanged(value, !selected),
      child: child,
    );
  }
}
