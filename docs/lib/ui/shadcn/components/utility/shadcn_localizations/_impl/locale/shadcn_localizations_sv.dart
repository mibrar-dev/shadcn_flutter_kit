// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Swedish (`sv`).
class ShadcnLocalizationsSv extends ShadcnLocalizations {
  /// Creates the Swedish localizations.
  ShadcnLocalizationsSv([super.locale = 'sv']);

  @override
  String get formNotEmpty => 'Det här fältet får inte vara tomt';

  @override
  String get invalidValue => 'Ogiltigt värde';

  @override
  String get invalidEmail => 'Ogiltig e-postadress';

  @override
  String get invalidURL => 'Ogiltig URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Måste vara mindre än $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Måste vara större än $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Måste vara mindre än eller lika med $valueString';
  }

  String get formPhoneNumberInvalid => 'Telefonnumret är ogiltigt';

  String get formPhoneNumberEmpty => 'Telefonnummer krävs';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Måste vara större än eller lika med $valueString';
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

    return 'Måste vara mellan $minString och $maxString (inklusive)';
  }

  String formEqualTo(String value) {
    return 'Måste vara lika med ${value}';
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

    return 'Måste vara mellan $minString och $maxString (exklusive)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Måste innehålla minst ${value} tecken';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Får innehålla högst ${value} tecken';
  }

  @override
  String get formPasswordDigits => 'Måste innehålla minst en siffra';

  @override
  String get formPasswordLowercase => 'Måste innehålla minst en liten bokstav';

  @override
  String get formPasswordUppercase => 'Måste innehålla minst en stor bokstav';

  @override
  String get formPasswordSpecial => 'Måste innehålla minst ett specialtecken';

  @override
  String get commandSearch => 'Skriv ett kommando eller sök...';

  @override
  String get commandEmpty => 'Inga resultat hittades.';

  @override
  String get datePickerSelectYear => 'Välj ett år';

  @override
  String get abbreviatedMonday => 'Må';

  @override
  String get abbreviatedTuesday => 'Ti';

  @override
  String get abbreviatedWednesday => 'On';

  @override
  String get abbreviatedThursday => 'To';

  @override
  String get abbreviatedFriday => 'Fr';

  @override
  String get abbreviatedSaturday => 'Lö';

  @override
  String get abbreviatedSunday => 'Sö';

  @override
  String get monthJanuary => 'Januari';

  @override
  String get monthFebruary => 'Februari';

  @override
  String get monthMarch => 'Mars';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Maj';

  @override
  String get monthJune => 'Juni';

  @override
  String get monthJuly => 'Juli';

  @override
  String get monthAugust => 'Augusti';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

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
  String get abbreviatedMay => 'maj';

  @override
  String get abbreviatedJune => 'jun';

  @override
  String get abbreviatedJuly => 'jul';

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
  String get buttonCancel => 'Avbryt';

  @override
  String get buttonSave => 'Spara';

  @override
  String get timeHour => 'Timme';

  @override
  String get timeMinute => 'Minut';

  @override
  String get timeSecond => 'Sekund';

  @override
  String get timeAM => 'FM';

  @override
  String get timePM => 'EM';

  @override
  String get colorRed => 'Röd';

  @override
  String get colorGreen => 'Grön';

  @override
  String get colorBlue => 'Blå';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Nyans';

  @override
  String get colorSaturation => 'Mätt';

  @override
  String get colorValue => 'Värde';

  @override
  String get colorLightness => 'Ljus';

  @override
  String get menuCut => 'Klipp ut';

  @override
  String get menuCopy => 'Kopiera';

  @override
  String get menuPaste => 'Klistra in';

  @override
  String get menuSelectAll => 'Markera allt';

  String get noSpellCheckReplacements => 'Inga förslag hittades';

  @override
  String get menuUndo => 'Ångra';

  @override
  String get menuRedo => 'Gör om';

  @override
  String get menuDelete => 'Ta bort';

  @override
  String get menuShare => 'Dela';

  @override
  String get menuSearchWeb => 'Sök på webben';

  @override
  String get menuLiveTextInput => 'Live-text';

  @override
  String get placeholderDatePicker => 'Välj ett datum';

  @override
  String get placeholderTimePicker => 'Välj en tid';

  @override
  String get placeholderColorPicker => 'Välj en färg';

  @override
  String get buttonPrevious => 'Föregående';

  @override
  String get buttonNext => 'Nästa';

  @override
  String get refreshTriggerPull => 'Dra för att uppdatera';

  @override
  String get refreshTriggerRelease => 'Släpp för att uppdatera';

  @override
  String get refreshTriggerRefreshing => 'Uppdaterar...';

  @override
  String get refreshTriggerComplete => 'Uppdatering klar';

  @override
  String get colorPickerTabRecent => 'Senaste';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Flytta upp';

  @override
  String get commandMoveDown => 'Flytta ner';

  @override
  String get commandActivate => 'Välj';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} av ${total} rad(er) markerade.';
  }

  @override
  String get dataTableNext => 'Nästa';

  @override
  String get dataTablePrevious => 'Föregående';

  @override
  String get dataTableColumns => 'Kolumner';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'TT';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Välj en varaktighet';

  @override
  String get durationDay => 'Dag';

  @override
  String get durationHour => 'Timme';

  @override
  String get durationMinute => 'Minut';

  @override
  String get durationSecond => 'Sekund';
}
