// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// Table defines a reusable type for this registry module.
class Table extends StatefulWidget {
  /// List of rows to display in the table.
  ///
  /// Type: `List<TableRow>`. Contains the table data organized as rows.
  /// Can include [TableRow], [TableHeader], and [TableFooter] instances.
  /// Each row contains a list of [TableCell] widgets.
  final List<TableRow> rows;

  /// Default sizing strategy for all columns.
  ///
  /// Type: `TableSize`. Used when no specific width is provided in
  /// [columnWidths]. Defaults to [FlexTableSize] for proportional sizing.
  final TableSize defaultColumnWidth;

  /// Default sizing strategy for all rows.
  ///
  /// Type: `TableSize`. Used when no specific height is provided in
  /// [rowHeights]. Defaults to [IntrinsicTableSize] for content-based sizing.
  final TableSize defaultRowHeight;

  /// Specific column width overrides.
  ///
  /// Type: `Map<int, TableSize>?`. Maps column indices to specific sizing
  /// strategies. Overrides [defaultColumnWidth] for specified columns.
  final Map<int, TableSize>? columnWidths;

  /// Specific row height overrides.
  ///
  /// Type: `Map<int, TableSize>?`. Maps row indices to specific sizing
  /// strategies. Overrides [defaultRowHeight] for specified rows.
  final Map<int, TableSize>? rowHeights;

  /// Clipping behavior for the table content.
  ///
  /// Type: `Clip`. Controls how content is clipped at table boundaries.
  /// Defaults to [Clip.hardEdge] for clean boundaries.
  final Clip clipBehavior;

  /// Theme configuration for the table appearance.
  ///
  /// Type: `TableTheme?`. Controls borders, colors, and overall styling.
  /// If null, uses the default theme from [ComponentTheme].
  final TableTheme? theme;

  /// Configuration for frozen cells during scrolling.
  ///
  /// Type: `FrozenTableData?`. Specifies which cells remain visible
  /// during horizontal or vertical scrolling. Useful for headers/footers.
  final FrozenTableData? frozenCells;

  /// Horizontal scroll offset for the table viewport.
  ///
  /// Type: `double?`. Controls horizontal scrolling position. If provided,
  /// the table displays within a scrollable viewport.
  final double? horizontalOffset;

  /// Vertical scroll offset for the table viewport.
  ///
  /// Type: `double?`. Controls vertical scrolling position. If provided,
  /// the table displays within a scrollable viewport.
  final double? verticalOffset;

  /// Size constraints for the table viewport.
  ///
  /// Type: `Size?`. When provided with scroll offsets, constrains the
  /// visible area of the table. Essential for scrolling behavior.
  final Size? viewportSize;

  /// Creates a [Table] widget.
  ///
  /// The table displays data organized in rows and cells with flexible
  /// sizing and interactive features.
  ///
  /// Parameters:
  /// - [rows] (`List<TableRow>`, required): Table data organized as rows
  /// - [defaultColumnWidth] (TableSize, default: FlexTableSize()): Default column sizing
  /// - [defaultRowHeight] (TableSize, default: IntrinsicTableSize()): Default row sizing
  /// - [columnWidths] (`Map<int, TableSize>?`, optional): Column-specific sizes
  /// - [rowHeights] (`Map<int, TableSize>?`, optional): Row-specific sizes
  /// - [clipBehavior] (Clip, default: Clip.hardEdge): Content clipping behavior
  /// - [theme] (TableTheme?, optional): Visual styling configuration
  /// - [frozenCells] (FrozenTableData?, optional): Frozen cell configuration
  /// - [horizontalOffset] (double?, optional): Horizontal scroll position
  /// - [verticalOffset] (double?, optional): Vertical scroll position
  /// - [viewportSize] (Size?, optional): Viewport size constraints
  ///
  /// Example:
  /// ```dart
  /// Table(
  ///   rows: [
  ///     TableHeader(cells: [TableCell(child: Text('Header'))]),
  ///     TableRow(cells: [TableCell(child: Text('Data'))]),
  ///   ],
  ///   columnWidths: {0: FixedTableSize(width: 200)},
  /// );
  /// ```
  const Table({
    super.key,
    required this.rows,
    this.defaultColumnWidth = const FlexTableSize(),
    this.defaultRowHeight = const IntrinsicTableSize(),
    this.columnWidths,
    this.rowHeights,
    this.clipBehavior = Clip.hardEdge,
    this.theme,
    this.frozenCells,
    this.horizontalOffset,
    this.verticalOffset,
    this.viewportSize,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Table> createState() => _TableState();
}
