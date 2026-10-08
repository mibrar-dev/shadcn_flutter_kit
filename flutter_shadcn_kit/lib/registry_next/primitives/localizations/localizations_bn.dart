import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Bengali (`bn`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsBn extends ShadcnLocalizations {
  /// Creates the Bengali strings.
  const ShadcnLocalizationsBn([super.locale = const Locale('bn')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'এই ঘরটি খালি রাখা যাবে না';

  @override
  String get invalidValue => 'অবৈধ মান';

  @override
  String get invalidEmail => 'অবৈধ ইমেল';

  @override
  String get invalidURL => 'অবৈধ URL';

  @override
  String formLessThan(Object? value) => '${_number(value)}-এর চেয়ে কম হতে হবে';

  @override
  String formGreaterThan(Object? value) =>
      '${_number(value)}-এর চেয়ে বেশি হতে হবে';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      '${_number(value)}-এর চেয়ে কম বা সমান হতে হবে';

  @override
  String get formPhoneNumberInvalid => 'ফোন নম্বরটি অবৈধ';

  @override
  String get formPhoneNumberEmpty => 'ফোন নম্বর প্রয়োজন';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      '${_number(value)}-এর চেয়ে বেশি বা সমান হতে হবে';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '${_number(min)} এবং ${_number(max)}-এর মধ্যে হতে হবে (সহ)';

  @override
  String formEqualTo(Object? value) => '${_number(value)}-এর সমান হতে হবে';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '${_number(min)} এবং ${_number(max)}-এর মধ্যে হতে হবে (ব্যতীত)';

  @override
  String formLengthLessThan(int limit) => 'কমপক্ষে $limitটি অক্ষর হতে হবে';

  @override
  String formLengthGreaterThan(int limit) => 'সর্বোচ্চ $limitটি অক্ষর হতে পারে';

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
  String get dialogDismiss => 'খারিজ করুন';

  @override
  String get chipInputRemoveChip => 'মুছে দিন';

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
