// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Russian (`ru`).
class ShadcnLocalizationsRu extends ShadcnLocalizations {
  /// Creates the Russian localizations.
  ShadcnLocalizationsRu([super.locale = 'ru']);

  @override
  String get formNotEmpty => 'Это поле не может быть пустым';

  @override
  String get invalidValue => 'Недопустимое значение';

  @override
  String get invalidEmail => 'Недопустимый адрес эл. почты';

  @override
  String get invalidURL => 'Недопустимый URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Должно быть меньше $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Должно быть больше $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Должно быть меньше или равно $valueString';
  }

  String get formPhoneNumberInvalid => 'Недопустимый номер телефона';

  String get formPhoneNumberEmpty => 'Укажите номер телефона';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Должно быть больше или равно $valueString';
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

    return 'Должно быть от $minString до $maxString (включительно)';
  }

  String formEqualTo(String value) {
    return 'Должно быть равно ${value}';
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

    return 'Должно быть между $minString и $maxString (не включая границы)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Должно содержать не менее ${value} символов';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Должно содержать не более ${value} символов';
  }

  @override
  String get formPasswordDigits => 'Должно содержать хотя бы одну цифру';

  @override
  String get formPasswordLowercase => 'Должно содержать хотя бы одну строчную букву';

  @override
  String get formPasswordUppercase => 'Должно содержать хотя бы одну заглавную букву';

  @override
  String get formPasswordSpecial => 'Должно содержать хотя бы один специальный символ';

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

  String get noSpellCheckReplacements => 'Вариантов не найдено';

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
  String get colorPickerTabRecent => 'Недавние';

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
  String dataTableSelectedRows(int count, int total) {
    return 'Выбрано строк: ${count} из ${total}.';
  }

  @override
  String get dataTableNext => 'Далее';

  @override
  String get dataTablePrevious => 'Назад';

  @override
  String get dataTableColumns => 'Столбцы';

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
