// Registry-owned theme data for the `history` component: the [HistoryTheme]
// container and its token-derived `historyDefaults`.
//
// Colors come from tokens; geometry is fixed by the defaults below. User-owned
// overrides live in `history_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Surface and selection styling of the color history grid.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class HistoryTheme extends ComponentThemeData
    implements Mergeable<HistoryTheme> {
  /// Creates a history theme.
  const HistoryTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.selectedBorder,
    this.selectedBorderWidth,
    this.borderRadius,
    this.spacing,
    this.tileSize,
  });

  /// Outline drawn around the selected swatch. Default: the `primary` token.
  final ThemedColor? selectedBorder;

  /// Width of the selection outline. Default: `2`.
  final double? selectedBorderWidth;

  /// Swatch corner radius; null resolves the ambient `radiusMd` at build.
  final BorderRadiusGeometry? borderRadius;

  /// Gap between swatches. Default: `4`.
  final double? spacing;

  /// Edge length of one swatch. Default: `32`.
  final double? tileSize;

  /// Returns a copy with the given fields replaced.
  HistoryTheme copyWith({
    ValueGetter<ThemedColor?>? selectedBorder,
    ValueGetter<double?>? selectedBorderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<double?>? spacing,
    ValueGetter<double?>? tileSize,
  }) {
    return HistoryTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      selectedBorder: selectedBorder == null
          ? this.selectedBorder
          : selectedBorder(),
      selectedBorderWidth: selectedBorderWidth == null
          ? this.selectedBorderWidth
          : selectedBorderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      spacing: spacing == null ? this.spacing : spacing(),
      tileSize: tileSize == null ? this.tileSize : tileSize(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  HistoryTheme merge(HistoryTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return HistoryTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      selectedBorder: selectedBorder ?? fallback.selectedBorder,
      selectedBorderWidth: selectedBorderWidth ?? fallback.selectedBorderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      spacing: spacing ?? fallback.spacing,
      tileSize: tileSize ?? fallback.tileSize,
    );
  }

  /// Colours step at `t = 0.5`; geometry is lerped.
  static HistoryTheme lerp(HistoryTheme a, HistoryTheme b, double t) {
    return HistoryTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      selectedBorder: t < 0.5 ? a.selectedBorder : b.selectedBorder,
      selectedBorderWidth: lerpDouble(
        a.selectedBorderWidth,
        b.selectedBorderWidth,
        t,
      ),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      spacing: lerpDouble(a.spacing, b.spacing, t),
      tileSize: lerpDouble(a.tileSize, b.tileSize, t),
    );
  }
}

/// Token-derived history defaults (the shadcn look).
const HistoryTheme historyDefaults = HistoryTheme(
  selectedBorder: ThemedColor.ref(ColorRef.primary),
  selectedBorderWidth: 2,
  spacing: 4,
  tileSize: 32,
);
