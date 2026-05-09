// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../calendar.dart';

/// Selection modes available for calendar components.
///
/// Determines how users can select dates in calendar widgets.
enum CalendarSelectionMode {
  /// No date selection allowed (display only).
  none,

  /// Only one date can be selected at a time.
  single,

  /// Two dates can be selected to form a date range.
  range,

  /// Multiple individual dates can be selected.
  multi,
}
