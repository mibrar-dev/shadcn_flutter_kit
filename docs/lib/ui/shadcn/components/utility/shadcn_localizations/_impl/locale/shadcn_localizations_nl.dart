// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Dutch (`nl`).
class ShadcnLocalizationsNl extends ShadcnLocalizations {
  /// Creates the Dutch localizations.
  ShadcnLocalizationsNl([super.locale = 'nl']);

  @override
  String get formNotEmpty => 'Dit veld mag niet leeg zijn';

  @override
  String get invalidValue => 'Ongeldige waarde';

  @override
  String get invalidEmail => 'Ongeldig e-mailadres';

  @override
  String get invalidURL => 'Ongeldige URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Moet kleiner zijn dan $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Moet groter zijn dan $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Moet kleiner dan of gelijk zijn aan $valueString';
  }

  String get formPhoneNumberInvalid => 'Het telefoonnummer is ongeldig';

  String get formPhoneNumberEmpty => 'Het telefoonnummer is verplicht';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Moet groter dan of gelijk zijn aan $valueString';
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

    return 'Moet tussen $minString en $maxString liggen (inclusief)';
  }

  String formEqualTo(String value) {
    return 'Moet gelijk zijn aan ${value}';
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

    return 'Moet tussen $minString en $maxString liggen (exclusief)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Moet minstens ${value} tekens bevatten';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Mag hoogstens ${value} tekens bevatten';
  }

  @override
  String get formPasswordDigits => 'Moet minstens één cijfer bevatten';

  @override
  String get formPasswordLowercase => 'Moet minstens één kleine letter bevatten';

  @override
  String get formPasswordUppercase => 'Moet minstens één hoofdletter bevatten';

  @override
  String get formPasswordSpecial => 'Moet minstens één speciaal teken bevatten';

  @override
  String get commandSearch => 'Typ een opdracht of zoek...';

  @override
  String get commandEmpty => 'Geen resultaten gevonden.';

  @override
  String get datePickerSelectYear => 'Selecteer een jaar';

  @override
  String get abbreviatedMonday => 'Ma';

  @override
  String get abbreviatedTuesday => 'Di';

  @override
  String get abbreviatedWednesday => 'Wo';

  @override
  String get abbreviatedThursday => 'Do';

  @override
  String get abbreviatedFriday => 'Vr';

  @override
  String get abbreviatedSaturday => 'Za';

  @override
  String get abbreviatedSunday => 'Zo';

  @override
  String get monthJanuary => 'Januari';

  @override
  String get monthFebruary => 'Februari';

  @override
  String get monthMarch => 'Maart';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Mei';

  @override
  String get monthJune => 'Juni';

  @override
  String get monthJuly => 'Juli';

  @override
  String get monthAugust => 'Augustus';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get abbreviatedJanuary => 'Jan';

  @override
  String get abbreviatedFebruary => 'Feb';

  @override
  String get abbreviatedMarch => 'Mrt';

  @override
  String get abbreviatedApril => 'Apr';

  @override
  String get abbreviatedMay => 'Mei';

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
  String get abbreviatedDecember => 'Dec';

  @override
  String get buttonCancel => 'Annuleren';

  @override
  String get buttonSave => 'Opslaan';

  @override
  String get timeHour => 'Uur';

  @override
  String get timeMinute => 'Minuut';

  @override
  String get timeSecond => 'Seconde';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Rood';

  @override
  String get colorGreen => 'Groen';

  @override
  String get colorBlue => 'Blauw';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Tint';

  @override
  String get colorSaturation => 'Verz';

  @override
  String get colorValue => 'Wrd';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Knippen';

  @override
  String get menuCopy => 'Kopiëren';

  @override
  String get menuPaste => 'Plakken';

  @override
  String get menuSelectAll => 'Alles selecteren';

  String get noSpellCheckReplacements => 'Geen suggesties gevonden';

  @override
  String get menuUndo => 'Ongedaan maken';

  @override
  String get menuRedo => 'Opnieuw';

  @override
  String get menuDelete => 'Verwijderen';

  @override
  String get menuShare => 'Delen';

  @override
  String get menuSearchWeb => 'Op het web zoeken';

  @override
  String get menuLiveTextInput => 'Live tekst';

  @override
  String get placeholderDatePicker => 'Selecteer een datum';

  @override
  String get placeholderTimePicker => 'Selecteer een tijd';

  @override
  String get placeholderColorPicker => 'Selecteer een kleur';

  @override
  String get buttonPrevious => 'Vorige';

  @override
  String get buttonNext => 'Volgende';

  @override
  String get refreshTriggerPull => 'Trek om te vernieuwen';

  @override
  String get refreshTriggerRelease => 'Laat los om te vernieuwen';

  @override
  String get refreshTriggerRefreshing => 'Vernieuwen...';

  @override
  String get refreshTriggerComplete => 'Vernieuwen voltooid';

  @override
  String get colorPickerTabRecent => 'Recent';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Omhoog';

  @override
  String get commandMoveDown => 'Omlaag';

  @override
  String get commandActivate => 'Selecteren';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} van ${total} rij(en) geselecteerd.';
  }

  @override
  String get dataTableNext => 'Volgende';

  @override
  String get dataTablePrevious => 'Vorige';

  @override
  String get dataTableColumns => 'Kolommen';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'UU';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Selecteer een duur';

  @override
  String get durationDay => 'Dag';

  @override
  String get durationHour => 'Uur';

  @override
  String get durationMinute => 'Minuut';

  @override
  String get durationSecond => 'Seconde';
}
