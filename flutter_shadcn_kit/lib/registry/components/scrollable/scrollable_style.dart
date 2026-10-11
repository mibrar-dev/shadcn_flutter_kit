// Registry-owned theme data for the `scrollable` component: the flat
// [ScrollableTheme] container and its `scrollableDefaults`.
//
// The component renders edge fades over any scrollable subtree; the theme
// exposes the two geometry values. User-owned overrides live in
// `scrollable_theme.dart`; CLI updates may replace this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Distance over which the leading/trailing fade reaches full strength.
const double scrollableDefaultFadeExtent = 20;

/// Length of the fade gradient in logical pixels.
const double scrollableDefaultFadeSize = 50;

/// Theme container for the scrollable component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ScrollableTheme extends ComponentThemeData
    implements Mergeable<ScrollableTheme> {
  /// Creates a scrollable theme.
  const ScrollableTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.fadeExtent,
    this.fadeSize,
  });

  /// Scroll distance over which the fade reaches full strength.
  final double? fadeExtent;

  /// Length of the fade gradient.
  final double? fadeSize;

  /// Returns a copy with the given fields replaced.
  ScrollableTheme copyWith({
    ValueGetter<double?>? fadeExtent,
    ValueGetter<double?>? fadeSize,
  }) {
    return ScrollableTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      fadeExtent: fadeExtent == null ? this.fadeExtent : fadeExtent(),
      fadeSize: fadeSize == null ? this.fadeSize : fadeSize(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ScrollableTheme merge(ScrollableTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ScrollableTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      fadeExtent: fadeExtent ?? fallback.fadeExtent,
      fadeSize: fadeSize ?? fallback.fadeSize,
    );
  }

  /// Lerps both geometry fields.
  static ScrollableTheme lerp(ScrollableTheme a, ScrollableTheme b, double t) {
    return ScrollableTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      fadeExtent: lerpDouble(a.fadeExtent, b.fadeExtent, t),
      fadeSize: lerpDouble(a.fadeSize, b.fadeSize, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ScrollableTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.fadeExtent == fadeExtent &&
        other.fadeSize == fadeSize;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    fadeExtent,
    fadeSize,
  );
}

/// Baseline values; unset override fields fall through here.
const ScrollableTheme scrollableDefaults = ScrollableTheme(
  fadeExtent: scrollableDefaultFadeExtent,
  fadeSize: scrollableDefaultFadeSize,
);
