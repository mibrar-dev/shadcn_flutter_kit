// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../time_picker.dart';

/// Represents a range of time with a start and end time.
///
/// Used to define time intervals or periods. Both [start] and [end]
/// are represented as [TimeOfDay] values.
///
/// Example:
/// ```dart
/// final workHours = TimeRange(
///   start: TimeOfDay(hour: 9, minute: 0),
///   end: TimeOfDay(hour: 17, minute: 0),
/// );
/// ```
class TimeRange {
  /// The start time of the range.
  final TimeOfDay start;

  /// The end time of the range.
  final TimeOfDay end;

  /// Creates a [TimeRange] with the specified start and end times.
  const TimeRange({required this.start, required this.end});

  /// Creates a copy of this range with the given fields replaced.
  TimeRange copyWith({
    ValueGetter<TimeOfDay>? start,
    ValueGetter<TimeOfDay>? end,
  }) {
    return TimeRange(
      start: start == null ? this.start : start(),
      end: end == null ? this.end : end(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  /// Flag indicating whether `hashCode` is enabled/active.
  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return 'TimeRange{start: $start, end: $end}';
  }
}
