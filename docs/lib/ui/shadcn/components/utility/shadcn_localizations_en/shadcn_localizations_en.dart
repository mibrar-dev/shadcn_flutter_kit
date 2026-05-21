// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:intl/intl.dart' as intl;
import '../shadcn_localizations/shadcn_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ShadcnLocalizationsEn extends ShadcnLocalizations {
  ShadcnLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  /// Stores `formNotEmpty` state/configuration for this implementation.
  String get formNotEmpty => 'This field cannot be empty';

  @override
  /// Stores `invalidValue` state/configuration for this implementation.
  String get invalidValue => 'Invalid value';

  @override
  /// Stores `invalidEmail` state/configuration for this implementation.
  String get invalidEmail => 'Invalid email';

  @override
  /// Stores `invalidURL` state/configuration for this implementation.
  String get invalidURL => 'Invalid URL';

  @override
  /// Executes `formLessThan` behavior for this component/composite.
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Must be less than $valueString';
  }

  @override
  /// Executes `formGreaterThan` behavior for this component/composite.
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Must be greater than $valueString';
  }

  @override
  /// Executes `formLessThanOrEqualTo` behavior for this component/composite.
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Must be less than or equal to $valueString';
  }

  @override
  /// Executes `formGreaterThanOrEqualTo` behavior for this component/composite.
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Must be greater than or equal to $valueString';
  }

  @override
  /// Executes `formBetweenInclusively` behavior for this component/composite.
  String formBetweenInclusively(double min, double max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'Must be between $minString and $maxString (inclusive)';
  }

  @override
  /// Executes `formBetweenExclusively` behavior for this component/composite.
  String formBetweenExclusively(double min, double max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'Must be between $minString and $maxString (exclusive)';
  }

  @override
  /// Executes `formLengthLessThan` behavior for this component/composite.
  String formLengthLessThan(int value) {
    return 'Must be at least $value characters';
  }

  @override
  /// Executes `formLengthGreaterThan` behavior for this component/composite.
  String formLengthGreaterThan(int value) {
    return 'Must be at most $value characters';
  }

  @override
  /// Stores `formPasswordDigits` state/configuration for this implementation.
  String get formPasswordDigits => 'Must contain at least one digit';

  @override
  String get formPasswordLowercase =>
      'Must contain at least one lowercase letter';

  @override
  String get formPasswordUppercase =>
      'Must contain at least one uppercase letter';

  @override
  String get formPasswordSpecial =>
      'Must contain at least one special character';

  @override
  /// Stores `commandSearch` state/configuration for this implementation.
  String get commandSearch => 'Type a command or search...';

  @override
  /// Stores `commandEmpty` state/configuration for this implementation.
  String get commandEmpty => 'No results found.';

  @override
  /// Stores `datePickerSelectYear` state/configuration for this implementation.
  String get datePickerSelectYear => 'Select a year';

  @override
  /// Stores `abbreviatedMonday` state/configuration for this implementation.
  String get abbreviatedMonday => 'Mo';

  @override
  /// Stores `abbreviatedTuesday` state/configuration for this implementation.
  String get abbreviatedTuesday => 'Tu';

  @override
  /// Stores `abbreviatedWednesday` state/configuration for this implementation.
  String get abbreviatedWednesday => 'We';

  @override
  /// Stores `abbreviatedThursday` state/configuration for this implementation.
  String get abbreviatedThursday => 'Th';

  @override
  /// Stores `abbreviatedFriday` state/configuration for this implementation.
  String get abbreviatedFriday => 'Fr';

  @override
  /// Stores `abbreviatedSaturday` state/configuration for this implementation.
  String get abbreviatedSaturday => 'Sa';

  @override
  /// Stores `abbreviatedSunday` state/configuration for this implementation.
  String get abbreviatedSunday => 'Su';

  @override
  /// Stores `monthJanuary` state/configuration for this implementation.
  String get monthJanuary => 'January';

  @override
  /// Stores `monthFebruary` state/configuration for this implementation.
  String get monthFebruary => 'February';

  @override
  /// Stores `monthMarch` state/configuration for this implementation.
  String get monthMarch => 'March';

  @override
  /// Stores `monthApril` state/configuration for this implementation.
  String get monthApril => 'April';

  @override
  /// Stores `monthMay` state/configuration for this implementation.
  String get monthMay => 'May';

  @override
  /// Stores `monthJune` state/configuration for this implementation.
  String get monthJune => 'June';

  @override
  /// Stores `monthJuly` state/configuration for this implementation.
  String get monthJuly => 'July';

  @override
  /// Stores `monthAugust` state/configuration for this implementation.
  String get monthAugust => 'August';

  @override
  /// Stores `monthSeptember` state/configuration for this implementation.
  String get monthSeptember => 'September';

  @override
  /// Stores `monthOctober` state/configuration for this implementation.
  String get monthOctober => 'October';

  @override
  /// Stores `monthNovember` state/configuration for this implementation.
  String get monthNovember => 'November';

  @override
  /// Stores `monthDecember` state/configuration for this implementation.
  String get monthDecember => 'December';

  @override
  /// Stores `abbreviatedJanuary` state/configuration for this implementation.
  String get abbreviatedJanuary => 'Jan';

  @override
  /// Stores `abbreviatedFebruary` state/configuration for this implementation.
  String get abbreviatedFebruary => 'Feb';

  @override
  /// Stores `abbreviatedMarch` state/configuration for this implementation.
  String get abbreviatedMarch => 'Mar';

  @override
  /// Stores `abbreviatedApril` state/configuration for this implementation.
  String get abbreviatedApril => 'Apr';

  @override
  /// Stores `abbreviatedMay` state/configuration for this implementation.
  String get abbreviatedMay => 'May';

  @override
  /// Stores `abbreviatedJune` state/configuration for this implementation.
  String get abbreviatedJune => 'Jun';

  @override
  /// Stores `abbreviatedJuly` state/configuration for this implementation.
  String get abbreviatedJuly => 'Jul';

  @override
  /// Stores `abbreviatedAugust` state/configuration for this implementation.
  String get abbreviatedAugust => 'Aug';

  @override
  /// Stores `abbreviatedSeptember` state/configuration for this implementation.
  String get abbreviatedSeptember => 'Sep';

  @override
  /// Stores `abbreviatedOctober` state/configuration for this implementation.
  String get abbreviatedOctober => 'Oct';

  @override
  /// Stores `abbreviatedNovember` state/configuration for this implementation.
  String get abbreviatedNovember => 'Nov';

  @override
  /// Stores `abbreviatedDecember` state/configuration for this implementation.
  String get abbreviatedDecember => 'Dec';

  @override
  /// Stores `buttonCancel` state/configuration for this implementation.
  String get buttonCancel => 'Cancel';

  @override
  /// Stores `buttonSave` state/configuration for this implementation.
  String get buttonSave => 'Save';

  @override
  /// Stores `timeHour` state/configuration for this implementation.
  String get timeHour => 'Hour';

  @override
  /// Stores `timeMinute` state/configuration for this implementation.
  String get timeMinute => 'Minute';

  @override
  /// Stores `timeSecond` state/configuration for this implementation.
  String get timeSecond => 'Second';

  @override
  /// Stores `timeAM` state/configuration for this implementation.
  String get timeAM => 'AM';

  @override
  /// Stores `timePM` state/configuration for this implementation.
  String get timePM => 'PM';

  @override
  /// Stores `colorRed` state/configuration for this implementation.
  String get colorRed => 'Red';

  @override
  /// Stores `colorGreen` state/configuration for this implementation.
  String get colorGreen => 'Green';

  @override
  /// Stores `colorBlue` state/configuration for this implementation.
  String get colorBlue => 'Blue';

  @override
  /// Stores `colorAlpha` state/configuration for this implementation.
  String get colorAlpha => 'Alpha';

  @override
  /// Stores `colorHue` state/configuration for this implementation.
  String get colorHue => 'Hue';

  @override
  /// Stores `colorSaturation` state/configuration for this implementation.
  String get colorSaturation => 'Sat';

  @override
  /// Stores `colorValue` state/configuration for this implementation.
  String get colorValue => 'Val';

  @override
  /// Stores `colorLightness` state/configuration for this implementation.
  String get colorLightness => 'Lum';

  @override
  /// Stores `menuCut` state/configuration for this implementation.
  String get menuCut => 'Cut';

  @override
  /// Stores `menuCopy` state/configuration for this implementation.
  String get menuCopy => 'Copy';

  @override
  /// Stores `menuPaste` state/configuration for this implementation.
  String get menuPaste => 'Paste';

  @override
  /// Stores `menuSelectAll` state/configuration for this implementation.
  String get menuSelectAll => 'Select All';

  @override
  /// Stores `menuUndo` state/configuration for this implementation.
  String get menuUndo => 'Undo';

  @override
  /// Stores `menuRedo` state/configuration for this implementation.
  String get menuRedo => 'Redo';

  @override
  /// Stores `menuDelete` state/configuration for this implementation.
  String get menuDelete => 'Delete';

  @override
  /// Stores `menuShare` state/configuration for this implementation.
  String get menuShare => 'Share';

  @override
  /// Stores `menuSearchWeb` state/configuration for this implementation.
  String get menuSearchWeb => 'Search Web';

  @override
  /// Stores `menuLiveTextInput` state/configuration for this implementation.
  String get menuLiveTextInput => 'Live Text Input';

  @override
  /// Stores `placeholderDatePicker` state/configuration for this implementation.
  String get placeholderDatePicker => 'Select a date';

  @override
  /// Stores `placeholderTimePicker` state/configuration for this implementation.
  String get placeholderTimePicker => 'Select a time';

  @override
  /// Stores `placeholderColorPicker` state/configuration for this implementation.
  String get placeholderColorPicker => 'Select a color';

  @override
  /// Stores `buttonPrevious` state/configuration for this implementation.
  String get buttonPrevious => 'Previous';

  @override
  /// Stores `buttonNext` state/configuration for this implementation.
  String get buttonNext => 'Next';

  @override
  /// Stores `refreshTriggerPull` state/configuration for this implementation.
  String get refreshTriggerPull => 'Pull to refresh';

  @override
  /// Stores `refreshTriggerRelease` state/configuration for this implementation.
  String get refreshTriggerRelease => 'Release to refresh';

  @override
  /// Stores `refreshTriggerRefreshing` state/configuration for this implementation.
  String get refreshTriggerRefreshing => 'Refreshing...';

  @override
  /// Stores `refreshTriggerComplete` state/configuration for this implementation.
  String get refreshTriggerComplete => 'Refresh complete';

  @override
  /// Stores `colorPickerTabRecent` state/configuration for this implementation.
  String get colorPickerTabRecent => 'Recent';

  @override
  /// Stores `colorPickerTabRGB` state/configuration for this implementation.
  String get colorPickerTabRGB => 'RGB';

  @override
  /// Stores `colorPickerTabHSV` state/configuration for this implementation.
  String get colorPickerTabHSV => 'HSV';

  @override
  /// Stores `colorPickerTabHSL` state/configuration for this implementation.
  String get colorPickerTabHSL => 'HSL';

  @override
  /// Stores `colorPickerTabHEX` state/configuration for this implementation.
  String get colorPickerTabHEX => 'HEX';

  @override
  /// Stores `commandMoveUp` state/configuration for this implementation.
  String get commandMoveUp => 'Move Up';

  @override
  /// Stores `commandMoveDown` state/configuration for this implementation.
  String get commandMoveDown => 'Move Down';

  @override
  /// Stores `commandActivate` state/configuration for this implementation.
  String get commandActivate => 'Select';

  @override
  /// Executes `dataTableSelectedRows` behavior for this component/composite.
  String dataTableSelectedRows(int count, int total) {
    return '$count of $total row(s) selected.';
  }

  @override
  /// Stores `dataTableNext` state/configuration for this implementation.
  String get dataTableNext => 'Next';

  @override
  /// Stores `dataTablePrevious` state/configuration for this implementation.
  String get dataTablePrevious => 'Previous';

  @override
  /// Stores `dataTableColumns` state/configuration for this implementation.
  String get dataTableColumns => 'Columns';

  @override
  /// Stores `timeDaysAbbreviation` state/configuration for this implementation.
  String get timeDaysAbbreviation => 'DD';

  @override
  /// Stores `timeHoursAbbreviation` state/configuration for this implementation.
  String get timeHoursAbbreviation => 'HH';

  @override
  /// Stores `timeMinutesAbbreviation` state/configuration for this implementation.
  String get timeMinutesAbbreviation => 'MM';

  @override
  /// Stores `timeSecondsAbbreviation` state/configuration for this implementation.
  String get timeSecondsAbbreviation => 'SS';

  @override
  /// Stores `placeholderDurationPicker` state/configuration for this implementation.
  String get placeholderDurationPicker => 'Select a duration';

  @override
  /// Stores `durationDay` state/configuration for this implementation.
  String get durationDay => 'Day';

  @override
  /// Stores `durationHour` state/configuration for this implementation.
  String get durationHour => 'Hour';

  @override
  /// Stores `durationMinute` state/configuration for this implementation.
  String get durationMinute => 'Minute';

  @override
  /// Stores `durationSecond` state/configuration for this implementation.
  String get durationSecond => 'Second';
}
