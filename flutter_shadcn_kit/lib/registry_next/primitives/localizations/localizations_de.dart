import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// German (`de`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsDe extends ShadcnLocalizations {
  /// Creates the German strings.
  const ShadcnLocalizationsDe([super.locale = const Locale('de')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Dieses Feld darf nicht leer sein';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get invalidURL => 'Ungültige URL';

  @override
  String formLessThan(Object? value) =>
      'Muss kleiner als ${_number(value)} sein';

  @override
  String formGreaterThan(Object? value) =>
      'Muss größer als ${_number(value)} sein';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Muss kleiner oder gleich ${_number(value)} sein';

  @override
  String get formPhoneNumberInvalid => 'Die Telefonnummer ist ungültig';

  @override
  String get formPhoneNumberEmpty => 'Die Telefonnummer ist erforderlich';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Muss größer oder gleich ${_number(value)} sein';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Muss zwischen ${_number(min)} und ${_number(max)} liegen (einschließlich)';

  @override
  String formEqualTo(Object? value) => 'Muss gleich ${_number(value)} sein';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Muss zwischen ${_number(min)} und ${_number(max)} liegen (ausschließlich)';

  @override
  String formLengthLessThan(int limit) =>
      'Muss mindestens $limit Zeichen lang sein';

  @override
  String formLengthGreaterThan(int limit) =>
      'Darf höchstens $limit Zeichen lang sein';

  @override
  String get formPasswordDigits => 'Muss mindestens eine Ziffer enthalten';

  @override
  String get formPasswordLowercase =>
      'Muss mindestens einen Kleinbuchstaben enthalten';

  @override
  String get formPasswordUppercase =>
      'Muss mindestens einen Großbuchstaben enthalten';

  @override
  String get formPasswordSpecial =>
      'Muss mindestens ein Sonderzeichen enthalten';

  @override
  String get commandSearch => 'Befehl eingeben oder suchen...';

  @override
  String get commandEmpty => 'Keine Ergebnisse gefunden.';

  @override
  String get datePickerSelectYear => 'Jahr auswählen';

  @override
  String get abbreviatedMonday => 'Mo';

  @override
  String get abbreviatedTuesday => 'Di';

  @override
  String get abbreviatedWednesday => 'Mi';

  @override
  String get abbreviatedThursday => 'Do';

  @override
  String get abbreviatedFriday => 'Fr';

  @override
  String get abbreviatedSaturday => 'Sa';

  @override
  String get abbreviatedSunday => 'So';

  @override
  String get monthJanuary => 'Januar';

  @override
  String get monthFebruary => 'Februar';

  @override
  String get monthMarch => 'März';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Juni';

  @override
  String get monthJuly => 'Juli';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'Dezember';

  @override
  String get abbreviatedJanuary => 'Jan';

  @override
  String get abbreviatedFebruary => 'Feb';

  @override
  String get abbreviatedMarch => 'Mär';

  @override
  String get abbreviatedApril => 'Apr';

  @override
  String get abbreviatedMay => 'Mai';

  @override
  String get abbreviatedJune => 'Jun';

  @override
  String get abbreviatedJuly => 'Jul';

  @override
  String get abbreviatedAugust => 'Aug';

  @override
  String get abbreviatedSeptember => 'Sep';

  @override
  String get abbreviatedOctober => 'Okt';

  @override
  String get abbreviatedNovember => 'Nov';

  @override
  String get abbreviatedDecember => 'Dez';

  @override
  String get dialogDismiss => 'Schließen';

  @override
  String get chipInputRemoveChip => 'Löschen';

  @override
  String get buttonCancel => 'Abbrechen';

  @override
  String get buttonSave => 'Speichern';

  @override
  String get timeHour => 'Stunde';

  @override
  String get timeMinute => 'Minute';

  @override
  String get timeSecond => 'Sekunde';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Rot';

  @override
  String get colorGreen => 'Grün';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorAlpha => 'Alpha';

  @override
  String get colorHue => 'Farbton';

  @override
  String get colorSaturation => 'Sät';

  @override
  String get colorValue => 'Hell';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Ausschneiden';

  @override
  String get menuCopy => 'Kopieren';

  @override
  String get menuPaste => 'Einfügen';

  @override
  String get menuSelectAll => 'Alles auswählen';

  @override
  String get menuUndo => 'Rückgängig';

  @override
  String get menuRedo => 'Wiederholen';

  @override
  String get menuDelete => 'Löschen';

  @override
  String get menuShare => 'Teilen';

  @override
  String get menuSearchWeb => 'Im Web suchen';

  @override
  String get menuLiveTextInput => 'Live-Text';

  @override
  String get placeholderDatePicker => 'Datum auswählen';

  @override
  String get placeholderTimePicker => 'Uhrzeit auswählen';

  @override
  String get placeholderColorPicker => 'Farbe auswählen';

  @override
  String get buttonPrevious => 'Zurück';

  @override
  String get buttonNext => 'Weiter';

  @override
  String get refreshTriggerPull => 'Zum Aktualisieren ziehen';

  @override
  String get refreshTriggerRelease => 'Zum Aktualisieren loslassen';

  @override
  String get refreshTriggerRefreshing => 'Wird aktualisiert...';

  @override
  String get refreshTriggerComplete => 'Aktualisierung abgeschlossen';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Nach oben';

  @override
  String get commandMoveDown => 'Nach unten';

  @override
  String get commandActivate => 'Auswählen';

  @override
  String get timeDaysAbbreviation => 'TT';

  @override
  String get timeHoursAbbreviation => 'SS';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Dauer auswählen';

  @override
  String get durationDay => 'Tag';

  @override
  String get durationHour => 'Stunde';

  @override
  String get durationMinute => 'Minute';

  @override
  String get durationSecond => 'Sekunde';
}
