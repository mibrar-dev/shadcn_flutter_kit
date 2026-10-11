// A focusable list row for `SubFocus`-navigated lists (command palettes,
// menus, select popups).
//
// Extracted from the old `command` component's `CommandItem` so the row
// machinery is shared by every keyboard-navigable list instead of living in
// one component; `SubFocus`'s own documentation already scopes the mechanism
// to "menus, command palettes and similar keyboard-navigable lists".
//
// The row is presentational: it reads the ambient tokens for its default
// colours and accepts per-call overrides for component themes.

import 'package:flutter/widgets.dart';

import '../foundation/gap.dart';
import '../theme/theme.dart';
import 'clickable.dart';
import 'subfocus_item.dart';

/// One selectable row inside a [SubFocus] list.
///
/// Hovering requests sub-focus; the row paints the highlight colour while
/// focused. A row without [onTap] (or with `enabled: false`) is rendered
/// read-only: no tap target, no hover, dimmed at half opacity.
class SubFocusListItem extends StatelessWidget {
  /// Creates a focusable list row.
  const SubFocusListItem({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
    this.enabled,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.borderRadius,
    this.highlightColor,
    this.highlightedForeground,
    this.foreground,
  });

  /// Widget shown before [title].
  final Widget? leading;

  /// Primary row content.
  final Widget title;

  /// Widget shown after [title].
  final Widget? trailing;

  /// Called when the row is activated; null renders it read-only.
  final VoidCallback? onTap;

  /// Overrides the enabled state; null means `onTap != null`.
  final bool? enabled;

  /// Padding around the row.
  final EdgeInsetsGeometry padding;

  /// Highlight corner radius; null falls back to `theme.borderRadiusSm`.
  final BorderRadius? borderRadius;

  /// Background while focused; null falls back to the `accent` token.
  final Color? highlightColor;

  /// Text/icon colour while focused; null falls back to `accentForeground`.
  final Color? highlightedForeground;

  /// Text/icon colour while not focused; null falls back to `foreground`.
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final bool isEnabled = enabled ?? (onTap != null);
    final Color highlight = highlightColor ?? theme.colors.accent;
    final Color onHighlight =
        highlightedForeground ?? theme.colors.accentForeground;
    final Color base = foreground ?? theme.colors.foreground;
    final BorderRadius radius = borderRadius ?? theme.borderRadiusSm;

    Widget row(Color color) {
      final double gap = theme.spacing.sm;
      return IconTheme.merge(
        data: IconThemeData(color: color, size: 16),
        child: DefaultTextStyle.merge(
          style: theme.typography.small.copyWith(color: color),
          child: Row(
            children: <Widget>[
              ?leading,
              if (leading != null) Gap(gap),
              Expanded(child: title),
              if (trailing != null) Gap(gap),
              ?trailing,
            ],
          ),
        ),
      );
    }

    if (!isEnabled) {
      return Opacity(
        opacity: 0.5,
        child: Padding(padding: padding, child: row(base)),
      );
    }

    return Actions(
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            onTap?.call();
            return null;
          },
        ),
      },
      child: SubFocus(
        builder: (context, focus) {
          final Color color = focus.isFocused ? onHighlight : base;
          return Clickable(
            onPressed: onTap,
            onHover: (hovered) {
              if (hovered) {
                focus.requestFocus();
              }
            },
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
            decoration: WidgetStatePropertyAll<Decoration>(
              BoxDecoration(
                color: focus.isFocused
                    ? highlight
                    : highlight.withValues(alpha: 0),
                borderRadius: radius,
              ),
            ),
            child: row(color),
          );
        },
      ),
    );
  }
}
