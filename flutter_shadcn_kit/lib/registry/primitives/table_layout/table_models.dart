// Public models for the `table` component: rows, headers, footers and cells.
//
// These are theme-free so they can live in the table primitive (with the
// layout engine and generic cell machinery) without the primitive importing a
// component. The component's `table_style.dart` owns the theme classes;
// `table.dart` re-exports these models.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'table_cells.dart';

/// One row of a `table`.
class ShadcnTableRow implements TableRowLike<ShadcnTableCell> {
  /// Creates a row.
  const ShadcnTableRow({required this.cells, this.selected = false});

  @override
  final List<ShadcnTableCell> cells;

  @override
  final bool selected;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadcnTableRow &&
          listEquals(other.cells, cells) &&
          other.selected == selected;

  @override
  int get hashCode => Object.hash(Object.hashAll(cells), selected);
}

/// A header row of a `table` (shadcn `TableHead` styling).
class ShadcnTableHeader extends ShadcnTableRow {
  /// Creates a header row.
  const ShadcnTableHeader({required super.cells});
}

/// A footer row of a `table` (muted text, no border).
class ShadcnTableFooter extends ShadcnTableRow {
  /// Creates a footer row.
  const ShadcnTableFooter({required super.cells});
}

/// One cell of a `table`.
class ShadcnTableCell implements TableCellLike {
  /// Creates a cell.
  const ShadcnTableCell({
    this.columnSpan = 1,
    this.rowSpan = 1,
    required this.child,
    this.columnHover = false,
    this.rowHover = true,
    this.enabled = true,
  });

  @override
  final int columnSpan;

  @override
  final int rowSpan;

  /// Cell content.
  final Widget child;

  /// Whether hovering another cell in the same column / row highlights this
  /// one.
  final bool columnHover;
  final bool rowHover;

  /// Whether the cell responds to hover.
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadcnTableCell &&
          other.columnSpan == columnSpan &&
          other.rowSpan == rowSpan &&
          other.child == child &&
          other.columnHover == columnHover &&
          other.rowHover == rowHover &&
          other.enabled == enabled;

  @override
  int get hashCode =>
      Object.hash(columnSpan, rowSpan, child, columnHover, rowHover, enabled);
}
