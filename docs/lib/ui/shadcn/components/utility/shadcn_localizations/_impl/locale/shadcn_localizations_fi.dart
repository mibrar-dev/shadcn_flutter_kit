// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Finnish (`fi`).
class ShadcnLocalizationsFi extends ShadcnLocalizations {
  /// Creates the Finnish localizations.
  ShadcnLocalizationsFi([super.locale = 'fi']);

  @override
  String get formNotEmpty => 'Tämä kenttä ei voi olla tyhjä';

  @override
  String get invalidValue => 'Virheellinen arvo';

  @override
  String get invalidEmail => 'Virheellinen sähköpostiosoite';

  @override
  String get invalidURL => 'Virheellinen URL-osoite';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Täytyy olla pienempi kuin $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Täytyy olla suurempi kuin $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Täytyy olla enintään $valueString';
  }

  String get formPhoneNumberInvalid => 'Puhelinnumero on virheellinen';

  String get formPhoneNumberEmpty => 'Puhelinnumero vaaditaan';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Täytyy olla vähintään $valueString';
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

    return 'Täytyy olla välillä $minString–$maxString (mukaan lukien)';
  }

  String formEqualTo(String value) {
    return 'Täytyy olla yhtä suuri kuin ${value}';
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

    return 'Täytyy olla välillä $minString–$maxString (pois lukien)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Täytyy olla vähintään ${value} merkkiä';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Saa olla enintään ${value} merkkiä';
  }

  @override
  String get formPasswordDigits => 'Täytyy sisältää vähintään yksi numero';

  @override
  String get formPasswordLowercase => 'Täytyy sisältää vähintään yksi pieni kirjain';

  @override
  String get formPasswordUppercase => 'Täytyy sisältää vähintään yksi iso kirjain';

  @override
  String get formPasswordSpecial => 'Täytyy sisältää vähintään yksi erikoismerkki';

  @override
  String get commandSearch => 'Kirjoita komento tai hae...';

  @override
  String get commandEmpty => 'Ei tuloksia.';

  @override
  String get datePickerSelectYear => 'Valitse vuosi';

  @override
  String get abbreviatedMonday => 'Ma';

  @override
  String get abbreviatedTuesday => 'Ti';

  @override
  String get abbreviatedWednesday => 'Ke';

  @override
  String get abbreviatedThursday => 'To';

  @override
  String get abbreviatedFriday => 'Pe';

  @override
  String get abbreviatedSaturday => 'La';

  @override
  String get abbreviatedSunday => 'Su';

  @override
  String get monthJanuary => 'Tammikuu';

  @override
  String get monthFebruary => 'Helmikuu';

  @override
  String get monthMarch => 'Maaliskuu';

  @override
  String get monthApril => 'Huhtikuu';

  @override
  String get monthMay => 'Toukokuu';

  @override
  String get monthJune => 'Kesäkuu';

  @override
  String get monthJuly => 'Heinäkuu';

  @override
  String get monthAugust => 'Elokuu';

  @override
  String get monthSeptember => 'Syyskuu';

  @override
  String get monthOctober => 'Lokakuu';

  @override
  String get monthNovember => 'Marraskuu';

  @override
  String get monthDecember => 'Joulukuu';

  @override
  String get abbreviatedJanuary => 'tammi';

  @override
  String get abbreviatedFebruary => 'helmi';

  @override
  String get abbreviatedMarch => 'maalis';

  @override
  String get abbreviatedApril => 'huhti';

  @override
  String get abbreviatedMay => 'touko';

  @override
  String get abbreviatedJune => 'kesä';

  @override
  String get abbreviatedJuly => 'heinä';

  @override
  String get abbreviatedAugust => 'elo';

  @override
  String get abbreviatedSeptember => 'syys';

  @override
  String get abbreviatedOctober => 'loka';

  @override
  String get abbreviatedNovember => 'marras';

  @override
  String get abbreviatedDecember => 'joulu';

  @override
  String get buttonCancel => 'Peruuta';

  @override
  String get buttonSave => 'Tallenna';

  @override
  String get timeHour => 'Tunti';

  @override
  String get timeMinute => 'Minuutti';

  @override
  String get timeSecond => 'Sekunti';

  @override
  String get timeAM => 'ap.';

  @override
  String get timePM => 'ip.';

  @override
  String get colorRed => 'Punainen';

  @override
  String get colorGreen => 'Vihreä';

  @override
  String get colorBlue => 'Sininen';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Sävy';

  @override
  String get colorSaturation => 'Kyll';

  @override
  String get colorValue => 'Arvo';

  @override
  String get colorLightness => 'Vaal';

  @override
  String get menuCut => 'Leikkaa';

  @override
  String get menuCopy => 'Kopioi';

  @override
  String get menuPaste => 'Liitä';

  @override
  String get menuSelectAll => 'Valitse kaikki';

  String get noSpellCheckReplacements => 'Ehdotuksia ei löytynyt';

  @override
  String get menuUndo => 'Kumoa';

  @override
  String get menuRedo => 'Tee uudelleen';

  @override
  String get menuDelete => 'Poista';

  @override
  String get menuShare => 'Jaa';

  @override
  String get menuSearchWeb => 'Hae verkosta';

  @override
  String get menuLiveTextInput => 'Live-teksti';

  @override
  String get placeholderDatePicker => 'Valitse päivämäärä';

  @override
  String get placeholderTimePicker => 'Valitse kellonaika';

  @override
  String get placeholderColorPicker => 'Valitse väri';

  @override
  String get buttonPrevious => 'Edellinen';

  @override
  String get buttonNext => 'Seuraava';

  @override
  String get refreshTriggerPull => 'Päivitä vetämällä';

  @override
  String get refreshTriggerRelease => 'Päivitä vapauttamalla';

  @override
  String get refreshTriggerRefreshing => 'Päivitetään...';

  @override
  String get refreshTriggerComplete => 'Päivitys valmis';

  @override
  String get colorPickerTabRecent => 'Viimeisimmät';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Siirrä ylös';

  @override
  String get commandMoveDown => 'Siirrä alas';

  @override
  String get commandActivate => 'Valitse';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count}/${total} riviä valittu.';
  }

  @override
  String get dataTableNext => 'Seuraava';

  @override
  String get dataTablePrevious => 'Edellinen';

  @override
  String get dataTableColumns => 'Sarakkeet';

  @override
  String get timeDaysAbbreviation => 'PP';

  @override
  String get timeHoursAbbreviation => 'TT';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Valitse kesto';

  @override
  String get durationDay => 'Päivä';

  @override
  String get durationHour => 'Tunti';

  @override
  String get durationMinute => 'Minuutti';

  @override
  String get durationSecond => 'Sekunti';
}
