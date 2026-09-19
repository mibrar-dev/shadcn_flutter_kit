// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Bulgarian (`bg`).
class ShadcnLocalizationsBg extends ShadcnLocalizations {
  /// Creates the Bulgarian localizations.
  ShadcnLocalizationsBg([super.locale = 'bg']);

  @override
  String get formNotEmpty => 'Това поле не може да бъде празно';

  @override
  String get invalidValue => 'Невалидна стойност';

  @override
  String get invalidEmail => 'Невалиден имейл';

  @override
  String get invalidURL => 'Невалиден URL адрес';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Трябва да е по-малко от $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Трябва да е по-голямо от $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Трябва да е по-малко или равно на $valueString';
  }

  String get formPhoneNumberInvalid => 'Телефонният номер е невалиден';

  String get formPhoneNumberEmpty => 'Телефонният номер е задължителен';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Трябва да е по-голямо или равно на $valueString';
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

    return 'Трябва да е между $minString и $maxString (включително)';
  }

  String formEqualTo(String value) {
    return 'Трябва да е равно на ${value}';
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

    return 'Трябва да е между $minString и $maxString (без границите)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Трябва да съдържа поне ${value} знака';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Трябва да съдържа най-много ${value} знака';
  }

  @override
  String get formPasswordDigits => 'Трябва да съдържа поне една цифра';

  @override
  String get formPasswordLowercase => 'Трябва да съдържа поне една малка буква';

  @override
  String get formPasswordUppercase => 'Трябва да съдържа поне една главна буква';

  @override
  String get formPasswordSpecial => 'Трябва да съдържа поне един специален знак';

  @override
  String get commandSearch => 'Въведете команда или потърсете...';

  @override
  String get commandEmpty => 'Няма намерени резултати.';

  @override
  String get datePickerSelectYear => 'Изберете година';

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
  String get monthJanuary => 'Януари';

  @override
  String get monthFebruary => 'Февруари';

  @override
  String get monthMarch => 'Март';

  @override
  String get monthApril => 'Април';

  @override
  String get monthMay => 'Май';

  @override
  String get monthJune => 'Юни';

  @override
  String get monthJuly => 'Юли';

  @override
  String get monthAugust => 'Август';

  @override
  String get monthSeptember => 'Септември';

  @override
  String get monthOctober => 'Октомври';

  @override
  String get monthNovember => 'Ноември';

  @override
  String get monthDecember => 'Декември';

  @override
  String get abbreviatedJanuary => 'яну';

  @override
  String get abbreviatedFebruary => 'фев';

  @override
  String get abbreviatedMarch => 'мар';

  @override
  String get abbreviatedApril => 'апр';

  @override
  String get abbreviatedMay => 'май';

  @override
  String get abbreviatedJune => 'юни';

  @override
  String get abbreviatedJuly => 'юли';

  @override
  String get abbreviatedAugust => 'авг';

  @override
  String get abbreviatedSeptember => 'сеп';

  @override
  String get abbreviatedOctober => 'окт';

  @override
  String get abbreviatedNovember => 'ное';

  @override
  String get abbreviatedDecember => 'дек';

  @override
  String get buttonCancel => 'Отказ';

  @override
  String get buttonSave => 'Запазване';

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
  String get colorRed => 'Червено';

  @override
  String get colorGreen => 'Зелено';

  @override
  String get colorBlue => 'Синьо';

  @override
  String get colorAlpha => 'Алфа';

  @override
  String get colorHue => 'Нюанс';

  @override
  String get colorSaturation => 'Нас';

  @override
  String get colorValue => 'Стой';

  @override
  String get colorLightness => 'Свет';

  @override
  String get menuCut => 'Изрязване';

  @override
  String get menuCopy => 'Копиране';

  @override
  String get menuPaste => 'Поставяне';

  @override
  String get menuSelectAll => 'Избор на всичко';

  String get noSpellCheckReplacements => 'Няма намерени предложения';

  @override
  String get menuUndo => 'Отмяна';

  @override
  String get menuRedo => 'Повтаряне';

  @override
  String get menuDelete => 'Изтриване';

  @override
  String get menuShare => 'Споделяне';

  @override
  String get menuSearchWeb => 'Търсене в интернет';

  @override
  String get menuLiveTextInput => 'Жив текст';

  @override
  String get placeholderDatePicker => 'Изберете дата';

  @override
  String get placeholderTimePicker => 'Изберете час';

  @override
  String get placeholderColorPicker => 'Изберете цвят';

  @override
  String get buttonPrevious => 'Назад';

  @override
  String get buttonNext => 'Напред';

  @override
  String get refreshTriggerPull => 'Издърпайте за опресняване';

  @override
  String get refreshTriggerRelease => 'Пуснете за опресняване';

  @override
  String get refreshTriggerRefreshing => 'Опресняване...';

  @override
  String get refreshTriggerComplete => 'Опресняването завърши';

  @override
  String get colorPickerTabRecent => 'Скорошни';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Преместване нагоре';

  @override
  String get commandMoveDown => 'Преместване надолу';

  @override
  String get commandActivate => 'Избор';

  @override
  String dataTableSelectedRows(int count, int total) {
    return 'Избрани са ${count} от ${total} реда.';
  }

  @override
  String get dataTableNext => 'Напред';

  @override
  String get dataTablePrevious => 'Назад';

  @override
  String get dataTableColumns => 'Колони';

  @override
  String get timeDaysAbbreviation => 'ДД';

  @override
  String get timeHoursAbbreviation => 'ЧЧ';

  @override
  String get timeMinutesAbbreviation => 'ММ';

  @override
  String get timeSecondsAbbreviation => 'СС';

  @override
  String get placeholderDurationPicker => 'Изберете продължителност';

  @override
  String get durationDay => 'Ден';

  @override
  String get durationHour => 'Час';

  @override
  String get durationMinute => 'Минута';

  @override
  String get durationSecond => 'Секунда';
}
