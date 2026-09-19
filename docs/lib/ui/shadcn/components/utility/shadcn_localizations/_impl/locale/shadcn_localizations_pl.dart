// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Polish (`pl`).
class ShadcnLocalizationsPl extends ShadcnLocalizations {
  /// Creates the Polish localizations.
  ShadcnLocalizationsPl([super.locale = 'pl']);

  @override
  String get formNotEmpty => 'To pole nie może być puste';

  @override
  String get invalidValue => 'Nieprawidłowa wartość';

  @override
  String get invalidEmail => 'Nieprawidłowy adres e-mail';

  @override
  String get invalidURL => 'Nieprawidłowy adres URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musi być mniejsze niż $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musi być większe niż $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musi być mniejsze lub równe $valueString';
  }

  String get formPhoneNumberInvalid => 'Nieprawidłowy numer telefonu';

  String get formPhoneNumberEmpty => 'Numer telefonu jest wymagany';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Musi być większe lub równe $valueString';
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

    return 'Musi zawierać się między $minString a $maxString (włącznie)';
  }

  String formEqualTo(String value) {
    return 'Musi być równe ${value}';
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

    return 'Musi zawierać się między $minString a $maxString (wyłącznie)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Musi mieć co najmniej ${value} znaków';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Może mieć najwyżej ${value} znaków';
  }

  @override
  String get formPasswordDigits => 'Musi zawierać co najmniej jedną cyfrę';

  @override
  String get formPasswordLowercase => 'Musi zawierać co najmniej jedną małą literę';

  @override
  String get formPasswordUppercase => 'Musi zawierać co najmniej jedną wielką literę';

  @override
  String get formPasswordSpecial => 'Musi zawierać co najmniej jeden znak specjalny';

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

  String get noSpellCheckReplacements => 'Nie znaleziono propozycji';

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
  String get colorPickerTabRecent => 'Ostatnie';

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
  String dataTableSelectedRows(int count, int total) {
    return 'Zaznaczono ${count} z ${total} wierszy.';
  }

  @override
  String get dataTableNext => 'Dalej';

  @override
  String get dataTablePrevious => 'Wstecz';

  @override
  String get dataTableColumns => 'Kolumny';

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
