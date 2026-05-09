// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../group_widget.dart';

/// Render box that lays out its children by absolute offsets.
class RenderGroup extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GroupParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GroupParentData> {
  /// Creates a `RenderGroup` instance.
  RenderGroup({List<RenderBox>? children}) {
    addAll(children);
  }

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(RenderBox child) {
    if (child.parentData is! GroupParentData) {
      child.parentData = GroupParentData();
    }
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    /// Stores `child` state/configuration for this implementation.
    var child = firstChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as GroupParentData;

      /// Stores `top` state/configuration for this implementation.
      double? top = childParentData.top;

      /// Stores `left` state/configuration for this implementation.
      double? left = childParentData.left;

      /// Stores `right` state/configuration for this implementation.
      double? right = childParentData.right;

      /// Stores `bottom` state/configuration for this implementation.
      double? bottom = childParentData.bottom;

      /// Stores `width` state/configuration for this implementation.
      double? width = childParentData.width;

      /// Stores `height` state/configuration for this implementation.
      double? height = childParentData.height;

      /// Stores `offsetX` state/configuration for this implementation.
      double offsetX = 0;

      /// Stores `offsetY` state/configuration for this implementation.
      double offsetY = 0;

      /// Stores `childWidth` state/configuration for this implementation.
      double childWidth = 0;

      /// Stores `childHeight` state/configuration for this implementation.
      double childHeight = 0;

      if (top != null && bottom != null) {
        offsetY = top;
        childHeight = constraints.maxHeight - (top + bottom);
      } else {
        if (top != null) {
          offsetY = top;
        } else if (bottom != null) {
          offsetY = constraints.maxHeight - bottom;
        }
        childHeight = height ?? constraints.maxHeight;
      }

      if (left != null && right != null) {
        offsetX = left;
        childWidth = constraints.maxWidth - (left + right);
      } else {
        if (left != null) {
          offsetX = left;
        } else if (right != null) {
          offsetX = constraints.maxWidth - right;
        }
        childWidth = width ?? constraints.maxWidth;
      }

      /// Creates a `child.layout` instance.
      child.layout(
        /// Creates a `BoxConstraints.tightFor` instance.
        BoxConstraints.tightFor(width: childWidth, height: childHeight),
        parentUsesSize: true,
      );

      if (top == null && bottom != null) {
        offsetY -= child.size.height;
      }
      if (left == null && right != null) {
        offsetX -= child.size.width;
      }

      childParentData.offset = Offset(offsetX, offsetY);
      child = childParentData.nextSibling;
    }
    size = constraints.biggest;
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    /// Stores `child` state/configuration for this implementation.
    var child = firstChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as GroupParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childParentData.nextSibling;
    }
  }

  @override
  /// Executes `hitTest` behavior for this component/composite.
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return hitTestChildren(result, position: position);
  }

  @override
  /// Executes `hitTestChildren` behavior for this component/composite.
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    /// Stores `child` state/configuration for this implementation.
    var child = lastChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData! as GroupParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child!.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
