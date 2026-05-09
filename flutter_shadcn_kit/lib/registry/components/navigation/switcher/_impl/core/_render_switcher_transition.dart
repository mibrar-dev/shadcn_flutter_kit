// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../switcher.dart';

/// _RenderSwitcherTransition defines a reusable type for this registry module.
class _RenderSwitcherTransition extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SwitcherParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SwitcherParentData> {
  /// Stores `progress` state/configuration for this implementation.
  double progress = 0;

  /// Stores `direction` state/configuration for this implementation.
  AxisDirection direction = AxisDirection.down;

  /// Stores `absolute` state/configuration for this implementation.
  bool absolute = false;

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(covariant RenderObject child) {
    if (child.parent != this) {
      child.parentData = _SwitcherParentData();
    }
  }

  /// Executes `_lerpDouble` behavior for this component/composite.
  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    if (firstChild == null || childAfter(firstChild!) == null) {
      size = Size.zero;
      return;
    }

    /// Stores `oldChild` state/configuration for this implementation.
    final oldChild = firstChild!;
    final newChild = childAfter(oldChild)!;

    oldChild.layout(constraints, parentUsesSize: true);
    newChild.layout(constraints, parentUsesSize: true);

    /// Stores `oldSize` state/configuration for this implementation.
    final oldSize = oldChild.size;

    /// Stores `newSize` state/configuration for this implementation.
    final newSize = newChild.size;

    /// Stores `oldData` state/configuration for this implementation.
    final oldData = oldChild.parentData! as _SwitcherParentData;

    /// Stores `newData` state/configuration for this implementation.
    final newData = newChild.parentData! as _SwitcherParentData;

    final lerpedSize = Size.lerp(oldSize, newSize, progress)!;

    if (absolute) {
      switch (direction) {
        case AxisDirection.down:
        case AxisDirection.up:
          final slideOffset = direction == AxisDirection.down
              ? Offset(0, _lerpDouble(0, newSize.height, progress))
              : Offset(0, _lerpDouble(0, -newSize.height, progress));
          final oldCenteringDx = (lerpedSize.width - oldSize.width) / 2;
          final newCenteringDx = (lerpedSize.width - newSize.width) / 2;

          oldData.offset = slideOffset + Offset(oldCenteringDx, 0);

          final newRelativePos = direction == AxisDirection.down
              ? slideOffset - Offset(0, newSize.height)
              : slideOffset + Offset(0, newSize.height);
          newData.offset = newRelativePos + Offset(newCenteringDx, 0);
          break;

        case AxisDirection.left:
        case AxisDirection.right:
          final slideOffset = direction == AxisDirection.right
              ? Offset(_lerpDouble(0, newSize.width, progress), 0)
              : Offset(_lerpDouble(0, -newSize.width, progress), 0);
          final oldCenteringDy = (lerpedSize.height - oldSize.height) / 2;
          final newCenteringDy = (lerpedSize.height - newSize.height) / 2;

          oldData.offset = slideOffset + Offset(0, oldCenteringDy);

          final newRelativePos = direction == AxisDirection.right
              ? slideOffset - Offset(newSize.width, 0)
              : slideOffset + Offset(newSize.width, 0);
          newData.offset = newRelativePos + Offset(0, newCenteringDy);
          break;
      }
    } else {
      switch (direction) {
        case AxisDirection.down:
        case AxisDirection.up:
          final oldSlideOffset = direction == AxisDirection.down
              ? Offset.lerp(Offset.zero, Offset(0, newSize.height), progress)!
              : Offset.lerp(Offset.zero, Offset(0, -oldSize.height), progress)!;
          final newSlideOffset = direction == AxisDirection.down
              ? Offset.lerp(Offset(0, -newSize.height), Offset.zero, progress)!
              : Offset.lerp(Offset(0, oldSize.height), Offset.zero, progress)!;
          final oldCenteringDx = (lerpedSize.width - oldSize.width) / 2;
          final newCenteringDx = (lerpedSize.width - newSize.width) / 2;

          oldData.offset = oldSlideOffset + Offset(oldCenteringDx, 0);
          newData.offset = newSlideOffset + Offset(newCenteringDx, 0);
          break;

        case AxisDirection.left:
        case AxisDirection.right:
          final oldSlideOffset = direction == AxisDirection.right
              ? Offset.lerp(Offset.zero, Offset(newSize.width, 0), progress)!
              : Offset.lerp(Offset.zero, Offset(-oldSize.width, 0), progress)!;
          final newSlideOffset = direction == AxisDirection.right
              ? Offset.lerp(Offset(-newSize.width, 0), Offset.zero, progress)!
              : Offset.lerp(Offset(oldSize.width, 0), Offset.zero, progress)!;
          final oldCenteringDy = (lerpedSize.height - oldSize.height) / 2;
          final newCenteringDy = (lerpedSize.height - newSize.height) / 2;

          oldData.offset = oldSlideOffset + Offset(0, oldCenteringDy);
          newData.offset = newSlideOffset + Offset(0, newCenteringDy);
          break;
      }
    }
    size = constraints.constrain(lerpedSize);
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  /// Executes `hitTestChildren` behavior for this component/composite.
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
