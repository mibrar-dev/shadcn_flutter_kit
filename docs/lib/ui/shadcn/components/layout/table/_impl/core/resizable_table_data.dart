// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// _ResizableTableData defines a reusable type for this registry module.
class _ResizableTableData {
  /// Stores `controller` state/configuration for this implementation.
  final ResizableTableController controller;

  /// Stores `cellWidthResizeMode` state/configuration for this implementation.
  final TableCellResizeMode cellWidthResizeMode;

  /// Stores `cellHeightResizeMode` state/configuration for this implementation.
  final TableCellResizeMode cellHeightResizeMode;

  /// Stores `maxColumn` state/configuration for this implementation.
  final int maxColumn;

  /// Stores `maxRow` state/configuration for this implementation.
  final int maxRow;

  /// Creates a `_ResizableTableData` instance.
  const _ResizableTableData({
    required this.controller,
    required this.cellWidthResizeMode,
    required this.cellHeightResizeMode,
    required this.maxColumn,
    required this.maxRow,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ResizableTableData &&
        other.cellWidthResizeMode == cellWidthResizeMode &&
        other.cellHeightResizeMode == cellHeightResizeMode &&
        other.maxColumn == maxColumn &&
        other.maxRow == maxRow;
  }

  @override
  int get hashCode {
    return Object.hash(
      cellWidthResizeMode,
      maxColumn,
      maxRow,
      cellHeightResizeMode,
    );
  }
}
