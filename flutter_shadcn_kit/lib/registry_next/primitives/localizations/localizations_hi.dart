import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Hindi (`hi`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsHi extends ShadcnLocalizations {
  /// Creates the Hindi strings.
  const ShadcnLocalizationsHi([super.locale = const Locale('hi')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'यह फ़ील्ड खाली नहीं हो सकता';

  @override
  String get invalidValue => 'अमान्य मान';

  @override
  String get invalidEmail => 'अमान्य ईमेल';

  @override
  String get invalidURL => 'अमान्य URL';

  @override
  String formLessThan(Object? value) => '${_number(value)} से कम होना चाहिए';

  @override
  String formGreaterThan(Object? value) =>
      '${_number(value)} से अधिक होना चाहिए';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      '${_number(value)} से कम या उसके बराबर होना चाहिए';

  @override
  String get formPhoneNumberInvalid => 'फ़ोन नंबर अमान्य है';

  @override
  String get formPhoneNumberEmpty => 'फ़ोन नंबर आवश्यक है';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      '${_number(value)} से अधिक या उसके बराबर होना चाहिए';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '${_number(min)} और ${_number(max)} के बीच होना चाहिए (सहित)';

  @override
  String formEqualTo(Object? value) => '${_number(value)} के बराबर होना चाहिए';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '${_number(min)} और ${_number(max)} के बीच होना चाहिए (रहित)';

  @override
  String formLengthLessThan(int limit) => 'कम से कम $limit वर्ण होने चाहिए';

  @override
  String formLengthGreaterThan(int limit) => 'अधिकतम $limit वर्ण होने चाहिए';

  @override
  String get formPasswordDigits => 'कम से कम एक अंक होना चाहिए';

  @override
  String get formPasswordLowercase => 'कम से कम एक छोटा अक्षर होना चाहिए';

  @override
  String get formPasswordUppercase => 'कम से कम एक बड़ा अक्षर होना चाहिए';

  @override
  String get formPasswordSpecial => 'कम से कम एक विशेष वर्ण होना चाहिए';

  @override
  String get commandSearch => 'कमांड लिखें या खोजें...';

  @override
  String get commandEmpty => 'कोई परिणाम नहीं मिला.';

  @override
  String get datePickerSelectYear => 'वर्ष चुनें';

  @override
  String get abbreviatedMonday => 'सोम';

  @override
  String get abbreviatedTuesday => 'मंगल';

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
  String get monthJanuary => 'जनवरी';

  @override
  String get monthFebruary => 'फ़रवरी';

  @override
  String get monthMarch => 'मार्च';

  @override
  String get monthApril => 'अप्रैल';

  @override
  String get monthMay => 'मई';

  @override
  String get monthJune => 'जून';

  @override
  String get monthJuly => 'जुलाई';

  @override
  String get monthAugust => 'अगस्त';

  @override
  String get monthSeptember => 'सितंबर';

  @override
  String get monthOctober => 'अक्तूबर';

  @override
  String get monthNovember => 'नवंबर';

  @override
  String get monthDecember => 'दिसंबर';

  @override
  String get abbreviatedJanuary => 'जन';

  @override
  String get abbreviatedFebruary => 'फ़र';

  @override
  String get abbreviatedMarch => 'मार्च';

  @override
  String get abbreviatedApril => 'अप्रै';

  @override
  String get abbreviatedMay => 'मई';

  @override
  String get abbreviatedJune => 'जून';

  @override
  String get abbreviatedJuly => 'जुल';

  @override
  String get abbreviatedAugust => 'अग';

  @override
  String get abbreviatedSeptember => 'सित';

  @override
  String get abbreviatedOctober => 'अक्तू';

  @override
  String get abbreviatedNovember => 'नव';

  @override
  String get abbreviatedDecember => 'दिस';

  @override
  String get dialogDismiss => 'खारिज करें';

  @override
  String get buttonCancel => 'रद्द करें';

  @override
  String get buttonSave => 'सहेजें';

  @override
  String get timeHour => 'घंटा';

  @override
  String get timeMinute => 'मिनट';

  @override
  String get timeSecond => 'सेकंड';

  @override
  String get timeAM => 'पूर्वाह्न';

  @override
  String get timePM => 'अपराह्न';

  @override
  String get colorRed => 'लाल';

  @override
  String get colorGreen => 'हरा';

  @override
  String get colorBlue => 'नीला';

  @override
  String get colorAlpha => 'अल्फ़ा';

  @override
  String get colorHue => 'रंगत';

  @override
  String get colorSaturation => 'संतृप्ति';

  @override
  String get colorValue => 'मान';

  @override
  String get colorLightness => 'चमक';

  @override
  String get menuCut => 'काटें';

  @override
  String get menuCopy => 'कॉपी करें';

  @override
  String get menuPaste => 'पेस्ट करें';

  @override
  String get menuSelectAll => 'सभी चुनें';

  @override
  String get menuUndo => 'पूर्ववत करें';

  @override
  String get menuRedo => 'फिर से करें';

  @override
  String get menuDelete => 'हटाएं';

  @override
  String get menuShare => 'शेयर करें';

  @override
  String get menuSearchWeb => 'वेब पर खोजें';

  @override
  String get menuLiveTextInput => 'लाइव टेक्स्ट';

  @override
  String get placeholderDatePicker => 'तारीख चुनें';

  @override
  String get placeholderTimePicker => 'समय चुनें';

  @override
  String get placeholderColorPicker => 'रंग चुनें';

  @override
  String get buttonPrevious => 'पिछला';

  @override
  String get buttonNext => 'अगला';

  @override
  String get refreshTriggerPull => 'रीफ़्रेश करने के लिए खींचें';

  @override
  String get refreshTriggerRelease => 'रीफ़्रेश करने के लिए छोड़ें';

  @override
  String get refreshTriggerRefreshing => 'रीफ़्रेश हो रहा है...';

  @override
  String get refreshTriggerComplete => 'रीफ़्रेश पूरा हुआ';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'ऊपर ले जाएं';

  @override
  String get commandMoveDown => 'नीचे ले जाएं';

  @override
  String get commandActivate => 'चुनें';

  @override
  String get timeDaysAbbreviation => 'दद';

  @override
  String get timeHoursAbbreviation => 'घघ';

  @override
  String get timeMinutesAbbreviation => 'मम';

  @override
  String get timeSecondsAbbreviation => 'सस';

  @override
  String get placeholderDurationPicker => 'अवधि चुनें';

  @override
  String get durationDay => 'दिन';

  @override
  String get durationHour => 'घंटा';

  @override
  String get durationMinute => 'मिनट';

  @override
  String get durationSecond => 'सेकंड';
}
