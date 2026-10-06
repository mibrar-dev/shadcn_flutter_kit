import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Hebrew (`he`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsHe extends ShadcnLocalizations {
  /// Creates the Hebrew strings.
  const ShadcnLocalizationsHe([super.locale = const Locale('he')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'שדה זה אינו יכול להיות ריק';

  @override
  String get invalidValue => 'ערך לא תקין';

  @override
  String get invalidEmail => 'כתובת אימייל לא תקינה';

  @override
  String get invalidURL => 'כתובת URL לא תקינה';

  @override
  String formLessThan(Object? value) => 'חייב להיות קטן מ-${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'חייב להיות גדול מ-${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'חייב להיות קטן מ-${_number(value)} או שווה לו';

  @override
  String get formPhoneNumberInvalid => 'מספר הטלפון אינו תקין';

  @override
  String get formPhoneNumberEmpty => 'יש להזין מספר טלפון';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'חייב להיות גדול מ-${_number(value)} או שווה לו';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'חייב להיות בין ${_number(min)} ל-${_number(max)} (כולל)';

  @override
  String formEqualTo(Object? value) => 'חייב להיות שווה ל-${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'חייב להיות בין ${_number(min)} ל-${_number(max)} (לא כולל)';

  @override
  String formLengthLessThan(int limit) => 'חייב להכיל לפחות $limit תווים';

  @override
  String formLengthGreaterThan(int limit) =>
      'חייב להכיל לכל היותר $limit תווים';

  @override
  String get formPasswordDigits => 'חייב להכיל לפחות ספרה אחת';

  @override
  String get formPasswordLowercase => 'חייב להכיל לפחות אות קטנה אחת';

  @override
  String get formPasswordUppercase => 'חייב להכיל לפחות אות גדולה אחת';

  @override
  String get formPasswordSpecial => 'חייב להכיל לפחות תו מיוחד אחד';

  @override
  String get commandSearch => 'הקלד פקודה או חפש...';

  @override
  String get commandEmpty => 'לא נמצאו תוצאות.';

  @override
  String get datePickerSelectYear => 'בחר שנה';

  @override
  String get abbreviatedMonday => 'ב׳';

  @override
  String get abbreviatedTuesday => 'ג׳';

  @override
  String get abbreviatedWednesday => 'ד׳';

  @override
  String get abbreviatedThursday => 'ה׳';

  @override
  String get abbreviatedFriday => 'ו׳';

  @override
  String get abbreviatedSaturday => 'ש׳';

  @override
  String get abbreviatedSunday => 'א׳';

  @override
  String get monthJanuary => 'ינואר';

  @override
  String get monthFebruary => 'פברואר';

  @override
  String get monthMarch => 'מרץ';

  @override
  String get monthApril => 'אפריל';

  @override
  String get monthMay => 'מאי';

  @override
  String get monthJune => 'יוני';

  @override
  String get monthJuly => 'יולי';

  @override
  String get monthAugust => 'אוגוסט';

  @override
  String get monthSeptember => 'ספטמבר';

  @override
  String get monthOctober => 'אוקטובר';

  @override
  String get monthNovember => 'נובמבר';

  @override
  String get monthDecember => 'דצמבר';

  @override
  String get abbreviatedJanuary => 'ינו׳';

  @override
  String get abbreviatedFebruary => 'פבר׳';

  @override
  String get abbreviatedMarch => 'מרץ';

  @override
  String get abbreviatedApril => 'אפר׳';

  @override
  String get abbreviatedMay => 'מאי';

  @override
  String get abbreviatedJune => 'יוני';

  @override
  String get abbreviatedJuly => 'יולי';

  @override
  String get abbreviatedAugust => 'אוג׳';

  @override
  String get abbreviatedSeptember => 'ספט׳';

  @override
  String get abbreviatedOctober => 'אוק׳';

  @override
  String get abbreviatedNovember => 'נוב׳';

  @override
  String get abbreviatedDecember => 'דצמ׳';

  @override
  String get dialogDismiss => 'סגירה';

  @override
  String get buttonCancel => 'ביטול';

  @override
  String get buttonSave => 'שמירה';

  @override
  String get timeHour => 'שעה';

  @override
  String get timeMinute => 'דקה';

  @override
  String get timeSecond => 'שנייה';

  @override
  String get timeAM => 'לפנה״צ';

  @override
  String get timePM => 'אחה״צ';

  @override
  String get colorRed => 'אדום';

  @override
  String get colorGreen => 'ירוק';

  @override
  String get colorBlue => 'כחול';

  @override
  String get colorAlpha => 'אלפא';

  @override
  String get colorHue => 'גוון';

  @override
  String get colorSaturation => 'רוויה';

  @override
  String get colorValue => 'ערך';

  @override
  String get colorLightness => 'בהירות';

  @override
  String get menuCut => 'גזור';

  @override
  String get menuCopy => 'העתק';

  @override
  String get menuPaste => 'הדבק';

  @override
  String get menuSelectAll => 'בחר הכול';

  @override
  String get menuUndo => 'בטל';

  @override
  String get menuRedo => 'בצע שוב';

  @override
  String get menuDelete => 'מחק';

  @override
  String get menuShare => 'שתף';

  @override
  String get menuSearchWeb => 'חפש באינטרנט';

  @override
  String get menuLiveTextInput => 'טקסט חי';

  @override
  String get placeholderDatePicker => 'בחר תאריך';

  @override
  String get placeholderTimePicker => 'בחר שעה';

  @override
  String get placeholderColorPicker => 'בחר צבע';

  @override
  String get buttonPrevious => 'הקודם';

  @override
  String get buttonNext => 'הבא';

  @override
  String get refreshTriggerPull => 'משוך כדי לרענן';

  @override
  String get refreshTriggerRelease => 'שחרר כדי לרענן';

  @override
  String get refreshTriggerRefreshing => 'מרענן...';

  @override
  String get refreshTriggerComplete => 'הרענון הושלם';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'הזז למעלה';

  @override
  String get commandMoveDown => 'הזז למטה';

  @override
  String get commandActivate => 'בחר';

  @override
  String get timeDaysAbbreviation => 'יי';

  @override
  String get timeHoursAbbreviation => 'שש';

  @override
  String get timeMinutesAbbreviation => 'דד';

  @override
  String get timeSecondsAbbreviation => 'שנ';

  @override
  String get placeholderDurationPicker => 'בחר משך זמן';

  @override
  String get durationDay => 'יום';

  @override
  String get durationHour => 'שעה';

  @override
  String get durationMinute => 'דקה';

  @override
  String get durationSecond => 'שנייה';
}
