import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Turkish (`tr`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsTr extends ShadcnLocalizations {
  /// Creates the Turkish strings.
  const ShadcnLocalizationsTr([super.locale = const Locale('tr')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Bu alan boş bırakılamaz';

  @override
  String get invalidValue => 'Geçersiz değer';

  @override
  String get invalidEmail => 'Geçersiz e-posta adresi';

  @override
  String get invalidURL => 'Geçersiz URL';

  @override
  String formLessThan(Object? value) =>
      '${_number(value)} değerinden küçük olmalıdır';

  @override
  String formGreaterThan(Object? value) =>
      '${_number(value)} değerinden büyük olmalıdır';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      '${_number(value)} değerinden küçük veya ona eşit olmalıdır';

  @override
  String get formPhoneNumberInvalid => 'Telefon numarası geçersiz';

  @override
  String get formPhoneNumberEmpty => 'Telefon numarası gereklidir';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      '${_number(value)} değerinden büyük veya ona eşit olmalıdır';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      '${_number(min)} ile ${_number(max)} arasında olmalıdır (uçlar dahil)';

  @override
  String formEqualTo(Object? value) =>
      '${_number(value)} değerine eşit olmalıdır';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      '${_number(min)} ile ${_number(max)} arasında olmalıdır (uçlar hariç)';

  @override
  String formLengthLessThan(int limit) => 'En az $limit karakter olmalıdır';

  @override
  String formLengthGreaterThan(int limit) =>
      'En fazla $limit karakter olmalıdır';

  @override
  String get formPasswordDigits => 'En az bir rakam içermelidir';

  @override
  String get formPasswordLowercase => 'En az bir küçük harf içermelidir';

  @override
  String get formPasswordUppercase => 'En az bir büyük harf içermelidir';

  @override
  String get formPasswordSpecial => 'En az bir özel karakter içermelidir';

  @override
  String get commandSearch => 'Bir komut yazın veya arayın...';

  @override
  String get commandEmpty => 'Sonuç bulunamadı.';

  @override
  String get datePickerSelectYear => 'Bir yıl seçin';

  @override
  String get abbreviatedMonday => 'Pzt';

  @override
  String get abbreviatedTuesday => 'Sal';

  @override
  String get abbreviatedWednesday => 'Çar';

  @override
  String get abbreviatedThursday => 'Per';

  @override
  String get abbreviatedFriday => 'Cum';

  @override
  String get abbreviatedSaturday => 'Cmt';

  @override
  String get abbreviatedSunday => 'Paz';

  @override
  String get monthJanuary => 'Ocak';

  @override
  String get monthFebruary => 'Şubat';

  @override
  String get monthMarch => 'Mart';

  @override
  String get monthApril => 'Nisan';

  @override
  String get monthMay => 'Mayıs';

  @override
  String get monthJune => 'Haziran';

  @override
  String get monthJuly => 'Temmuz';

  @override
  String get monthAugust => 'Ağustos';

  @override
  String get monthSeptember => 'Eylül';

  @override
  String get monthOctober => 'Ekim';

  @override
  String get monthNovember => 'Kasım';

  @override
  String get monthDecember => 'Aralık';

  @override
  String get abbreviatedJanuary => 'Oca';

  @override
  String get abbreviatedFebruary => 'Şub';

  @override
  String get abbreviatedMarch => 'Mar';

  @override
  String get abbreviatedApril => 'Nis';

  @override
  String get abbreviatedMay => 'May';

  @override
  String get abbreviatedJune => 'Haz';

  @override
  String get abbreviatedJuly => 'Tem';

  @override
  String get abbreviatedAugust => 'Ağu';

  @override
  String get abbreviatedSeptember => 'Eyl';

  @override
  String get abbreviatedOctober => 'Eki';

  @override
  String get abbreviatedNovember => 'Kas';

  @override
  String get abbreviatedDecember => 'Ara';

  @override
  String get dialogDismiss => 'Kapat';

  @override
  String get buttonCancel => 'İptal';

  @override
  String get buttonSave => 'Kaydet';

  @override
  String get timeHour => 'Saat';

  @override
  String get timeMinute => 'Dakika';

  @override
  String get timeSecond => 'Saniye';

  @override
  String get timeAM => 'ÖÖ';

  @override
  String get timePM => 'ÖS';

  @override
  String get colorRed => 'Kırmızı';

  @override
  String get colorGreen => 'Yeşil';

  @override
  String get colorBlue => 'Mavi';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Ton';

  @override
  String get colorSaturation => 'Doy';

  @override
  String get colorValue => 'Değ';

  @override
  String get colorLightness => 'Aç';

  @override
  String get menuCut => 'Kes';

  @override
  String get menuCopy => 'Kopyala';

  @override
  String get menuPaste => 'Yapıştır';

  @override
  String get menuSelectAll => 'Tümünü Seç';

  @override
  String get menuUndo => 'Geri Al';

  @override
  String get menuRedo => 'Yinele';

  @override
  String get menuDelete => 'Sil';

  @override
  String get menuShare => 'Paylaş';

  @override
  String get menuSearchWeb => 'Web\'de Ara';

  @override
  String get menuLiveTextInput => 'Canlı Metin';

  @override
  String get placeholderDatePicker => 'Bir tarih seçin';

  @override
  String get placeholderTimePicker => 'Bir saat seçin';

  @override
  String get placeholderColorPicker => 'Bir renk seçin';

  @override
  String get buttonPrevious => 'Önceki';

  @override
  String get buttonNext => 'Sonraki';

  @override
  String get refreshTriggerPull => 'Yenilemek için çekin';

  @override
  String get refreshTriggerRelease => 'Yenilemek için bırakın';

  @override
  String get refreshTriggerRefreshing => 'Yenileniyor...';

  @override
  String get refreshTriggerComplete => 'Yenileme tamamlandı';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Yukarı Taşı';

  @override
  String get commandMoveDown => 'Aşağı Taşı';

  @override
  String get commandActivate => 'Seç';

  @override
  String get timeDaysAbbreviation => 'GG';

  @override
  String get timeHoursAbbreviation => 'SS';

  @override
  String get timeMinutesAbbreviation => 'DD';

  @override
  String get timeSecondsAbbreviation => 'SN';

  @override
  String get placeholderDurationPicker => 'Bir süre seçin';

  @override
  String get durationDay => 'Gün';

  @override
  String get durationHour => 'Saat';

  @override
  String get durationMinute => 'Dakika';

  @override
  String get durationSecond => 'Saniye';
}
