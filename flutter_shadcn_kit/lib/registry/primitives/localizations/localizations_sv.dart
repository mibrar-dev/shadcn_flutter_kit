import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Swedish (`sv`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsSv extends ShadcnLocalizations {
  /// Creates the Swedish strings.
  const ShadcnLocalizationsSv([super.locale = const Locale('sv')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Det här fältet får inte vara tomt';

  @override
  String get invalidValue => 'Ogiltigt värde';

  @override
  String get invalidEmail => 'Ogiltig e-postadress';

  @override
  String get invalidURL => 'Ogiltig URL';

  @override
  String formLessThan(Object? value) =>
      'Måste vara mindre än ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Måste vara större än ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Måste vara mindre än eller lika med ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Telefonnumret är ogiltigt';

  @override
  String get formPhoneNumberEmpty => 'Telefonnummer krävs';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Måste vara större än eller lika med ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Måste vara mellan ${_number(min)} och ${_number(max)} (inklusive)';

  @override
  String formEqualTo(Object? value) => 'Måste vara lika med ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Måste vara mellan ${_number(min)} och ${_number(max)} (exklusive)';

  @override
  String formLengthLessThan(int limit) => 'Måste innehålla minst $limit tecken';

  @override
  String formLengthGreaterThan(int limit) =>
      'Får innehålla högst $limit tecken';

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
  String get dialogDismiss => 'Stäng';

  @override
  String get chipInputRemoveChip => 'Radera';

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
