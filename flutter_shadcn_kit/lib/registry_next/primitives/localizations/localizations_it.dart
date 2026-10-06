import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Italian (`it`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsIt extends ShadcnLocalizations {
  /// Creates the Italian strings.
  const ShadcnLocalizationsIt([super.locale = const Locale('it')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Questo campo non può essere vuoto';

  @override
  String get invalidValue => 'Valore non valido';

  @override
  String get invalidEmail => 'Indirizzo e-mail non valido';

  @override
  String get invalidURL => 'URL non valido';

  @override
  String formLessThan(Object? value) =>
      'Deve essere minore di ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Deve essere maggiore di ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Deve essere minore o uguale a ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Il numero di telefono non è valido';

  @override
  String get formPhoneNumberEmpty => 'Il numero di telefono è obbligatorio';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Deve essere maggiore o uguale a ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Deve essere compreso tra ${_number(min)} e ${_number(max)} (inclusi)';

  @override
  String formEqualTo(Object? value) => 'Deve essere uguale a ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Deve essere compreso tra ${_number(min)} e ${_number(max)} (esclusi)';

  @override
  String formLengthLessThan(int limit) =>
      'Deve contenere almeno $limit caratteri';

  @override
  String formLengthGreaterThan(int limit) =>
      'Deve contenere al massimo $limit caratteri';

  @override
  String get formPasswordDigits => 'Deve contenere almeno una cifra';

  @override
  String get formPasswordLowercase =>
      'Deve contenere almeno una lettera minuscola';

  @override
  String get formPasswordUppercase =>
      'Deve contenere almeno una lettera maiuscola';

  @override
  String get formPasswordSpecial =>
      'Deve contenere almeno un carattere speciale';

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
  String get dialogDismiss => 'Ignora';

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
