// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizableLayoutChild defines a reusable type for this registry module.
class _ResizableLayoutChild
    extends ParentDataWidget<_ResizableLayoutParentData> {
  /// Stores `index` state/configuration for this implementation.
  final int? index;

  /// Stores `isDragger` state/configuration for this implementation.
  final bool? isDragger;

  /// Stores `isDivider` state/configuration for this implementation.
  final bool? isDivider;

  /// Stores `size` state/configuration for this implementation.
  final double? size;

  /// Stores `flex` state/configuration for this implementation.
  final double? flex;

  /// Creates a `_ResizableLayoutChild` instance.
  const _ResizableLayoutChild({
    this.index,
    this.isDragger,
    this.isDivider,
    this.size,
    this.flex,
    required super.child,
  });

  @override
  /// Executes `applyParentData` behavior for this component/composite.
  void applyParentData(RenderObject renderObject) {
    /// Stores `parentData` state/configuration for this implementation.
    final parentData = renderObject.parentData as _ResizableLayoutParentData;

    /// Stores `needsLayout` state/configuration for this implementation.
    bool needsLayout = false;

    if (parentData.index != index) {
      parentData.index = index;
      needsLayout = true;
    }

    if (parentData.isDragger != isDragger) {
      parentData.isDragger = isDragger;
      needsLayout = true;
    }

    if (parentData.isDivider != isDivider) {
      parentData.isDivider = isDivider;
      needsLayout = true;
    }

    if (parentData.size != size) {
      parentData.size = size;
      needsLayout = true;
    }

    if (parentData.flex != flex) {
      parentData.flex = flex;
      needsLayout = true;
    }

    if (needsLayout) {
      /// Stores `targetParent` state/configuration for this implementation.
      final targetParent = renderObject.parent;
      targetParent?.markNeedsLayout();
    }
  }

  @override
  /// Stores `debugTypicalAncestorWidgetClass` state/configuration for this implementation.
  Type get debugTypicalAncestorWidgetClass => _ResizableLayout;
}
