// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Flexible child with optional custom paint order.
class Flexible extends widgets.ParentDataWidget<FlexParentData> {
  /// Creates a `Flexible` instance.
  const Flexible({
    super.key,
    this.flex = 1,
    this.fit = rendering.FlexFit.loose,
    this.paintOrder,
    required super.child,
  });

  /// Stores `flex` state/configuration for this implementation.
  final int flex;
  final rendering.FlexFit fit;

  /// Higher values paint above lower values.
  final int? paintOrder;

  @override
  /// Executes `applyParentData` behavior for this component/composite.
  void applyParentData(rendering.RenderObject renderObject) {
    assert(renderObject.parentData is FlexParentData);

    /// Stores `parentData` state/configuration for this implementation.
    final parentData = renderObject.parentData! as FlexParentData;

    /// Stores `needsLayout` state/configuration for this implementation.
    var needsLayout = false;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      needsLayout = true;
    }
    if (parentData.fit != fit) {
      parentData.fit = fit;
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
  Type get debugTypicalAncestorWidgetClass => Flex;

  @override
  /// Executes `debugFillProperties` behavior for this component/composite.
  void debugFillProperties(foundation.DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(foundation.IntProperty('flex', flex));
    properties.add(foundation.EnumProperty<rendering.FlexFit>('fit', fit));
    properties.add(foundation.IntProperty('paintOrder', paintOrder));
  }
}

/// Expanded child with optional custom paint order.
class Expanded extends Flexible {
  /// Creates a `Expanded` instance.
  const Expanded({
    super.key,
    super.flex,
    super.paintOrder,
    required super.child,
  }) : super(fit: rendering.FlexFit.tight);
}

/// Assign paint order to non-flex children inside [Flex].
class PaintOrder extends widgets.ParentDataWidget<FlexParentData> {
  const PaintOrder({super.key, required this.paintOrder, required super.child});

  /// Stores `paintOrder` state/configuration for this implementation.
  final int paintOrder;

  @override
  /// Executes `applyParentData` behavior for this component/composite.
  void applyParentData(rendering.RenderObject renderObject) {
    assert(renderObject.parentData is FlexParentData);

    /// Stores `parentData` state/configuration for this implementation.
    final parentData = renderObject.parentData! as FlexParentData;
    if (parentData.paintOrder != paintOrder) {
      parentData.paintOrder = paintOrder;
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  /// Stores `debugTypicalAncestorWidgetClass` state/configuration for this implementation.
  Type get debugTypicalAncestorWidgetClass => Flex;

  @override
  /// Executes `debugFillProperties` behavior for this component/composite.
  void debugFillProperties(foundation.DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(foundation.IntProperty('paintOrder', paintOrder));
  }
}
