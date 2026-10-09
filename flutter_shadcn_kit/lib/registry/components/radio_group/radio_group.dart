// The `radio_group` component: [ShadcnRadioGroup] (single-select scope with form
// participation), [RadioItem] (row or card shape) and [RadioIndicator].
//
// Ported from `components/form/radio_group/**` (17 files, 1.6k LOC) into three
// files. The bugs it fixed are listed in README.md under "Fixed (not ported)".
//
// Two old behaviours are dropped deliberately:
//   * selecting on *focus* (`onShowFocusHighlight` called `_setSelected`), so
//     tabbing into a group changed the value before the user pressed anything;
//   * `ControlledRadioGroup` + the `ControlledComponent` adapter, replaced by
//     one widget with two modes (like `Switch`).

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/roving_group.dart';
import '../../primitives/selectable_radio/selectable_radio.dart';
import '../../theme/theme.dart';
import '../card/card.dart';
import 'radio_group_style.dart';

export '../../primitives/selectable_radio/selectable_radio.dart'
    show RadioIndicator, RadioItem;
export 'radio_group_style.dart';

/// Holds the value of an uncontrolled [ShadcnRadioGroup].
class ShadcnRadioGroupController<T> extends ValueNotifier<T?> {
  /// Creates a controller, with no selection by default.
  ShadcnRadioGroupController([super.value]);

  /// Selects [next].
  void select(T? next) => value = next;
}

/// A single-select group of radio items.
///
/// Two modes: controlled (`value` + `onChanged`, null `onChanged` disables) or
/// uncontrolled ([ShadcnRadioGroupController]). The caller lays the items out; the
/// group owns the selection, the arrow-key traversal and the form value.
class ShadcnRadioGroup<T> extends StatefulWidget {
  /// Creates a radio group.
  const ShadcnRadioGroup({
    super.key,
    required this.child,
    this.value,
    this.controller,
    this.onChanged,
    this.enabled,
    this.direction = Axis.vertical,
    this.theme,
  }) : assert(
         controller == null || onChanged == null,
         'A controller-driven ShadcnRadioGroup must not also receive onChanged',
       );

  /// The items, laid out by the caller.
  final Widget child;

  /// The selected value in controlled mode.
  final T? value;

  /// Controller mode: the controller owns the selection.
  final ShadcnRadioGroupController<T>? controller;

  /// Called with the newly selected value in controlled mode.
  final ValueChanged<T>? onChanged;

  /// Overrides the enabled state; null means "interactive when driven".
  final bool? enabled;

  /// Arrow-key reading order: vertical walks top to bottom, horizontal left to
  /// right.
  final Axis direction;

  /// Widget-leg theme override for the group.
  final RadioGroupTheme? theme;

  @override
  State<ShadcnRadioGroup<T>> createState() => _RadioGroupState<T>();
}

/// The `ShadcnRadioGroup` state.
class _RadioGroupState<T> extends State<ShadcnRadioGroup<T>>
    with FormValueSupplier<T, ShadcnRadioGroup<T>> {
  /// The registered items, in tree order, for the arrow-key traversal.
  final RovingGroupRegistry<T> _registry = RovingGroupRegistry<T>();

  bool get _enabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  T? get _value => widget.controller?.value ?? widget.value;

  @override
  void initState() {
    super.initState();
    _listenToController();
    formValue = _value;
  }

  @override
  void didUpdateWidget(covariant ShadcnRadioGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      _listenToController();
    }
    if (oldWidget.value != widget.value) {
      formValue = _value;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _listenToController() {
    widget.controller?.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    formValue = _value;
    if (mounted) {
      setState(() {});
    }
  }

  void _select(T value) {
    if (!_enabled) {
      return;
    }
    final ShadcnRadioGroupController<T>? controller = widget.controller;
    if (controller != null) {
      controller.select(value);
    } else {
      widget.onChanged?.call(value);
    }
  }

  /// Form validation asked for a different value.
  @override
  void didReplaceFormValue(T value) => _select(value);

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _value;
    final SelectableData<T> data = SelectableData<T>(
      selected: _value,
      enabled: _enabled,
      onChanged: _select,
    );
    // The registry owns the traversal and hands each item the arrow-key map:
    // `Clickable` binds those keys to directional focus traversal, and the
    // nearest `Shortcuts` wins, so a `Shortcuts` above the items would never
    // be reached.
    _registry.direction = widget.direction;
    _registry.onSelect = _select;

    return SelectableDataScope<T>(
      data: data,
      child: _registry.scope(
        child: FocusTraversalGroup(
          policy: widget.direction == Axis.horizontal
              ? OrderedTraversalPolicy()
              : ReadingOrderTraversalPolicy(),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A card-shaped option of a [ShadcnRadioGroup]: the indicator and a whole
/// block of content.
///
/// The border *colour* reacts to selection; its width never changes, so
/// selecting a card cannot shift its content.
class RadioCard<T> extends StatefulWidget {
  /// Creates a radio card.
  const RadioCard({
    super.key,
    required this.value,
    required this.child,
    this.trailing,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.theme,
    this.cardTheme,
  });

  /// The value this card stands for.
  final T value;

  /// The card content, shown next to the indicator.
  final Widget child;

  /// Widget shown after the content.
  final Widget? trailing;

  /// Whether this card accepts input.
  final bool enabled;

  /// Focus node; created internally when [autofocus] is true and this is null.
  final FocusNode? focusNode;

  /// Whether the card takes focus when first built.
  final bool autofocus;

  /// Widget-leg override for the indicator slice.
  final SelectableRadioTheme? theme;

  /// Widget-leg override for the card surface.
  final SelectableCardTheme? cardTheme;

  @override
  State<RadioCard<T>> createState() => _RadioCardState<T>();
}

/// The `RadioCard` state.
class _RadioCardState<T> extends State<RadioCard<T>> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  /// Cached in [didChangeDependencies]: `dispose` runs after the element has
  /// been deactivated, so reading an inherited widget from `context` there
  /// would assert.
  RovingGroupRegistry<T>? _registry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registry = Data.maybeOf<RovingGroupRegistry<T>>(context);
    _syncRegistration();
  }

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant RadioCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autofocus != oldWidget.autofocus ||
        widget.focusNode != oldWidget.focusNode) {
      _syncAutofocus();
    }
  }

  @override
  void dispose() {
    _registry?.unregister(this);
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _syncAutofocus() {
    final bool needsOwnNode = widget.autofocus && widget.focusNode == null;
    if (needsOwnNode && _ownedFocusNode == null) {
      final FocusNode node = FocusNode(debugLabel: 'RadioCard');
      _ownedFocusNode = node;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          node.requestFocus();
        }
      });
      return;
    }
    if (!needsOwnNode && _ownedFocusNode != null) {
      _ownedFocusNode!.dispose();
      _ownedFocusNode = null;
    }
  }

  /// Tells the group about this card so the arrow keys can walk onto it.
  void _syncRegistration() {
    final RovingGroupRegistry<T>? registry = _registry;
    if (registry == null) {
      return;
    }
    final SelectableData<T>? group = Data.maybeOf<SelectableData<T>>(context);
    registry.register(
      RovingItem<T>(
        key: this,
        value: widget.value,
        enabled: widget.enabled && (group?.enabled ?? false),
        selected: group?.selected == widget.value,
        requestFocus: () => _focusNode?.requestFocus(),
      ),
    );
  }

  void _select() =>
      Data.maybeOf<SelectableData<T>>(context)?.select(widget.value);

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final SelectableData<T>? group = Data.maybeOf<SelectableData<T>>(context);
    final SelectableRadioTheme rows =
        resolveComponentStyle<SelectableRadioTheme, SelectableRadioTheme>(
          context,
          widget: widget.theme,
          select: (SelectableRadioTheme t) => t,
          defaults: selectableRadioDefaults,
        );
    final SelectableCardTheme card =
        resolveComponentStyle<SelectableCardTheme, SelectableCardTheme>(
          context,
          widget: widget.cardTheme,
          select: (SelectableCardTheme t) => t,
          defaults: selectableCardDefaults,
        );
    final bool selected = group?.selected == widget.value;
    final bool enabled = widget.enabled && (group?.enabled ?? false);
    _syncRegistration();
    final Set<WidgetState> states = <WidgetState>{
      if (selected) WidgetState.selected,
    };
    final RadioIndicatorStyle indicator =
        (rows.indicator ?? const RadioIndicatorStyle()).merge(
          rows.forValue(selected),
        );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : selectableItemDisabledOpacity,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? _select : null,
          focusNode: _focusNode,
          // The group's traversal map wins over `Clickable`'s own arrow-key
          // binding to directional focus.
          shortcuts: _registry?.shortcuts,
          actions: _registry?.actions,
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(null),
          decoration: const WidgetStatePropertyAll<Decoration?>(null),
          child: Card(
            key: kRadioCardKey,
            padding: card.padding ?? selectableCardDefaults.padding,
            background: card.background?.resolve(states),
            borderColor: card.borderColor?.resolve(states),
            borderWidth: card.borderWidth ?? 1,
            borderRadius:
                card.borderRadius ??
                BorderRadius.circular(
                  shadcnTheme.radiusLg * shadcnTheme.scaling,
                ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: RadioIndicator(style: indicator, selected: selected),
                ),
                Gap(card.gap ?? 12),
                Flexible(child: widget.child),
                if (widget.trailing != null) ...<Widget>[
                  Gap(card.gap ?? 12),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Lookup key of a radio card surface.
const ValueKey<String> kRadioCardKey = ValueKey<String>(
  'shadcn.radio_group.card',
);
