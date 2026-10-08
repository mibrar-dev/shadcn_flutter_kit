// Registry-owned theme data for the `scaffold` component: [ScaffoldTheme]
// for the layout shell and [AppBarTheme] for the [AppBar] bar.
//
// User-owned overrides live in `scaffold_theme.dart`; CLI updates may replace
// this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Theme of the scaffold layout shell.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget).
class ScaffoldTheme extends ComponentThemeData
    implements Mergeable<ScaffoldTheme> {
  /// Creates a scaffold theme.
  const ScaffoldTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.headerBackground,
    this.footerBackground,
    this.showLoadingSparks,
    this.resizeToAvoidBottomInset,
  });

  /// Fill of the body area. Default: the `background` token.
  final ThemedColor? background;

  /// Fill behind the header bars. Default: transparent (bars paint their own).
  final ThemedColor? headerBackground;

  /// Fill behind the footer bars. Default: transparent.
  final ThemedColor? footerBackground;

  /// Whether the loading bar shows sparks by default. Default: false.
  final bool? showLoadingSparks;

  /// Whether the body pads for the on-screen keyboard. Default: true.
  final bool? resizeToAvoidBottomInset;

  /// Returns a copy with the given fields replaced.
  ScaffoldTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? headerBackground,
    ValueGetter<ThemedColor?>? footerBackground,
    ValueGetter<bool?>? showLoadingSparks,
    ValueGetter<bool?>? resizeToAvoidBottomInset,
  }) {
    return ScaffoldTheme(
      background: background == null ? this.background : background(),
      headerBackground: headerBackground == null
          ? this.headerBackground
          : headerBackground(),
      footerBackground: footerBackground == null
          ? this.footerBackground
          : footerBackground(),
      showLoadingSparks: showLoadingSparks == null
          ? this.showLoadingSparks
          : showLoadingSparks(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset == null
          ? this.resizeToAvoidBottomInset
          : resizeToAvoidBottomInset(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  ScaffoldTheme merge(ScaffoldTheme? fallback) {
    if (fallback == null) return this;
    return ScaffoldTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      headerBackground: headerBackground ?? fallback.headerBackground,
      footerBackground: footerBackground ?? fallback.footerBackground,
      showLoadingSparks: showLoadingSparks ?? fallback.showLoadingSparks,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? fallback.resizeToAvoidBottomInset,
    );
  }

  /// Booleans and colors step at `t = 0.5`.
  static ScaffoldTheme lerp(ScaffoldTheme a, ScaffoldTheme b, double t) {
    return ScaffoldTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      headerBackground: t < 0.5 ? a.headerBackground : b.headerBackground,
      footerBackground: t < 0.5 ? a.footerBackground : b.footerBackground,
      showLoadingSparks: t < 0.5 ? a.showLoadingSparks : b.showLoadingSparks,
      resizeToAvoidBottomInset: t < 0.5
          ? a.resizeToAvoidBottomInset
          : b.resizeToAvoidBottomInset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScaffoldTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.headerBackground == headerBackground &&
        other.footerBackground == footerBackground &&
        other.showLoadingSparks == showLoadingSparks &&
        other.resizeToAvoidBottomInset == resizeToAvoidBottomInset;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    headerBackground,
    footerBackground,
    showLoadingSparks,
    resizeToAvoidBottomInset,
  );
}

/// Built-in scaffold defaults.
const ScaffoldTheme scaffoldDefaults = ScaffoldTheme(
  background: ThemedColor.ref(ColorRef.background),
  showLoadingSparks: false,
  resizeToAvoidBottomInset: true,
);

/// Theme of the [AppBar] bar.
///
/// Every field is nullable: `null` means "inherit".
class AppBarTheme extends ComponentThemeData implements Mergeable<AppBarTheme> {
  /// Creates an app bar theme.
  const AppBarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.padding,
    this.leadingGap,
    this.trailingGap,
    this.contentGap,
    this.surfaceBlur,
    this.surfaceOpacity,
  });

  /// Bar surface fill. Default: the `card` token.
  final ThemedColor? background;

  /// Inner padding. Default: horizontal 18px, vertical 12px at base density.
  final EdgeInsetsGeometry? padding;

  /// Gap between leading widgets. Default: 4px scaled.
  final double? leadingGap;

  /// Gap between trailing widgets. Default: 4px scaled.
  final double? trailingGap;

  /// Gap between the leading/center/trailing sections. Default: 18px scaled.
  final double? contentGap;

  /// Backdrop blur under the bar. Default: the ambient surface blur (or 0).
  final double? surfaceBlur;

  /// Opacity multiplied onto [background]. Default: 1 (opaque).
  final double? surfaceOpacity;

  /// Returns a copy with the given fields replaced.
  AppBarTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? leadingGap,
    ValueGetter<double?>? trailingGap,
    ValueGetter<double?>? contentGap,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<double?>? surfaceOpacity,
  }) {
    return AppBarTheme(
      background: background == null ? this.background : background(),
      padding: padding == null ? this.padding : padding(),
      leadingGap: leadingGap == null ? this.leadingGap : leadingGap(),
      trailingGap: trailingGap == null ? this.trailingGap : trailingGap(),
      contentGap: contentGap == null ? this.contentGap : contentGap(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  AppBarTheme merge(AppBarTheme? fallback) {
    if (fallback == null) return this;
    return AppBarTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      padding: padding ?? fallback.padding,
      leadingGap: leadingGap ?? fallback.leadingGap,
      trailingGap: trailingGap ?? fallback.trailingGap,
      contentGap: contentGap ?? fallback.contentGap,
      surfaceBlur: surfaceBlur ?? fallback.surfaceBlur,
      surfaceOpacity: surfaceOpacity ?? fallback.surfaceOpacity,
    );
  }

  /// Steps at `t = 0.5`, except gaps and blur which interpolate.
  static AppBarTheme lerp(AppBarTheme a, AppBarTheme b, double t) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return AppBarTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      padding: t < 0.5 ? a.padding : b.padding,
      leadingGap: scale(a.leadingGap, b.leadingGap),
      trailingGap: scale(a.trailingGap, b.trailingGap),
      contentGap: scale(a.contentGap, b.contentGap),
      surfaceBlur: scale(a.surfaceBlur, b.surfaceBlur),
      surfaceOpacity: scale(a.surfaceOpacity, b.surfaceOpacity),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppBarTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.padding == padding &&
        other.leadingGap == leadingGap &&
        other.trailingGap == trailingGap &&
        other.contentGap == contentGap &&
        other.surfaceBlur == surfaceBlur &&
        other.surfaceOpacity == surfaceOpacity;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    padding,
    leadingGap,
    trailingGap,
    contentGap,
    surfaceBlur,
    surfaceOpacity,
  );
}

/// Built-in app bar defaults.
const AppBarTheme appBarDefaults = AppBarTheme(
  background: ThemedColor.ref(ColorRef.card),
  padding: EdgeInsetsDensity.symmetric(horizontal: 1.125, vertical: 0.75),
  surfaceOpacity: 1,
);

/// Position of a bar inside a scaffold shell.
///
/// [AppBar] reads it for edge-aware `SafeArea` handling.
class ScaffoldBarData {
  /// Creates bar position data.
  const ScaffoldBarData({
    this.isHeader = true,
    required this.childIndex,
    required this.childrenCount,
  });

  /// Whether this bar lives in the header section (else footer).
  final bool isHeader;

  /// Zero-based index of this bar among its section siblings.
  final int childIndex;

  /// Total number of bars in this bar's section.
  final int childrenCount;
}
