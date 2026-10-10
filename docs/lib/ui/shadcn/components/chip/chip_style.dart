// Registry-owned theme data for the `chip` component: the [ChipTheme]
// container and its token-derived `chipDefaults`.
//
// A chip is a compact button row, so the theme picks a `ButtonVariant` and
// tightens the button's padding and type scale; the per-state paint table
// itself is the `button` component's [ButtonVariantStyle], reused as-is so a
// chip can never drift from the button colours. User-owned overrides live in
// `chip_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';

/// Chip label text style: shadcn chip `text-xs`, medium weight.
///
/// The 16px (`1rem`) line matches Tailwind's `text-xs` line height, so the
/// chip measures 16 + `py-0.5` (4) = 20 like the badge.
const TextStyle chipDefaultTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  height: 4 / 3,
);

/// Padding of a chip: shadcn `px-2 py-0.5`, density-scaled.
const EdgeInsetsGeometry chipDefaultPadding = EdgeInsetsDensity.pxSymmetric(
  horizontal: 8,
  vertical: 2,
);

/// Padding of an inner [ChipButton]: the remove/expand control has no padding
/// of its own, it only fills the slot the chip reserves for it.
const EdgeInsetsGeometry chipButtonDefaultPadding = EdgeInsets.zero;

/// Icon size of an inner [ChipButton].
const double chipButtonDefaultIconSize = 12;

/// Theme container for the chip component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ChipTheme extends ComponentThemeData implements Mergeable<ChipTheme> {
  /// Creates a chip theme.
  const ChipTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.variant,
    this.padding,
    this.textStyle,
    this.style,
    this.buttonPadding,
    this.buttonIconSize,
  });

  /// Button variant the chips render with. Default:
  /// [ButtonVariant.secondary].
  final ButtonVariant? variant;

  /// Padding between the chip border and its content. Default:
  /// [chipDefaultPadding].
  final EdgeInsetsGeometry? padding;

  /// Label text style; its colour is ignored (the button style owns it).
  final TextStyle? textStyle;

  /// Extra per-state rows merged over the variant's button style.
  final ButtonVariantStyle? style;

  /// Padding of an inner [ChipButton]. Default:
  /// [chipButtonDefaultPadding].
  final EdgeInsetsGeometry? buttonPadding;

  /// Icon size of an inner [ChipButton]. Default:
  /// [chipButtonDefaultIconSize].
  final double? buttonIconSize;

  /// Returns a copy with the given fields replaced.
  ChipTheme copyWith({
    ValueGetter<ButtonVariant?>? variant,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<ButtonVariantStyle?>? style,
    ValueGetter<EdgeInsetsGeometry?>? buttonPadding,
    ValueGetter<double?>? buttonIconSize,
  }) {
    return ChipTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      variant: variant == null ? this.variant : variant(),
      padding: padding == null ? this.padding : padding(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      style: style == null ? this.style : style(),
      buttonPadding: buttonPadding == null
          ? this.buttonPadding
          : buttonPadding(),
      buttonIconSize: buttonIconSize == null
          ? this.buttonIconSize
          : buttonIconSize(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ChipTheme merge(ChipTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ChipTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      variant: variant ?? fallback.variant,
      padding: padding ?? fallback.padding,
      style: style?.merge(fallback.style) ?? fallback.style,
      buttonPadding: buttonPadding ?? fallback.buttonPadding,
      buttonIconSize: buttonIconSize ?? fallback.buttonIconSize,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
    );
  }

  /// Enums step at `t = 0.5`; padding, icon size and text styles interpolate.
  static ChipTheme lerp(ChipTheme a, ChipTheme b, double t) {
    return ChipTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      variant: t < 0.5 ? a.variant : b.variant,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      style: ButtonVariantStyle.lerp(a.style!, b.style!, t),
      buttonPadding: EdgeInsetsGeometry.lerp(
        a.buttonPadding,
        b.buttonPadding,
        t,
      ),
      buttonIconSize: lerpDouble(a.buttonIconSize, b.buttonIconSize, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ChipTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.variant == variant &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.style == style &&
        other.buttonPadding == buttonPadding &&
        other.buttonIconSize == buttonIconSize;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    variant,
    padding,
    textStyle,
    style,
    buttonPadding,
    buttonIconSize,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
const ChipTheme chipDefaults = ChipTheme(
  variant: ButtonVariant.secondary,
  padding: chipDefaultPadding,
  textStyle: chipDefaultTextStyle,
  buttonPadding: chipButtonDefaultPadding,
  buttonIconSize: chipButtonDefaultIconSize,
);
