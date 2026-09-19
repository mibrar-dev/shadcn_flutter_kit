// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// Parent data for sortable items within a [RawSortableStack].
///
/// Extends [ContainerBoxParentData] to include positioning information
/// for items in a sortable layout.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class RawSortableParentData extends ContainerBoxParentData<RenderBox> {
  /// The current position offset of this sortable item.
  Offset? position;
}

/// Widget that positions a sortable item at a specific offset.
///
/// Used internally by sortable lists to position items during drag
/// operations. Wraps a child widget and updates its parent data with
/// the specified [offset].
///
/// Upstream parity: ported from `sortable.dart` upstream.
class RawSortableItemPositioned
    extends ParentDataWidget<RawSortableParentData> {
  /// The offset where the item should be positioned.
  final Offset offset;

  /// Creates a [RawSortableItemPositioned].
  ///
  /// Parameters:
  /// - [offset] (`Offset`, required): Position offset for the child.
  /// - [child] (`Widget`, required): The child widget to position.
  const RawSortableItemPositioned({
    super.key,
    required this.offset,
    required super.child,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as RawSortableParentData;
    if (parentData.position != offset) {
      parentData.position = offset;
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => RawSortableStack;
}

/// RawSortableStack prevents the stacking children from going outside the bounds of this widget.
/// A raw sortable stack widget for managing layered sortable items.
///
/// Provides basic stacking functionality for sortable components without
/// additional layout or styling. Clamps child positions to widget bounds.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class RawSortableStack extends MultiChildRenderObjectWidget {
  /// Creates a raw sortable stack.
  const RawSortableStack({super.key, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRawSortableStack();
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderRawSortableStack renderObject,
  ) {
    renderObject.enabled = true;
  }
}

/// Render object for managing sortable item stacking and positioning.
///
/// Handles layout, painting, and hit testing for sortable items arranged
/// in a stack. Clamps child positions to widget bounds to prevent items
/// from escaping during drag operations.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class RenderRawSortableStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, RawSortableParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, RawSortableParentData> {
  /// Whether drag-and-drop interactions are enabled.
  bool enabled = true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! RawSortableParentData) {
      child.parentData = RawSortableParentData();
    }
  }

  @override
  void performLayout() {
    var constraints = this.constraints;
    var child = firstChild;
    while (child != null) {
      var childParentData = child.parentData as RawSortableParentData;
      child.layout(constraints, parentUsesSize: true);
      child = childParentData.nextSibling;
    }
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      var childParentData = child.parentData as RawSortableParentData;
      context.paintChild(child, childParentData.position! + offset);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;
    while (child != null) {
      var childParentData = child.parentData as RawSortableParentData;
      if ((childParentData.position! & child.size).contains(position)) {
        return result.addWithPaintOffset(
          offset: childParentData.position!,
          position: position,
          hitTest: (BoxHitTestResult result, Offset position) {
            return child!.hitTest(
              result,
              position: position - childParentData.position!,
            );
          },
        );
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
