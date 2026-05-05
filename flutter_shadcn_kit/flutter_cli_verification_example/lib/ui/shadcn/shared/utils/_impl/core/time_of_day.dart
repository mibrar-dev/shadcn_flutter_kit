part of '../../util.dart';
/// Represents a time of day with hour, minute, and second.

/// TimeOfDay defines a reusable type for this registry module.
class TimeOfDay {
  /// Hour component (0-23).
  final int hour;

  /// Minute component (0-59).
  final int minute;

  /// Second component (0-59).
  final int second;

  /// Creates a [TimeOfDay] with specified components.
  ///
  /// Parameters:
  /// - [hour] (`int`, required): Hour (0-23).
  /// - [minute] (`int`, required): Minute (0-59).
  /// - [second] (`int`, default: 0): Second (0-59).
  const TimeOfDay({
    required this.hour,
    required this.minute,
    this.second = 0,
  });

  /// Creates a PM time (adds 12 to the hour).
  ///
  /// Parameters:
  /// - [hour] (`int`, required): Hour in 12-hour format (1-12).
  /// - [minute] (`int`, required): Minute (0-59).
  /// - [second] (`int`, default: 0): Second (0-59).
  const TimeOfDay.pm({
    required int hour,
    required this.minute,
    this.second = 0,
  }) : hour = hour + 12;

  /// Creates an AM time.
  ///
  /// Parameters:
  /// - [hour] (`int`, required): Hour in 12-hour format (0-11).
  /// - [minute] (`int`, required): Minute (0-59).
  /// - [second] (`int`, default: 0): Second (0-59).
  const TimeOfDay.am({
    required this.hour,
    required this.minute,
    this.second = 0,
  });

  /// Creates a [TimeOfDay] from a [DateTime].
  ///
  /// Parameters:
  /// - [dateTime] (`DateTime`, required): DateTime to extract time from.
  TimeOfDay.fromDateTime(DateTime dateTime)
      : hour = dateTime.hour,
        minute = dateTime.minute,
        second = dateTime.second;

  /// Creates a [TimeOfDay] from a [Duration].
  ///
  /// Parameters:
  /// - [duration] (`Duration`, required): Duration to convert.
  TimeOfDay.fromDuration(Duration duration)
      : hour = duration.inHours,
        minute = duration.inMinutes % 60,
        second = duration.inSeconds % 60;

  /// Creates a [TimeOfDay] representing the current time.
  TimeOfDay.now() : this.fromDateTime(DateTime.now());

  /// Creates a copy with specified fields replaced.
  ///
  /// Parameters:
  /// - [hour] (`ValueGetter<int>?`, optional): New hour value.
  /// - [minute] (`ValueGetter<int>?`, optional): New minute value.
  /// - [second] (`ValueGetter<int>?`, optional): New second value.
  ///
  /// Returns: `TimeOfDay` — copy with updated values.
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

  /// Creates a copy with optional replacements.
  TimeOfDay replacing({
    int? hour,
    int? minute,
    int? second,
  }) {
    return TimeOfDay(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is TimeOfDay &&
        other.hour == hour &&
        other.minute == minute &&
        other.second == second;
  }

  @override
  int get hashCode => Object.hash(hour, minute, second);

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'TimeOfDay{hour: $hour, minute: $minute, second: $second}';
  }
}
