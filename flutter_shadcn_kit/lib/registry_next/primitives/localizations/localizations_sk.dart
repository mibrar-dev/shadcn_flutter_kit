import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Slovak (`sk`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsSk extends ShadcnLocalizations {
  /// Creates the Slovak strings.
  const ShadcnLocalizationsSk([super.locale = const Locale('sk')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Toto pole nesmie byť prázdne';

  @override
  String get invalidValue => 'Neplatná hodnota';

  @override
  String get invalidEmail => 'Neplatný e-mail';

  @override
  String get invalidURL => 'Neplatná adresa URL';

  @override
  String formLessThan(Object? value) => 'Musí byť menšie ako ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Musí byť väčšie ako ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Musí byť menšie alebo rovné ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Telefónne číslo je neplatné';

  @override
  String get formPhoneNumberEmpty => 'Telefónne číslo je povinné';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Musí byť väčšie alebo rovné ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Musí byť medzi ${_number(min)} a ${_number(max)} (vrátane)';

  @override
  String formEqualTo(Object? value) => 'Musí sa rovnať ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Musí byť medzi ${_number(min)} a ${_number(max)} (bez krajných hodnôt)';

  @override
  String formLengthLessThan(int limit) => 'Musí mať aspoň $limit znakov';

  @override
  String formLengthGreaterThan(int limit) => 'Môže mať najviac $limit znakov';

  @override
  String get formPasswordDigits => 'Musí obsahovať aspoň jednu číslicu';

  @override
  String get formPasswordLowercase => 'Musí obsahovať aspoň jedno malé písmeno';

  @override
  String get formPasswordUppercase =>
      'Musí obsahovať aspoň jedno veľké písmeno';

  @override
  String get formPasswordSpecial => 'Musí obsahovať aspoň jeden špeciálny znak';

  @override
  String get commandSearch => 'Zadajte príkaz alebo hľadajte...';

  @override
  String get commandEmpty => 'Nenašli sa žiadne výsledky.';

  @override
  String get datePickerSelectYear => 'Vyberte rok';

  @override
  String get abbreviatedMonday => 'Po';

  @override
  String get abbreviatedTuesday => 'Ut';

  @override
  String get abbreviatedWednesday => 'St';

  @override
  String get abbreviatedThursday => 'Št';

  @override
  String get abbreviatedFriday => 'Pi';

  @override
  String get abbreviatedSaturday => 'So';

  @override
  String get abbreviatedSunday => 'Ne';

  @override
  String get monthJanuary => 'Január';

  @override
  String get monthFebruary => 'Február';

  @override
  String get monthMarch => 'Marec';

  @override
  String get monthApril => 'Apríl';

  @override
  String get monthMay => 'Máj';

  @override
  String get monthJune => 'Jún';

  @override
  String get monthJuly => 'Júl';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Október';

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
  String get abbreviatedMay => 'máj';

  @override
  String get abbreviatedJune => 'jún';

  @override
  String get abbreviatedJuly => 'júl';

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
  String get dialogDismiss => 'Odmietnuť';

  @override
  String get chipInputRemoveChip => 'Odstrániť';

  @override
  String get buttonCancel => 'Zrušiť';

  @override
  String get buttonSave => 'Uložiť';

  @override
  String get timeHour => 'Hodina';

  @override
  String get timeMinute => 'Minúta';

  @override
  String get timeSecond => 'Sekunda';

  @override
  String get timeAM => 'dop.';

  @override
  String get timePM => 'popol.';

  @override
  String get colorRed => 'Červená';

  @override
  String get colorGreen => 'Zelená';

  @override
  String get colorBlue => 'Modrá';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Odtieň';

  @override
  String get colorSaturation => 'Sýt';

  @override
  String get colorValue => 'Hod';

  @override
  String get colorLightness => 'Jas';

  @override
  String get menuCut => 'Vystrihnúť';

  @override
  String get menuCopy => 'Kopírovať';

  @override
  String get menuPaste => 'Prilepiť';

  @override
  String get menuSelectAll => 'Vybrať všetko';

  @override
  String get menuUndo => 'Späť';

  @override
  String get menuRedo => 'Znova';

  @override
  String get menuDelete => 'Odstrániť';

  @override
  String get menuShare => 'Zdieľať';

  @override
  String get menuSearchWeb => 'Hľadať na webe';

  @override
  String get menuLiveTextInput => 'Živý text';

  @override
  String get placeholderDatePicker => 'Vyberte dátum';

  @override
  String get placeholderTimePicker => 'Vyberte čas';

  @override
  String get placeholderColorPicker => 'Vyberte farbu';

  @override
  String get buttonPrevious => 'Predchádzajúce';

  @override
  String get buttonNext => 'Ďalšie';

  @override
  String get refreshTriggerPull => 'Potiahnutím obnovte';

  @override
  String get refreshTriggerRelease => 'Uvoľnením obnovte';

  @override
  String get refreshTriggerRefreshing => 'Obnovuje sa...';

  @override
  String get refreshTriggerComplete => 'Obnovenie dokončené';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Posunúť nahor';

  @override
  String get commandMoveDown => 'Posunúť nadol';

  @override
  String get commandActivate => 'Vybrať';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Vyberte trvanie';

  @override
  String get durationDay => 'Deň';

  @override
  String get durationHour => 'Hodina';

  @override
  String get durationMinute => 'Minúta';

  @override
  String get durationSecond => 'Sekunda';
}
