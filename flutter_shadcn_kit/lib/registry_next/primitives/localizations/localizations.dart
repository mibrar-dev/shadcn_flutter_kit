import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_date_time.dart';
import 'localizations_delegate.dart';
import 'localizations_error.dart';
import 'localizations_files.dart';
import 'localizations_form.dart';
import 'localizations_misc.dart';
import 'localizations_overlay.dart';

// Keeps `ShadcnLocalizations.delegate`, `ShadcnLocalizationsDelegate` and
// `lookupShadcnLocalizations` reachable from this one import, and exposes the
// domain mixins the class is built from.
export 'localizations_date_time.dart';
export 'localizations_delegate.dart';
export 'localizations_error.dart';
export 'localizations_files.dart';
export 'localizations_form.dart';
export 'localizations_misc.dart';
export 'localizations_overlay.dart';

/// Every user-facing string the registry components read.
///
/// One instance per locale, reached with [of]. The values here are the English
/// defaults, grouped by domain into the `localizations_<domain>.dart` mixins
/// this class applies; locales with translated data subclass it and override
/// what they translate (see [lookupShadcnLocalizations]).
///
/// ```dart
/// Localizations.override(
///   context: context,
///   delegates: ShadcnLocalizations.localizationsDelegates,
///   child: child,
/// );
/// Text(ShadcnLocalizations.of(context).formLengthLessThan(4));
/// ```
class ShadcnLocalizations
    with
        ShadcnLocalizationsForm,
        ShadcnLocalizationsOverlay,
        ShadcnLocalizationsDateTime,
        ShadcnLocalizationsFiles,
        ShadcnLocalizationsMisc,
        ShadcnLocalizationsError {
  const ShadcnLocalizations(this.locale);

  /// The English defaults, for code that has no [BuildContext] to call [of]
  /// on.
  static const ShadcnLocalizations english = ShadcnLocalizations(Locale('en'));

  /// The locale these strings belong to.
  final Locale locale;

  /// [locale] in the form `intl` expects: `language[-COUNTRY][-SCRIPT]`.
  String get localeName => intl.Intl.canonicalizedLocale(locale.toString());

  /// Loads [ShadcnLocalizations] for [context]'s locale.
  ///
  /// Falls back to English when no delegate was installed.
  static ShadcnLocalizations of(BuildContext context) {
    return Localizations.of<ShadcnLocalizations>(
          context,
          ShadcnLocalizations,
        ) ??
        english;
  }

  /// Delegate to add to an app's `localizationsDelegates`.
  static const LocalizationsDelegate<ShadcnLocalizations> delegate =
      ShadcnLocalizationsDelegate();

  /// [delegate] on its own, ready to spread into `localizationsDelegates`.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[delegate];

  /// Locales this delegate can load; must match the app's `supportedLocales`.
  ///
  /// One entry per translated table, with [Locale('en')] first: English is the
  /// base fallback, so an unknown device locale resolves to English instead of
  /// the first translated table. Text direction is *not* handled here: Flutter
  /// resolves it from [WidgetsLocalizations] and [Directionality].
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('ar'),
    Locale('bg'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('es'),
    Locale('fa'),
    Locale('fi'),
    Locale('fil'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('ps'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Resolves a device [locale] against [supported] (a `supportedLocales`
  /// list), matching by **language code first**, then refining by
  /// script/country:
  ///
  /// * `en_US`, `en_GB` → the `en` entry;
  /// * `de_AT` → the `de` entry;
  /// * `zh_Hant*` and `zh_TW`/`zh_HK`/`zh_MO` → the `zh_Hant` entry;
  /// * other `zh` regions (`zh_CN`, `zh_SG`, …) → the plain `zh` entry;
  /// * an unknown language (`sw`) → the first fallback entry (`en`).
  ///
  /// Use it as a `localeResolutionCallback` (the `app` component does) so a
  /// locale whose language is supported never loses to an earlier script or
  /// country entry.
  static Locale resolveLocale(Locale locale, Iterable<Locale> supported) {
    final List<Locale> candidates = supported.toList(growable: false);
    if (candidates.isEmpty) {
      return locale;
    }
    Locale? pick(bool Function(Locale) test) {
      for (final Locale candidate in candidates) {
        if (test(candidate)) {
          return candidate;
        }
      }
      return null;
    }

    final Locale? exact = pick(
      (Locale candidate) =>
          candidate.languageCode == locale.languageCode &&
          candidate.scriptCode == locale.scriptCode &&
          candidate.countryCode == locale.countryCode,
    );
    if (exact != null) {
      return exact;
    }
    if (locale.scriptCode != null) {
      final Locale? script = pick(
        (Locale candidate) =>
            candidate.languageCode == locale.languageCode &&
            candidate.scriptCode == locale.scriptCode,
      );
      if (script != null) {
        return script;
      }
    }
    if (locale.languageCode == 'zh') {
      final bool traditional =
          locale.scriptCode == 'Hant' ||
          (locale.scriptCode == null &&
              (locale.countryCode == 'TW' ||
                  locale.countryCode == 'HK' ||
                  locale.countryCode == 'MO'));
      final Locale? chinese = pick(
        (Locale candidate) =>
            candidate.languageCode == 'zh' &&
            (traditional
                ? candidate.scriptCode == 'Hant'
                : candidate.scriptCode == null),
      );
      if (chinese != null) {
        return chinese;
      }
    }
    final Locale? language = pick(
      (Locale candidate) => candidate.languageCode == locale.languageCode,
    );
    return language ?? candidates.first;
  }
}
