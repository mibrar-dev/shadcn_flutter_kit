import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Arabic (`ar`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsAr extends ShadcnLocalizations {
  /// Creates the Arabic strings.
  const ShadcnLocalizationsAr([super.locale = const Locale('ar')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'لا يمكن ترك هذا الحقل فارغًا';

  @override
  String get invalidValue => 'قيمة غير صالحة';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidURL => 'رابط غير صالح';

  @override
  String formLessThan(Object? value) => 'يجب أن يكون أقل من ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'يجب أن يكون أكبر من ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'يجب أن يكون أقل من أو يساوي ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'رقم الهاتف غير صالح';

  @override
  String get formPhoneNumberEmpty => 'رقم الهاتف مطلوب';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'يجب أن يكون أكبر من أو يساوي ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'يجب أن يكون بين ${_number(min)} و ${_number(max)} (شاملًا الطرفين)';

  @override
  String formEqualTo(Object? value) => 'يجب أن يساوي ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'يجب أن يكون بين ${_number(min)} و ${_number(max)} (غير شامل الطرفين)';

  @override
  String formLengthLessThan(int limit) => 'يجب ألا يقل عن $limit حرفًا';

  @override
  String formLengthGreaterThan(int limit) => 'يجب ألا يزيد عن $limit حرفًا';

  @override
  String get formPasswordDigits => 'يجب أن يحتوي على رقم واحد على الأقل';

  @override
  String get formPasswordLowercase =>
      'يجب أن يحتوي على حرف صغير واحد على الأقل';

  @override
  String get formPasswordUppercase =>
      'يجب أن يحتوي على حرف كبير واحد على الأقل';

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
