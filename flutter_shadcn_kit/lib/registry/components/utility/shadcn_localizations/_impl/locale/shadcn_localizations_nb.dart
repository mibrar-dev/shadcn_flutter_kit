// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Norwegian Bokmal (`nb`).
class ShadcnLocalizationsNb extends ShadcnLocalizations {
  /// Creates the Norwegian Bokmal localizations.
  ShadcnLocalizationsNb([super.locale = 'nb']);

  @override
  String get formNotEmpty => 'Dette feltet kan ikke være tomt';

  @override
  String get invalidValue => 'Ugyldig verdi';

  @override
  String get invalidEmail => 'Ugyldig e-postadresse';

  @override
  String get invalidURL => 'Ugyldig URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Må være mindre enn $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Må være større enn $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Må være mindre enn eller lik $valueString';
  }

  String get formPhoneNumberInvalid => 'Telefonnummeret er ugyldig';

  String get formPhoneNumberEmpty => 'Telefonnummer er påkrevd';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Må være større enn eller lik $valueString';
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

    return 'Må være mellom $minString og $maxString (inklusive)';
  }

  String formEqualTo(String value) {
    return 'Må være lik ${value}';
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

    return 'Må være mellom $minString og $maxString (eksklusive)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Må inneholde minst ${value} tegn';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Kan inneholde høyst ${value} tegn';
  }

  @override
  String get formPasswordDigits => 'Må inneholde minst ett siffer';

  @override
  String get formPasswordLowercase => 'Må inneholde minst én liten bokstav';

  @override
  String get formPasswordUppercase => 'Må inneholde minst én stor bokstav';

  @override
  String get formPasswordSpecial => 'Må inneholde minst ett spesialtegn';

  @override
  String get commandSearch => 'Skriv en kommando eller søk...';

  @override
  String get commandEmpty => 'Ingen resultater funnet.';

  @override
  String get datePickerSelectYear => 'Velg et år';

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
  String get monthMarch => 'Mars';

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
  String get monthDecember => 'Desember';

  @override
  String get abbreviatedJanuary => 'jan';

  @override
  String get abbreviatedFebruary => 'feb';

  @override
  String get abbreviatedMarch => 'mar';

  @override
  String get abbreviatedApril => 'apr';

  @override
  String get abbreviatedMay => 'mai';

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
  String get abbreviatedDecember => 'des';

  @override
  String get buttonCancel => 'Avbryt';

  @override
  String get buttonSave => 'Lagre';

  @override
  String get timeHour => 'Time';

  @override
  String get timeMinute => 'Minutt';

  @override
  String get timeSecond => 'Sekund';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Rød';

  @override
  String get colorGreen => 'Grønn';

  @override
  String get colorBlue => 'Blå';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Fargetone';

  @override
  String get colorSaturation => 'Met';

  @override
  String get colorValue => 'Verdi';

  @override
  String get colorLightness => 'Lys';

  @override
  String get menuCut => 'Klipp ut';

  @override
  String get menuCopy => 'Kopier';

  @override
  String get menuPaste => 'Lim inn';

  @override
  String get menuSelectAll => 'Merk alt';

  String get noSpellCheckReplacements => 'Ingen forslag funnet';

  @override
  String get menuUndo => 'Angre';

  @override
  String get menuRedo => 'Gjør om';

  @override
  String get menuDelete => 'Slett';

  @override
  String get menuShare => 'Del';

  @override
  String get menuSearchWeb => 'Søk på nettet';

  @override
  String get menuLiveTextInput => 'Live-tekst';

  @override
  String get placeholderDatePicker => 'Velg en dato';

  @override
  String get placeholderTimePicker => 'Velg et tidspunkt';

  @override
  String get placeholderColorPicker => 'Velg en farge';

  @override
  String get buttonPrevious => 'Forrige';

  @override
  String get buttonNext => 'Neste';

  @override
  String get refreshTriggerPull => 'Dra for å oppdatere';

  @override
  String get refreshTriggerRelease => 'Slipp for å oppdatere';

  @override
  String get refreshTriggerRefreshing => 'Oppdaterer...';

  @override
  String get refreshTriggerComplete => 'Oppdatering fullført';

  @override
  String get colorPickerTabRecent => 'Nylige';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Flytt opp';

  @override
  String get commandMoveDown => 'Flytt ned';

  @override
  String get commandActivate => 'Velg';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} av ${total} rad(er) valgt.';
  }

  @override
  String get dataTableNext => 'Neste';

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
  String get placeholderDurationPicker => 'Velg en varighet';

  @override
  String get durationDay => 'Dag';

  @override
  String get durationHour => 'Time';

  @override
  String get durationMinute => 'Minutt';

  @override
  String get durationSecond => 'Sekund';
}
