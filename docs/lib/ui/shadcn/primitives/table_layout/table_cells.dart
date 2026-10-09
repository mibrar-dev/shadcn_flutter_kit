// Generic cell-position helpers for the `table` component: a rectangular range
// with overlap testing and the span-aware cell reorganisation pass.
//
// Extracted from the old `table_cell_data.dart` + `hovered_cell.dart` so the
// component file stays small. Independent of the component's theme.

import 'dart:math';

import 'package:flutter/widgets.dart';

/// A cell's grid position and span.
abstract interface class TableCellPosition {
  /// Column index.
  int get column;

  /// Row index.
  int get row;

  /// Number of columns spanned.
  int get columnSpan;

  /// Number of rows spanned.
  int get rowSpan;

  /// A copy moved by [column], [row] cells.
  TableCellPosition shift(int column, int row);
}

/// The span fields a table cell model exposes to [flattenTableCells].
abstract interface class TableCellLike {
  /// Number of columns spanned.
  int get columnSpan;

  /// Number of rows spanned.
  int get rowSpan;
}

/// The fields a table row model exposes to [flattenTableCells].
abstract interface class TableRowLike<T extends TableCellLike> {
  /// Cells of the row.
  List<T> get cells;

  /// Whether the row is selected.
  bool get selected;
}

/// A cell flattened to its grid position.
class FlatTableCell<T extends TableCellLike> implements TableCellPosition {
  /// Creates a flat cell.
  const FlatTableCell({
    required this.column,
    required this.row,
    required this.columnSpan,
    required this.rowSpan,
    required this.cell,
    required this.selected,
  });

  @override
  final int column;
  @override
  final int row;
  @override
  final int columnSpan;
  @override
  final int rowSpan;

  /// The underlying cell model.
  final T cell;

  /// Whether the owning row is selected.
  final bool selected;

  @override
  FlatTableCell<T> shift(int column, int row) => FlatTableCell<T>(
    column: this.column + column,
    row: this.row + row,
    columnSpan: columnSpan,
    rowSpan: rowSpan,
    cell: cell,
    selected: selected,
  );
}

/// Flattens [rows] into positioned cells and shifts span collisions right.
List<FlatTableCell<T>> flattenTableCells<
  T extends TableCellLike,
  R extends TableRowLike<T>
>(List<R> rows) {
  final List<FlatTableCell<T>> cells = <FlatTableCell<T>>[];
  for (int r = 0; r < rows.length; r++) {
    final R row = rows[r];
    for (int c = 0; c < row.cells.length; c++) {
      final T cell = row.cells[c];
      cells.add(
        FlatTableCell<T>(
          column: c,
          row: r,
          columnSpan: cell.columnSpan,
          rowSpan: cell.rowSpan,
          cell: cell,
          selected: row.selected,
        ),
      );
    }
  }
  return reorganizeCells(cells);
}

/// A rectangular range of cells.
class TableCellRange {
  /// Creates a range.
  const TableCellRange(this.column, this.row, this.columnSpan, this.rowSpan);

  /// Left column.
  final int column;

  /// Top row.
  final int row;

  /// Number of columns.
  final int columnSpan;

  /// Number of rows.
  final int rowSpan;

  /// Whether this range overlaps [other] along [axis].
  ///
  /// [Axis.vertical] compares columns, [Axis.horizontal] compares rows.
  bool intersects(TableCellRange other, Axis axis) {
    if (other.column == column &&
        other.row == row &&
        other.columnSpan == columnSpan &&
        other.rowSpan == rowSpan) {
      return true;
    }
    if (axis == Axis.vertical) {
      return column < other.column + other.columnSpan &&
          column + columnSpan > other.column;
    }
    return row < other.row + other.rowSpan && row + rowSpan > other.row;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableCellRange &&
          other.column == column &&
          other.row == row &&
          other.columnSpan == columnSpan &&
          other.rowSpan == rowSpan;

  @override
  int get hashCode => Object.hash(column, row, columnSpan, rowSpan);
}

/// Shifts cells that collide with a spanning cell to the right.
List<T> reorganizeCells<T extends TableCellPosition>(List<T> cells) {
  int maxColumn = 0;
  int maxRow = 0;
  final Map<int, Map<int, T>> cellMap = <int, Map<int, T>>{};
  for (final T cell in cells) {
    maxColumn = max(maxColumn, cell.column + cell.columnSpan - 1);
    maxRow = max(maxRow, cell.row + cell.rowSpan - 1);
    cellMap.putIfAbsent(cell.column, () => <int, T>{})[cell.row] = cell;
  }

  for (int c = maxColumn; c >= 0; c--) {
    for (int r = maxRow; r >= 0; r--) {
      final T? cell = cellMap[c]?[r];
      if (cell == null) {
        continue;
      }
      for (int i = maxColumn; i >= cell.column; i--) {
        if (cellMap[i]?[r] == null) {
          continue;
        }
        for (int row = r; row < r + cell.rowSpan; row++) {
          if (i == cell.column && row == r) {
            continue;
          }
          final T? rightCell = cellMap[i]?[row];
          if (rightCell != null) {
            cellMap[i]!.remove(row);
            if (row != r) {
              cellMap.putIfAbsent(i + cell.columnSpan, () => <int, T>{})[row] =
                  rightCell.shift(cell.columnSpan, 0) as T;
            } else {
              cellMap.putIfAbsent(
                i + cell.columnSpan - 1,
                () => <int, T>{},
              )[row] = rightCell.shift(cell.columnSpan - 1, 0) as T;
            }
          }
        }
      }
    }
  }

  final List<T> result = <T>[];
  for (final Map<int, T> column in cellMap.values) {
    result.addAll(column.values);
  }
  return result;
}
