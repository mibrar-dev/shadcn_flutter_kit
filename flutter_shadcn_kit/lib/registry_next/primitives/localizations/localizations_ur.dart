import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Urdu (`ur`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsUr extends ShadcnLocalizations {
  /// Creates the Urdu strings.
  const ShadcnLocalizationsUr([super.locale = const Locale('ur')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'یہ خانہ خالی نہیں ہو سکتا';

  @override
  String get invalidValue => 'غلط قدر';

  @override
  String get invalidEmail => 'غلط ای میل';

  @override
  String get invalidURL => 'غلط URL';

  @override
  String formLessThan(Object? value) => '${_number(value)} سے کم ہونا چاہیے';

  @override
  String formGreaterThan(Object? value) =>
      '${_number(value)} سے زیادہ ہونا چاہیے';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      '${_number(value)} سے کم یا اس کے برابر ہونا چاہیے';

  @override
  String get formPhoneNumberInvalid => 'فون نمبر غلط ہے';

  @override
  String get formPhoneNumberEmpty => 'فون نمبر درکار ہے';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      '${_number(value)} سے زیادہ یا اس کے برابر ہونا چاہیے';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '${_number(min)} اور ${_number(max)} کے درمیان ہونا چاہیے (شامل)';

  @override
  String formEqualTo(Object? value) => '${_number(value)} کے برابر ہونا چاہیے';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '${_number(min)} اور ${_number(max)} کے درمیان ہونا چاہیے (غیر شامل)';

  @override
  String formLengthLessThan(int limit) => 'کم از کم $limit حروف ہونے چاہئیں';

  @override
  String formLengthGreaterThan(int limit) =>
      'زیادہ سے زیادہ $limit حروف ہونے چاہئیں';

  @override
  String get formPasswordDigits => 'کم از کم ایک ہندسہ ہونا چاہیے';

  @override
  String get formPasswordLowercase => 'کم از کم ایک چھوٹا حرف ہونا چاہیے';

  @override
  String get formPasswordUppercase => 'کم از کم ایک بڑا حرف ہونا چاہیے';

  @override
  String get formPasswordSpecial => 'کم از کم ایک خصوصی حرف ہونا چاہیے';

  @override
  String get commandSearch => 'کمانڈ لکھیں یا تلاش کریں...';

  @override
  String get commandEmpty => 'کوئی نتیجہ نہیں ملا۔';

  @override
  String get datePickerSelectYear => 'سال منتخب کریں';

  @override
  String get abbreviatedMonday => 'پیر';

  @override
  String get abbreviatedTuesday => 'منگل';

  @override
  String get abbreviatedWednesday => 'بدھ';

  @override
  String get abbreviatedThursday => 'جمعرات';

  @override
  String get abbreviatedFriday => 'جمعہ';

  @override
  String get abbreviatedSaturday => 'ہفتہ';

  @override
  String get abbreviatedSunday => 'اتوار';

  @override
  String get monthJanuary => 'جنوری';

  @override
  String get monthFebruary => 'فروری';

  @override
  String get monthMarch => 'مارچ';

  @override
  String get monthApril => 'اپریل';

  @override
  String get monthMay => 'مئی';

  @override
  String get monthJune => 'جون';

  @override
  String get monthJuly => 'جولائی';

  @override
  String get monthAugust => 'اگست';

  @override
  String get monthSeptember => 'ستمبر';

  @override
  String get monthOctober => 'اکتوبر';

  @override
  String get monthNovember => 'نومبر';

  @override
  String get monthDecember => 'دسمبر';

  @override
  String get abbreviatedJanuary => 'جنو';

  @override
  String get abbreviatedFebruary => 'فرو';

  @override
  String get abbreviatedMarch => 'مار';

  @override
  String get abbreviatedApril => 'اپر';

  @override
  String get abbreviatedMay => 'مئی';

  @override
  String get abbreviatedJune => 'جون';

  @override
  String get abbreviatedJuly => 'جول';

  @override
  String get abbreviatedAugust => 'اگس';

  @override
  String get abbreviatedSeptember => 'ستم';

  @override
  String get abbreviatedOctober => 'اکت';

  @override
  String get abbreviatedNovember => 'نوم';

  @override
  String get abbreviatedDecember => 'دسم';

  @override
  String get buttonCancel => 'منسوخ کریں';

  @override
  String get buttonSave => 'محفوظ کریں';

  @override
  String get timeHour => 'گھنٹہ';

  @override
  String get timeMinute => 'منٹ';

  @override
  String get timeSecond => 'سیکنڈ';

  @override
  String get timeAM => 'صبح';

  @override
  String get timePM => 'شام';

  @override
  String get colorRed => 'سرخ';

  @override
  String get colorGreen => 'سبز';

  @override
  String get colorBlue => 'نیلا';

  @override
  String get colorAlpha => 'الفا';

  @override
  String get colorHue => 'رنگت';

  @override
  String get colorSaturation => 'سیرابی';

  @override
  String get colorValue => 'قدر';

  @override
  String get colorLightness => 'روشنی';

  @override
  String get menuCut => 'کاٹیں';

  @override
  String get menuCopy => 'کاپی کریں';

  @override
  String get menuPaste => 'پیسٹ کریں';

  @override
  String get menuSelectAll => 'سب منتخب کریں';

  @override
  String get menuUndo => 'کالعدم کریں';

  @override
  String get menuRedo => 'دوبارہ کریں';

  @override
  String get menuDelete => 'حذف کریں';

  @override
  String get menuShare => 'شیئر کریں';

  @override
  String get menuSearchWeb => 'ویب پر تلاش کریں';

  @override
  String get menuLiveTextInput => 'لائیو ٹیکسٹ';

  @override
  String get placeholderDatePicker => 'تاریخ منتخب کریں';

  @override
  String get placeholderTimePicker => 'وقت منتخب کریں';

  @override
  String get placeholderColorPicker => 'رنگ منتخب کریں';

  @override
  String get buttonPrevious => 'پچھلا';

  @override
  String get buttonNext => 'اگلا';

  @override
  String get refreshTriggerPull => 'ریفریش کرنے کے لیے کھینچیں';

  @override
  String get refreshTriggerRelease => 'ریفریش کرنے کے لیے چھوڑیں';

  @override
  String get refreshTriggerRefreshing => 'ریفریش ہو رہا ہے...';

  @override
  String get refreshTriggerComplete => 'ریفریش مکمل ہوا';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'اوپر لے جائیں';

  @override
  String get commandMoveDown => 'نیچے لے جائیں';

  @override
  String get commandActivate => 'منتخب کریں';

  @override
  String get timeDaysAbbreviation => 'دد';

  @override
  String get timeHoursAbbreviation => 'گگ';

  @override
  String get timeMinutesAbbreviation => 'من';

  @override
  String get timeSecondsAbbreviation => 'سس';

  @override
  String get placeholderDurationPicker => 'دورانیہ منتخب کریں';

  @override
  String get durationDay => 'دن';

  @override
  String get durationHour => 'گھنٹہ';

  @override
  String get durationMinute => 'منٹ';

  @override
  String get durationSecond => 'سیکنڈ';
}
