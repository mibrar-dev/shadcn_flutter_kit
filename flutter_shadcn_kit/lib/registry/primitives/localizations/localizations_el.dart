import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Greek (`el`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsEl extends ShadcnLocalizations {
  /// Creates the Greek strings.
  const ShadcnLocalizationsEl([super.locale = const Locale('el')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Αυτό το πεδίο δεν μπορεί να είναι κενό';

  @override
  String get invalidValue => 'Μη έγκυρη τιμή';

  @override
  String get invalidEmail => 'Μη έγκυρο email';

  @override
  String get invalidURL => 'Μη έγκυρη διεύθυνση URL';

  @override
  String formLessThan(Object? value) =>
      'Πρέπει να είναι μικρότερο από ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Πρέπει να είναι μεγαλύτερο από ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Πρέπει να είναι μικρότερο ή ίσο με ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Ο αριθμός τηλεφώνου δεν είναι έγκυρος';

  @override
  String get formPhoneNumberEmpty => 'Απαιτείται αριθμός τηλεφώνου';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Πρέπει να είναι μεγαλύτερο ή ίσο με ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Πρέπει να είναι μεταξύ ${_number(min)} και ${_number(max)} (συμπεριλαμβανομένων)';

  @override
  String formEqualTo(Object? value) => 'Πρέπει να ισούται με ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Πρέπει να είναι μεταξύ ${_number(min)} και ${_number(max)} (μη συμπεριλαμβανομένων)';

  @override
  String formLengthLessThan(int limit) =>
      'Πρέπει να έχει τουλάχιστον $limit χαρακτήρες';

  @override
  String formLengthGreaterThan(int limit) =>
      'Πρέπει να έχει το πολύ $limit χαρακτήρες';

  @override
  String get formPasswordDigits => 'Πρέπει να περιέχει τουλάχιστον ένα ψηφίο';

  @override
  String get formPasswordLowercase =>
      'Πρέπει να περιέχει τουλάχιστον ένα πεζό γράμμα';

  @override
  String get formPasswordUppercase =>
      'Πρέπει να περιέχει τουλάχιστον ένα κεφαλαίο γράμμα';

  @override
  String get formPasswordSpecial =>
      'Πρέπει να περιέχει τουλάχιστον έναν ειδικό χαρακτήρα';

  @override
  String get commandSearch => 'Πληκτρολογήστε μια εντολή ή αναζητήστε...';

  @override
  String get commandEmpty => 'Δεν βρέθηκαν αποτελέσματα.';

  @override
  String get datePickerSelectYear => 'Επιλέξτε έτος';

  @override
  String get abbreviatedMonday => 'Δε';

  @override
  String get abbreviatedTuesday => 'Τρ';

  @override
  String get abbreviatedWednesday => 'Τε';

  @override
  String get abbreviatedThursday => 'Πε';

  @override
  String get abbreviatedFriday => 'Πα';

  @override
  String get abbreviatedSaturday => 'Σα';

  @override
  String get abbreviatedSunday => 'Κυ';

  @override
  String get monthJanuary => 'Ιανουάριος';

  @override
  String get monthFebruary => 'Φεβρουάριος';

  @override
  String get monthMarch => 'Μάρτιος';

  @override
  String get monthApril => 'Απρίλιος';

  @override
  String get monthMay => 'Μάιος';

  @override
  String get monthJune => 'Ιούνιος';

  @override
  String get monthJuly => 'Ιούλιος';

  @override
  String get monthAugust => 'Αύγουστος';

  @override
  String get monthSeptember => 'Σεπτέμβριος';

  @override
  String get monthOctober => 'Οκτώβριος';

  @override
  String get monthNovember => 'Νοέμβριος';

  @override
  String get monthDecember => 'Δεκέμβριος';

  @override
  String get abbreviatedJanuary => 'Ιαν';

  @override
  String get abbreviatedFebruary => 'Φεβ';

  @override
  String get abbreviatedMarch => 'Μάρ';

  @override
  String get abbreviatedApril => 'Απρ';

  @override
  String get abbreviatedMay => 'Μάι';

  @override
  String get abbreviatedJune => 'Ιούν';

  @override
  String get abbreviatedJuly => 'Ιούλ';

  @override
  String get abbreviatedAugust => 'Αύγ';

  @override
  String get abbreviatedSeptember => 'Σεπ';

  @override
  String get abbreviatedOctober => 'Οκτ';

  @override
  String get abbreviatedNovember => 'Νοέ';

  @override
  String get abbreviatedDecember => 'Δεκ';

  @override
  String get dialogDismiss => 'Παράβλεψη';

  @override
  String get chipInputRemoveChip => 'Διαγραφή';

  @override
  String get buttonCancel => 'Άκυρο';

  @override
  String get buttonSave => 'Αποθήκευση';

  @override
  String get timeHour => 'Ώρα';

  @override
  String get timeMinute => 'Λεπτό';

  @override
  String get timeSecond => 'Δευτερόλεπτο';

  @override
  String get timeAM => 'π.μ.';

  @override
  String get timePM => 'μ.μ.';

  @override
  String get colorRed => 'Κόκκινο';

  @override
  String get colorGreen => 'Πράσινο';

  @override
  String get colorBlue => 'Μπλε';

  @override
  String get colorAlpha => 'Άλφα';

  @override
  String get colorHue => 'Απόχρωση';

  @override
  String get colorSaturation => 'Κορ';

  @override
  String get colorValue => 'Τιμή';

  @override
  String get colorLightness => 'Φωτ';

  @override
  String get menuCut => 'Αποκοπή';

  @override
  String get menuCopy => 'Αντιγραφή';

  @override
  String get menuPaste => 'Επικόλληση';

  @override
  String get menuSelectAll => 'Επιλογή όλων';

  @override
  String get menuUndo => 'Αναίρεση';

  @override
  String get menuRedo => 'Επανάληψη';

  @override
  String get menuDelete => 'Διαγραφή';

  @override
  String get menuShare => 'Κοινοποίηση';

  @override
  String get menuSearchWeb => 'Αναζήτηση στον ιστό';

  @override
  String get menuLiveTextInput => 'Ζωντανό κείμενο';

  @override
  String get placeholderDatePicker => 'Επιλέξτε ημερομηνία';

  @override
  String get placeholderTimePicker => 'Επιλέξτε ώρα';

  @override
  String get placeholderColorPicker => 'Επιλέξτε χρώμα';

  @override
  String get buttonPrevious => 'Προηγούμενο';

  @override
  String get buttonNext => 'Επόμενο';

  @override
  String get refreshTriggerPull => 'Τραβήξτε για ανανέωση';

  @override
  String get refreshTriggerRelease => 'Αφήστε για ανανέωση';

  @override
  String get refreshTriggerRefreshing => 'Ανανέωση...';

  @override
  String get refreshTriggerComplete => 'Η ανανέωση ολοκληρώθηκε';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Μετακίνηση επάνω';

  @override
  String get commandMoveDown => 'Μετακίνηση κάτω';

  @override
  String get commandActivate => 'Επιλογή';

  @override
  String get timeDaysAbbreviation => 'ΗΗ';

  @override
  String get timeHoursAbbreviation => 'ΩΩ';

  @override
  String get timeMinutesAbbreviation => 'ΛΛ';

  @override
  String get timeSecondsAbbreviation => 'ΔΔ';

  @override
  String get placeholderDurationPicker => 'Επιλέξτε διάρκεια';

  @override
  String get durationDay => 'Ημέρα';

  @override
  String get durationHour => 'Ώρα';

  @override
  String get durationMinute => 'Λεπτό';

  @override
  String get durationSecond => 'Δευτερόλεπτο';
}
