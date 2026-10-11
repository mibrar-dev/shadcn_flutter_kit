// The `checkbox` component: [Checkbox] with three values, two modes
// (controlled and controller-driven) and form participation through
// [FormValueSupplier].
//
// The old module had two widgets (`Checkbox` + `ControlledCheckbox`), a
// `CheckboxController` and a hand-rolled `AnimatedCheckPainter`. The adapter is
// gone (one widget, two modes), the painter is replaced by the shadcn check /
// minus indicator and interaction moved to the `Clickable` primitive.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/clickable.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/widget_states.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'checkbox_style.dart';

export 'checkbox_style.dart';

/// Lookup key of the 16px checkbox box surface (fill/border live here only).
const ValueKey<String> kCheckboxBoxKey = ValueKey<String>(
  'shadcn.checkbox.box',
);

/// Opacity applied to the whole checkbox while disabled (shadcn
/// `opacity-50`).
const double _checkboxDisabledOpacity = 0.5;

/// Cursor for an enabled checkbox; the system arrow while disabled.
const _checkboxMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

/// Duration of the indicator fade.
const Duration _checkboxIndicatorDuration = Duration(milliseconds: 100);

/// Holds the value of an uncontrolled [Checkbox].
class CheckboxController extends ValueNotifier<CheckboxValue> {
  /// Creates a controller, unchecked by default.
  CheckboxController([super.value = CheckboxValue.unchecked]);

  /// Moves to [CheckboxValue.checked].
  void check() => value = CheckboxValue.checked;

  /// Moves to [CheckboxValue.unchecked].
  void uncheck() => value = CheckboxValue.unchecked;

  /// Moves to [CheckboxValue.indeterminate].
  void setIndeterminate() => value = CheckboxValue.indeterminate;

  /// Flips between checked and unchecked; indeterminate becomes checked.
  void toggle() {
    value = value == CheckboxValue.checked
        ? CheckboxValue.unchecked
        : CheckboxValue.checked;
  }

  /// Cycles unchecked -> checked -> indeterminate -> unchecked.
  void cycle() {
    value = switch (value) {
      CheckboxValue.unchecked => CheckboxValue.checked,
      CheckboxValue.checked => CheckboxValue.indeterminate,
      CheckboxValue.indeterminate => CheckboxValue.unchecked,
    };
  }
}

/// A tri-state checkbox.
///
/// Two modes:
/// * uncontrolled — pass a [controller]; `value`/`onChanged` must be null;
/// * controlled — pass `value` and `onChanged` (null `onChanged` disables).
class Checkbox extends StatefulWidget {
  /// Creates a checkbox.
  const Checkbox({
    super.key,
    this.value = CheckboxValue.unchecked,
    this.controller,
    this.onChanged,
    this.tristate = false,
    this.enabled,
    this.label,
    this.size,
    this.gap,
    this.padding,
    this.focusNode,
    this.autofocus = false,
    this.onHover,
    this.onFocusChange,
    this.theme,
  }) : assert(
         controller == null ||
             (value == CheckboxValue.unchecked && onChanged == null),
         'A controller-driven Checkbox must not also receive value/onChanged',
       );

  /// Current value in controlled mode.
  final CheckboxValue value;

  /// Controller mode: the controller owns the value.
  final CheckboxController? controller;

  /// Called with the next value in controlled mode.
  final ValueChanged<CheckboxValue>? onChanged;

  /// Whether a tap cycles through the indeterminate state as well.
  final bool tristate;

  /// Overrides the enabled state; null means "interactive when controlled or
  /// controller-driven".
  final bool? enabled;

  /// Text shown next to the box.
  final Widget? label;

  /// Side length of the box; null falls back to the size table.
  final double? size;

  /// Space between the box and [label]; null falls back to the size table.
  final double? gap;

  /// Padding around the whole control; null falls back to the size table.
  final EdgeInsetsGeometry? padding;

  /// Focus node. A node is created internally when [autofocus] is true and
  /// this is null.
  final FocusNode? focusNode;

  /// Whether the checkbox requests focus when first built.
  final bool autofocus;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Widget-leg override, merged over the component/app/defaults.
  final CheckboxStyle? theme;

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox>
    with FormValueSupplier<CheckboxValue, Checkbox> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  CheckboxValue get _value => widget.controller?.value ?? widget.value;

  bool get _isEnabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autofocus != oldWidget.autofocus ||
        widget.focusNode != oldWidget.focusNode) {
      _syncAutofocus();
    }
  }

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _syncAutofocus() {
    final bool needsOwnNode = widget.autofocus && widget.focusNode == null;
    if (needsOwnNode && _ownedFocusNode == null) {
      final FocusNode node = FocusNode(debugLabel: 'Checkbox');
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

  /// The value a tap moves to: unchecked -> checked -> (indeterminate).
  CheckboxValue get _nextValue {
    if (!widget.tristate) {
      return _value == CheckboxValue.checked
          ? CheckboxValue.unchecked
          : CheckboxValue.checked;
    }
    return switch (_value) {
      CheckboxValue.unchecked => CheckboxValue.checked,
      CheckboxValue.checked => CheckboxValue.indeterminate,
      CheckboxValue.indeterminate => CheckboxValue.unchecked,
    };
  }

  void _handleTap() {
    final CheckboxValue next = _nextValue;
    final CheckboxController? controller = widget.controller;
    if (controller != null) {
      controller.value = next;
    } else {
      widget.onChanged?.call(next);
    }
  }

  /// Form validation asked for a different value.
  @override
  void didReplaceFormValue(CheckboxValue value) {
    final CheckboxController? controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _value;
    final CheckboxController? controller = widget.controller;
    if (controller == null) {
      return _build(context);
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _build(context),
    );
  }

  Widget _build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final CheckboxValue value = _value;
    final bool enabled = _isEnabled;
    final CheckboxTheme container =
        resolveComponentStyle<CheckboxTheme, CheckboxTheme>(
          context,
          select: (t) => t,
          defaults: checkboxDefaults,
        );
    final CheckboxStyle resolved = (widget.theme ?? const CheckboxStyle())
        .merge(container.forValue(value));
    final double size = widget.size ?? resolved.size ?? checkboxDefaultSize;
    final double gap =
        (widget.gap ?? resolved.gap ?? checkboxDefaultGap) *
        theme.density.scale *
        theme.scaling;
    final EdgeInsetsGeometry padding =
        widget.padding ?? resolved.padding ?? checkboxDefaultPadding;
    // shadcn check icon `size-3.5` = 14 inside the `size-4` (16) box.
    final double indicatorSize = resolved.indicatorSize ?? size * 0.875;
    final double borderWidth = resolved.borderWidth ?? 1;
    final BorderRadiusGeometry radius =
        resolved.borderRadius ?? theme.borderRadiusSm;
    final TextStyle labelStyle =
        (resolved.labelStyle ??
                container.labelStyle ??
                checkboxDefaultLabelStyle)
            .copyWith(
              color: resolved.labelStyle?.color ?? theme.colors.foreground,
            );

    final Color? indicatorColor = resolved.indicatorColor?.resolve(
      theme.colors,
    );
    final Widget box = _CheckboxBox(
      size: size,
      indicatorSize: indicatorSize,
      borderWidth: borderWidth,
      radius: radius,
      background: resolved.background,
      borderColor: resolved.borderColor,
      indicatorColor: indicatorColor,
      value: value,
      colors: theme.colors,
    );

    final Widget row = Row(
      key: const ValueKey<String>('shadcn.checkbox.row'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        box,
        if (widget.label != null) ...<Widget>[
          Gap(gap),
          Flexible(
            child: DefaultTextStyle.merge(
              style: labelStyle,
              child: widget.label!,
            ),
          ),
        ],
      ],
    );

    // The Clickable paints no surface of its own — the 16px box alone
    // carries the fill/border, the label sits beside it uncoloured (shadcn
    // checkbox). The row hugs its content (MainAxisSize.min); under a stretch
    // parent the transparent Clickable may fill the width, but no fill is
    // ever painted outside the box.
    final Widget padded = Padding(padding: padding, child: row);

    return Semantics(
      checked: value == CheckboxValue.checked,
      mixed: value == CheckboxValue.indeterminate,
      enabled: enabled,
      label: widget.label is Text ? (widget.label! as Text).data : null,
      child: Opacity(
        opacity: enabled ? 1 : _checkboxDisabledOpacity,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? _handleTap : null,
          onHover: widget.onHover,
          onFocus: widget.onFocusChange,
          focusNode: _focusNode,
          mouseCursor: _checkboxMouseCursor,
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(null),
          decoration: const WidgetStatePropertyAll<Decoration?>(null),
          child: padded,
        ),
      ),
    );
  }
}

/// The 16px checkbox box: the only surface that carries fill/border.
///
/// Reads the states `Clickable` publishes so hover/press/focus rows reach the
/// box without the clickable's own decoration (the row carries the label,
/// which must not be filled).
class _CheckboxBox extends StatelessWidget {
  const _CheckboxBox({
    required this.size,
    required this.indicatorSize,
    required this.borderWidth,
    required this.radius,
    required this.background,
    required this.borderColor,
    required this.indicatorColor,
    required this.value,
    required this.colors,
  });

  final double size;
  final double indicatorSize;
  final double borderWidth;
  final BorderRadiusGeometry radius;
  final StateValue<ThemedColor>? background;
  final StateValue<ThemedColor>? borderColor;
  final Color? indicatorColor;
  final CheckboxValue value;
  final ShadcnColors colors;

  @override
  Widget build(BuildContext context) {
    final Set<WidgetState> states =
        Data.maybeOf<WidgetStatesData>(context)?.states ??
        const <WidgetState>{};
    Color? colorFor(StateValue<ThemedColor>? entry) =>
        entry?.resolve(states)?.resolve(colors);
    final Color? fill = colorFor(background);
    final Color? border = colorFor(borderColor);
    final BoxDecoration decoration = BoxDecoration(
      color: fill,
      borderRadius: radius,
      border: border == null || borderWidth <= 0
          ? null
          : Border.all(color: border, width: borderWidth),
    );
    final Widget indicator = AnimatedOpacity(
      duration: _checkboxIndicatorDuration,
      opacity: indicatorColor == null ? 0 : 1,
      child: SizedBox.fromSize(
        size: Size.square(indicatorSize),
        child: indicatorColor == null
            ? null
            : IconTheme.merge(
                data: IconThemeData(color: indicatorColor, size: indicatorSize),
                child: Icon(
                  value == CheckboxValue.indeterminate
                      ? LucideIcons.minus
                      : LucideIcons.check,
                  size: indicatorSize,
                  color: indicatorColor,
                ),
              ),
      ),
    );
    return DecoratedBox(
      key: kCheckboxBoxKey,
      decoration: decoration,
      child: SizedBox.fromSize(
        size: Size.square(size),
        child: Center(child: indicator),
      ),
    );
  }
}
