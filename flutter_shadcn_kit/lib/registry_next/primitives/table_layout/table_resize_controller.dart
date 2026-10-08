// Column/row sizing controller for the `table` component.
//
// Ported from the old `resizable_table_controller.dart`. Extracted into its own
// primitive file so `table_resize.dart` (the handles) stays small.

import 'package:flutter/widgets.dart';

import 'table_layout.dart';

/// Programmatic column-width and row-height state for a resizable table.
///
/// Notifies listeners when a column or row changes so the table can relayout.
class ResizableTableController extends ChangeNotifier {
  /// Creates a controller.
  ResizableTableController({
    Map<int, double>? columnWidths,
    required double defaultColumnWidth,
    Map<int, double>? rowHeights,
    required double defaultRowHeight,
    ConstrainedTableSize? defaultWidthConstraint,
    ConstrainedTableSize? defaultHeightConstraint,
    Map<int, ConstrainedTableSize>? widthConstraints,
    Map<int, ConstrainedTableSize>? heightConstraints,
  }) : _columnWidths = columnWidths,
       _rowHeights = rowHeights,
       _defaultColumnWidth = defaultColumnWidth,
       _defaultRowHeight = defaultRowHeight,
       _widthConstraints = widthConstraints,
       _heightConstraints = heightConstraints,
       _defaultWidthConstraint = defaultWidthConstraint,
       _defaultHeightConstraint = defaultHeightConstraint;

  Map<int, double>? _columnWidths;
  Map<int, double>? _rowHeights;
  final double _defaultColumnWidth;
  final double _defaultRowHeight;
  final ConstrainedTableSize? _defaultWidthConstraint;
  final ConstrainedTableSize? _defaultHeightConstraint;
  final Map<int, ConstrainedTableSize>? _widthConstraints;
  final Map<int, ConstrainedTableSize>? _heightConstraints;

  /// Resizes [column] to [width]; returns whether the value changed.
  bool resizeColumn(int column, double width) {
    if (column < 0 || width < 0) {
      return false;
    }
    width = width.clamp(
      _widthConstraints?[column]?.min ?? _defaultWidthConstraint?.min ?? 0,
      _widthConstraints?[column]?.max ??
          _defaultWidthConstraint?.max ??
          double.infinity,
    );
    if (_columnWidths != null && _columnWidths![column] == width) {
      return false;
    }
    _columnWidths ??= <int, double>{};
    _columnWidths![column] = width;
    notifyListeners();
    return true;
  }

  /// Resizes [row] to [height]; returns whether the value changed.
  bool resizeRow(int row, double height) {
    if (row < 0 || height < 0) {
      return false;
    }
    height = height.clamp(
      _heightConstraints?[row]?.min ?? _defaultHeightConstraint?.min ?? 0,
      _heightConstraints?[row]?.max ??
          _defaultHeightConstraint?.max ??
          double.infinity,
    );
    if (_rowHeights != null && _rowHeights![row] == height) {
      return false;
    }
    _rowHeights ??= <int, double>{};
    _rowHeights![row] = height;
    notifyListeners();
    return true;
  }

  /// Moves [deltaWidth] across the border between two columns.
  double resizeColumnBorder(
    int previousColumn,
    int nextColumn,
    double deltaWidth,
  ) {
    if (previousColumn < 0 || nextColumn < 0 || deltaWidth == 0) {
      return 0;
    }
    final double previousWidth =
        _columnWidths?[previousColumn] ?? _defaultColumnWidth;
    final double nextWidth = _columnWidths?[nextColumn] ?? _defaultColumnWidth;
    final double previousDelta =
        _clampColumn(previousColumn, previousWidth + deltaWidth) -
        previousWidth;
    final double nextDelta =
        _clampColumn(nextColumn, nextWidth - deltaWidth) - nextWidth;
    final double delta = _closestToZero(previousDelta, -nextDelta);
    _columnWidths ??= <int, double>{};
    _columnWidths![previousColumn] = previousWidth + delta;
    _columnWidths![nextColumn] = nextWidth - delta;
    notifyListeners();
    return delta;
  }

  /// Moves [deltaHeight] across the border between two rows.
  double resizeRowBorder(int previousRow, int nextRow, double deltaHeight) {
    if (previousRow < 0 || nextRow < 0 || deltaHeight == 0) {
      return 0;
    }
    final double previousHeight =
        _rowHeights?[previousRow] ?? _defaultRowHeight;
    final double nextHeight = _rowHeights?[nextRow] ?? _defaultRowHeight;
    final double previousDelta =
        _clampRow(previousRow, previousHeight + deltaHeight) - previousHeight;
    final double nextDelta =
        _clampRow(nextRow, nextHeight - deltaHeight) - nextHeight;
    final double delta = _closestToZero(previousDelta, -nextDelta);
    _rowHeights ??= <int, double>{};
    _rowHeights![previousRow] = previousHeight + delta;
    _rowHeights![nextRow] = nextHeight - delta;
    notifyListeners();
    return delta;
  }

  double _clampColumn(int index, double value) {
    return value.clamp(
      _widthConstraints?[index]?.min ?? _defaultWidthConstraint?.min ?? 0,
      _widthConstraints?[index]?.max ??
          _defaultWidthConstraint?.max ??
          double.infinity,
    );
  }

  double _clampRow(int index, double value) {
    return value.clamp(
      _heightConstraints?[index]?.min ?? _defaultHeightConstraint?.min ?? 0,
      _heightConstraints?[index]?.max ??
          _defaultHeightConstraint?.max ??
          double.infinity,
    );
  }

  static double _closestToZero(double a, double b) {
    return a.abs() < b.abs() ? a : b;
  }

  /// Unmodifiable custom column widths, or null when none were set.
  Map<int, double>? get columnWidths => _columnWidths == null
      ? null
      : Map<int, double>.unmodifiable(_columnWidths!);

  /// Unmodifiable custom row heights, or null when none were set.
  Map<int, double>? get rowHeights =>
      _rowHeights == null ? null : Map<int, double>.unmodifiable(_rowHeights!);

  /// Width of [index].
  double getColumnWidth(int index) =>
      _columnWidths?[index] ?? _defaultColumnWidth;

  /// Height of [index].
  double getRowHeight(int index) => _rowHeights?[index] ?? _defaultRowHeight;

  /// Minimum height of [index], if constrained.
  double? getRowMinHeight(int index) =>
      _heightConstraints?[index]?.min ?? _defaultHeightConstraint?.min;

  /// Maximum height of [index], if constrained.
  double? getRowMaxHeight(int index) =>
      _heightConstraints?[index]?.max ?? _defaultHeightConstraint?.max;

  /// Minimum width of [index], if constrained.
  double? getColumnMinWidth(int index) =>
      _widthConstraints?[index]?.min ?? _defaultWidthConstraint?.min;

  /// Maximum width of [index], if constrained.
  double? getColumnMaxWidth(int index) =>
      _widthConstraints?[index]?.max ?? _defaultWidthConstraint?.max;
}
