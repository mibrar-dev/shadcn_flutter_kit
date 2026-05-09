// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// ResizableTableController defines a reusable type for this registry module.
class ResizableTableController extends ChangeNotifier {
  /// Stores `_columnWidths` state/configuration for this implementation.
  Map<int, double>? _columnWidths;

  /// Stores `_rowHeights` state/configuration for this implementation.
  Map<int, double>? _rowHeights;

  /// Stores `_defaultColumnWidth` state/configuration for this implementation.
  final double _defaultColumnWidth;

  /// Stores `_defaultRowHeight` state/configuration for this implementation.
  final double _defaultRowHeight;

  /// Stores `_defaultWidthConstraint` state/configuration for this implementation.
  final ConstrainedTableSize? _defaultWidthConstraint;

  /// Stores `_defaultHeightConstraint` state/configuration for this implementation.
  final ConstrainedTableSize? _defaultHeightConstraint;

  /// Stores `_widthConstraints` state/configuration for this implementation.
  final Map<int, ConstrainedTableSize>? _widthConstraints;

  /// Stores `_heightConstraints` state/configuration for this implementation.
  final Map<int, ConstrainedTableSize>? _heightConstraints;

  /// Creates a controller for managing resizable table dimensions.
  ///
  /// This controller manages column widths and row heights with support for
  /// constraints and dynamic resizing. It provides methods to resize individual
  /// columns/rows or adjust shared borders between adjacent columns/rows.
  ///
  /// Parameters:
  /// - [columnWidths] (`Map<int, double>?`): Initial column widths by index
  /// - [defaultColumnWidth] (double, required): Default width for columns without explicit width
  /// - [rowHeights] (`Map<int, double>?`): Initial row heights by index
  /// - [defaultRowHeight] (double, required): Default height for rows without explicit height
  /// - [defaultWidthConstraint] (ConstrainedTableSize?): Default width constraints applied to all columns
  /// - [defaultHeightConstraint] (ConstrainedTableSize?): Default height constraints applied to all rows
  /// - [widthConstraints] (`Map<int, ConstrainedTableSize>?`): Per-column width constraints
  /// - [heightConstraints] (`Map<int, ConstrainedTableSize>?`): Per-row height constraints
  ///
  /// Example:
  /// ```dart
  /// ResizableTableController(
  ///   defaultColumnWidth: 100,
  ///   defaultRowHeight: 40,
  ///   widthConstraints: {
  ///     0: ConstrainedTableSize(min: 80, max: 200),
  ///   },
  /// )
  /// ```
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

  /// Resizes a specific column to a new width.
  ///
  /// Parameters:
  /// - [column] (`int`, required): Column index.
  /// - [width] (`double`, required): New width in pixels.
  ///
  /// Returns: `bool` — true if resize succeeded, false otherwise.
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
    _columnWidths ??= {};
    _columnWidths![column] = width;
    notifyListeners();
    return true;
  }

  /// Resizes adjacent columns by dragging their shared border.
  ///
  /// Parameters:
  /// - [previousColumn] (`int`, required): Index of column before border.
  /// - [nextColumn] (`int`, required): Index of column after border.
  /// - [deltaWidth] (`double`, required): Width change in pixels.
  ///
  /// Returns: `double` — actual width change applied.
  double resizeColumnBorder(
    int previousColumn,
    int nextColumn,
    double deltaWidth,
  ) {
    if (previousColumn < 0 || nextColumn < 0 || deltaWidth == 0) {
      return 0;
    }
    // make sure that both previous and next column have width enough to resize
    /// Stores `previousWidth` state/configuration for this implementation.
    var previousWidth = _columnWidths?[previousColumn] ?? _defaultColumnWidth;

    /// Stores `newPreviousWidth` state/configuration for this implementation.
    double newPreviousWidth = previousWidth + deltaWidth;

    /// Stores `nextWidth` state/configuration for this implementation.
    var nextWidth = _columnWidths?[nextColumn] ?? _defaultColumnWidth;

    /// Stores `newNextWidth` state/configuration for this implementation.
    double newNextWidth = nextWidth - deltaWidth;
    double clampedPreviousWidth = newPreviousWidth.clamp(
      _widthConstraints?[previousColumn]?.min ??
          _defaultWidthConstraint?.min ??
          0,
      _widthConstraints?[previousColumn]?.max ??
          _defaultWidthConstraint?.max ??
          double.infinity,
    );
    double clampedNextWidth = newNextWidth.clamp(
      _widthConstraints?[nextColumn]?.min ?? _defaultWidthConstraint?.min ?? 0,
      _widthConstraints?[nextColumn]?.max ??
          _defaultWidthConstraint?.max ??
          double.infinity,
    );

    /// Stores `previousDelta` state/configuration for this implementation.
    double previousDelta = clampedPreviousWidth - previousWidth;

    /// Stores `nextDelta` state/configuration for this implementation.
    double nextDelta = clampedNextWidth - nextWidth;
    // find the delta that can be applied to both columns
    double delta = _absClosestTo(previousDelta, -nextDelta, 0);

    newPreviousWidth = previousWidth + delta;
    newNextWidth = nextWidth - delta;
    _columnWidths ??= {};
    _columnWidths![previousColumn] = newPreviousWidth;
    _columnWidths![nextColumn] = newNextWidth;
    notifyListeners();
    return delta;
  }

  /// Executes `_absClosestTo` behavior for this component/composite.
  double _absClosestTo(double a, double b, double target) {
    double absA = (a - target).abs();
    double absB = (b - target).abs();
    return absA < absB ? a : b;
  }

  /// Resizes adjacent rows by dragging their shared border.
  ///
  /// Parameters:
  /// - [previousRow] (`int`, required): Index of row before border.
  /// - [nextRow] (`int`, required): Index of row after border.
  /// - [deltaHeight] (`double`, required): Height change in pixels.
  ///
  /// Returns: `double` — actual height change applied.
  double resizeRowBorder(int previousRow, int nextRow, double deltaHeight) {
    if (previousRow < 0 || nextRow < 0 || deltaHeight == 0) {
      return 0;
    }
    // make sure that both previous and next row have height enough to resize
    /// Stores `previousHeight` state/configuration for this implementation.
    var previousHeight = _rowHeights?[previousRow] ?? _defaultRowHeight;

    /// Stores `newPreviousHeight` state/configuration for this implementation.
    double newPreviousHeight = previousHeight + deltaHeight;

    /// Stores `nextHeight` state/configuration for this implementation.
    var nextHeight = _rowHeights?[nextRow] ?? _defaultRowHeight;

    /// Stores `newNextHeight` state/configuration for this implementation.
    double newNextHeight = nextHeight - deltaHeight;
    double clampedPreviousHeight = newPreviousHeight.clamp(
      _heightConstraints?[previousRow]?.min ??
          _defaultHeightConstraint?.min ??
          0,
      _heightConstraints?[previousRow]?.max ??
          _defaultHeightConstraint?.max ??
          double.infinity,
    );
    double clampedNextHeight = newNextHeight.clamp(
      _heightConstraints?[nextRow]?.min ?? _defaultHeightConstraint?.min ?? 0,
      _heightConstraints?[nextRow]?.max ??
          _defaultHeightConstraint?.max ??
          double.infinity,
    );

    /// Stores `previousDelta` state/configuration for this implementation.
    double previousDelta = clampedPreviousHeight - previousHeight;

    /// Stores `nextDelta` state/configuration for this implementation.
    double nextDelta = clampedNextHeight - nextHeight;
    // find the delta that can be applied to both rows
    double delta = _absClosestTo(previousDelta, -nextDelta, 0);

    newPreviousHeight = previousHeight + delta;
    newNextHeight = nextHeight - delta;
    _rowHeights ??= {};
    _rowHeights![previousRow] = newPreviousHeight;
    _rowHeights![nextRow] = newNextHeight;
    notifyListeners();
    return delta;
  }

  /// Resizes a specific row to a new height.
  ///
  /// Parameters:
  /// - [row] (`int`, required): Row index.
  /// - [height] (`double`, required): New height in pixels.
  ///
  /// Returns: `bool` — true if resize succeeded, false otherwise.
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
    _rowHeights ??= {};
    _rowHeights![row] = height;
    notifyListeners();
    return true;
  }

  /// Gets an unmodifiable map of custom column widths.
  ///
  /// Returns: `Map<int, double>?` — map of column indices to widths, or null if none set.
  Map<int, double>? get columnWidths => _columnWidths == null
      ? null
      : Map<int, double>.unmodifiable(_columnWidths!);

  /// Gets an unmodifiable map of custom row heights.
  ///
  /// Returns: `Map<int, double>?` — map of row indices to heights, or null if none set.
  Map<int, double>? get rowHeights =>
      _rowHeights == null ? null : Map<int, double>.unmodifiable(_rowHeights!);

  /// Gets the width of a specific column.
  ///
  /// Parameters:
  /// - [index] (`int`, required): Column index.
  ///
  /// Returns: `double` — column width in pixels.
  double getColumnWidth(int index) {
    return _columnWidths?[index] ?? _defaultColumnWidth;
  }

  /// Gets the height of a specific row.
  ///
  /// Parameters:
  /// - [index] (`int`, required): Row index.
  ///
  /// Returns: `double` — row height in pixels.
  double getRowHeight(int index) {
    return _rowHeights?[index] ?? _defaultRowHeight;
  }

  /// Gets the minimum height constraint for a specific row.
  ///
  /// Parameters:
  /// - [index] (`int`, required): Row index.
  ///
  /// Returns: `double?` — minimum height, or null if unconstrained.
  double? getRowMinHeight(int index) {
    return _heightConstraints?[index]?.min ?? _defaultHeightConstraint?.min;
  }

  /// Gets the maximum height constraint for a specific row.
  ///
  /// Parameters:
  /// - [index] (`int`, required): Row index.
  ///
  /// Returns: `double?` — maximum height, or null if unconstrained.
  double? getRowMaxHeight(int index) {
    return _heightConstraints?[index]?.max ?? _defaultHeightConstraint?.max;
  }

  /// Gets the minimum width constraint for a specific column.
  ///
  /// Parameters:
  /// - [index] (`int`, required): Column index.
  ///
  /// Returns: `double?` — minimum width, or null if unconstrained.
  double? getColumnMinWidth(int index) {
    return _widthConstraints?[index]?.min ?? _defaultWidthConstraint?.min;
  }

  /// Gets the maximum width constraint for a specific column.
  ///
  /// Parameters:
  /// - [index] (`int`, required): Column index.
  ///
  /// Returns: `double?` — maximum width, or null if unconstrained.
  double? getColumnMaxWidth(int index) {
    return _widthConstraints?[index]?.max ?? _defaultWidthConstraint?.max;
  }
}

/// Defines how table cells should resize.
///
/// Determines the behavior when a table cell is resized by the user.
