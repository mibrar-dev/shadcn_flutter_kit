// Registry-owned theme data for the `switcher` component: the
// [SwitcherTheme] container and the `switcherDefaults` rows.
//
// User-owned overrides live in `switcher_theme.dart`; CLI updates may replace
// this file. The widget resolves the four legs through `resolveComponentStyle`
// from `theme/theme.dart`.

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Motion contract for the `switcher` component.
class SwitcherTheme extends ComponentThemeData
    implements Mergeable<SwitcherTheme> {
  /// Creates a switcher theme.
  const SwitcherTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.duration,
    this.curve,
  });

  /// Snap-back duration; default 150 ms ([kDefaultDuration]).
  final Duration? duration;

  /// Snap-back curve; default `Curves.easeInOut`.
  final Curve? curve;

  /// Returns a copy with the given fields replaced.
  SwitcherTheme copyWith({
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
  }) {
    return SwitcherTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SwitcherTheme merge(SwitcherTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SwitcherTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      duration: duration ?? fallback.duration,
      curve: curve ?? fallback.curve,
    );
  }

  /// Discrete fields step at t < 0.5.
  static SwitcherTheme lerp(SwitcherTheme a, SwitcherTheme b, double t) {
    return SwitcherTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      duration: t < 0.5 ? a.duration : b.duration,
      curve: t < 0.5 ? a.curve : b.curve,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SwitcherTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, duration, curve);
}

/// Baseline motion rows.
const SwitcherTheme switcherDefaults = SwitcherTheme(
  duration: kDefaultDuration,
  curve: Curves.easeInOut,
);
