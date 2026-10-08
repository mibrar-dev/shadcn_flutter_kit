// Registry-owned theme data for the `collapsible` component: the flat
// [CollapsibleTheme] container and its `collapsibleDefaults`.
//
// The old theme imported `package:flutter/material.dart` for its default
// icons; the new defaults use the bundled Lucide set. User-owned overrides
// live in `collapsible_theme.dart`; CLI updates may replace this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme container for the collapsible component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class CollapsibleTheme extends ComponentThemeData
    implements Mergeable<CollapsibleTheme> {
  /// Creates a collapsible theme.
  const CollapsibleTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.padding,
    this.iconExpanded,
    this.iconCollapsed,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.iconGap,
  });

  /// Horizontal padding around the trigger row. Default: content density.
  final double? padding;

  /// Icon shown while the section is expanded.
  final IconData? iconExpanded;

  /// Icon shown while the section is collapsed.
  final IconData? iconCollapsed;

  /// Cross-axis alignment of the children column. Default: stretch.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Main-axis alignment of the children column. Default: start.
  final MainAxisAlignment? mainAxisAlignment;

  /// Space between the trigger content and the icon. Default: 16 × scaling.
  final double? iconGap;

  /// Returns a copy with the given fields replaced.
  CollapsibleTheme copyWith({
    ValueGetter<double?>? padding,
    ValueGetter<IconData?>? iconExpanded,
    ValueGetter<IconData?>? iconCollapsed,
    ValueGetter<CrossAxisAlignment?>? crossAxisAlignment,
    ValueGetter<MainAxisAlignment?>? mainAxisAlignment,
    ValueGetter<double?>? iconGap,
  }) {
    return CollapsibleTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      padding: padding == null ? this.padding : padding(),
      iconExpanded: iconExpanded == null ? this.iconExpanded : iconExpanded(),
      iconCollapsed: iconCollapsed == null
          ? this.iconCollapsed
          : iconCollapsed(),
      crossAxisAlignment: crossAxisAlignment == null
          ? this.crossAxisAlignment
          : crossAxisAlignment(),
      mainAxisAlignment: mainAxisAlignment == null
          ? this.mainAxisAlignment
          : mainAxisAlignment(),
      iconGap: iconGap == null ? this.iconGap : iconGap(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CollapsibleTheme merge(CollapsibleTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return CollapsibleTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      padding: padding ?? fallback.padding,
      iconExpanded: iconExpanded ?? fallback.iconExpanded,
      iconCollapsed: iconCollapsed ?? fallback.iconCollapsed,
      crossAxisAlignment: crossAxisAlignment ?? fallback.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? fallback.mainAxisAlignment,
      iconGap: iconGap ?? fallback.iconGap,
    );
  }

  /// Icons and alignments step at `t = 0.5`; dimensions are lerped.
  static CollapsibleTheme lerp(
    CollapsibleTheme a,
    CollapsibleTheme b,
    double t,
  ) {
    return CollapsibleTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      padding: lerpDouble(a.padding, b.padding, t),
      iconExpanded: t < 0.5 ? a.iconExpanded : b.iconExpanded,
      iconCollapsed: t < 0.5 ? a.iconCollapsed : b.iconCollapsed,
      crossAxisAlignment: t < 0.5 ? a.crossAxisAlignment : b.crossAxisAlignment,
      mainAxisAlignment: t < 0.5 ? a.mainAxisAlignment : b.mainAxisAlignment,
      iconGap: lerpDouble(a.iconGap, b.iconGap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CollapsibleTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.padding == padding &&
        other.iconExpanded == iconExpanded &&
        other.iconCollapsed == iconCollapsed &&
        other.crossAxisAlignment == crossAxisAlignment &&
        other.mainAxisAlignment == mainAxisAlignment &&
        other.iconGap == iconGap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    padding,
    iconExpanded,
    iconCollapsed,
    crossAxisAlignment,
    mainAxisAlignment,
    iconGap,
  );
}

/// Baseline values; unset override fields fall through here.
const CollapsibleTheme collapsibleDefaults = CollapsibleTheme(
  iconExpanded: LucideIcons.chevronsDownUp,
  iconCollapsed: LucideIcons.chevronsUpDown,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisAlignment: MainAxisAlignment.start,
);
