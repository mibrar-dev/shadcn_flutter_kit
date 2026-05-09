// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// Result type for calendar value lookup operations.
///
/// Indicates the relationship between a queried date and the current calendar selection.
enum CalendarValueLookup {
  /// Date is not part of any selection.
  none,

  /// Date is directly selected (single mode or exact match).
  selected,

  /// Date is the start of a selected range.
  start,

  /// Date is the end of a selected range.
  end,

  /// Date falls within a selected range but is not start/end.
  inRange,
}
