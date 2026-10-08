import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Chinese (Hant) (`zh_Hant`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsZhHant extends ShadcnLocalizations {
  /// Creates the Chinese (Hant) strings.
  const ShadcnLocalizationsZhHant([
    super.locale = const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
    ),
  ]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => '此欄位不能為空';

  @override
  String get invalidValue => '無效的值';

  @override
  String get invalidEmail => '無效的電子郵件地址';

  @override
  String get invalidURL => '無效的網址';

  @override
  String formLessThan(Object? value) => '必須小於 ${_number(value)}';

  @override
  String formGreaterThan(Object? value) => '必須大於 ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) => '必須小於或等於 ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => '電話號碼無效';

  @override
  String get formPhoneNumberEmpty => '請輸入電話號碼';

  @override
  String formGreaterThanOrEqualTo(Object? value) => '必須大於或等於 ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '必須介於 ${_number(min)} 和 ${_number(max)} 之間（含端點）';

  @override
  String formEqualTo(Object? value) => '必須等於 ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '必須介於 ${_number(min)} 和 ${_number(max)} 之間（不含端點）';

  @override
  String formLengthLessThan(int limit) => '至少需要 $limit 個字元';

  @override
  String formLengthGreaterThan(int limit) => '最多只能有 $limit 個字元';

  @override
  String get formPasswordDigits => '必須包含至少一個數字';

  @override
  String get formPasswordLowercase => '必須包含至少一個小寫字母';

  @override
  String get formPasswordUppercase => '必須包含至少一個大寫字母';

  @override
  String get formPasswordSpecial => '必須包含至少一個特殊字元';

  @override
  String get commandSearch => '輸入指令或搜尋...';

  @override
  String get commandEmpty => '找不到結果。';

  @override
  String get datePickerSelectYear => '選擇年份';

  @override
  String get abbreviatedMonday => '一';

  @override
  String get abbreviatedTuesday => '二';

  @override
  String get abbreviatedWednesday => '三';

  @override
  String get abbreviatedThursday => '四';

  @override
  String get abbreviatedFriday => '五';

  @override
  String get abbreviatedSaturday => '六';

  @override
  String get abbreviatedSunday => '日';

  @override
  String get monthJanuary => '一月';

  @override
  String get monthFebruary => '二月';

  @override
  String get monthMarch => '三月';

  @override
  String get monthApril => '四月';

  @override
  String get monthMay => '五月';

  @override
  String get monthJune => '六月';

  @override
  String get monthJuly => '七月';

  @override
  String get monthAugust => '八月';

  @override
  String get monthSeptember => '九月';

  @override
  String get monthOctober => '十月';

  @override
  String get monthNovember => '十一月';

  @override
  String get monthDecember => '十二月';

  @override
  String get abbreviatedJanuary => '1月';

  @override
  String get abbreviatedFebruary => '2月';

  @override
  String get abbreviatedMarch => '3月';

  @override
  String get abbreviatedApril => '4月';

  @override
  String get abbreviatedMay => '5月';

  @override
  String get abbreviatedJune => '6月';

  @override
  String get abbreviatedJuly => '7月';

  @override
  String get abbreviatedAugust => '8月';

  @override
  String get abbreviatedSeptember => '9月';

  @override
  String get abbreviatedOctober => '10月';

  @override
  String get abbreviatedNovember => '11月';

  @override
  String get abbreviatedDecember => '12月';

  @override
  String get dialogDismiss => '關閉';

  @override
  String get chipInputRemoveChip => '刪除';

  @override
  String get buttonCancel => '取消';

  @override
  String get buttonSave => '儲存';

  @override
  String get timeHour => '時';

  @override
  String get timeMinute => '分';

  @override
  String get timeSecond => '秒';

  @override
  String get timeAM => '上午';

  @override
  String get timePM => '下午';

  @override
  String get colorRed => '紅';

  @override
  String get colorGreen => '綠';

  @override
  String get colorBlue => '藍';

  @override
  String get colorAlpha => '透明度';

  @override
  String get colorHue => '色相';

  @override
  String get colorSaturation => '飽和度';

  @override
  String get colorValue => '明度';

  @override
  String get colorLightness => '亮度';

  @override
  String get menuCut => '剪下';

  @override
  String get menuCopy => '複製';

  @override
  String get menuPaste => '貼上';

  @override
  String get menuSelectAll => '全選';

  @override
  String get menuUndo => '復原';

  @override
  String get menuRedo => '重做';

  @override
  String get menuDelete => '刪除';

  @override
  String get menuShare => '分享';

  @override
  String get menuSearchWeb => '網頁搜尋';

  @override
  String get menuLiveTextInput => '即時文字';

  @override
  String get placeholderDatePicker => '選擇日期';

  @override
  String get placeholderTimePicker => '選擇時間';

  @override
  String get placeholderColorPicker => '選擇顏色';

  @override
  String get buttonPrevious => '上一步';

  @override
  String get buttonNext => '下一步';

  @override
  String get refreshTriggerPull => '下拉以重新整理';

  @override
  String get refreshTriggerRelease => '放開以重新整理';

  @override
  String get refreshTriggerRefreshing => '正在重新整理...';

  @override
  String get refreshTriggerComplete => '重新整理完成';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => '上移';

  @override
  String get commandMoveDown => '下移';

  @override
  String get commandActivate => '選擇';

  @override
  String get timeDaysAbbreviation => '日';

  @override
  String get timeHoursAbbreviation => '時';

  @override
  String get timeMinutesAbbreviation => '分';

  @override
  String get timeSecondsAbbreviation => '秒';

  @override
  String get placeholderDurationPicker => '選擇時間長度';

  @override
  String get durationDay => '天';

  @override
  String get durationHour => '小時';

  @override
  String get durationMinute => '分鐘';

  @override
  String get durationSecond => '秒';
}
