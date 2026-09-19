// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Slovak (`sk`).
class ShadcnLocalizationsSk extends ShadcnLocalizations {
  /// Creates the Slovak localizations.
  ShadcnLocalizationsSk([super.locale = 'sk']);

  @override
  String get formNotEmpty => 'Toto pole nesmie byť prázdne';

  @override
  String get invalidValue => 'Neplatná hodnota';

  @override
  String get invalidEmail => 'Neplatný e-mail';

  @override
  String get invalidURL => 'Neplatná adresa URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musí byť menšie ako $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musí byť väčšie ako $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musí byť menšie alebo rovné $valueString';
  }

  String get formPhoneNumberInvalid => 'Telefónne číslo je neplatné';

  String get formPhoneNumberEmpty => 'Telefónne číslo je povinné';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musí byť väčšie alebo rovné $valueString';
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

    return 'Musí byť medzi $minString a $maxString (vrátane)';
  }

  String formEqualTo(String value) {
    return 'Musí sa rovnať ${value}';
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

    return 'Musí byť medzi $minString a $maxString (bez krajných hodnôt)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Musí mať aspoň ${value} znakov';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Môže mať najviac ${value} znakov';
  }

  @override
  String get formPasswordDigits => 'Musí obsahovať aspoň jednu číslicu';

  @override
  String get formPasswordLowercase => 'Musí obsahovať aspoň jedno malé písmeno';

  @override
  String get formPasswordUppercase => 'Musí obsahovať aspoň jedno veľké písmeno';

  @override
  String get formPasswordSpecial => 'Musí obsahovať aspoň jeden špeciálny znak';

  @override
  String get commandSearch => 'Zadajte príkaz alebo hľadajte...';

  @override
  String get commandEmpty => 'Nenašli sa žiadne výsledky.';

  @override
  String get datePickerSelectYear => 'Vyberte rok';

  @override
  String get abbreviatedMonday => 'Po';

  @override
  String get abbreviatedTuesday => 'Ut';

  @override
  String get abbreviatedWednesday => 'St';

  @override
  String get abbreviatedThursday => 'Št';

  @override
  String get abbreviatedFriday => 'Pi';

  @override
  String get abbreviatedSaturday => 'So';

  @override
  String get abbreviatedSunday => 'Ne';

  @override
  String get monthJanuary => 'Január';

  @override
  String get monthFebruary => 'Február';

  @override
  String get monthMarch => 'Marec';

  @override
  String get monthApril => 'Apríl';

  @override
  String get monthMay => 'Máj';

  @override
  String get monthJune => 'Jún';

  @override
  String get monthJuly => 'Júl';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Október';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get abbreviatedJanuary => 'jan';

  @override
  String get abbreviatedFebruary => 'feb';

  @override
  String get abbreviatedMarch => 'mar';

  @override
  String get abbreviatedApril => 'apr';

  @override
  String get abbreviatedMay => 'máj';

  @override
  String get abbreviatedJune => 'jún';

  @override
  String get abbreviatedJuly => 'júl';

  @override
  String get abbreviatedAugust => 'aug';

  @override
  String get abbreviatedSeptember => 'sep';

  @override
  String get abbreviatedOctober => 'okt';

  @override
  String get abbreviatedNovember => 'nov';

  @override
  String get abbreviatedDecember => 'dec';

  @override
  String get buttonCancel => 'Zrušiť';

  @override
  String get buttonSave => 'Uložiť';

  @override
  String get timeHour => 'Hodina';

  @override
  String get timeMinute => 'Minúta';

  @override
  String get timeSecond => 'Sekunda';

  @override
  String get timeAM => 'dop.';

  @override
  String get timePM => 'popol.';

  @override
  String get colorRed => 'Červená';

  @override
  String get colorGreen => 'Zelená';

  @override
  String get colorBlue => 'Modrá';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Odtieň';

  @override
  String get colorSaturation => 'Sýt';

  @override
  String get colorValue => 'Hod';

  @override
  String get colorLightness => 'Jas';

  @override
  String get menuCut => 'Vystrihnúť';

  @override
  String get menuCopy => 'Kopírovať';

  @override
  String get menuPaste => 'Prilepiť';

  @override
  String get menuSelectAll => 'Vybrať všetko';

  String get noSpellCheckReplacements => 'Nenašli sa žiadne návrhy';

  @override
  String get menuUndo => 'Späť';

  @override
  String get menuRedo => 'Znova';

  @override
  String get menuDelete => 'Odstrániť';

  @override
  String get menuShare => 'Zdieľať';

  @override
  String get menuSearchWeb => 'Hľadať na webe';

  @override
  String get menuLiveTextInput => 'Živý text';

  @override
  String get placeholderDatePicker => 'Vyberte dátum';

  @override
  String get placeholderTimePicker => 'Vyberte čas';

  @override
  String get placeholderColorPicker => 'Vyberte farbu';

  @override
  String get buttonPrevious => 'Predchádzajúce';

  @override
  String get buttonNext => 'Ďalšie';

  @override
  String get refreshTriggerPull => 'Potiahnutím obnovte';

  @override
  String get refreshTriggerRelease => 'Uvoľnením obnovte';

  @override
  String get refreshTriggerRefreshing => 'Obnovuje sa...';

  @override
  String get refreshTriggerComplete => 'Obnovenie dokončené';

  @override
  String get colorPickerTabRecent => 'Nedávne';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Posunúť nahor';

  @override
  String get commandMoveDown => 'Posunúť nadol';

  @override
  String get commandActivate => 'Vybrať';

  @override
  String dataTableSelectedRows(int count, int total) {
    return 'Vybraných ${count} z ${total} riadkov.';
  }

  @override
  String get dataTableNext => 'Ďalšie';

  @override
  String get dataTablePrevious => 'Predchádzajúce';

  @override
  String get dataTableColumns => 'Stĺpce';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Vyberte trvanie';

  @override
  String get durationDay => 'Deň';

  @override
  String get durationHour => 'Hodina';

  @override
  String get durationMinute => 'Minúta';

  @override
  String get durationSecond => 'Sekunda';
}
