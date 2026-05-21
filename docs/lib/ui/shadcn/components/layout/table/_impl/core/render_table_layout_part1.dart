// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// RenderTableLayout defines a reusable type for this registry module.
class RenderTableLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TableParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TableParentData> {
  /// Stores `_width` state/configuration for this implementation.
  TableSizeSupplier _width;

  /// Stores `_height` state/configuration for this implementation.
  TableSizeSupplier _height;

  /// Stores `_clipBehavior` state/configuration for this implementation.
  Clip _clipBehavior;

  /// Stores `_frozenColumn` state/configuration for this implementation.
  CellPredicate? _frozenColumn;

  /// Stores `_frozenRow` state/configuration for this implementation.
  CellPredicate? _frozenRow;

  /// Stores `_verticalOffset` state/configuration for this implementation.
  double? _verticalOffset;

  /// Stores `_horizontalOffset` state/configuration for this implementation.
  double? _horizontalOffset;

  /// Stores `_viewportSize` state/configuration for this implementation.
  Size? _viewportSize;

  /// Stores `_layoutResult` state/configuration for this implementation.
  TableLayoutResult? _layoutResult;

  /// Creates a render object for table layout.
  ///
  /// Initializes the table layout system with sizing functions and optional
  /// frozen cell configurations. This render object handles the complex
  /// layout calculations for tables with variable cell sizes.
  ///
  /// Parameters:
  /// - [children] (`List<RenderBox>?`): Optional initial child render boxes
  /// - [width] (TableSizeSupplier, required): Function providing width for each column
  /// - [height] (TableSizeSupplier, required): Function providing height for each row
  /// - [clipBehavior] (Clip, required): How to clip children outside table bounds
  /// - [frozenCell] (CellPredicate?): Predicate identifying frozen columns
  /// - [frozenRow] (CellPredicate?): Predicate identifying frozen rows
  /// - [verticalOffset] (double?): Vertical scroll offset for viewport
  /// - [horizontalOffset] (double?): Horizontal scroll offset for viewport
  /// - [viewportSize] (Size?): Size of the visible viewport area
  ///
  /// Frozen cells remain visible during scrolling, useful for sticky headers.
  RenderTableLayout({
    List<RenderBox>? children,
    required TableSizeSupplier width,
    required TableSizeSupplier height,
    required Clip clipBehavior,
    CellPredicate? frozenCell,
    CellPredicate? frozenRow,
    double? verticalOffset,
    double? horizontalOffset,
    Size? viewportSize,
  }) : _clipBehavior = clipBehavior,
       _width = width,
       _height = height,
       _frozenColumn = frozenCell,
       _frozenRow = frozenRow,
       _verticalOffset = verticalOffset,
       _horizontalOffset = horizontalOffset,
       _viewportSize = viewportSize {
    addAll(children);
  }

  @override
  /// Executes `setupParentData` behavior for this component/composite.
  void setupParentData(RenderObject child) {
    if (child.parentData is! TableParentData) {
      child.parentData = TableParentData();
    }
  }

  @override
  /// Executes `hitTestChildren` behavior for this component/composite.
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // reverse hit test traversal so that the first child is hit tested last
    // important for column and row spans
    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;
      final hit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      if (hit) {
        return true;
      }
      child = childAfter(child);
    }
    return false;
  }

  @override
  /// Executes `computeMinIntrinsicWidth` behavior for this component/composite.
  double computeMinIntrinsicWidth(double height) {
    return computeTableSize(
      /// Creates a `BoxConstraints.loose` instance.
      BoxConstraints.loose(Size(double.infinity, height)),
      (child, extent) {
        return child.getMinIntrinsicWidth(extent);
      },
    ).width;
  }

  @override
  /// Executes `computeDryLayout` behavior for this component/composite.
  Size computeDryLayout(BoxConstraints constraints) {
    return computeTableSize(constraints).size;
  }

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(PaintingContext context, Offset offset) {
    // reverse paint traversal so that the first child is painted last
    // important for column and row spans
    // (ASSUMPTION: children are already sorted in the correct order)
    if (_clipBehavior != Clip.none) {
      /// Creates a `context.pushClipRect` instance.
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, (
        context,
        offset,
      ) {
        /// Stores `child` state/configuration for this implementation.
        RenderBox? child = lastChild;
        while (child != null) {
          /// Stores `parentData` state/configuration for this implementation.
          final parentData = child.parentData as TableParentData;
          if (parentData.computeSize &&
              !parentData.frozenRow &&
              !parentData.frozenColumn) {
            context.paintChild(child, offset + parentData.offset);
          }
          child = childBefore(child);
        }
      }, clipBehavior: _clipBehavior);

      /// Stores `child` state/configuration for this implementation.
      RenderBox? child = lastChild;
      while (child != null) {
        /// Stores `parentData` state/configuration for this implementation.
        final parentData = child.parentData as TableParentData;
        if (!parentData.computeSize &&
            !parentData.frozenRow &&
            !parentData.frozenColumn) {
          context.paintChild(child, offset + parentData.offset);
        }
        child = childBefore(child);
      }

      /// Creates a `context.pushClipRect` instance.
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, (
        context,
        offset,
      ) {
        /// Stores `child` state/configuration for this implementation.
        RenderBox? child = lastChild;
        while (child != null) {
          /// Stores `parentData` state/configuration for this implementation.
          final parentData = child.parentData as TableParentData;
          if (parentData.frozenColumn) {
            context.paintChild(child, offset + parentData.offset);
          }
          child = childBefore(child);
        }
      }, clipBehavior: _clipBehavior);

      /// Creates a `context.pushClipRect` instance.
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, (
        context,
        offset,
      ) {
        /// Stores `child` state/configuration for this implementation.
        RenderBox? child = lastChild;
        while (child != null) {
          /// Stores `parentData` state/configuration for this implementation.
          final parentData = child.parentData as TableParentData;
          if (parentData.frozenRow) {
            context.paintChild(child, offset + parentData.offset);
          }
          child = childBefore(child);
        }
      }, clipBehavior: _clipBehavior);
      child = lastChild;
      while (child != null) {
        /// Stores `parentData` state/configuration for this implementation.
        final parentData = child.parentData as TableParentData;
        if (!parentData.computeSize && (parentData.frozenColumn)) {
          context.paintChild(child, offset + parentData.offset);
        }
        child = childBefore(child);
      }
      child = lastChild;
      while (child != null) {
        /// Stores `parentData` state/configuration for this implementation.
        final parentData = child.parentData as TableParentData;
        if (!parentData.computeSize && (parentData.frozenRow)) {
          context.paintChild(child, offset + parentData.offset);
        }
        child = childBefore(child);
      }
      return;
    }

    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = lastChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;
      if (!parentData.frozenRow && !parentData.frozenColumn) {
        context.paintChild(child, offset + parentData.offset);
      }
      child = childBefore(child);
    }
    child = lastChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;
      if (parentData.frozenColumn) {
        context.paintChild(child, offset + parentData.offset);
      }
      child = childBefore(child);
    }
    child = lastChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;
      if (parentData.frozenRow) {
        context.paintChild(child, offset + parentData.offset);
      }
      child = childBefore(child);
    }
  }

  @override
  /// Executes `performLayout` behavior for this component/composite.
  void performLayout() {
    final result = computeTableSize(constraints);
    size = constraints.constrain(result.size);

    /// Stores `frozenRows` state/configuration for this implementation.
    Map<int, double> frozenRows = {};

    /// Stores `frozenColumns` state/configuration for this implementation.
    Map<int, double> frozenColumns = {};

    /// Stores `effectiveHorizontalOffset` state/configuration for this implementation.
    double effectiveHorizontalOffset = _horizontalOffset ?? 0;

    /// Stores `effectiveVerticalOffset` state/configuration for this implementation.
    double effectiveVerticalOffset = _verticalOffset ?? 0;

    if (_viewportSize != null) {
      double maxHorizontalScroll = max(0, size.width - _viewportSize!.width);
      double maxVerticalScroll = max(0, size.height - _viewportSize!.height);
      effectiveHorizontalOffset = effectiveHorizontalOffset.clamp(
        0,
        maxHorizontalScroll,
      );
      effectiveVerticalOffset = effectiveVerticalOffset.clamp(
        0,
        maxVerticalScroll,
      );
    } else {
      effectiveHorizontalOffset = max(0, effectiveHorizontalOffset);
      effectiveVerticalOffset = max(0, effectiveVerticalOffset);
    }

    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;

      /// Stores `column` state/configuration for this implementation.
      final column = parentData.column;

      /// Stores `row` state/configuration for this implementation.
      final row = parentData.row;
      if (column != null && row != null) {
        /// Stores `width` state/configuration for this implementation.
        double width = 0;

        /// Stores `height` state/configuration for this implementation.
        double height = 0;

        /// Stores `columnSpan` state/configuration for this implementation.
        int columnSpan = parentData.columnSpan ?? 1;

        /// Stores `rowSpan` state/configuration for this implementation.
        int rowSpan = parentData.rowSpan ?? 1;
        bool frozenRow = _frozenRow?.call(row, rowSpan) ?? false;
        bool frozenColumn = _frozenColumn?.call(column, columnSpan) ?? false;
        for (
          /// Stores `i` state/configuration for this implementation.
          int i = 0;
          i < columnSpan && column + i < result.columnWidths.length;
          i++
        ) {
          width += result.columnWidths[column + i];
        }
        for (
          /// Stores `i` state/configuration for this implementation.
          int i = 0;
          i < rowSpan && row + i < result.rowHeights.length;
          i++
        ) {
          height += result.rowHeights[row + i];
        }
        child.layout(BoxConstraints.tightFor(width: width, height: height));
        final offset = result.getOffset(column, row);

        /// Stores `offsetX` state/configuration for this implementation.
        double offsetX = offset.dx;

        /// Stores `offsetY` state/configuration for this implementation.
        double offsetY = offset.dy;

        if (frozenRow) {
          /// Stores `verticalOffset` state/configuration for this implementation.
          double verticalOffset = effectiveVerticalOffset;
          double offsetInViewport =
              offsetY - (_viewportSize != null ? verticalOffset : 0);

          // make sure its visible on the viewport
          /// Stores `minViewport` state/configuration for this implementation.
          double minViewport = 0;

          /// Stores `maxViewport` state/configuration for this implementation.
          double maxViewport = _viewportSize?.height ?? constraints.maxHeight;
          if (maxViewport == double.infinity) {
            maxViewport = size.height;
          }
          for (int i = 0; i < row; i++) {
            /// Stores `rowHeight` state/configuration for this implementation.
            var rowHeight = frozenRows[i] ?? 0;
            minViewport += rowHeight;
          }

          /// Stores `verticalAdjustment` state/configuration for this implementation.
          double verticalAdjustment = 0;
          if (_viewportSize != null && verticalOffset < 0) {
            verticalAdjustment = verticalOffset;
          } else if (offsetInViewport < minViewport) {
            verticalAdjustment = -offsetInViewport + minViewport;
          } else if (offsetInViewport + height > maxViewport) {
            // Sticky bottom logic if needed, but for now just top sticking
            // verticalAdjustment = maxViewport - offsetInViewport - height;
          }
          frozenRows[row] = max(frozenRows[row] ?? 0, height);
          offsetY += verticalAdjustment;
        }
        if (frozenColumn) {
          /// Stores `horizontalOffset` state/configuration for this implementation.
          double horizontalOffset = effectiveHorizontalOffset;
          double offsetInViewport =
              offsetX - (_viewportSize != null ? horizontalOffset : 0);

          // make sure its visible on the viewport
          /// Stores `minViewport` state/configuration for this implementation.
          double minViewport = 0;

          /// Stores `maxViewport` state/configuration for this implementation.
          double maxViewport = _viewportSize?.width ?? constraints.maxWidth;
          if (maxViewport == double.infinity) {
            maxViewport = size.width;
          }
          for (int i = 0; i < column; i++) {
            /// Stores `columnWidth` state/configuration for this implementation.
            var columnWidth = frozenColumns[i] ?? 0;
            minViewport += columnWidth;
          }

          /// Stores `horizontalAdjustment` state/configuration for this implementation.
          double horizontalAdjustment = 0;
          if (_viewportSize != null && horizontalOffset < 0) {
            horizontalAdjustment = horizontalOffset;
          } else if (offsetInViewport < minViewport) {
            horizontalAdjustment = -offsetInViewport + minViewport;
          } else if (offsetInViewport + width > maxViewport) {
            // Sticky right logic if needed
            // horizontalAdjustment = maxViewport - offsetInViewport - width;
          }
          frozenColumns[column] = max(frozenColumns[column] ?? 0, width);
          offsetX += horizontalAdjustment;
        }
        parentData.frozenRow = frozenRow;
        parentData.frozenColumn = frozenColumn;
        parentData.offset = Offset(offsetX, offsetY);
      }
      child = childAfter(child);
    }

    _layoutResult = result;
  }

  /// Computes the table layout with specified constraints.
  ///
  /// Performs the complex table layout algorithm that:
  /// 1. Determines maximum row and column counts from child cells
  /// 2. Calculates fixed and flexible sizing for all columns and rows
  /// 3. Distributes available space among flex items
  /// 4. Handles both tight and loose flex constraints
  /// 5. Computes final dimensions for each column and row
  ///
  /// The layout algorithm respects size constraints from [TableSize] objects
  /// and ensures cells spanning multiple columns/rows are properly handled.
  ///
  /// Parameters:
  /// - [constraints] (BoxConstraints, required): Layout constraints for the table
  /// - [intrinsicComputer] (IntrinsicComputer?): Optional function to compute intrinsic sizes
  ///
  /// Returns [TableLayoutResult] containing computed dimensions and layout metadata.
  TableLayoutResult computeTableSize(
    BoxConstraints constraints, [
    IntrinsicComputer? intrinsicComputer,
  ]) {
    /// Stores `flexWidth` state/configuration for this implementation.
    double flexWidth = 0;

    /// Stores `flexHeight` state/configuration for this implementation.
    double flexHeight = 0;

    /// Stores `fixedWidth` state/configuration for this implementation.
    double fixedWidth = 0;

    /// Stores `fixedHeight` state/configuration for this implementation.
    double fixedHeight = 0;

    /// Stores `columnWidths` state/configuration for this implementation.
    Map<int, double> columnWidths = {};

    /// Stores `rowHeights` state/configuration for this implementation.
    Map<int, double> rowHeights = {};

    /// Stores `maxRow` state/configuration for this implementation.
    int maxRow = 0;

    /// Stores `maxColumn` state/configuration for this implementation.
    int maxColumn = 0;

    /// Stores `hasTightFlexWidth` state/configuration for this implementation.
    bool hasTightFlexWidth = false;

    /// Stores `hasTightFlexHeight` state/configuration for this implementation.
    bool hasTightFlexHeight = false;

    // find the maximum row and column
    /// Stores `child` state/configuration for this implementation.
    RenderBox? child = firstChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;
      if (parentData.computeSize) {
        /// Stores `column` state/configuration for this implementation.
        int? column = parentData.column;

        /// Stores `row` state/configuration for this implementation.
        int? row = parentData.row;
        if (column != null && row != null) {
          /// Stores `columnSpan` state/configuration for this implementation.
          int columnSpan = parentData.columnSpan ?? 1;

          /// Stores `rowSpan` state/configuration for this implementation.
          int rowSpan = parentData.rowSpan ?? 1;
          maxColumn = max(maxColumn, column + columnSpan - 1);
          maxRow = max(maxRow, row + rowSpan - 1);
        }
      }
      child = childAfter(child);
    }

    // micro-optimization: avoid calculating flexes if there are no flexes
    /// Stores `hasFlexWidth` state/configuration for this implementation.
    bool hasFlexWidth = false;

    /// Stores `hasFlexHeight` state/configuration for this implementation.
    bool hasFlexHeight = false;

    // row
    for (int r = 0; r <= maxRow; r++) {
      final heightConstraint = _height(r);
      if (heightConstraint is FlexTableSize &&
          constraints.hasBoundedHeight &&
          intrinsicComputer == null) {
        flexHeight += heightConstraint.flex;
        hasFlexHeight = true;
        if (heightConstraint.fit == FlexFit.tight) {
          hasTightFlexHeight = true;
        }
      } else if (heightConstraint is FixedTableSize) {
        fixedHeight += heightConstraint.value;
        rowHeights[r] = max(rowHeights[r] ?? 0, heightConstraint.value);
      }
    }
    // column
    for (int c = 0; c <= maxColumn; c++) {
      final widthConstraint = _width(c);
      if (widthConstraint is FlexTableSize && constraints.hasBoundedWidth) {
        flexWidth += widthConstraint.flex;
        hasFlexWidth = true;
        if (widthConstraint.fit == FlexFit.tight) {
          hasTightFlexWidth = true;
        }
      } else if (widthConstraint is FixedTableSize) {
        fixedWidth += widthConstraint.value;
        columnWidths[c] = max(columnWidths[c] ?? 0, widthConstraint.value);
      } else if (widthConstraint is FractionalTableSize &&
          constraints.hasBoundedWidth) {
        /// Stores `value` state/configuration for this implementation.
        double value = widthConstraint.fraction * constraints.maxWidth;
        fixedWidth += value;
        columnWidths[c] = max(columnWidths[c] ?? 0, value);
      }
    }

    /// Stores `spacePerFlexWidth` state/configuration for this implementation.
    double spacePerFlexWidth = 0;

    /// Stores `spacePerFlexHeight` state/configuration for this implementation.
    double spacePerFlexHeight = 0;

    /// Stores `remainingWidth` state/configuration for this implementation.
    double remainingWidth;

    /// Stores `remainingHeight` state/configuration for this implementation.
    double remainingHeight;
    if (constraints.hasBoundedWidth) {
      remainingWidth = constraints.maxWidth - fixedWidth;
    } else {
      remainingWidth = double.infinity;
    }
    if (constraints.hasBoundedHeight) {
      remainingHeight = constraints.maxHeight - fixedHeight;
    } else {
      remainingHeight = double.infinity;
    }

    // find the proper intrinsic sizes (if any)
    child = lastChild;
    while (child != null) {
      /// Stores `parentData` state/configuration for this implementation.
      final parentData = child.parentData as TableParentData;
      if (parentData.computeSize) {
        /// Stores `column` state/configuration for this implementation.
        int? column = parentData.column;

        /// Stores `row` state/configuration for this implementation.
        int? row = parentData.row;
        if (column != null && row != null) {
          final widthConstraint = _width(column);
          final heightConstraint = _height(row);
          if (widthConstraint is IntrinsicTableSize ||
              (widthConstraint is FlexTableSize && intrinsicComputer != null)) {
            /// Stores `extent` state/configuration for this implementation.
            var extent = rowHeights[row] ?? remainingHeight;
            double maxIntrinsicWidth = intrinsicComputer != null
                ? intrinsicComputer(child, extent)
                : child.getMaxIntrinsicWidth(extent);
            maxIntrinsicWidth = min(maxIntrinsicWidth, remainingWidth);

            /// Stores `columnSpan` state/configuration for this implementation.
            int columnSpan = parentData.columnSpan ?? 1;
            // distribute the intrinsic width to all columns
            maxIntrinsicWidth = maxIntrinsicWidth / columnSpan;
            for (int i = 0; i < columnSpan; i++) {
              columnWidths[column + i] = max(
                columnWidths[column + i] ?? 0,
                maxIntrinsicWidth,
              );
            }
          }
          if (heightConstraint is IntrinsicTableSize ||
              (heightConstraint is FlexTableSize &&
                  intrinsicComputer != null)) {
            /// Stores `extent` state/configuration for this implementation.
            var extent = columnWidths[column] ?? remainingWidth;
            double maxIntrinsicHeight = intrinsicComputer != null
                ? intrinsicComputer(child, extent)
                : child.getMaxIntrinsicHeight(extent);
            maxIntrinsicHeight = min(maxIntrinsicHeight, remainingHeight);

            /// Stores `rowSpan` state/configuration for this implementation.
            int rowSpan = parentData.rowSpan ?? 1;
            // distribute the intrinsic height to all rows

            maxIntrinsicHeight = maxIntrinsicHeight / rowSpan;
            for (int i = 0; i < rowSpan; i++) {
              rowHeights[row + i] = max(
                rowHeights[row + i] ?? 0,
                maxIntrinsicHeight,
              );
            }
          }
        }
      }
      child = childBefore(child);
    }

    double usedColumnWidth = columnWidths.values.fold(0, (a, b) => a + b);
    double usedRowHeight = rowHeights.values.fold(0, (a, b) => a + b);

    /// Stores `looseRemainingWidth` state/configuration for this implementation.
    double looseRemainingWidth = remainingWidth;

    /// Stores `looseRemainingHeight` state/configuration for this implementation.
    double looseRemainingHeight = remainingHeight;

    /// Stores `looseSpacePerFlexWidth` state/configuration for this implementation.
    double looseSpacePerFlexWidth = 0;

    /// Stores `looseSpacePerFlexHeight` state/configuration for this implementation.
    double looseSpacePerFlexHeight = 0;

    if (intrinsicComputer == null) {
      // recalculate remaining space for flexes
      if (constraints.hasBoundedWidth) {
        remainingWidth = constraints.maxWidth - usedColumnWidth;
      } else {
        remainingWidth = double.infinity;
      }
      if (constraints.hasInfiniteWidth) {
        looseRemainingWidth = double.infinity;
      } else {
        looseRemainingWidth = max(0, constraints.minWidth - usedColumnWidth);
      }
      if (constraints.hasBoundedHeight) {
        remainingHeight = constraints.maxHeight - usedRowHeight;
      } else {
        remainingHeight = double.infinity;
      }
      if (constraints.hasInfiniteHeight) {
        looseRemainingHeight = double.infinity;
      } else {
        looseRemainingHeight = max(0, constraints.minHeight - usedRowHeight);
      }
      if (flexWidth > 0 && remainingWidth > 0) {
        spacePerFlexWidth = remainingWidth / flexWidth;
      } else {
        spacePerFlexWidth = 0;
      }
      if (flexWidth > 0 && looseRemainingWidth > 0) {
        looseSpacePerFlexWidth = looseRemainingWidth / flexWidth;
      }
      if (flexHeight > 0 && remainingHeight > 0) {
        spacePerFlexHeight = remainingHeight / flexHeight;
      } else {
        spacePerFlexHeight = 0;
      }
      if (flexHeight > 0 && looseRemainingHeight > 0) {
        spacePerFlexHeight = looseRemainingHeight / flexHeight;
      }

      // calculate space used for flexes
      if (hasFlexWidth) {
        for (int c = 0; c <= maxColumn; c++) {
          final widthConstraint = _width(c);
          if (widthConstraint is FlexTableSize) {
            // columnWidths[c] = widthConstraint.flex * spacePerFlexWidth;
            if (widthConstraint.fit == FlexFit.tight || hasTightFlexWidth) {
              columnWidths[c] = widthConstraint.flex * spacePerFlexWidth;
            } else {
              columnWidths[c] = widthConstraint.flex * looseSpacePerFlexWidth;
            }
          }
        }
      }
      if (hasFlexHeight) {
        for (int r = 0; r <= maxRow; r++) {
          final heightConstraint = _height(r);
          if (heightConstraint is FlexTableSize) {
            // rowHeights[r] = heightConstraint.flex * spacePerFlexHeight;
            if (heightConstraint.fit == FlexFit.tight || hasTightFlexHeight) {
              rowHeights[r] = heightConstraint.flex * spacePerFlexHeight;
            } else {
              rowHeights[r] = heightConstraint.flex * looseSpacePerFlexHeight;
            }
          }
        }
      }
    }

    // Second pass: recalculate intrinsic sizes if they depend on flex sizes
    if (intrinsicComputer == null) {
      child = lastChild;
      while (child != null) {
        /// Stores `parentData` state/configuration for this implementation.
        final parentData = child.parentData as TableParentData;
        if (parentData.computeSize) {
          /// Stores `column` state/configuration for this implementation.
          int? column = parentData.column;

          /// Stores `row` state/configuration for this implementation.
          int? row = parentData.row;
          if (column != null && row != null) {
            final heightConstraint = _height(row);
            // Check if we need to recalculate height (Intrinsic row with Flex/Fixed column)
            if (heightConstraint is IntrinsicTableSize) {
              // If column was Flex, it now has a calculated width in columnWidths
              // If column was Fixed, it's also in columnWidths
              // We can use the actual column width now
              /// Stores `columnSpan` state/configuration for this implementation.
              int columnSpan = parentData.columnSpan ?? 1;

              /// Stores `availableWidth` state/configuration for this implementation.
              double availableWidth = 0;
              for (int i = 0; i < columnSpan; i++) {
                availableWidth += columnWidths[column + i] ?? 0;
              }

              if (availableWidth > 0) {
                double maxIntrinsicHeight = child.getMaxIntrinsicHeight(
                  availableWidth,
                );
                maxIntrinsicHeight = min(maxIntrinsicHeight, remainingHeight);

                /// Stores `rowSpan` state/configuration for this implementation.
                int rowSpan = parentData.rowSpan ?? 1;

                maxIntrinsicHeight = maxIntrinsicHeight / rowSpan;
                for (int i = 0; i < rowSpan; i++) {
                  rowHeights[row + i] = max(
                    rowHeights[row + i] ?? 0,
                    maxIntrinsicHeight,
                  );
                }
              }
            }
          }
        }
        child = childBefore(child);
      }
    }

    // convert the column widths and row heights to a list, where missing values are 0
    List<double> columnWidthsList = List.generate(maxColumn + 1, (index) {
      return columnWidths[index] ?? 0;
    });

    /// Creates a `columnWidths.forEach` instance.
    columnWidths.forEach((key, value) {
      columnWidthsList[key] = value;
    });
    List<double> rowHeightsList =
        // List.filled(rowHeights.keys.reduce(max) + 1, 0);
        /// Creates a `List.generate` instance.
        List.generate(maxRow + 1, (index) {
          return rowHeights[index] ?? 0;
        });

    /// Creates a `rowHeights.forEach` instance.
    rowHeights.forEach((key, value) {
      rowHeightsList[key] = value;
    });
    return TableLayoutResult(
      columnWidths: columnWidthsList,
      rowHeights: rowHeightsList,
      remainingWidth: remainingWidth,
      remainingHeight: remainingHeight,
      remainingLooseWidth: looseRemainingWidth,
      remainingLooseHeight: looseRemainingHeight,
      hasTightFlexWidth: hasTightFlexWidth,
      hasTightFlexHeight: hasTightFlexHeight,
    );
  }

  @override
  /// Executes `computeMaxIntrinsicWidth` behavior for this component/composite.
  double computeMaxIntrinsicWidth(double height) {
    return computeTableSize(
      /// Creates a `BoxConstraints.loose` instance.
      BoxConstraints.loose(Size(double.infinity, height)),
      (child, extent) {
        return child.getMaxIntrinsicWidth(extent);
      },
    ).width;
  }

  @override
  /// Executes `computeMinIntrinsicHeight` behavior for this component/composite.
  double computeMinIntrinsicHeight(double width) {
    return computeTableSize(
      /// Creates a `BoxConstraints.loose` instance.
      BoxConstraints.loose(Size(width, double.infinity)),
      (child, extent) {
        return child.getMinIntrinsicHeight(extent);
      },
    ).height;
  }

  @override
  /// Executes `computeMaxIntrinsicHeight` behavior for this component/composite.
  double computeMaxIntrinsicHeight(double width) {
    return computeTableSize(
      /// Creates a `BoxConstraints.loose` instance.
      BoxConstraints.loose(Size(width, double.infinity)),
      (child, extent) {
        return child.getMaxIntrinsicHeight(extent);
      },
    ).height;
  }

  // delegate from TableLayoutResult, with read-only view
  /// Gets an unmodifiable list of computed column widths.
  ///
  /// Returns the width of each column after layout calculation. The list
  /// index corresponds to the column index, and the value is the width in
  /// logical pixels.
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns an unmodifiable `List<double>` of column widths.
  List<double> get columnWidths {
    assert(_layoutResult != null, 'Layout result is not available');
    return List.unmodifiable(_layoutResult!.columnWidths);
  }

  /// Gets an unmodifiable list of computed row heights.
  ///
  /// Returns the height of each row after layout calculation. The list
  /// index corresponds to the row index, and the value is the height in
  /// logical pixels.
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns an unmodifiable `List<double>` of row heights.
  List<double> get rowHeights {
    assert(_layoutResult != null, 'Layout result is not available');
    return List.unmodifiable(_layoutResult!.rowHeights);
  }

  /// Gets the top-left offset of a cell at the specified position.
  ///
  /// Calculates the cumulative offset by summing the widths of all columns
  /// before the specified column and heights of all rows before the specified row.
  ///
  /// Parameters:
  /// - [column] (int, required): Zero-based column index
  /// - [row] (int, required): Zero-based row index
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns [Offset] representing the cell's top-left corner position.
  Offset getOffset(int column, int row) {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.getOffset(column, row);
  }

  /// Gets the remaining unclaimed width in the table layout.
  ///
  /// This represents horizontal space not allocated to any column after
  /// fixed and flex sizing calculations. Useful for understanding how much
  /// space is available for expansion or debugging layout issues.
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns remaining width in logical pixels as a double.
  double get remainingWidth {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.remainingWidth;
  }

  /// Gets the remaining unclaimed height in the table layout.
  ///
  /// This represents vertical space not allocated to any row after
  /// fixed and flex sizing calculations. Useful for understanding how much
  /// space is available for expansion or debugging layout issues.
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns remaining height in logical pixels as a double.
  double get remainingHeight {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.remainingHeight;
  }

  /// Gets the remaining loose (flexible) width available for loose flex items.
  ///
  /// Loose flex items can shrink below their flex allocation. This getter
  /// returns the remaining width available specifically for items with
  /// loose flex constraints (FlexFit.loose).
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns remaining loose width in logical pixels as a double.
  double get remainingLooseWidth {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.remainingLooseWidth;
  }

  /// Gets the remaining loose (flexible) height available for loose flex items.
  ///
  /// Loose flex items can shrink below their flex allocation. This getter
  /// returns the remaining height available specifically for items with
  /// loose flex constraints (FlexFit.loose).
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns remaining loose height in logical pixels as a double.
  double get remainingLooseHeight {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.remainingLooseHeight;
  }

  /// Indicates whether any column uses tight flex sizing.
  ///
  /// Tight flex items must occupy their full flex allocation. This getter
  /// returns true if at least one column has a tight flex constraint
  /// (FlexFit.tight), which affects how remaining space is distributed.
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns true if table has tight flex width columns, false otherwise.
  bool get hasTightFlexWidth {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.hasTightFlexWidth;
  }

  /// Indicates whether any row uses tight flex sizing.
  ///
  /// Tight flex items must occupy their full flex allocation. This getter
  /// returns true if at least one row has a tight flex constraint
  /// (FlexFit.tight), which affects how remaining space is distributed.
  ///
  /// Throws [AssertionError] if called before layout is complete.
  ///
  /// Returns true if table has tight flex height rows, false otherwise.
  bool get hasTightFlexHeight {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!.hasTightFlexHeight;
  }
}

/// Function that computes intrinsic dimensions for a render box.
///
/// Used internally during table layout to calculate natural sizes
/// of cells when using intrinsic sizing modes.
