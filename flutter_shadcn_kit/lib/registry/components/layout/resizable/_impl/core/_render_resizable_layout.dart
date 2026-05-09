// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _RenderResizableLayout defines a reusable type for this registry module.
class _RenderResizableLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ResizableLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ResizableLayoutParentData> {
  /// Stores `direction` state/configuration for this implementation.
  Axis direction;

  /// Stores `onLayout` state/configuration for this implementation.
  _ResizableLayoutCallback onLayout;

  _RenderResizableLayout(this.direction, this.onLayout);

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ResizableLayoutParentData) {
      child.parentData = _ResizableLayoutParentData();
    }
  }

  /// Executes `_getSizeExtent` behavior for this component/composite.
  double _getSizeExtent(Size size) {
    return direction == Axis.horizontal ? size.width : size.height;
  }

  /// Executes `_createOffset` behavior for this component/composite.
  Offset _createOffset(double main, double cross) {
    return direction == Axis.horizontal
        ? Offset(main, cross)
        : Offset(cross, main);
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

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    /// Stores `constraints` state/configuration for this implementation.
    final constraints = this.constraints;

    /// Stores `mainOffset` state/configuration for this implementation.
    double mainOffset = 0;

    /// Stores `intrinsicCross` state/configuration for this implementation.
    double intrinsicCross = 0;
    bool hasInfiniteCross = direction == Axis.horizontal
        ? !constraints.hasBoundedHeight
        : !constraints.hasBoundedWidth;
    if (hasInfiniteCross) {
      /// Stores `child` state/configuration for this implementation.
      RenderBox? child = firstChild;
      while (child != null) {
        /// Stores `childParentData` state/configuration for this implementation.
        final childParentData = child.parentData as _ResizableLayoutParentData;
        if (childParentData.isDragger != true &&
            childParentData.index == null) {
          if (direction == Axis.horizontal) {
            intrinsicCross = max(
              intrinsicCross,

              /// Creates a `child.getMaxIntrinsicHeight` instance.
              child.getMaxIntrinsicHeight(double.infinity),
            );
          } else {
            intrinsicCross = max(
              intrinsicCross,

              /// Creates a `child.getMaxIntrinsicWidth` instance.
              child.getMaxIntrinsicWidth(double.infinity),
            );
          }
        }
        child = childParentData.nextSibling;
      }
    } else {
      intrinsicCross = direction == Axis.horizontal
          ? constraints.maxHeight
          : constraints.maxWidth;
    }

    // lay out the dividers
    /// Stores `flexCount` state/configuration for this implementation.
    double flexCount = 0;

    /// Stores `dividerSizes` state/configuration for this implementation.
    List<double> dividerSizes = [];

    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;

    /// Stores `panelSize` state/configuration for this implementation.
    double panelSize = 0;

    /// Stores `dividerOffsets` state/configuration for this implementation.
    List<double> dividerOffsets = [];
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as _ResizableLayoutParentData;
      if (childParentData.isDragger != true && childParentData.index == null) {
        if (childParentData.isDivider == true) {
          /// Stores `childConstraints` state/configuration for this implementation.
          BoxConstraints childConstraints;
          if (direction == Axis.horizontal) {
            childConstraints = BoxConstraints(
              minWidth: 0,
              maxWidth: constraints.maxWidth,
              minHeight: intrinsicCross,
              maxHeight: intrinsicCross,
            );
          } else {
            childConstraints = BoxConstraints(
              minWidth: intrinsicCross,
              maxWidth: intrinsicCross,
              minHeight: 0,
              maxHeight: constraints.maxHeight,
            );
          }
          child.layout(childConstraints, parentUsesSize: true);

          /// Stores `childSize` state/configuration for this implementation.
          Size childSize = child.size;
          var sizeExtent = _getSizeExtent(childSize);
          dividerSizes.add(sizeExtent);
          mainOffset += sizeExtent;
        } else if (childParentData.flex != null) {
          flexCount += childParentData.flex!;
        } else if (childParentData.size != null) {
          panelSize += childParentData.size!;
        }
      }
      child = childParentData.nextSibling;
    }

    /// Stores `totalDividerSize` state/configuration for this implementation.
    double totalDividerSize = mainOffset;
    mainOffset = 0;
    // lay out the panes
    child = firstChild;
    // List<double> sizes = [];
    double parentSize = direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    double remainingSpace = parentSize - (panelSize + totalDividerSize);

    /// Stores `flexSpace` state/configuration for this implementation.
    double flexSpace = remainingSpace / flexCount;
    onLayout(flexSpace, flexCount);
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as _ResizableLayoutParentData;
      if (childParentData.isDragger != true && childParentData.index == null) {
        if (childParentData.isDivider != true) {
          /// Stores `childConstraints` state/configuration for this implementation.
          BoxConstraints childConstraints;

          /// Stores `childExtent` state/configuration for this implementation.
          double childExtent;
          if (childParentData.flex != null) {
            childExtent = flexSpace * childParentData.flex!;
          } else {
            childExtent = childParentData.size!;
          }
          if (direction == Axis.horizontal) {
            childConstraints = BoxConstraints(
              minWidth: childExtent,
              maxWidth: childExtent,
              minHeight: intrinsicCross,
              maxHeight: intrinsicCross,
            );
          } else {
            childConstraints = BoxConstraints(
              minWidth: intrinsicCross,
              maxWidth: intrinsicCross,
              minHeight: childExtent,
              maxHeight: childExtent,
            );
          }
          child.layout(childConstraints, parentUsesSize: true);

          /// Stores `childSize` state/configuration for this implementation.
          Size childSize = child.size;
          var sizeExtent = _getSizeExtent(childSize);
          // sizes.add(sizeExtent);
          childParentData.offset = _createOffset(mainOffset, 0);
          mainOffset += sizeExtent;
        } else {
          childParentData.offset = _createOffset(mainOffset, 0);
          dividerOffsets.add(mainOffset + _getSizeExtent(child.size) / 2);
          mainOffset += _getSizeExtent(child.size);
        }
      }
      child = childParentData.nextSibling;
    }

    // layout the rest
    child = firstChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as _ResizableLayoutParentData;
      if (childParentData.isDragger == true || childParentData.index != null) {
        // total offset = sum of sizes from 0 to index
        /// Stores `minExtent` state/configuration for this implementation.
        double minExtent = 0;
        if (childParentData.index != null) {
          minExtent = dividerSizes[childParentData.index!];
        }

        /// Stores `intrinsicExtent` state/configuration for this implementation.
        double intrinsicExtent = 0;
        if (direction == Axis.horizontal) {
          intrinsicExtent = child.getMaxIntrinsicWidth(double.infinity);
        } else {
          intrinsicExtent = child.getMaxIntrinsicHeight(double.infinity);
        }
        minExtent += intrinsicExtent;

        /// Stores `draggerConstraints` state/configuration for this implementation.
        BoxConstraints draggerConstraints;
        if (direction == Axis.horizontal) {
          draggerConstraints = BoxConstraints(
            minWidth: minExtent,
            maxWidth: double.infinity,
            minHeight: intrinsicCross,
            maxHeight: intrinsicCross,
          );
        } else {
          draggerConstraints = BoxConstraints(
            minWidth: intrinsicCross,
            maxWidth: intrinsicCross,
            minHeight: minExtent,
            maxHeight: double.infinity,
          );
        }
        child.layout(draggerConstraints, parentUsesSize: true);

        /// Stores `draggerSize` state/configuration for this implementation.
        Size draggerSize = child.size;
        // align at center
        var sizeExtent = _getSizeExtent(draggerSize);
        childParentData.offset = _createOffset(
          dividerOffsets[childParentData.index!] - sizeExtent / 2,
          0,
        );
        // childParentData.offset =
        //     _createOffset(draggerOffset - sizeExtent / 2 + dividerOffset, 0);
        // dividerOffset += sizeExtent;
      }
      child = childParentData.nextSibling;
    }

    /// Stores `size` state/configuration for this implementation.
    Size size;
    if (direction == Axis.horizontal) {
      size = Size(mainOffset, intrinsicCross);
    } else {
      size = Size(intrinsicCross, mainOffset);
    }
    this.size = constraints.constrain(size);
  }

  /// Helper method to compute intrinsic sizes based on children
  double _computeIntrinsicMainSize(double extent) {
    /// Stores `totalSize` state/configuration for this implementation.
    double totalSize = 0;

    // First pass: calculate fixed sizes and total flex
    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as _ResizableLayoutParentData;

      if (childParentData.isDragger != true && childParentData.index == null) {
        if (childParentData.isDivider == true) {
          // Add divider intrinsic size
          if (direction == Axis.horizontal) {
            totalSize += child.getMinIntrinsicWidth(extent);
          } else {
            totalSize += child.getMinIntrinsicHeight(extent);
          }
        } else if (childParentData.size != null) {
          // Fixed size pane
          totalSize += childParentData.size!;
        } else if (childParentData.flex != null) {
          // Add minimum intrinsic size for flex children
          if (direction == Axis.horizontal) {
            totalSize += child.getMinIntrinsicWidth(extent);
          } else {
            totalSize += child.getMinIntrinsicHeight(extent);
          }
        }
      }

      child = childParentData.nextSibling;
    }

    return totalSize;
  }

  /// Executes `_computeIntrinsicCrossSize` behavior for this component/composite.
  double _computeIntrinsicCrossSize(double extent) {
    /// Stores `maxCrossSize` state/configuration for this implementation.
    double maxCrossSize = 0;

    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as _ResizableLayoutParentData;

      if (childParentData.isDragger != true && childParentData.index == null) {
        /// Stores `childCrossSize` state/configuration for this implementation.
        double childCrossSize;
        if (direction == Axis.horizontal) {
          childCrossSize = child.getMinIntrinsicHeight(extent);
        } else {
          childCrossSize = child.getMinIntrinsicWidth(extent);
        }
        maxCrossSize = max(maxCrossSize, childCrossSize);
      }

      child = childParentData.nextSibling;
    }

    return maxCrossSize;
  }

  @override
  /// Executes `computeMinIntrinsicWidth` behavior for this component/composite.
  double computeMinIntrinsicWidth(double height) {
    if (direction == Axis.horizontal) {
      return _computeIntrinsicMainSize(height);
    } else {
      return _computeIntrinsicCrossSize(height);
    }
  }

  @override
  /// Executes `computeMaxIntrinsicWidth` behavior for this component/composite.
  double computeMaxIntrinsicWidth(double height) {
    if (direction == Axis.horizontal) {
      return _computeIntrinsicMainSize(height);
    } else {
      return _computeIntrinsicCrossSize(height);
    }
  }

  @override
  /// Executes `computeMinIntrinsicHeight` behavior for this component/composite.
  double computeMinIntrinsicHeight(double width) {
    if (direction == Axis.vertical) {
      return _computeIntrinsicMainSize(width);
    } else {
      return _computeIntrinsicCrossSize(width);
    }
  }

  @override
  /// Executes `computeMaxIntrinsicHeight` behavior for this component/composite.
  double computeMaxIntrinsicHeight(double width) {
    if (direction == Axis.vertical) {
      return _computeIntrinsicMainSize(width);
    } else {
      return _computeIntrinsicCrossSize(width);
    }
  }

  @override
  /// Executes `computeDryLayout` behavior for this component/composite.
  Size computeDryLayout(BoxConstraints constraints) {
    /// Stores `mainOffset` state/configuration for this implementation.
    double mainOffset = 0;

    // Calculate cross axis size
    /// Stores `intrinsicCross` state/configuration for this implementation.
    double intrinsicCross = 0;
    bool hasInfiniteCross = direction == Axis.horizontal
        ? !constraints.hasBoundedHeight
        : !constraints.hasBoundedWidth;

    if (hasInfiniteCross) {
      intrinsicCross = direction == Axis.horizontal
          ? computeMinIntrinsicHeight(constraints.maxWidth)
          : computeMinIntrinsicWidth(constraints.maxHeight);
    } else {
      intrinsicCross = direction == Axis.horizontal
          ? constraints.maxHeight
          : constraints.maxWidth;
    }

    // Calculate main axis sizes - similar to performLayout but without actual layout
    /// Stores `flexCount` state/configuration for this implementation.
    double flexCount = 0;

    /// Stores `panelSize` state/configuration for this implementation.
    double panelSize = 0;

    /// Stores `totalDividerSize` state/configuration for this implementation.
    double totalDividerSize = 0;

    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `childParentData` state/configuration for this implementation.
      final childParentData = child.parentData as _ResizableLayoutParentData;

      if (childParentData.isDragger != true && childParentData.index == null) {
        if (childParentData.isDivider == true) {
          // Calculate divider size
          /// Stores `childSize` state/configuration for this implementation.
          Size childSize;
          if (direction == Axis.horizontal) {
            childSize = child.getDryLayout(
              /// Creates a `BoxConstraints` instance.
              BoxConstraints(
                minWidth: 0,
                maxWidth: constraints.maxWidth,
                minHeight: intrinsicCross,
                maxHeight: intrinsicCross,
              ),
            );
          } else {
            childSize = child.getDryLayout(
              /// Creates a `BoxConstraints` instance.
              BoxConstraints(
                minWidth: intrinsicCross,
                maxWidth: intrinsicCross,
                minHeight: 0,
                maxHeight: constraints.maxHeight,
              ),
            );
          }
          totalDividerSize += _getSizeExtent(childSize);
        } else if (childParentData.flex != null) {
          flexCount += childParentData.flex!;
        } else if (childParentData.size != null) {
          panelSize += childParentData.size!;
        }
      }

      child = childParentData.nextSibling;
    }

    // Calculate remaining space for flex children
    double parentSize = direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    double remainingSpace = parentSize - (panelSize + totalDividerSize);

    /// Stores `flexSpace` state/configuration for this implementation.
    double flexSpace = flexCount > 0 ? remainingSpace / flexCount : 0;

    // Calculate total main axis size
    mainOffset = panelSize + totalDividerSize + (flexSpace * flexCount);

    /// Stores `size` state/configuration for this implementation.
    Size size;
    if (direction == Axis.horizontal) {
      size = Size(mainOffset, intrinsicCross);
    } else {
      size = Size(intrinsicCross, mainOffset);
    }

    return constraints.constrain(size);
  }
}
