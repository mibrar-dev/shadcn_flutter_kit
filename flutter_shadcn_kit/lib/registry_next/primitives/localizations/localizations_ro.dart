import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Romanian (`ro`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsRo extends ShadcnLocalizations {
  /// Creates the Romanian strings.
  const ShadcnLocalizationsRo([super.locale = const Locale('ro')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Acest câmp nu poate fi gol';

  @override
  String get invalidValue => 'Valoare nevalidă';

  @override
  String get invalidEmail => 'Adresă de e-mail nevalidă';

  @override
  String get invalidURL => 'URL nevalid';

  @override
  String formLessThan(Object? value) =>
      'Trebuie să fie mai mic decât ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Trebuie să fie mai mare decât ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Trebuie să fie mai mic sau egal cu ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Numărul de telefon nu este valid';

  @override
  String get formPhoneNumberEmpty => 'Numărul de telefon este obligatoriu';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Trebuie să fie mai mare sau egal cu ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Trebuie să fie între ${_number(min)} și ${_number(max)} (inclusiv)';

  @override
  String formEqualTo(Object? value) =>
      'Trebuie să fie egal cu ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Trebuie să fie între ${_number(min)} și ${_number(max)} (exclusiv)';

  @override
  String formLengthLessThan(int limit) =>
      'Trebuie să aibă cel puțin $limit caractere';

  @override
  String formLengthGreaterThan(int limit) =>
      'Trebuie să aibă cel mult $limit caractere';

  @override
  String get formPasswordDigits => 'Trebuie să conțină cel puțin o cifră';

  @override
  String get formPasswordLowercase =>
      'Trebuie să conțină cel puțin o literă mică';

  @override
  String get formPasswordUppercase =>
      'Trebuie să conțină cel puțin o literă mare';

  @override
  String get formPasswordSpecial =>
      'Trebuie să conțină cel puțin un caracter special';

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
