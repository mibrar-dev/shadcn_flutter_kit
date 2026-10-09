// Rendering helpers for one `table` cell: hover tracking, per-state style
// resolution and the raw-cell parent-data wrapper.
//
// Extracted from the old `TableCell.build` / `_CellResizer` overlay so the
// `table` component files stay within the 400-line limit. Theme-agnostic: the
// cell takes already-merged `StateValue<ThemedColor>` fields and resolves them
// against the ambient `ShadcnColors`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'table_cells.dart';
import 'table_layout.dart';
import 'table_resize.dart';

/// Renders one cell: hover tracking, a bottom border, padding and text style.
class TableCellView extends StatelessWidget {
  /// Creates a cell view.
  const TableCellView({
    super.key,
    required this.child,
    required this.current,
    required this.hoveredNotifier,
    this.draggingNotifier,
    this.columnHover = false,
    this.rowHover = true,
    this.selected = false,
    this.enabled = true,
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    this.padding,
    this.minHeight,
  });

  /// Cell content.
  final Widget child;

  /// This cell's grid range.
  final TableCellRange current;

  /// Notifier of the hovered cell range.
  final ValueNotifier<TableCellRange?> hoveredNotifier;

  /// Notifier of an active resize drag (suppresses hover while dragging).
  final ValueNotifier<TableResizeLine?>? draggingNotifier;

  /// Whether hovering another cell in the same column highlights this one.
  final bool columnHover;

  /// Whether hovering another cell in the same row highlights this one.
  final bool rowHover;

  /// Whether the row is selected.
  final bool selected;

  /// Whether the cell responds to hover.
  final bool enabled;

  /// Per-state fill.
  final StateValue<ThemedColor>? background;

  /// Per-state text colour.
  final StateValue<ThemedColor>? foreground;

  /// Per-state bottom-border colour.
  final StateValue<ThemedColor>? borderColor;

  /// Bottom-border width.
  final double? borderWidth;

  /// Text style override (colour comes from [foreground]).
  final TextStyle? textStyle;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  /// Minimum cell height.
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return MouseRegion(
      onEnter: (_) {
        if (enabled) {
          hoveredNotifier.value = current;
        }
      },
      onExit: (_) {
        if (enabled && hoveredNotifier.value == current) {
          hoveredNotifier.value = null;
        }
      },
      child: ListenableBuilder(
        listenable: Listenable.merge(<Listenable?>[
          hoveredNotifier,
          draggingNotifier,
        ]),
        builder: (context, child) {
          final TableCellRange? hovered = draggingNotifier?.value != null
              ? null
              : hoveredNotifier.value;
          final Set<WidgetState> states = <WidgetState>{
            if (hovered != null &&
                ((columnHover && hovered.intersects(current, Axis.vertical)) ||
                    (rowHover && hovered.intersects(current, Axis.horizontal))))
              WidgetState.hovered,
            if (selected) WidgetState.selected,
            if (!enabled) WidgetState.disabled,
          };
          final Color? border = borderColor
              ?.resolve(states)
              ?.resolve(theme.colors);
          final double width = borderWidth ?? 0;
          final Color? fill = background
              ?.resolve(states)
              ?.resolve(theme.colors);
          Widget content = DecoratedBox(
            decoration: BoxDecoration(
              color: fill,
              border: border != null && width > 0
                  ? Border(
                      bottom: BorderSide(color: border, width: width),
                    )
                  : null,
            ),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: DefaultTextStyle.merge(
                style: _textStyle(theme, states),
                child: child!,
              ),
            ),
          );
          final double? height = minHeight;
          if (height != null) {
            content = ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: content,
            );
          }
          return content;
        },
        child: child,
      ),
    );
  }

  TextStyle? _textStyle(ShadcnThemeData theme, Set<WidgetState> states) {
    final TextStyle? base = textStyle;
    final Color? color = foreground?.resolve(states)?.resolve(theme.colors);
    if (base == null && color == null) {
      return null;
    }
    return (base ?? const TextStyle()).copyWith(color: color);
  }
}

/// Positions a cell on the grid and overlays an optional resize handle.
class TableRawCell extends StatelessWidget {
  /// Creates a raw table cell.
  const TableRawCell({
    super.key,
    required this.column,
    required this.row,
    required this.columnSpan,
    required this.rowSpan,
    required this.child,
    this.resizer,
  });

  /// Column index.
  final int column;

  /// Row index.
  final int row;

  /// Number of columns spanned.
  final int columnSpan;

  /// Number of rows spanned.
  final int rowSpan;

  /// Cell content.
  final Widget child;

  /// Optional resize-handle overlay.
  final Widget? resizer;

  @override
  Widget build(BuildContext context) {
    final Widget? resizer = this.resizer;
    final Widget content = resizer == null
        ? child
        : Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              child,
              Positioned.fill(child: resizer),
            ],
          );
    return RawCell(
      column: column,
      row: row,
      columnSpan: columnSpan,
      rowSpan: rowSpan,
      child: content,
    );
  }
}
