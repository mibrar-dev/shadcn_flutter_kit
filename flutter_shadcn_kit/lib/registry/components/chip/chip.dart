// The `chip` component: [Chip], a compact deletable-token control, and
// [ChipButton], the borderless inner control (the remove "x", the expand
// caret) that `chip_input`, `select` and `filter_bar` embed.
//
// A chip is a button row with chip metrics: it reuses the `button` component's
// `ButtonVariantStyle` table for the per-state paint and `Clickable` for
// interaction, but builds its own (much smaller) box so a read-only chip is a
// static token instead of a dimmed, clickable button.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'chip_style.dart';

export 'chip_style.dart';

/// Cursor for a pressable chip; the system arrow for a static one.
const _chipMouseCursor = StateValue<MouseCursor>(
  rest: SystemMouseCursors.click,
  disabled: SystemMouseCursors.basic,
);

/// A compact button shaped like a shadcn chip (`px-2 py-0.5 text-xs`).
///
/// Without [onPressed] the chip is a static token: it paints the variant's
/// colours at full strength and never enters the focus tree. The old widget
/// passed `onPressed ?? () {}`, so a read-only chip was an enabled button that
/// swallowed taps and showed its hover/press rows.
class Chip extends StatelessWidget {
  /// Creates a chip.
  const Chip({
    super.key,
    required this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.variant,
    this.padding,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  });

  /// Chip content, usually a `Text`.
  final Widget child;

  /// Turns the chip into a press target when provided.
  final VoidCallback? onPressed;

  /// Widget shown before [child].
  final Widget? leading;

  /// Widget shown after [child].
  final Widget? trailing;

  /// Button variant override; null resolves `ChipTheme.variant`.
  final ButtonVariant? variant;

  /// Padding override; null resolves `ChipTheme.padding`.
  final EdgeInsetsGeometry? padding;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Focus node of a pressable chip; ignored when [onPressed] is null.
  final FocusNode? focusNode;

  /// Whether a pressable chip requests focus when first built.
  final bool autofocus;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final ChipTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ChipTheme style = resolveComponentStyle<ChipTheme, ChipTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: chipDefaults,
    );
    final ButtonVariant buttonVariant =
        variant ?? style.variant ?? chipDefaults.variant!;
    // The chip's own metrics are the widget leg; the variant's button style is
    // the base, so an app override can restyle colours without losing padding.
    final ButtonVariantStyle chipLeg = ButtonVariantStyle(
      padding: padding ?? style.padding ?? chipDefaultPadding,
      textStyle: style.textStyle ?? chipDefaultTextStyle,
    ).merge(style.style);
    final ButtonVariantStyle resolved = chipLeg.merge(
      buttonDefaults.forVariant(buttonVariant),
    );
    final bool interactive = onPressed != null;

    Color? colorFor(StateValue<ThemedColor>? value, Set<WidgetState> states) =>
        value?.resolve(states)?.resolve(ambient.colors);

    BoxDecoration decorationFor(Set<WidgetState> states) {
      final Color? background = colorFor(resolved.background, states);
      final Color? border = colorFor(resolved.borderColor, states);
      final double width = resolved.borderWidth ?? 0;
      return BoxDecoration(
        color: background,
        border: border == null || width <= 0
            ? null
            : Border.all(color: border, width: width),
        borderRadius: ambient.borderRadiusMd,
      );
    }

    TextStyle textStyleFor(Set<WidgetState> states) =>
        (resolved.textStyle ?? chipDefaultTextStyle).copyWith(
          color: colorFor(resolved.foreground, states),
          decoration: resolved.decoration?.resolve(states),
        );

    IconThemeData iconThemeFor(Set<WidgetState> states) {
      final Color? color = colorFor(resolved.foreground, states);
      return IconThemeData(color: color, size: style.buttonIconSize);
    }

    Widget content = Padding(
      padding: resolved.padding ?? chipDefaultPadding,
      child: child,
    );
    if (leading != null || trailing != null) {
      final double gap = ambient.spacing.sm;
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          content,
          if (leading != null) ...<Widget>[Gap(gap), leading!],
          if (trailing != null) ...<Widget>[Gap(gap), trailing!],
        ],
      );
    }

    if (!interactive) {
      return DecoratedBox(
        decoration: decorationFor(const <WidgetState>{}),
        child: DefaultTextStyle.merge(
          style: textStyleFor(const <WidgetState>{}),
          child: IconTheme.merge(
            data: iconThemeFor(const <WidgetState>{}),
            child: content,
          ),
        ),
      );
    }

    return Clickable(
      onPressed: onPressed,
      onHover: onHover,
      onFocus: onFocusChange,
      focusNode: focusNode,
      decoration: WidgetStateProperty.resolveWith(decorationFor),
      textStyle: WidgetStateProperty.resolveWith(textStyleFor),
      iconTheme: WidgetStateProperty.resolveWith(iconThemeFor),
      mouseCursor: _chipMouseCursor,
      child: content,
    );
  }
}

/// The borderless control embedded in a [Chip] (remove, expand, clear).
///
/// It renders the `ghost` button row with no padding, so it lines up with the
/// chip's content and shows no fill until it is hovered.
class ChipButton extends StatelessWidget {
  /// Creates an inner chip control.
  const ChipButton({
    super.key,
    required this.child,
    this.onPressed,
    this.iconSize,
    this.focusNode,
    this.autofocus = false,
    this.theme,
  });

  /// Control content, usually an `Icon`.
  final Widget child;

  /// Called on tap; null makes the control static.
  final VoidCallback? onPressed;

  /// Icon size override; null resolves `ChipTheme.buttonIconSize`.
  final double? iconSize;

  /// Focus node; ignored when [onPressed] is null.
  final FocusNode? focusNode;

  /// Whether the control requests focus when first built.
  final bool autofocus;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final ChipTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ChipTheme style = resolveComponentStyle<ChipTheme, ChipTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: chipDefaults,
    );
    final ButtonVariantStyle resolved = const ButtonVariantStyle(
      padding: chipButtonDefaultPadding,
    ).merge(buttonDefaults.forVariant(ButtonVariant.ghost));
    final bool interactive = onPressed != null;
    final double size =
        iconSize ?? style.buttonIconSize ?? chipButtonDefaultIconSize;

    Color? colorFor(StateValue<ThemedColor>? value, Set<WidgetState> states) =>
        value?.resolve(states)?.resolve(ambient.colors);

    BoxDecoration decorationFor(Set<WidgetState> states) => BoxDecoration(
      color: colorFor(resolved.background, states),
      borderRadius: ambient.borderRadiusMd,
    );

    Color? colorOf(Set<WidgetState> states) =>
        colorFor(resolved.foreground, states);

    final Widget content = Padding(
      padding: resolved.padding ?? chipButtonDefaultPadding,
      child: IconTheme.merge(
        data: IconThemeData(color: colorOf(const <WidgetState>{}), size: size),
        child: child,
      ),
    );

    if (!interactive) {
      return DecoratedBox(
        decoration: decorationFor(const <WidgetState>{}),
        child: content,
      );
    }

    return Clickable(
      onPressed: onPressed,
      focusNode: focusNode,
      decoration: WidgetStateProperty.resolveWith(decorationFor),
      iconTheme: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) =>
            IconThemeData(color: colorOf(states), size: size),
      ),
      mouseCursor: _chipMouseCursor,
      child: content,
    );
  }
}
