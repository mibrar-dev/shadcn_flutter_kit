// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Chinese (Hant) (`zh_Hant`).
class ShadcnLocalizationsZhHant extends ShadcnLocalizations {
  /// Creates the Chinese (Hant) localizations.
  ShadcnLocalizationsZhHant([super.locale = 'zh_Hant']);

  @override
  String get formNotEmpty => '此欄位不能為空';

  @override
  String get invalidValue => '無效的值';

  @override
  String get invalidEmail => '無效的電子郵件地址';

  @override
  String get invalidURL => '無效的網址';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '必須小於 $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '必須大於 $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '必須小於或等於 $valueString';
  }

  String get formPhoneNumberInvalid => '電話號碼無效';

  String get formPhoneNumberEmpty => '請輸入電話號碼';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '必須大於或等於 $valueString';
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

    return '必須介於 $minString 和 $maxString 之間（含端點）';
  }

  String formEqualTo(String value) {
    return '必須等於 ${value}';
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

    return '必須介於 $minString 和 $maxString 之間（不含端點）';
  }

  @override
  String formLengthLessThan(int value) {
    return '至少需要 ${value} 個字元';
  }

  @override
  String formLengthGreaterThan(int value) {
    return '最多只能有 ${value} 個字元';
  }

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

  String get noSpellCheckReplacements => '找不到建議';

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
  String get colorPickerTabRecent => '最近';

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
  String dataTableSelectedRows(int count, int total) {
    return '已選擇 ${total} 列中的 ${count} 列。';
  }

  @override
  String get dataTableNext => '下一頁';

  @override
  String get dataTablePrevious => '上一頁';

  @override
  String get dataTableColumns => '欄';

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
