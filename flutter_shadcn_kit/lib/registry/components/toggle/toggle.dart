// The `toggle` component: [Toggle], a controlled/uncontrolled on/off button,
// plus [ToggleController] for the controller mode.
//
// Separate from `Button` because boolean state, the controller and form
// participation are different behaviour (PLAN §4 rule 2); it also replaces
// the old `SelectedButton` through [Toggle.activeStyle].

import 'dart:math' as math;

import '../../foundation/geometry.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/clickable.dart';
import '../../primitives/form_core/form_value.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'toggle_style.dart';

export 'toggle_style.dart';

/// Opacity applied to the whole toggle while disabled.
const double _toggleDisabledOpacity = 0.5;

/// Cursor for an enabled toggle; the system arrow while disabled.
const _toggleMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

/// Holds the on/off value of an uncontrolled [Toggle].
class ToggleController extends ValueNotifier<bool> {
  /// Creates a controller, off by default.
  ToggleController([super.value = false]);

  /// Flips the value.
  void toggle() => value = !value;
}

/// A button that keeps an on/off state.
///
/// Two modes:
/// * uncontrolled — pass a [controller]; `value`/`onChanged` must be null;
/// * controlled — pass `value` and `onChanged` (null `onChanged` disables).
class Toggle extends StatefulWidget {
  /// Creates a toggle.
  const Toggle({
    super.key,
    this.value,
    this.controller,
    required this.child,
    this.size = ToggleSize.md,
    this.onChanged,
    this.enabled,
    this.style,
    this.activeStyle,
    this.theme,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
         controller == null || (value == null && onChanged == null),
         'A controller-driven Toggle must not also receive value/onChanged',
       ),
       assert(
         controller != null || value != null,
         'A controlled Toggle requires value',
       );

  /// Current value in controlled mode; null in controller mode.
  final bool? value;

  /// Controller mode: the controller owns the value.
  final ToggleController? controller;

  /// Toggle content, usually a `Text` or an icon.
  final Widget child;

  /// Fixed size row. Defaults to [ToggleSize.md] (h-9 = 36).
  final ToggleSize size;

  /// Called with the next value in controlled mode.
  final ValueChanged<bool>? onChanged;

  /// Overrides the enabled state; null means "interactive when controlled or
  /// controller-driven".
  final bool? enabled;

  /// Widget-leg override for the off state (old `SelectedButton.style`).
  final ToggleStyle? style;

  /// Widget-leg override for the on state (old `selectedStyle`).
  final ToggleStyle? activeStyle;

  /// Generic widget-leg override, merged under [style]/[activeStyle].
  final ToggleStyle? theme;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Focus node. A node is created internally when [autofocus] is true and
  /// this is null.
  final FocusNode? focusNode;

  /// Whether the toggle requests focus when first built.
  final bool autofocus;

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> with FormValueSupplier<bool, Toggle> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  bool get _isOn => widget.controller?.value ?? widget.value!;

  bool get _isEnabled =>
      widget.enabled ?? (widget.controller != null || widget.onChanged != null);

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant Toggle oldWidget) {
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
      final node = FocusNode(debugLabel: 'Toggle');
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

  void _handleToggle() {
    final ToggleController? controller = widget.controller;
    if (controller != null) {
      controller.toggle();
    } else {
      widget.onChanged?.call(!_isOn);
    }
  }

  /// Form validation asked for a different value.
  @override
  void didReplaceFormValue(bool value) {
    final ToggleController? controller = widget.controller;
    if (controller != null) {
      controller.value = value;
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Report the current value to the nearest form; a no-op without one.
    formValue = _isOn;
    final ToggleController? controller = widget.controller;
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
    final bool isOn = _isOn;
    final bool enabled = _isEnabled;
    final ToggleStyle? stateStyle = isOn ? widget.activeStyle : widget.style;
    final ToggleStyle? widgetLeg = widget.theme == null
        ? stateStyle
        : (stateStyle?.merge(widget.theme!) ?? widget.theme);
    final ToggleStyle resolved =
        resolveComponentStyle<ToggleTheme, ToggleStyle>(
          context,
          widget: widgetLeg,
          select: (t) => t.forValue(isOn),
          defaults: toggleDefaults.forValue(isOn)!,
        );
    final EdgeInsetsGeometry padding = resolved.padding ?? toggleDefaultPadding;
    // Border-box totals (shadcn h-8/h-9/h-10 with px-2): the `Clickable`
    // padding wraps the `ConstrainedBox`, so the inner minima subtract the
    // resolved padding to keep totals exact (e.g. 16px icon + 16px padding
    // still measures 36x36, not 52x36). A painted border adds layout as
    // decoration padding, so the minima reserve `max(padding, border)` and the
    // Clickable padding is inset by the border width (F1).
    final double minSide = switch (widget.size) {
      ToggleSize.sm => 32,
      ToggleSize.md => 36,
      ToggleSize.lg => 40,
    };
    final double borderWidth = resolved.borderWidth ?? 0;
    final bool hasBorder = resolved.borderColor != null && borderWidth > 0;
    // Density resolution happens before `.resolve`, so an
    // [EdgeInsetsDensity] theme leg measures its shadcn px value at the
    // default density and scales with every other one.
    final EdgeInsets resolvedPad = resolveEdgeInsets(
      padding,
      theme.density.baseContentPadding * theme.scaling,
    ).resolve(Directionality.of(context));
    final EdgeInsets contentPadding = hasBorder
        ? insetBorder(resolvedPad, borderWidth)
        : resolvedPad;
    final double reservedBorder = hasBorder ? borderWidth : 0;
    final double innerMinWidth =
        (minSide -
                math.max(resolvedPad.left, reservedBorder) -
                math.max(resolvedPad.right, reservedBorder))
            .clamp(0, double.infinity)
            .toDouble();
    final double innerMinHeight =
        (minSide -
                math.max(resolvedPad.top, reservedBorder) -
                math.max(resolvedPad.bottom, reservedBorder))
            .clamp(0, double.infinity)
            .toDouble();

    Color? colorFor(StateValue<ThemedColor>? value, Set<WidgetState> states) {
      return value?.resolve(states)?.resolve(theme.colors);
    }

    // Disabled entries are never set: values fall back to rest colours and
    // the whole control is dimmed once via [_toggleDisabledOpacity].
    Decoration? decorationFor(Set<WidgetState> states) {
      final Color? background = colorFor(resolved.background, states);
      final Color? borderColor = colorFor(resolved.borderColor, states);
      return BoxDecoration(
        color: background,
        // A declared border always occupies its width (transparent where a
        // state has no colour), so the control size never depends on state.
        border: hasBorder
            ? Border.all(
                color: borderColor ?? const Color(0x00000000),
                width: borderWidth,
              )
            : null,
        borderRadius: theme.borderRadiusMd,
      );
    }

    TextStyle? textStyleFor(Set<WidgetState> states) {
      final TextStyle base = resolved.textStyle ?? toggleDefaultTextStyle;
      return base.copyWith(
        color: colorFor(resolved.foreground, states),
        decoration: resolved.decoration?.resolve(states),
      );
    }

    IconThemeData? iconThemeFor(Set<WidgetState> states) {
      final Color? color = colorFor(resolved.foreground, states);
      return color == null ? null : IconThemeData(color: color);
    }

    return Semantics(
      button: true,
      toggled: isOn,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : _toggleDisabledOpacity,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? _handleToggle : null,
          onHover: widget.onHover,
          onFocus: widget.onFocusChange,
          focusNode: _focusNode,
          decoration: WidgetStateProperty.resolveWith(decorationFor),
          mouseCursor: _toggleMouseCursor,
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(contentPadding),
          textStyle: WidgetStateProperty.resolveWith(textStyleFor),
          iconTheme: WidgetStateProperty.resolveWith(iconThemeFor),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: innerMinWidth,
              minHeight: innerMinHeight,
            ),
            child: Center(widthFactor: 1, heightFactor: 1, child: widget.child),
          ),
        ),
      ),
    );
  }
}
