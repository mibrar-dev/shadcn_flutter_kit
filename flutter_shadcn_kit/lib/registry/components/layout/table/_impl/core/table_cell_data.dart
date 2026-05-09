// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// _TableCellData defines a reusable type for this registry module.
abstract class _TableCellData {
  const _TableCellData();

  /// Stores `column` state/configuration for this implementation.
  int get column;

  /// Stores `row` state/configuration for this implementation.
  int get row;

  /// Stores `columnSpan` state/configuration for this implementation.
  int get columnSpan;

  /// Stores `rowSpan` state/configuration for this implementation.
  int get rowSpan;
  _TableCellData shift(int column, int row);
}

/// This will shift cell data if there are any overlapping cells due to column or row spans.
List<T> _reorganizeCells<T extends _TableCellData>(List<T> cells) {
  /// Stores `maxColumn` state/configuration for this implementation.
  int maxColumn = 0;

  /// Stores `maxRow` state/configuration for this implementation.
  int maxRow = 0;

  Map<int, Map<int, _TableCellData>> cellMap = {}; // column -> row -> cell

  // find the maximum row and column
  for (final cell in cells) {
    maxColumn = max(maxColumn, cell.column + cell.columnSpan - 1);
    maxRow = max(maxRow, cell.row + cell.rowSpan - 1);
    cellMap.putIfAbsent(cell.column, () => {});
    cellMap[cell.column]![cell.row] = cell;
  }

  // shift from bottom right to top left
  for (int c = maxColumn; c >= 0; c--) {
    for (int r = maxRow; r >= 0; r--) {
      /// Stores `cell` state/configuration for this implementation.
      final cell = cellMap[c]?[r];
      if (cell != null) {
        // column span
        // shift to the right from end column to the current column + 1 (reverse)
        for (int i = maxColumn; i >= cell.column; i--) {
          /// Stores `rightCell` state/configuration for this implementation.
          final rightCell = cellMap[i]?[r];
          if (rightCell != null) {
            // repeat by rowSpan
            for (int row = r; row < r + cell.rowSpan; row++) {
              if (i == cell.column && row == r) {
                continue;
              }

              /// Stores `rightCell` state/configuration for this implementation.
              final rightCell = cellMap[i]?[row];
              if (rightCell != null) {
                // remove the cell from the map
                cellMap[i]!.remove(row);
                // shift the cell to the right (+ columnSpan)
                if (row != r) {
                  cellMap.putIfAbsent(i + cell.columnSpan, () => {});
                  cellMap[i + cell.columnSpan]![row] = rightCell.shift(
                    cell.columnSpan,
                    0,
                  );
                } else {
                  cellMap.putIfAbsent(i + cell.columnSpan - 1, () => {});
                  cellMap[i + cell.columnSpan - 1]![row] = rightCell.shift(
                    cell.columnSpan - 1,
                    0,
                  );
                }
              }
            }
          }
        }
      }
    }
  }

  /// Stores `result` state/configuration for this implementation.
  List<T> result = [];
  for (final column in cellMap.values) {
    result.addAll(column.values.cast<T>());
  }
  return result;
}
