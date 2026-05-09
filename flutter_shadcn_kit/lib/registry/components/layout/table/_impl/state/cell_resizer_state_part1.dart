// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// _CellResizerState defines a reusable type for this registry module.
class _CellResizerState extends State<_CellResizer> {
  /// Stores `_resizer` state/configuration for this implementation.
  Resizer? _resizer;

  /// Stores `_resizeRow` state/configuration for this implementation.
  bool? _resizeRow;

  /// Executes `_onDragStartRow` behavior for this component/composite.
  void _onDragStartRow(DragStartDetails details) {
    /// Stores `items` state/configuration for this implementation.
    List<ResizableItem> items = [];
    for (int i = 0; i <= widget.maxRow; i++) {
      /// Creates a `items.add` instance.
      items.add(
        /// Creates a `ResizableItem` instance.
        ResizableItem(
          value: widget.controller.getRowHeight(i),
          min: widget.controller.getRowMinHeight(i) ?? 0,
          max: widget.controller.getRowMaxHeight(i) ?? double.infinity,
        ),
      );
    }
    _resizer = Resizer(items);
    _resizeRow = true;
    widget.onDrag(true, -1, Axis.horizontal);
  }

  /// Executes `_onDragStartColumn` behavior for this component/composite.
  void _onDragStartColumn(DragStartDetails details) {
    /// Stores `items` state/configuration for this implementation.
    List<ResizableItem> items = [];
    for (int i = 0; i <= widget.maxColumn; i++) {
      /// Creates a `items.add` instance.
      items.add(
        /// Creates a `ResizableItem` instance.
        ResizableItem(
          value: widget.controller.getColumnWidth(i),
          min: widget.controller.getColumnMinWidth(i) ?? 0,
          max: widget.controller.getColumnMaxWidth(i) ?? double.infinity,
        ),
      );
    }
    _resizer = Resizer(items);
    _resizeRow = false;
    widget.onDrag(true, -1, Axis.vertical);
  }

  /// Executes `_onDragUpdate` behavior for this component/composite.
  void _onDragUpdate(int start, int end, DragUpdateDetails details) {
    // _resizer!.resize(start, end, _delta!);
    _resizer!.dragDivider(end, details.primaryDelta!);
    for (int i = 0; i < _resizer!.items.length; i++) {
      // widget.controller.resizeRow(i, _resizer!.items[i].newValue);
      if (_resizeRow!) {
        widget.controller.resizeRow(i, _resizer!.items[i].newValue);
      } else {
        widget.controller.resizeColumn(i, _resizer!.items[i].newValue);
      }
    }
  }

  /// Executes `_onDragEnd` behavior for this component/composite.
  void _onDragEnd(DragEndDetails details) {
    widget.onDrag(false, -1, Axis.horizontal);
    // _delta = null;
    _resizer = null;
    _resizeRow = null;
  }

  /// Executes `_onDragCancel` behavior for this component/composite.
  void _onDragCancel() {
    if (_resizer == null) {
      return;
    }
    widget.onDrag(false, -1, Axis.horizontal);
    _resizer!.reset();
    for (int i = 0; i <= widget.maxRow; i++) {
      if (_resizeRow == true) {
        widget.controller.resizeRow(i, _resizer!.items[i].value);
      } else {
        widget.controller.resizeColumn(i, _resizer!.items[i].value);
      }
    }
    _resizer = null;
    _resizeRow = null;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `thickness` state/configuration for this implementation.
    double thickness = widget.theme?.resizerThickness ?? 4;
    final flattenedData = Data.of<_FlattenedTableCell>(context);

    /// Stores `row` state/configuration for this implementation.
    final row = flattenedData.row;

    /// Stores `column` state/configuration for this implementation.
    final column = flattenedData.column;

    /// Stores `rowSpan` state/configuration for this implementation.
    final rowSpan = flattenedData.rowSpan;

    /// Stores `columnSpan` state/configuration for this implementation.
    final columnSpan = flattenedData.columnSpan;
    final tableData = Data.of<_ResizableTableData>(context);

    /// Stores `widthMode` state/configuration for this implementation.
    final widthMode = tableData.cellWidthResizeMode;

    /// Stores `heightMode` state/configuration for this implementation.
    final heightMode = tableData.cellHeightResizeMode;
    final theme = Theme.of(context);
    return Stack(
      children: [
        // top
        if (row > 0 && heightMode != TableCellResizeMode.none)
          /// Creates a `Positioned` instance.
          Positioned(
            top: -thickness / 2,
            left: 0,
            right: 0,
            height: thickness,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeRow,
              hitTestBehavior: HitTestBehavior.translucent,
              onEnter: (event) {
                widget.onHover(true, row - 1, Axis.horizontal);
              },
              onExit: (event) {
                widget.onHover(false, row - 1, Axis.horizontal);
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: _onDragStartRow,
                onVerticalDragUpdate: (details) {
                  if (heightMode == TableCellResizeMode.reallocate) {
                    _onDragUpdate(row - 1, row, details);
                  } else {
                    widget.controller.resizeRow(
                      row - 1,
                      widget.controller.getRowHeight(row - 1) +
                          details.primaryDelta!,
                    );
                  }
                },
                onVerticalDragEnd: _onDragEnd,
                onVerticalDragCancel: _onDragCancel,
                child: ListenableBuilder(
                  // valueListenable: widget.hoverNotifier,
                  listenable: Listenable.merge([
                    widget.hoverNotifier,
                    widget.dragNotifier,
                  ]),
                  builder: (context, child) {
                    /// Stores `hover` state/configuration for this implementation.
                    _HoveredLine? hover = widget.hoverNotifier.value;

                    /// Stores `drag` state/configuration for this implementation.
                    _HoveredLine? drag = widget.dragNotifier.value;
                    if (drag != null) {
                      hover = null;
                    }
                    return Container(
                      color:
                          (hover?.index == row - 1 &&
                                  hover?.direction == Axis.horizontal) ||
                              (drag?.index == row - 1 &&
                                  drag?.direction == Axis.horizontal)
                          ? widget.theme?.resizerColor ??
                                theme.colorScheme.primary
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
        // bottom
        if ((row + rowSpan <= tableData.maxRow ||
                heightMode == TableCellResizeMode.expand) &&
            heightMode != TableCellResizeMode.none)
          /// Creates a `Positioned` instance.
          Positioned(
            bottom: -thickness / 2,
            left: 0,
            right: 0,
            height: thickness,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeRow,
              hitTestBehavior: HitTestBehavior.translucent,
              onEnter: (event) {
                widget.onHover(true, row + rowSpan - 1, Axis.horizontal);
              },
              onExit: (event) {
                widget.onHover(false, row + rowSpan - 1, Axis.horizontal);
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: _onDragStartRow,
                onVerticalDragUpdate: (details) {
                  if (heightMode == TableCellResizeMode.reallocate) {
                    _onDragUpdate(row + rowSpan - 1, row + rowSpan, details);
                  } else {
                    widget.controller.resizeRow(
                      row + rowSpan - 1,
                      widget.controller.getRowHeight(row + rowSpan - 1) +
                          details.primaryDelta!,
                    );
                  }
                },
                onVerticalDragEnd: _onDragEnd,
                onVerticalDragCancel: _onDragCancel,
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    widget.hoverNotifier,
                    widget.dragNotifier,
                  ]),
                  builder: (context, child) {
                    /// Stores `hover` state/configuration for this implementation.
                    _HoveredLine? hover = widget.hoverNotifier.value;

                    /// Stores `drag` state/configuration for this implementation.
                    _HoveredLine? drag = widget.dragNotifier.value;
                    if (drag != null) {
                      hover = null;
                    }
                    return Container(
                      color:
                          (hover?.index == row + rowSpan - 1 &&
                                  hover?.direction == Axis.horizontal) ||
                              (drag?.index == row + rowSpan - 1 &&
                                  drag?.direction == Axis.horizontal)
                          ? widget.theme?.resizerColor ??
                                theme.colorScheme.primary
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
        // left
        if (column > 0 && widthMode != TableCellResizeMode.none)
          /// Creates a `Positioned` instance.
          Positioned(
            left: -thickness / 2,
            top: 0,
            bottom: 0,
            width: thickness,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              hitTestBehavior: HitTestBehavior.translucent,
              onEnter: (event) {
                widget.onHover(true, column - 1, Axis.vertical);
              },
              onExit: (event) {
                widget.onHover(false, column - 1, Axis.vertical);
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: _onDragStartColumn,
                onHorizontalDragUpdate: (details) {
                  if (widthMode == TableCellResizeMode.reallocate) {
                    _onDragUpdate(column - 1, column, details);
                  } else {
                    widget.controller.resizeColumn(
                      column - 1,
                      widget.controller.getColumnWidth(column - 1) +
                          details.primaryDelta!,
                    );
                  }
                },
                onHorizontalDragEnd: _onDragEnd,
                onHorizontalDragCancel: _onDragCancel,
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    widget.hoverNotifier,
                    widget.dragNotifier,
                  ]),
                  builder: (context, child) {
                    /// Stores `hover` state/configuration for this implementation.
                    _HoveredLine? hover = widget.hoverNotifier.value;

                    /// Stores `drag` state/configuration for this implementation.
                    _HoveredLine? drag = widget.dragNotifier.value;
                    if (drag != null) {
                      hover = null;
                    }
                    return Container(
                      color:
                          (hover?.index == column - 1 &&
                                  hover?.direction == Axis.vertical) ||
                              (drag?.index == column - 1 &&
                                  drag?.direction == Axis.vertical)
                          ? widget.theme?.resizerColor ??
                                theme.colorScheme.primary
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
        // right
        if ((column + columnSpan <= tableData.maxColumn ||
                widthMode == TableCellResizeMode.expand) &&
            widthMode != TableCellResizeMode.none)
          /// Creates a `Positioned` instance.
          Positioned(
            right: -thickness / 2,
            top: 0,
            bottom: 0,
            width: thickness,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              hitTestBehavior: HitTestBehavior.translucent,
              onEnter: (event) {
                widget.onHover(true, column + columnSpan - 1, Axis.vertical);
              },
              onExit: (event) {
                widget.onHover(false, column + columnSpan - 1, Axis.vertical);
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: _onDragStartColumn,
                onHorizontalDragUpdate: (details) {
                  if (widthMode == TableCellResizeMode.reallocate) {
                    /// Creates a `_onDragUpdate` instance.
                    _onDragUpdate(
                      column + columnSpan - 1,
                      column + columnSpan,
                      details,
                    );
                  } else {
                    widget.controller.resizeColumn(
                      column + columnSpan - 1,
                      widget.controller.getColumnWidth(
                            column + columnSpan - 1,
                          ) +
                          details.primaryDelta!,
                    );
                  }
                },
                onHorizontalDragEnd: _onDragEnd,
                onHorizontalDragCancel: _onDragCancel,
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    widget.hoverNotifier,
                    widget.dragNotifier,
                  ]),
                  builder: (context, child) {
                    /// Stores `hover` state/configuration for this implementation.
                    _HoveredLine? hover = widget.hoverNotifier.value;

                    /// Stores `drag` state/configuration for this implementation.
                    _HoveredLine? drag = widget.dragNotifier.value;
                    if (drag != null) {
                      hover = null;
                    }
                    return Container(
                      color:
                          (hover?.index == column + columnSpan - 1 &&
                                  hover?.direction == Axis.vertical) ||
                              (drag?.index == column + columnSpan - 1 &&
                                  drag?.direction == Axis.vertical)
                          ? widget.theme?.resizerColor ??
                                theme.colorScheme.primary
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
