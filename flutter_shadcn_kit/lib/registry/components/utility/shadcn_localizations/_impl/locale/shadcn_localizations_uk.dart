// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Ukrainian (`uk`).
class ShadcnLocalizationsUk extends ShadcnLocalizations {
  /// Creates the Ukrainian localizations.
  ShadcnLocalizationsUk([super.locale = 'uk']);

  @override
  String get formNotEmpty => 'Це поле не може бути порожнім';

  @override
  String get invalidValue => 'Недопустиме значення';

  @override
  String get invalidEmail => 'Недопустима адреса електронної пошти';

  @override
  String get invalidURL => 'Недопустима URL-адреса';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Має бути менше ніж $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Має бути більше ніж $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Має бути менше або дорівнювати $valueString';
  }

  String get formPhoneNumberInvalid => 'Недопустимий номер телефону';

  String get formPhoneNumberEmpty => 'Укажіть номер телефону';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Має бути більше або дорівнювати $valueString';
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

    return 'Має бути від $minString до $maxString (включно)';
  }

  String formEqualTo(String value) {
    return 'Має дорівнювати ${value}';
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

    return 'Має бути між $minString і $maxString (не включно)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Має містити щонайменше ${value} символів';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Має містити щонайбільше ${value} символів';
  }

  @override
  String get formPasswordDigits => 'Має містити принаймні одну цифру';

  @override
  String get formPasswordLowercase => 'Має містити принаймні одну малу літеру';

  @override
  String get formPasswordUppercase => 'Має містити принаймні одну велику літеру';

  @override
  String get formPasswordSpecial => 'Має містити принаймні один спеціальний символ';

  @override
  String get commandSearch => 'Введіть команду або запит...';

  @override
  String get commandEmpty => 'Нічого не знайдено.';

  @override
  String get datePickerSelectYear => 'Виберіть рік';

  @override
  String get abbreviatedMonday => 'Пн';

  @override
  String get abbreviatedTuesday => 'Вт';

  @override
  String get abbreviatedWednesday => 'Ср';

  @override
  String get abbreviatedThursday => 'Чт';

  @override
  String get abbreviatedFriday => 'Пт';

  @override
  String get abbreviatedSaturday => 'Сб';

  @override
  String get abbreviatedSunday => 'Нд';

  @override
  String get monthJanuary => 'Січень';

  @override
  String get monthFebruary => 'Лютий';

  @override
  String get monthMarch => 'Березень';

  @override
  String get monthApril => 'Квітень';

  @override
  String get monthMay => 'Травень';

  @override
  String get monthJune => 'Червень';

  @override
  String get monthJuly => 'Липень';

  @override
  String get monthAugust => 'Серпень';

  @override
  String get monthSeptember => 'Вересень';

  @override
  String get monthOctober => 'Жовтень';

  @override
  String get monthNovember => 'Листопад';

  @override
  String get monthDecember => 'Грудень';

  @override
  String get abbreviatedJanuary => 'січ.';

  @override
  String get abbreviatedFebruary => 'лют.';

  @override
  String get abbreviatedMarch => 'бер.';

  @override
  String get abbreviatedApril => 'квіт.';

  @override
  String get abbreviatedMay => 'трав.';

  @override
  String get abbreviatedJune => 'черв.';

  @override
  String get abbreviatedJuly => 'лип.';

  @override
  String get abbreviatedAugust => 'серп.';

  @override
  String get abbreviatedSeptember => 'вер.';

  @override
  String get abbreviatedOctober => 'жовт.';

  @override
  String get abbreviatedNovember => 'лист.';

  @override
  String get abbreviatedDecember => 'груд.';

  @override
  String get buttonCancel => 'Скасувати';

  @override
  String get buttonSave => 'Зберегти';

  @override
  String get timeHour => 'Година';

  @override
  String get timeMinute => 'Хвилина';

  @override
  String get timeSecond => 'Секунда';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Червоний';

  @override
  String get colorGreen => 'Зелений';

  @override
  String get colorBlue => 'Синій';

  @override
  String get colorAlpha => 'Альфа';

  @override
  String get colorHue => 'Відтінок';

  @override
  String get colorSaturation => 'Нас';

  @override
  String get colorValue => 'Яскр';

  @override
  String get colorLightness => 'Світл';

  @override
  String get menuCut => 'Вирізати';

  @override
  String get menuCopy => 'Копіювати';

  @override
  String get menuPaste => 'Вставити';

  @override
  String get menuSelectAll => 'Вибрати все';

  String get noSpellCheckReplacements => 'Варіантів не знайдено';

  @override
  String get menuUndo => 'Скасувати';

  @override
  String get menuRedo => 'Повторити';

  @override
  String get menuDelete => 'Видалити';

  @override
  String get menuShare => 'Поділитися';

  @override
  String get menuSearchWeb => 'Шукати в інтернеті';

  @override
  String get menuLiveTextInput => 'Живий текст';

  @override
  String get placeholderDatePicker => 'Виберіть дату';

  @override
  String get placeholderTimePicker => 'Виберіть час';

  @override
  String get placeholderColorPicker => 'Виберіть колір';

  @override
  String get buttonPrevious => 'Назад';

  @override
  String get buttonNext => 'Далі';

  @override
  String get refreshTriggerPull => 'Потягніть, щоб оновити';

  @override
  String get refreshTriggerRelease => 'Відпустіть, щоб оновити';

  @override
  String get refreshTriggerRefreshing => 'Оновлення...';

  @override
  String get refreshTriggerComplete => 'Оновлення завершено';

  @override
  String get colorPickerTabRecent => 'Нещодавні';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Вгору';

  @override
  String get commandMoveDown => 'Вниз';

  @override
  String get commandActivate => 'Вибрати';

  @override
  String dataTableSelectedRows(int count, int total) {
    return 'Вибрано рядків: ${count} з ${total}.';
  }

  @override
  String get dataTableNext => 'Далі';

  @override
  String get dataTablePrevious => 'Назад';

  @override
  String get dataTableColumns => 'Стовпці';

  @override
  String get timeDaysAbbreviation => 'ДД';

  @override
  String get timeHoursAbbreviation => 'ГГ';

  @override
  String get timeMinutesAbbreviation => 'ХХ';

  @override
  String get timeSecondsAbbreviation => 'СС';

  @override
  String get placeholderDurationPicker => 'Виберіть тривалість';

  @override
  String get durationDay => 'День';

  @override
  String get durationHour => 'Година';

  @override
  String get durationMinute => 'Хвилина';

  @override
  String get durationSecond => 'Секунда';
}
