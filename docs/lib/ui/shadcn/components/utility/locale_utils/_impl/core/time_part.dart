// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../locale_utils.dart';

/// Represents a part of a time (hour, minute, or second).
enum TimePart {
  /// Hour component.
  hour(_getTimeHour, _computeTimeHourValueRange),

  /// Minute component.
  minute(_getTimeMinute, _computeTimeMinuteValueRange),

  /// Second component.
  second(_getTimeSecond, _computeTimeSecondValueRange);

  /// Function that extracts the time component value from a TimeOfDay.
  final int Function(TimeOfDay time) getter;

  /// Function that computes the valid value range for this component.
  final (int? min, int? max) Function(Map<TimePart, int> values)
  computeValueRange;

  const TimePart(this.getter, this.computeValueRange);
}
