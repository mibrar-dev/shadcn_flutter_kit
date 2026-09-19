// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Italian (`it`).
class ShadcnLocalizationsIt extends ShadcnLocalizations {
  /// Creates the Italian localizations.
  ShadcnLocalizationsIt([super.locale = 'it']);

  @override
  String get formNotEmpty => 'Questo campo non può essere vuoto';

  @override
  String get invalidValue => 'Valore non valido';

  @override
  String get invalidEmail => 'Indirizzo e-mail non valido';

  @override
  String get invalidURL => 'URL non valido';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve essere minore di $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve essere maggiore di $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve essere minore o uguale a $valueString';
  }

  String get formPhoneNumberInvalid => 'Il numero di telefono non è valido';

  String get formPhoneNumberEmpty => 'Il numero di telefono è obbligatorio';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve essere maggiore o uguale a $valueString';
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

    return 'Deve essere compreso tra $minString e $maxString (inclusi)';
  }

  String formEqualTo(String value) {
    return 'Deve essere uguale a ${value}';
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

    return 'Deve essere compreso tra $minString e $maxString (esclusi)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Deve contenere almeno ${value} caratteri';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Deve contenere al massimo ${value} caratteri';
  }

  @override
  String get formPasswordDigits => 'Deve contenere almeno una cifra';

  @override
  String get formPasswordLowercase => 'Deve contenere almeno una lettera minuscola';

  @override
  String get formPasswordUppercase => 'Deve contenere almeno una lettera maiuscola';

  @override
  String get formPasswordSpecial => 'Deve contenere almeno un carattere speciale';

  @override
  String get commandSearch => 'Digita un comando o cerca...';

  @override
  String get commandEmpty => 'Nessun risultato.';

  @override
  String get datePickerSelectYear => 'Seleziona un anno';

  @override
  String get abbreviatedMonday => 'Lu';

  @override
  String get abbreviatedTuesday => 'Ma';

  @override
  String get abbreviatedWednesday => 'Me';

  @override
  String get abbreviatedThursday => 'Gi';

  @override
  String get abbreviatedFriday => 'Ve';

  @override
  String get abbreviatedSaturday => 'Sa';

  @override
  String get abbreviatedSunday => 'Do';

  @override
  String get monthJanuary => 'Gennaio';

  @override
  String get monthFebruary => 'Febbraio';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Aprile';

  @override
  String get monthMay => 'Maggio';

  @override
  String get monthJune => 'Giugno';

  @override
  String get monthJuly => 'Luglio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Settembre';

  @override
  String get monthOctober => 'Ottobre';

  @override
  String get monthNovember => 'Novembre';

  @override
  String get monthDecember => 'Dicembre';

  @override
  String get abbreviatedJanuary => 'Gen';

  @override
  String get abbreviatedFebruary => 'Feb';

  @override
  String get abbreviatedMarch => 'Mar';

  @override
  String get abbreviatedApril => 'Apr';

  @override
  String get abbreviatedMay => 'Mag';

  @override
  String get abbreviatedJune => 'Giu';

  @override
  String get abbreviatedJuly => 'Lug';

  @override
  String get abbreviatedAugust => 'Ago';

  @override
  String get abbreviatedSeptember => 'Set';

  @override
  String get abbreviatedOctober => 'Ott';

  @override
  String get abbreviatedNovember => 'Nov';

  @override
  String get abbreviatedDecember => 'Dic';

  @override
  String get buttonCancel => 'Annulla';

  @override
  String get buttonSave => 'Salva';

  @override
  String get timeHour => 'Ora';

  @override
  String get timeMinute => 'Minuto';

  @override
  String get timeSecond => 'Secondo';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Rosso';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Blu';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Tonalità';

  @override
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Taglia';

  @override
  String get menuCopy => 'Copia';

  @override
  String get menuPaste => 'Incolla';

  @override
  String get menuSelectAll => 'Seleziona tutto';

  String get noSpellCheckReplacements => 'Nessun suggerimento trovato';

  @override
  String get menuUndo => 'Annulla';

  @override
  String get menuRedo => 'Ripeti';

  @override
  String get menuDelete => 'Elimina';

  @override
  String get menuShare => 'Condividi';

  @override
  String get menuSearchWeb => 'Cerca sul Web';

  @override
  String get menuLiveTextInput => 'Testo dal vivo';

  @override
  String get placeholderDatePicker => 'Seleziona una data';

  @override
  String get placeholderTimePicker => 'Seleziona un orario';

  @override
  String get placeholderColorPicker => 'Seleziona un colore';

  @override
  String get buttonPrevious => 'Precedente';

  @override
  String get buttonNext => 'Avanti';

  @override
  String get refreshTriggerPull => 'Trascina per aggiornare';

  @override
  String get refreshTriggerRelease => 'Rilascia per aggiornare';

  @override
  String get refreshTriggerRefreshing => 'Aggiornamento...';

  @override
  String get refreshTriggerComplete => 'Aggiornamento completato';

  @override
  String get colorPickerTabRecent => 'Recenti';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Sposta su';

  @override
  String get commandMoveDown => 'Sposta giù';

  @override
  String get commandActivate => 'Seleziona';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} di ${total} riga/righe selezionate.';
  }

  @override
  String get dataTableNext => 'Avanti';

  @override
  String get dataTablePrevious => 'Precedente';

  @override
  String get dataTableColumns => 'Colonne';

  @override
  String get timeDaysAbbreviation => 'GG';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Seleziona una durata';

  @override
  String get durationDay => 'Giorno';

  @override
  String get durationHour => 'Ora';

  @override
  String get durationMinute => 'Minuto';

  @override
  String get durationSecond => 'Secondo';
}
