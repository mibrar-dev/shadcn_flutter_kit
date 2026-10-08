// The `button` component: the [Button] widget, the [ButtonGroup] layout and
// the per-state paint pipeline that feeds the `Clickable` interaction
// primitive.
//
// One constructor plus `variant`/`size` enums replaces the old per-variant
// wrapper classes and named constructors (clean break, no aliases).

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'button_group.dart';
import 'button_style.dart';

export 'button_group.dart' show ButtonGroup, ButtonGroupData;
export 'button_style.dart';

/// Opacity applied to the whole button while disabled (shadcn `opacity-50`).
const double _buttonDisabledOpacity = 0.5;

/// Cursor for an enabled button; the system arrow while disabled.
const _buttonMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

/// A pressable action control.
///
/// Use a [ButtonGroup] to connect several buttons; on/off state belongs to the
/// separate `Toggle` component. Rare gestures (secondary click, tap-down
/// tracking) are available through an outer `GestureDetector`.
class Button extends StatefulWidget {
  /// Creates a button.
  const Button({
    super.key,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.leading,
    this.trailing,
    this.focusNode,
    this.autofocus = false,
    this.enabled,
    this.theme,
  });

  /// Button content, usually a `Text` or an `Icon`.
  final Widget child;

  /// Visual variant. Defaults to [ButtonVariant.primary].
  final ButtonVariant variant;

  /// Fixed size row. Defaults to [ButtonSize.md].
  final ButtonSize size;

  /// Called on tap. When null the button is disabled unless [enabled] is true.
  final VoidCallback? onPressed;

  /// Called on long press. Ignored while the button is disabled.
  final VoidCallback? onLongPress;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Widget shown before [child].
  final Widget? leading;

  /// Widget shown after [child].
  final Widget? trailing;

  /// Focus node. A node is created internally when [autofocus] is true and
  /// this is null; otherwise the internal `Clickable` owns its own node.
  final FocusNode? focusNode;

  /// Whether the button requests focus when first built.
  final bool autofocus;

  /// Overrides the enabled state; null means `onPressed != null`.
  final bool? enabled;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final ButtonVariantStyle? theme;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  FocusNode? _ownedFocusNode;

  FocusNode? get _focusNode => widget.focusNode ?? _ownedFocusNode;

  @override
  void initState() {
    super.initState();
    _syncAutofocus();
  }

  @override
  void didUpdateWidget(covariant Button oldWidget) {
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
      final node = FocusNode(debugLabel: 'Button');
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

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool enabled = widget.enabled ?? (widget.onPressed != null);
    final ButtonVariantStyle resolved =
        resolveComponentStyle<ButtonTheme, ButtonVariantStyle>(
          context,
          widget: widget.theme,
          select: (t) => t.forVariant(widget.variant),
          defaults: buttonDefaults.forVariant(widget.variant)!,
        );
    final Density density =
        ComponentTheme.maybeOf<ButtonTheme>(context)?.themeDensity ??
        ComponentThemes.maybeOf<ButtonTheme>(context)?.themeDensity ??
        theme.density;
    final _ButtonSizeMetrics metrics = _buttonMetricsFor(widget.size, density);
    final EdgeInsetsGeometry padding = resolved.padding ?? metrics.padding;
    final BorderRadius radius = _borderRadius(context, theme);

    Color? colorFor(StateValue<ThemedColor>? value, Set<WidgetState> states) {
      return value?.resolve(states)?.resolve(theme.colors);
    }

    // Disabled entries are never set: every value falls back to its rest
    // colour and the whole control is dimmed once via [_buttonDisabledOpacity].
    Decoration? decorationFor(Set<WidgetState> states) {
      final Color? background = colorFor(resolved.background, states);
      final Color? borderColor = colorFor(resolved.borderColor, states);
      final double width = resolved.borderWidth ?? 0;
      return BoxDecoration(
        color: background,
        border: borderColor != null && width > 0
            ? Border.all(color: borderColor, width: width)
            : null,
        borderRadius: radius,
      );
    }

    TextStyle? textStyleFor(Set<WidgetState> states) {
      final TextStyle? base = resolved.textStyle ?? metrics.textStyle;
      if (base == null) {
        return null;
      }
      return base.copyWith(
        color: colorFor(resolved.foreground, states),
        decoration: resolved.decoration?.resolve(states),
      );
    }

    IconThemeData? iconThemeFor(Set<WidgetState> states) {
      final Color? color = colorFor(resolved.foreground, states);
      return color == null ? null : IconThemeData(color: color);
    }

    Widget content = widget.child;
    if (widget.leading != null || widget.trailing != null) {
      final double gap = theme.spacing.sm;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (widget.leading != null) widget.leading!,
          if (widget.leading != null) Gap(gap),
          content,
          if (widget.trailing != null) Gap(gap),
          if (widget.trailing != null) widget.trailing!,
        ],
      );
    }
    content = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: _innerMin(metrics.minWidth, padding, context, true),
        minHeight: _innerMin(metrics.minHeight, padding, context, false),
      ),
      child: Center(widthFactor: 1, heightFactor: 1, child: content),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : _buttonDisabledOpacity,
        child: Clickable(
          enabled: enabled,
          onPressed: enabled ? widget.onPressed : null,
          onLongPress: enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          onFocus: widget.onFocusChange,
          focusNode: _focusNode,
          decoration: WidgetStateProperty.resolveWith(decorationFor),
          mouseCursor: _buttonMouseCursor,
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
          textStyle: WidgetStateProperty.resolveWith(textStyleFor),
          iconTheme: WidgetStateProperty.resolveWith(iconThemeFor),
          child: content,
        ),
      ),
    );
  }

  BorderRadius _borderRadius(BuildContext context, ShadcnThemeData theme) {
    final ButtonGroupData? group = Data.maybeOf<ButtonGroupData>(context);
    final BorderRadius base = theme.borderRadiusMd;
    if (group == null) {
      return base;
    }
    return group.apply(base, Directionality.of(context));
  }
}

/// Size-table metrics with density-scaled padding.
class _ButtonSizeMetrics {
  const _ButtonSizeMetrics({
    required this.padding,
    required this.minHeight,
    this.minWidth = 0,
    this.textStyle,
  });

  final EdgeInsetsGeometry padding;
  final double minHeight;
  final double minWidth;
  final TextStyle? textStyle;
}

/// Border-box helper: `metrics` minima are totals, but the `Clickable`
/// padding wraps the `ConstrainedBox`, so the inner minimum subtracts the
/// resolved padding (e.g. an icon button with 36px total and zero padding
/// keeps a 36px inner minimum; a themed vertical padding does not stack).
double _innerMin(
  double total,
  EdgeInsetsGeometry padding,
  BuildContext context,
  bool horizontal,
) {
  final EdgeInsets resolved = padding.resolve(Directionality.of(context));
  final double used = horizontal
      ? resolved.left + resolved.right
      : resolved.top + resolved.bottom;
  return (total - used).clamp(0, double.infinity).toDouble();
}

/// Design §1.3 size table, corrected to shadcn/ui (new-york, default
/// density): heights are border-box totals (h-7/h-8/h-9/h-10 = 28/32/36/40),
/// horizontal padding is px-2/px-3/px-4/px-6 (8/12/16/24). Vertical padding
/// is zero: the `Clickable` padding wraps the `ConstrainedBox`, so any
/// vertical padding would stack on top of `minHeight` (52 instead of 36 for
/// md). Height comes from `minHeight` + centering; all sizes use 14px w500.
_ButtonSizeMetrics _buttonMetricsFor(ButtonSize size, Density density) {
  final double scale =
      density.baseContentPadding / Density.defaultDensity.baseContentPadding;
  EdgeInsetsGeometry pad(double horizontal) {
    return EdgeInsets.symmetric(horizontal: horizontal * scale);
  }

  const TextStyle text = buttonDefaultTextStyle;

  return switch (size) {
    ButtonSize.xs => _ButtonSizeMetrics(
      padding: pad(8),
      minHeight: 28,
      textStyle: text,
    ),
    ButtonSize.sm => _ButtonSizeMetrics(
      padding: pad(12),
      minHeight: 32,
      textStyle: text,
    ),
    ButtonSize.md => _ButtonSizeMetrics(
      padding: pad(16),
      minHeight: 36,
      textStyle: text,
    ),
    ButtonSize.lg => _ButtonSizeMetrics(
      padding: pad(24),
      minHeight: 40,
      textStyle: text,
    ),
    ButtonSize.icon => const _ButtonSizeMetrics(
      padding: EdgeInsets.zero,
      minHeight: 36,
      minWidth: 36,
    ),
  };
}
