// Registry-owned theme data for the `pagination` component: the
// [PaginationTheme] container and the token-derived `paginationDefaults`.
//
// User-owned overrides live in `pagination_theme.dart`; CLI updates may
// replace this file. The widget reads the resolved theme through
// `resolveComponentStyle<PaginationTheme, PaginationTheme>`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual contract of the pagination control.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class PaginationTheme extends ComponentThemeData
    implements Mergeable<PaginationTheme> {
  /// Creates a pagination theme.
  const PaginationTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.gap,
    this.showLabel,
  });

  /// Gap between the controls. Default: `4` (× scaling).
  final double? gap;

  /// Whether the previous/next buttons show their text label. Default: `true`.
  final bool? showLabel;

  /// Returns a copy with the given fields replaced.
  PaginationTheme copyWith({
    ValueGetter<double?>? gap,
    ValueGetter<bool?>? showLabel,
  }) {
    return PaginationTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      gap: gap == null ? this.gap : gap(),
      showLabel: showLabel == null ? this.showLabel : showLabel(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  PaginationTheme merge(PaginationTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return PaginationTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      gap: gap ?? fallback.gap,
      showLabel: showLabel ?? fallback.showLabel,
    );
  }

  /// Dimensions are lerped; flags step at `t < 0.5`.
  static PaginationTheme lerp(PaginationTheme a, PaginationTheme b, double t) {
    return PaginationTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      gap: lerpDouble(a.gap, b.gap, t),
      showLabel: t < 0.5 ? a.showLabel : b.showLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PaginationTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.gap == gap &&
        other.showLabel == showLabel;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, gap, showLabel);
}

/// Token-derived baseline; every unset override field falls through here.
const PaginationTheme paginationDefaults = PaginationTheme(
  gap: 4,
  showLabel: true,
);
