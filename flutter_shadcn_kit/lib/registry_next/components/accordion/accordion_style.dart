// Registry-owned theme data for the `accordion` component: the flat
// [AccordionTheme] container and its `accordionDefaults`.
//
// The old defaults imported `package:flutter/material.dart` for `Icons` and
// `Divider`; the new defaults use the bundled Lucide set and token colours.
// User-owned overrides live in `accordion_theme.dart`; CLI updates may
// replace this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme container for the accordion component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class AccordionTheme extends ComponentThemeData
    implements Mergeable<AccordionTheme> {
  /// Creates an accordion theme.
  const AccordionTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.duration,
    this.curve,
    this.reverseCurve,
    this.padding,
    this.iconGap,
    this.dividerHeight,
    this.dividerColor,
    this.arrowIcon,
    this.arrowIconColor,
  });

  /// Expand/collapse animation duration. Default: 200 ms.
  final Duration? duration;

  /// Curve applied while expanding. Default: easeIn.
  final Curve? curve;

  /// Curve applied while collapsing. Default: easeOut.
  final Curve? reverseCurve;

  /// Vertical padding around triggers and content. Default: content density.
  final double? padding;

  /// Space between the trigger label and the arrow. Default: 18 × scaling.
  final double? iconGap;

  /// Height of the divider between items. Default: 1 × scaling.
  final double? dividerHeight;

  /// Colour of the divider between items. Default: the `muted` token.
  final ThemedColor? dividerColor;

  /// Expand/collapse indicator. Default: Lucide `chevronUp`.
  final IconData? arrowIcon;

  /// Colour of the indicator. Default: the `mutedForeground` token.
  final ThemedColor? arrowIconColor;

  /// Returns a copy with the given fields replaced.
  AccordionTheme copyWith({
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
    ValueGetter<Curve?>? reverseCurve,
    ValueGetter<double?>? padding,
    ValueGetter<double?>? iconGap,
    ValueGetter<double?>? dividerHeight,
    ValueGetter<ThemedColor?>? dividerColor,
    ValueGetter<IconData?>? arrowIcon,
    ValueGetter<ThemedColor?>? arrowIconColor,
  }) {
    return AccordionTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
      reverseCurve: reverseCurve == null ? this.reverseCurve : reverseCurve(),
      padding: padding == null ? this.padding : padding(),
      iconGap: iconGap == null ? this.iconGap : iconGap(),
      dividerHeight: dividerHeight == null
          ? this.dividerHeight
          : dividerHeight(),
      dividerColor: dividerColor == null ? this.dividerColor : dividerColor(),
      arrowIcon: arrowIcon == null ? this.arrowIcon : arrowIcon(),
      arrowIconColor: arrowIconColor == null
          ? this.arrowIconColor
          : arrowIconColor(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  AccordionTheme merge(AccordionTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return AccordionTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      duration: duration ?? fallback.duration,
      curve: curve ?? fallback.curve,
      reverseCurve: reverseCurve ?? fallback.reverseCurve,
      padding: padding ?? fallback.padding,
      iconGap: iconGap ?? fallback.iconGap,
      dividerHeight: dividerHeight ?? fallback.dividerHeight,
      dividerColor: dividerColor ?? fallback.dividerColor,
      arrowIcon: arrowIcon ?? fallback.arrowIcon,
      arrowIconColor: arrowIconColor ?? fallback.arrowIconColor,
    );
  }

  /// Curves, icons and colours step at `t = 0.5`; dimensions are lerped.
  static AccordionTheme lerp(AccordionTheme a, AccordionTheme b, double t) {
    return AccordionTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      duration: t < 0.5 ? a.duration : b.duration,
      curve: t < 0.5 ? a.curve : b.curve,
      reverseCurve: t < 0.5 ? a.reverseCurve : b.reverseCurve,
      padding: lerpDouble(a.padding, b.padding, t),
      iconGap: lerpDouble(a.iconGap, b.iconGap, t),
      dividerHeight: lerpDouble(a.dividerHeight, b.dividerHeight, t),
      dividerColor: t < 0.5 ? a.dividerColor : b.dividerColor,
      arrowIcon: t < 0.5 ? a.arrowIcon : b.arrowIcon,
      arrowIconColor: t < 0.5 ? a.arrowIconColor : b.arrowIconColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AccordionTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.duration == duration &&
        other.curve == curve &&
        other.reverseCurve == reverseCurve &&
        other.padding == padding &&
        other.iconGap == iconGap &&
        other.dividerHeight == dividerHeight &&
        other.dividerColor == dividerColor &&
        other.arrowIcon == arrowIcon &&
        other.arrowIconColor == arrowIconColor;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    duration,
    curve,
    reverseCurve,
    padding,
    iconGap,
    dividerHeight,
    dividerColor,
    arrowIcon,
    arrowIconColor,
  );
}

/// Baseline values; unset override fields fall through here.
const AccordionTheme accordionDefaults = AccordionTheme(
  duration: Duration(milliseconds: 200),
  curve: Curves.easeIn,
  reverseCurve: Curves.easeOut,
  dividerColor: ThemedColor.ref(ColorRef.muted),
  arrowIcon: LucideIcons.chevronUp,
  arrowIconColor: ThemedColor.ref(ColorRef.mutedForeground),
);
