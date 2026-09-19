// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Malay (`ms`).
class ShadcnLocalizationsMs extends ShadcnLocalizations {
  /// Creates the Malay localizations.
  ShadcnLocalizationsMs([super.locale = 'ms']);

  @override
  String get formNotEmpty => 'Medan ini tidak boleh kosong';

  @override
  String get invalidValue => 'Nilai tidak sah';

  @override
  String get invalidEmail => 'E-mel tidak sah';

  @override
  String get invalidURL => 'URL tidak sah';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Mesti kurang daripada $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Mesti lebih daripada $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Mesti kurang daripada atau sama dengan $valueString';
  }

  String get formPhoneNumberInvalid => 'Nombor telefon tidak sah';

  String get formPhoneNumberEmpty => 'Nombor telefon diperlukan';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Mesti lebih daripada atau sama dengan $valueString';
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

    return 'Mesti antara $minString dan $maxString (termasuk)';
  }

  String formEqualTo(String value) {
    return 'Mesti sama dengan ${value}';
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

    return 'Mesti antara $minString dan $maxString (tidak termasuk)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Mesti sekurang-kurangnya ${value} aksara';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Mesti tidak melebihi ${value} aksara';
  }

  @override
  String get formPasswordDigits => 'Mesti mengandungi sekurang-kurangnya satu digit';

  @override
  String get formPasswordLowercase => 'Mesti mengandungi sekurang-kurangnya satu huruf kecil';

  @override
  String get formPasswordUppercase => 'Mesti mengandungi sekurang-kurangnya satu huruf besar';

  @override
  String get formPasswordSpecial => 'Mesti mengandungi sekurang-kurangnya satu aksara khas';

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

  String get noSpellCheckReplacements => 'Tiada cadangan ditemui';

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
  String get colorPickerTabRecent => 'Terkini';

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
  String dataTableSelectedRows(int count, int total) {
    return '${count} daripada ${total} baris dipilih.';
  }

  @override
  String get dataTableNext => 'Seterusnya';

  @override
  String get dataTablePrevious => 'Sebelumnya';

  @override
  String get dataTableColumns => 'Lajur';

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
