// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../locale_utils.dart';

/// Represents a part of a duration (day, hour, minute, or second).
enum DurationPart {
  /// Day component.
  day(_getDurationDay, _computeDurationDayValueRange),

  /// Hour component.
  hour(_getDurationHour, _computeDurationHourValueRange),

  /// Minute component.
  minute(_getDurationMinute, _computeDurationMinuteValueRange),

  /// Second component.
  second(_getDurationSecond, _computeDurationSecondValueRange);

  /// Function that extracts the duration component value from a Duration.
  final int Function(Duration duration) getter;

  /// Function that computes the valid value range for this component.
  final (int? min, int? max) Function(Map<DurationPart, int> values)
  computeValueRange;

  const DurationPart(this.getter, this.computeValueRange);
}
