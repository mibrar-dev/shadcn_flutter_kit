// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../table.dart';

/// Type alias for `TableCellThemeBuilder` used by public or internal APIs.
typedef TableCellThemeBuilder = TableCellTheme Function(BuildContext context);

/// Represents a row in a table.
///
/// Contains a list of cells and optional styling for all cells in the row.
/// Can be marked as selected to highlight the entire row.
///
/// Example:
/// ```dart
/// TableRow(
///   cells: [
///     TableCell(child: Text('Cell 1')),
///     TableCell(child: Text('Cell 2')),
///   ],
///   selected: true,
///   cellTheme: TableCellTheme(...),
/// )
/// ```
