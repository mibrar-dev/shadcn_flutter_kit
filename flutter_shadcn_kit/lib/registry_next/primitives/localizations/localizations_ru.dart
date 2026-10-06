import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Russian (`ru`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsRu extends ShadcnLocalizations {
  /// Creates the Russian strings.
  const ShadcnLocalizationsRu([super.locale = const Locale('ru')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Это поле не может быть пустым';

  @override
  String get invalidValue => 'Недопустимое значение';

  @override
  String get invalidEmail => 'Недопустимый адрес эл. почты';

  @override
  String get invalidURL => 'Недопустимый URL';

  @override
  String formLessThan(Object? value) => 'Должно быть меньше ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Должно быть больше ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Должно быть меньше или равно ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Недопустимый номер телефона';

  @override
  String get formPhoneNumberEmpty => 'Укажите номер телефона';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Должно быть больше или равно ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Должно быть от ${_number(min)} до ${_number(max)} (включительно)';

  @override
  String formEqualTo(Object? value) => 'Должно быть равно ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Должно быть между ${_number(min)} и ${_number(max)} (не включая границы)';

  @override
  String formLengthLessThan(int limit) =>
      'Должно содержать не менее $limit символов';

  @override
  String formLengthGreaterThan(int limit) =>
      'Должно содержать не более $limit символов';

  @override
  String get formPasswordDigits => 'Должно содержать хотя бы одну цифру';

  @override
  String get formPasswordLowercase =>
      'Должно содержать хотя бы одну строчную букву';

  @override
  String get formPasswordUppercase =>
      'Должно содержать хотя бы одну заглавную букву';

  @override
  String get formPasswordSpecial =>
      'Должно содержать хотя бы один специальный символ';

  @override
  String get commandSearch => 'Введите команду или запрос...';

  @override
  String get commandEmpty => 'Ничего не найдено.';

  @override
  String get datePickerSelectYear => 'Выберите год';

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
  String get abbreviatedSunday => 'Вс';

  @override
  String get monthJanuary => 'Январь';

  @override
  String get monthFebruary => 'Февраль';

  @override
  String get monthMarch => 'Март';

  @override
  String get monthApril => 'Апрель';

  @override
  String get monthMay => 'Май';

  @override
  String get monthJune => 'Июнь';

  @override
  String get monthJuly => 'Июль';

  @override
  String get monthAugust => 'Август';

  @override
  String get monthSeptember => 'Сентябрь';

  @override
  String get monthOctober => 'Октябрь';

  @override
  String get monthNovember => 'Ноябрь';

  @override
  String get monthDecember => 'Декабрь';

  @override
  String get abbreviatedJanuary => 'янв.';

  @override
  String get abbreviatedFebruary => 'февр.';

  @override
  String get abbreviatedMarch => 'март';

  @override
  String get abbreviatedApril => 'апр.';

  @override
  String get abbreviatedMay => 'май';

  @override
  String get abbreviatedJune => 'июнь';

  @override
  String get abbreviatedJuly => 'июль';

  @override
  String get abbreviatedAugust => 'авг.';

  @override
  String get abbreviatedSeptember => 'сент.';

  @override
  String get abbreviatedOctober => 'окт.';

  @override
  String get abbreviatedNovember => 'нояб.';

  @override
  String get abbreviatedDecember => 'дек.';

  @override
  String get dialogDismiss => 'Закрыть';

  @override
  String get buttonCancel => 'Отмена';

  @override
  String get buttonSave => 'Сохранить';

  @override
  String get timeHour => 'Час';

  @override
  String get timeMinute => 'Минута';

  @override
  String get timeSecond => 'Секунда';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Красный';

  @override
  String get colorGreen => 'Зелёный';

  @override
  String get colorBlue => 'Синий';

  @override
  String get colorAlpha => 'Альфа';

  @override
  String get colorHue => 'Оттенок';

  @override
  String get colorSaturation => 'Нас';

  @override
  String get colorValue => 'Ярк';

  @override
  String get colorLightness => 'Свет';

  @override
  String get menuCut => 'Вырезать';

  @override
  String get menuCopy => 'Копировать';

  @override
  String get menuPaste => 'Вставить';

  @override
  String get menuSelectAll => 'Выбрать всё';

  @override
  String get menuUndo => 'Отменить';

  @override
  String get menuRedo => 'Повторить';

  @override
  String get menuDelete => 'Удалить';

  @override
  String get menuShare => 'Поделиться';

  @override
  String get menuSearchWeb => 'Искать в интернете';

  @override
  String get menuLiveTextInput => 'Живой текст';

  @override
  String get placeholderDatePicker => 'Выберите дату';

  @override
  String get placeholderTimePicker => 'Выберите время';

  @override
  String get placeholderColorPicker => 'Выберите цвет';

  @override
  String get buttonPrevious => 'Назад';

  @override
  String get buttonNext => 'Далее';

  @override
  String get refreshTriggerPull => 'Потяните для обновления';

  @override
  String get refreshTriggerRelease => 'Отпустите для обновления';

  @override
  String get refreshTriggerRefreshing => 'Обновление...';

  @override
  String get refreshTriggerComplete => 'Обновление завершено';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Вверх';

  @override
  String get commandMoveDown => 'Вниз';

  @override
  String get commandActivate => 'Выбрать';

  @override
  String get timeDaysAbbreviation => 'ДД';

  @override
  String get timeHoursAbbreviation => 'ЧЧ';

  @override
  String get timeMinutesAbbreviation => 'ММ';

  @override
  String get timeSecondsAbbreviation => 'СС';

  @override
  String get placeholderDurationPicker => 'Выберите продолжительность';

  @override
  String get durationDay => 'День';

  @override
  String get durationHour => 'Час';

  @override
  String get durationMinute => 'Минута';

  @override
  String get durationSecond => 'Секунда';
}
