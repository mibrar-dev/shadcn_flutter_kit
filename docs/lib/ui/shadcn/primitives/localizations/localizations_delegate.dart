import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';

import 'localizations_ar.dart';
import 'localizations_bg.dart';
import 'localizations_bn.dart';
import 'localizations_cs.dart';
import 'localizations_da.dart';
import 'localizations_de.dart';
import 'localizations_el.dart';
import 'localizations_es.dart';
import 'localizations_fa.dart';
import 'localizations_fi.dart';
import 'localizations_fil.dart';
import 'localizations_fr.dart';
import 'localizations_he.dart';
import 'localizations_hi.dart';
import 'localizations_hu.dart';
import 'localizations_id.dart';
import 'localizations_it.dart';
import 'localizations_ja.dart';
import 'localizations_ko.dart';
import 'localizations_mr.dart';
import 'localizations_ms.dart';
import 'localizations_nb.dart';
import 'localizations_nl.dart';
import 'localizations_pl.dart';
import 'localizations_ps.dart';
import 'localizations_pt.dart';
import 'localizations_ro.dart';
import 'localizations_ru.dart';
import 'localizations_sk.dart';
import 'localizations_sv.dart';
import 'localizations_ta.dart';
import 'localizations_te.dart';
import 'localizations_th.dart';
import 'localizations_tr.dart';
import 'localizations_uk.dart';
import 'localizations_ur.dart';
import 'localizations_vi.dart';
import 'localizations_zh.dart';
import 'localizations_zh_hant.dart';
import 'localizations.dart';

/// Loads [ShadcnLocalizations] for every locale that ships translated data.
///
/// Matching is on the language code, so `de_AT` resolves to German and
/// `zh_TW` to the traditional-Chinese table.
class ShadcnLocalizationsDelegate
    extends LocalizationsDelegate<ShadcnLocalizations> {
  /// Creates the delegate.
  const ShadcnLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ShadcnLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<ShadcnLocalizations> load(Locale locale) =>
      SynchronousFuture<ShadcnLocalizations>(lookupShadcnLocalizations(locale));

  @override
  bool shouldReload(ShadcnLocalizationsDelegate old) => false;
}

/// Returns the translated [ShadcnLocalizations] for [locale].
///
/// Locales without their own table fall back to the English defaults, so this
/// is total: it never throws.
ShadcnLocalizations lookupShadcnLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return ShadcnLocalizationsAr(locale);
    case 'bg':
      return ShadcnLocalizationsBg(locale);
    case 'bn':
      return ShadcnLocalizationsBn(locale);
    case 'cs':
      return ShadcnLocalizationsCs(locale);
    case 'da':
      return ShadcnLocalizationsDa(locale);
    case 'de':
      return ShadcnLocalizationsDe(locale);
    case 'el':
      return ShadcnLocalizationsEl(locale);
    case 'es':
      return ShadcnLocalizationsEs(locale);
    case 'fa':
      return ShadcnLocalizationsFa(locale);
    case 'fi':
      return ShadcnLocalizationsFi(locale);
    case 'fil':
      return ShadcnLocalizationsFil(locale);
    case 'fr':
      return ShadcnLocalizationsFr(locale);
    case 'he':
      return ShadcnLocalizationsHe(locale);
    case 'hi':
      return ShadcnLocalizationsHi(locale);
    case 'hu':
      return ShadcnLocalizationsHu(locale);
    case 'id':
      return ShadcnLocalizationsId(locale);
    case 'it':
      return ShadcnLocalizationsIt(locale);
    case 'ja':
      return ShadcnLocalizationsJa(locale);
    case 'ko':
      return ShadcnLocalizationsKo(locale);
    case 'mr':
      return ShadcnLocalizationsMr(locale);
    case 'ms':
      return ShadcnLocalizationsMs(locale);
    case 'nb':
      return ShadcnLocalizationsNb(locale);
    case 'nl':
      return ShadcnLocalizationsNl(locale);
    case 'pl':
      return ShadcnLocalizationsPl(locale);
    case 'ps':
      return ShadcnLocalizationsPs(locale);
    case 'pt':
      return ShadcnLocalizationsPt(locale);
    case 'ro':
      return ShadcnLocalizationsRo(locale);
    case 'ru':
      return ShadcnLocalizationsRu(locale);
    case 'sk':
      return ShadcnLocalizationsSk(locale);
    case 'sv':
      return ShadcnLocalizationsSv(locale);
    case 'ta':
      return ShadcnLocalizationsTa(locale);
    case 'te':
      return ShadcnLocalizationsTe(locale);
    case 'th':
      return ShadcnLocalizationsTh(locale);
    case 'tr':
      return ShadcnLocalizationsTr(locale);
    case 'uk':
      return ShadcnLocalizationsUk(locale);
    case 'ur':
      return ShadcnLocalizationsUr(locale);
    case 'vi':
      return ShadcnLocalizationsVi(locale);
    case 'zh':
      // Traditional first, then the regions that write in that script.
      if (locale.scriptCode == 'Hant' ||
          (locale.scriptCode == null &&
              (locale.countryCode == 'TW' ||
                  locale.countryCode == 'HK' ||
                  locale.countryCode == 'MO'))) {
        return ShadcnLocalizationsZhHant(locale);
      }
      return ShadcnLocalizationsZh(locale);
    default:
      return ShadcnLocalizations(locale);
  }
}
