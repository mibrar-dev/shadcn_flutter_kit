// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Japanese (`ja`).
class ShadcnLocalizationsJa extends ShadcnLocalizations {
  /// Creates the Japanese localizations.
  ShadcnLocalizationsJa([super.locale = 'ja']);

  @override
  String get formNotEmpty => 'この項目は必須です';

  @override
  String get invalidValue => '無効な値です';

  @override
  String get invalidEmail => '無効なメールアドレスです';

  @override
  String get invalidURL => '無効なURLです';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString 未満である必要があります';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString より大きい必要があります';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString 以下である必要があります';
  }

  String get formPhoneNumberInvalid => '電話番号が無効です';

  String get formPhoneNumberEmpty => '電話番号は必須です';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString 以上である必要があります';
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

    return '$minString 以上 $maxString 以下である必要があります';
  }

  String formEqualTo(String value) {
    return '${value} と等しい必要があります';
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

    return '$minString より大きく $maxString 未満である必要があります';
  }

  @override
  String formLengthLessThan(int value) {
    return '${value} 文字以上で入力してください';
  }

  @override
  String formLengthGreaterThan(int value) {
    return '${value} 文字以内で入力してください';
  }

  @override
  String get formPasswordDigits => '数字を1文字以上含めてください';

  @override
  String get formPasswordLowercase => '小文字を1文字以上含めてください';

  @override
  String get formPasswordUppercase => '大文字を1文字以上含めてください';

  @override
  String get formPasswordSpecial => '記号を1文字以上含めてください';

  @override
  String get commandSearch => 'コマンドを入力または検索...';

  @override
  String get commandEmpty => '結果が見つかりません。';

  @override
  String get datePickerSelectYear => '年を選択';

  @override
  String get abbreviatedMonday => '月';

  @override
  String get abbreviatedTuesday => '火';

  @override
  String get abbreviatedWednesday => '水';

  @override
  String get abbreviatedThursday => '木';

  @override
  String get abbreviatedFriday => '金';

  @override
  String get abbreviatedSaturday => '土';

  @override
  String get abbreviatedSunday => '日';

  @override
  String get monthJanuary => '1月';

  @override
  String get monthFebruary => '2月';

  @override
  String get monthMarch => '3月';

  @override
  String get monthApril => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJune => '6月';

  @override
  String get monthJuly => '7月';

  @override
  String get monthAugust => '8月';

  @override
  String get monthSeptember => '9月';

  @override
  String get monthOctober => '10月';

  @override
  String get monthNovember => '11月';

  @override
  String get monthDecember => '12月';

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
  String get buttonCancel => 'キャンセル';

  @override
  String get buttonSave => '保存';

  @override
  String get timeHour => '時';

  @override
  String get timeMinute => '分';

  @override
  String get timeSecond => '秒';

  @override
  String get timeAM => '午前';

  @override
  String get timePM => '午後';

  @override
  String get colorRed => '赤';

  @override
  String get colorGreen => '緑';

  @override
  String get colorBlue => '青';

  @override
  String get colorAlpha => 'アルファ';

  @override
  String get colorHue => '色相';

  @override
  String get colorSaturation => '彩度';

  @override
  String get colorValue => '明度';

  @override
  String get colorLightness => '輝度';

  @override
  String get menuCut => '切り取り';

  @override
  String get menuCopy => 'コピー';

  @override
  String get menuPaste => '貼り付け';

  @override
  String get menuSelectAll => 'すべて選択';

  String get noSpellCheckReplacements => '候補が見つかりません';

  @override
  String get menuUndo => '元に戻す';

  @override
  String get menuRedo => 'やり直し';

  @override
  String get menuDelete => '削除';

  @override
  String get menuShare => '共有';

  @override
  String get menuSearchWeb => 'ウェブで検索';

  @override
  String get menuLiveTextInput => 'ライブテキスト';

  @override
  String get placeholderDatePicker => '日付を選択';

  @override
  String get placeholderTimePicker => '時刻を選択';

  @override
  String get placeholderColorPicker => '色を選択';

  @override
  String get buttonPrevious => '前へ';

  @override
  String get buttonNext => '次へ';

  @override
  String get refreshTriggerPull => '引っ張って更新';

  @override
  String get refreshTriggerRelease => '離して更新';

  @override
  String get refreshTriggerRefreshing => '更新中...';

  @override
  String get refreshTriggerComplete => '更新が完了しました';

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
  String get commandMoveUp => '上へ移動';

  @override
  String get commandMoveDown => '下へ移動';

  @override
  String get commandActivate => '選択';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${total} 行中 ${count} 行を選択中。';
  }

  @override
  String get dataTableNext => '次へ';

  @override
  String get dataTablePrevious => '前へ';

  @override
  String get dataTableColumns => '列';

  @override
  String get timeDaysAbbreviation => '日';

  @override
  String get timeHoursAbbreviation => '時';

  @override
  String get timeMinutesAbbreviation => '分';

  @override
  String get timeSecondsAbbreviation => '秒';

  @override
  String get placeholderDurationPicker => '期間を選択';

  @override
  String get durationDay => '日';

  @override
  String get durationHour => '時間';

  @override
  String get durationMinute => '分';

  @override
  String get durationSecond => '秒';
}
