// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Pashto (`ps`).
class ShadcnLocalizationsPs extends ShadcnLocalizations {
  /// Creates the Pashto localizations.
  ShadcnLocalizationsPs([super.locale = 'ps']);

  @override
  TextDirection get textDirection => TextDirection.rtl;

  @override
  String get formNotEmpty => 'دا برخه نشي تشه پاتې کېدای';

  @override
  String get invalidValue => 'ناسم ارزښت';

  @override
  String get invalidEmail => 'ناسم بریښنالیک';

  @override
  String get invalidURL => 'ناسم URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید له $valueString څخه کم وي';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید له $valueString څخه ډېر وي';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید له $valueString څخه کم یا ورسره برابر وي';
  }

  String get formPhoneNumberInvalid => 'د تلیفون شمېره ناسمه ده';

  String get formPhoneNumberEmpty => 'د تلیفون شمېره اړینه ده';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید له $valueString څخه ډېر یا ورسره برابر وي';
  }

  @override
  String formBetweenInclusively(double min, double max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'باید د $minString او $maxString ترمنځ وي (دواړه شامل)';
  }

  String formEqualTo(String value) {
    return 'باید له ${value} سره برابر وي';
  }

  @override
  String formBetweenExclusively(double min, double max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'باید د $minString او $maxString ترمنځ وي (دواړه نه شامل)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'باید لږ تر لږه ${value} تورو ولري';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'باید تر ټولو ډېر ${value} تورو ولري';
  }

  @override
  String get formPasswordDigits => 'باید لږ تر لږه یو عدد ولري';

  @override
  String get formPasswordLowercase => 'باید لږ تر لږه یو کوچنی توری ولري';

  @override
  String get formPasswordUppercase => 'باید لږ تر لږه یو لوی توری ولري';

  @override
  String get formPasswordSpecial => 'باید لږ تر لږه یو ځانګړی توری ولري';

  @override
  String get commandSearch => 'کمانډ ولیکئ یا لټون وکړئ...';

  @override
  String get commandEmpty => 'پایله ونه موندل شوه.';

  @override
  String get datePickerSelectYear => 'کال وټاکئ';

  @override
  String get abbreviatedMonday => 'دو';

  @override
  String get abbreviatedTuesday => 'سې';

  @override
  String get abbreviatedWednesday => 'څل';

  @override
  String get abbreviatedThursday => 'پن';

  @override
  String get abbreviatedFriday => 'جم';

  @override
  String get abbreviatedSaturday => 'شن';

  @override
  String get abbreviatedSunday => 'یک';

  @override
  String get monthJanuary => 'جنوري';

  @override
  String get monthFebruary => 'فبروري';

  @override
  String get monthMarch => 'مارچ';

  @override
  String get monthApril => 'اپریل';

  @override
  String get monthMay => 'می';

  @override
  String get monthJune => 'جون';

  @override
  String get monthJuly => 'جولای';

  @override
  String get monthAugust => 'اګست';

  @override
  String get monthSeptember => 'سپتمبر';

  @override
  String get monthOctober => 'اکتوبر';

  @override
  String get monthNovember => 'نومبر';

  @override
  String get monthDecember => 'دسمبر';

  @override
  String get abbreviatedJanuary => 'جنو';

  @override
  String get abbreviatedFebruary => 'فبر';

  @override
  String get abbreviatedMarch => 'مار';

  @override
  String get abbreviatedApril => 'اپر';

  @override
  String get abbreviatedMay => 'می';

  @override
  String get abbreviatedJune => 'جون';

  @override
  String get abbreviatedJuly => 'جول';

  @override
  String get abbreviatedAugust => 'اګس';

  @override
  String get abbreviatedSeptember => 'سپت';

  @override
  String get abbreviatedOctober => 'اکت';

  @override
  String get abbreviatedNovember => 'نوم';

  @override
  String get abbreviatedDecember => 'دسم';

  @override
  String get buttonCancel => 'لغوه کول';

  @override
  String get buttonSave => 'خوندي کول';

  @override
  String get timeHour => 'ساعت';

  @override
  String get timeMinute => 'دقیقه';

  @override
  String get timeSecond => 'ثانیه';

  @override
  String get timeAM => 'غ.م';

  @override
  String get timePM => 'غ.و';

  @override
  String get colorRed => 'سور';

  @override
  String get colorGreen => 'شین';

  @override
  String get colorBlue => 'آسماني';

  @override
  String get colorAlpha => 'الفا';

  @override
  String get colorHue => 'رنګ';

  @override
  String get colorSaturation => 'بډایه‌والی';

  @override
  String get colorValue => 'ارزښت';

  @override
  String get colorLightness => 'روښانتیا';

  @override
  String get menuCut => 'پرې کول';

  @override
  String get menuCopy => 'کاپي';

  @override
  String get menuPaste => 'پېست کول';

  @override
  String get menuSelectAll => 'ټول وټاکئ';

  String get noSpellCheckReplacements => 'وړاندیز ونه موندل شو';

  @override
  String get menuUndo => 'بېرته';

  @override
  String get menuRedo => 'بیا';

  @override
  String get menuDelete => 'ړنګول';

  @override
  String get menuShare => 'شریکول';

  @override
  String get menuSearchWeb => 'په وېب کې لټون';

  @override
  String get menuLiveTextInput => 'ژوندی متن';

  @override
  String get placeholderDatePicker => 'نېټه وټاکئ';

  @override
  String get placeholderTimePicker => 'وخت وټاکئ';

  @override
  String get placeholderColorPicker => 'رنګ وټاکئ';

  @override
  String get buttonPrevious => 'پخوانی';

  @override
  String get buttonNext => 'راتلونکی';

  @override
  String get refreshTriggerPull => 'د تازه کولو لپاره کش کړئ';

  @override
  String get refreshTriggerRelease => 'د تازه کولو لپاره پرېږدئ';

  @override
  String get refreshTriggerRefreshing => 'تازه کیږي...';

  @override
  String get refreshTriggerComplete => 'تازه کول بشپړ شول';

  @override
  String get colorPickerTabRecent => 'وروستي';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'پورته وړل';

  @override
  String get commandMoveDown => 'ښکته وړل';

  @override
  String get commandActivate => 'ټاکل';

  @override
  String dataTableSelectedRows(int count, int total) {
    return 'له ${total} څخه ${count} کتارونه وټاکل شول.';
  }

  @override
  String get dataTableNext => 'راتلونکی';

  @override
  String get dataTablePrevious => 'پخوانی';

  @override
  String get dataTableColumns => 'کالمونه';

  @override
  String get timeDaysAbbreviation => 'ور';

  @override
  String get timeHoursAbbreviation => 'سا';

  @override
  String get timeMinutesAbbreviation => 'دق';

  @override
  String get timeSecondsAbbreviation => 'ثا';

  @override
  String get placeholderDurationPicker => 'موده وټاکئ';

  @override
  String get durationDay => 'ورځ';

  @override
  String get durationHour => 'ساعت';

  @override
  String get durationMinute => 'دقیقه';

  @override
  String get durationSecond => 'ثانیه';
}
