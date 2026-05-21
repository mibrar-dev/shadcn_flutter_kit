// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Patched stack render object with paint-order sorting support.
class RenderStack extends rendering.RenderStack with PaintOrderMixin {
  /// Creates a `RenderStack` instance.
  RenderStack({
    super.children,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
  });

  @override
  rendering.RenderBox? get paintOrderFirstChild => firstChild;

  @override
  /// Stores `optionalClipBehavior` state/configuration for this implementation.
  Clip? get optionalClipBehavior => clipBehavior;

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(rendering.RenderBox child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    super.performLayout();
    buildSortedLinkedList();
  }

  @override
  /// Executes `paintStack` behavior for this component/composite.
  void paintStack(rendering.PaintingContext context, Offset offset) {
    paintSorted(context, offset);
  }

  @override
  bool hitTestChildren(
    rendering.BoxHitTestResult result, {
    required Offset position,
  }) {
    return hitTestSortedChildren(result, position: position);
  }
}
