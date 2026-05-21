// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tree.dart';

/// Represents the visual position of a selected item within a group.
///
/// Used to determine border radius styling for selected tree items
/// when multiple consecutive items are selected.
enum SelectionPosition {
  /// First item in a selection group.
  start,

  /// Middle item in a selection group.
  middle,

  /// Last item in a selection group.
  end,

  /// Single selected item (not part of a group).
  single,
}
