// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Indonesian (`id`).
class ShadcnLocalizationsId extends ShadcnLocalizations {
  /// Creates the Indonesian localizations.
  ShadcnLocalizationsId([super.locale = 'id']);

  @override
  String get formNotEmpty => 'Kolom ini tidak boleh kosong';

  @override
  String get invalidValue => 'Nilai tidak valid';

  @override
  String get invalidEmail => 'Email tidak valid';

  @override
  String get invalidURL => 'URL tidak valid';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Harus kurang dari $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Harus lebih dari $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Harus kurang dari atau sama dengan $valueString';
  }

  String get formPhoneNumberInvalid => 'Nomor telepon tidak valid';

  String get formPhoneNumberEmpty => 'Nomor telepon wajib diisi';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Harus lebih dari atau sama dengan $valueString';
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

    return 'Harus antara $minString dan $maxString (inklusif)';
  }

  String formEqualTo(String value) {
    return 'Harus sama dengan ${value}';
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

    return 'Harus antara $minString dan $maxString (eksklusif)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Harus terdiri dari minimal ${value} karakter';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Harus terdiri dari maksimal ${value} karakter';
  }

  @override
  String get formPasswordDigits => 'Harus mengandung minimal satu angka';

  @override
  String get formPasswordLowercase => 'Harus mengandung minimal satu huruf kecil';

  @override
  String get formPasswordUppercase => 'Harus mengandung minimal satu huruf kapital';

  @override
  String get formPasswordSpecial => 'Harus mengandung minimal satu karakter khusus';

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

  String get noSpellCheckReplacements => 'Tidak ada saran';

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
  String get colorPickerTabRecent => 'Terbaru';

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
  String dataTableSelectedRows(int count, int total) {
    return '${count} dari ${total} baris dipilih.';
  }

  @override
  String get dataTableNext => 'Berikutnya';

  @override
  String get dataTablePrevious => 'Sebelumnya';

  @override
  String get dataTableColumns => 'Kolom';

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
