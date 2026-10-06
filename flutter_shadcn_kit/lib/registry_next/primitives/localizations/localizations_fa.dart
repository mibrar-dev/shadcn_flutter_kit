import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Persian (`fa`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsFa extends ShadcnLocalizations {
  /// Creates the Persian strings.
  const ShadcnLocalizationsFa([super.locale = const Locale('fa')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'این فیلد نمی‌تواند خالی باشد';

  @override
  String get invalidValue => 'مقدار نامعتبر';

  @override
  String get invalidEmail => 'ایمیل نامعتبر';

  @override
  String get invalidURL => 'نشانی اینترنتی نامعتبر';

  @override
  String formLessThan(Object? value) => 'باید کمتر از ${_number(value)} باشد';

  @override
  String formGreaterThan(Object? value) =>
      'باید بیشتر از ${_number(value)} باشد';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'باید کمتر یا مساوی ${_number(value)} باشد';

  @override
  String get formPhoneNumberInvalid => 'شماره تلفن نامعتبر است';

  @override
  String get formPhoneNumberEmpty => 'شماره تلفن الزامی است';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'باید بیشتر یا مساوی ${_number(value)} باشد';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'باید بین ${_number(min)} و ${_number(max)} باشد (شامل دو سر)';

  @override
  String formEqualTo(Object? value) => 'باید برابر ${_number(value)} باشد';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'باید بین ${_number(min)} و ${_number(max)} باشد (بدون دو سر)';

  @override
  String formLengthLessThan(int limit) => 'باید حداقل $limit نویسه باشد';

  @override
  String formLengthGreaterThan(int limit) => 'باید حداکثر $limit نویسه باشد';

  @override
  String get formPasswordDigits => 'باید حداقل یک رقم داشته باشد';

  @override
  String get formPasswordLowercase => 'باید حداقل یک حرف کوچک داشته باشد';

  @override
  String get formPasswordUppercase => 'باید حداقل یک حرف بزرگ داشته باشد';

  @override
  String get formPasswordSpecial => 'باید حداقل یک نویسه ویژه داشته باشد';

  @override
  String get commandSearch => 'فرمانی بنویسید یا جستجو کنید...';

  @override
  String get commandEmpty => 'نتیجه‌ای یافت نشد.';

  @override
  String get datePickerSelectYear => 'یک سال انتخاب کنید';

  @override
  String get abbreviatedMonday => 'دو';

  @override
  String get abbreviatedTuesday => 'سه';

  @override
  String get abbreviatedWednesday => 'چه';

  @override
  String get abbreviatedThursday => 'پن';

  @override
  String get abbreviatedFriday => 'جم';

  @override
  String get abbreviatedSaturday => 'شن';

  @override
  String get abbreviatedSunday => 'یک';

  @override
  String get monthJanuary => 'ژانویه';

  @override
  String get monthFebruary => 'فوریه';

  @override
  String get monthMarch => 'مارس';

  @override
  String get monthApril => 'آوریل';

  @override
  String get monthMay => 'مه';

  @override
  String get monthJune => 'ژوئن';

  @override
  String get monthJuly => 'ژوئیه';

  @override
  String get monthAugust => 'اوت';

  @override
  String get monthSeptember => 'سپتامبر';

  @override
  String get monthOctober => 'اکتبر';

  @override
  String get monthNovember => 'نوامبر';

  @override
  String get monthDecember => 'دسامبر';

  @override
  String get abbreviatedJanuary => 'ژانویه';

  @override
  String get abbreviatedFebruary => 'فوریه';

  @override
  String get abbreviatedMarch => 'مارس';

  @override
  String get abbreviatedApril => 'آوریل';

  @override
  String get abbreviatedMay => 'مه';

  @override
  String get abbreviatedJune => 'ژوئن';

  @override
  String get abbreviatedJuly => 'ژوئیه';

  @override
  String get abbreviatedAugust => 'اوت';

  @override
  String get abbreviatedSeptember => 'سپتامبر';

  @override
  String get abbreviatedOctober => 'اکتبر';

  @override
  String get abbreviatedNovember => 'نوامبر';

  @override
  String get abbreviatedDecember => 'دسامبر';

  @override
  String get buttonCancel => 'لغو';

  @override
  String get buttonSave => 'ذخیره';

  @override
  String get timeHour => 'ساعت';

  @override
  String get timeMinute => 'دقیقه';

  @override
  String get timeSecond => 'ثانیه';

  @override
  String get timeAM => 'ق.ظ';

  @override
  String get timePM => 'ب.ظ';

  @override
  String get colorRed => 'قرمز';

  @override
  String get colorGreen => 'سبز';

  @override
  String get colorBlue => 'آبی';

  @override
  String get colorAlpha => 'آلفا';

  @override
  String get colorHue => 'فام';

  @override
  String get colorSaturation => 'اشباع';

  @override
  String get colorValue => 'روشنی';

  @override
  String get colorLightness => 'درخشندگی';

  @override
  String get menuCut => 'برش';

  @override
  String get menuCopy => 'کپی';

  @override
  String get menuPaste => 'چسباندن';

  @override
  String get menuSelectAll => 'انتخاب همه';

  @override
  String get menuUndo => 'واگرد';

  @override
  String get menuRedo => 'ازنو';

  @override
  String get menuDelete => 'حذف';

  @override
  String get menuShare => 'هم‌رسانی';

  @override
  String get menuSearchWeb => 'جستجو در وب';

  @override
  String get menuLiveTextInput => 'متن زنده';

  @override
  String get placeholderDatePicker => 'یک تاریخ انتخاب کنید';

  @override
  String get placeholderTimePicker => 'یک زمان انتخاب کنید';

  @override
  String get placeholderColorPicker => 'یک رنگ انتخاب کنید';

  @override
  String get buttonPrevious => 'قبلی';

  @override
  String get buttonNext => 'بعدی';

  @override
  String get refreshTriggerPull => 'برای تازه‌سازی بکشید';

  @override
  String get refreshTriggerRelease => 'برای تازه‌سازی رها کنید';

  @override
  String get refreshTriggerRefreshing => 'در حال تازه‌سازی...';

  @override
  String get refreshTriggerComplete => 'تازه‌سازی کامل شد';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'انتقال به بالا';

  @override
  String get commandMoveDown => 'انتقال به پایین';

  @override
  String get commandActivate => 'انتخاب';

  @override
  String get timeDaysAbbreviation => 'رر';

  @override
  String get timeHoursAbbreviation => 'سس';

  @override
  String get timeMinutesAbbreviation => 'دد';

  @override
  String get timeSecondsAbbreviation => 'ثث';

  @override
  String get placeholderDurationPicker => 'یک مدت انتخاب کنید';

  @override
  String get durationDay => 'روز';

  @override
  String get durationHour => 'ساعت';

  @override
  String get durationMinute => 'دقیقه';

  @override
  String get durationSecond => 'ثانیه';
}
