// The command-palette overlay route (mockup 09).
//
// Lives next to the router that pushes it: the palette is a root-level
// overlay owned by [DocsRouterDelegate], not a URL route.

import 'package:flutter/widgets.dart';

import '../motion/ease.dart';

/// The root-level palette overlay route.
///
/// The reference palette has **no scrim** (`<DialogOverlay/>` is commented
/// out): the transparent barrier below only catches outside taps. The panel
/// scales .97→1 + fades 200ms `ease` and exits ease-in 150ms (spec §2.8).
/// Reduced motion keeps a fade capped at 150ms.
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

  /// No dimming; the barrier exists so an outside tap still closes the panel.
  @override
  Color? get barrierColor => const Color(0x00000000);

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      reduceMotion ? kDurationFast : kDurationPalette;

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
      curve: kEaseStandard,
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
