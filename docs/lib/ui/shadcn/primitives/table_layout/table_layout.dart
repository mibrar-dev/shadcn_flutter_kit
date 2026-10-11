// Generic table layout machinery shared by the `table` component: sizing
// strategies, the cell parent data, the low-level layout widget and its
// result.
//
// Extracted from the old `layout/table` component (see
// `components/table/table.dart`) so the component file stays within the
// 400-line limit, mirroring the `slider` → `primitives/slider/` split. Nothing
// here reads the component's theme.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'table_layout_render.dart';

export 'table_layout_render.dart' show RenderTableLayout;

/// How one column or row is sized inside a table.
abstract base class TableSize {
  /// Const constructor for subclasses.
  const TableSize();
}

/// Sizes a column or row proportionally to its [flex] factor.
final class FlexTableSize extends TableSize {
  /// Creates a flexible size.
  const FlexTableSize({this.flex = 1, this.fit = FlexFit.tight});

  /// Flex factor.
  final double flex;

  /// Whether the item must fill its allocation.
  final FlexFit fit;
}

/// Sizes a column or row to a fixed pixel [value].
final class FixedTableSize extends TableSize {
  /// Creates a fixed size.
  const FixedTableSize(this.value);

  /// Size in logical pixels.
  final double value;
}

/// Sizes a column or row from the intrinsic size of its content.
final class IntrinsicTableSize extends TableSize {
  /// Creates an intrinsic size.
  const IntrinsicTableSize();
}

/// Sizes a column or row to a [fraction] of the table's extent.
final class FractionalTableSize extends TableSize {
  /// Creates a fractional size.
  const FractionalTableSize(this.fraction);

  /// Fraction of the bounded extent.
  final double fraction;
}

/// Supplies a [TableSize] for the column or row at [index].
typedef TableSizeSupplier = TableSize Function(int index);

/// Tests whether a column or row at [index] with [span] is selected.
typedef CellPredicate = bool Function(int index, int span);

/// Computes an intrinsic extent for a table child.
typedef IntrinsicComputer = double Function(RenderBox child, double extent);

/// A pinned row or column range.
class TableRef {
  /// Creates a reference to [span] rows/columns starting at [index].
  const TableRef(this.index, [this.span = 1]);

  /// First index of the range.
  final int index;

  /// Number of rows/columns in the range.
  final int span;

  /// Whether [index] falls inside this range.
  bool test(int index, int span) {
    return this.index <= index && this.index + this.span > index;
  }
}

/// Frozen rows and columns of a table.
class FrozenTableData {
  /// Creates frozen row/column ranges.
  const FrozenTableData({
    this.frozenRows = const <TableRef>[],
    this.frozenColumns = const <TableRef>[],
  });

  /// Rows kept visible during vertical scrolling.
  final Iterable<TableRef> frozenRows;

  /// Columns kept visible during horizontal scrolling.
  final Iterable<TableRef> frozenColumns;

  /// Whether the row at [index] with [span] is frozen.
  bool testRow(int index, int span) {
    for (final TableRef ref in frozenRows) {
      if (ref.test(index, span)) {
        return true;
      }
    }
    return false;
  }

  /// Whether the column at [index] with [span] is frozen.
  bool testColumn(int index, int span) {
    for (final TableRef ref in frozenColumns) {
      if (ref.test(index, span)) {
        return true;
      }
    }
    return false;
  }
}

/// Minimum and maximum extent for a resizable column or row.
class ConstrainedTableSize {
  /// Creates constraints; the defaults are unbounded.
  const ConstrainedTableSize({
    this.min = double.negativeInfinity,
    this.max = double.infinity,
  });

  /// Minimum extent.
  final double min;

  /// Maximum extent.
  final double max;
}

/// How a table cell resizes when its handle is dragged.
enum TableCellResizeMode {
  /// Only the dragged cell grows.
  expand,

  /// The dragged cell grows and its neighbour shrinks.
  reallocate,

  /// Resizing is disabled.
  none,
}

/// Parent data that positions one cell inside a table layout.
class TableParentData extends ContainerBoxParentData<RenderBox> {
  /// Column index of this cell.
  int? column;

  /// Row index of this cell.
  int? row;

  /// Number of columns this cell spans.
  int? columnSpan;

  /// Number of rows this cell spans.
  int? rowSpan;

  /// Whether this cell contributes to column/row sizing.
  bool computeSize = true;

  /// Whether this cell's row is frozen.
  bool frozenRow = false;

  /// Whether this cell's column is frozen.
  bool frozenColumn = false;
}

/// Result of one table layout pass.
class TableLayoutResult {
  /// Creates a layout result.
  TableLayoutResult({
    required this.columnWidths,
    required this.rowHeights,
    required this.remainingWidth,
    required this.remainingHeight,
    required this.remainingLooseWidth,
    required this.remainingLooseHeight,
    required this.hasTightFlexWidth,
    required this.hasTightFlexHeight,
  });

  /// Computed width of each column.
  final List<double> columnWidths;

  /// Computed height of each row.
  final List<double> rowHeights;

  /// Width left after fixed and flex columns.
  final double remainingWidth;

  /// Height left after fixed and flex rows.
  final double remainingHeight;

  /// Loose width left for loose flex columns.
  final double remainingLooseWidth;

  /// Loose height left for loose flex rows.
  final double remainingLooseHeight;

  /// Whether any column is tightly flexible.
  final bool hasTightFlexWidth;

  /// Whether any row is tightly flexible.
  final bool hasTightFlexHeight;

  /// Top-left offset of the cell at [column], [row].
  Offset getOffset(int column, int row) {
    double x = 0;
    for (int i = 0; i < column; i++) {
      x += columnWidths[i];
    }
    double y = 0;
    for (int i = 0; i < row; i++) {
      y += rowHeights[i];
    }
    return Offset(x, y);
  }

  /// Total size of the table.
  Size get size => Size(width, height);

  /// Sum of all column widths.
  double get width => columnWidths.fold(0, (a, b) => a + b);

  /// Sum of all row heights.
  double get height => rowHeights.fold(0, (a, b) => a + b);
}

/// Positions a child inside a [RawTableLayout].
class RawCell extends ParentDataWidget<TableParentData> {
  /// Creates a raw table cell.
  const RawCell({
    super.key,
    required this.column,
    required this.row,
    this.columnSpan,
    this.rowSpan,
    this.computeSize = true,
    required super.child,
  });

  /// Column index.
  final int column;

  /// Row index.
  final int row;

  /// Number of columns spanned.
  final int? columnSpan;

  /// Number of rows spanned.
  final int? rowSpan;

  /// Whether this cell contributes to column/row sizing.
  final bool computeSize;

  @override
  void applyParentData(RenderObject renderObject) {
    final TableParentData parentData =
        renderObject.parentData! as TableParentData;
    bool needsLayout = false;
    if (parentData.column != column) {
      parentData.column = column;
      needsLayout = true;
    }
    if (parentData.row != row) {
      parentData.row = row;
      needsLayout = true;
    }
    if (parentData.columnSpan != columnSpan) {
      parentData.columnSpan = columnSpan;
      needsLayout = true;
    }
    if (parentData.rowSpan != rowSpan) {
      parentData.rowSpan = rowSpan;
      needsLayout = true;
    }
    if (parentData.computeSize != computeSize) {
      parentData.computeSize = computeSize;
      needsLayout = true;
    }
    if (needsLayout) {
      (renderObject.parent as RenderTableLayout?)?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => RawTableLayout;
}

/// Low-level table layout widget.
///
/// Lays out [children] on a grid whose columns and rows are sized by [width]
/// and [height], with optional frozen rows/columns and scroll offsets.
class RawTableLayout extends MultiChildRenderObjectWidget {
  /// Creates a raw table layout.
  const RawTableLayout({
    super.key,
    super.children,
    required this.width,
    required this.height,
    required this.clipBehavior,
    this.frozenColumn,
    this.frozenRow,
    this.verticalOffset,
    this.horizontalOffset,
    this.viewportSize,
    this.textDirection = TextDirection.ltr,
  });

  /// Column width supplier.
  final TableSizeSupplier width;

  /// Row height supplier.
  final TableSizeSupplier height;

  /// How content is clipped.
  final Clip clipBehavior;

  /// Frozen column predicate.
  final CellPredicate? frozenColumn;

  /// Frozen row predicate.
  final CellPredicate? frozenRow;

  /// Vertical scroll offset.
  final double? verticalOffset;

  /// Horizontal scroll offset.
  final double? horizontalOffset;

  /// Size of the visible viewport.
  final Size? viewportSize;

  /// Direction columns run in (columns stay logical under RTL).
  final TextDirection textDirection;

  @override
  RenderTableLayout createRenderObject(BuildContext context) {
    return RenderTableLayout(
      width: width,
      height: height,
      clipBehavior: clipBehavior,
      frozenColumn: frozenColumn,
      frozenRow: frozenRow,
      verticalOffset: verticalOffset,
      horizontalOffset: horizontalOffset,
      viewportSize: viewportSize,
      textDirection: textDirection,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTableLayout renderObject,
  ) {
    renderObject
      ..width = width
      ..height = height
      ..clipBehavior = clipBehavior
      ..frozenColumn = frozenColumn
      ..frozenRow = frozenRow
      ..verticalOffset = verticalOffset
      ..horizontalOffset = horizontalOffset
      ..viewportSize = viewportSize
      ..textDirection = textDirection;
  }
}
