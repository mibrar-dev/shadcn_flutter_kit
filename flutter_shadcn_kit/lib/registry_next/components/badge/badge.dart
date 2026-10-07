// The `badge` component: [Badge], a small rounded label (or a status dot) with
// four variants.
//
// The four old wrapper classes (`PrimaryBadge`, `SecondaryBadge`,
// `OutlineBadge`, `DestructiveBadge`) collapse into one widget with a
// `variant` enum (PLAN §4 rule 1). Interaction lives in the `Clickable`
// primitive, so a static badge stays out of the focus tree; the widget does
// not import the `button` component.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'badge_style.dart';

export 'badge_style.dart';

/// Diameter of the dot drawn when [Badge.showAsDot] is true (shadcn
/// `size-2.5 rounded-full`).
const double badgeDotSize = 6;

/// Cursor of a pressable badge.
const MouseCursor _badgeMouseCursor = SystemMouseCursors.click;

/// A small rounded label used for status, counts and categories.
///
/// Non-interactive by default: without [onPressed] the badge paints a plain
/// surface and never enters the focus tree. The old badges were always
/// `enabled: true` buttons wrapped in `ExcludeFocus`, so even a static badge
/// showed hover/press styling and swallowed a pointer click with no handler.
class Badge extends StatelessWidget {
  /// Creates a badge.
  const Badge({
    super.key,
    required this.child,
    this.variant = BadgeVariant.primary,
    this.leading,
    this.trailing,
    this.onPressed,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.showAsDot = false,
    this.theme,
  }) : assert(
         !showAsDot || (leading == null && trailing == null),
         'A dot badge takes no child, leading or trailing content',
       );

  /// Badge content. Ignored when [showAsDot] is true.
  final Widget child;

  /// Visual variant. Defaults to [BadgeVariant.primary].
  final BadgeVariant variant;

  /// Widget shown before [child].
  final Widget? leading;

  /// Widget shown after [child].
  final Widget? trailing;

  /// Turns the badge into a press target when provided.
  final VoidCallback? onPressed;

  /// Called when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Focus node of a pressable badge; ignored when [onPressed] is null.
  final FocusNode? focusNode;

  /// Whether a pressable badge requests focus when first built.
  final bool autofocus;

  /// Draws a fixed-size dot instead of [child] (shadcn `showAsDot`).
  final bool showAsDot;

  /// Widget-leg style override, merged over the component/app/defaults.
  final BadgeStyle? theme;

  /// Whether this badge reacts to input.
  bool get isInteractive => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final BadgeTheme container = resolveComponentStyle<BadgeTheme, BadgeTheme>(
      context,
      select: (t) => t,
      defaults: badgeDefaults,
    );
    final BadgeStyle resolved = (theme ?? const BadgeStyle()).merge(
      container.forVariant(variant),
    );
    final TextStyle textStyle =
        resolved.textStyle ?? container.textStyle ?? badgeDefaultTextStyle;
    final EdgeInsetsGeometry padding = resolved.padding ?? badgeDefaultPadding;
    final double iconSize = resolved.iconSize ?? 12;
    final double gap = ambient.spacing.sm;

    Color? colorFor(StateValue<ThemedColor>? value, Set<WidgetState> states) =>
        value?.resolve(states)?.resolve(ambient.colors);

    // A dot is always round and never bordered; shadcn paints it from the
    // variant fill alone.
    BoxDecoration dotDecoration(Set<WidgetState> states) => BoxDecoration(
      color: colorFor(resolved.background, states),
      shape: BoxShape.circle,
    );

    BoxDecoration decorationFor(Set<WidgetState> states) {
      final Color? borderColor = colorFor(resolved.borderColor, states);
      final double width = resolved.borderWidth ?? 0;
      return BoxDecoration(
        color: colorFor(resolved.background, states),
        border: borderColor != null && width > 0
            ? Border.all(color: borderColor, width: width)
            : null,
        borderRadius: ambient.borderRadiusMd,
      );
    }

    TextStyle labelStyleFor(Set<WidgetState> states) =>
        textStyle.copyWith(color: colorFor(resolved.foreground, states));

    IconThemeData iconThemeFor(Set<WidgetState> states) {
      final Color? color = colorFor(resolved.foreground, states);
      return IconThemeData(color: color, size: iconSize);
    }

    if (showAsDot) {
      final Widget dot = DecoratedBox(
        decoration: dotDecoration(const <WidgetState>{}),
        child: SizedBox.fromSize(size: const Size.square(badgeDotSize)),
      );
      if (!isInteractive) {
        return dot;
      }
      return Clickable(
        onPressed: onPressed,
        onHover: onHover,
        onFocus: onFocusChange,
        focusNode: focusNode,
        mouseCursor: const WidgetStatePropertyAll<MouseCursor?>(
          _badgeMouseCursor,
        ),
        decoration: WidgetStateProperty.resolveWith(dotDecoration),
        child: dot,
      );
    }

    Widget content = Padding(padding: padding, child: child);
    if (leading != null || trailing != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ?leading,
          if (leading != null) Gap(gap),
          content,
          if (trailing != null) Gap(gap),
          ?trailing,
        ],
      );
    }

    if (!isInteractive) {
      return DecoratedBox(
        decoration: decorationFor(const <WidgetState>{}),
        child: content,
      );
    }

    return Clickable(
      onPressed: onPressed,
      onHover: onHover,
      onFocus: onFocusChange,
      focusNode: focusNode,
      mouseCursor: const WidgetStatePropertyAll<MouseCursor?>(
        _badgeMouseCursor,
      ),
      decoration: WidgetStateProperty.resolveWith(decorationFor),
      textStyle: WidgetStateProperty.resolveWith(labelStyleFor),
      iconTheme: WidgetStateProperty.resolveWith(iconThemeFor),
      child: content,
    );
  }
}
