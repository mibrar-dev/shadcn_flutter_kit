// Pane value/controller model for split-pane layouts, extracted from the
// `resizable` component so its files stay within the layout budget. Reusable
// by any pane-based layout (resizable, future split views).

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/resizable_item.dart';

/// Controller for one resizable pane.
///
/// A pane is either absolute ([size]) or flexible ([flex]); provide exactly
/// one. Replaces the old `AbsoluteResizablePaneController` /
/// `FlexibleResizablePaneController` pair (clean break).
class ResizablePaneController extends ChangeNotifier {
  /// Creates a pane controller.
  ResizablePaneController({double? size, double? flex, bool collapsed = false})
    : _size = size,
      _flex = flex,
      _collapsed = collapsed {
    assert(
      (size == null) != (flex == null),
      'Provide exactly one of size or flex',
    );
  }

  double? _size;
  double? _flex;
  bool _collapsed;

  /// Whether this pane sizes itself proportionally.
  bool get isFlexible => _flex != null;

  /// The current size (pixels) or flex factor.
  double get value => _flex ?? _size ?? 0;

  /// Whether the pane is collapsed.
  bool get collapsed => _collapsed;

  /// Sets an absolute pixel size.
  void setSize(double value) {
    if (_size == value) {
      return;
    }
    _size = value;
    _flex = null;
    notifyListeners();
  }

  /// Sets a flex factor.
  void setFlex(double value) {
    if (_flex == value) {
      return;
    }
    _flex = value;
    _size = null;
    notifyListeners();
  }

  /// Collapses the pane to its minimum size.
  void collapse() {
    if (_collapsed) {
      return;
    }
    _collapsed = true;
    notifyListeners();
  }

  /// Expands the pane back to its normal size.
  void expand() {
    if (!_collapsed) {
      return;
    }
    _collapsed = false;
    notifyListeners();
  }

  /// The pane's size for [paneSize], clamped to the constraints.
  double computeSize(double paneSize, {double? minSize, double? maxSize}) {
    final double base = _flex != null ? _flex! * paneSize : (_size ?? 0);
    return base.clamp(minSize ?? 0, maxSize ?? double.infinity);
  }
}

/// A pane's constraints plus controller, managed by a group.
class ResizablePaneHandle {
  /// Creates a pane handle.
  ResizablePaneHandle({
    required this.controller,
    this.minSize,
    this.maxSize,
    this.collapsedSize,
  });

  /// The pane controller.
  ResizablePaneController controller;

  /// Minimum size in pixels.
  double? minSize;

  /// Maximum size in pixels.
  double? maxSize;

  /// Size when collapsed.
  double? collapsedSize;

  /// The pane's current size for [paneSize], honouring the constraints.
  double computeSize(double paneSize) => controller.computeSize(
    paneSize,
    minSize: controller.collapsed ? null : minSize,
    maxSize: controller.collapsed ? null : maxSize,
  );
}

/// A [ResizableItem] that remembers its controller.
class ResizableEntryItem extends ResizableItem {
  /// Creates an entry item.
  ResizableEntryItem({
    required super.value,
    super.min,
    super.max,
    super.collapsed,
    super.collapsedSize,
    required this.controller,
  });

  /// The controller this item resizes.
  final ResizablePaneController controller;
}

/// Builds and applies the resizer engine's items for a list of handles.
class ResizablePaneLayout {
  /// Creates a layout over [handles].
  ResizablePaneLayout(this.handles);

  /// The managed panes.
  final List<ResizablePaneHandle> handles;

  /// The current engine items for [flexSpace].
  List<ResizableItem> items(double flexSpace) => <ResizableItem>[
    for (final ResizablePaneHandle handle in handles)
      ResizableEntryItem(
        value: handle.controller.collapsed
            ? (handle.collapsedSize ?? 0)
            : handle.computeSize(flexSpace),
        min: handle.minSize ?? 0,
        max: handle.maxSize ?? double.infinity,
        collapsed: handle.controller.collapsed,
        collapsedSize: handle.collapsedSize,
        controller: handle.controller,
      ),
  ];

  /// Applies committed [items] back onto the controllers.
  void apply(List<ResizableItem> items, double flexSpace) {
    for (final ResizableItem item in items) {
      if (item is! ResizableEntryItem) {
        continue;
      }
      if (item.newCollapsed) {
        item.controller.collapse();
        continue;
      }
      item.controller.expand();
      if (item.controller.isFlexible) {
        item.controller.setFlex(flexSpace > 0 ? item.newValue / flexSpace : 0);
      } else {
        item.controller.setSize(item.newValue);
      }
    }
  }
}

/// The delta that moves the divider at [index] of [items] to its extreme:
/// forward (`end`) or backward. Bounded by the two adjacent panes' min/max so
/// a single [Resizer.dragDivider] call lands exactly on the extreme.
double resizableEdgeDelta(
  List<ResizableItem> items,
  int index,
  bool end,
  double mainMax,
) {
  final ResizableItem left = items[index];
  final ResizableItem? right = index + 1 < items.length
      ? items[index + 1]
      : null;
  if (end) {
    final double leftGain =
        (left.max.isFinite ? left.max : mainMax) - left.newValue;
    final double rightLoss = right == null ? 0 : right.newValue - right.min;
    return math.min(leftGain, rightLoss);
  }
  final double leftLoss = left.newValue - left.min;
  final double rightGain = right == null
      ? 0
      : (right.max.isFinite ? right.max : mainMax) - right.newValue;
  return -math.min(leftLoss, rightGain);
}
