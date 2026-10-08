import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Hungarian (`hu`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsHu extends ShadcnLocalizations {
  /// Creates the Hungarian strings.
  const ShadcnLocalizationsHu([super.locale = const Locale('hu')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Ez a mező nem lehet üres';

  @override
  String get invalidValue => 'Érvénytelen érték';

  @override
  String get invalidEmail => 'Érvénytelen e-mail cím';

  @override
  String get invalidURL => 'Érvénytelen URL';

  @override
  String formLessThan(Object? value) =>
      'Kisebbnek kell lennie, mint ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Nagyobbnak kell lennie, mint ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Legfeljebb ${_number(value)} lehet';

  @override
  String get formPhoneNumberInvalid => 'A telefonszám érvénytelen';

  @override
  String get formPhoneNumberEmpty => 'A telefonszám megadása kötelező';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Legalább ${_number(value)} kell legyen';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '${_number(min)} és ${_number(max)} között kell lennie (a végpontokkal együtt)';

  @override
  String formEqualTo(Object? value) =>
      'Egyenlőnek kell lennie ezzel: ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '${_number(min)} és ${_number(max)} között kell lennie (a végpontok nélkül)';

  @override
  String formLengthLessThan(int limit) =>
      'Legalább $limit karakter hosszú legyen';

  @override
  String formLengthGreaterThan(int limit) =>
      'Legfeljebb $limit karakter hosszú lehet';

  @override
  String get formPasswordDigits => 'Legalább egy számjegyet tartalmaznia kell';

  @override
  String get formPasswordLowercase => 'Legalább egy kisbetűt tartalmaznia kell';

  @override
  String get formPasswordUppercase =>
      'Legalább egy nagybetűt tartalmaznia kell';

  @override
  String get formPasswordSpecial =>
      'Legalább egy speciális karaktert tartalmaznia kell';

  @override
  String get commandSearch => 'Írjon be egy parancsot vagy keressen...';

  @override
  String get commandEmpty => 'Nincs találat.';

  @override
  String get datePickerSelectYear => 'Válasszon évet';

  @override
  String get abbreviatedMonday => 'H';

  @override
  String get abbreviatedTuesday => 'K';

  @override
  String get abbreviatedWednesday => 'Sze';

  @override
  String get abbreviatedThursday => 'Cs';

  @override
  String get abbreviatedFriday => 'P';

  @override
  String get abbreviatedSaturday => 'Szo';

  @override
  String get abbreviatedSunday => 'V';

  @override
  String get monthJanuary => 'Január';

  @override
  String get monthFebruary => 'Február';

  @override
  String get monthMarch => 'Március';

  @override
  String get monthApril => 'Április';

  @override
  String get monthMay => 'Május';

  @override
  String get monthJune => 'Június';

  @override
  String get monthJuly => 'Július';

  @override
  String get monthAugust => 'Augusztus';

  @override
  String get monthSeptember => 'Szeptember';

  @override
  String get monthOctober => 'Október';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get abbreviatedJanuary => 'jan';

  @override
  String get abbreviatedFebruary => 'febr';

  @override
  String get abbreviatedMarch => 'márc';

  @override
  String get abbreviatedApril => 'ápr';

  @override
  String get abbreviatedMay => 'máj';

  @override
  String get abbreviatedJune => 'jún';

  @override
  String get abbreviatedJuly => 'júl';

  @override
  String get abbreviatedAugust => 'aug';

  @override
  String get abbreviatedSeptember => 'szept';

  @override
  String get abbreviatedOctober => 'okt';

  @override
  String get abbreviatedNovember => 'nov';

  @override
  String get abbreviatedDecember => 'dec';

  @override
  String get dialogDismiss => 'Elvetés';

  @override
  String get chipInputRemoveChip => 'Törlés';

  @override
  String get buttonCancel => 'Mégse';

  @override
  String get buttonSave => 'Mentés';

  @override
  String get timeHour => 'Óra';

  @override
  String get timeMinute => 'Perc';

  @override
  String get timeSecond => 'Másodperc';

  @override
  String get timeAM => 'de.';

  @override
  String get timePM => 'du.';

  @override
  String get colorRed => 'Piros';

  @override
  String get colorGreen => 'Zöld';

  @override
  String get colorBlue => 'Kék';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Színárnyalat';

  @override
  String get colorSaturation => 'Telít';

  @override
  String get colorValue => 'Érték';

  @override
  String get colorLightness => 'Vil';

  @override
  String get menuCut => 'Kivágás';

  @override
  String get menuCopy => 'Másolás';

  @override
  String get menuPaste => 'Beillesztés';

  @override
  String get menuSelectAll => 'Összes kijelölése';

  @override
  String get menuUndo => 'Visszavonás';

  @override
  String get menuRedo => 'Újra';

  @override
  String get menuDelete => 'Törlés';

  @override
  String get menuShare => 'Megosztás';

  @override
  String get menuSearchWeb => 'Keresés a weben';

  @override
  String get menuLiveTextInput => 'Élő szöveg';

  @override
  String get placeholderDatePicker => 'Válasszon dátumot';

  @override
  String get placeholderTimePicker => 'Válasszon időpontot';

  @override
  String get placeholderColorPicker => 'Válasszon színt';

  @override
  String get buttonPrevious => 'Előző';

  @override
  String get buttonNext => 'Következő';

  @override
  String get refreshTriggerPull => 'Húzza le a frissítéshez';

  @override
  String get refreshTriggerRelease => 'Engedje el a frissítéshez';

  @override
  String get refreshTriggerRefreshing => 'Frissítés...';

  @override
  String get refreshTriggerComplete => 'A frissítés befejeződött';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Mozgatás felfelé';

  @override
  String get commandMoveDown => 'Mozgatás lefelé';

  @override
  String get commandActivate => 'Kiválasztás';

  @override
  String get timeDaysAbbreviation => 'NN';

  @override
  String get timeHoursAbbreviation => 'ÓÓ';

  @override
  String get timeMinutesAbbreviation => 'PP';

  @override
  String get timeSecondsAbbreviation => 'MM';

  @override
  String get placeholderDurationPicker => 'Válasszon időtartamot';

  @override
  String get durationDay => 'Nap';

  @override
  String get durationHour => 'Óra';

  @override
  String get durationMinute => 'Perc';

  @override
  String get durationSecond => 'Másodperc';
}
