import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Malay (`ms`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsMs extends ShadcnLocalizations {
  /// Creates the Malay strings.
  const ShadcnLocalizationsMs([super.locale = const Locale('ms')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Medan ini tidak boleh kosong';

  @override
  String get invalidValue => 'Nilai tidak sah';

  @override
  String get invalidEmail => 'E-mel tidak sah';

  @override
  String get invalidURL => 'URL tidak sah';

  @override
  String formLessThan(Object? value) =>
      'Mesti kurang daripada ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Mesti lebih daripada ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Mesti kurang daripada atau sama dengan ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Nombor telefon tidak sah';

  @override
  String get formPhoneNumberEmpty => 'Nombor telefon diperlukan';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Mesti lebih daripada atau sama dengan ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Mesti antara ${_number(min)} dan ${_number(max)} (termasuk)';

  @override
  String formEqualTo(Object? value) => 'Mesti sama dengan ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Mesti antara ${_number(min)} dan ${_number(max)} (tidak termasuk)';

  @override
  String formLengthLessThan(int limit) =>
      'Mesti sekurang-kurangnya $limit aksara';

  @override
  String formLengthGreaterThan(int limit) =>
      'Mesti tidak melebihi $limit aksara';

  @override
  String get formPasswordDigits =>
      'Mesti mengandungi sekurang-kurangnya satu digit';

  @override
  String get formPasswordLowercase =>
      'Mesti mengandungi sekurang-kurangnya satu huruf kecil';

  @override
  String get formPasswordUppercase =>
      'Mesti mengandungi sekurang-kurangnya satu huruf besar';

  @override
  String get formPasswordSpecial =>
      'Mesti mengandungi sekurang-kurangnya satu aksara khas';

  @override
  String get commandSearch => 'Taip arahan atau cari...';

  @override
  String get commandEmpty => 'Tiada keputusan ditemui.';

  @override
  String get datePickerSelectYear => 'Pilih tahun';

  @override
  String get abbreviatedMonday => 'Isn';

  @override
  String get abbreviatedTuesday => 'Sel';

  @override
  String get abbreviatedWednesday => 'Rab';

  @override
  String get abbreviatedThursday => 'Kha';

  @override
  String get abbreviatedFriday => 'Jum';

  @override
  String get abbreviatedSaturday => 'Sab';

  @override
  String get abbreviatedSunday => 'Ahd';

  @override
  String get monthJanuary => 'Januari';

  @override
  String get monthFebruary => 'Februari';

  @override
  String get monthMarch => 'Mac';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Mei';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'Julai';

  @override
  String get monthAugust => 'Ogos';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'Disember';

  @override
  String get abbreviatedJanuary => 'Jan';

  @override
  String get abbreviatedFebruary => 'Feb';

  @override
  String get abbreviatedMarch => 'Mac';

  @override
  String get abbreviatedApril => 'Apr';

  @override
  String get abbreviatedMay => 'Mei';

  @override
  String get abbreviatedJune => 'Jun';

  @override
  String get abbreviatedJuly => 'Jul';

  @override
  String get abbreviatedAugust => 'Ogo';

  @override
  String get abbreviatedSeptember => 'Sep';

  @override
  String get abbreviatedOctober => 'Okt';

  @override
  String get abbreviatedNovember => 'Nov';

  @override
  String get abbreviatedDecember => 'Dis';

  @override
  String get dialogDismiss => 'Tolak';

  @override
  String get buttonCancel => 'Batal';

  @override
  String get buttonSave => 'Simpan';

  @override
  String get timeHour => 'Jam';

  @override
  String get timeMinute => 'Minit';

  @override
  String get timeSecond => 'Saat';

  @override
  String get timeAM => 'PG';

  @override
  String get timePM => 'PTG';

  @override
  String get colorRed => 'Merah';

  @override
  String get colorGreen => 'Hijau';

  @override
  String get colorBlue => 'Biru';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Rona';

  @override
  String get colorSaturation => 'Ket';

  @override
  String get colorValue => 'Nilai';

  @override
  String get colorLightness => 'Cerah';

  @override
  String get menuCut => 'Potong';

  @override
  String get menuCopy => 'Salin';

  @override
  String get menuPaste => 'Tampal';

  @override
  String get menuSelectAll => 'Pilih Semua';

  @override
  String get menuUndo => 'Buat asal';

  @override
  String get menuRedo => 'Buat semula';

  @override
  String get menuDelete => 'Padam';

  @override
  String get menuShare => 'Kongsi';

  @override
  String get menuSearchWeb => 'Cari di Web';

  @override
  String get menuLiveTextInput => 'Teks Langsung';

  @override
  String get placeholderDatePicker => 'Pilih tarikh';

  @override
  String get placeholderTimePicker => 'Pilih masa';

  @override
  String get placeholderColorPicker => 'Pilih warna';

  @override
  String get buttonPrevious => 'Sebelumnya';

  @override
  String get buttonNext => 'Seterusnya';

  @override
  String get refreshTriggerPull => 'Tarik untuk menyegar semula';

  @override
  String get refreshTriggerRelease => 'Lepaskan untuk menyegar semula';

  @override
  String get refreshTriggerRefreshing => 'Menyegar semula...';

  @override
  String get refreshTriggerComplete => 'Penyegaran semula selesai';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Alih ke atas';

  @override
  String get commandMoveDown => 'Alih ke bawah';

  @override
  String get commandActivate => 'Pilih';

  @override
  String get timeDaysAbbreviation => 'HH';

  @override
  String get timeHoursAbbreviation => 'JJ';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Pilih tempoh';

  @override
  String get durationDay => 'Hari';

  @override
  String get durationHour => 'Jam';

  @override
  String get durationMinute => 'Minit';

  @override
  String get durationSecond => 'Saat';
}
