import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_delegate.dart';

// Keeps `ShadcnLocalizations.delegate`, `ShadcnLocalizationsDelegate` and
// `lookupShadcnLocalizations` reachable from this one import.
export 'localizations_delegate.dart';

/// Every user-facing string the registry components read.
///
/// One instance per locale, reached with [of]. The values here are the English
/// defaults, so the class is usable directly; locales with translated data
/// subclass it and override what they translate (see [lookupShadcnLocalizations]).
///
/// ```dart
/// Localizations.override(
///   context: context,
///   delegates: ShadcnLocalizations.localizationsDelegates,
///   child: child,
/// );
/// Text(ShadcnLocalizations.of(context).formLengthLessThan(4));
/// ```
class ShadcnLocalizations {
  const ShadcnLocalizations(this.locale);

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
        const ShadcnLocalizations(Locale('en'));
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

  String get commandEmpty => 'No results found';

  String get commandSearch => 'Type a command or search...';

  String get commandMoveUp => 'Move up';

  String get commandMoveDown => 'Move down';

  String get commandActivate => 'Activate';

  String get dialogDismiss => 'Dismiss';

  /// Accessible label of a token chip's remove button.
  ///
  /// Copied from Flutter's `deleteButtonTooltip`, documented there as "the
  /// tooltip for the delete button of chips".
  String get chipInputRemoveChip => 'Delete';

  String get buttonCancel => 'Cancel';

  String get buttonSave => 'Save';

  String get buttonPrevious => 'Previous';

  String get buttonNext => 'Next';

  String get datePickerSelectYear => 'Select a year';

  String get placeholderDatePicker => 'Pick a date';

  String get timeAM => 'AM';

  String get timePM => 'PM';

  String get timeHour => 'Hour';

  String get timeMinute => 'Minute';

  String get timeSecond => 'Second';

  String get placeholderTimePicker => 'Select a time';

  String get placeholderDurationPicker => 'Select a duration';

  String get durationDay => 'Day';

  String get durationHour => 'Hour';

  String get durationMinute => 'Minute';

  String get durationSecond => 'Second';

  String get timeDaysAbbreviation => 'DD';

  String get timeHoursAbbreviation => 'HH';

  String get timeMinutesAbbreviation => 'MM';

  String get timeSecondsAbbreviation => 'SS';

  String get menuCut => 'Cut';

  String get menuCopy => 'Copy';

  String get menuPaste => 'Paste';

  String get menuSelectAll => 'Select all';

  String get menuShare => 'Share';

  String get menuSearchWeb => 'Search web';

  String get menuLiveTextInput => 'Live text input';

  String get menuUndo => 'Undo';

  String get menuRedo => 'Redo';

  String get menuDelete => 'Delete';

  String get refreshTriggerRefreshing => 'Refreshing...';

  String get refreshTriggerComplete => 'Refresh complete';

  String get refreshTriggerPull => 'Pull to refresh';

  String get refreshTriggerRelease => 'Release to refresh';

  String get placeholderColorPicker => 'Pick a color';

  String get colorPickerTabRGB => 'RGB';

  String get colorPickerTabHSL => 'HSL';

  String get colorPickerTabHSV => 'HSV';

  String get colorPickerTabHEX => 'HEX';

  String get colorRed => 'Red';

  String get colorGreen => 'Green';

  String get colorBlue => 'Blue';

  String get colorAlpha => 'Alpha';

  String get colorHue => 'Hue';

  String get colorSaturation => 'Saturation';

  String get colorLightness => 'Lightness';

  String get colorValue => 'Value';

  String get formNotEmpty => 'This field cannot be empty.';

  String formLessThan(Object? value) => 'Must be less than $value.';

  String formGreaterThan(Object? value) => 'Must be greater than $value.';

  String formLessThanOrEqualTo(Object? value) =>
      'Must be less than or equal to $value.';

  String formGreaterThanOrEqualTo(Object? value) =>
      'Must be greater than or equal to $value.';

  String formEqualTo(Object? value) => 'Must be equal to $value.';

  String formBetweenInclusively(Object? min, Object? max) =>
      'Must be between $min and $max (inclusive).';

  String formBetweenExclusively(Object? min, Object? max) =>
      'Must be between $min and $max (exclusive).';

  String formLengthLessThan(int limit) => 'Must be at least $limit characters.';

  String formLengthGreaterThan(int limit) =>
      'Must be at most $limit characters.';

  String get formPasswordDigits => 'Must include at least one digit.';

  String get formPasswordLowercase =>
      'Must include at least one lowercase letter.';

  String get formPasswordUppercase =>
      'Must include at least one uppercase letter.';

  String get formPasswordSpecial =>
      'Must include at least one special character.';

  String get formPhoneNumberInvalid => 'Phone number is invalid.';

  String get formPhoneNumberEmpty => 'Phone number is required.';

  String get invalidValue => 'Invalid value provided.';

  String get invalidEmail => 'Invalid email address.';

  String get invalidURL => 'Invalid URL.';

  String get monthJanuary => 'January';

  String get monthFebruary => 'February';

  String get monthMarch => 'March';

  String get monthApril => 'April';

  String get monthMay => 'May';

  String get monthJune => 'June';

  String get monthJuly => 'July';

  String get monthAugust => 'August';

  String get monthSeptember => 'September';

  String get monthOctober => 'October';

  String get monthNovember => 'November';

  String get monthDecember => 'December';

  String get abbreviatedMonday => 'Mon';

  String get abbreviatedTuesday => 'Tue';

  String get abbreviatedWednesday => 'Wed';

  String get abbreviatedThursday => 'Thu';

  String get abbreviatedFriday => 'Fri';

  String get abbreviatedSaturday => 'Sat';

  String get abbreviatedSunday => 'Sun';

  String get abbreviatedJanuary => 'Jan';

  String get abbreviatedFebruary => 'Feb';

  String get abbreviatedMarch => 'Mar';

  String get abbreviatedApril => 'Apr';

  String get abbreviatedMay => 'May';

  String get abbreviatedJune => 'Jun';

  String get abbreviatedJuly => 'Jul';

  String get abbreviatedAugust => 'Aug';

  String get abbreviatedSeptember => 'Sep';

  String get abbreviatedOctober => 'Oct';

  String get abbreviatedNovember => 'Nov';

  String get abbreviatedDecember => 'Dec';

  /// The abbreviated weekday name for [weekday] (1 = Monday .. 7 = Sunday).
  String getAbbreviatedWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return abbreviatedMonday;
      case DateTime.tuesday:
        return abbreviatedTuesday;
      case DateTime.wednesday:
        return abbreviatedWednesday;
      case DateTime.thursday:
        return abbreviatedThursday;
      case DateTime.friday:
        return abbreviatedFriday;
      case DateTime.saturday:
        return abbreviatedSaturday;
      case DateTime.sunday:
        return abbreviatedSunday;
      default:
        throw ArgumentError.value(weekday, 'weekday');
    }
  }

  /// The full month name for [month] (1 = January .. 12 = December).
  String getMonth(int month) {
    switch (month) {
      case DateTime.january:
        return monthJanuary;
      case DateTime.february:
        return monthFebruary;
      case DateTime.march:
        return monthMarch;
      case DateTime.april:
        return monthApril;
      case DateTime.may:
        return monthMay;
      case DateTime.june:
        return monthJune;
      case DateTime.july:
        return monthJuly;
      case DateTime.august:
        return monthAugust;
      case DateTime.september:
        return monthSeptember;
      case DateTime.october:
        return monthOctober;
      case DateTime.november:
        return monthNovember;
      case DateTime.december:
        return monthDecember;
      default:
        throw ArgumentError.value(month, 'month');
    }
  }

  /// The abbreviated month name for [month] (1 = January .. 12 = December).
  String getAbbreviatedMonth(int month) {
    switch (month) {
      case DateTime.january:
        return abbreviatedJanuary;
      case DateTime.february:
        return abbreviatedFebruary;
      case DateTime.march:
        return abbreviatedMarch;
      case DateTime.april:
        return abbreviatedApril;
      case DateTime.may:
        return abbreviatedMay;
      case DateTime.june:
        return abbreviatedJune;
      case DateTime.july:
        return abbreviatedJuly;
      case DateTime.august:
        return abbreviatedAugust;
      case DateTime.september:
        return abbreviatedSeptember;
      case DateTime.october:
        return abbreviatedOctober;
      case DateTime.november:
        return abbreviatedNovember;
      case DateTime.december:
        return abbreviatedDecember;
      default:
        throw ArgumentError.value(month, 'month');
    }
  }

  /// Semantics label for a column resize handle.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get tableResizeColumn => 'Resize column';

  /// Semantics label for a row resize handle.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get tableResizeRow => 'Resize row';

  /// Semantics label for a resizable pane divider handle.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get resizableHandle => 'Resize handle';

  /// Default title of an `empty_state` with no content yet.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get emptyStateEmptyTitle => 'Nothing here yet';

  /// Default description of an `empty_state` with no content yet.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get emptyStateEmptyDescription =>
      'Create your first item to get started.';

  /// Default title of an `empty_state` after a search returned nothing.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get emptyStateNoResultsTitle => 'No results found';

  /// Default description of an `empty_state` after a search returned nothing.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get emptyStateNoResultsDescription =>
      'Try adjusting your filters or search terms.';

  /// Default title of an `empty_state` standing in for a failed load.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get emptyStateErrorTitle => 'Something went wrong';

  /// Default description of an `empty_state` standing in for a failed load.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get emptyStateErrorDescription =>
      'We couldn\u2019t load this data. Try again in a moment.';

  /// `dropzone` status line while nothing is happening.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneIdle => 'Browse to upload files';

  /// `dropzone` status line while a drag hovers over the surface.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneDragging => 'Drop files to upload';

  /// `dropzone` status line while the files are being written.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneUploading => 'Uploading files...';

  /// `dropzone` status line after a successful upload.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneSuccess => 'Files ready';

  /// `dropzone` status line after a failed upload.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneError => 'Fix errors to continue';

  /// `dropzone` status line while the surface is disabled.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneDisabled => 'File uploads disabled';

  /// Default `dropzone` browse action label.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneBrowse => 'Browse files';

  // File upload strings (the `file_picker` component and `FileUploadRow`).
  //
  // Flutter's ARB files have no file-upload equivalents, so these are English
  // fallbacks only.

  /// Pick/browse label of the file surfaces.
  String get fileUploadChoose => 'Choose file';

  /// Tile label while nothing is selected.
  String get fileUploadNoFile => 'No file chosen';

  /// Error shown when the platform picker threw.
  String get fileUploadPickFailed => 'File picking failed.';

  /// Validation: more files than the constraint allows.
  String get fileUploadTooMany => 'Too many files selected.';

  /// Validation: one file is over the size limit.
  String get fileUploadTooLarge => 'File is too large.';

  /// Validation: extension or MIME type not allowed.
  String get fileUploadInvalidType => 'File type is not allowed.';

  /// Upload failure without a file (e.g. the picker failed).
  String get fileUploadUploadFailed => 'Upload failed.';

  /// Upload failure for one file.
  String fileUploadUploadFailedFor(String name) => 'Upload failed for $name.';

  /// Status label for [FileStatus.queued].
  String get fileUploadStatusQueued => 'Queued';

  /// Status label for [FileStatus.uploading].
  String get fileUploadStatusUploading => 'Uploading';

  /// Status label for [FileStatus.success].
  String get fileUploadStatusCompleted => 'Completed';

  /// Status label for [FileStatus.error].
  String get fileUploadStatusFailed => 'Failed';

  /// Type label for a file without an extension.
  String get fileUploadUnknownType => 'File';

  /// Row action: remove the file.
  String get fileUploadRemove => 'Remove file';

  /// Row action: retry the upload.
  String get fileUploadRetry => 'Retry upload';

  /// Row action: preview the file.
  String get fileUploadPreview => 'Preview file';

  /// Row action: download the file.
  String get fileUploadDownload => 'Download file';
}
