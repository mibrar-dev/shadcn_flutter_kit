// The shared toast exit animation: fade + slide (optionally collapse) before
// the queue removes the entry.
//
// Used by both `toast` and `gooey_toast` so a dismissed toast leaves the same
// way everywhere, and so removal stays in the queue: the entry's exiting state
// is the single source of truth, this widget only presents it.

import 'package:flutter/widgets.dart';

import 'toast_entry.dart';
import 'toast_placement.dart';
import 'toast_queue.dart';

/// Exit animation duration used by both toast components.
const Duration kToastExitDuration = Duration(milliseconds: 200);

/// The ordered column of one toast slot: the newest entry sits nearest the
/// anchor, each unit carries its own gap (so a collapse takes the gap with it)
/// and is wrapped in a [ToastExitTransition].
class ToastSlotColumn<T> extends StatelessWidget {
  /// Creates a slot column.
  const ToastSlotColumn({
    super.key,
    required this.queue,
    required this.entries,
    required this.placement,
    required this.cardBuilder,
    this.gap = 8,
    this.collapse = false,
  });

  /// Queue that owns the entries.
  final ToastQueue<T> queue;

  /// Live entries of the slot.
  final List<ToastEntry<T>> entries;

  /// Where the slot is anchored.
  final ToastPlacement placement;

  /// Builds one card; the exit transition and gap are added here.
  final Widget Function(BuildContext context, ToastEntry<T> entry) cardBuilder;

  /// Gap between stacked cards.
  final double gap;

  /// Whether exiting cards also collapse their vertical extent.
  final bool collapse;

  @override
  Widget build(BuildContext context) {
    final List<ToastEntry<T>> ordered = placement.isTop
        ? entries
        : entries.reversed.toList(growable: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: placement.isTop
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: placement.isCenter
          ? CrossAxisAlignment.center
          : (placement.isLeading
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end),
      children: <Widget>[
        for (var i = 0; i < ordered.length; i++)
          ToastExitTransition<T>(
            key: ValueKey<String>(ordered[i].id),
            queue: queue,
            entry: ordered[i],
            direction: placement.exitDirection,
            collapse: collapse,
            child: Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : gap),
              child: cardBuilder(context, ordered[i]),
            ),
          ),
      ],
    );
  }
}

/// How far the toast slides towards its dismiss direction, in child fractions.
const double _kExitSlide = 0.3;

/// Plays the exit animation of [entry] and removes it from [queue] when done.
///
/// While [entry] is not exiting this is a pass-through. When it becomes
/// exiting (see [ToastQueue.dismiss]) the child fades and slides towards
/// [direction]; with [collapse] it also shrinks its vertical extent so the
/// siblings animate into the freed space. On completion the entry is removed
/// through [ToastQueue.remove].
///
/// [MediaQuery.disableAnimations] skips the animation and removes the entry
/// after the current frame.
class ToastExitTransition<T> extends StatefulWidget {
  /// Creates an exit transition around [child].
  const ToastExitTransition({
    super.key,
    required this.queue,
    required this.entry,
    required this.direction,
    required this.child,
    this.collapse = false,
    this.duration = kToastExitDuration,
  });

  /// Queue that owns [entry].
  final ToastQueue<T> queue;

  /// Entry whose exit phase drives the animation.
  final ToastEntry<T> entry;

  /// Direction the toast leaves towards.
  final ToastSwipeDirection direction;

  /// Toast content.
  final Widget child;

  /// Whether the child also collapses its vertical extent while leaving.
  final bool collapse;

  /// Exit animation duration.
  final Duration duration;

  @override
  State<ToastExitTransition<T>> createState() => _ToastExitTransitionState<T>();
}

class _ToastExitTransitionState<T> extends State<ToastExitTransition<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _started = false;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.addStatusListener(_onStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeStart();
  }

  @override
  void didUpdateWidget(covariant ToastExitTransition<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeStart();
  }

  void _maybeStart() {
    if (_started || !widget.entry.isExiting) {
      return;
    }
    _started = true;
    final bool instant = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _controller.duration = instant ? Duration.zero : widget.duration;
    _controller.forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _removed) {
      return;
    }
    _removed = true;
    // Removing notifies the queue, so it must not happen during build/layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.queue.remove(widget.entry.id);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  Offset get _slideTarget => switch (widget.direction) {
    ToastSwipeDirection.up => const Offset(0, -_kExitSlide),
    ToastSwipeDirection.down => const Offset(0, _kExitSlide),
    ToastSwipeDirection.left => const Offset(-_kExitSlide, 0),
    ToastSwipeDirection.right => const Offset(_kExitSlide, 0),
  };

  @override
  Widget build(BuildContext context) {
    if (!widget.entry.isExiting) {
      return widget.child;
    }
    Widget child = FadeTransition(
      opacity: ReverseAnimation(_progress),
      child: widget.child,
    );
    child = SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: _slideTarget,
      ).animate(_progress),
      child: child,
    );
    if (widget.collapse) {
      child = SizeTransition(
        axis: Axis.vertical,
        sizeFactor: Tween<double>(begin: 1, end: 0).animate(_progress),
        axisAlignment: widget.direction == ToastSwipeDirection.up ? -1 : 1,
        child: child,
      );
    }
    return IgnorePointer(child: child);
  }
}
