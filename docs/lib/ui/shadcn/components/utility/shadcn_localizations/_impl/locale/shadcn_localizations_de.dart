// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for German (`de`).
class ShadcnLocalizationsDe extends ShadcnLocalizations {
  /// Creates the German localizations.
  ShadcnLocalizationsDe([super.locale = 'de']);

  @override
  String get formNotEmpty => 'Dieses Feld darf nicht leer sein';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get invalidURL => 'Ungültige URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Muss kleiner als $valueString sein';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Muss größer als $valueString sein';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Muss kleiner oder gleich $valueString sein';
  }

  String get formPhoneNumberInvalid => 'Die Telefonnummer ist ungültig';

  String get formPhoneNumberEmpty => 'Die Telefonnummer ist erforderlich';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Muss größer oder gleich $valueString sein';
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

    return 'Muss zwischen $minString und $maxString liegen (einschließlich)';
  }

  String formEqualTo(String value) {
    return 'Muss gleich ${value} sein';
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

    return 'Muss zwischen $minString und $maxString liegen (ausschließlich)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Muss mindestens ${value} Zeichen lang sein';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Darf höchstens ${value} Zeichen lang sein';
  }

  @override
  String get formPasswordDigits => 'Muss mindestens eine Ziffer enthalten';

  @override
  String get formPasswordLowercase => 'Muss mindestens einen Kleinbuchstaben enthalten';

  @override
  String get formPasswordUppercase => 'Muss mindestens einen Großbuchstaben enthalten';

  @override
  String get formPasswordSpecial => 'Muss mindestens ein Sonderzeichen enthalten';

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

  String get noSpellCheckReplacements => 'Keine Vorschläge gefunden';

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
  String get colorPickerTabRecent => 'Zuletzt';

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
  String dataTableSelectedRows(int count, int total) {
    return '${count} von ${total} Zeile(n) ausgewählt.';
  }

  @override
  String get dataTableNext => 'Weiter';

  @override
  String get dataTablePrevious => 'Zurück';

  @override
  String get dataTableColumns => 'Spalten';

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
