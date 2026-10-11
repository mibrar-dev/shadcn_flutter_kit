// Registry-owned theme data for the `input_otp` component: the
// [InputOtpTheme] container and the token-derived `inputOtpDefaults`.
//
// User-owned overrides live in `input_otp_theme.dart`; CLI updates may replace
// this file.
//
// The old `InputOTPTheme` had only `spacing` and `height`; every visual
// property (fill, border, radius, padding, text) came from the hidden
// `TextField` the widget nested inside each box, so an OTP box could not be
// themed at all. All of them are rows here.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Visual contract of the OTP slots.
class InputOtpTheme extends ComponentThemeData
    implements Mergeable<InputOtpTheme> {
  /// Creates an input-otp theme.
  const InputOtpTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.boxSize,
    this.spacing,
    this.separatorTextStyle,
    this.cursorColor,
  });

  /// Per-state fill of a slot; null resolves `input` at 30% alpha.
  final StateValue<ThemedColor>? background;

  /// Per-state slot border; null resolves the `input` token.
  final StateValue<ThemedColor>? borderColor;

  /// Border width used when [borderColor] resolves; null resolves 1.
  final double? borderWidth;

  /// Corner radius; null resolves `borderRadiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves 6 x 0 (`px-1.5 py-0`), density-scaled
  /// through [inputOtpDefaultPadding].
  final EdgeInsetsGeometry? padding;

  /// Slot label style; its colour is ignored (taken from the foreground).
  final TextStyle? textStyle;

  /// Slot box size; null resolves the theme's `typography.small` line height.
  final double? boxSize;

  /// Gap between two slots; null resolves the density base gap.
  final double? spacing;

  /// Style of the optional [InputOtp.separator].
  final TextStyle? separatorTextStyle;

  /// Caret colour of the focused slot; null resolves `ring`.
  final ThemedColor? cursorColor;

  /// Returns a copy with the given fields replaced.
  InputOtpTheme copyWith({
    ValueGetter<StateValue<ThemedColor>?>? background,
    ValueGetter<StateValue<ThemedColor>?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<double?>? boxSize,
    ValueGetter<double?>? spacing,
    ValueGetter<TextStyle?>? separatorTextStyle,
    ValueGetter<ThemedColor?>? cursorColor,
  }) {
    return InputOtpTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      boxSize: boxSize == null ? this.boxSize : boxSize(),
      spacing: spacing == null ? this.spacing : spacing(),
      separatorTextStyle: separatorTextStyle == null
          ? this.separatorTextStyle
          : separatorTextStyle(),
      cursorColor: cursorColor == null ? this.cursorColor : cursorColor(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  InputOtpTheme merge(InputOtpTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return InputOtpTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background?.merge(fallback.background) ?? fallback.background,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      boxSize: boxSize ?? fallback.boxSize,
      spacing: spacing ?? fallback.spacing,
      separatorTextStyle: separatorTextStyle ?? fallback.separatorTextStyle,
      cursorColor: cursorColor ?? fallback.cursorColor,
    );
  }

  /// State scales step at t < 0.5; dimensions lerp.
  static InputOtpTheme lerp(InputOtpTheme a, InputOtpTheme b, double t) {
    return InputOtpTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: t < 0.5 ? a.borderWidth : b.borderWidth,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      boxSize: t < 0.5 ? a.boxSize : b.boxSize,
      spacing: t < 0.5 ? a.spacing : b.spacing,
      separatorTextStyle: TextStyle.lerp(
        a.separatorTextStyle,
        b.separatorTextStyle,
        t,
      ),
      cursorColor: t < 0.5 ? a.cursorColor : b.cursorColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is InputOtpTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.boxSize == boxSize &&
        other.spacing == spacing &&
        other.separatorTextStyle == separatorTextStyle &&
        other.cursorColor == cursorColor;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    textStyle,
    boxSize,
    spacing,
    separatorTextStyle,
    cursorColor,
  );
}

const StateValue<ThemedColor> _otpBackground = StateValue<ThemedColor>(
  rest: ThemedColor.ref(ColorRef.input, alpha: 0.3),
  hovered: ThemedColor.ref(ColorRef.input, alpha: 0.5),
  disabled: ThemedColor.ref(ColorRef.input, alpha: 0),
);

const StateValue<ThemedColor> _otpBorder = StateValue<ThemedColor>(
  rest: ThemedColor.ref(ColorRef.input),
);

/// Inner padding of one slot: shadcn `px-1.5`, density-scaled.
///
/// A const whose stored sides are shadcn-px multipliers (6/16, 0/16), so it
/// measures exactly `px-1.5 py-0` at the default density and scales with it.
const EdgeInsetsGeometry inputOtpDefaultPadding = EdgeInsetsDensity.pxSymmetric(
  horizontal: 6,
);

/// Token-derived baseline; every unset override field falls through here.
const InputOtpTheme inputOtpDefaults = InputOtpTheme(
  background: _otpBackground,
  borderColor: _otpBorder,
  borderWidth: 1,
  padding: inputOtpDefaultPadding,
  textStyle: TextStyle(fontSize: 14),
  cursorColor: ThemedColor.ref(ColorRef.ring),
);
