// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Romanian (`ro`).
class ShadcnLocalizationsRo extends ShadcnLocalizations {
  /// Creates the Romanian localizations.
  ShadcnLocalizationsRo([super.locale = 'ro']);

  @override
  String get formNotEmpty => 'Acest câmp nu poate fi gol';

  @override
  String get invalidValue => 'Valoare nevalidă';

  @override
  String get invalidEmail => 'Adresă de e-mail nevalidă';

  @override
  String get invalidURL => 'URL nevalid';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Trebuie să fie mai mic decât $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Trebuie să fie mai mare decât $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Trebuie să fie mai mic sau egal cu $valueString';
  }

  String get formPhoneNumberInvalid => 'Numărul de telefon nu este valid';

  String get formPhoneNumberEmpty => 'Numărul de telefon este obligatoriu';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Trebuie să fie mai mare sau egal cu $valueString';
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

    return 'Trebuie să fie între $minString și $maxString (inclusiv)';
  }

  String formEqualTo(String value) {
    return 'Trebuie să fie egal cu ${value}';
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

    return 'Trebuie să fie între $minString și $maxString (exclusiv)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Trebuie să aibă cel puțin ${value} caractere';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Trebuie să aibă cel mult ${value} caractere';
  }

  @override
  String get formPasswordDigits => 'Trebuie să conțină cel puțin o cifră';

  @override
  String get formPasswordLowercase => 'Trebuie să conțină cel puțin o literă mică';

  @override
  String get formPasswordUppercase => 'Trebuie să conțină cel puțin o literă mare';

  @override
  String get formPasswordSpecial => 'Trebuie să conțină cel puțin un caracter special';

  @override
  String get commandSearch => 'Tastați o comandă sau căutați...';

  @override
  String get commandEmpty => 'Niciun rezultat.';

  @override
  String get datePickerSelectYear => 'Selectați un an';

  @override
  String get abbreviatedMonday => 'Lu';

  @override
  String get abbreviatedTuesday => 'Ma';

  @override
  String get abbreviatedWednesday => 'Mi';

  @override
  String get abbreviatedThursday => 'Jo';

  @override
  String get abbreviatedFriday => 'Vi';

  @override
  String get abbreviatedSaturday => 'Sâ';

  @override
  String get abbreviatedSunday => 'Du';

  @override
  String get monthJanuary => 'Ianuarie';

  @override
  String get monthFebruary => 'Februarie';

  @override
  String get monthMarch => 'Martie';

  @override
  String get monthApril => 'Aprilie';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Iunie';

  @override
  String get monthJuly => 'Iulie';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'Septembrie';

  @override
  String get monthOctober => 'Octombrie';

  @override
  String get monthNovember => 'Noiembrie';

  @override
  String get monthDecember => 'Decembrie';

  @override
  String get abbreviatedJanuary => 'ian';

  @override
  String get abbreviatedFebruary => 'feb';

  @override
  String get abbreviatedMarch => 'mar';

  @override
  String get abbreviatedApril => 'apr';

  @override
  String get abbreviatedMay => 'mai';

  @override
  String get abbreviatedJune => 'iun';

  @override
  String get abbreviatedJuly => 'iul';

  @override
  String get abbreviatedAugust => 'aug';

  @override
  String get abbreviatedSeptember => 'sep';

  @override
  String get abbreviatedOctober => 'oct';

  @override
  String get abbreviatedNovember => 'noi';

  @override
  String get abbreviatedDecember => 'dec';

  @override
  String get buttonCancel => 'Anulare';

  @override
  String get buttonSave => 'Salvare';

  @override
  String get timeHour => 'Oră';

  @override
  String get timeMinute => 'Minut';

  @override
  String get timeSecond => 'Secundă';

  @override
  String get timeAM => 'a.m.';

  @override
  String get timePM => 'p.m.';

  @override
  String get colorRed => 'Roșu';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Albastru';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Nuanță';

  @override
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Decupare';

  @override
  String get menuCopy => 'Copiere';

  @override
  String get menuPaste => 'Lipire';

  @override
  String get menuSelectAll => 'Selectare totală';

  String get noSpellCheckReplacements => 'Nicio sugestie găsită';

  @override
  String get menuUndo => 'Anulare';

  @override
  String get menuRedo => 'Refacere';

  @override
  String get menuDelete => 'Ștergere';

  @override
  String get menuShare => 'Distribuire';

  @override
  String get menuSearchWeb => 'Căutare pe web';

  @override
  String get menuLiveTextInput => 'Text live';

  @override
  String get placeholderDatePicker => 'Selectați o dată';

  @override
  String get placeholderTimePicker => 'Selectați o oră';

  @override
  String get placeholderColorPicker => 'Selectați o culoare';

  @override
  String get buttonPrevious => 'Anterior';

  @override
  String get buttonNext => 'Următor';

  @override
  String get refreshTriggerPull => 'Trageți pentru a reîmprospăta';

  @override
  String get refreshTriggerRelease => 'Eliberați pentru a reîmprospăta';

  @override
  String get refreshTriggerRefreshing => 'Se reîmprospătează...';

  @override
  String get refreshTriggerComplete => 'Reîmprospătare finalizată';

  @override
  String get colorPickerTabRecent => 'Recente';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Mutare în sus';

  @override
  String get commandMoveDown => 'Mutare în jos';

  @override
  String get commandActivate => 'Selectare';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} din ${total} rând(uri) selectate.';
  }

  @override
  String get dataTableNext => 'Următor';

  @override
  String get dataTablePrevious => 'Anterior';

  @override
  String get dataTableColumns => 'Coloane';

  @override
  String get timeDaysAbbreviation => 'ZZ';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Selectați o durată';

  @override
  String get durationDay => 'Zi';

  @override
  String get durationHour => 'Oră';

  @override
  String get durationMinute => 'Minut';

  @override
  String get durationSecond => 'Secundă';
}
