// Action, refresh, color, table and empty-state strings for
// [ShadcnLocalizations].

/// Shared action, refresh, color-picker, table and empty-state text for
/// [ShadcnLocalizations].
///
/// Applied by `ShadcnLocalizations`; every getter has an English default and
/// translated locale tables may override it.
mixin ShadcnLocalizationsMisc {
  String get buttonCancel => 'Cancel';

  String get buttonSave => 'Save';

  String get buttonPrevious => 'Previous';

  String get buttonNext => 'Next';

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
}
