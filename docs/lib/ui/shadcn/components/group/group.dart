// The `group` component: a manual layout surface that places each child at an
// explicit offset and size, like a `Stack` driven by absolute coordinates.
//
// Ported from `layout/group` (`group_widget.dart` + `_impl/`). The old
// directory had no `group.dart` entry file (the installability violation the
// batch asked to fix); this file is that entry and the component's only Dart
// file. There is no theme: placement is pure geometry.
//
// Old bugs fixed, not ported:
//  * `RenderGroup.performLayout` sized itself with `constraints.biggest`,
//    which is infinite under unbounded constraints and crashed; it now sizes
//    from the children's extents and constrains the result.
//  * children pinned to `bottom`/`right` only were offset using the incoming
//    constraints, which are infinite when unbounded; the resolved group size
//    is used instead.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Parent data carrying one child's explicit placement inside a [Group].
class GroupParentData extends ContainerBoxParentData<RenderBox> {
  /// Distance from the group's top edge, when pinned.
  double? top;

  /// Distance from the group's leading (left) edge, when pinned.
  double? left;

  /// Distance from the group's trailing (right) edge, when pinned.
  double? right;

  /// Distance from the group's bottom edge, when pinned.
  double? bottom;

  /// Fixed width, when given.
  double? width;

  /// Fixed height, when given.
  double? height;
}

/// A layout surface that places children at explicit offsets and sizes.
///
/// Every child should be a [GroupPositioned]. A child without one fills the
/// available space (or takes its natural size when the group is unbounded).
class Group extends MultiChildRenderObjectWidget {
  /// Creates a group.
  const Group({super.key, super.children});

  @override
  RenderGroup createRenderObject(BuildContext context) => RenderGroup();

  @override
  void updateRenderObject(BuildContext context, RenderGroup renderObject) {}
}

/// Places a child inside a [Group] at explicit coordinates.
class GroupPositioned extends ParentDataWidget<GroupParentData> {
  /// Creates a positioned child.
  const GroupPositioned({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required super.child,
  });

  /// Creates a child that fills the group bounds.
  const GroupPositioned.fill({
    super.key,
    this.top = 0,
    this.left = 0,
    this.right = 0,
    this.bottom = 0,
    this.width,
    this.height,
    required super.child,
  });

  /// Creates a child from [rect].
  GroupPositioned.fromRect({
    super.key,
    required Rect rect,
    required super.child,
  }) : left = rect.left,
       top = rect.top,
       width = rect.width,
       height = rect.height,
       right = null,
       bottom = null;

  /// Distance from the group's top edge, when pinned.
  final double? top;

  /// Distance from the group's leading (left) edge, when pinned.
  final double? left;

  /// Distance from the group's trailing (right) edge, when pinned.
  final double? right;

  /// Distance from the group's bottom edge, when pinned.
  final double? bottom;

  /// Fixed width, when given.
  final double? width;

  /// Fixed height, when given.
  final double? height;

  @override
  void applyParentData(RenderObject renderObject) {
    final GroupParentData parentData =
        renderObject.parentData! as GroupParentData;
    bool needsLayout = false;
    if (parentData.top != top) {
      parentData.top = top;
      needsLayout = true;
    }
    if (parentData.left != left) {
      parentData.left = left;
      needsLayout = true;
    }
    if (parentData.right != right) {
      parentData.right = right;
      needsLayout = true;
    }
    if (parentData.bottom != bottom) {
      parentData.bottom = bottom;
      needsLayout = true;
    }
    if (parentData.width != width) {
      parentData.width = width;
      needsLayout = true;
    }
    if (parentData.height != height) {
      parentData.height = height;
      needsLayout = true;
    }
    if (needsLayout) {
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Group;
}

/// Render object that lays out [Group] children at absolute offsets.
class RenderGroup extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GroupParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GroupParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GroupParentData) {
      child.parentData = GroupParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints c = constraints;
    final bool boundedWidth = c.maxWidth.isFinite;
    final bool boundedHeight = c.maxHeight.isFinite;
    double extentWidth = 0;
    double extentHeight = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final GroupParentData parentData = child.parentData! as GroupParentData;
      child.layout(
        BoxConstraints.tightFor(
          width: _extent(
            parentData.left,
            parentData.right,
            parentData.width,
            boundedWidth ? c.maxWidth : null,
          ),
          height: _extent(
            parentData.top,
            parentData.bottom,
            parentData.height,
            boundedHeight ? c.maxHeight : null,
          ),
        ),
        parentUsesSize: true,
      );
      final double x = _offset(
        parentData.left,
        parentData.right,
        boundedWidth,
        c.maxWidth,
        child.size.width,
      );
      final double y = _offset(
        parentData.top,
        parentData.bottom,
        boundedHeight,
        c.maxHeight,
        child.size.height,
      );
      parentData.offset = Offset(x, y);
      extentWidth = math.max(extentWidth, x + child.size.width);
      extentHeight = math.max(extentHeight, y + child.size.height);
      child = parentData.nextSibling;
    }
    size = c.constrain(
      Size(
        boundedWidth ? c.maxWidth : extentWidth,
        boundedHeight ? c.maxHeight : extentHeight,
      ),
    );
  }

  /// The tight extent for one axis.
  ///
  /// `start` + `end` fills the span, [extent] fixes it, pinning to a single
  /// edge leaves the axis natural and an unpinned child fills a bounded axis
  /// (or takes its natural size when the axis is unbounded). Null is loose.
  static double? _extent(
    double? start,
    double? end,
    double? extent,
    double? max,
  ) {
    if (start != null && end != null && max != null) {
      return max - start - end;
    }
    if (extent != null) {
      return extent;
    }
    if (start != null || end != null) {
      return null;
    }
    return max;
  }

  /// The leading offset for one axis.
  ///
  /// A trailing pin is only resolvable against a bounded axis; on an unbounded
  /// axis the child is placed at zero instead of at a negative offset.
  static double _offset(
    double? start,
    double? end,
    bool bounded,
    double max,
    double childSize,
  ) {
    if (start != null) {
      return start;
    }
    if (end == null || !bounded) {
      return 0;
    }
    return max - end - childSize;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(
      Size(
        constraints.hasBoundedWidth ? constraints.maxWidth : 0,
        constraints.hasBoundedHeight ? constraints.maxHeight : 0,
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
