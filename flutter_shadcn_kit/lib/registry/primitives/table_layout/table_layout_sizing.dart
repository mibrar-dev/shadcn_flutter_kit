// The table grid-sizing algorithm used by [RenderTableLayout].
//
// Extracted from `table_layout_render.dart` so both files stay within the
// 400-line limit. Pure computation over the child render boxes.
//
// Bug fixed 2026-10-09 (P4-T4): `remainingWidth`/`remainingHeight` were
// `maxWidth - fixedWidth` WITHOUT a zero clamp, so any grid whose fixed columns
// or rows already overflow the incoming constraints (resized columns inside a
// zero-width viewport) produced a negative budget. That negative was then used
// as the "extent" argument of the children's intrinsic queries, and the
// framework asserts on it ("The height argument to getMaxIntrinsicWidth was
// negative"). The negative also reached the public `remainingWidth` /
// `remainingHeight` accessors. Both budgets are now clamped at the source.

import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'table_layout.dart';

/// Computes the grid for [constraints].
///
/// [children] are the table children in sibling order, [reversedChildren] the
/// same children reversed (intrinsic passes walk last-to-first).
TableLayoutResult computeTableLayout(
  BoxConstraints constraints,
  TableSizeSupplier width,
  TableSizeSupplier height,
  List<RenderBox> children,
  List<RenderBox> reversedChildren, [
  IntrinsicComputer? intrinsicComputer,
]) {
  double flexWidth = 0;
  double flexHeight = 0;
  double fixedWidth = 0;
  double fixedHeight = 0;
  final Map<int, double> columnWidths = <int, double>{};
  final Map<int, double> rowHeights = <int, double>{};
  int maxRow = 0;
  int maxColumn = 0;
  bool hasTightFlexWidth = false;
  bool hasTightFlexHeight = false;

  for (final RenderBox child in children) {
    final TableParentData parentData = child.parentData! as TableParentData;
    if (parentData.computeSize) {
      final int? column = parentData.column;
      final int? row = parentData.row;
      if (column != null && row != null) {
        maxColumn = max(maxColumn, column + (parentData.columnSpan ?? 1) - 1);
        maxRow = max(maxRow, row + (parentData.rowSpan ?? 1) - 1);
      }
    }
  }

  for (int r = 0; r <= maxRow; r++) {
    final TableSize constraint = height(r);
    if (constraint is FlexTableSize &&
        constraints.hasBoundedHeight &&
        intrinsicComputer == null) {
      flexHeight += constraint.flex;
      if (constraint.fit == FlexFit.tight) {
        hasTightFlexHeight = true;
      }
    } else if (constraint is FixedTableSize) {
      fixedHeight += constraint.value;
      rowHeights[r] = max(rowHeights[r] ?? 0, constraint.value);
    }
  }
  for (int c = 0; c <= maxColumn; c++) {
    final TableSize constraint = width(c);
    if (constraint is FlexTableSize && constraints.hasBoundedWidth) {
      flexWidth += constraint.flex;
      if (constraint.fit == FlexFit.tight) {
        hasTightFlexWidth = true;
      }
    } else if (constraint is FixedTableSize) {
      fixedWidth += constraint.value;
      columnWidths[c] = max(columnWidths[c] ?? 0, constraint.value);
    } else if (constraint is FractionalTableSize &&
        constraints.hasBoundedWidth) {
      final double value = constraint.fraction * constraints.maxWidth;
      fixedWidth += value;
      columnWidths[c] = max(columnWidths[c] ?? 0, value);
    }
  }

  // `maxWidth - fixedWidth` goes NEGATIVE as soon as the fixed columns/rows
  // overflow the incoming constraints (resized columns inside a zero-width
  // viewport). A negative budget is not harmless: it is used below as the
  // "extent" argument of the children's intrinsic queries — the framework
  // asserts `getMaxIntrinsicWidth(negative)` — and it shrinks the space left
  // for flex and intrinsic tracks. Clamp it here, once, at the source.
  double remainingWidth = constraints.hasBoundedWidth
      ? max(0.0, constraints.maxWidth - fixedWidth)
      : double.infinity;
  double remainingHeight = constraints.hasBoundedHeight
      ? max(0.0, constraints.maxHeight - fixedHeight)
      : double.infinity;

  // Intrinsic pass (uses the running row/column extents).
  for (final RenderBox child in reversedChildren) {
    final TableParentData parentData = child.parentData! as TableParentData;
    if (parentData.computeSize) {
      final int? column = parentData.column;
      final int? row = parentData.row;
      if (column != null && row != null) {
        final TableSize widthConstraint = width(column);
        final TableSize heightConstraint = height(row);
        if (widthConstraint is IntrinsicTableSize ||
            (widthConstraint is FlexTableSize && intrinsicComputer != null)) {
          final double extent = rowHeights[row] ?? remainingHeight;
          double intrinsic = intrinsicComputer != null
              ? intrinsicComputer(child, extent)
              : child.getMaxIntrinsicWidth(extent);
          intrinsic = min(intrinsic, remainingWidth);
          final int columnSpan = parentData.columnSpan ?? 1;
          intrinsic = intrinsic / columnSpan;
          for (int i = 0; i < columnSpan; i++) {
            columnWidths[column + i] = max(
              columnWidths[column + i] ?? 0,
              intrinsic,
            );
          }
        }
        if (heightConstraint is IntrinsicTableSize ||
            (heightConstraint is FlexTableSize && intrinsicComputer != null)) {
          final double extent = columnWidths[column] ?? remainingWidth;
          double intrinsic = intrinsicComputer != null
              ? intrinsicComputer(child, extent)
              : child.getMaxIntrinsicHeight(extent);
          intrinsic = min(intrinsic, remainingHeight);
          final int rowSpan = parentData.rowSpan ?? 1;
          intrinsic = intrinsic / rowSpan;
          for (int i = 0; i < rowSpan; i++) {
            rowHeights[row + i] = max(rowHeights[row + i] ?? 0, intrinsic);
          }
        }
      }
    }
  }

  final double usedColumnWidth = columnWidths.values.fold(0, (a, b) => a + b);
  final double usedRowHeight = rowHeights.values.fold(0, (a, b) => a + b);
  double looseRemainingWidth = remainingWidth;
  double looseRemainingHeight = remainingHeight;
  double spacePerFlexWidth = 0;
  double spacePerFlexHeight = 0;
  double looseSpacePerFlexWidth = 0;
  double looseSpacePerFlexHeight = 0;

  if (intrinsicComputer == null) {
    remainingWidth = constraints.hasBoundedWidth
        ? max(0.0, constraints.maxWidth - usedColumnWidth)
        : double.infinity;
    looseRemainingWidth = constraints.hasInfiniteWidth
        ? double.infinity
        : max(0, constraints.minWidth - usedColumnWidth);
    remainingHeight = constraints.hasBoundedHeight
        ? max(0.0, constraints.maxHeight - usedRowHeight)
        : double.infinity;
    looseRemainingHeight = constraints.hasInfiniteHeight
        ? double.infinity
        : max(0, constraints.minHeight - usedRowHeight);
    if (flexWidth > 0 && remainingWidth > 0) {
      spacePerFlexWidth = remainingWidth / flexWidth;
    }
    if (flexWidth > 0 && looseRemainingWidth > 0) {
      looseSpacePerFlexWidth = looseRemainingWidth / flexWidth;
    }
    if (flexHeight > 0 && remainingHeight > 0) {
      spacePerFlexHeight = remainingHeight / flexHeight;
    }
    // Old bug fixed: this wrote to `spacePerFlexHeight`, so a loose flex row
    // used the tight budget.
    if (flexHeight > 0 && looseRemainingHeight > 0) {
      looseSpacePerFlexHeight = looseRemainingHeight / flexHeight;
    }

    for (int c = 0; c <= maxColumn; c++) {
      final TableSize constraint = width(c);
      if (constraint is FlexTableSize) {
        // `performLayout` feeds these into `BoxConstraints.tightFor(width: …)`,
        // so a negative flex factor would assert there.
        columnWidths[c] = max(
          0.0,
          constraint.flex *
              (constraint.fit == FlexFit.tight || hasTightFlexWidth
                  ? spacePerFlexWidth
                  : looseSpacePerFlexWidth),
        );
      }
    }
    for (int r = 0; r <= maxRow; r++) {
      final TableSize constraint = height(r);
      if (constraint is FlexTableSize) {
        rowHeights[r] = max(
          0.0,
          constraint.flex *
              (constraint.fit == FlexFit.tight || hasTightFlexHeight
                  ? spacePerFlexHeight
                  : looseSpacePerFlexHeight),
        );
      }
    }
  }

  // Second intrinsic pass: intrinsic rows can now use resolved column widths.
  if (intrinsicComputer == null) {
    for (final RenderBox child in reversedChildren) {
      final TableParentData parentData = child.parentData! as TableParentData;
      if (parentData.computeSize) {
        final int? column = parentData.column;
        final int? row = parentData.row;
        if (column != null &&
            row != null &&
            height(row) is IntrinsicTableSize) {
          final int columnSpan = parentData.columnSpan ?? 1;
          double availableWidth = 0;
          for (int i = 0; i < columnSpan; i++) {
            availableWidth += columnWidths[column + i] ?? 0;
          }
          if (availableWidth > 0) {
            double intrinsic = child.getMaxIntrinsicHeight(availableWidth);
            intrinsic = min(intrinsic, remainingHeight);
            final int rowSpan = parentData.rowSpan ?? 1;
            intrinsic = intrinsic / rowSpan;
            for (int i = 0; i < rowSpan; i++) {
              rowHeights[row + i] = max(rowHeights[row + i] ?? 0, intrinsic);
            }
          }
        }
      }
    }
  }

  final List<double> columnWidthList = List<double>.generate(
    maxColumn + 1,
    (index) => columnWidths[index] ?? 0,
  );
  final List<double> rowHeightList = List<double>.generate(
    maxRow + 1,
    (index) => rowHeights[index] ?? 0,
  );
  return TableLayoutResult(
    columnWidths: columnWidthList,
    rowHeights: rowHeightList,
    remainingWidth: remainingWidth,
    remainingHeight: remainingHeight,
    remainingLooseWidth: looseRemainingWidth,
    remainingLooseHeight: looseRemainingHeight,
    hasTightFlexWidth: hasTightFlexWidth,
    hasTightFlexHeight: hasTightFlexHeight,
  );
}
