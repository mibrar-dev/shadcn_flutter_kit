// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// TableRef defines a reusable type for this registry module.
class TableRef {
  /// Starting index of the reference.
  final int index;

  /// Number of rows/columns spanned. Defaults to 1.
  final int span;

  /// Creates a [TableRef].
  const TableRef(this.index, [this.span = 1]);

  /// Tests if this reference includes the given index and span.
  bool test(int index, int span) {
    return this.index <= index && this.index + this.span > index;
  }
}

/// Configuration for frozen (pinned) rows and columns in a table.
///
/// Specifies which rows and columns should remain fixed in place
/// during scrolling, useful for keeping headers or key columns visible.
///
/// Example:
/// ```dart
/// FrozenTableData(
///   frozenRows: [TableRef(0)],      // Freeze first row (header)
///   frozenColumns: [TableRef(0, 2)], // Freeze first two columns
/// )
/// ```
