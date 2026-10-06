import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Ukrainian (`uk`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsUk extends ShadcnLocalizations {
  /// Creates the Ukrainian strings.
  const ShadcnLocalizationsUk([super.locale = const Locale('uk')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Це поле не може бути порожнім';

  @override
  String get invalidValue => 'Недопустиме значення';

  @override
  String get invalidEmail => 'Недопустима адреса електронної пошти';

  @override
  String get invalidURL => 'Недопустима URL-адреса';

  @override
  String formLessThan(Object? value) => 'Має бути менше ніж ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Має бути більше ніж ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Має бути менше або дорівнювати ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Недопустимий номер телефону';

  @override
  String get formPhoneNumberEmpty => 'Укажіть номер телефону';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Має бути більше або дорівнювати ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Має бути від ${_number(min)} до ${_number(max)} (включно)';

  @override
  String formEqualTo(Object? value) => 'Має дорівнювати ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Має бути між ${_number(min)} і ${_number(max)} (не включно)';

  @override
  String formLengthLessThan(int limit) =>
      'Має містити щонайменше $limit символів';

  @override
  String formLengthGreaterThan(int limit) =>
      'Має містити щонайбільше $limit символів';

  @override
  String get formPasswordDigits => 'Має містити принаймні одну цифру';

  @override
  String get formPasswordLowercase => 'Має містити принаймні одну малу літеру';

  @override
  String get formPasswordUppercase =>
      'Має містити принаймні одну велику літеру';

  @override
  String get formPasswordSpecial =>
      'Має містити принаймні один спеціальний символ';

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
  String get dialogDismiss => 'Закрити';

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
