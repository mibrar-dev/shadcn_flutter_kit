// Registry-owned theme data for the `triple_dots` component: the
// [TripleDotsTheme] container and the token-derived `tripleDotsDefaults`.
//
// User-owned overrides live in `triple_dots_theme.dart`; CLI updates may
// replace this file. The widget reads the resolved theme through
// `resolveComponentStyle<TripleDotsTheme, TripleDotsTheme>` from
// `theme/theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// One dots row's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class TripleDotsTheme extends ComponentThemeData
    implements Mergeable<TripleDotsTheme> {
  /// Creates a dots theme.
  const TripleDotsTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.size,
    this.spacing,
  });

  /// Dot colour; null resolves the `mutedForeground` token.
  final ThemedColor? color;

  /// Dot diameter; null resolves `4 * scaling`.
  final double? size;

  /// Gap between dots; null resolves `2`.
  final double? spacing;

  /// Returns a copy with the given fields replaced.
  TripleDotsTheme copyWith({
    ValueGetter<ThemedColor?>? color,
    ValueGetter<double?>? size,
    ValueGetter<double?>? spacing,
  }) {
    return TripleDotsTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      color: color == null ? this.color : color(),
      size: size == null ? this.size : size(),
      spacing: spacing == null ? this.spacing : spacing(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TripleDotsTheme merge(TripleDotsTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return TripleDotsTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      color: color ?? fallback.color,
      size: size ?? fallback.size,
      spacing: spacing ?? fallback.spacing,
    );
  }

  /// Colours step at t < 0.5; dimensions are lerped.
  static TripleDotsTheme lerp(TripleDotsTheme a, TripleDotsTheme b, double t) {
    return TripleDotsTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      color: t < 0.5 ? a.color : b.color,
      size: lerpDouble(a.size, b.size, t),
      spacing: lerpDouble(a.spacing, b.spacing, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TripleDotsTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.color == color &&
        other.size == size &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    color,
    size,
    spacing,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const TripleDotsTheme tripleDotsDefaults = TripleDotsTheme(
  color: ThemedColor.ref(ColorRef.mutedForeground),
  size: 4,
  spacing: 2,
);
