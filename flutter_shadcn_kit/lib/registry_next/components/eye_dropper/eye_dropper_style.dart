// Registry-owned theme data for the `eye_dropper` component: the
// [EyeDropperTheme] container and its token-derived `eyeDropperDefaults`.
//
// User-owned overrides live in `eye_dropper_theme.dart`; CLI updates may
// replace this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Styling of the magnified picker preview.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class EyeDropperTheme extends ComponentThemeData
    implements Mergeable<EyeDropperTheme> {
  /// Creates an eye-dropper theme.
  const EyeDropperTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.previewSize,
    this.previewScale,
    this.showPreview,
    this.borderColor,
    this.borderWidth,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    this.backgroundColor,
  });

  /// Size of the magnified preview. Default: 100x100 (scaled by the ambient
  /// `scaling` factor).
  final Size? previewSize;

  /// Magnification factor of the preview: one screen pixel covers
  /// `1 / previewScale` of the sampled area. Default: 8.
  final double? previewScale;

  /// Whether the magnified preview is shown at all. Default: true.
  final bool? showPreview;

  /// Outer ring colour of the preview circle. Default: the `border` token.
  final ThemedColor? borderColor;

  /// Outer ring width. Default: 1 (scaled by the ambient `scaling` factor).
  final double? borderWidth;

  /// Colour of the highlighted centre cell. Default: the `primary` token.
  final ThemedColor? selectedBorderColor;

  /// Width of the highlighted centre cell. Default: 2 (scaled).
  final double? selectedBorderWidth;

  /// Background behind the sampled cells. Default: the `background` token.
  final ThemedColor? backgroundColor;

  /// Returns a copy with the given fields replaced.
  EyeDropperTheme copyWith({
    ValueGetter<Size?>? previewSize,
    ValueGetter<double?>? previewScale,
    ValueGetter<bool?>? showPreview,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<ThemedColor?>? selectedBorderColor,
    ValueGetter<double?>? selectedBorderWidth,
    ValueGetter<ThemedColor?>? backgroundColor,
  }) {
    return EyeDropperTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      previewSize: previewSize == null ? this.previewSize : previewSize(),
      previewScale: previewScale == null ? this.previewScale : previewScale(),
      showPreview: showPreview == null ? this.showPreview : showPreview(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      selectedBorderColor: selectedBorderColor == null
          ? this.selectedBorderColor
          : selectedBorderColor(),
      selectedBorderWidth: selectedBorderWidth == null
          ? this.selectedBorderWidth
          : selectedBorderWidth(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  EyeDropperTheme merge(EyeDropperTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return EyeDropperTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      previewSize: previewSize ?? fallback.previewSize,
      previewScale: previewScale ?? fallback.previewScale,
      showPreview: showPreview ?? fallback.showPreview,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      selectedBorderColor: selectedBorderColor ?? fallback.selectedBorderColor,
      selectedBorderWidth: selectedBorderWidth ?? fallback.selectedBorderWidth,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
    );
  }

  /// Colours and flags step at `t = 0.5`; dimensions are lerped.
  static EyeDropperTheme lerp(EyeDropperTheme a, EyeDropperTheme b, double t) {
    return EyeDropperTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      previewSize: Size.lerp(a.previewSize, b.previewSize, t),
      previewScale: lerpDouble(a.previewScale, b.previewScale, t),
      showPreview: t < 0.5 ? a.showPreview : b.showPreview,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      selectedBorderColor: t < 0.5
          ? a.selectedBorderColor
          : b.selectedBorderColor,
      selectedBorderWidth: lerpDouble(
        a.selectedBorderWidth,
        b.selectedBorderWidth,
        t,
      ),
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is EyeDropperTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.previewSize == previewSize &&
        other.previewScale == previewScale &&
        other.showPreview == showPreview &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.selectedBorderColor == selectedBorderColor &&
        other.selectedBorderWidth == selectedBorderWidth &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    previewSize,
    previewScale,
    showPreview,
    borderColor,
    borderWidth,
    selectedBorderColor,
    selectedBorderWidth,
    backgroundColor,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
const EyeDropperTheme eyeDropperDefaults = EyeDropperTheme(
  previewSize: Size(100, 100),
  previewScale: 8,
  showPreview: true,
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  selectedBorderColor: ThemedColor.ref(ColorRef.primary),
  selectedBorderWidth: 2,
  backgroundColor: ThemedColor.ref(ColorRef.background),
);
