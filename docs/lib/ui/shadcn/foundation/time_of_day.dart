import 'package:flutter/foundation.dart';

/// A time-of-day value used by time pickers and form keys.
///
/// Mirrors the constructor surface of Material's `TimeOfDay` so form code can
/// drop its Material import without changing call sites.
class TimeOfDay {
  /// Hour component (0-23).
  final int hour;

  /// Minute component (0-59).
  final int minute;

  /// Second component (0-59).
  final int second;

  /// Creates a [TimeOfDay] with the given components.
  const TimeOfDay({required this.hour, required this.minute, this.second = 0});

  /// Creates a PM time (adds 12 to the hour).
  const TimeOfDay.pm({required int hour, required this.minute, this.second = 0})
    : hour = hour + 12;

  /// Creates an AM time.
  const TimeOfDay.am({
    required this.hour,
    required this.minute,
    this.second = 0,
  });

  /// Creates a [TimeOfDay] from a [DateTime].
  TimeOfDay.fromDateTime(DateTime dateTime)
    : hour = dateTime.hour,
      minute = dateTime.minute,
      second = dateTime.second;

  /// Creates a [TimeOfDay] from a [Duration].
  TimeOfDay.fromDuration(Duration duration)
    : hour = duration.inHours,
      minute = duration.inMinutes % 60,
      second = duration.inSeconds % 60;

  /// Creates a [TimeOfDay] for the current wall-clock time.
  TimeOfDay.now() : this.fromDateTime(DateTime.now());

  /// Returns a copy with the given fields replaced.
  TimeOfDay copyWith({
    ValueGetter<int>? hour,
    ValueGetter<int>? minute,
    ValueGetter<int>? second,
  }) {
    return TimeOfDay(
      hour: hour == null ? this.hour : hour(),
      minute: minute == null ? this.minute : minute(),
      second: second == null ? this.second : second(),
    );
  }

  /// Returns a copy with the given fields replaced.
  TimeOfDay replacing({int? hour, int? minute, int? second}) {
    return TimeOfDay(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TimeOfDay &&
        other.hour == hour &&
        other.minute == minute &&
        other.second == second;
  }

  @override
  int get hashCode => Object.hash(hour, minute, second);

  @override
  String toString() {
    return 'TimeOfDay{hour: $hour, minute: $minute, second: $second}';
  }
}
