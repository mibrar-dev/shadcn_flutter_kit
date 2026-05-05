part of '../../hidden.dart';


/// _HiddenLayoutRender defines a reusable type for this registry module.
class _HiddenLayoutRender extends RenderShiftedBox {
/// Stores `keepCrossAxisSize` state/configuration for this implementation.
  bool keepCrossAxisSize;
/// Stores `keepMainAxisSize` state/configuration for this implementation.
  bool keepMainAxisSize;
/// Stores `textDirection` state/configuration for this implementation.
  TextDirection textDirection;
/// Stores `direction` state/configuration for this implementation.
  Axis direction;
/// Stores `reverse` state/configuration for this implementation.
  bool reverse;
/// Stores `progress` state/configuration for this implementation.
  double progress;

/// Creates a `_HiddenLayoutRender` instance.
  _HiddenLayoutRender({
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
    required this.textDirection,
    required this.direction,
    required this.reverse,
    required this.progress,
    RenderBox? child,
  }) : super(child);

  @override
/// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    if (child == null) {
      size = constraints.smallest;
      return;
    }

    child!.layout(constraints, parentUsesSize: true);
/// Stores `childSize` state/configuration for this implementation.
    final childSize = child!.size;

/// Stores `mainAxisSize` state/configuration for this implementation.
    var mainAxisSize = direction == Axis.horizontal ? childSize.width : childSize.height;
/// Stores `crossAxisSize` state/configuration for this implementation.
    var crossAxisSize = direction == Axis.horizontal ? childSize.height : childSize.width;

/// Stores `mainAxisProgress` state/configuration for this implementation.
    final mainAxisProgress = keepMainAxisSize ? 1.0 : progress;
/// Stores `crossAxisProgress` state/configuration for this implementation.
    final crossAxisProgress = keepCrossAxisSize ? 1.0 : progress;

/// Stores `constrainedMainAxis` state/configuration for this implementation.
    final constrainedMainAxis = mainAxisSize * mainAxisProgress;
/// Stores `constrainedCrossAxis` state/configuration for this implementation.
    final constrainedCrossAxis = crossAxisSize * crossAxisProgress;

/// Stores `width` state/configuration for this implementation.
    final width = direction == Axis.horizontal ? constrainedMainAxis : constrainedCrossAxis;
/// Stores `height` state/configuration for this implementation.
    final height = direction == Axis.horizontal ? constrainedCrossAxis : constrainedMainAxis;

    size = constraints.constrain(Size(width, height));

    final alignment = direction == Axis.horizontal
        ? (textDirection == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight)
        : Alignment.topCenter;
    final offset = alignment.alongOffset(
/// Creates a `Offset` instance.
      Offset(size.width - childSize.width, size.height - childSize.height),
    );
    final shift =
        reverse ? Offset(-offset.dx, -offset.dy) : Offset(offset.dx, offset.dy);
    (child!.parentData as BoxParentData).offset = shift;
  }
}
