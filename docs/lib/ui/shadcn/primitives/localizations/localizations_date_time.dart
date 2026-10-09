// Calendar, date, time and duration strings for [ShadcnLocalizations].

/// Calendar, date, time and duration text for [ShadcnLocalizations].
///
/// Applied by `ShadcnLocalizations`; every getter has an English default and
/// translated locale tables may override it.
mixin ShadcnLocalizationsDateTime {
  String get datePickerSelectYear => 'Select a year';

  String get placeholderDatePicker => 'Pick a date';

  String get timeAM => 'AM';

  String get timePM => 'PM';

  String get timeHour => 'Hour';

  String get timeMinute => 'Minute';

  String get timeSecond => 'Second';

  String get placeholderTimePicker => 'Select a time';

  String get placeholderDurationPicker => 'Select a duration';

  String get durationDay => 'Day';

  String get durationHour => 'Hour';

  String get durationMinute => 'Minute';

  String get durationSecond => 'Second';

  String get timeDaysAbbreviation => 'DD';

  String get timeHoursAbbreviation => 'HH';

  String get timeMinutesAbbreviation => 'MM';

  String get timeSecondsAbbreviation => 'SS';

  String get monthJanuary => 'January';

  String get monthFebruary => 'February';

  String get monthMarch => 'March';

  String get monthApril => 'April';

  String get monthMay => 'May';

  String get monthJune => 'June';

  String get monthJuly => 'July';

  String get monthAugust => 'August';

  String get monthSeptember => 'September';

  String get monthOctober => 'October';

  String get monthNovember => 'November';

  String get monthDecember => 'December';

  String get abbreviatedMonday => 'Mon';

  String get abbreviatedTuesday => 'Tue';

  String get abbreviatedWednesday => 'Wed';

  String get abbreviatedThursday => 'Thu';

  String get abbreviatedFriday => 'Fri';

  String get abbreviatedSaturday => 'Sat';

  String get abbreviatedSunday => 'Sun';

  String get abbreviatedJanuary => 'Jan';

  String get abbreviatedFebruary => 'Feb';

  String get abbreviatedMarch => 'Mar';

  String get abbreviatedApril => 'Apr';

  String get abbreviatedMay => 'May';

  String get abbreviatedJune => 'Jun';

  String get abbreviatedJuly => 'Jul';

  String get abbreviatedAugust => 'Aug';

  String get abbreviatedSeptember => 'Sep';

  String get abbreviatedOctober => 'Oct';

  String get abbreviatedNovember => 'Nov';

  String get abbreviatedDecember => 'Dec';

  /// The abbreviated weekday name for [weekday] (1 = Monday .. 7 = Sunday).
  String getAbbreviatedWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return abbreviatedMonday;
      case DateTime.tuesday:
        return abbreviatedTuesday;
      case DateTime.wednesday:
        return abbreviatedWednesday;
      case DateTime.thursday:
        return abbreviatedThursday;
      case DateTime.friday:
        return abbreviatedFriday;
      case DateTime.saturday:
        return abbreviatedSaturday;
      case DateTime.sunday:
        return abbreviatedSunday;
      default:
        throw ArgumentError.value(weekday, 'weekday');
    }
  }

  /// The full month name for [month] (1 = January .. 12 = December).
  String getMonth(int month) {
    switch (month) {
      case DateTime.january:
        return monthJanuary;
      case DateTime.february:
        return monthFebruary;
      case DateTime.march:
        return monthMarch;
      case DateTime.april:
        return monthApril;
      case DateTime.may:
        return monthMay;
      case DateTime.june:
        return monthJune;
      case DateTime.july:
        return monthJuly;
      case DateTime.august:
        return monthAugust;
      case DateTime.september:
        return monthSeptember;
      case DateTime.october:
        return monthOctober;
      case DateTime.november:
        return monthNovember;
      case DateTime.december:
        return monthDecember;
      default:
        throw ArgumentError.value(month, 'month');
    }
  }

  /// The abbreviated month name for [month] (1 = January .. 12 = December).
  String getAbbreviatedMonth(int month) {
    switch (month) {
      case DateTime.january:
        return abbreviatedJanuary;
      case DateTime.february:
        return abbreviatedFebruary;
      case DateTime.march:
        return abbreviatedMarch;
      case DateTime.april:
        return abbreviatedApril;
      case DateTime.may:
        return abbreviatedMay;
      case DateTime.june:
        return abbreviatedJune;
      case DateTime.july:
        return abbreviatedJuly;
      case DateTime.august:
        return abbreviatedAugust;
      case DateTime.september:
        return abbreviatedSeptember;
      case DateTime.october:
        return abbreviatedOctober;
      case DateTime.november:
        return abbreviatedNovember;
      case DateTime.december:
        return abbreviatedDecember;
      default:
        throw ArgumentError.value(month, 'month');
    }
  }
}
