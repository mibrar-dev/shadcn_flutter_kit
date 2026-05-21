// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Patched flex render object with paint-order sorting support.
class RenderFlex extends rendering.RenderFlex with PaintOrderMixin {
  /// Creates a `RenderFlex` instance.
  RenderFlex({
    super.children,
    super.direction,
    super.mainAxisSize,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.spacing,
  });

  /// Stores `_hasOverflow` state/configuration for this implementation.
  bool _hasOverflow = false;

  @override
  rendering.RenderBox? get paintOrderFirstChild => firstChild;

  @override
  /// Stores `optionalClipBehavior` state/configuration for this implementation.
  Clip? get optionalClipBehavior => clipBehavior;

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(rendering.RenderBox child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    super.performLayout();
    buildSortedLinkedList();
    _hasOverflow = _checkOverflow();
  }

  /// Executes `_checkOverflow` behavior for this component/composite.
  bool _checkOverflow() {
    rendering.RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData! as FlexParentData;

      /// Stores `childRect` state/configuration for this implementation.
      final childRect = parentData.offset & child.size;
      if (childRect.right > size.width + 0.001 ||
          childRect.bottom > size.height + 0.001) {
        return true;
      }
      child = parentData.nextSibling;
    }
    return false;
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(rendering.PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      paintSorted(context, offset);
      return;
    }

    if (size.isEmpty) {
      return;
    }

    /// Creates a `context.pushClipRect` instance.
    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      paintSorted,
      clipBehavior: clipBehavior,
    );
  }

  @override
  bool hitTestChildren(
    rendering.BoxHitTestResult result, {
    required Offset position,
  }) {
    return hitTestSortedChildren(result, position: position);
  }
}
