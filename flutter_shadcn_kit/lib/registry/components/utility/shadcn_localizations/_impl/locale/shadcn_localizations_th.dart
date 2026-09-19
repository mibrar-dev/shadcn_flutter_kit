// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Thai (`th`).
class ShadcnLocalizationsTh extends ShadcnLocalizations {
  /// Creates the Thai localizations.
  ShadcnLocalizationsTh([super.locale = 'th']);

  @override
  String get formNotEmpty => 'ต้องกรอกข้อมูลในช่องนี้';

  @override
  String get invalidValue => 'ค่าไม่ถูกต้อง';

  @override
  String get invalidEmail => 'อีเมลไม่ถูกต้อง';

  @override
  String get invalidURL => 'URL ไม่ถูกต้อง';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'ต้องน้อยกว่า $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'ต้องมากกว่า $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'ต้องน้อยกว่าหรือเท่ากับ $valueString';
  }

  String get formPhoneNumberInvalid => 'หมายเลขโทรศัพท์ไม่ถูกต้อง';

  String get formPhoneNumberEmpty => 'ต้องระบุหมายเลขโทรศัพท์';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'ต้องมากกว่าหรือเท่ากับ $valueString';
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

    return 'ต้องอยู่ระหว่าง $minString ถึง $maxString (รวมค่าปลาย)';
  }

  String formEqualTo(String value) {
    return 'ต้องเท่ากับ ${value}';
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

    return 'ต้องอยู่ระหว่าง $minString ถึง $maxString (ไม่รวมค่าปลาย)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'ต้องมีอย่างน้อย ${value} ตัวอักษร';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'ต้องมีไม่เกิน ${value} ตัวอักษร';
  }

  @override
  String get formPasswordDigits => 'ต้องมีตัวเลขอย่างน้อยหนึ่งตัว';

  @override
  String get formPasswordLowercase => 'ต้องมีตัวพิมพ์เล็กอย่างน้อยหนึ่งตัว';

  @override
  String get formPasswordUppercase => 'ต้องมีตัวพิมพ์ใหญ่อย่างน้อยหนึ่งตัว';

  @override
  String get formPasswordSpecial => 'ต้องมีอักขระพิเศษอย่างน้อยหนึ่งตัว';

  @override
  String get commandSearch => 'พิมพ์คำสั่งหรือค้นหา...';

  @override
  String get commandEmpty => 'ไม่พบผลลัพธ์';

  @override
  String get datePickerSelectYear => 'เลือกปี';

  @override
  String get abbreviatedMonday => 'จ.';

  @override
  String get abbreviatedTuesday => 'อ.';

  @override
  String get abbreviatedWednesday => 'พ.';

  @override
  String get abbreviatedThursday => 'พฤ.';

  @override
  String get abbreviatedFriday => 'ศ.';

  @override
  String get abbreviatedSaturday => 'ส.';

  @override
  String get abbreviatedSunday => 'อา.';

  @override
  String get monthJanuary => 'มกราคม';

  @override
  String get monthFebruary => 'กุมภาพันธ์';

  @override
  String get monthMarch => 'มีนาคม';

  @override
  String get monthApril => 'เมษายน';

  @override
  String get monthMay => 'พฤษภาคม';

  @override
  String get monthJune => 'มิถุนายน';

  @override
  String get monthJuly => 'กรกฎาคม';

  @override
  String get monthAugust => 'สิงหาคม';

  @override
  String get monthSeptember => 'กันยายน';

  @override
  String get monthOctober => 'ตุลาคม';

  @override
  String get monthNovember => 'พฤศจิกายน';

  @override
  String get monthDecember => 'ธันวาคม';

  @override
  String get abbreviatedJanuary => 'ม.ค.';

  @override
  String get abbreviatedFebruary => 'ก.พ.';

  @override
  String get abbreviatedMarch => 'มี.ค.';

  @override
  String get abbreviatedApril => 'เม.ย.';

  @override
  String get abbreviatedMay => 'พ.ค.';

  @override
  String get abbreviatedJune => 'มิ.ย.';

  @override
  String get abbreviatedJuly => 'ก.ค.';

  @override
  String get abbreviatedAugust => 'ส.ค.';

  @override
  String get abbreviatedSeptember => 'ก.ย.';

  @override
  String get abbreviatedOctober => 'ต.ค.';

  @override
  String get abbreviatedNovember => 'พ.ย.';

  @override
  String get abbreviatedDecember => 'ธ.ค.';

  @override
  String get buttonCancel => 'ยกเลิก';

  @override
  String get buttonSave => 'บันทึก';

  @override
  String get timeHour => 'ชั่วโมง';

  @override
  String get timeMinute => 'นาที';

  @override
  String get timeSecond => 'วินาที';

  @override
  String get timeAM => 'ก่อนเที่ยง';

  @override
  String get timePM => 'หลังเที่ยง';

  @override
  String get colorRed => 'แดง';

  @override
  String get colorGreen => 'เขียว';

  @override
  String get colorBlue => 'น้ำเงิน';

  @override
  String get colorAlpha => 'อัลฟา';

  @override
  String get colorHue => 'เฉดสี';

  @override
  String get colorSaturation => 'ความอิ่มสี';

  @override
  String get colorValue => 'ความสว่าง';

  @override
  String get colorLightness => 'ความจ้า';

  @override
  String get menuCut => 'ตัด';

  @override
  String get menuCopy => 'คัดลอก';

  @override
  String get menuPaste => 'วาง';

  @override
  String get menuSelectAll => 'เลือกทั้งหมด';

  String get noSpellCheckReplacements => 'ไม่พบคำแนะนำ';

  @override
  String get menuUndo => 'เลิกทำ';

  @override
  String get menuRedo => 'ทำซ้ำ';

  @override
  String get menuDelete => 'ลบ';

  @override
  String get menuShare => 'แชร์';

  @override
  String get menuSearchWeb => 'ค้นหาบนเว็บ';

  @override
  String get menuLiveTextInput => 'ข้อความสด';

  @override
  String get placeholderDatePicker => 'เลือกวันที่';

  @override
  String get placeholderTimePicker => 'เลือกเวลา';

  @override
  String get placeholderColorPicker => 'เลือกสี';

  @override
  String get buttonPrevious => 'ก่อนหน้า';

  @override
  String get buttonNext => 'ถัดไป';

  @override
  String get refreshTriggerPull => 'ดึงเพื่อรีเฟรช';

  @override
  String get refreshTriggerRelease => 'ปล่อยเพื่อรีเฟรช';

  @override
  String get refreshTriggerRefreshing => 'กำลังรีเฟรช...';

  @override
  String get refreshTriggerComplete => 'รีเฟรชเสร็จสิ้น';

  @override
  String get colorPickerTabRecent => 'ล่าสุด';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'เลื่อนขึ้น';

  @override
  String get commandMoveDown => 'เลื่อนลง';

  @override
  String get commandActivate => 'เลือก';

  @override
  String dataTableSelectedRows(int count, int total) {
    return 'เลือกแล้ว ${count} จาก ${total} แถว';
  }

  @override
  String get dataTableNext => 'ถัดไป';

  @override
  String get dataTablePrevious => 'ก่อนหน้า';

  @override
  String get dataTableColumns => 'คอลัมน์';

  @override
  String get timeDaysAbbreviation => 'วว';

  @override
  String get timeHoursAbbreviation => 'ชช';

  @override
  String get timeMinutesAbbreviation => 'นน';

  @override
  String get timeSecondsAbbreviation => 'วว';

  @override
  String get placeholderDurationPicker => 'เลือกระยะเวลา';

  @override
  String get durationDay => 'วัน';

  @override
  String get durationHour => 'ชั่วโมง';

  @override
  String get durationMinute => 'นาที';

  @override
  String get durationSecond => 'วินาที';
}
