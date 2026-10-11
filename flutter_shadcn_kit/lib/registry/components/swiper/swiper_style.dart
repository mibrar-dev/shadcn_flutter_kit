// Registry-owned theme data for the `swiper` component: the [SwiperTheme]
// behavioural slice and the per-variant `swiperDefaults` rows.
//
// User-owned overrides live in `swiper_theme.dart`; CLI updates may replace
// this file. `SwiperVariant` lives here (not in `swiper.dart`) so the style
// layer never imports the widget layer; `swiper.dart` re-exports it.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// How a [Swiper] presents its overlay.
enum SwiperVariant {
  /// A side panel that slides in from an edge.
  drawer,

  /// A sheet that expands along its edge.
  sheet,
}

/// Behavioural configuration of a [Swiper]'s panel and swipe gesture.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. The panel's colours,
/// border and handle come from `DrawerTheme`, resolved by the swiper.
class SwiperTheme extends ComponentThemeData implements Mergeable<SwiperTheme> {
  /// Creates a swiper theme.
  const SwiperTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.expands,
    this.draggable,
    this.barrierDismissible,
    this.useSafeArea,
    this.showDragHandle,
    this.borderRadius,
    this.maxSize,
    this.barrierColor,
    this.behavior,
    this.threshold,
  });

  /// Whether the panel fills its slide axis; null uses the variant default.
  final bool? expands;

  /// Whether the open panel can be dragged away.
  final bool? draggable;

  /// Whether tapping the barrier dismisses the panel.
  final bool? barrierDismissible;

  /// Whether the panel respects the device safe area.
  final bool? useSafeArea;

  /// Whether the panel draws a drag handle; null keeps `DrawerTheme`.
  final bool? showDragHandle;

  /// Inner-corner radius of the panel; null keeps `DrawerTheme`.
  final BorderRadius? borderRadius;

  /// Panel extent along its slide axis; null keeps `DrawerTheme`'s `maxSize`.
  final double? maxSize;

  /// Barrier colour; null uses black at 50%.
  final ThemedColor? barrierColor;

  /// Hit test behaviour of the swipe gesture.
  final HitTestBehavior? behavior;

  /// Fraction (0..1) of the panel at which a release settles it open.
  final double? threshold;

  /// Returns a copy with the given fields replaced.
  SwiperTheme copyWith({
    ValueGetter<bool?>? expands,
    ValueGetter<bool?>? draggable,
    ValueGetter<bool?>? barrierDismissible,
    ValueGetter<bool?>? useSafeArea,
    ValueGetter<bool?>? showDragHandle,
    ValueGetter<BorderRadius?>? borderRadius,
    ValueGetter<double?>? maxSize,
    ValueGetter<ThemedColor?>? barrierColor,
    ValueGetter<HitTestBehavior?>? behavior,
    ValueGetter<double?>? threshold,
  }) {
    return SwiperTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      expands: expands == null ? this.expands : expands(),
      draggable: draggable == null ? this.draggable : draggable(),
      barrierDismissible: barrierDismissible == null
          ? this.barrierDismissible
          : barrierDismissible(),
      useSafeArea: useSafeArea == null ? this.useSafeArea : useSafeArea(),
      showDragHandle: showDragHandle == null
          ? this.showDragHandle
          : showDragHandle(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      maxSize: maxSize == null ? this.maxSize : maxSize(),
      barrierColor: barrierColor == null ? this.barrierColor : barrierColor(),
      behavior: behavior == null ? this.behavior : behavior(),
      threshold: threshold == null ? this.threshold : threshold(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SwiperTheme merge(SwiperTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SwiperTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      expands: expands ?? fallback.expands,
      draggable: draggable ?? fallback.draggable,
      barrierDismissible: barrierDismissible ?? fallback.barrierDismissible,
      useSafeArea: useSafeArea ?? fallback.useSafeArea,
      showDragHandle: showDragHandle ?? fallback.showDragHandle,
      borderRadius: borderRadius ?? fallback.borderRadius,
      maxSize: maxSize ?? fallback.maxSize,
      barrierColor: barrierColor ?? fallback.barrierColor,
      behavior: behavior ?? fallback.behavior,
      threshold: threshold ?? fallback.threshold,
    );
  }

  /// Flags and colours step at t < 0.5; geometry and numbers lerp.
  static SwiperTheme lerp(SwiperTheme a, SwiperTheme b, double t) {
    return SwiperTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      expands: t < 0.5 ? a.expands : b.expands,
      draggable: t < 0.5 ? a.draggable : b.draggable,
      barrierDismissible: t < 0.5 ? a.barrierDismissible : b.barrierDismissible,
      useSafeArea: t < 0.5 ? a.useSafeArea : b.useSafeArea,
      showDragHandle: t < 0.5 ? a.showDragHandle : b.showDragHandle,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      maxSize: lerpDouble(a.maxSize, b.maxSize, t),
      barrierColor: t < 0.5 ? a.barrierColor : b.barrierColor,
      behavior: t < 0.5 ? a.behavior : b.behavior,
      threshold: lerpDouble(a.threshold, b.threshold, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SwiperTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.expands == expands &&
        other.draggable == draggable &&
        other.barrierDismissible == barrierDismissible &&
        other.useSafeArea == useSafeArea &&
        other.showDragHandle == showDragHandle &&
        other.borderRadius == borderRadius &&
        other.maxSize == maxSize &&
        other.barrierColor == barrierColor &&
        other.behavior == behavior &&
        other.threshold == threshold;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    expands,
    draggable,
    barrierDismissible,
    useSafeArea,
    showDragHandle,
    borderRadius,
    maxSize,
    barrierColor,
    behavior,
    threshold,
  );
}

/// Baseline configuration for [variant]; every unset override falls through.
///
/// A `drawer` keeps the drawer's own `maxSize` width (`expands: false`); a
/// `sheet` fills its edge (`expands: true`). The old `SwiperHandler.drawer`
/// forced `expands: true`, which made side drawers cover the whole screen.
SwiperTheme swiperDefaults(SwiperVariant variant) {
  return switch (variant) {
    SwiperVariant.drawer => const SwiperTheme(
      expands: false,
      draggable: true,
      barrierDismissible: true,
      useSafeArea: true,
      showDragHandle: true,
      behavior: HitTestBehavior.translucent,
      threshold: 0.5,
    ),
    SwiperVariant.sheet => const SwiperTheme(
      expands: true,
      draggable: false,
      barrierDismissible: true,
      useSafeArea: true,
      behavior: HitTestBehavior.translucent,
      threshold: 0.5,
    ),
  };
}
