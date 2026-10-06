import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Vietnamese (`vi`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsVi extends ShadcnLocalizations {
  /// Creates the Vietnamese strings.
  const ShadcnLocalizationsVi([super.locale = const Locale('vi')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Trường này không được để trống';

  @override
  String get invalidValue => 'Giá trị không hợp lệ';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get invalidURL => 'URL không hợp lệ';

  @override
  String formLessThan(Object? value) => 'Phải nhỏ hơn ${_number(value)}';

  @override
  String formGreaterThan(Object? value) => 'Phải lớn hơn ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Phải nhỏ hơn hoặc bằng ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Số điện thoại không hợp lệ';

  @override
  String get formPhoneNumberEmpty => 'Vui lòng nhập số điện thoại';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Phải lớn hơn hoặc bằng ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Phải nằm trong khoảng ${_number(min)} đến ${_number(max)} (bao gồm hai đầu)';

  @override
  String formEqualTo(Object? value) => 'Phải bằng ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Phải nằm trong khoảng ${_number(min)} đến ${_number(max)} (không bao gồm hai đầu)';

  @override
  String formLengthLessThan(int limit) => 'Phải có ít nhất $limit ký tự';

  @override
  String formLengthGreaterThan(int limit) => 'Chỉ được tối đa $limit ký tự';

  @override
  String get formPasswordDigits => 'Phải chứa ít nhất một chữ số';

  @override
  String get formPasswordLowercase => 'Phải chứa ít nhất một chữ thường';

  @override
  String get formPasswordUppercase => 'Phải chứa ít nhất một chữ hoa';

  @override
  String get formPasswordSpecial => 'Phải chứa ít nhất một ký tự đặc biệt';

  @override
  String get commandSearch => 'Nhập lệnh hoặc tìm kiếm...';

  @override
  String get commandEmpty => 'Không tìm thấy kết quả.';

  @override
  String get datePickerSelectYear => 'Chọn năm';

  @override
  String get abbreviatedMonday => 'T2';

  @override
  String get abbreviatedTuesday => 'T3';

  @override
  String get abbreviatedWednesday => 'T4';

  @override
  String get abbreviatedThursday => 'T5';

  @override
  String get abbreviatedFriday => 'T6';

  @override
  String get abbreviatedSaturday => 'T7';

  @override
  String get abbreviatedSunday => 'CN';

  @override
  String get monthJanuary => 'Tháng 1';

  @override
  String get monthFebruary => 'Tháng 2';

  @override
  String get monthMarch => 'Tháng 3';

  @override
  String get monthApril => 'Tháng 4';

  @override
  String get monthMay => 'Tháng 5';

  @override
  String get monthJune => 'Tháng 6';

  @override
  String get monthJuly => 'Tháng 7';

  @override
  String get monthAugust => 'Tháng 8';

  @override
  String get monthSeptember => 'Tháng 9';

  @override
  String get monthOctober => 'Tháng 10';

  @override
  String get monthNovember => 'Tháng 11';

  @override
  String get monthDecember => 'Tháng 12';

  @override
  String get abbreviatedJanuary => 'Th1';

  @override
  String get abbreviatedFebruary => 'Th2';

  @override
  String get abbreviatedMarch => 'Th3';

  @override
  String get abbreviatedApril => 'Th4';

  @override
  String get abbreviatedMay => 'Th5';

  @override
  String get abbreviatedJune => 'Th6';

  @override
  String get abbreviatedJuly => 'Th7';

  @override
  String get abbreviatedAugust => 'Th8';

  @override
  String get abbreviatedSeptember => 'Th9';

  @override
  String get abbreviatedOctober => 'Th10';

  @override
  String get abbreviatedNovember => 'Th11';

  @override
  String get abbreviatedDecember => 'Th12';

  @override
  String get dialogDismiss => 'Bỏ qua';

  @override
  String get buttonCancel => 'Hủy';

  @override
  String get buttonSave => 'Lưu';

  @override
  String get timeHour => 'Giờ';

  @override
  String get timeMinute => 'Phút';

  @override
  String get timeSecond => 'Giây';

  @override
  String get timeAM => 'SA';

  @override
  String get timePM => 'CH';

  @override
  String get colorRed => 'Đỏ';

  @override
  String get colorGreen => 'Lục';

  @override
  String get colorBlue => 'Lam';

  @override
  String get colorAlpha => 'Alpha';

  @override
  String get colorHue => 'Sắc độ';

  @override
  String get colorSaturation => 'Bão hòa';

  @override
  String get colorValue => 'Độ sáng';

  @override
  String get colorLightness => 'Độ chói';

  @override
  String get menuCut => 'Cắt';

  @override
  String get menuCopy => 'Sao chép';

  @override
  String get menuPaste => 'Dán';

  @override
  String get menuSelectAll => 'Chọn tất cả';

  @override
  String get menuUndo => 'Hoàn tác';

  @override
  String get menuRedo => 'Làm lại';

  @override
  String get menuDelete => 'Xóa';

  @override
  String get menuShare => 'Chia sẻ';

  @override
  String get menuSearchWeb => 'Tìm trên web';

  @override
  String get menuLiveTextInput => 'Văn bản trực tiếp';

  @override
  String get placeholderDatePicker => 'Chọn ngày';

  @override
  String get placeholderTimePicker => 'Chọn giờ';

  @override
  String get placeholderColorPicker => 'Chọn màu';

  @override
  String get buttonPrevious => 'Trước';

  @override
  String get buttonNext => 'Tiếp';

  @override
  String get refreshTriggerPull => 'Kéo để làm mới';

  @override
  String get refreshTriggerRelease => 'Thả để làm mới';

  @override
  String get refreshTriggerRefreshing => 'Đang làm mới...';

  @override
  String get refreshTriggerComplete => 'Đã làm mới xong';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Di chuyển lên';

  @override
  String get commandMoveDown => 'Di chuyển xuống';

  @override
  String get commandActivate => 'Chọn';

  @override
  String get timeDaysAbbreviation => 'NN';

  @override
  String get timeHoursAbbreviation => 'GG';

  @override
  String get timeMinutesAbbreviation => 'PP';

  @override
  String get timeSecondsAbbreviation => 'GY';

  @override
  String get placeholderDurationPicker => 'Chọn khoảng thời gian';

  @override
  String get durationDay => 'Ngày';

  @override
  String get durationHour => 'Giờ';

  @override
  String get durationMinute => 'Phút';

  @override
  String get durationSecond => 'Giây';
}
