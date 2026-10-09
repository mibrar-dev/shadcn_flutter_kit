// The `breadcrumb` component: a horizontal trail of crumbs with a separator
// between each pair.
//
// Ported from `components/navigation/breadcrumb`. The old tree wrapped each
// crumb in `shared/primitives/text` modifiers (`.medium()`, `.small()`,
// `.muted()`, `.foreground()`); those now come from `primitives/text`. The
// default separator is the shadcn chevron; a slash separator is provided too.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/theme.dart';
import 'breadcrumb_style.dart';

export 'breadcrumb_style.dart';

/// A horizontal breadcrumb trail, scrollable when it overflows.
///
/// The last crumb is drawn in the body foreground; every earlier crumb and the
/// separators use the muted foreground.
///
/// ```dart
/// const Breadcrumb(
///   children: <Widget>[
///     Text('Home'),
///     Text('Settings'),
///     Text('Profile'),
///   ],
/// );
/// ```
class Breadcrumb extends StatelessWidget {
  /// Creates a breadcrumb trail.
  const Breadcrumb({
    super.key,
    required this.children,
    this.separator,
    this.padding,
    this.theme,
  });

  /// Chevron separator (the shadcn default).
  static const Widget arrowSeparator = _BreadcrumbArrowSeparator();

  /// Slash separator.
  static const Widget slashSeparator = _BreadcrumbSlashSeparator();

  /// Crumbs, ordered from root to the current location.
  final List<Widget> children;

  /// Separator override; null resolves [BreadcrumbTheme.separator] and then
  /// [arrowSeparator].
  final Widget? separator;

  /// Padding around the strip; null resolves [BreadcrumbTheme.padding].
  final EdgeInsetsGeometry? padding;

  /// Widget-leg theme override, merged on top of the other legs.
  final BreadcrumbTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final BreadcrumbTheme style =
        resolveComponentStyle<BreadcrumbTheme, BreadcrumbTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: breadcrumbDefaults,
        );
    final Widget effectiveSeparator =
        separator ?? style.separator ?? arrowSeparator;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? style.padding ?? EdgeInsets.zero;
    final double spacing = (style.spacing ?? 6) * ambient.scaling;

    final List<Widget> row = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        row
          ..add(SizedBox(width: spacing))
          ..add(effectiveSeparator)
          ..add(SizedBox(width: spacing));
      }
      row.add(_crumb(children[i], isLast: i == children.length - 1));
    }

    return ScrollConfiguration(
      // A breadcrumb is not a scroll surface: hide the scrollbar chrome.
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: effectivePadding,
          child: Row(mainAxisSize: MainAxisSize.min, children: row).small.muted,
        ),
      ),
    );
  }

  /// Styles one crumb: medium weight, foreground only for the current one.
  Widget _crumb(Widget child, {required bool isLast}) {
    final Widget styled = child.medium;
    return isLast ? styled.foreground : styled;
  }
}

/// The default chevron separator, coloured with `mutedForeground`.
class _BreadcrumbArrowSeparator extends StatelessWidget {
  const _BreadcrumbArrowSeparator();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double size = 12 * theme.scaling;
    return SizedBox.square(
      dimension: size,
      child: Icon(
        LucideIcons.chevronRight,
        size: size,
        color: theme.colors.mutedForeground,
      ),
    );
  }
}

/// The `/` separator, coloured with `mutedForeground`.
class _BreadcrumbSlashSeparator extends StatelessWidget {
  const _BreadcrumbSlashSeparator();

  @override
  Widget build(BuildContext context) {
    return const Text('/').small.muted;
  }
}
