// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// _ResizableTableState defines a reusable type for this registry module.
class _ResizableTableState extends State<ResizableTable> {
  /// Stores `_cells` state/configuration for this implementation.
  late List<_FlattenedTableCell> _cells;

  /// Stores `_maxColumn` state/configuration for this implementation.
  late int _maxColumn;

  /// Stores `_maxRow` state/configuration for this implementation.
  late int _maxRow;
  final ValueNotifier<_HoveredLine?> _hoverNotifier = ValueNotifier(null);
  final ValueNotifier<_HoveredCell?> _hoveredCellNotifier = ValueNotifier(null);
  final ValueNotifier<_HoveredLine?> _dragNotifier = ValueNotifier(null);

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _initResizerRows();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant ResizableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.rows, oldWidget.rows)) {
      _initResizerRows();
    }
  }

  /// Executes `_initResizerRows` behavior for this component/composite.
  void _initResizerRows() {
    _cells = [];
    for (int r = 0; r < widget.rows.length; r++) {
      /// Stores `row` state/configuration for this implementation.
      final row = widget.rows[r];
      for (int c = 0; c < row.cells.length; c++) {
        /// Stores `cell` state/configuration for this implementation.
        final cell = row.cells[c];

        /// Creates a `_cells.add` instance.
        _cells.add(
          /// Creates a `_FlattenedTableCell` instance.
          _FlattenedTableCell(
            column: c,
            row: r,
            columnSpan: cell.columnSpan,
            rowSpan: cell.rowSpan,
            builder: cell.build,
            enabled: cell.enabled,
            hoveredCellNotifier: _hoveredCellNotifier,
            dragNotifier: _dragNotifier,
            tableCellThemeBuilder: row.buildDefaultTheme,
            selected: row.selected,
          ),
        );
      }
    }
    _cells = _reorganizeCells(_cells);
    _maxColumn = 0;
    _maxRow = 0;
    for (final cell in _cells) {
      _maxColumn = max(_maxColumn, cell.column + cell.columnSpan - 1);
      _maxRow = max(_maxRow, cell.row + cell.rowSpan - 1);
    }
  }

  /// Executes `_onHover` behavior for this component/composite.
  void _onHover(bool hover, int index, Axis direction) {
    if (hover) {
      _hoverNotifier.value = _HoveredLine(index, direction);
    } else if (_hoverNotifier.value?.index == index &&
        _hoverNotifier.value?.direction == direction) {
      _hoverNotifier.value = null;
    }
  }

  /// Executes `_onDrag` behavior for this component/composite.
  void _onDrag(bool drag, int index, Axis direction) {
    if (drag && _dragNotifier.value == null) {
      _dragNotifier.value = _HoveredLine(index, direction);
    } else if (!drag) {
      _dragNotifier.value = null;
    }
  }

  /// Executes `_width` behavior for this component/composite.
  TableSize _width(int index) {
    return FixedTableSize(widget.controller.getColumnWidth(index));
  }

  /// Executes `_height` behavior for this component/composite.
  TableSize _height(int index) {
    return FixedTableSize(widget.controller.getRowHeight(index));
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    ResizableTableTheme? resizableTableTheme =
        widget.theme ?? ComponentTheme.maybeOf<ResizableTableTheme>(context);
    TableTheme? tableTheme =
        resizableTableTheme?.tableTheme ??
        ComponentTheme.maybeOf<TableTheme>(context);
    var children = _cells.map((cell) {
      return Data.inherit(
        data: cell,
        child: RawCell(
          column: cell.column,
          row: cell.row,
          columnSpan: cell.columnSpan,
          rowSpan: cell.rowSpan,
          child: Builder(
            builder: (context) {
              return cell.builder(context);
            },
          ),
        ),
      );
    }).toList();
    return Data.inherit(
      data: this,
      child: Data.inherit(
        data: _ResizableTableData(
          controller: widget.controller,
          cellWidthResizeMode: widget.cellWidthResizeMode,
          cellHeightResizeMode: widget.cellHeightResizeMode,
          maxColumn: _maxColumn,
          maxRow: _maxRow,
        ),
        child: Container(
          clipBehavior: widget.clipBehavior,
          decoration: BoxDecoration(
            border: tableTheme?.border,
            color: tableTheme?.backgroundColor,
            borderRadius: tableTheme?.borderRadius,
          ),
          child: ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) {
              return RawTableLayout(
                clipBehavior: widget.clipBehavior,
                horizontalOffset: widget.horizontalOffset,
                verticalOffset: widget.verticalOffset,
                frozenColumn: widget.frozenCells?.testColumn,
                frozenRow: widget.frozenCells?.testRow,
                viewportSize: widget.viewportSize,
                width: (index) {
                  return _width(index);
                },
                height: (index) {
                  return _height(index);
                },
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}
