// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Danish (`da`).
class ShadcnLocalizationsDa extends ShadcnLocalizations {
  /// Creates the Danish localizations.
  ShadcnLocalizationsDa([super.locale = 'da']);

  @override
  String get formNotEmpty => 'Dette felt må ikke være tomt';

  @override
  String get invalidValue => 'Ugyldig værdi';

  @override
  String get invalidEmail => 'Ugyldig e-mailadresse';

  @override
  String get invalidURL => 'Ugyldig URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Skal være mindre end $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Skal være større end $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Skal være mindre end eller lig med $valueString';
  }

  String get formPhoneNumberInvalid => 'Telefonnummeret er ugyldigt';

  String get formPhoneNumberEmpty => 'Telefonnummer er påkrævet';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Skal være større end eller lig med $valueString';
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

    return 'Skal være mellem $minString og $maxString (inklusive)';
  }

  String formEqualTo(String value) {
    return 'Skal være lig med ${value}';
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

    return 'Skal være mellem $minString og $maxString (eksklusive)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Skal indeholde mindst ${value} tegn';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Må højst indeholde ${value} tegn';
  }

  @override
  String get formPasswordDigits => 'Skal indeholde mindst ét ciffer';

  @override
  String get formPasswordLowercase => 'Skal indeholde mindst ét lille bogstav';

  @override
  String get formPasswordUppercase => 'Skal indeholde mindst ét stort bogstav';

  @override
  String get formPasswordSpecial => 'Skal indeholde mindst ét specialtegn';

  @override
  String get commandSearch => 'Skriv en kommando, eller søg...';

  @override
  String get commandEmpty => 'Ingen resultater fundet.';

  @override
  String get datePickerSelectYear => 'Vælg et år';

  @override
  String get abbreviatedMonday => 'Ma';

  @override
  String get abbreviatedTuesday => 'Ti';

  @override
  String get abbreviatedWednesday => 'On';

  @override
  String get abbreviatedThursday => 'To';

  @override
  String get abbreviatedFriday => 'Fr';

  @override
  String get abbreviatedSaturday => 'Lø';

  @override
  String get abbreviatedSunday => 'Sø';

  @override
  String get monthJanuary => 'Januar';

  @override
  String get monthFebruary => 'Februar';

  @override
  String get monthMarch => 'Marts';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Maj';

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
  String get buttonCancel => 'Annuller';

  @override
  String get buttonSave => 'Gem';

  @override
  String get timeHour => 'Time';

  @override
  String get timeMinute => 'Minut';

  @override
  String get timeSecond => 'Sekund';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Rød';

  @override
  String get colorGreen => 'Grøn';

  @override
  String get colorBlue => 'Blå';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Farvetone';

  @override
  String get colorSaturation => 'Mæt';

  @override
  String get colorValue => 'Værdi';

  @override
  String get colorLightness => 'Lys';

  @override
  String get menuCut => 'Klip';

  @override
  String get menuCopy => 'Kopiér';

  @override
  String get menuPaste => 'Indsæt';

  @override
  String get menuSelectAll => 'Vælg alle';

  String get noSpellCheckReplacements => 'Ingen forslag fundet';

  @override
  String get menuUndo => 'Fortryd';

  @override
  String get menuRedo => 'Gentag';

  @override
  String get menuDelete => 'Slet';

  @override
  String get menuShare => 'Del';

  @override
  String get menuSearchWeb => 'Søg på nettet';

  @override
  String get menuLiveTextInput => 'Livetekst';

  @override
  String get placeholderDatePicker => 'Vælg en dato';

  @override
  String get placeholderTimePicker => 'Vælg et tidspunkt';

  @override
  String get placeholderColorPicker => 'Vælg en farve';

  @override
  String get buttonPrevious => 'Forrige';

  @override
  String get buttonNext => 'Næste';

  @override
  String get refreshTriggerPull => 'Træk for at opdatere';

  @override
  String get refreshTriggerRelease => 'Slip for at opdatere';

  @override
  String get refreshTriggerRefreshing => 'Opdaterer...';

  @override
  String get refreshTriggerComplete => 'Opdatering fuldført';

  @override
  String get colorPickerTabRecent => 'Seneste';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Flyt op';

  @override
  String get commandMoveDown => 'Flyt ned';

  @override
  String get commandActivate => 'Vælg';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} af ${total} række(r) valgt.';
  }

  @override
  String get dataTableNext => 'Næste';

  @override
  String get dataTablePrevious => 'Forrige';

  @override
  String get dataTableColumns => 'Kolonner';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'TT';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Vælg en varighed';

  @override
  String get durationDay => 'Dag';

  @override
  String get durationHour => 'Time';

  @override
  String get durationMinute => 'Minut';

  @override
  String get durationSecond => 'Sekund';
}
