// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Bengali (`bn`).
class ShadcnLocalizationsBn extends ShadcnLocalizations {
  /// Creates the Bengali localizations.
  ShadcnLocalizationsBn([super.locale = 'bn']);

  @override
  String get formNotEmpty => 'এই ঘরটি খালি রাখা যাবে না';

  @override
  String get invalidValue => 'অবৈধ মান';

  @override
  String get invalidEmail => 'অবৈধ ইমেল';

  @override
  String get invalidURL => 'অবৈধ URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-এর চেয়ে কম হতে হবে';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-এর চেয়ে বেশি হতে হবে';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-এর চেয়ে কম বা সমান হতে হবে';
  }

  String get formPhoneNumberInvalid => 'ফোন নম্বরটি অবৈধ';

  String get formPhoneNumberEmpty => 'ফোন নম্বর প্রয়োজন';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-এর চেয়ে বেশি বা সমান হতে হবে';
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

    return '$minString এবং $maxString-এর মধ্যে হতে হবে (সহ)';
  }

  String formEqualTo(String value) {
    return '${value}-এর সমান হতে হবে';
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

    return '$minString এবং $maxString-এর মধ্যে হতে হবে (ব্যতীত)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'কমপক্ষে ${value}টি অক্ষর হতে হবে';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'সর্বোচ্চ ${value}টি অক্ষর হতে পারে';
  }

  @override
  String get formPasswordDigits => 'কমপক্ষে একটি সংখ্যা থাকতে হবে';

  @override
  String get formPasswordLowercase => 'কমপক্ষে একটি ছোট হাতের অক্ষর থাকতে হবে';

  @override
  String get formPasswordUppercase => 'কমপক্ষে একটি বড় হাতের অক্ষর থাকতে হবে';

  @override
  String get formPasswordSpecial => 'কমপক্ষে একটি বিশেষ অক্ষর থাকতে হবে';

  @override
  String get commandSearch => 'একটি কমান্ড লিখুন বা খুঁজুন...';

  @override
  String get commandEmpty => 'কোনও ফলাফল পাওয়া যায়নি।';

  @override
  String get datePickerSelectYear => 'একটি বছর নির্বাচন করুন';

  @override
  String get abbreviatedMonday => 'সোম';

  @override
  String get abbreviatedTuesday => 'মঙ্গল';

  @override
  String get abbreviatedWednesday => 'বুধ';

  @override
  String get abbreviatedThursday => 'বৃহ';

  @override
  String get abbreviatedFriday => 'শুক্র';

  @override
  String get abbreviatedSaturday => 'শনি';

  @override
  String get abbreviatedSunday => 'রবি';

  @override
  String get monthJanuary => 'জানুয়ারি';

  @override
  String get monthFebruary => 'ফেব্রুয়ারি';

  @override
  String get monthMarch => 'মার্চ';

  @override
  String get monthApril => 'এপ্রিল';

  @override
  String get monthMay => 'মে';

  @override
  String get monthJune => 'জুন';

  @override
  String get monthJuly => 'জুলাই';

  @override
  String get monthAugust => 'আগস্ট';

  @override
  String get monthSeptember => 'সেপ্টেম্বর';

  @override
  String get monthOctober => 'অক্টোবর';

  @override
  String get monthNovember => 'নভেম্বর';

  @override
  String get monthDecember => 'ডিসেম্বর';

  @override
  String get abbreviatedJanuary => 'জানু';

  @override
  String get abbreviatedFebruary => 'ফেব';

  @override
  String get abbreviatedMarch => 'মার্চ';

  @override
  String get abbreviatedApril => 'এপ্রি';

  @override
  String get abbreviatedMay => 'মে';

  @override
  String get abbreviatedJune => 'জুন';

  @override
  String get abbreviatedJuly => 'জুল';

  @override
  String get abbreviatedAugust => 'আগ';

  @override
  String get abbreviatedSeptember => 'সেপ্ট';

  @override
  String get abbreviatedOctober => 'অক্টো';

  @override
  String get abbreviatedNovember => 'নভে';

  @override
  String get abbreviatedDecember => 'ডিসে';

  @override
  String get buttonCancel => 'বাতিল';

  @override
  String get buttonSave => 'সংরক্ষণ';

  @override
  String get timeHour => 'ঘণ্টা';

  @override
  String get timeMinute => 'মিনিট';

  @override
  String get timeSecond => 'সেকেন্ড';

  @override
  String get timeAM => 'পূর্বাহ্ন';

  @override
  String get timePM => 'অপরাহ্ন';

  @override
  String get colorRed => 'লাল';

  @override
  String get colorGreen => 'সবুজ';

  @override
  String get colorBlue => 'নীল';

  @override
  String get colorAlpha => 'আলফা';

  @override
  String get colorHue => 'রঙের আভা';

  @override
  String get colorSaturation => 'সম্পৃক্ততা';

  @override
  String get colorValue => 'মান';

  @override
  String get colorLightness => 'উজ্জ্বলতা';

  @override
  String get menuCut => 'কাটুন';

  @override
  String get menuCopy => 'কপি করুন';

  @override
  String get menuPaste => 'পেস্ট করুন';

  @override
  String get menuSelectAll => 'সব নির্বাচন করুন';

  String get noSpellCheckReplacements => 'কোনও পরামর্শ পাওয়া যায়নি';

  @override
  String get menuUndo => 'পূর্বাবস্থায় ফেরান';

  @override
  String get menuRedo => 'পুনরায় করুন';

  @override
  String get menuDelete => 'মুছুন';

  @override
  String get menuShare => 'শেয়ার করুন';

  @override
  String get menuSearchWeb => 'ওয়েবে খুঁজুন';

  @override
  String get menuLiveTextInput => 'লাইভ টেক্সট';

  @override
  String get placeholderDatePicker => 'একটি তারিখ নির্বাচন করুন';

  @override
  String get placeholderTimePicker => 'একটি সময় নির্বাচন করুন';

  @override
  String get placeholderColorPicker => 'একটি রঙ নির্বাচন করুন';

  @override
  String get buttonPrevious => 'পূর্ববর্তী';

  @override
  String get buttonNext => 'পরবর্তী';

  @override
  String get refreshTriggerPull => 'রিফ্রেশ করতে টানুন';

  @override
  String get refreshTriggerRelease => 'রিফ্রেশ করতে ছেড়ে দিন';

  @override
  String get refreshTriggerRefreshing => 'রিফ্রেশ হচ্ছে...';

  @override
  String get refreshTriggerComplete => 'রিফ্রেশ সম্পন্ন';

  @override
  String get colorPickerTabRecent => 'সাম্প্রতিক';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'উপরে সরান';

  @override
  String get commandMoveDown => 'নিচে সরান';

  @override
  String get commandActivate => 'নির্বাচন করুন';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${total}টির মধ্যে ${count}টি সারি নির্বাচিত।';
  }

  @override
  String get dataTableNext => 'পরবর্তী';

  @override
  String get dataTablePrevious => 'পূর্ববর্তী';

  @override
  String get dataTableColumns => 'কলাম';

  @override
  String get timeDaysAbbreviation => 'দদ';

  @override
  String get timeHoursAbbreviation => 'ঘঘ';

  @override
  String get timeMinutesAbbreviation => 'মম';

  @override
  String get timeSecondsAbbreviation => 'সস';

  @override
  String get placeholderDurationPicker => 'একটি সময়কাল নির্বাচন করুন';

  @override
  String get durationDay => 'দিন';

  @override
  String get durationHour => 'ঘণ্টা';

  @override
  String get durationMinute => 'মিনিট';

  @override
  String get durationSecond => 'সেকেন্ড';
}
