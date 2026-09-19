// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Tamil (`ta`).
class ShadcnLocalizationsTa extends ShadcnLocalizations {
  /// Creates the Tamil localizations.
  ShadcnLocalizationsTa([super.locale = 'ta']);

  @override
  String get formNotEmpty => 'இந்தப் புலம் காலியாக இருக்கக் கூடாது';

  @override
  String get invalidValue => 'தவறான மதிப்பு';

  @override
  String get invalidEmail => 'தவறான மின்னஞ்சல்';

  @override
  String get invalidURL => 'தவறான URL';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-ஐ விடக் குறைவாக இருக்க வேண்டும்';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-ஐ விட அதிகமாக இருக்க வேண்டும்';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-ஐ விடக் குறைவாகவோ சமமாகவோ இருக்க வேண்டும்';
  }

  String get formPhoneNumberInvalid => 'தொலைபேசி எண் தவறானது';

  String get formPhoneNumberEmpty => 'தொலைபேசி எண் தேவை';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString-ஐ விட அதிகமாகவோ சமமாகவோ இருக்க வேண்டும்';
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

    return '$minString மற்றும் $maxString இடையே இருக்க வேண்டும் (உட்பட)';
  }

  String formEqualTo(String value) {
    return '${value}-க்குச் சமமாக இருக்க வேண்டும்';
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

    return '$minString மற்றும் $maxString இடையே இருக்க வேண்டும் (தவிர)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'குறைந்தது ${value} எழுத்துகள் இருக்க வேண்டும்';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'அதிகபட்சம் ${value} எழுத்துகள் இருக்கலாம்';
  }

  @override
  String get formPasswordDigits => 'குறைந்தது ஒரு இலக்கம் இருக்க வேண்டும்';

  @override
  String get formPasswordLowercase => 'குறைந்தது ஒரு சிறிய எழுத்து இருக்க வேண்டும்';

  @override
  String get formPasswordUppercase => 'குறைந்தது ஒரு பெரிய எழுத்து இருக்க வேண்டும்';

  @override
  String get formPasswordSpecial => 'குறைந்தது ஒரு சிறப்பு எழுத்து இருக்க வேண்டும்';

  @override
  String get commandSearch => 'கட்டளையைத் தட்டச்சு செய்யவும் அல்லது தேடவும்...';

  @override
  String get commandEmpty => 'முடிவுகள் எதுவும் இல்லை.';

  @override
  String get datePickerSelectYear => 'ஆண்டைத் தேர்ந்தெடுக்கவும்';

  @override
  String get abbreviatedMonday => 'திங்';

  @override
  String get abbreviatedTuesday => 'செவ்';

  @override
  String get abbreviatedWednesday => 'புத';

  @override
  String get abbreviatedThursday => 'வியா';

  @override
  String get abbreviatedFriday => 'வெள்';

  @override
  String get abbreviatedSaturday => 'சனி';

  @override
  String get abbreviatedSunday => 'ஞாயி';

  @override
  String get monthJanuary => 'ஜனவரி';

  @override
  String get monthFebruary => 'பிப்ரவரி';

  @override
  String get monthMarch => 'மார்ச்';

  @override
  String get monthApril => 'ஏப்ரல்';

  @override
  String get monthMay => 'மே';

  @override
  String get monthJune => 'ஜூன்';

  @override
  String get monthJuly => 'ஜூலை';

  @override
  String get monthAugust => 'ஆகஸ்ட்';

  @override
  String get monthSeptember => 'செப்டம்பர்';

  @override
  String get monthOctober => 'அக்டோபர்';

  @override
  String get monthNovember => 'நவம்பர்';

  @override
  String get monthDecember => 'டிசம்பர்';

  @override
  String get abbreviatedJanuary => 'ஜன';

  @override
  String get abbreviatedFebruary => 'பிப்';

  @override
  String get abbreviatedMarch => 'மார்';

  @override
  String get abbreviatedApril => 'ஏப்';

  @override
  String get abbreviatedMay => 'மே';

  @override
  String get abbreviatedJune => 'ஜூன்';

  @override
  String get abbreviatedJuly => 'ஜூலை';

  @override
  String get abbreviatedAugust => 'ஆக';

  @override
  String get abbreviatedSeptember => 'செப்';

  @override
  String get abbreviatedOctober => 'அக்';

  @override
  String get abbreviatedNovember => 'நவ';

  @override
  String get abbreviatedDecember => 'டிச';

  @override
  String get buttonCancel => 'ரத்துசெய்';

  @override
  String get buttonSave => 'சேமி';

  @override
  String get timeHour => 'மணி';

  @override
  String get timeMinute => 'நிமிடம்';

  @override
  String get timeSecond => 'வினாடி';

  @override
  String get timeAM => 'முற்பகல்';

  @override
  String get timePM => 'பிற்பகல்';

  @override
  String get colorRed => 'சிவப்பு';

  @override
  String get colorGreen => 'பச்சை';

  @override
  String get colorBlue => 'நீலம்';

  @override
  String get colorAlpha => 'ஆல்ஃபா';

  @override
  String get colorHue => 'வண்ணச்சாயல்';

  @override
  String get colorSaturation => 'நிறைவு';

  @override
  String get colorValue => 'மதிப்பு';

  @override
  String get colorLightness => 'ஒளிர்வு';

  @override
  String get menuCut => 'வெட்டு';

  @override
  String get menuCopy => 'நகலெடு';

  @override
  String get menuPaste => 'ஒட்டு';

  @override
  String get menuSelectAll => 'அனைத்தையும் தேர்ந்தெடு';

  String get noSpellCheckReplacements => 'பரிந்துரைகள் இல்லை';

  @override
  String get menuUndo => 'செயல்தவிர்';

  @override
  String get menuRedo => 'மீண்டும் செய்';

  @override
  String get menuDelete => 'நீக்கு';

  @override
  String get menuShare => 'பகிர்';

  @override
  String get menuSearchWeb => 'இணையத்தில் தேடு';

  @override
  String get menuLiveTextInput => 'நேரடி உரை';

  @override
  String get placeholderDatePicker => 'தேதியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get placeholderTimePicker => 'நேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get placeholderColorPicker => 'வண்ணத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get buttonPrevious => 'முந்தைய';

  @override
  String get buttonNext => 'அடுத்து';

  @override
  String get refreshTriggerPull => 'புதுப்பிக்க இழுக்கவும்';

  @override
  String get refreshTriggerRelease => 'புதுப்பிக்க விடுவிக்கவும்';

  @override
  String get refreshTriggerRefreshing => 'புதுப்பிக்கிறது...';

  @override
  String get refreshTriggerComplete => 'புதுப்பித்தல் முடிந்தது';

  @override
  String get colorPickerTabRecent => 'சமீபத்திய';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'மேலே நகர்த்து';

  @override
  String get commandMoveDown => 'கீழே நகர்த்து';

  @override
  String get commandActivate => 'தேர்ந்தெடு';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${total} வரிசைகளில் ${count} தேர்ந்தெடுக்கப்பட்டன.';
  }

  @override
  String get dataTableNext => 'அடுத்து';

  @override
  String get dataTablePrevious => 'முந்தைய';

  @override
  String get dataTableColumns => 'நெடுவரிசைகள்';

  @override
  String get timeDaysAbbreviation => 'நந';

  @override
  String get timeHoursAbbreviation => 'மம';

  @override
  String get timeMinutesAbbreviation => 'நிநி';

  @override
  String get timeSecondsAbbreviation => 'விவி';

  @override
  String get placeholderDurationPicker => 'கால அளவைத் தேர்ந்தெடுக்கவும்';

  @override
  String get durationDay => 'நாள்';

  @override
  String get durationHour => 'மணி';

  @override
  String get durationMinute => 'நிமிடம்';

  @override
  String get durationSecond => 'வினாடி';
}
