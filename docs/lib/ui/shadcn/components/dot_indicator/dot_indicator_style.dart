// Registry-owned theme data for the `dot_indicator` component: the
// [DotIndicatorTheme] container, the [DotStyle] state row and the
// `dotIndicatorDefaults` rows.
//
// User-owned overrides live in `dot_indicator_theme.dart`; CLI updates may
// replace this file.
//
// Fixes against the old theme:
//   * `activeColor` defaulted to the literal `0xFF171717` and
//     `inactiveBorderColor` to `0xFFF5F5F5` — hard-coded greys no preset
//     defines. Both are tokens now (`primary` / `muted`).
//   * The inactive dot was a transparent fill with a `secondary` ring, so an
//     "inactive" dot read as an outline rather than a dot.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// One dot's state-aware styling slice.
class DotStyle implements Mergeable<DotStyle> {
  /// Creates a dot style.
  const DotStyle({
    this.background,
    this.borderColor,
    this.borderWidth,
    this.size,
    this.borderRadius,
  });

  /// Per-state fill of the dot.
  final StateValue<ThemedColor>? background;

  /// Per-state outline; null draws no border.
  final StateValue<ThemedColor>? borderColor;

  /// Outline width used when [borderColor] resolves.
  final double? borderWidth;

  /// Diameter; null resolves `12 * scaling`.
  final double? size;

  /// Corner radius; null resolves a full circle.
  final BorderRadiusGeometry? borderRadius;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  DotStyle merge(DotStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return DotStyle(
      background: background?.merge(fallback.background) ?? fallback.background,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      size: size ?? fallback.size,
      borderRadius: borderRadius ?? fallback.borderRadius,
    );
  }

  /// State scales step at t < 0.5; dimensions lerp.
  static DotStyle lerp(DotStyle a, DotStyle b, double t) {
    return DotStyle(
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      size: lerpDouble(a.size, b.size, t),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DotStyle &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.size == size &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      Object.hash(background, borderColor, borderWidth, size, borderRadius);
}

/// Per-variant theme container for the `dot_indicator` component.
class DotIndicatorTheme extends ComponentThemeData
    implements Mergeable<DotIndicatorTheme> {
  /// Creates a dot indicator theme.
  const DotIndicatorTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.active,
    this.inactive,
    this.spacing,
    this.padding,
    this.duration,
  });

  /// Style of the dot at the active index.
  final DotStyle? active;

  /// Style of every other dot.
  final DotStyle? inactive;

  /// Gap between two dots; null resolves `8 * scaling`.
  final double? spacing;

  /// Padding around the run of dots; null resolves [dotIndicatorDefaultPadding]
  /// (shadcn `p-2`, density-scaled).
  final EdgeInsetsGeometry? padding;

  /// Duration of the active/inactive morph; null resolves 150 ms.
  final Duration? duration;

  /// The slice for the row at [index].
  DotStyle? forIndex(bool isActive) => isActive ? active : inactive;

  /// Returns a copy with the given fields replaced.
  DotIndicatorTheme copyWith({
    ValueGetter<DotStyle?>? active,
    ValueGetter<DotStyle?>? inactive,
    ValueGetter<double?>? spacing,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Duration?>? duration,
  }) {
    return DotIndicatorTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      active: active == null ? this.active : active(),
      inactive: inactive == null ? this.inactive : inactive(),
      spacing: spacing == null ? this.spacing : spacing(),
      padding: padding == null ? this.padding : padding(),
      duration: duration == null ? this.duration : duration(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  DotIndicatorTheme merge(DotIndicatorTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return DotIndicatorTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      active: active?.merge(fallback.active) ?? fallback.active,
      inactive: inactive?.merge(fallback.inactive) ?? fallback.inactive,
      spacing: spacing ?? fallback.spacing,
      padding: padding ?? fallback.padding,
      duration: duration ?? fallback.duration,
    );
  }

  /// Lerps each row; state scales step at t < 0.5.
  static DotIndicatorTheme lerp(
    DotIndicatorTheme a,
    DotIndicatorTheme b,
    double t,
  ) {
    DotStyle? row(DotStyle? x, DotStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return DotStyle.lerp(x, y, t);
    }

    return DotIndicatorTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      active: row(a.active, b.active),
      inactive: row(a.inactive, b.inactive),
      spacing: lerpDouble(a.spacing, b.spacing, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      duration: t < 0.5 ? a.duration : b.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DotIndicatorTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.active == active &&
        other.inactive == inactive &&
        other.spacing == spacing &&
        other.padding == padding &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    active,
    inactive,
    spacing,
    padding,
    duration,
  );
}

/// The active row: a filled `primary` dot. No border, so `borderColor` stays
/// null — a transparent colour must never stand in for "no border".
const DotStyle _dotIndicatorActiveRow = DotStyle(
  background: StateValue(
    rest: ThemedColor.ref(ColorRef.primary),
    hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
    pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.9),
    selected: ThemedColor.ref(ColorRef.primary),
  ),
);

/// The inactive row: a `muted` dot. No border — the old transparent fill plus a
/// `secondary` ring read as an outline, not a dot.
const DotStyle _dotIndicatorInactiveRow = DotStyle(
  background: StateValue(
    rest: ThemedColor.ref(ColorRef.muted),
    hovered: ThemedColor.ref(ColorRef.accent),
    pressed: ThemedColor.ref(ColorRef.accent),
    selected: ThemedColor.ref(ColorRef.muted),
  ),
);

/// Padding of the run of dots: shadcn `p-2` (8px), density-scaled.
const EdgeInsetsGeometry dotIndicatorDefaultPadding = EdgeInsetsDensity.pxAll(
  8,
);

/// Token-derived baseline rows; every unset override field falls through here.
const DotIndicatorTheme dotIndicatorDefaults = DotIndicatorTheme(
  active: _dotIndicatorActiveRow,
  inactive: _dotIndicatorInactiveRow,
  padding: dotIndicatorDefaultPadding,
  duration: kDefaultDuration,
);
