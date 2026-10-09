// Directional swipe-to-dismiss wrapper for gooey surfaces.
//
// Replaces the old `_GooeyToastSwipeDismissRegion`, which tracked raw global
// pointer positions; this version follows the accepted `toast` component:
// local pan deltas, animated slide feedback and velocity support.

import 'package:flutter/widgets.dart';

import '../toast_queue/toast_placement.dart';

/// Dismiss velocity that counts as a fling regardless of distance.
const double kGooeySwipeVelocity = 800;

/// Wraps [child] with a directional swipe-to-dismiss gesture.
class GooeySwipe extends StatefulWidget {
  /// Creates a swipe wrapper.
  const GooeySwipe({
    super.key,
    required this.child,
    required this.directions,
    required this.onDismissed,
    this.threshold = 72,
  });

  /// Wrapped surface.
  final Widget child;

  /// Directions that trigger the dismissal.
  final Set<ToastSwipeDirection> directions;

  /// Called once when a valid dismiss drag or fling ends.
  final VoidCallback onDismissed;

  /// Minimum drag distance in logical px.
  final double threshold;

  @override
  State<GooeySwipe> createState() => _GooeySwipeState();
}

class _GooeySwipeState extends State<GooeySwipe> {
  Offset _drag = Offset.zero;
  bool _dragging = false;

  void _onPanUpdate(DragUpdateDetails details) {
    _dragging = true;
    final bool horizontal =
        widget.directions.contains(ToastSwipeDirection.left) ||
        widget.directions.contains(ToastSwipeDirection.right);
    final bool vertical =
        widget.directions.contains(ToastSwipeDirection.up) ||
        widget.directions.contains(ToastSwipeDirection.down);
    setState(() {
      _drag = Offset(
        horizontal ? _drag.dx + details.delta.dx : 0,
        vertical ? _drag.dy + details.delta.dy : 0,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final double dx = _drag.dx;
    final double dy = _drag.dy;
    final bool horizontal = dx.abs() >= dy.abs();
    final double distance = horizontal ? dx.abs() : dy.abs();
    final double velocity = horizontal
        ? details.velocity.pixelsPerSecond.dx.abs()
        : details.velocity.pixelsPerSecond.dy.abs();
    final ToastSwipeDirection direction = horizontal
        ? (dx >= 0 ? ToastSwipeDirection.right : ToastSwipeDirection.left)
        : (dy >= 0 ? ToastSwipeDirection.down : ToastSwipeDirection.up);
    _dragging = false;
    if (widget.directions.contains(direction) &&
        (distance >= widget.threshold || velocity >= kGooeySwipeVelocity)) {
      widget.onDismissed();
      return;
    }
    setState(() => _drag = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedSlide(
        duration: _dragging ? Duration.zero : const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        offset: Offset(_drag.dx / 300, _drag.dy / 200),
        child: widget.child,
      ),
    );
  }
}
