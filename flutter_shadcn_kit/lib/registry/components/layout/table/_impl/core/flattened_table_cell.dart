// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// _FlattenedTableCell defines a reusable type for this registry module.
class _FlattenedTableCell extends _TableCellData {
  @override
  /// Stores `column` state/configuration for this implementation.
  final int column;
  @override
  /// Stores `row` state/configuration for this implementation.
  final int row;
  @override
  /// Stores `columnSpan` state/configuration for this implementation.
  final int columnSpan;
  @override
  /// Stores `rowSpan` state/configuration for this implementation.
  final int rowSpan;

  /// Stores `builder` state/configuration for this implementation.
  final WidgetBuilder builder;

  /// Stores `enabled` state/configuration for this implementation.
  final bool enabled;

  /// Stores `hoveredCellNotifier` state/configuration for this implementation.
  final ValueNotifier<_HoveredCell?> hoveredCellNotifier;

  /// Stores `dragNotifier` state/configuration for this implementation.
  final ValueNotifier<_HoveredLine?>? dragNotifier;

  /// Stores `tableCellThemeBuilder` state/configuration for this implementation.
  final TableCellThemeBuilder tableCellThemeBuilder;

  /// Stores `selected` state/configuration for this implementation.
  final bool selected;

  /// Creates a `_FlattenedTableCell` instance.
  _FlattenedTableCell({
    required this.column,
    required this.row,
    required this.columnSpan,
    required this.rowSpan,
    required this.builder,
    required this.enabled,
    required this.hoveredCellNotifier,
    required this.dragNotifier,
    required this.tableCellThemeBuilder,
    required this.selected,
  });

  @override
  /// Executes `shift` behavior for this component/composite.
  _TableCellData shift(int column, int row) {
    return _FlattenedTableCell(
      column: this.column + column,
      row: this.row + row,
      columnSpan: columnSpan,
      rowSpan: rowSpan,
      builder: builder,
      enabled: enabled,
      hoveredCellNotifier: hoveredCellNotifier,
      tableCellThemeBuilder: tableCellThemeBuilder,
      selected: selected,
      dragNotifier: dragNotifier,
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _FlattenedTableCell &&
        other.column == column &&
        other.row == row &&
        other.columnSpan == columnSpan &&
        other.rowSpan == rowSpan &&
        other.builder == builder &&
        other.enabled == enabled &&
        other.hoveredCellNotifier == hoveredCellNotifier &&
        other.dragNotifier == dragNotifier &&
        other.tableCellThemeBuilder == tableCellThemeBuilder &&
        other.selected == selected;
  }

  @override
  int get hashCode {
    return Object.hash(
      column,
      row,
      columnSpan,
      rowSpan,
      builder,
      enabled,
      hoveredCellNotifier,
      dragNotifier,
      tableCellThemeBuilder,
      selected,
    );
  }
}

/// A flexible table widget with support for spanning, scrolling, and interactive features.
///
/// [Table] provides a comprehensive table component with advanced layout capabilities
/// including cell spanning, flexible sizing, frozen cells, scrolling, and rich theming.
/// It supports both simple data tables and complex layouts with header/footer rows.
///
/// ## Key Features
/// - **Cell Spanning**: Support for colspan and rowspan across multiple cells
/// - **Flexible Sizing**: Multiple sizing strategies (fixed, flex, intrinsic) for columns/rows
/// - **Frozen Cells**: Ability to freeze specific cells during scrolling
/// - **Interactive States**: Hover effects and selection states with visual feedback
/// - **Scrolling**: Optional horizontal and vertical scrolling with viewport control
/// - **Theming**: Comprehensive theming system for visual customization
///
/// ## Layout System
/// The table uses a sophisticated layout system that handles:
/// - Variable column widths via [TableSize] strategies
/// - Dynamic row heights based on content
/// - Complex cell spanning calculations
/// - Efficient rendering with viewport culling
///
/// ## Sizing Strategies
/// - [FlexTableSize]: Proportional sizing like CSS flex
/// - [FixedTableSize]: Absolute pixel sizes
/// - [IntrinsicTableSize]: Size based on content
///
/// Example:
/// ```dart
/// Table(
///   rows: [
///     TableHeader(cells: [
///       TableCell(child: Text('Name')),
///       TableCell(child: Text('Age')),
///       TableCell(child: Text('City')),
///     ]),
///     TableRow(cells: [
///       TableCell(child: Text('John Doe')),
///       TableCell(child: Text('25')),
///       TableCell(child: Text('New York')),
///     ]),
///   ],
///   columnWidths: {
///     0: FlexTableSize(flex: 2),
///     1: FixedTableSize(width: 80),
///     2: FlexTableSize(flex: 1),
///   },
/// );
/// ```
