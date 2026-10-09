// Static gradient masks over a scrollable edge (spec: `scroll-fade`).
//
// The reference paints a 1px-transition mask at the scroll edges of the
// sidebar, TOC and horizontal tables. This widget is a static paint (no
// animation, no timers): the gradient simply covers the edge of [child].

import 'package:flutter/widgets.dart';

import '../ui/shadcn/theme/theme.dart';

/// Paints background-to-transparent gradients over the scroll edges of
/// [child].
class ScrollFade extends StatelessWidget {
  /// Wraps [child] with optional top/bottom edge fades.
  const ScrollFade({
    super.key,
    required this.child,
    this.fadeTop = true,
    this.fadeBottom = true,
    this.fadeSize = 24,
    this.color,
  });

  /// The scrollable subtree.
  final Widget child;

  /// Whether to fade the top edge.
  final bool fadeTop;

  /// Whether to fade the bottom edge.
  final bool fadeBottom;

  /// Length of each gradient.
  final double fadeSize;

  /// Gradient base colour; defaults to the page background.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color base = color ?? ShadcnTheme.of(context).colors.background;
    return Stack(
      children: <Widget>[
        child,
        if (fadeTop)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: fadeSize,
            child: _Fade(base: base, fromTop: true),
          ),
        if (fadeBottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fadeSize,
            child: _Fade(base: base, fromTop: false),
          ),
      ],
    );
  }
}

class _Fade extends StatelessWidget {
  const _Fade({required this.base, required this.fromTop});

  final Color base;
  final bool fromTop;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
            end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
            colors: <Color>[base, base.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
