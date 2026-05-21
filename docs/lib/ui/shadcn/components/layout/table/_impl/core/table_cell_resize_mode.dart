// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// TableCellResizeMode enumerates fixed values used by this implementation.
enum TableCellResizeMode {
  /// The cell size will expand when resized
  expand,

  /// The cell size will expand when resized, but the other cells will shrink
  reallocate,

  /// Disables resizing
  none,
}

/// A table widget with resizable columns and rows.
///
/// Displays tabular data with interactive row and column resizing capabilities.
/// Supports frozen rows/columns, custom resize modes, and scrolling viewports.
///
/// Example:
/// ```dart
/// ResizableTable(
///   controller: ResizableTableController(),
///   rows: [
///     TableRow(children: [Text('Cell 1'), Text('Cell 2')]),
///     TableRow(children: [Text('Cell 3'), Text('Cell 4')]),
///   ],
/// )
/// ```
