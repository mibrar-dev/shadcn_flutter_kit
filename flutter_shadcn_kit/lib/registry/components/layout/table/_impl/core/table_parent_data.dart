// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../table.dart';

/// TableParentData defines a reusable type for this registry module.
class TableParentData extends ContainerBoxParentData<RenderBox> {
  /// Column index of this cell.
  int? column;

  /// Row index of this cell.
  int? row;

  /// Number of columns this cell spans.
  int? columnSpan;

  /// Number of rows this cell spans.
  int? rowSpan;

  /// Whether to compute size for this cell.
  bool computeSize = true;

  /// Whether this cell's row is frozen.
  bool frozenRow = false;

  /// Whether this cell's column is frozen.
  bool frozenColumn = false;
}

/// Low-level widget for positioning cells in table layouts.
///
/// Sets parent data for a table cell widget. Used internally by
/// table implementations to manage cell positioning and spanning.
///
/// Example:
/// ```dart
/// RawCell(
///   column: 0,
///   row: 1,
///   columnSpan: 2,
///   child: Container(...),
/// )
/// ```
