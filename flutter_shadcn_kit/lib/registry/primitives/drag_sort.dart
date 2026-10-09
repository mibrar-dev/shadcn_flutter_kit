// Drag-and-drop reorder position math shared by the `sortable` component and the
// tab drag-reorder of the `tabs` component (P4 plan, P4-PRIM-5).
//
// Ported from the two old sortable trees:
//   * `layout/sortable/_impl/core/sortable_drop_location.dart` (`_getPosition`)
//   * `layout/sortable/_impl/state/sortable_state_part1.dart` (`_handleDrag`
//     bounds math) and `_impl/core/sortable_dragging_session.dart`
//   * `form/sortable/_impl/core/sortable_changes.dart` (the change model)
//
// Only the reusable maths and the list-change model live here; the widgets,
// render objects and drag session state belong to the owning component.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Edge of a target box a dragged item can be dropped on.
enum DragDropEdge {
  /// Above the target (or before it on a vertical list).
  top,

  /// Left of the target (or before it on a horizontal list).
  left,

  /// Right of the target (or after it on a horizontal list).
  right,

  /// Below the target (or after it on a vertical list).
  bottom;

  /// The edge on the opposite side of the same axis.
  DragDropEdge get opposite => switch (this) {
    DragDropEdge.top => DragDropEdge.bottom,
    DragDropEdge.bottom => DragDropEdge.top,
    DragDropEdge.left => DragDropEdge.right,
    DragDropEdge.right => DragDropEdge.left,
  };

  /// Whether this edge belongs to the vertical axis.
  bool get isVertical =>
      this == DragDropEdge.top || this == DragDropEdge.bottom;

  /// Whether this edge belongs to the horizontal axis.
  bool get isHorizontal => !isVertical;
}

/// Which edge of [size] contains [localPosition], or null when none.
///
/// A target that accepts edges on a single axis resolves like this:
///
/// * one accepted edge -> that edge, whatever the pointer position;
/// * both edges -> the pointer is compared against the midpoint.
///
/// When edges of both axes are accepted, every accepted edge is scored by its
/// normalised distance from the pointer and the closest one wins, with ties
/// broken in `top`, `left`, `right`, `bottom` order.
///
/// The old `_getPosition` tested the axes in a fixed order, so a target that
/// accepted `top` and `bottom` reported `top` for the whole upper half even
/// when the pointer sat almost exactly on the left edge. Scoring by distance
/// removes that bias; the single-axis cases above are unchanged.
DragDropEdge? resolveDragDropEdge(
  Offset localPosition,
  Size size, {
  bool acceptTop = false,
  bool acceptLeft = false,
  bool acceptRight = false,
  bool acceptBottom = false,
}) {
  final hasHorizontal = acceptLeft || acceptRight;
  final hasVertical = acceptTop || acceptBottom;
  if (!hasHorizontal && !hasVertical) {
    return null;
  }
  // A one-sided axis reports its single accepted edge wherever the pointer is.
  if (acceptTop && !acceptBottom) {
    return DragDropEdge.top;
  }
  if (acceptBottom && !acceptTop) {
    return DragDropEdge.bottom;
  }
  if (acceptLeft && !acceptRight) {
    return DragDropEdge.left;
  }
  if (acceptRight && !acceptLeft) {
    return DragDropEdge.right;
  }

  final width = size.width <= 0 ? 0.0 : size.width;
  final height = size.height <= 0 ? 0.0 : size.height;
  var best = DragDropEdge.top;
  var bestDistance = double.infinity;
  void consider(DragDropEdge edge, double distance) {
    if (distance < bestDistance) {
      best = edge;
      bestDistance = distance;
    }
  }

  if (acceptTop) {
    consider(DragDropEdge.top, height == 0 ? 0 : localPosition.dy / height);
  }
  if (acceptBottom) {
    consider(
      DragDropEdge.bottom,
      height == 0 ? 0 : (height - localPosition.dy) / height,
    );
  }
  if (acceptLeft) {
    consider(DragDropEdge.left, width == 0 ? 0 : localPosition.dx / width);
  }
  if (acceptRight) {
    consider(
      DragDropEdge.right,
      width == 0 ? 0 : (width - localPosition.dx) / width,
    );
  }
  return best;
}

/// The rectangle a dragged item may be translated inside.
///
/// The layer clamps the drag translation so the ghost never leaves the layer
/// bounds. [minOffset] and [maxOffset] are the item's top-left and bottom-right
/// corners expressed in layer coordinates, which is what makes the clamp work
/// for nested and scrolled layers.
class DragBounds {
  /// Creates bounds from explicit layer-space corners.
  const DragBounds({
    required this.layerSize,
    required this.minOffset,
    required this.maxOffset,
  });

  /// Reads the item's layer-space corners from a transform to [layerSize].
  factory DragBounds.fromTransform(
    Matrix4 transform,
    Size itemSize,
    Size layerSize,
  ) {
    final min = MatrixUtils.transformPoint(transform, Offset.zero);
    final max = MatrixUtils.transformPoint(
      transform,
      Offset(itemSize.width, itemSize.height),
    );
    return DragBounds(layerSize: layerSize, minOffset: min, maxOffset: max);
  }

  /// Size of the layer the drag is clamped to.
  final Size layerSize;

  /// Top-left corner of the item in layer coordinates.
  final Offset minOffset;

  /// Bottom-right corner of the item in layer coordinates.
  final Offset maxOffset;

  /// Size of the item being dragged.
  Size get itemSize =>
      Size(maxOffset.dx - minOffset.dx, maxOffset.dy - minOffset.dy);

  /// Whether the item is wider than the layer.
  bool get overflowsHorizontally => itemSize.width > layerSize.width;

  /// Whether the item is taller than the layer.
  bool get overflowsVertically => itemSize.height > layerSize.height;

  /// Largest translation the item can take on [axis] without leaving the layer.
  ///
  /// Negative when the item is larger than the layer: there is no position that
  /// keeps it inside, so [clampTranslation] pins that axis to zero instead of
  /// inverting the drag direction.
  double maxTranslationOn(Axis axis) {
    final item = axis == Axis.horizontal ? itemSize.width : itemSize.height;
    final layer = axis == Axis.horizontal ? layerSize.width : layerSize.height;
    if (item >= layer) {
      return 0;
    }
    return layer - item;
  }

  /// Applies [delta] to [current] and clamps the result to the bounds.
  ///
  /// The old `_handleDrag` clamped with `min(low, high)` / `max(low, high)`,
  /// which turned an inverted range into a drag that moved the ghost the wrong
  /// way whenever the item was larger than the layer.
  Offset clampTranslation(Offset current, Offset delta) {
    final next = current + delta;
    final maxX = maxTranslationOn(Axis.horizontal);
    final maxY = maxTranslationOn(Axis.vertical);
    return Offset(
      next.dx.isFinite ? next.dx.clamp(0.0, maxX) : 0.0,
      next.dy.isFinite ? next.dy.clamp(0.0, maxY) : 0.0,
    );
  }

  /// The layer-space point the drag hits, i.e. the centre of the translated
  /// item. This is what hit tests are run against.
  Offset probePosition(Offset translation) =>
      minOffset + translation + Offset(itemSize.width / 2, itemSize.height / 2);

  @override
  String toString() =>
      'DragBounds(layer: $layerSize, item: $itemSize, at: $minOffset)';
}

/// Base class of a single reorder operation on a list.
///
/// Implementations are immutable and describe intent, so the owning component
/// can report them to a form before applying them.
sealed class ReorderChange<T> {
  /// Creates a change.
  const ReorderChange();

  /// Applies this change to [list]; returns false when it was skipped.
  ///
  /// The old `ListChange` hierarchy threw a [RangeError] when an index was out
  /// of range. Every implementation here is bounds checked and reports the skip
  /// instead, so a stale index from an animation can never crash the list.
  bool apply(List<T> list);
}

/// A batch of [ReorderChange]s applied in order.
class ReorderChanges<T> {
  /// Creates a batch.
  const ReorderChanges(this.changes);

  /// The changes, applied in order.
  final List<ReorderChange<T>> changes;

  /// Whether the batch does nothing.
  bool get isEmpty => changes.isEmpty;

  /// Whether the batch has at least one change.
  bool get isNotEmpty => changes.isNotEmpty;

  /// Applies every change; returns how many were applied.
  int apply(List<T> list) {
    var applied = 0;
    for (final change in changes) {
      if (change.apply(list)) {
        applied += 1;
      }
    }
    return applied;
  }

  /// Applies every change to a copy of [items] and returns it.
  List<T> appliedTo(List<T> items) {
    final result = List<T>.of(items);
    apply(result);
    return result;
  }
}

/// Swaps the items at [from] and [to].
class ReorderSwap<T> extends ReorderChange<T> {
  /// Creates a swap.
  const ReorderSwap(this.from, this.to);

  /// Source index.
  final int from;

  /// Destination index.
  final int to;

  @override
  bool apply(List<T> list) {
    if (from < 0 || from >= list.length || to < 0 || to >= list.length) {
      return false;
    }
    final value = list[from];
    list[from] = list[to];
    list[to] = value;
    return true;
  }

  @override
  bool operator ==(Object other) =>
      other is ReorderSwap<T> && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(ReorderSwap, from, to);

  @override
  String toString() => 'ReorderSwap($from -> $to)';
}

/// Removes the item at [index].
class ReorderRemove<T> extends ReorderChange<T> {
  /// Creates a removal.
  const ReorderRemove(this.index);

  /// Index of the item to remove.
  final int index;

  @override
  bool apply(List<T> list) {
    if (index < 0 || index >= list.length) {
      return false;
    }
    list.removeAt(index);
    return true;
  }

  @override
  bool operator ==(Object other) =>
      other is ReorderRemove<T> && other.index == index;

  @override
  int get hashCode => Object.hash(ReorderRemove, index);

  @override
  String toString() => 'ReorderRemove($index)';
}

/// Inserts [item] at [index].
class ReorderInsert<T> extends ReorderChange<T> {
  /// Creates an insertion.
  const ReorderInsert(this.index, this.item);

  /// Target index; clamped into `[0, length]` on apply.
  final int index;

  /// The item to insert.
  final T item;

  @override
  bool apply(List<T> list) {
    list.insert(math.max(0, math.min(index, list.length)), item);
    return true;
  }

  @override
  bool operator ==(Object other) =>
      other is ReorderInsert<T> && other.index == index && other.item == item;

  @override
  int get hashCode => Object.hash(ReorderInsert, index, item);

  @override
  String toString() => 'ReorderInsert($index, $item)';
}

/// The index at which to insert an item so it lands at [targetIndex] of the
/// list *without* that item.
///
/// Drag code measures the drop position against the list that already has the
/// dragged item removed, so `0` means "first" and `length - 1` means "last";
/// the index is clamped into that range instead of throwing.
int reorderIndex({required int targetIndex, required int length}) {
  if (length <= 0) {
    return 0;
  }
  return math.max(0, math.min(targetIndex, length - 1));
}
