import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Czech (`cs`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsCs extends ShadcnLocalizations {
  /// Creates the Czech strings.
  const ShadcnLocalizationsCs([super.locale = const Locale('cs')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Toto pole nesmí být prázdné';

  @override
  String get invalidValue => 'Neplatná hodnota';

  @override
  String get invalidEmail => 'Neplatný e-mail';

  @override
  String get invalidURL => 'Neplatná adresa URL';

  @override
  String formLessThan(Object? value) => 'Musí být menší než ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Musí být větší než ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Musí být menší nebo rovno ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Telefonní číslo je neplatné';

  @override
  String get formPhoneNumberEmpty => 'Telefonní číslo je povinné';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Musí být větší nebo rovno ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Musí být mezi ${_number(min)} a ${_number(max)} (včetně)';

  @override
  String formEqualTo(Object? value) => 'Musí se rovnat ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Musí být mezi ${_number(min)} a ${_number(max)} (bez krajních hodnot)';

  @override
  String formLengthLessThan(int limit) => 'Musí mít alespoň $limit znaků';

  @override
  String formLengthGreaterThan(int limit) => 'Může mít nejvýše $limit znaků';

  @override
  String get formPasswordDigits => 'Musí obsahovat alespoň jednu číslici';

  @override
  String get formPasswordLowercase =>
      'Musí obsahovat alespoň jedno malé písmeno';

  @override
  String get formPasswordUppercase =>
      'Musí obsahovat alespoň jedno velké písmeno';

  @override
  String get formPasswordSpecial =>
      'Musí obsahovat alespoň jeden speciální znak';

  @override
  String get commandSearch => 'Zadejte příkaz nebo hledejte...';

  @override
  String get commandEmpty => 'Nenalezeny žádné výsledky.';

  @override
  String get datePickerSelectYear => 'Vyberte rok';

  @override
  String get abbreviatedMonday => 'Po';

  @override
  String get abbreviatedTuesday => 'Út';

  @override
  String get abbreviatedWednesday => 'St';

  @override
  String get abbreviatedThursday => 'Čt';

  @override
  String get abbreviatedFriday => 'Pá';

  @override
  String get abbreviatedSaturday => 'So';

  @override
  String get abbreviatedSunday => 'Ne';

  @override
  String get monthJanuary => 'Leden';

  @override
  String get monthFebruary => 'Únor';

  @override
  String get monthMarch => 'Březen';

  @override
  String get monthApril => 'Duben';

  @override
  String get monthMay => 'Květen';

  @override
  String get monthJune => 'Červen';

  @override
  String get monthJuly => 'Červenec';

  @override
  String get monthAugust => 'Srpen';

  @override
  String get monthSeptember => 'Září';

  @override
  String get monthOctober => 'Říjen';

  @override
  String get monthNovember => 'Listopad';

  @override
  String get monthDecember => 'Prosinec';

  @override
  String get abbreviatedJanuary => 'led';

  @override
  String get abbreviatedFebruary => 'úno';

  @override
  String get abbreviatedMarch => 'bře';

  @override
  String get abbreviatedApril => 'dub';

  @override
  String get abbreviatedMay => 'kvě';

  @override
  String get abbreviatedJune => 'čvn';

  @override
  String get abbreviatedJuly => 'čvc';

  @override
  String get abbreviatedAugust => 'srp';

  @override
  String get abbreviatedSeptember => 'zář';

  @override
  String get abbreviatedOctober => 'říj';

  @override
  String get abbreviatedNovember => 'lis';

  @override
  String get abbreviatedDecember => 'pro';

  @override
  String get dialogDismiss => 'Zavřít';

  @override
  String get chipInputRemoveChip => 'Smazat';

  @override
  String get buttonCancel => 'Zrušit';

  @override
  String get buttonSave => 'Uložit';

  @override
  String get timeHour => 'Hodina';

  @override
  String get timeMinute => 'Minuta';

  @override
  String get timeSecond => 'Sekunda';

  @override
  String get timeAM => 'dop.';

  @override
  String get timePM => 'odp.';

  @override
  String get colorRed => 'Červená';

  @override
  String get colorGreen => 'Zelená';

  @override
  String get colorBlue => 'Modrá';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Odstín';

  @override
  String get colorSaturation => 'Syt';

  @override
  String get colorValue => 'Hod';

  @override
  String get colorLightness => 'Jas';

  @override
  String get menuCut => 'Vyjmout';

  @override
  String get menuCopy => 'Kopírovat';

  @override
  String get menuPaste => 'Vložit';

  @override
  String get menuSelectAll => 'Vybrat vše';

  @override
  String get menuUndo => 'Zpět';

  @override
  String get menuRedo => 'Znovu';

  @override
  String get menuDelete => 'Smazat';

  @override
  String get menuShare => 'Sdílet';

  @override
  String get menuSearchWeb => 'Hledat na webu';

  @override
  String get menuLiveTextInput => 'Živý text';

  @override
  String get placeholderDatePicker => 'Vyberte datum';

  @override
  String get placeholderTimePicker => 'Vyberte čas';

  @override
  String get placeholderColorPicker => 'Vyberte barvu';

  @override
  String get buttonPrevious => 'Předchozí';

  @override
  String get buttonNext => 'Další';

  @override
  String get refreshTriggerPull => 'Přetažením obnovte';

  @override
  String get refreshTriggerRelease => 'Uvolněním obnovte';

  @override
  String get refreshTriggerRefreshing => 'Obnovování...';

  @override
  String get refreshTriggerComplete => 'Obnovení dokončeno';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Přesunout nahoru';

  @override
  String get commandMoveDown => 'Přesunout dolů';

  @override
  String get commandActivate => 'Vybrat';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Vyberte dobu trvání';

  @override
  String get durationDay => 'Den';

  @override
  String get durationHour => 'Hodina';

  @override
  String get durationMinute => 'Minuta';

  @override
  String get durationSecond => 'Sekunda';
}
