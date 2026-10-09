// The `table` component: a themed data grid with span-aware cells, frozen
// rows/columns, optional scrolling and optional column/row resizing.
//
// Ported from `layout/table` (39 files, ~4.5k LOC). The layout engine, cell
// helpers, resize controller/handles and the cell view live in
// `primitives/table_layout/` so this file stays within the 400-line limit.
// `ResizableTable` is folded into `ShadcnTable` behind `resizeController`
// (clean break; no alias).
//
// Names are prefixed `ShadcnTable*` because `Table`, `TableRow` and `TableCell`
// are also names in `package:flutter/widgets.dart` (the `image` batch resolved
// the same clash by renaming `Image` to `ShadcnImage`).
//
// Old bugs fixed, not ported: hard-coded white cell fill (dark tables were
// white); `TableTheme.cellTheme` declared but never read; per-build
// `WidgetStateProperty.resolveWith` closures for row defaults; cells reading the
// old shared `Theme.of(context).colorScheme`; `TableTheme.copyWith` dropping
// `borderRadius`; the hidden `Data.inherit` dependency.

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/table_layout/table_cell_view.dart';
import '../../primitives/table_layout/table_cells.dart';
import '../../primitives/table_layout/table_layout.dart';
import '../../primitives/table_layout/table_models.dart';
import '../../primitives/table_layout/table_resize.dart';
import '../../primitives/table_layout/table_resize_controller.dart';
import '../../theme/theme.dart';
import '../scrollable_client/scrollable_client.dart';
import 'table_style.dart';

export '../../primitives/table_layout/table_cell_view.dart'
    show TableCellView, TableRawCell;
export '../../primitives/table_layout/table_cells.dart'
    show FlatTableCell, TableCellPosition, TableCellRange;
export '../../primitives/table_layout/table_models.dart';
export '../../primitives/table_layout/table_layout.dart';
export '../../primitives/table_layout/table_resize.dart'
    show CellResizer, TableResizeHoverCallback, TableResizeLine;
export '../../primitives/table_layout/table_resize_controller.dart'
    show ResizableTableController;
export 'table_style.dart';

/// A themed data grid of [ShadcnTableRow]s (headers, rows, footers) holding
/// [ShadcnTableCell]s, sized by [TableSize] strategies.
class ShadcnTable extends StatefulWidget {
  /// Creates a table.
  const ShadcnTable({
    super.key,
    required this.rows,
    this.defaultColumnWidth = const FlexTableSize(),
    this.defaultRowHeight = const IntrinsicTableSize(),
    this.columnWidths,
    this.rowHeights,
    this.clipBehavior = Clip.hardEdge,
    this.frozenCells,
    this.horizontalOffset,
    this.verticalOffset,
    this.viewportSize,
    this.verticalController,
    this.horizontalController,
    this.textDirection,
    this.resizeController,
    this.cellWidthResizeMode = TableCellResizeMode.reallocate,
    this.cellHeightResizeMode = TableCellResizeMode.expand,
    this.theme,
  });

  /// Rows of the table.
  final List<ShadcnTableRow> rows;

  /// Default column sizing strategy.
  final TableSize defaultColumnWidth;

  /// Default row sizing strategy.
  final TableSize defaultRowHeight;

  /// Per-column / per-row sizing overrides.
  final Map<int, TableSize>? columnWidths;
  final Map<int, TableSize>? rowHeights;

  /// How content is clipped at the table boundary.
  final Clip clipBehavior;

  /// Frozen rows/columns kept visible while scrolling.
  final FrozenTableData? frozenCells;

  /// Manual scroll offsets and viewport size (used when no controllers).
  final double? horizontalOffset;
  final double? verticalOffset;
  final Size? viewportSize;

  /// Own scrolling controllers; when set the table wraps a `ScrollableClient`.
  final ScrollController? verticalController;
  final ScrollController? horizontalController;

  /// Direction columns run in; defaults to the ambient `Directionality`.
  final TextDirection? textDirection;

  /// Enables interactive resizing when non-null.
  final ResizableTableController? resizeController;

  /// Column / row resize behaviour when [resizeController] is set.
  final TableCellResizeMode cellWidthResizeMode;
  final TableCellResizeMode cellHeightResizeMode;

  /// Widget-leg theme override, merged on top of the other resolver legs.
  final TableTheme? theme;

  @override
  State<ShadcnTable> createState() => ShadcnTableState();
}

/// One row of a [ShadcnTable].

/// State of a [ShadcnTable]: flattens the rows, resolves the theme and lays out
/// the cells.
class ShadcnTableState extends State<ShadcnTable> {
  List<FlatTableCell<ShadcnTableCell>> _cells =
      const <FlatTableCell<ShadcnTableCell>>[];
  int _maxRow = 0;
  int _maxColumn = 0;
  TextDirection _textDirection = TextDirection.ltr;
  double _resizerThickness = 4;
  Color _resizerColor = const Color(0xFF000000);
  final ValueNotifier<TableCellRange?> _hoveredCellNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<TableResizeLine?> _hoverNotifier = ValueNotifier(null);
  final ValueNotifier<TableResizeLine?> _dragNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _initCells();
  }

  @override
  void didUpdateWidget(covariant ShadcnTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.rows, oldWidget.rows)) {
      _initCells();
    }
  }

  @override
  void dispose() {
    _hoveredCellNotifier.dispose();
    _hoverNotifier.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  void _initCells() {
    _cells = flattenTableCells<ShadcnTableCell, ShadcnTableRow>(widget.rows);
    _maxRow = 0;
    _maxColumn = 0;
    for (final FlatTableCell<ShadcnTableCell> cell in _cells) {
      _maxColumn = max(_maxColumn, cell.column + cell.columnSpan - 1);
      _maxRow = max(_maxRow, cell.row + cell.rowSpan - 1);
    }
  }

  void _onHover(bool hover, int index, Axis direction) {
    final TableResizeLine line = TableResizeLine(index, direction);
    if (hover) {
      _hoverNotifier.value = line;
    } else if (_hoverNotifier.value == line) {
      _hoverNotifier.value = null;
    }
  }

  void _onDrag(bool drag, int index, Axis direction) {
    if (drag && _dragNotifier.value == null) {
      _dragNotifier.value = TableResizeLine(index, direction);
    } else if (!drag) {
      _dragNotifier.value = null;
    }
  }

  TableSize _size(int index, bool column) {
    final ResizableTableController? controller = widget.resizeController;
    if (controller != null) {
      return FixedTableSize(
        column
            ? controller.getColumnWidth(index)
            : controller.getRowHeight(index),
      );
    }
    return (column ? widget.columnWidths : widget.rowHeights)?[index] ??
        (column ? widget.defaultColumnWidth : widget.defaultRowHeight);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final TableTheme resolved = resolveComponentStyle<TableTheme, TableTheme>(
      context,
      widget: widget.theme,
      select: (t) => t,
      defaults: tableDefaults,
    );
    _textDirection =
        widget.textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;
    _resizerThickness = resolved.resizerThickness ?? 4;
    _resizerColor =
        resolved.resizerColor?.resolve(theme.colors) ?? theme.colors.primary;

    Widget buildTable(double? horizontal, double? vertical, Size? viewport) {
      Widget layout = RawTableLayout(
        clipBehavior: widget.clipBehavior,
        frozenColumn: widget.frozenCells?.testColumn,
        frozenRow: widget.frozenCells?.testRow,
        horizontalOffset: horizontal,
        verticalOffset: vertical,
        viewportSize: viewport,
        textDirection: _textDirection,
        width: (i) => _size(i, true),
        height: (i) => _size(i, false),
        children: <Widget>[
          for (final FlatTableCell<ShadcnTableCell> cell in _cells)
            _buildRawCell(cell, resolved.cellTheme),
        ],
      );
      final ResizableTableController? controller = widget.resizeController;
      if (controller != null) {
        layout = ListenableBuilder(
          listenable: controller,
          builder: (context, child) => child!,
          child: layout,
        );
      }
      final Color? borderColor = resolved.borderColor?.resolve(theme.colors);
      final double borderWidth = resolved.borderWidth ?? 0;
      return Container(
        clipBehavior: widget.clipBehavior,
        decoration: BoxDecoration(
          color: resolved.background?.resolve(theme.colors),
          border: borderColor != null && borderWidth > 0
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
          borderRadius: resolved.borderRadius ?? theme.borderRadiusMd,
        ),
        padding: resolved.padding,
        child: layout,
      );
    }

    if (widget.verticalController != null ||
        widget.horizontalController != null) {
      return ScrollableClient(
        verticalDetails: ScrollableDetails.vertical(
          controller: widget.verticalController,
        ),
        horizontalDetails: ScrollableDetails.horizontal(
          controller: widget.horizontalController,
          reverse: _textDirection == TextDirection.rtl,
        ),
        builder: (context, offset, viewportSize, child) =>
            buildTable(offset.dx, offset.dy, viewportSize),
      );
    }
    return buildTable(
      widget.horizontalOffset,
      widget.verticalOffset,
      widget.viewportSize,
    );
  }

  Widget _buildRawCell(
    FlatTableCell<ShadcnTableCell> flat,
    TableCellTheme? tableCellTheme,
  ) {
    final ResizableTableController? controller = widget.resizeController;
    return TableRawCell(
      column: flat.column,
      row: flat.row,
      columnSpan: flat.columnSpan,
      rowSpan: flat.rowSpan,
      resizer: controller == null
          ? null
          : CellResizer(
              controller: controller,
              row: flat.row,
              column: flat.column,
              rowSpan: flat.rowSpan,
              columnSpan: flat.columnSpan,
              maxRow: _maxRow,
              maxColumn: _maxColumn,
              widthMode: widget.cellWidthResizeMode,
              heightMode: widget.cellHeightResizeMode,
              textDirection: _textDirection,
              thickness: _resizerThickness,
              color: _resizerColor,
              hoverNotifier: _hoverNotifier,
              dragNotifier: _dragNotifier,
              onHover: _onHover,
              onDrag: _onDrag,
            ),
      child: _buildCell(flat, tableCellTheme),
    );
  }

  Widget _buildCell(
    FlatTableCell<ShadcnTableCell> flat,
    TableCellTheme? tableCellTheme,
  ) {
    final ShadcnTableCell cell = flat.cell;
    final ShadcnTableRow row = widget.rows[flat.row];
    final TableCellTheme cellTheme = mergeTableCellTheme(
      _rowDefaultTheme(row),
      tableTheme: tableCellTheme,
    );
    return TableCellView(
      current: TableCellRange(
        flat.column,
        flat.row,
        flat.columnSpan,
        flat.rowSpan,
      ),
      hoveredNotifier: _hoveredCellNotifier,
      draggingNotifier: _dragNotifier,
      columnHover: cell.columnHover,
      rowHover: cell.rowHover,
      selected: flat.selected,
      enabled: cell.enabled,
      background: cellTheme.background,
      foreground: cellTheme.foreground,
      borderColor: cellTheme.borderColor,
      borderWidth: cellTheme.borderWidth,
      textStyle: cellTheme.textStyle,
      padding: cellTheme.padding,
      minHeight: cellTheme.minHeight,
      child: cell.child,
    );
  }

  TableCellTheme _rowDefaultTheme(ShadcnTableRow row) {
    if (row is ShadcnTableHeader) {
      return tableHeaderCellDefaults;
    }
    if (row is ShadcnTableFooter) {
      return tableFooterCellDefaults;
    }
    return tableCellDefaults;
  }
}
