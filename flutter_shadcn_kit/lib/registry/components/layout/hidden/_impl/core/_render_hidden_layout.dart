// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hidden.dart';

/// _RenderHiddenLayout defines a reusable type for this registry module.
class _RenderHiddenLayout extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  /// Stores `textDirection` state/configuration for this implementation.
  TextDirection textDirection;

  /// Stores `direction` state/configuration for this implementation.
  Axis direction;

  /// Stores `reverse` state/configuration for this implementation.
  bool reverse;

  /// Stores `progress` state/configuration for this implementation.
  double progress;

  /// Stores `keepCrossAxisSize` state/configuration for this implementation.
  bool keepCrossAxisSize;

  /// Stores `keepMainAxisSize` state/configuration for this implementation.
  bool keepMainAxisSize;

  /// Creates a `_RenderHiddenLayout` instance.
  _RenderHiddenLayout({
    required this.textDirection,
    required this.direction,
    required this.reverse,
    required this.progress,
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
  });

  @override
  /// Executes `computeMaxIntrinsicHeight` behavior for this component/composite.
  double computeMaxIntrinsicHeight(double width) {
    return _computeIntrinsicHeight(
      (RenderBox child, double width) => child.getMaxIntrinsicHeight(width),
      width,
    );
  }

  @override
  /// Executes `computeMaxIntrinsicWidth` behavior for this component/composite.
  double computeMaxIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(
      (RenderBox child, double height) => child.getMaxIntrinsicWidth(height),
      height,
    );
  }

  @override
  /// Executes `computeMinIntrinsicHeight` behavior for this component/composite.
  double computeMinIntrinsicHeight(double width) {
    return _computeIntrinsicHeight(
      (RenderBox child, double width) => child.getMinIntrinsicHeight(width),
      width,
    );
  }

  @override
  /// Executes `computeMinIntrinsicWidth` behavior for this component/composite.
  double computeMinIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(
      (RenderBox child, double height) => child.getMinIntrinsicWidth(height),
      height,
    );
  }

  double _computeIntrinsicWidth(
    double Function(RenderBox child, double height) childWidth,
    double height,
  ) {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child == null) {
      return 0;
    }
    final width = childWidth(child, height);
    if ((keepMainAxisSize && direction != Axis.vertical) ||
        (keepCrossAxisSize && direction != Axis.horizontal)) {
      return width;
    }
    return width * progress;
  }

  double _computeIntrinsicHeight(
    double Function(RenderBox child, double width) childHeight,
    double width,
  ) {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child == null) {
      return 0;
    }
    final height = childHeight(child, width);
    if ((keepMainAxisSize && direction != Axis.horizontal) ||
        (keepCrossAxisSize && direction != Axis.vertical)) {
      return height;
    }
    return height * progress;
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as BoxParentData;
      context.paintChild(child, offset + parentData.offset);
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
    final child = this.child;
    if (child == null) return false;

    /// Stores `parentData` state/configuration for this implementation.
    final parentData = child.parentData as BoxParentData;
    return result.addWithPaintOffset(
      offset: parentData.offset,
      position: position,
      hitTest: (result, transformed) {
        return child.hitTest(result, position: transformed);
      },
    );
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    /// Stores `child` state/configuration for this implementation.
    final child = this.child;
    if (child == null) {
      size = constraints.biggest;
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    final childSize = constraints.constrain(child.size);

    /// Stores `width` state/configuration for this implementation.
    double width = childSize.width;

    /// Stores `height` state/configuration for this implementation.
    double height = childSize.height;

    if (!keepMainAxisSize) {
      if (direction == Axis.horizontal) {
        width = width * progress;
      } else {
        height = height * progress;
      }
    }
    if (!keepCrossAxisSize) {
      if (direction == Axis.horizontal) {
        height = height * progress;
      } else {
        width = width * progress;
      }
    }

    child.parentData = (child.parentData as BoxParentData)
      ..offset = Offset(
        reverse ? constraints.maxWidth - width : 0,
        reverse ? constraints.maxHeight - height : 0,
      );

    size = constraints.constrain(Size(width, height));
  }
}
