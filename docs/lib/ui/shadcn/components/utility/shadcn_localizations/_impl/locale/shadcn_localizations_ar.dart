// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Arabic (`ar`).
class ShadcnLocalizationsAr extends ShadcnLocalizations {
  /// Creates the Arabic localizations.
  ShadcnLocalizationsAr([super.locale = 'ar']);

  @override
  TextDirection get textDirection => TextDirection.rtl;

  @override
  String get formNotEmpty => 'لا يمكن ترك هذا الحقل فارغًا';

  @override
  String get invalidValue => 'قيمة غير صالحة';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidURL => 'رابط غير صالح';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'يجب أن يكون أقل من $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'يجب أن يكون أكبر من $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'يجب أن يكون أقل من أو يساوي $valueString';
  }

  String get formPhoneNumberInvalid => 'رقم الهاتف غير صالح';

  String get formPhoneNumberEmpty => 'رقم الهاتف مطلوب';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'يجب أن يكون أكبر من أو يساوي $valueString';
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

    return 'يجب أن يكون بين $minString و $maxString (شاملًا الطرفين)';
  }

  String formEqualTo(String value) {
    return 'يجب أن يساوي ${value}';
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

    return 'يجب أن يكون بين $minString و $maxString (غير شامل الطرفين)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'يجب ألا يقل عن ${value} حرفًا';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'يجب ألا يزيد عن ${value} حرفًا';
  }

  @override
  String get formPasswordDigits => 'يجب أن يحتوي على رقم واحد على الأقل';

  @override
  String get formPasswordLowercase => 'يجب أن يحتوي على حرف صغير واحد على الأقل';

  @override
  String get formPasswordUppercase => 'يجب أن يحتوي على حرف كبير واحد على الأقل';

  @override
  String get formPasswordSpecial => 'يجب أن يحتوي على رمز خاص واحد على الأقل';

  @override
  String get commandSearch => 'اكتب أمرًا أو ابحث...';

  @override
  String get commandEmpty => 'لا توجد نتائج.';

  @override
  String get datePickerSelectYear => 'اختر سنة';

  @override
  String get abbreviatedMonday => 'إث';

  @override
  String get abbreviatedTuesday => 'ثل';

  @override
  String get abbreviatedWednesday => 'أر';

  @override
  String get abbreviatedThursday => 'خم';

  @override
  String get abbreviatedFriday => 'جم';

  @override
  String get abbreviatedSaturday => 'سب';

  @override
  String get abbreviatedSunday => 'أح';

  @override
  String get monthJanuary => 'يناير';

  @override
  String get monthFebruary => 'فبراير';

  @override
  String get monthMarch => 'مارس';

  @override
  String get monthApril => 'أبريل';

  @override
  String get monthMay => 'مايو';

  @override
  String get monthJune => 'يونيو';

  @override
  String get monthJuly => 'يوليو';

  @override
  String get monthAugust => 'أغسطس';

  @override
  String get monthSeptember => 'سبتمبر';

  @override
  String get monthOctober => 'أكتوبر';

  @override
  String get monthNovember => 'نوفمبر';

  @override
  String get monthDecember => 'ديسمبر';

  @override
  String get abbreviatedJanuary => 'ينا';

  @override
  String get abbreviatedFebruary => 'فبر';

  @override
  String get abbreviatedMarch => 'مار';

  @override
  String get abbreviatedApril => 'أبر';

  @override
  String get abbreviatedMay => 'ماي';

  @override
  String get abbreviatedJune => 'يون';

  @override
  String get abbreviatedJuly => 'يول';

  @override
  String get abbreviatedAugust => 'أغس';

  @override
  String get abbreviatedSeptember => 'سبت';

  @override
  String get abbreviatedOctober => 'أكت';

  @override
  String get abbreviatedNovember => 'نوف';

  @override
  String get abbreviatedDecember => 'ديس';

  @override
  String get buttonCancel => 'إلغاء';

  @override
  String get buttonSave => 'حفظ';

  @override
  String get timeHour => 'ساعة';

  @override
  String get timeMinute => 'دقيقة';

  @override
  String get timeSecond => 'ثانية';

  @override
  String get timeAM => 'ص';

  @override
  String get timePM => 'م';

  @override
  String get colorRed => 'أحمر';

  @override
  String get colorGreen => 'أخضر';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorAlpha => 'الشفافية';

  @override
  String get colorHue => 'التدرج';

  @override
  String get colorSaturation => 'التشبع';

  @override
  String get colorValue => 'القيمة';

  @override
  String get colorLightness => 'الإضاءة';

  @override
  String get menuCut => 'قص';

  @override
  String get menuCopy => 'نسخ';

  @override
  String get menuPaste => 'لصق';

  @override
  String get menuSelectAll => 'تحديد الكل';

  String get noSpellCheckReplacements => 'لا توجد اقتراحات';

  @override
  String get menuUndo => 'تراجع';

  @override
  String get menuRedo => 'إعادة';

  @override
  String get menuDelete => 'حذف';

  @override
  String get menuShare => 'مشاركة';

  @override
  String get menuSearchWeb => 'البحث في الويب';

  @override
  String get menuLiveTextInput => 'النص المباشر';

  @override
  String get placeholderDatePicker => 'اختر تاريخًا';

  @override
  String get placeholderTimePicker => 'اختر وقتًا';

  @override
  String get placeholderColorPicker => 'اختر لونًا';

  @override
  String get buttonPrevious => 'السابق';

  @override
  String get buttonNext => 'التالي';

  @override
  String get refreshTriggerPull => 'اسحب للتحديث';

  @override
  String get refreshTriggerRelease => 'أفلت للتحديث';

  @override
  String get refreshTriggerRefreshing => 'جارٍ التحديث...';

  @override
  String get refreshTriggerComplete => 'اكتمل التحديث';

  @override
  String get colorPickerTabRecent => 'الأخيرة';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'تحريك لأعلى';

  @override
  String get commandMoveDown => 'تحريك لأسفل';

  @override
  String get commandActivate => 'تحديد';

  @override
  String dataTableSelectedRows(int count, int total) {
    return 'تم تحديد ${count} من ${total} صف.';
  }

  @override
  String get dataTableNext => 'التالي';

  @override
  String get dataTablePrevious => 'السابق';

  @override
  String get dataTableColumns => 'الأعمدة';

  @override
  String get timeDaysAbbreviation => 'يي';

  @override
  String get timeHoursAbbreviation => 'سس';

  @override
  String get timeMinutesAbbreviation => 'دد';

  @override
  String get timeSecondsAbbreviation => 'ثث';

  @override
  String get placeholderDurationPicker => 'اختر مدة';

  @override
  String get durationDay => 'يوم';

  @override
  String get durationHour => 'ساعة';

  @override
  String get durationMinute => 'دقيقة';

  @override
  String get durationSecond => 'ثانية';
}
