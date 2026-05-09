// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// FrozenTableData defines a reusable type for this registry module.
class FrozenTableData {
  /// Rows that should be frozen during vertical scrolling.
  final Iterable<TableRef> frozenRows;

  /// Columns that should be frozen during horizontal scrolling.
  final Iterable<TableRef> frozenColumns;

  /// Creates a [FrozenTableData].
  const FrozenTableData({
    this.frozenRows = const [],
    this.frozenColumns = const [],
  });

  /// Tests if a row at the given index and span is frozen.
  bool testRow(int index, int span) {
    for (final ref in frozenRows) {
      if (ref.test(index, span)) {
        return true;
      }
    }
    return false;
  }

  /// Tests if a column at the given index and span is frozen.
  bool testColumn(int index, int span) {
    for (final ref in frozenColumns) {
      if (ref.test(index, span)) {
        return true;
      }
    }
    return false;
  }
}

/// Parent data for table cell layout information.
///
/// Stores layout parameters for cells in a table including position,
/// span, and frozen state. Used internally by the table rendering system.
