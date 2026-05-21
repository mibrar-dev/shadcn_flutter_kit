// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Positioned child with optional custom paint order for [Stack].
class Positioned extends widgets.ParentDataWidget<StackParentData> {
  /// Creates a `Positioned` instance.
  const Positioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.paintOrder,
    required super.child,
  }) : assert(left == null || right == null || width == null),
       assert(top == null || bottom == null || height == null);

  /// Creates a `Positioned.fill` instance.
  const Positioned.fill({
    super.key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.paintOrder,
    required super.child,
  }) : width = null,
       height = null;

  /// Stores `left` state/configuration for this implementation.
  final double? left;

  /// Stores `top` state/configuration for this implementation.
  final double? top;

  /// Stores `right` state/configuration for this implementation.
  final double? right;

  /// Stores `bottom` state/configuration for this implementation.
  final double? bottom;

  /// Stores `width` state/configuration for this implementation.
  final double? width;

  /// Stores `height` state/configuration for this implementation.
  final double? height;

  /// Higher values paint above lower values.
  final int? paintOrder;

  @override
  /// Executes `applyParentData` behavior for this component/composite.
  void applyParentData(rendering.RenderObject renderObject) {
    assert(renderObject.parentData is StackParentData);

    /// Stores `parentData` state/configuration for this implementation.
    final parentData = renderObject.parentData! as StackParentData;

    /// Stores `needsLayout` state/configuration for this implementation.
    var needsLayout = false;

    if (parentData.left != left) {
      parentData.left = left;
      needsLayout = true;
    }
    if (parentData.top != top) {
      parentData.top = top;
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
    if (parentData.paintOrder != paintOrder) {
      parentData.paintOrder = paintOrder;
      needsLayout = true;
    }

    if (needsLayout) {
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  /// Stores `debugTypicalAncestorWidgetClass` state/configuration for this implementation.
  Type get debugTypicalAncestorWidgetClass => Stack;

  @override
  /// Executes `debugFillProperties` behavior for this component/composite.
  void debugFillProperties(foundation.DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(foundation.DoubleProperty('left', left, defaultValue: null));
    properties.add(foundation.DoubleProperty('top', top, defaultValue: null));

    /// Creates a `properties.add` instance.
    properties.add(
      /// Creates a `foundation.DoubleProperty` instance.
      foundation.DoubleProperty('right', right, defaultValue: null),
    );

    /// Creates a `properties.add` instance.
    properties.add(
      /// Creates a `foundation.DoubleProperty` instance.
      foundation.DoubleProperty('bottom', bottom, defaultValue: null),
    );

    /// Creates a `properties.add` instance.
    properties.add(
      /// Creates a `foundation.DoubleProperty` instance.
      foundation.DoubleProperty('width', width, defaultValue: null),
    );

    /// Creates a `properties.add` instance.
    properties.add(
      /// Creates a `foundation.DoubleProperty` instance.
      foundation.DoubleProperty('height', height, defaultValue: null),
    );

    /// Creates a `properties.add` instance.
    properties.add(
      /// Creates a `foundation.IntProperty` instance.
      foundation.IntProperty('paintOrder', paintOrder, defaultValue: null),
    );
  }
}
