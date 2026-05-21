// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import '../../components/utility/locale_utils/locale_utils.dart';
import '../utils/util.dart';

import 'shadcn_localizations.dart';

/// Adds helpers required by object input components.
extension ShadcnLocalizationsObjectInputExtensions on ShadcnLocalizations {
  /// Default order used when rendering date fields.
  List<DatePart> get datePartsOrder => const [
    DatePart.month,
    DatePart.day,
    DatePart.year,
  ];

  /// Returns the abbreviation for the provided [DatePart].
  String getDatePartAbbreviation(DatePart part) {
    switch (part) {
      case DatePart.year:
        return 'YYYY';
      case DatePart.month:
        return 'MM';
      case DatePart.day:
        return 'DD';
    }
  }

  /// Returns the abbreviation for the provided [TimePart].
  String getTimePartAbbreviation(TimePart part) {
    switch (part) {
      case TimePart.hour:
        return timeHoursAbbreviation;
      case TimePart.minute:
        return timeMinutesAbbreviation;
      case TimePart.second:
        return timeSecondsAbbreviation;
    }
  }

  /// Formats a [TimeOfDay] object into a string.
  ///
  /// [use24HourFormat] - Whether to use 24-hour format.
  /// [showSeconds] - Whether to include seconds.
  String formatTimeOfDay(
    TimeOfDay time, {
    bool use24HourFormat = true,
    bool showSeconds = false,
  }) {
    /// Stores `result` state/configuration for this implementation.
    String result = '';
    if (use24HourFormat) {
      result +=
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      if (showSeconds) {
        result += ':${time.second.toString().padLeft(2, '0')}';
      }
    } else {
      /// Stores `hour` state/configuration for this implementation.
      int hour = time.hour;
      if (hour > 12) {
        hour -= 12;
        if (showSeconds) {
          result +=
              '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} $timePM';
        } else {
          result +=
              '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $timePM';
        }
      } else {
        if (showSeconds) {
          result +=
              '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} $timeAM';
        } else {
          result +=
              '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $timeAM';
        }
      }
    }
    return result;
  }

  /// Formats a [Duration] into a string.
  ///
  /// [showDays] - Whether to show days.
  /// [showHours] - Whether to show hours.
  /// [showMinutes] - Whether to show minutes.
  /// [showSeconds] - Whether to show seconds.
  String formatDuration(
    Duration duration, {
    bool showDays = true,
    bool showHours = true,
    bool showMinutes = true,
    bool showSeconds = true,
  }) {
    /// Stores `days` state/configuration for this implementation.
    final days = duration.inDays;

    /// Stores `hours` state/configuration for this implementation.
    final hours = duration.inHours % Duration.hoursPerDay;

    /// Stores `minutes` state/configuration for this implementation.
    final minutes = duration.inMinutes % Duration.minutesPerHour;

    /// Stores `seconds` state/configuration for this implementation.
    final seconds = duration.inSeconds % Duration.secondsPerMinute;

    /// Stores `parts` state/configuration for this implementation.
    final parts = <String>[];
    if (showDays && days > 0) {
      parts.add('${days}d');
    }
    if (showHours && hours > 0) {
      parts.add('${hours}h');
    }
    if (showMinutes && minutes > 0) {
      parts.add('${minutes}m');
    }
    if (showSeconds && seconds > 0) {
      parts.add('${seconds}s');
    }
    return parts.join(' ');
  }

  /// Gets the abbreviation for a [DurationPart].
  String getDurationPartAbbreviation(DurationPart part) {
    switch (part) {
      case DurationPart.day:
        return timeDaysAbbreviation;
      case DurationPart.hour:
        return timeHoursAbbreviation;
      case DurationPart.minute:
        return timeMinutesAbbreviation;
      case DurationPart.second:
        return timeSecondsAbbreviation;
    }
  }

  /// Formats a [DateTime] into a localized string.
  ///
  /// [showDate] - Whether to include the date portion.
  /// [showTime] - Whether to include the time portion.
  /// [showSeconds] - Whether to include seconds in the time portion.
  /// [use24HourFormat] - Whether to use 24-hour time formatting.
  String formatDateTime(
    DateTime dateTime, {
    bool showDate = true,
    bool showTime = true,
    bool showSeconds = false,
    bool use24HourFormat = true,
  }) {
    /// Stores `result` state/configuration for this implementation.
    String result = '';
    if (showDate) {
      result += '${getMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    }
    if (showTime) {
      if (result.isNotEmpty) {
        result += ' ';
      }
      if (use24HourFormat) {
        result += '${dateTime.hour}:${dateTime.minute}';
        if (showSeconds) {
          result += ':${dateTime.second}';
        }
      } else {
        /// Stores `hour` state/configuration for this implementation.
        int hour = dateTime.hour;
        if (hour > 12) {
          hour -= 12;
          result += '$hour:${dateTime.minute} $timePM';
        } else {
          result += '$hour:${dateTime.minute} $timeAM';
        }
      }
    }
    return result;
  }
}
