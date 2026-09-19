// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Persian (`fa`).
class ShadcnLocalizationsFa extends ShadcnLocalizations {
  /// Creates the Persian localizations.
  ShadcnLocalizationsFa([super.locale = 'fa']);

  @override
  TextDirection get textDirection => TextDirection.rtl;

  @override
  String get formNotEmpty => 'این فیلد نمی‌تواند خالی باشد';

  @override
  String get invalidValue => 'مقدار نامعتبر';

  @override
  String get invalidEmail => 'ایمیل نامعتبر';

  @override
  String get invalidURL => 'نشانی اینترنتی نامعتبر';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید کمتر از $valueString باشد';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید بیشتر از $valueString باشد';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید کمتر یا مساوی $valueString باشد';
  }

  String get formPhoneNumberInvalid => 'شماره تلفن نامعتبر است';

  String get formPhoneNumberEmpty => 'شماره تلفن الزامی است';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'باید بیشتر یا مساوی $valueString باشد';
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

    return 'باید بین $minString و $maxString باشد (شامل دو سر)';
  }

  String formEqualTo(String value) {
    return 'باید برابر ${value} باشد';
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

    return 'باید بین $minString و $maxString باشد (بدون دو سر)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'باید حداقل ${value} نویسه باشد';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'باید حداکثر ${value} نویسه باشد';
  }

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

  String get noSpellCheckReplacements => 'پیشنهادی یافت نشد';

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
  String get colorPickerTabRecent => 'اخیر';

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
  String dataTableSelectedRows(int count, int total) {
    return '${count} از ${total} ردیف انتخاب شد.';
  }

  @override
  String get dataTableNext => 'بعدی';

  @override
  String get dataTablePrevious => 'قبلی';

  @override
  String get dataTableColumns => 'ستون‌ها';

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
