import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Polish (`pl`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsPl extends ShadcnLocalizations {
  /// Creates the Polish strings.
  const ShadcnLocalizationsPl([super.locale = const Locale('pl')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'To pole nie może być puste';

  @override
  String get invalidValue => 'Nieprawidłowa wartość';

  @override
  String get invalidEmail => 'Nieprawidłowy adres e-mail';

  @override
  String get invalidURL => 'Nieprawidłowy adres URL';

  @override
  String formLessThan(Object? value) =>
      'Musi być mniejsze niż ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Musi być większe niż ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Musi być mniejsze lub równe ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Nieprawidłowy numer telefonu';

  @override
  String get formPhoneNumberEmpty => 'Numer telefonu jest wymagany';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Musi być większe lub równe ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Musi zawierać się między ${_number(min)} a ${_number(max)} (włącznie)';

  @override
  String formEqualTo(Object? value) => 'Musi być równe ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Musi zawierać się między ${_number(min)} a ${_number(max)} (wyłącznie)';

  @override
  String formLengthLessThan(int limit) => 'Musi mieć co najmniej $limit znaków';

  @override
  String formLengthGreaterThan(int limit) => 'Może mieć najwyżej $limit znaków';

  @override
  String get formPasswordDigits => 'Musi zawierać co najmniej jedną cyfrę';

  @override
  String get formPasswordLowercase =>
      'Musi zawierać co najmniej jedną małą literę';

  @override
  String get formPasswordUppercase =>
      'Musi zawierać co najmniej jedną wielką literę';

  @override
  String get formPasswordSpecial =>
      'Musi zawierać co najmniej jeden znak specjalny';

  @override
  String get commandSearch => 'Wpisz polecenie lub wyszukaj...';

  @override
  String get commandEmpty => 'Brak wyników.';

  @override
  String get datePickerSelectYear => 'Wybierz rok';

  @override
  String get abbreviatedMonday => 'Pn';

  @override
  String get abbreviatedTuesday => 'Wt';

  @override
  String get abbreviatedWednesday => 'Śr';

  @override
  String get abbreviatedThursday => 'Cz';

  @override
  String get abbreviatedFriday => 'Pt';

  @override
  String get abbreviatedSaturday => 'So';

  @override
  String get abbreviatedSunday => 'Nd';

  @override
  String get monthJanuary => 'Styczeń';

  @override
  String get monthFebruary => 'Luty';

  @override
  String get monthMarch => 'Marzec';

  @override
  String get monthApril => 'Kwiecień';

  @override
  String get monthMay => 'Maj';

  @override
  String get monthJune => 'Czerwiec';

  @override
  String get monthJuly => 'Lipiec';

  @override
  String get monthAugust => 'Sierpień';

  @override
  String get monthSeptember => 'Wrzesień';

  @override
  String get monthOctober => 'Październik';

  @override
  String get monthNovember => 'Listopad';

  @override
  String get monthDecember => 'Grudzień';

  @override
  String get abbreviatedJanuary => 'sty';

  @override
  String get abbreviatedFebruary => 'lut';

  @override
  String get abbreviatedMarch => 'mar';

  @override
  String get abbreviatedApril => 'kwi';

  @override
  String get abbreviatedMay => 'maj';

  @override
  String get abbreviatedJune => 'cze';

  @override
  String get abbreviatedJuly => 'lip';

  @override
  String get abbreviatedAugust => 'sie';

  @override
  String get abbreviatedSeptember => 'wrz';

  @override
  String get abbreviatedOctober => 'paź';

  @override
  String get abbreviatedNovember => 'lis';

  @override
  String get abbreviatedDecember => 'gru';

  @override
  String get buttonCancel => 'Anuluj';

  @override
  String get buttonSave => 'Zapisz';

  @override
  String get timeHour => 'Godzina';

  @override
  String get timeMinute => 'Minuta';

  @override
  String get timeSecond => 'Sekunda';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Czerwony';

  @override
  String get colorGreen => 'Zielony';

  @override
  String get colorBlue => 'Niebieski';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Odcień';

  @override
  String get colorSaturation => 'Nas';

  @override
  String get colorValue => 'Wart';

  @override
  String get colorLightness => 'Jasn';

  @override
  String get menuCut => 'Wytnij';

  @override
  String get menuCopy => 'Kopiuj';

  @override
  String get menuPaste => 'Wklej';

  @override
  String get menuSelectAll => 'Zaznacz wszystko';

  @override
  String get menuUndo => 'Cofnij';

  @override
  String get menuRedo => 'Ponów';

  @override
  String get menuDelete => 'Usuń';

  @override
  String get menuShare => 'Udostępnij';

  @override
  String get menuSearchWeb => 'Szukaj w internecie';

  @override
  String get menuLiveTextInput => 'Tekst na żywo';

  @override
  String get placeholderDatePicker => 'Wybierz datę';

  @override
  String get placeholderTimePicker => 'Wybierz godzinę';

  @override
  String get placeholderColorPicker => 'Wybierz kolor';

  @override
  String get buttonPrevious => 'Wstecz';

  @override
  String get buttonNext => 'Dalej';

  @override
  String get refreshTriggerPull => 'Pociągnij, aby odświeżyć';

  @override
  String get refreshTriggerRelease => 'Puść, aby odświeżyć';

  @override
  String get refreshTriggerRefreshing => 'Odświeżanie...';

  @override
  String get refreshTriggerComplete => 'Odświeżanie zakończone';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Przenieś w górę';

  @override
  String get commandMoveDown => 'Przenieś w dół';

  @override
  String get commandActivate => 'Wybierz';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'GG';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Wybierz czas trwania';

  @override
  String get durationDay => 'Dzień';

  @override
  String get durationHour => 'Godzina';

  @override
  String get durationMinute => 'Minuta';

  @override
  String get durationSecond => 'Sekunda';
}
