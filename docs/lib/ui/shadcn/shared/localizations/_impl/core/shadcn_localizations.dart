// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../shadcn_localizations.dart';

/// ShadcnLocalizations defines a reusable type for this registry module.
class ShadcnLocalizations {
  const ShadcnLocalizations(this.locale);

  /// Stores `locale` state/configuration for this implementation.
  final Locale locale;

  /// Executes `of` behavior for this component/composite.
  static ShadcnLocalizations of(BuildContext context) {
    return Localizations.of<ShadcnLocalizations>(
          context,
          ShadcnLocalizations,
        ) ??
        const ShadcnLocalizations(Locale('en'));
  }

  static const LocalizationsDelegate<ShadcnLocalizations> delegate =
      _ShadcnLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[delegate];

  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Stores `commandEmpty` state/configuration for this implementation.
  String get commandEmpty => 'No results found';

  /// Stores `commandSearch` state/configuration for this implementation.
  String get commandSearch => 'Type a command or search...';

  /// Stores `commandMoveUp` state/configuration for this implementation.
  String get commandMoveUp => 'Move up';

  /// Stores `commandMoveDown` state/configuration for this implementation.
  String get commandMoveDown => 'Move down';

  /// Stores `commandActivate` state/configuration for this implementation.
  String get commandActivate => 'Activate';

  /// Stores `buttonCancel` state/configuration for this implementation.
  String get buttonCancel => 'Cancel';

  /// Stores `buttonSave` state/configuration for this implementation.
  String get buttonSave => 'Save';

  /// Stores `buttonPrevious` state/configuration for this implementation.
  String get buttonPrevious => 'Previous';

  /// Stores `buttonNext` state/configuration for this implementation.
  String get buttonNext => 'Next';

  /// Stores `datePickerSelectYear` state/configuration for this implementation.
  String get datePickerSelectYear => 'Select a year';

  /// Stores `placeholderDatePicker` state/configuration for this implementation.
  String get placeholderDatePicker => 'Pick a date';

  /// Stores `timeAM` state/configuration for this implementation.
  String get timeAM => 'AM';

  /// Stores `timePM` state/configuration for this implementation.
  String get timePM => 'PM';

  /// Stores `timeHour` state/configuration for this implementation.
  String get timeHour => 'Hour';

  /// Stores `timeMinute` state/configuration for this implementation.
  String get timeMinute => 'Minute';

  /// Stores `timeSecond` state/configuration for this implementation.
  String get timeSecond => 'Second';

  /// Stores `placeholderTimePicker` state/configuration for this implementation.
  String get placeholderTimePicker => 'Select a time';

  /// Stores `placeholderDurationPicker` state/configuration for this implementation.
  String get placeholderDurationPicker => 'Select a duration';

  /// Stores `durationDay` state/configuration for this implementation.
  String get durationDay => 'Day';

  /// Stores `durationHour` state/configuration for this implementation.
  String get durationHour => 'Hour';

  /// Stores `durationMinute` state/configuration for this implementation.
  String get durationMinute => 'Minute';

  /// Stores `durationSecond` state/configuration for this implementation.
  String get durationSecond => 'Second';

  /// Stores `timeDaysAbbreviation` state/configuration for this implementation.
  String get timeDaysAbbreviation => 'DD';

  /// Stores `timeHoursAbbreviation` state/configuration for this implementation.
  String get timeHoursAbbreviation => 'HH';

  /// Stores `timeMinutesAbbreviation` state/configuration for this implementation.
  String get timeMinutesAbbreviation => 'MM';

  /// Stores `timeSecondsAbbreviation` state/configuration for this implementation.
  String get timeSecondsAbbreviation => 'SS';

  /// Stores `menuCut` state/configuration for this implementation.
  String get menuCut => 'Cut';

  /// Stores `menuCopy` state/configuration for this implementation.
  String get menuCopy => 'Copy';

  /// Stores `menuPaste` state/configuration for this implementation.
  String get menuPaste => 'Paste';

  /// Stores `menuSelectAll` state/configuration for this implementation.
  String get menuSelectAll => 'Select all';

  /// Stores `menuShare` state/configuration for this implementation.
  String get menuShare => 'Share';

  /// Stores `menuSearchWeb` state/configuration for this implementation.
  String get menuSearchWeb => 'Search web';

  /// Stores `menuLiveTextInput` state/configuration for this implementation.
  String get menuLiveTextInput => 'Live text input';

  /// Stores `menuUndo` state/configuration for this implementation.
  String get menuUndo => 'Undo';

  /// Stores `menuRedo` state/configuration for this implementation.
  String get menuRedo => 'Redo';

  /// Stores `menuDelete` state/configuration for this implementation.
  String get menuDelete => 'Delete';

  /// Stores `refreshTriggerRefreshing` state/configuration for this implementation.
  String get refreshTriggerRefreshing => 'Refreshing...';

  /// Stores `refreshTriggerComplete` state/configuration for this implementation.
  String get refreshTriggerComplete => 'Refresh complete';

  /// Stores `refreshTriggerPull` state/configuration for this implementation.
  String get refreshTriggerPull => 'Pull to refresh';

  /// Stores `refreshTriggerRelease` state/configuration for this implementation.
  String get refreshTriggerRelease => 'Release to refresh';

  /// Stores `placeholderColorPicker` state/configuration for this implementation.
  String get placeholderColorPicker => 'Pick a color';

  /// Stores `colorPickerTabRGB` state/configuration for this implementation.
  String get colorPickerTabRGB => 'RGB';

  /// Stores `colorPickerTabHSL` state/configuration for this implementation.
  String get colorPickerTabHSL => 'HSL';

  /// Stores `colorPickerTabHSV` state/configuration for this implementation.
  String get colorPickerTabHSV => 'HSV';

  /// Stores `colorPickerTabHEX` state/configuration for this implementation.
  String get colorPickerTabHEX => 'HEX';

  /// Stores `colorRed` state/configuration for this implementation.
  String get colorRed => 'Red';

  /// Stores `colorGreen` state/configuration for this implementation.
  String get colorGreen => 'Green';

  /// Stores `colorBlue` state/configuration for this implementation.
  String get colorBlue => 'Blue';

  /// Stores `colorAlpha` state/configuration for this implementation.
  String get colorAlpha => 'Alpha';

  /// Stores `colorHue` state/configuration for this implementation.
  String get colorHue => 'Hue';

  /// Stores `colorSaturation` state/configuration for this implementation.
  String get colorSaturation => 'Saturation';

  /// Stores `colorLightness` state/configuration for this implementation.
  String get colorLightness => 'Lightness';

  /// Stores `colorValue` state/configuration for this implementation.
  String get colorValue => 'Value';

  /// Stores `formNotEmpty` state/configuration for this implementation.
  String get formNotEmpty => 'This field cannot be empty.';

  /// Executes `formLessThan` behavior for this component/composite.
  String formLessThan(Object? value) => 'Must be less than $value.';

  /// Executes `formGreaterThan` behavior for this component/composite.
  String formGreaterThan(Object? value) => 'Must be greater than $value.';

  /// Executes `formLessThanOrEqualTo` behavior for this component/composite.
  String formLessThanOrEqualTo(Object? value) =>
      'Must be less than or equal to $value.';

  /// Executes `formGreaterThanOrEqualTo` behavior for this component/composite.
  String formGreaterThanOrEqualTo(Object? value) =>
      'Must be greater than or equal to $value.';

  /// Executes `formEqualTo` behavior for this component/composite.
  String formEqualTo(Object? value) => 'Must be equal to $value.';

  /// Executes `formBetweenInclusively` behavior for this component/composite.
  String formBetweenInclusively(Object? min, Object? max) =>
      'Must be between $min and $max (inclusive).';

  /// Executes `formBetweenExclusively` behavior for this component/composite.
  String formBetweenExclusively(Object? min, Object? max) =>
      'Must be between $min and $max (exclusive).';

  /// Executes `formLengthLessThan` behavior for this component/composite.
  String formLengthLessThan(int limit) =>
      'Must be shorter than $limit characters.';

  /// Executes `formLengthGreaterThan` behavior for this component/composite.
  String formLengthGreaterThan(int limit) =>
      'Must be at least $limit characters.';

  /// Stores `formPasswordDigits` state/configuration for this implementation.
  String get formPasswordDigits => 'Must include at least one digit.';

  /// Stores `formPasswordLowercase` state/configuration for this implementation.
  String get formPasswordLowercase =>
      'Must include at least one lowercase letter.';

  /// Stores `formPasswordUppercase` state/configuration for this implementation.
  String get formPasswordUppercase =>
      'Must include at least one uppercase letter.';

  /// Stores `formPasswordSpecial` state/configuration for this implementation.
  String get formPasswordSpecial =>
      'Must include at least one special character.';

  /// Stores `invalidValue` state/configuration for this implementation.
  String get invalidValue => 'Invalid value provided.';

  /// Stores `invalidEmail` state/configuration for this implementation.
  String get invalidEmail => 'Invalid email address.';

  /// Stores `invalidURL` state/configuration for this implementation.
  String get invalidURL => 'Invalid URL.';

  /// Stores `monthJanuary` state/configuration for this implementation.
  String get monthJanuary => 'January';

  /// Stores `monthFebruary` state/configuration for this implementation.
  String get monthFebruary => 'February';

  /// Stores `monthMarch` state/configuration for this implementation.
  String get monthMarch => 'March';

  /// Stores `monthApril` state/configuration for this implementation.
  String get monthApril => 'April';

  /// Stores `monthMay` state/configuration for this implementation.
  String get monthMay => 'May';

  /// Stores `monthJune` state/configuration for this implementation.
  String get monthJune => 'June';

  /// Stores `monthJuly` state/configuration for this implementation.
  String get monthJuly => 'July';

  /// Stores `monthAugust` state/configuration for this implementation.
  String get monthAugust => 'August';

  /// Stores `monthSeptember` state/configuration for this implementation.
  String get monthSeptember => 'September';

  /// Stores `monthOctober` state/configuration for this implementation.
  String get monthOctober => 'October';

  /// Stores `monthNovember` state/configuration for this implementation.
  String get monthNovember => 'November';

  /// Stores `monthDecember` state/configuration for this implementation.
  String get monthDecember => 'December';

  /// Stores `abbreviatedMonday` state/configuration for this implementation.
  String get abbreviatedMonday => 'Mon';

  /// Stores `abbreviatedTuesday` state/configuration for this implementation.
  String get abbreviatedTuesday => 'Tue';

  /// Stores `abbreviatedWednesday` state/configuration for this implementation.
  String get abbreviatedWednesday => 'Wed';

  /// Stores `abbreviatedThursday` state/configuration for this implementation.
  String get abbreviatedThursday => 'Thu';

  /// Stores `abbreviatedFriday` state/configuration for this implementation.
  String get abbreviatedFriday => 'Fri';

  /// Stores `abbreviatedSaturday` state/configuration for this implementation.
  String get abbreviatedSaturday => 'Sat';

  /// Stores `abbreviatedSunday` state/configuration for this implementation.
  String get abbreviatedSunday => 'Sun';

  /// Stores `abbreviatedJanuary` state/configuration for this implementation.
  String get abbreviatedJanuary => 'Jan';

  /// Stores `abbreviatedFebruary` state/configuration for this implementation.
  String get abbreviatedFebruary => 'Feb';

  /// Stores `abbreviatedMarch` state/configuration for this implementation.
  String get abbreviatedMarch => 'Mar';

  /// Stores `abbreviatedApril` state/configuration for this implementation.
  String get abbreviatedApril => 'Apr';

  /// Stores `abbreviatedMay` state/configuration for this implementation.
  String get abbreviatedMay => 'May';

  /// Stores `abbreviatedJune` state/configuration for this implementation.
  String get abbreviatedJune => 'Jun';

  /// Stores `abbreviatedJuly` state/configuration for this implementation.
  String get abbreviatedJuly => 'Jul';

  /// Stores `abbreviatedAugust` state/configuration for this implementation.
  String get abbreviatedAugust => 'Aug';

  /// Stores `abbreviatedSeptember` state/configuration for this implementation.
  String get abbreviatedSeptember => 'Sep';

  /// Stores `abbreviatedOctober` state/configuration for this implementation.
  String get abbreviatedOctober => 'Oct';

  /// Stores `abbreviatedNovember` state/configuration for this implementation.
  String get abbreviatedNovember => 'Nov';

  /// Stores `abbreviatedDecember` state/configuration for this implementation.
  String get abbreviatedDecember => 'Dec';

  /// Executes `getAbbreviatedWeekday` behavior for this component/composite.
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

  /// Executes `getMonth` behavior for this component/composite.
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

  /// Executes `getAbbreviatedMonth` behavior for this component/composite.
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
