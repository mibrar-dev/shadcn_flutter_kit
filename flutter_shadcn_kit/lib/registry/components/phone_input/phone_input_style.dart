// Registry-owned theme data for the `phone_input` component:
// [PhoneInputTheme] and the token-derived `phoneInputDefaults`.
//
// The old `phone_input_theme.dart` plus its four config files (defaults,
// tokens, schema, config) collapse into this file: the config classes were
// never applied at runtime and the schema was generated tooling. User-owned
// overrides live in `phone_input_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Theme data for the `phone_input` component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class PhoneInputTheme extends ComponentThemeData
    implements Mergeable<PhoneInputTheme> {
  /// Creates a phone input theme.
  const PhoneInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.inputPadding,
    this.maxWidth,
    this.selectWidth,
    this.popupConstraints,
    this.flagWidth,
    this.flagHeight,
    this.flagGap,
    this.fieldGap,
    this.countryGap,
  });

  /// Padding inside the number field; density-scaled (shadcn `px-3 py-2`).
  final EdgeInsetsGeometry? inputPadding;

  /// Maximum width of the number field.
  final double? maxWidth;

  /// Width of the country selector (the popup is trigger-wide).
  final double? selectWidth;

  /// Constraints of the country popup.
  final BoxConstraints? popupConstraints;

  /// Flag width in the trigger and in popup rows.
  final double? flagWidth;

  /// Flag height in the trigger and in popup rows.
  final double? flagHeight;

  /// Gap between a flag and the dial code / country name.
  final double? flagGap;

  /// Gap between the country selector and the number field.
  final double? fieldGap;

  /// Gap between the country name and its dial code in popup rows.
  final double? countryGap;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  PhoneInputTheme merge(PhoneInputTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return PhoneInputTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      inputPadding: inputPadding ?? fallback.inputPadding,
      maxWidth: maxWidth ?? fallback.maxWidth,
      selectWidth: selectWidth ?? fallback.selectWidth,
      popupConstraints: popupConstraints ?? fallback.popupConstraints,
      flagWidth: flagWidth ?? fallback.flagWidth,
      flagHeight: flagHeight ?? fallback.flagHeight,
      flagGap: flagGap ?? fallback.flagGap,
      fieldGap: fieldGap ?? fallback.fieldGap,
      countryGap: countryGap ?? fallback.countryGap,
    );
  }

  /// Dimensions are lerped; box constraints step at `t = 0.5`.
  static PhoneInputTheme lerp(PhoneInputTheme a, PhoneInputTheme b, double t) {
    return PhoneInputTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      inputPadding: EdgeInsetsGeometry.lerp(a.inputPadding, b.inputPadding, t),
      maxWidth: lerpDouble(a.maxWidth, b.maxWidth, t),
      selectWidth: lerpDouble(a.selectWidth, b.selectWidth, t),
      popupConstraints: t < 0.5 ? a.popupConstraints : b.popupConstraints,
      flagWidth: lerpDouble(a.flagWidth, b.flagWidth, t),
      flagHeight: lerpDouble(a.flagHeight, b.flagHeight, t),
      flagGap: lerpDouble(a.flagGap, b.flagGap, t),
      fieldGap: lerpDouble(a.fieldGap, b.fieldGap, t),
      countryGap: lerpDouble(a.countryGap, b.countryGap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PhoneInputTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.inputPadding == inputPadding &&
        other.maxWidth == maxWidth &&
        other.selectWidth == selectWidth &&
        other.popupConstraints == popupConstraints &&
        other.flagWidth == flagWidth &&
        other.flagHeight == flagHeight &&
        other.flagGap == flagGap &&
        other.fieldGap == fieldGap &&
        other.countryGap == countryGap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    inputPadding,
    maxWidth,
    selectWidth,
    popupConstraints,
    flagWidth,
    flagHeight,
    flagGap,
    fieldGap,
    countryGap,
  );
}

/// Token-derived defaults: 200px number field, 24x18 flags, 8px flag gap,
/// 8px field gap, 16px country gap, 250x300 popup.
const PhoneInputTheme phoneInputDefaults = PhoneInputTheme(
  // shadcn `px-3 py-2` — the same rule as `inputDefaultPadding`, resolved by
  // the `Input` this value feeds.
  inputPadding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
  maxWidth: 200,
  selectWidth: 180,
  popupConstraints: BoxConstraints(maxWidth: 250, maxHeight: 300),
  flagWidth: 24,
  flagHeight: 18,
  flagGap: 8,
  fieldGap: 8,
  countryGap: 16,
);

/// Formatters for the number field: digits plus at most one leading `+`
/// (the dial-code prefix is typeable, non-digits are filtered).
List<TextInputFormatter> phoneInputNumberFormatters() {
  return const <TextInputFormatter>[_PhoneInputTextFormatter()];
}

class _PhoneInputTextFormatter extends TextInputFormatter {
  const _PhoneInputTextFormatter();

  static final RegExp _disallowed = RegExp(r'[^0-9+]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(_disallowed, '');
    if (text.contains('+')) {
      text = (text.startsWith('+') ? '+' : '') + text.replaceAll('+', '');
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: newValue.selection.baseOffset.clamp(0, text.length),
        extentOffset: newValue.selection.extentOffset.clamp(0, text.length),
      ),
    );
  }
}
