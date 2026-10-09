/// One component of a calendar date.
///
/// Date pickers use it to order and label their fields, and as the key type of
/// the "which components are set" map. The concepts here are language-neutral;
/// their *labels* are locale data, via
/// [ShadcnLocalizationsExtensions.getDatePartAbbreviation].
enum DatePart {
  /// The year, conventionally written with four digits.
  year,

  /// The month, 1-12.
  month,

  /// The day of the month.
  day,
}

/// One component of a clock time.
///
/// Used to order and label the fields of a time picker; see [DatePart] for the
/// same idea applied to dates.
enum TimePart {
  /// The hour, 0-23.
  hour,

  /// The minute, 0-59.
  minute,

  /// The second, 0-59.
  second,
}

/// One component of a duration.
///
/// Used to order and label the fields of a duration picker; see [DatePart] for
/// the same idea applied to dates.
enum DurationPart {
  /// Whole days.
  day,

  /// Hours within the day.
  hour,

  /// Minutes within the hour.
  minute,

  /// Seconds within the minute.
  second,
}
