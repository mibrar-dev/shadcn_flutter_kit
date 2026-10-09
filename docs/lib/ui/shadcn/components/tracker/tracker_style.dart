// Registry-owned theme data for the `tracker` component: the [TrackerLevel]
// enum, the [TrackerTheme] container and the token-derived `trackerDefaults`.
//
// The old `TrackerLevel` was an abstract class with four `static const`
// instances, each carrying its own literal `Color` (`Colors.green` etc.). The
// colour moves into [TrackerTheme] (one `ThemedColor` per level) so a preset
// switch restyles the tracker, and the four levels become one enum (PLAN §4
// rule 1: variants are data). User-owned overrides live in `tracker_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Activity level of one tracker segment.
///
/// Replaces the old abstract `TrackerLevel` class; its `name` getter is gone
/// (the tracker never rendered it — the caller supplies the tooltip).
enum TrackerLevel { fine, warning, critical, unknown }

/// Appearance of the tracker component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class TrackerTheme extends ComponentThemeData
    implements Mergeable<TrackerTheme> {
  /// Creates a tracker theme.
  const TrackerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.fine,
    this.warning,
    this.critical,
    this.unknown,
    this.radius,
    this.gap,
    this.itemHeight,
  });

  /// Fill of a [TrackerLevel.fine] segment.
  final ThemedColor? fine;

  /// Fill of a [TrackerLevel.warning] segment.
  final ThemedColor? warning;

  /// Fill of a [TrackerLevel.critical] segment.
  final ThemedColor? critical;

  /// Fill of a [TrackerLevel.unknown] segment.
  final ThemedColor? unknown;

  /// Outer corner radius; null resolves the ambient `radiusMd` at build.
  final double? radius;

  /// Gap between two segments.
  final double? gap;

  /// Height of every segment.
  final double? itemHeight;

  /// The fill for [level].
  ThemedColor? forLevel(TrackerLevel level) {
    return switch (level) {
      TrackerLevel.fine => fine,
      TrackerLevel.warning => warning,
      TrackerLevel.critical => critical,
      TrackerLevel.unknown => unknown,
    };
  }

  /// Returns a copy with the given fields replaced.
  TrackerTheme copyWith({
    ValueGetter<ThemedColor?>? fine,
    ValueGetter<ThemedColor?>? warning,
    ValueGetter<ThemedColor?>? critical,
    ValueGetter<ThemedColor?>? unknown,
    ValueGetter<double?>? radius,
    ValueGetter<double?>? gap,
    ValueGetter<double?>? itemHeight,
  }) {
    return TrackerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      fine: fine == null ? this.fine : fine(),
      warning: warning == null ? this.warning : warning(),
      critical: critical == null ? this.critical : critical(),
      unknown: unknown == null ? this.unknown : unknown(),
      radius: radius == null ? this.radius : radius(),
      gap: gap == null ? this.gap : gap(),
      itemHeight: itemHeight == null ? this.itemHeight : itemHeight(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TrackerTheme merge(TrackerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return TrackerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      fine: fine ?? fallback.fine,
      warning: warning ?? fallback.warning,
      critical: critical ?? fallback.critical,
      unknown: unknown ?? fallback.unknown,
      radius: radius ?? fallback.radius,
      gap: gap ?? fallback.gap,
      itemHeight: itemHeight ?? fallback.itemHeight,
    );
  }

  /// Colours step at `t = 0.5`; dimensions are lerped.
  static TrackerTheme lerp(TrackerTheme a, TrackerTheme b, double t) {
    return TrackerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      fine: t < 0.5 ? a.fine : b.fine,
      warning: t < 0.5 ? a.warning : b.warning,
      critical: t < 0.5 ? a.critical : b.critical,
      unknown: t < 0.5 ? a.unknown : b.unknown,
      radius: lerpDouble(a.radius, b.radius, t),
      gap: lerpDouble(a.gap, b.gap, t),
      itemHeight: lerpDouble(a.itemHeight, b.itemHeight, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TrackerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.fine == fine &&
        other.warning == warning &&
        other.critical == critical &&
        other.unknown == unknown &&
        other.radius == radius &&
        other.gap == gap &&
        other.itemHeight == itemHeight;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    fine,
    warning,
    critical,
    unknown,
    radius,
    gap,
    itemHeight,
  );
}

/// Default gap between two tracker segments.
const double trackerDefaultGap = 2;

/// Default height of a tracker segment.
const double trackerDefaultItemHeight = 32;

// Status colours: shadcn has no green/amber token, so `fine` and `warning`
// are literals (same precedent as `gooey_toast`'s status rows); `critical`
// and `unknown` follow tokens so a preset switch restyles them.
const _trackerFine = ThemedColor.value(Color(0xFF22C55E));
const _trackerWarning = ThemedColor.value(Color(0xFFF59E0B));
const _trackerCritical = ThemedColor.ref(ColorRef.destructive);
const _trackerUnknown = ThemedColor.ref(ColorRef.mutedForeground);

/// Token-derived baseline; `radius` stays null and resolves the ambient
/// `radiusMd` at build time instead of being frozen into this const.
const TrackerTheme trackerDefaults = TrackerTheme(
  fine: _trackerFine,
  warning: _trackerWarning,
  critical: _trackerCritical,
  unknown: _trackerUnknown,
  gap: trackerDefaultGap,
  itemHeight: trackerDefaultItemHeight,
);
