import '../../foundation/time_of_day.dart';
import 'locale_parts.dart';
import 'localizations.dart';

/// Formatting helpers built on the [ShadcnLocalizations] strings.
///
/// The words come from the localizations instance; the separators, padding and
/// 12/24-hour convention come from the arguments.
extension ShadcnLocalizationsExtensions on ShadcnLocalizations {
  /// The order date fields are presented in unless the app overrides it.
  ///
  /// Month/day/year, matching the shadcn and platform defaults.
  List<DatePart> get datePartsOrder => const [
    DatePart.month,
    DatePart.day,
    DatePart.year,
  ];

  /// Abbreviation for the year component, e.g. `YYYY`.
  String get dateYearAbbreviation => 'YYYY';

  /// Abbreviation for the month component, e.g. `MM`.
  String get dateMonthAbbreviation => 'MM';

  /// Abbreviation for the day component, e.g. `DD`.
  String get dateDayAbbreviation => 'DD';

  /// The placeholder for one date field, e.g. `MM` for [DatePart.month].
  String getDatePartAbbreviation(DatePart part) {
    switch (part) {
      case DatePart.year:
        return dateYearAbbreviation;
      case DatePart.month:
        return dateMonthAbbreviation;
      case DatePart.day:
        return dateDayAbbreviation;
    }
  }

  /// The placeholder for one clock field, e.g. `HH` for [TimePart.hour].
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

  /// The placeholder for one duration field, e.g. `HH` for [DurationPart.hour].
  ///
  /// Shares [getTimePartAbbreviation]'s placeholders: a duration has no separate
  /// notation, so `DD` doubles as the day placeholder.
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

  /// Formats [value] without a decimal point when it is a whole number.
  ///
  /// `1500.0` renders as `1500`, `1.5` as `1.5`.
  String formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  /// Renders [dateTime] as a localized date, optionally followed by the time.
  ///
  /// [showDate] drops the date part and [showTime] drops the time part;
  /// [showSeconds] adds seconds and [use24HourFormat] picks the clock
  /// convention. 12-hour output appends [timeAM] or [timePM] and ignores
  /// [showSeconds].
  String formatDateTime(
    DateTime dateTime, {
    bool showDate = true,
    bool showTime = true,
    bool showSeconds = false,
    bool use24HourFormat = true,
  }) {
    var result = '';
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
        var hour = dateTime.hour;
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

  /// Renders [time] as a clock string with zero-padded components.
  ///
  /// [use24HourFormat] picks the clock convention and [showSeconds] adds the
  /// seconds component. 12-hour output appends [timeAM] or [timePM].
  String formatTimeOfDay(
    TimeOfDay time, {
    bool use24HourFormat = true,
    bool showSeconds = false,
  }) {
    var result = '';
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    final ss = time.second.toString().padLeft(2, '0');
    if (use24HourFormat) {
      result = '$hh:$mm';
      if (showSeconds) {
        result += ':$ss';
      }
      return result;
    }
    final int hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final String period = time.hour < 12 ? timeAM : timePM;
    result = showSeconds ? '$hour12:$mm:$ss $period' : '$hour12:$mm $period';
    return result;
  }

  /// Renders [duration] as a compact `1d 2h 3m 4s` string.
  ///
  /// Each component is dropped when its flag is false, and zero components are
  /// dropped regardless of the flags.
  String formatDuration(
    Duration duration, {
    bool showDays = true,
    bool showHours = true,
    bool showMinutes = true,
    bool showSeconds = true,
  }) {
    final days = duration.inDays;
    final hours = duration.inHours % Duration.hoursPerDay;
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    final seconds = duration.inSeconds % Duration.secondsPerMinute;

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
}
