// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Korean (`ko`).
class ShadcnLocalizationsKo extends ShadcnLocalizations {
  /// Creates the Korean localizations.
  ShadcnLocalizationsKo([super.locale = 'ko']);

  @override
  String get formNotEmpty => '이 항목은 비워 둘 수 없습니다';

  @override
  String get invalidValue => '잘못된 값입니다';

  @override
  String get invalidEmail => '잘못된 이메일 주소입니다';

  @override
  String get invalidURL => '잘못된 URL입니다';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString보다 작아야 합니다';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString보다 커야 합니다';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString 이하여야 합니다';
  }

  String get formPhoneNumberInvalid => '전화번호가 잘못되었습니다';

  String get formPhoneNumberEmpty => '전화번호를 입력하세요';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString 이상이어야 합니다';
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

    return '$minString에서 $maxString 사이여야 합니다 (경계 포함)';
  }

  String formEqualTo(String value) {
    return '${value}와(과) 같아야 합니다';
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

    return '$minString에서 $maxString 사이여야 합니다 (경계 제외)';
  }

  @override
  String formLengthLessThan(int value) {
    return '${value}자 이상이어야 합니다';
  }

  @override
  String formLengthGreaterThan(int value) {
    return '${value}자 이하여야 합니다';
  }

  @override
  String get formPasswordDigits => '숫자를 하나 이상 포함해야 합니다';

  @override
  String get formPasswordLowercase => '소문자를 하나 이상 포함해야 합니다';

  @override
  String get formPasswordUppercase => '대문자를 하나 이상 포함해야 합니다';

  @override
  String get formPasswordSpecial => '특수문자를 하나 이상 포함해야 합니다';

  @override
  String get commandSearch => '명령어를 입력하거나 검색하세요...';

  @override
  String get commandEmpty => '결과가 없습니다.';

  @override
  String get datePickerSelectYear => '연도 선택';

  @override
  String get abbreviatedMonday => '월';

  @override
  String get abbreviatedTuesday => '화';

  @override
  String get abbreviatedWednesday => '수';

  @override
  String get abbreviatedThursday => '목';

  @override
  String get abbreviatedFriday => '금';

  @override
  String get abbreviatedSaturday => '토';

  @override
  String get abbreviatedSunday => '일';

  @override
  String get monthJanuary => '1월';

  @override
  String get monthFebruary => '2월';

  @override
  String get monthMarch => '3월';

  @override
  String get monthApril => '4월';

  @override
  String get monthMay => '5월';

  @override
  String get monthJune => '6월';

  @override
  String get monthJuly => '7월';

  @override
  String get monthAugust => '8월';

  @override
  String get monthSeptember => '9월';

  @override
  String get monthOctober => '10월';

  @override
  String get monthNovember => '11월';

  @override
  String get monthDecember => '12월';

  @override
  String get abbreviatedJanuary => '1월';

  @override
  String get abbreviatedFebruary => '2월';

  @override
  String get abbreviatedMarch => '3월';

  @override
  String get abbreviatedApril => '4월';

  @override
  String get abbreviatedMay => '5월';

  @override
  String get abbreviatedJune => '6월';

  @override
  String get abbreviatedJuly => '7월';

  @override
  String get abbreviatedAugust => '8월';

  @override
  String get abbreviatedSeptember => '9월';

  @override
  String get abbreviatedOctober => '10월';

  @override
  String get abbreviatedNovember => '11월';

  @override
  String get abbreviatedDecember => '12월';

  @override
  String get buttonCancel => '취소';

  @override
  String get buttonSave => '저장';

  @override
  String get timeHour => '시';

  @override
  String get timeMinute => '분';

  @override
  String get timeSecond => '초';

  @override
  String get timeAM => '오전';

  @override
  String get timePM => '오후';

  @override
  String get colorRed => '빨강';

  @override
  String get colorGreen => '초록';

  @override
  String get colorBlue => '파랑';

  @override
  String get colorAlpha => '알파';

  @override
  String get colorHue => '색조';

  @override
  String get colorSaturation => '채도';

  @override
  String get colorValue => '명도';

  @override
  String get colorLightness => '휘도';

  @override
  String get menuCut => '잘라내기';

  @override
  String get menuCopy => '복사';

  @override
  String get menuPaste => '붙여넣기';

  @override
  String get menuSelectAll => '전체 선택';

  String get noSpellCheckReplacements => '추천 단어가 없습니다';

  @override
  String get menuUndo => '실행 취소';

  @override
  String get menuRedo => '다시 실행';

  @override
  String get menuDelete => '삭제';

  @override
  String get menuShare => '공유';

  @override
  String get menuSearchWeb => '웹에서 검색';

  @override
  String get menuLiveTextInput => '라이브 텍스트';

  @override
  String get placeholderDatePicker => '날짜 선택';

  @override
  String get placeholderTimePicker => '시간 선택';

  @override
  String get placeholderColorPicker => '색상 선택';

  @override
  String get buttonPrevious => '이전';

  @override
  String get buttonNext => '다음';

  @override
  String get refreshTriggerPull => '당겨서 새로 고침';

  @override
  String get refreshTriggerRelease => '놓아서 새로 고침';

  @override
  String get refreshTriggerRefreshing => '새로 고치는 중...';

  @override
  String get refreshTriggerComplete => '새로 고침 완료';

  @override
  String get colorPickerTabRecent => '최근';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => '위로 이동';

  @override
  String get commandMoveDown => '아래로 이동';

  @override
  String get commandActivate => '선택';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${total}개 행 중 ${count}개 선택됨.';
  }

  @override
  String get dataTableNext => '다음';

  @override
  String get dataTablePrevious => '이전';

  @override
  String get dataTableColumns => '열';

  @override
  String get timeDaysAbbreviation => '일';

  @override
  String get timeHoursAbbreviation => '시';

  @override
  String get timeMinutesAbbreviation => '분';

  @override
  String get timeSecondsAbbreviation => '초';

  @override
  String get placeholderDurationPicker => '기간 선택';

  @override
  String get durationDay => '일';

  @override
  String get durationHour => '시간';

  @override
  String get durationMinute => '분';

  @override
  String get durationSecond => '초';
}
