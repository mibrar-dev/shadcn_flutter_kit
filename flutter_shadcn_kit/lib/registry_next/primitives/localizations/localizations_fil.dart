import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Filipino (`fil`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsFil extends ShadcnLocalizations {
  /// Creates the Filipino strings.
  const ShadcnLocalizationsFil([super.locale = const Locale('fil')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Hindi puwedeng walang laman ang field na ito';

  @override
  String get invalidValue => 'Di-wastong halaga';

  @override
  String get invalidEmail => 'Di-wastong email';

  @override
  String get invalidURL => 'Di-wastong URL';

  @override
  String formLessThan(Object? value) => 'Dapat mas mababa sa ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Dapat mas mataas sa ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Dapat mas mababa o katumbas ng ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Di-wasto ang numero ng telepono';

  @override
  String get formPhoneNumberEmpty => 'Kailangan ang numero ng telepono';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Dapat mas mataas o katumbas ng ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Dapat nasa pagitan ng ${_number(min)} at ${_number(max)} (kasama)';

  @override
  String formEqualTo(Object? value) => 'Dapat katumbas ng ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Dapat nasa pagitan ng ${_number(min)} at ${_number(max)} (hindi kasama)';

  @override
  String formLengthLessThan(int limit) =>
      'Dapat hindi bababa sa $limit character';

  @override
  String formLengthGreaterThan(int limit) =>
      'Dapat hindi hihigit sa $limit character';

  @override
  String get formPasswordDigits => 'Dapat may kahit isang numero';

  @override
  String get formPasswordLowercase => 'Dapat may kahit isang maliit na letra';

  @override
  String get formPasswordUppercase => 'Dapat may kahit isang malaking letra';

  @override
  String get formPasswordSpecial =>
      'Dapat may kahit isang espesyal na character';

  @override
  String get commandSearch => 'Mag-type ng command o maghanap...';

  @override
  String get commandEmpty => 'Walang nahanap na resulta.';

  @override
  String get datePickerSelectYear => 'Pumili ng taon';

  @override
  String get abbreviatedMonday => 'Lun';

  @override
  String get abbreviatedTuesday => 'Mar';

  @override
  String get abbreviatedWednesday => 'Miy';

  @override
  String get abbreviatedThursday => 'Huw';

  @override
  String get abbreviatedFriday => 'Biy';

  @override
  String get abbreviatedSaturday => 'Sab';

  @override
  String get abbreviatedSunday => 'Lin';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Pebrero';

  @override
  String get monthMarch => 'Marso';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Hunyo';

  @override
  String get monthJuly => 'Hulyo';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Setyembre';

  @override
  String get monthOctober => 'Oktubre';

  @override
  String get monthNovember => 'Nobyembre';

  @override
  String get monthDecember => 'Disyembre';

  @override
  String get abbreviatedJanuary => 'Ene';

  @override
  String get abbreviatedFebruary => 'Peb';

  @override
  String get abbreviatedMarch => 'Mar';

  @override
  String get abbreviatedApril => 'Abr';

  @override
  String get abbreviatedMay => 'May';

  @override
  String get abbreviatedJune => 'Hun';

  @override
  String get abbreviatedJuly => 'Hul';

  @override
  String get abbreviatedAugust => 'Ago';

  @override
  String get abbreviatedSeptember => 'Set';

  @override
  String get abbreviatedOctober => 'Okt';

  @override
  String get abbreviatedNovember => 'Nob';

  @override
  String get abbreviatedDecember => 'Dis';

  @override
  String get buttonCancel => 'Kanselahin';

  @override
  String get buttonSave => 'I-save';

  @override
  String get timeHour => 'Oras';

  @override
  String get timeMinute => 'Minuto';

  @override
  String get timeSecond => 'Segundo';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Pula';

  @override
  String get colorGreen => 'Berde';

  @override
  String get colorBlue => 'Asul';

  @override
  String get colorAlpha => 'Alpha';

  @override
  String get colorHue => 'Hue';

  @override
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'I-cut';

  @override
  String get menuCopy => 'Kopyahin';

  @override
  String get menuPaste => 'I-paste';

  @override
  String get menuSelectAll => 'Piliin Lahat';

  @override
  String get menuUndo => 'I-undo';

  @override
  String get menuRedo => 'I-redo';

  @override
  String get menuDelete => 'I-delete';

  @override
  String get menuShare => 'Ibahagi';

  @override
  String get menuSearchWeb => 'Maghanap sa Web';

  @override
  String get menuLiveTextInput => 'Live na Teksto';

  @override
  String get placeholderDatePicker => 'Pumili ng petsa';

  @override
  String get placeholderTimePicker => 'Pumili ng oras';

  @override
  String get placeholderColorPicker => 'Pumili ng kulay';

  @override
  String get buttonPrevious => 'Nakaraan';

  @override
  String get buttonNext => 'Susunod';

  @override
  String get refreshTriggerPull => 'Hilahin para mag-refresh';

  @override
  String get refreshTriggerRelease => 'Bitawan para mag-refresh';

  @override
  String get refreshTriggerRefreshing => 'Nagre-refresh...';

  @override
  String get refreshTriggerComplete => 'Tapos na ang pag-refresh';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Ilipat pataas';

  @override
  String get commandMoveDown => 'Ilipat pababa';

  @override
  String get commandActivate => 'Piliin';

  @override
  String get timeDaysAbbreviation => 'AA';

  @override
  String get timeHoursAbbreviation => 'OO';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Pumili ng tagal';

  @override
  String get durationDay => 'Araw';

  @override
  String get durationHour => 'Oras';

  @override
  String get durationMinute => 'Minuto';

  @override
  String get durationSecond => 'Segundo';
}
