// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Telugu (`te`).
class ShadcnLocalizationsTe extends ShadcnLocalizations {
  /// Creates the Telugu localizations.
  ShadcnLocalizationsTe([super.locale = 'te']);

  @override
  String get formNotEmpty => 'ఈ ఫీల్డ్ ఖాళీగా ఉండకూడదు';

  @override
  String get invalidValue => 'చెల్లని విలువ';

  @override
  String get invalidEmail => 'చెల్లని ఇమెయిల్';

  @override
  String get invalidURL => 'చెల్లని URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString కంటే తక్కువగా ఉండాలి';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString కంటే ఎక్కువగా ఉండాలి';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString కంటే తక్కువ లేదా సమానంగా ఉండాలి';
  }

  String get formPhoneNumberInvalid => 'ఫోన్ నంబర్ చెల్లదు';

  String get formPhoneNumberEmpty => 'ఫోన్ నంబర్ అవసరం';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString కంటే ఎక్కువ లేదా సమానంగా ఉండాలి';
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

    return '$minString మరియు $maxString మధ్య ఉండాలి (కలిపి)';
  }

  String formEqualTo(String value) {
    return '${value}కి సమానంగా ఉండాలి';
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

    return '$minString మరియు $maxString మధ్య ఉండాలి (మినహా)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'కనీసం ${value} అక్షరాలు ఉండాలి';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'గరిష్ఠంగా ${value} అక్షరాలు ఉండాలి';
  }

  @override
  String get formPasswordDigits => 'కనీసం ఒక అంకె ఉండాలి';

  @override
  String get formPasswordLowercase => 'కనీసం ఒక చిన్న అక్షరం ఉండాలి';

  @override
  String get formPasswordUppercase => 'కనీసం ఒక పెద్ద అక్షరం ఉండాలి';

  @override
  String get formPasswordSpecial => 'కనీసం ఒక ప్రత్యేక అక్షరం ఉండాలి';

  @override
  String get commandSearch => 'ఆదేశాన్ని టైప్ చేయండి లేదా వెతకండి...';

  @override
  String get commandEmpty => 'ఫలితాలు కనుగొనబడలేదు.';

  @override
  String get datePickerSelectYear => 'సంవత్సరాన్ని ఎంచుకోండి';

  @override
  String get abbreviatedMonday => 'సోమ';

  @override
  String get abbreviatedTuesday => 'మంగళ';

  @override
  String get abbreviatedWednesday => 'బుధ';

  @override
  String get abbreviatedThursday => 'గురు';

  @override
  String get abbreviatedFriday => 'శుక్ర';

  @override
  String get abbreviatedSaturday => 'శని';

  @override
  String get abbreviatedSunday => 'ఆది';

  @override
  String get monthJanuary => 'జనవరి';

  @override
  String get monthFebruary => 'ఫిబ్రవరి';

  @override
  String get monthMarch => 'మార్చి';

  @override
  String get monthApril => 'ఏప్రిల్';

  @override
  String get monthMay => 'మే';

  @override
  String get monthJune => 'జూన్';

  @override
  String get monthJuly => 'జూలై';

  @override
  String get monthAugust => 'ఆగస్టు';

  @override
  String get monthSeptember => 'సెప్టెంబర్';

  @override
  String get monthOctober => 'అక్టోబర్';

  @override
  String get monthNovember => 'నవంబర్';

  @override
  String get monthDecember => 'డిసెంబర్';

  @override
  String get abbreviatedJanuary => 'జన';

  @override
  String get abbreviatedFebruary => 'ఫిబ్ర';

  @override
  String get abbreviatedMarch => 'మార్చి';

  @override
  String get abbreviatedApril => 'ఏప్రి';

  @override
  String get abbreviatedMay => 'మే';

  @override
  String get abbreviatedJune => 'జూన్';

  @override
  String get abbreviatedJuly => 'జూలై';

  @override
  String get abbreviatedAugust => 'ఆగ';

  @override
  String get abbreviatedSeptember => 'సెప్టెం';

  @override
  String get abbreviatedOctober => 'అక్టో';

  @override
  String get abbreviatedNovember => 'నవం';

  @override
  String get abbreviatedDecember => 'డిసెం';

  @override
  String get buttonCancel => 'రద్దు చేయి';

  @override
  String get buttonSave => 'సేవ్ చేయి';

  @override
  String get timeHour => 'గంట';

  @override
  String get timeMinute => 'నిమిషం';

  @override
  String get timeSecond => 'సెకను';

  @override
  String get timeAM => 'ఉ.';

  @override
  String get timePM => 'సా.';

  @override
  String get colorRed => 'ఎరుపు';

  @override
  String get colorGreen => 'ఆకుపచ్చ';

  @override
  String get colorBlue => 'నీలం';

  @override
  String get colorAlpha => 'ఆల్ఫా';

  @override
  String get colorHue => 'వర్ణం';

  @override
  String get colorSaturation => 'సంతృప్తత';

  @override
  String get colorValue => 'విలువ';

  @override
  String get colorLightness => 'ప్రకాశం';

  @override
  String get menuCut => 'కత్తిరించు';

  @override
  String get menuCopy => 'కాపీ చేయి';

  @override
  String get menuPaste => 'అతికించు';

  @override
  String get menuSelectAll => 'అన్నీ ఎంచుకో';

  String get noSpellCheckReplacements => 'సూచనలు కనుగొనబడలేదు';

  @override
  String get menuUndo => 'చర్య రద్దు';

  @override
  String get menuRedo => 'మళ్లీ చేయి';

  @override
  String get menuDelete => 'తొలగించు';

  @override
  String get menuShare => 'షేర్ చేయి';

  @override
  String get menuSearchWeb => 'వెబ్‌లో వెతుకు';

  @override
  String get menuLiveTextInput => 'లైవ్ టెక్స్ట్';

  @override
  String get placeholderDatePicker => 'తేదీని ఎంచుకోండి';

  @override
  String get placeholderTimePicker => 'సమయాన్ని ఎంచుకోండి';

  @override
  String get placeholderColorPicker => 'రంగును ఎంచుకోండి';

  @override
  String get buttonPrevious => 'మునుపటి';

  @override
  String get buttonNext => 'తదుపరి';

  @override
  String get refreshTriggerPull => 'రిఫ్రెష్ చేయడానికి లాగండి';

  @override
  String get refreshTriggerRelease => 'రిఫ్రెష్ చేయడానికి వదిలేయండి';

  @override
  String get refreshTriggerRefreshing => 'రిఫ్రెష్ అవుతోంది...';

  @override
  String get refreshTriggerComplete => 'రిఫ్రెష్ పూర్తయింది';

  @override
  String get colorPickerTabRecent => 'ఇటీవలివి';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'పైకి జరుపు';

  @override
  String get commandMoveDown => 'కిందికి జరుపు';

  @override
  String get commandActivate => 'ఎంచుకో';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${total} వరుసల్లో ${count} ఎంచుకోబడ్డాయి.';
  }

  @override
  String get dataTableNext => 'తదుపరి';

  @override
  String get dataTablePrevious => 'మునుపటి';

  @override
  String get dataTableColumns => 'నిలువు వరుసలు';

  @override
  String get timeDaysAbbreviation => 'రర';

  @override
  String get timeHoursAbbreviation => 'గగ';

  @override
  String get timeMinutesAbbreviation => 'నిని';

  @override
  String get timeSecondsAbbreviation => 'సెసె';

  @override
  String get placeholderDurationPicker => 'వ్యవధిని ఎంచుకోండి';

  @override
  String get durationDay => 'రోజు';

  @override
  String get durationHour => 'గంట';

  @override
  String get durationMinute => 'నిమిషం';

  @override
  String get durationSecond => 'సెకను';
}
