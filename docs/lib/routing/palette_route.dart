// The command-palette overlay route (mockup 09).
//
// Lives next to the router that pushes it: the palette is a root-level
// overlay owned by [DocsRouterDelegate], not a URL route.

import 'package:flutter/widgets.dart';

import '../motion/ease.dart';

/// The root-level palette overlay route.
///
/// Scrim fades 150ms; the panel scales .97→1 + fades 200ms with ease-out-expo
/// and exits ease-in 150ms (motion spec). Reduced motion keeps the fade only,
/// capped at 150ms.
class DocsPaletteRoute extends PageRoute<void> {
  /// Creates the palette route.
  DocsPaletteRoute({required this.builder, this.reduceMotion = false})
    : super(barrierDismissible: true);

  /// Builds the palette panel.
  final WidgetBuilder builder;

  /// When true: opacity-only, ≤150ms.
  final bool reduceMotion;

  @override
  String? get barrierLabel => 'Command palette';

  @override
  Color? get barrierColor => const Color(0x8C000000);

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      reduceMotion ? kDurationFast : kDurationPage;

  @override
  Duration get reverseTransitionDuration => kDurationFast;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Animation<double> curved = CurvedAnimation(
      parent: animation,
      curve: kEaseOutExpo,
      reverseCurve: kEaseIn,
    );
    if (reduceMotion) {
      return FadeTransition(opacity: curved, child: child);
    }
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
        child: child,
      ),
    );
  }
}
