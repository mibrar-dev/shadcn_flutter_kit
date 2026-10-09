// The `media_query` component: shows one child when the viewport width is
// inside a range and another when it is not.
//
// Ported from `components/layout/media_query/**`. The old module was two
// `part`s behind a barrel with a a suppress-all-lints pragma, resolved only
// two of the four theme legs, and its `copyWith` silently dropped the
// density/spacing/shadow fields of `ComponentThemeData`.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'media_query_style.dart';

export 'media_query_style.dart';

/// Width-driven child switching.
///
/// ```dart
/// MediaQueryVisibility(
///   minWidth: 768,
///   alternateChild: const MobileNav(),
///   child: const DesktopNav(),
/// )
/// ```
///
/// Both bounds are optional: with neither the child always shows. An
/// out-of-range viewport renders [alternateChild] when it is given, and a
/// zero-size box otherwise, so the widget never reserves layout space for
/// content it is not showing.
class MediaQueryVisibility extends StatelessWidget {
  /// Creates a width-responsive child switch.
  const MediaQueryVisibility({
    super.key,
    this.minWidth,
    this.maxWidth,
    required this.child,
    this.alternateChild,
    this.theme,
  });

  /// Narrowest viewport width (inclusive) that shows [child].
  final double? minWidth;

  /// Widest viewport width (inclusive) that shows [child].
  final double? maxWidth;

  /// Shown while the viewport width is inside the range.
  final Widget child;

  /// Shown while the viewport width is outside the range; null collapses the
  /// box instead.
  final Widget? alternateChild;

  /// Widget-leg theme override, merged on top of the other legs.
  final MediaQueryVisibilityTheme? theme;

  @override
  Widget build(BuildContext context) {
    final MediaQueryVisibilityTheme resolved =
        resolveComponentStyle<
          MediaQueryVisibilityTheme,
          MediaQueryVisibilityTheme
        >(
          context,
          widget: theme,
          select: (t) => t,
          defaults: mediaQueryVisibilityDefaults,
        );
    final double? min = minWidth ?? resolved.minWidth;
    final double? max = maxWidth ?? resolved.maxWidth;
    final double width = MediaQuery.sizeOf(context).width;
    final bool inside =
        (min == null || width >= min) && (max == null || width <= max);
    if (inside) {
      return child;
    }
    return alternateChild ?? const SizedBox.shrink();
  }
}
