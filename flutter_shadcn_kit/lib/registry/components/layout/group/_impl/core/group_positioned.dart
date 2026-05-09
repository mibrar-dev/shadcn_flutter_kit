// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../group_widget.dart';

/// GroupPositioned defines a reusable type for this registry module.
class GroupPositioned extends ParentDataWidget<GroupParentData> {
  /// Creates a [GroupPositioned].
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

  /// Creates a positioned child that fills the group bounds.
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

  /// Creates a positioned child from the provided [rect].
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

  /// Stores `top` state/configuration for this implementation.
  final double? top;

  /// Stores `left` state/configuration for this implementation.
  final double? left;

  /// Stores `right` state/configuration for this implementation.
  final double? right;

  /// Stores `bottom` state/configuration for this implementation.
  final double? bottom;

  /// Stores `width` state/configuration for this implementation.
  final double? width;

  /// Stores `height` state/configuration for this implementation.
  final double? height;

  @override
  /// Executes `applyParentData` behavior for this component/composite.
  void applyParentData(RenderObject renderObject) {
    /// Stores `parentData` state/configuration for this implementation.
    final parentData = renderObject.parentData as GroupParentData;

    /// Stores `needsLayout` state/configuration for this implementation.
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
      /// Stores `targetParent` state/configuration for this implementation.
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  /// Stores `debugTypicalAncestorWidgetClass` state/configuration for this implementation.
  Type get debugTypicalAncestorWidgetClass => GroupWidget;
}
