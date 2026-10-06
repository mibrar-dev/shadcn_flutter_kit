import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Marathi (`mr`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsMr extends ShadcnLocalizations {
  /// Creates the Marathi strings.
  const ShadcnLocalizationsMr([super.locale = const Locale('mr')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'हे फील्ड रिकामे असू शकत नाही';

  @override
  String get invalidValue => 'अवैध मूल्य';

  @override
  String get invalidEmail => 'अवैध ईमेल';

  @override
  String get invalidURL => 'अवैध URL';

  @override
  String formLessThan(Object? value) =>
      '${_number(value)} पेक्षा कमी असणे आवश्यक आहे';

  @override
  String formGreaterThan(Object? value) =>
      '${_number(value)} पेक्षा जास्त असणे आवश्यक आहे';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      '${_number(value)} पेक्षा कमी किंवा समान असणे आवश्यक आहे';

  @override
  String get formPhoneNumberInvalid => 'फोन नंबर अवैध आहे';

  @override
  String get formPhoneNumberEmpty => 'फोन नंबर आवश्यक आहे';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      '${_number(value)} पेक्षा जास्त किंवा समान असणे आवश्यक आहे';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '${_number(min)} आणि ${_number(max)} दरम्यान असणे आवश्यक आहे (समावेशक)';

  @override
  String formEqualTo(Object? value) =>
      '${_number(value)} च्या समान असणे आवश्यक आहे';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '${_number(min)} आणि ${_number(max)} दरम्यान असणे आवश्यक आहे (वगळून)';

  @override
  String formLengthLessThan(int limit) => 'किमान $limit वर्ण असणे आवश्यक आहे';

  @override
  String formLengthGreaterThan(int limit) =>
      'जास्तीत जास्त $limit वर्ण असू शकतात';

  @override
  String get formPasswordDigits => 'किमान एक अंक असणे आवश्यक आहे';

  @override
  String get formPasswordLowercase => 'किमान एक लहान अक्षर असणे आवश्यक आहे';

  @override
  String get formPasswordUppercase => 'किमान एक मोठे अक्षर असणे आवश्यक आहे';

  @override
  String get formPasswordSpecial => 'किमान एक विशेष वर्ण असणे आवश्यक आहे';

  @override
  String get commandSearch => 'आदेश टाइप करा किंवा शोधा...';

  @override
  String get commandEmpty => 'कोणतेही परिणाम आढळले नाहीत.';

  @override
  String get datePickerSelectYear => 'वर्ष निवडा';

  @override
  String get abbreviatedMonday => 'सोम';

  @override
  String get abbreviatedTuesday => 'मंगळ';

  @override
  String get abbreviatedWednesday => 'बुध';

  @override
  String get abbreviatedThursday => 'गुरु';

  @override
  String get abbreviatedFriday => 'शुक्र';

  @override
  String get abbreviatedSaturday => 'शनि';

  @override
  String get abbreviatedSunday => 'रवि';

  @override
  String get monthJanuary => 'जानेवारी';

  @override
  String get monthFebruary => 'फेब्रुवारी';

  @override
  String get monthMarch => 'मार्च';

  @override
  String get monthApril => 'एप्रिल';

  @override
  String get monthMay => 'मे';

  @override
  String get monthJune => 'जून';

  @override
  String get monthJuly => 'जुलै';

  @override
  String get monthAugust => 'ऑगस्ट';

  @override
  String get monthSeptember => 'सप्टेंबर';

  @override
  String get monthOctober => 'ऑक्टोबर';

  @override
  String get monthNovember => 'नोव्हेंबर';

  @override
  String get monthDecember => 'डिसेंबर';

  @override
  String get abbreviatedJanuary => 'जाने';

  @override
  String get abbreviatedFebruary => 'फेब्रु';

  @override
  String get abbreviatedMarch => 'मार्च';

  @override
  String get abbreviatedApril => 'एप्रि';

  @override
  String get abbreviatedMay => 'मे';

  @override
  String get abbreviatedJune => 'जून';

  @override
  String get abbreviatedJuly => 'जुलै';

  @override
  String get abbreviatedAugust => 'ऑग';

  @override
  String get abbreviatedSeptember => 'सप्टें';

  @override
  String get abbreviatedOctober => 'ऑक्टो';

  @override
  String get abbreviatedNovember => 'नोव्हें';

  @override
  String get abbreviatedDecember => 'डिसें';

  @override
  String get dialogDismiss => 'डिसमिस करा';

  @override
  String get buttonCancel => 'रद्द करा';

  @override
  String get buttonSave => 'जतन करा';

  @override
  String get timeHour => 'तास';

  @override
  String get timeMinute => 'मिनिट';

  @override
  String get timeSecond => 'सेकंद';

  @override
  String get timeAM => 'स.';

  @override
  String get timePM => 'दु.';

  @override
  String get colorRed => 'लाल';

  @override
  String get colorGreen => 'हिरवा';

  @override
  String get colorBlue => 'निळा';

  @override
  String get colorAlpha => 'अल्फा';

  @override
  String get colorHue => 'छटा';

  @override
  String get colorSaturation => 'संपृक्तता';

  @override
  String get colorValue => 'मूल्य';

  @override
  String get colorLightness => 'तेजस्विता';

  @override
  String get menuCut => 'कट करा';

  @override
  String get menuCopy => 'कॉपी करा';

  @override
  String get menuPaste => 'पेस्ट करा';

  @override
  String get menuSelectAll => 'सर्व निवडा';

  @override
  String get menuUndo => 'पूर्ववत करा';

  @override
  String get menuRedo => 'पुन्हा करा';

  @override
  String get menuDelete => 'हटवा';

  @override
  String get menuShare => 'शेअर करा';

  @override
  String get menuSearchWeb => 'वेबवर शोधा';

  @override
  String get menuLiveTextInput => 'लाइव्ह मजकूर';

  @override
  String get placeholderDatePicker => 'तारीख निवडा';

  @override
  String get placeholderTimePicker => 'वेळ निवडा';

  @override
  String get placeholderColorPicker => 'रंग निवडा';

  @override
  String get buttonPrevious => 'मागील';

  @override
  String get buttonNext => 'पुढील';

  @override
  String get refreshTriggerPull => 'रिफ्रेश करण्यासाठी ओढा';

  @override
  String get refreshTriggerRelease => 'रिफ्रेश करण्यासाठी सोडा';

  @override
  String get refreshTriggerRefreshing => 'रिफ्रेश होत आहे...';

  @override
  String get refreshTriggerComplete => 'रिफ्रेश पूर्ण झाले';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'वर हलवा';

  @override
  String get commandMoveDown => 'खाली हलवा';

  @override
  String get commandActivate => 'निवडा';

  @override
  String get timeDaysAbbreviation => 'दिदि';

  @override
  String get timeHoursAbbreviation => 'तात';

  @override
  String get timeMinutesAbbreviation => 'मिमि';

  @override
  String get timeSecondsAbbreviation => 'सेसे';

  @override
  String get placeholderDurationPicker => 'कालावधी निवडा';

  @override
  String get durationDay => 'दिवस';

  @override
  String get durationHour => 'तास';

  @override
  String get durationMinute => 'मिनिट';

  @override
  String get durationSecond => 'सेकंद';
}
