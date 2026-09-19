// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// ResizableTable defines a reusable type for this registry module.
class ResizableTable extends StatefulWidget {
  /// List of table rows to display.
  final List<TableRow> rows;

  /// Controller for managing table resize state.
  final ResizableTableController controller;

  /// Theme for table styling.
  final ResizableTableTheme? theme;

  /// How content should be clipped at table boundaries.
  final Clip clipBehavior;

  /// Resize mode for column widths.
  final TableCellResizeMode cellWidthResizeMode;

  /// Resize mode for row heights.
  final TableCellResizeMode cellHeightResizeMode;

  /// Configuration for frozen (non-scrolling) rows and columns.
  final FrozenTableData? frozenCells;

  /// Horizontal scroll offset.
  final double? horizontalOffset;

  /// Vertical scroll offset.
  final double? verticalOffset;

  /// Size of the visible viewport.
  final Size? viewportSize;

  /// Optional controller for vertical scrolling owned by this
  /// [ResizableTable]. See [Table.verticalController].
  final ScrollController? verticalController;

  /// Optional controller for horizontal scrolling owned by this
  /// [ResizableTable]. See [Table.horizontalController].
  final ScrollController? horizontalController;

  /// The direction columns run in. See [Table.textDirection].
  ///
  /// The resize handles follow it too: under [TextDirection.rtl] the handle on
  /// a cell's right edge resizes the column before it, and dragging left
  /// widens rather than narrows.
  final TextDirection? textDirection;

  /// Creates a [ResizableTable].
  ///
  /// Parameters:
  /// - [rows] (`List<TableRow>`, required): Table rows.
  /// - [controller] (`ResizableTableController`, required): Resize controller.
  /// - [theme] (`ResizableTableTheme?`, optional): Table theme.
  /// - [clipBehavior] (`Clip`, default: `Clip.hardEdge`): Clipping behavior.
  /// - [cellWidthResizeMode] (`TableCellResizeMode`, default: `reallocate`): Column resize mode.
  /// - [cellHeightResizeMode] (`TableCellResizeMode`, default: `expand`): Row resize mode.
  /// - [frozenCells] (`FrozenTableData?`, optional): Frozen cell configuration.
  /// - [horizontalOffset] (`double?`, optional): Horizontal scroll offset.
  /// - [verticalOffset] (`double?`, optional): Vertical scroll offset.
  /// - [viewportSize] (`Size?`, optional): Viewport size.
  /// - [verticalController] (`ScrollController?`, optional): Controller-driven vertical scrolling.
  /// - [horizontalController] (`ScrollController?`, optional): Controller-driven horizontal scrolling.
  /// - [textDirection] (`TextDirection?`, optional): Direction columns run in;
  ///   defaults to the ambient [Directionality].
  const ResizableTable({
    super.key,
    required this.rows,
    required this.controller,
    this.theme,
    this.clipBehavior = Clip.hardEdge,
    this.cellWidthResizeMode = TableCellResizeMode.reallocate,
    this.cellHeightResizeMode = TableCellResizeMode.expand,
    this.frozenCells,
    this.horizontalOffset,
    this.verticalOffset,
    this.viewportSize,
    this.verticalController,
    this.horizontalController,
    this.textDirection,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ResizableTable> createState() => _ResizableTableState();
}
