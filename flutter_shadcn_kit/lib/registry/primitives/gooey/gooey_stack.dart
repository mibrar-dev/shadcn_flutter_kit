// An anchored stack of gooey surfaces over a [ToastQueue].
//
// Owns the presentation-free queue's slot reconciliation (the documented
// auto-dismiss policy: non-primary toasts in a stacked slot pause) and the
// edge anchoring, so the `gooey_toast` component only supplies the card
// builder.

import 'package:flutter/widgets.dart';

import '../toast_queue/toast_entry.dart';
import '../toast_queue/toast_exit.dart';
import '../toast_queue/toast_placement.dart';
import '../toast_queue/toast_queue.dart';

/// Hosts a [ToastQueue]'s entries as gooey surfaces anchored to screen edges.
///
/// Entries are positioned per [ToastSlot.placement]: top/bottom edge plus a
/// leading/center/trailing alignment, stacked away from the anchor with
/// [gap] between items. The newest entry of a placement sits nearest the edge.
class GooeyStack<T> extends StatefulWidget {
  /// Creates a gooey stack.
  const GooeyStack({
    super.key,
    required this.queue,
    required this.builder,
    required this.child,
    this.anchorInset = 16,
    this.gap = 8,
  });

  /// The queue driving the stack.
  final ToastQueue<T> queue;

  /// Builds one surface; [index] is its position within its placement.
  final Widget Function(BuildContext context, ToastEntry<T> entry, int index)
  builder;

  /// Content below the surfaces.
  final Widget child;

  /// Distance from the screen edge in logical px.
  final double anchorInset;

  /// Distance between stacked surfaces in logical px.
  final double gap;

  @override
  State<GooeyStack<T>> createState() => _GooeyStackState<T>();
}

class _GooeyStackState<T> extends State<GooeyStack<T>> {
  final Map<ToastSlot, int> _slotCounts = <ToastSlot, int>{};

  @override
  void initState() {
    super.initState();
    widget.queue.addListener(_reconcileSlots);
  }

  @override
  void didUpdateWidget(covariant GooeyStack<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queue == widget.queue) {
      return;
    }
    oldWidget.queue.removeListener(_reconcileSlots);
    _slotCounts.clear();
    widget.queue.addListener(_reconcileSlots);
  }

  @override
  void dispose() {
    widget.queue.removeListener(_reconcileSlots);
    super.dispose();
  }

  void _reconcileSlots() {
    for (final ToastPlacement placement in ToastPlacement.values) {
      final ToastSlot slot = ToastSlot(placement);
      final List<ToastEntry<T>> live = widget.queue
          .entriesIn(slot)
          .where((ToastEntry<T> entry) => !entry.isExiting)
          .toList(growable: false);
      final int previous = _slotCounts[slot] ?? 0;
      _slotCounts[slot] = live.length;
      if (live.length > 1) {
        widget.queue.pauseSlot(
          slot,
          selector: (ToastEntry<T> entry) => entry.id != live.first.id,
        );
      } else if (previous > 1) {
        widget.queue.resumeSlot(slot);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.queue,
      builder: (BuildContext context, Widget? child) {
        final List<ToastEntry<T>> entries = widget.queue.entries;
        if (entries.isEmpty) {
          return widget.child;
        }
        final Map<ToastPlacement, int> counts = <ToastPlacement, int>{};
        return Stack(
          children: <Widget>[
            widget.child,
            for (final ToastEntry<T> entry in entries)
              _positioned(
                context,
                entry,
                counts.update(
                  entry.slot.placement,
                  (int value) => value + 1,
                  ifAbsent: () => 0,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _positioned(BuildContext context, ToastEntry<T> entry, int index) {
    final ToastPlacement placement = entry.slot.placement;
    final MediaQueryData? media = MediaQuery.maybeOf(context);
    final EdgeInsets padding = media?.padding ?? EdgeInsets.zero;
    final double inset = widget.anchorInset;
    final double offset = index * widget.gap;
    final bool ltr = Directionality.of(context) == TextDirection.ltr;
    final bool leading = placement.isLeading;
    final bool onLeft = placement.isCenter ? false : (leading ? ltr : !ltr);
    final bool onRight = placement.isCenter ? false : (leading ? !ltr : ltr);
    final bool instant = media?.disableAnimations ?? false;
    final Widget child = widget.builder(context, entry, index);
    return AnimatedPositioned(
      // Keyed so an entry keeps its element (and its offset animation) when
      // the list shrinks after an exiting toast is removed.
      key: ValueKey<String>(entry.id),
      // Siblings animate into their new offsets when an exiting toast leaves.
      duration: instant ? Duration.zero : kToastExitDuration,
      curve: Curves.easeInOut,
      top: placement.isTop ? inset + padding.top + offset : null,
      bottom: placement.isTop ? null : inset + padding.bottom + offset,
      left: placement.isCenter ? 0 : (onLeft ? inset + padding.left : null),
      right: placement.isCenter ? 0 : (onRight ? inset + padding.right : null),
      child: placement.isCenter
          ? Align(
              alignment: placement.isTop
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: child,
            )
          : child,
    );
  }
}
