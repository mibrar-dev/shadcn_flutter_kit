// Resize handles for the `table` component: the four drag targets around a
// cell that resize its column and row boundaries.
//
// Ported from the old `cell_resizer.dart` + `cell_resizer_state_part1.dart`.
// The four near-identical handles are built by one helper instead of four
// copies, and the cell/table data is passed as arguments instead of read from
// `Data`, so the widget has no hidden context dependency.

import 'package:flutter/widgets.dart';

import '../../foundation/resizable_item.dart';
import '../../foundation/resizer.dart';
import '../localizations/localizations.dart';
import 'table_layout.dart';
import 'table_resize_controller.dart';

/// A hovered or dragged resize boundary.
class TableResizeLine {
  /// Creates a boundary at [index] along [direction].
  const TableResizeLine(this.index, this.direction);

  /// Boundary index.
  final int index;

  /// `Axis.horizontal` for a row boundary, `Axis.vertical` for a column one.
  final Axis direction;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableResizeLine &&
          other.index == index &&
          other.direction == direction;

  @override
  int get hashCode => Object.hash(index, direction);
}

/// Reports a hover/drag change on a resize boundary.
typedef TableResizeHoverCallback =
    void Function(bool active, int index, Axis direction);

/// The drag handles that resize a cell's column and row boundaries.
///
/// Place it in a `Positioned.fill` over the cell content. It draws nothing
/// until a handle is hovered or dragged, when it paints [color].
class CellResizer extends StatefulWidget {
  /// Creates a cell resizer.
  const CellResizer({
    super.key,
    required this.controller,
    required this.row,
    required this.column,
    required this.rowSpan,
    required this.columnSpan,
    required this.maxRow,
    required this.maxColumn,
    required this.widthMode,
    required this.heightMode,
    required this.textDirection,
    required this.thickness,
    required this.color,
    required this.hoverNotifier,
    required this.dragNotifier,
    required this.onHover,
    required this.onDrag,
  });

  /// Sizing controller that receives the resize results.
  final ResizableTableController controller;

  /// Row index of the cell.
  final int row;

  /// Column index of the cell.
  final int column;

  /// Number of rows the cell spans.
  final int rowSpan;

  /// Number of columns the cell spans.
  final int columnSpan;

  /// Last row index of the table.
  final int maxRow;

  /// Last column index of the table.
  final int maxColumn;

  /// Column resize behaviour.
  final TableCellResizeMode widthMode;

  /// Row resize behaviour.
  final TableCellResizeMode heightMode;

  /// Direction columns run in (mirrors the horizontal drag).
  final TextDirection textDirection;

  /// Thickness of each handle.
  final double thickness;

  /// Colour painted while a handle is active.
  final Color color;

  /// Shared notifier of the hovered boundary.
  final ValueNotifier<TableResizeLine?> hoverNotifier;

  /// Shared notifier of the dragged boundary.
  final ValueNotifier<TableResizeLine?> dragNotifier;

  /// Called when a boundary hover starts or ends.
  final TableResizeHoverCallback onHover;

  /// Called when a boundary drag starts or ends.
  final TableResizeHoverCallback onDrag;

  @override
  State<CellResizer> createState() => _CellResizerState();
}

class _CellResizerState extends State<CellResizer> {
  Resizer? _resizer;
  bool? _resizeRow;

  void _start(bool rowAxis) {
    final List<ResizableItem> items = <ResizableItem>[];
    if (rowAxis) {
      for (int i = 0; i <= widget.maxRow; i++) {
        items.add(
          ResizableItem(
            value: widget.controller.getRowHeight(i),
            min: widget.controller.getRowMinHeight(i) ?? 0,
            max: widget.controller.getRowMaxHeight(i) ?? double.infinity,
          ),
        );
      }
    } else {
      for (int i = 0; i <= widget.maxColumn; i++) {
        items.add(
          ResizableItem(
            value: widget.controller.getColumnWidth(i),
            min: widget.controller.getColumnMinWidth(i) ?? 0,
            max: widget.controller.getColumnMaxWidth(i) ?? double.infinity,
          ),
        );
      }
    }
    _resizer = Resizer(items);
    _resizeRow = rowAxis;
    widget.onDrag(true, -1, rowAxis ? Axis.horizontal : Axis.vertical);
  }

  void _update({
    required bool rowAxis,
    required int boundary,
    required double delta,
    required TableCellResizeMode mode,
  }) {
    final Resizer? resizer = _resizer;
    if (resizer == null) {
      return;
    }
    if (mode == TableCellResizeMode.reallocate) {
      resizer.dragDivider(boundary + 1, delta);
      for (int i = 0; i < resizer.items.length; i++) {
        if (rowAxis) {
          widget.controller.resizeRow(i, resizer.items[i].newValue);
        } else {
          widget.controller.resizeColumn(i, resizer.items[i].newValue);
        }
      }
      return;
    }
    if (rowAxis) {
      widget.controller.resizeRow(
        boundary,
        widget.controller.getRowHeight(boundary) + delta,
      );
    } else {
      widget.controller.resizeColumn(
        boundary,
        widget.controller.getColumnWidth(boundary) + delta,
      );
    }
  }

  void _end() {
    widget.onDrag(false, -1, Axis.horizontal);
    _resizer = null;
    _resizeRow = null;
  }

  void _cancel() {
    final Resizer? resizer = _resizer;
    if (resizer == null) {
      return;
    }
    widget.onDrag(false, -1, Axis.horizontal);
    resizer.reset();
    for (int i = 0; i < resizer.items.length; i++) {
      if (_resizeRow == true) {
        widget.controller.resizeRow(i, resizer.items[i].value);
      } else {
        widget.controller.resizeColumn(i, resizer.items[i].value);
      }
    }
    _resizer = null;
    _resizeRow = null;
  }

  double _columnDelta(double delta) =>
      widget.textDirection == TextDirection.rtl ? -delta : delta;

  @override
  Widget build(BuildContext context) {
    final bool canWidth = widget.widthMode != TableCellResizeMode.none;
    final bool canHeight = widget.heightMode != TableCellResizeMode.none;
    final bool expandHeight =
        widget.heightMode == TableCellResizeMode.expand ||
        widget.row + widget.rowSpan <= widget.maxRow;
    final bool expandWidth =
        widget.widthMode == TableCellResizeMode.expand ||
        widget.column + widget.columnSpan <= widget.maxColumn;
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    return Stack(
      children: <Widget>[
        if (widget.row > 0 && canHeight)
          _handle(
            rowAxis: true,
            boundary: widget.row - 1,
            leading: true,
            label: l10n.tableResizeRow,
          ),
        if (expandHeight && canHeight)
          _handle(
            rowAxis: true,
            boundary: widget.row + widget.rowSpan - 1,
            leading: false,
            label: l10n.tableResizeRow,
          ),
        if (widget.column > 0 && canWidth)
          _handle(
            rowAxis: false,
            boundary: widget.column - 1,
            leading: true,
            label: l10n.tableResizeColumn,
          ),
        if (expandWidth && canWidth)
          _handle(
            rowAxis: false,
            boundary: widget.column + widget.columnSpan - 1,
            leading: false,
            label: l10n.tableResizeColumn,
          ),
      ],
    );
  }

  Widget _handle({
    required bool rowAxis,
    required int boundary,
    required bool leading,
    required String label,
  }) {
    final double thickness = widget.thickness;
    final Axis direction = rowAxis ? Axis.horizontal : Axis.vertical;
    final Widget child = Semantics(
      label: label,
      child: MouseRegion(
        cursor: rowAxis
            ? SystemMouseCursors.resizeRow
            : SystemMouseCursors.resizeColumn,
        hitTestBehavior: HitTestBehavior.translucent,
        onEnter: (_) => widget.onHover(true, boundary, direction),
        onExit: (_) => widget.onHover(false, boundary, direction),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragStart: rowAxis ? (_) => _start(true) : null,
          onVerticalDragUpdate: rowAxis
              ? (details) => _update(
                  rowAxis: true,
                  boundary: boundary,
                  delta: details.primaryDelta ?? 0,
                  mode: widget.heightMode,
                )
              : null,
          onVerticalDragEnd: rowAxis ? (_) => _end() : null,
          onVerticalDragCancel: rowAxis ? _cancel : null,
          onHorizontalDragStart: rowAxis ? null : (_) => _start(false),
          onHorizontalDragUpdate: rowAxis
              ? null
              : (details) => _update(
                  rowAxis: false,
                  boundary: boundary,
                  delta: _columnDelta(details.primaryDelta ?? 0),
                  mode: widget.widthMode,
                ),
          onHorizontalDragEnd: rowAxis ? null : (_) => _end(),
          onHorizontalDragCancel: rowAxis ? null : _cancel,
          child: _bar(boundary, direction),
        ),
      ),
    );
    if (rowAxis) {
      return leading
          ? Positioned(
              top: -thickness / 2,
              left: 0,
              right: 0,
              height: thickness,
              child: child,
            )
          : Positioned(
              bottom: -thickness / 2,
              left: 0,
              right: 0,
              height: thickness,
              child: child,
            );
    }
    return leading
        ? Positioned.directional(
            textDirection: widget.textDirection,
            start: -thickness / 2,
            top: 0,
            bottom: 0,
            width: thickness,
            child: child,
          )
        : Positioned.directional(
            textDirection: widget.textDirection,
            end: -thickness / 2,
            top: 0,
            bottom: 0,
            width: thickness,
            child: child,
          );
  }

  Widget _bar(int boundary, Axis direction) {
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        widget.hoverNotifier,
        widget.dragNotifier,
      ]),
      builder: (context, child) {
        final TableResizeLine? hover = widget.hoverNotifier.value;
        final TableResizeLine? drag = widget.dragNotifier.value;
        final bool active =
            (hover != null &&
                hover.index == boundary &&
                hover.direction == direction) ||
            (drag != null &&
                drag.index == boundary &&
                drag.direction == direction);
        return active
            ? ColoredBox(color: widget.color, child: const SizedBox.expand())
            : const SizedBox.expand();
      },
    );
  }
}
