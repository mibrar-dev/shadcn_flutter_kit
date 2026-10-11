// The table layout render object: sizes columns and rows from [TableSize]
// strategies and positions each cell on the grid.
//
// Ported from the old `render_table_layout_part1.dart`. Old bugs fixed:
//  * `computeTableSize` wrote the loose flex height into `spacePerFlexHeight`,
//    so a loose flex row used the tight budget; the loose value is written to
//    `looseSpacePerFlexHeight`.
//  * `hitTestChildren` walked the children first-to-last (comment claimed the
//    reverse), so a cell covered by a later sibling still won the hit; it now
//    walks last-to-first, matching paint order.
//  * `paint` pushed a clip layer per frozen group and then repainted the
//    frozen groups a second time outside the clip; each cell is painted once.

import 'dart:math';

import 'package:flutter/rendering.dart';

import 'table_layout.dart';
import 'table_layout_sizing.dart';

/// Render object for [RawTableLayout].
class RenderTableLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TableParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TableParentData> {
  /// Creates a table layout render object.
  RenderTableLayout({
    List<RenderBox>? children,
    required this._width,
    required this._height,
    required this._clipBehavior,
    this._frozenColumn,
    this._frozenRow,
    this._verticalOffset,
    this._horizontalOffset,
    this._viewportSize,
    this._textDirection = TextDirection.ltr,
  }) {
    addAll(children);
  }

  TableSizeSupplier _width;
  TableSizeSupplier _height;
  Clip _clipBehavior;
  CellPredicate? _frozenColumn;
  CellPredicate? _frozenRow;
  double? _verticalOffset;
  double? _horizontalOffset;
  Size? _viewportSize;
  TextDirection _textDirection;
  TableLayoutResult? _layoutResult;

  /// Column width supplier.
  set width(TableSizeSupplier value) {
    if (_width != value) {
      _width = value;
      markNeedsLayout();
    }
  }

  /// Row height supplier.
  set height(TableSizeSupplier value) {
    if (_height != value) {
      _height = value;
      markNeedsLayout();
    }
  }

  /// How content is clipped.
  set clipBehavior(Clip value) {
    if (_clipBehavior != value) {
      _clipBehavior = value;
      markNeedsLayout();
    }
  }

  /// Frozen column predicate.
  set frozenColumn(CellPredicate? value) {
    if (_frozenColumn != value) {
      _frozenColumn = value;
      markNeedsLayout();
    }
  }

  /// Frozen row predicate.
  set frozenRow(CellPredicate? value) {
    if (_frozenRow != value) {
      _frozenRow = value;
      markNeedsLayout();
    }
  }

  /// Vertical scroll offset.
  set verticalOffset(double? value) {
    if (_verticalOffset != value) {
      _verticalOffset = value;
      markNeedsLayout();
    }
  }

  /// Horizontal scroll offset.
  set horizontalOffset(double? value) {
    if (_horizontalOffset != value) {
      _horizontalOffset = value;
      markNeedsLayout();
    }
  }

  /// Visible viewport size.
  set viewportSize(Size? value) {
    if (_viewportSize != value) {
      _viewportSize = value;
      markNeedsLayout();
    }
  }

  /// Direction columns run in.
  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! TableParentData) {
      child.parentData = TableParentData();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // Walk last-to-first so a cell covered by a later sibling (row/column
    // spans) loses the hit, matching paint order.
    RenderBox? child = lastChild;
    while (child != null) {
      final TableParentData parentData = child.parentData! as TableParentData;
      final bool hit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) =>
            child!.hitTest(result, position: transformed),
      );
      if (hit) {
        return true;
      }
      child = childBefore(child);
    }
    return false;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return computeTableSize(constraints).size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void paintGroup(bool Function(TableParentData) test) {
      RenderBox? child = lastChild;
      while (child != null) {
        final TableParentData parentData = child.parentData! as TableParentData;
        if (test(parentData)) {
          context.paintChild(child, offset + parentData.offset);
        }
        child = childBefore(child);
      }
    }

    if (_clipBehavior == Clip.none) {
      paintGroup((pd) => !pd.frozenRow && !pd.frozenColumn);
      paintGroup((pd) => pd.frozenColumn && !pd.frozenRow);
      paintGroup((pd) => pd.frozenRow);
      return;
    }
    void clipped(bool Function(TableParentData) test) {
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, (
        context,
        offset,
      ) {
        RenderBox? child = lastChild;
        while (child != null) {
          final TableParentData parentData =
              child.parentData! as TableParentData;
          if (test(parentData)) {
            context.paintChild(child, offset + parentData.offset);
          }
          child = childBefore(child);
        }
      }, clipBehavior: _clipBehavior);
    }

    clipped((pd) => !pd.frozenRow && !pd.frozenColumn);
    clipped((pd) => pd.frozenColumn && !pd.frozenRow);
    clipped((pd) => pd.frozenRow);
  }

  @override
  void performLayout() {
    final TableLayoutResult result = computeTableSize(constraints);
    size = constraints.constrain(result.size);

    final Map<int, double> frozenRows = <int, double>{};
    final Map<int, double> frozenColumns = <int, double>{};

    double effectiveHorizontalOffset = _horizontalOffset ?? 0;
    double effectiveVerticalOffset = _verticalOffset ?? 0;
    if (_viewportSize != null) {
      effectiveHorizontalOffset = effectiveHorizontalOffset.clamp(
        0,
        max(0, size.width - _viewportSize!.width),
      );
      effectiveVerticalOffset = effectiveVerticalOffset.clamp(
        0,
        max(0, size.height - _viewportSize!.height),
      );
    } else {
      effectiveHorizontalOffset = max(0, effectiveHorizontalOffset);
      effectiveVerticalOffset = max(0, effectiveVerticalOffset);
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final TableParentData parentData = child.parentData! as TableParentData;
      final int? column = parentData.column;
      final int? row = parentData.row;
      if (column != null && row != null) {
        final int columnSpan = parentData.columnSpan ?? 1;
        final int rowSpan = parentData.rowSpan ?? 1;
        final bool frozenRow = _frozenRow?.call(row, rowSpan) ?? false;
        final bool frozenColumn =
            _frozenColumn?.call(column, columnSpan) ?? false;
        double cellWidth = 0;
        for (
          int i = 0;
          i < columnSpan && column + i < result.columnWidths.length;
          i++
        ) {
          cellWidth += result.columnWidths[column + i];
        }
        double cellHeight = 0;
        for (
          int i = 0;
          i < rowSpan && row + i < result.rowHeights.length;
          i++
        ) {
          cellHeight += result.rowHeights[row + i];
        }
        child.layout(
          BoxConstraints.tightFor(width: cellWidth, height: cellHeight),
        );
        final Offset cellOffset = result.getOffset(column, row);
        double offsetX = cellOffset.dx;
        double offsetY = cellOffset.dy;

        if (frozenRow) {
          final double offsetInViewport =
              offsetY - (_viewportSize != null ? effectiveVerticalOffset : 0);
          double minViewport = 0;
          for (int i = 0; i < row; i++) {
            minViewport += frozenRows[i] ?? 0;
          }
          if (_viewportSize != null && effectiveVerticalOffset < 0) {
            offsetY += effectiveVerticalOffset;
          } else if (offsetInViewport < minViewport) {
            offsetY += -offsetInViewport + minViewport;
          }
          frozenRows[row] = max(frozenRows[row] ?? 0, cellHeight);
        }
        if (frozenColumn) {
          final double offsetInViewport =
              offsetX - (_viewportSize != null ? effectiveHorizontalOffset : 0);
          double minViewport = 0;
          for (int i = 0; i < column; i++) {
            minViewport += frozenColumns[i] ?? 0;
          }
          if (_viewportSize != null && effectiveHorizontalOffset < 0) {
            offsetX += effectiveHorizontalOffset;
          } else if (offsetInViewport < minViewport) {
            offsetX += -offsetInViewport + minViewport;
          }
          frozenColumns[column] = max(frozenColumns[column] ?? 0, cellWidth);
        }
        parentData.frozenRow = frozenRow;
        parentData.frozenColumn = frozenColumn;
        // Column indices stay logical; only the final offset is mirrored under
        // RTL, so the first column lands on the right edge.
        if (_textDirection == TextDirection.rtl) {
          offsetX = size.width - offsetX - cellWidth;
        }
        parentData.offset = Offset(offsetX, offsetY);
      }
      child = childAfter(child);
    }
    _layoutResult = result;
  }

  /// Computes the grid for [constraints].
  TableLayoutResult computeTableSize(
    BoxConstraints constraints, [
    IntrinsicComputer? intrinsicComputer,
  ]) {
    final List<RenderBox> children = <RenderBox>[];
    RenderBox? child = firstChild;
    while (child != null) {
      children.add(child);
      child = childAfter(child);
    }
    return computeTableLayout(
      constraints,
      _width,
      _height,
      children,
      children.reversed.toList(),
      intrinsicComputer,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return computeTableSize(
      BoxConstraints.loose(Size(double.infinity, height)),
      (child, extent) => child.getMinIntrinsicWidth(extent),
    ).width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return computeTableSize(
      BoxConstraints.loose(Size(double.infinity, height)),
      (child, extent) => child.getMaxIntrinsicWidth(extent),
    ).width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return computeTableSize(
      BoxConstraints.loose(Size(width, double.infinity)),
      (child, extent) => child.getMinIntrinsicHeight(extent),
    ).height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeTableSize(
      BoxConstraints.loose(Size(width, double.infinity)),
      (child, extent) => child.getMaxIntrinsicHeight(extent),
    ).height;
  }

  TableLayoutResult get _result {
    assert(_layoutResult != null, 'Layout result is not available');
    return _layoutResult!;
  }

  /// Computed width of each column.
  List<double> get columnWidths =>
      List<double>.unmodifiable(_result.columnWidths);

  /// Computed height of each row.
  List<double> get rowHeights => List<double>.unmodifiable(_result.rowHeights);

  /// Top-left offset of the cell at [column], [row].
  Offset getOffset(int column, int row) => _result.getOffset(column, row);

  /// Width left after fixed and flex columns.
  double get remainingWidth => _result.remainingWidth;

  /// Height left after fixed and flex rows.
  double get remainingHeight => _result.remainingHeight;

  /// Loose width left for loose flex columns.
  double get remainingLooseWidth => _result.remainingLooseWidth;

  /// Loose height left for loose flex rows.
  double get remainingLooseHeight => _result.remainingLooseHeight;

  /// Whether any column is tightly flexible.
  bool get hasTightFlexWidth => _result.hasTightFlexWidth;

  /// Whether any row is tightly flexible.
  bool get hasTightFlexHeight => _result.hasTightFlexHeight;
}
