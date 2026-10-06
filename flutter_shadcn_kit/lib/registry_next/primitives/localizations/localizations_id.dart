import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Indonesian (`id`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsId extends ShadcnLocalizations {
  /// Creates the Indonesian strings.
  const ShadcnLocalizationsId([super.locale = const Locale('id')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Kolom ini tidak boleh kosong';

  @override
  String get invalidValue => 'Nilai tidak valid';

  @override
  String get invalidEmail => 'Email tidak valid';

  @override
  String get invalidURL => 'URL tidak valid';

  @override
  String formLessThan(Object? value) => 'Harus kurang dari ${_number(value)}';

  @override
  String formGreaterThan(Object? value) => 'Harus lebih dari ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Harus kurang dari atau sama dengan ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Nomor telepon tidak valid';

  @override
  String get formPhoneNumberEmpty => 'Nomor telepon wajib diisi';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Harus lebih dari atau sama dengan ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Harus antara ${_number(min)} dan ${_number(max)} (inklusif)';

  @override
  String formEqualTo(Object? value) => 'Harus sama dengan ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Harus antara ${_number(min)} dan ${_number(max)} (eksklusif)';

  @override
  String formLengthLessThan(int limit) =>
      'Harus terdiri dari minimal $limit karakter';

  @override
  String formLengthGreaterThan(int limit) =>
      'Harus terdiri dari maksimal $limit karakter';

  @override
  String get formPasswordDigits => 'Harus mengandung minimal satu angka';

  @override
  String get formPasswordLowercase =>
      'Harus mengandung minimal satu huruf kecil';

  @override
  String get formPasswordUppercase =>
      'Harus mengandung minimal satu huruf kapital';

  @override
  String get formPasswordSpecial =>
      'Harus mengandung minimal satu karakter khusus';

  @override
  String get commandSearch => 'Ketik perintah atau cari...';

  @override
  String get commandEmpty => 'Tidak ada hasil.';

  @override
  String get datePickerSelectYear => 'Pilih tahun';

  @override
  String get abbreviatedMonday => 'Sen';

  @override
  String get abbreviatedTuesday => 'Sel';

  @override
  String get abbreviatedWednesday => 'Rab';

  @override
  String get abbreviatedThursday => 'Kam';

  @override
  String get abbreviatedFriday => 'Jum';

  @override
  String get abbreviatedSaturday => 'Sab';

  @override
  String get abbreviatedSunday => 'Min';

  @override
  String get monthJanuary => 'Januari';

  @override
  String get monthFebruary => 'Februari';

  @override
  String get monthMarch => 'Maret';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Mei';

  @override
  String get monthJune => 'Juni';

  @override
  String get monthJuly => 'Juli';

  @override
  String get monthAugust => 'Agustus';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'Desember';

  @override
  String get abbreviatedJanuary => 'Jan';

  @override
  String get abbreviatedFebruary => 'Feb';

  @override
  String get abbreviatedMarch => 'Mar';

  @override
  String get abbreviatedApril => 'Apr';

  @override
  String get abbreviatedMay => 'Mei';

  @override
  String get abbreviatedJune => 'Jun';

  @override
  String get abbreviatedJuly => 'Jul';

  @override
  String get abbreviatedAugust => 'Agu';

  @override
  String get abbreviatedSeptember => 'Sep';

  @override
  String get abbreviatedOctober => 'Okt';

  @override
  String get abbreviatedNovember => 'Nov';

  @override
  String get abbreviatedDecember => 'Des';

  @override
  String get buttonCancel => 'Batal';

  @override
  String get buttonSave => 'Simpan';

  @override
  String get timeHour => 'Jam';

  @override
  String get timeMinute => 'Menit';

  @override
  String get timeSecond => 'Detik';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

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
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Potong';

  @override
  String get menuCopy => 'Salin';

  @override
  String get menuPaste => 'Tempel';

  @override
  String get menuSelectAll => 'Pilih Semua';

  @override
  String get menuUndo => 'Urungkan';

  @override
  String get menuRedo => 'Ulangi';

  @override
  String get menuDelete => 'Hapus';

  @override
  String get menuShare => 'Bagikan';

  @override
  String get menuSearchWeb => 'Cari di Web';

  @override
  String get menuLiveTextInput => 'Teks Langsung';

  @override
  String get placeholderDatePicker => 'Pilih tanggal';

  @override
  String get placeholderTimePicker => 'Pilih waktu';

  @override
  String get placeholderColorPicker => 'Pilih warna';

  @override
  String get buttonPrevious => 'Sebelumnya';

  @override
  String get buttonNext => 'Berikutnya';

  @override
  String get refreshTriggerPull => 'Tarik untuk menyegarkan';

  @override
  String get refreshTriggerRelease => 'Lepaskan untuk menyegarkan';

  @override
  String get refreshTriggerRefreshing => 'Menyegarkan...';

  @override
  String get refreshTriggerComplete => 'Penyegaran selesai';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Naik';

  @override
  String get commandMoveDown => 'Turun';

  @override
  String get commandActivate => 'Pilih';

  @override
  String get timeDaysAbbreviation => 'HH';

  @override
  String get timeHoursAbbreviation => 'JJ';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'DD';

  @override
  String get placeholderDurationPicker => 'Pilih durasi';

  @override
  String get durationDay => 'Hari';

  @override
  String get durationHour => 'Jam';

  @override
  String get durationMinute => 'Menit';

  @override
  String get durationSecond => 'Detik';
}
