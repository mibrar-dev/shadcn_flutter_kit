// Registry-owned theme data for the `window` component: the [WindowTheme]
// container and its token-derived `windowDefaults`.
//
// User-owned overrides live in `window_theme.dart`; CLI updates may replace
// this file. The window surface itself is a `Card`; this theme owns the chrome
// metrics (title bar, resize handles) and the drag-snap preview colours.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Chrome metrics and snap-preview colours of a window.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class WindowTheme extends ComponentThemeData implements Mergeable<WindowTheme> {
  /// Creates a window theme.
  const WindowTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.titleBarHeight,
    this.resizeThickness,
    this.titleBarPadding,
    this.titleColor,
    this.snapOverlayColor,
    this.snapOverlayOpacity,
    this.snapOverlayBlur,
  });

  /// Height of the title bar. Default: 32 (scaled).
  final double? titleBarHeight;

  /// Grab thickness of the resize edges. Default: 8 (scaled).
  final double? resizeThickness;

  /// Padding inside the title bar. Default: 8 horizontal.
  final EdgeInsetsGeometry? titleBarPadding;

  /// Title colour. Default: the `foreground` token.
  final ThemedColor? titleColor;

  /// Fill of the snap preview. Default: the `card` token.
  final ThemedColor? snapOverlayColor;

  /// Fill opacity of the snap preview. Default: 0.8.
  final double? snapOverlayOpacity;

  /// Backdrop blur sigma of the snap preview. Default: 8; 0 disables it.
  final double? snapOverlayBlur;

  /// Returns a copy with the given fields replaced.
  WindowTheme copyWith({
    ValueGetter<double?>? titleBarHeight,
    ValueGetter<double?>? resizeThickness,
    ValueGetter<EdgeInsetsGeometry?>? titleBarPadding,
    ValueGetter<ThemedColor?>? titleColor,
    ValueGetter<ThemedColor?>? snapOverlayColor,
    ValueGetter<double?>? snapOverlayOpacity,
    ValueGetter<double?>? snapOverlayBlur,
  }) {
    return WindowTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      titleBarHeight: titleBarHeight == null
          ? this.titleBarHeight
          : titleBarHeight(),
      resizeThickness: resizeThickness == null
          ? this.resizeThickness
          : resizeThickness(),
      titleBarPadding: titleBarPadding == null
          ? this.titleBarPadding
          : titleBarPadding(),
      titleColor: titleColor == null ? this.titleColor : titleColor(),
      snapOverlayColor: snapOverlayColor == null
          ? this.snapOverlayColor
          : snapOverlayColor(),
      snapOverlayOpacity: snapOverlayOpacity == null
          ? this.snapOverlayOpacity
          : snapOverlayOpacity(),
      snapOverlayBlur: snapOverlayBlur == null
          ? this.snapOverlayBlur
          : snapOverlayBlur(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  WindowTheme merge(WindowTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return WindowTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      titleBarHeight: titleBarHeight ?? fallback.titleBarHeight,
      resizeThickness: resizeThickness ?? fallback.resizeThickness,
      titleBarPadding: titleBarPadding ?? fallback.titleBarPadding,
      titleColor: titleColor ?? fallback.titleColor,
      snapOverlayColor: snapOverlayColor ?? fallback.snapOverlayColor,
      snapOverlayOpacity: snapOverlayOpacity ?? fallback.snapOverlayOpacity,
      snapOverlayBlur: snapOverlayBlur ?? fallback.snapOverlayBlur,
    );
  }

  /// Colours and flags step at `t = 0.5`; dimensions are lerped.
  static WindowTheme lerp(WindowTheme a, WindowTheme b, double t) {
    return WindowTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      titleBarHeight: lerpDouble(a.titleBarHeight, b.titleBarHeight, t),
      resizeThickness: lerpDouble(a.resizeThickness, b.resizeThickness, t),
      titleBarPadding: EdgeInsetsGeometry.lerp(
        a.titleBarPadding,
        b.titleBarPadding,
        t,
      ),
      titleColor: t < 0.5 ? a.titleColor : b.titleColor,
      snapOverlayColor: t < 0.5 ? a.snapOverlayColor : b.snapOverlayColor,
      snapOverlayOpacity: lerpDouble(
        a.snapOverlayOpacity,
        b.snapOverlayOpacity,
        t,
      ),
      snapOverlayBlur: lerpDouble(a.snapOverlayBlur, b.snapOverlayBlur, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is WindowTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.titleBarHeight == titleBarHeight &&
        other.resizeThickness == resizeThickness &&
        other.titleBarPadding == titleBarPadding &&
        other.titleColor == titleColor &&
        other.snapOverlayColor == snapOverlayColor &&
        other.snapOverlayOpacity == snapOverlayOpacity &&
        other.snapOverlayBlur == snapOverlayBlur;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    titleBarHeight,
    resizeThickness,
    titleBarPadding,
    titleColor,
    snapOverlayColor,
    snapOverlayOpacity,
    snapOverlayBlur,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
const WindowTheme windowDefaults = WindowTheme(
  titleBarHeight: 32,
  resizeThickness: 8,
  titleBarPadding: EdgeInsets.symmetric(horizontal: 8),
  titleColor: ThemedColor.ref(ColorRef.foreground),
  snapOverlayColor: ThemedColor.ref(ColorRef.card),
  snapOverlayOpacity: 0.8,
  snapOverlayBlur: 8,
);
