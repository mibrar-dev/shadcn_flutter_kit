// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// TableRow defines a reusable type for this registry module.
class TableRow {
  /// The cells contained in this row.
  final List<TableCell> cells;

  /// Theme applied to all cells in this row.
  final TableCellTheme? cellTheme;

  /// Whether this row is selected.
  final bool selected;

  /// Creates a [TableRow].
  const TableRow({required this.cells, this.cellTheme, this.selected = false});

  /// Builds the default theme for cells in this row.
  ///
  /// Creates a [TableCellTheme] with default styling when no explicit [cellTheme]
  /// is provided. The default theme includes:
  /// - Border with bottom line using theme border color
  /// - Background color that changes to muted on hover
  /// - Text style that becomes muted when disabled
  ///
  /// The theme uses [WidgetStateProperty] to adapt styling based on cell state
  /// (hovered, selected, disabled).
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context for accessing theme data
  ///
  /// Returns [TableCellTheme] with default or custom cell styling.
  TableCellTheme buildDefaultTheme(BuildContext context) {
    if (cellTheme != null) {
      return cellTheme!;
    }
    final theme = Theme.of(context);
    return TableCellTheme(
      border: WidgetStateProperty.resolveWith((states) {
        return Border(
          bottom: BorderSide(color: theme.colorScheme.border, width: 1),
        );
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered)
            ? theme.colorScheme.muted.withValues(alpha: 0.5)
            : null;
      }),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          color: states.contains(WidgetState.disabled)
              ? theme.colorScheme.muted
              : null,
        );
      }),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableRow &&
        /// Creates a `listEquals` instance.
        listEquals(other.cells, cells) &&
        other.cellTheme == cellTheme &&
        other.selected == selected;
  }

  @override
  int get hashCode {
    return Object.hash(cells, cellTheme, selected);
  }
}

/// Specialized row for table footers.
///
/// Extends [TableRow] with default styling appropriate for footer rows,
/// including muted background colors and custom hover effects.
///
/// Example:
/// ```dart
/// TableFooter(
///   cells: [
///     TableCell(child: Text('Total: \$100')),
///     TableCell(child: Text('Paid')),
///   ],
/// )
/// ```
