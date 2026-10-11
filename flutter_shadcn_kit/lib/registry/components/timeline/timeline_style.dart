// Registry-owned theme data for the `timeline` component: the
// [TimelineTheme] container and the token/density-derived `timelineDefaults`.
//
// User-owned overrides live in `timeline_theme.dart`; CLI updates may replace
// this file. Geometry defaults that depend on the ambient density resolve at
// build (see [resolveTimelineSurface]), so the default theme stays const.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Geometry and colour of one timeline: the three-column row layout.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class TimelineTheme extends ComponentThemeData
    implements Mergeable<TimelineTheme> {
  /// Creates a timeline theme.
  const TimelineTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.timeConstraints,
    this.spacing,
    this.dotSize,
    this.connectorThickness,
    this.color,
    this.rowGap,
  });

  /// Width constraints of the time column; null resolves `120 * scaling`.
  final BoxConstraints? timeConstraints;

  /// Horizontal gap between the three columns; null resolves the ambient
  /// base content padding.
  final double? spacing;

  /// Diameter of the indicator dot; null resolves `12 * scaling`.
  final double? dotSize;

  /// Thickness of the connector line; null resolves `2 * scaling`.
  final double? connectorThickness;

  /// Fallback colour for dots and connectors; null resolves the `primary`
  /// token. Per-entry colours win over this.
  final ThemedColor? color;

  /// Vertical gap between rows; null resolves `16 * scaling`.
  final double? rowGap;

  /// Returns a copy with the given fields replaced.
  TimelineTheme copyWith({
    ValueGetter<BoxConstraints?>? timeConstraints,
    ValueGetter<double?>? spacing,
    ValueGetter<double?>? dotSize,
    ValueGetter<double?>? connectorThickness,
    ValueGetter<ThemedColor?>? color,
    ValueGetter<double?>? rowGap,
  }) {
    return TimelineTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      timeConstraints: timeConstraints == null
          ? this.timeConstraints
          : timeConstraints(),
      spacing: spacing == null ? this.spacing : spacing(),
      dotSize: dotSize == null ? this.dotSize : dotSize(),
      connectorThickness: connectorThickness == null
          ? this.connectorThickness
          : connectorThickness(),
      color: color == null ? this.color : color(),
      rowGap: rowGap == null ? this.rowGap : rowGap(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TimelineTheme merge(TimelineTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return TimelineTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      timeConstraints: timeConstraints ?? fallback.timeConstraints,
      spacing: spacing ?? fallback.spacing,
      dotSize: dotSize ?? fallback.dotSize,
      connectorThickness: connectorThickness ?? fallback.connectorThickness,
      color: color ?? fallback.color,
      rowGap: rowGap ?? fallback.rowGap,
    );
  }

  /// Constraints step at t < 0.5; dimensions and colours are lerped.
  static TimelineTheme lerp(TimelineTheme a, TimelineTheme b, double t) {
    return TimelineTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      timeConstraints: t < 0.5 ? a.timeConstraints : b.timeConstraints,
      spacing: lerpDouble(a.spacing, b.spacing, t),
      dotSize: lerpDouble(a.dotSize, b.dotSize, t),
      connectorThickness: lerpDouble(
        a.connectorThickness,
        b.connectorThickness,
        t,
      ),
      color: t < 0.5 ? a.color : b.color,
      rowGap: lerpDouble(a.rowGap, b.rowGap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TimelineTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.timeConstraints == timeConstraints &&
        other.spacing == spacing &&
        other.dotSize == dotSize &&
        other.connectorThickness == connectorThickness &&
        other.color == color &&
        other.rowGap == rowGap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    timeConstraints,
    spacing,
    dotSize,
    connectorThickness,
    color,
    rowGap,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// Size fields stay null on purpose: their defaults depend on the ambient
/// scaling factor and resolve at build.
const TimelineTheme timelineDefaults = TimelineTheme();

// ---------------------------------------------------------------------------
// Build-time resolution.
// ---------------------------------------------------------------------------

/// Resolved geometry for one timeline build.
class TimelineSurface {
  /// Creates a resolved surface.
  const TimelineSurface({
    required this.timeConstraints,
    required this.spacing,
    required this.dotSize,
    required this.connectorThickness,
    required this.color,
    required this.rowGap,
    required this.contentStart,
    required this.colors,
  });

  /// Width of the time column.
  final BoxConstraints timeConstraints;

  /// Gap between the three columns.
  final double spacing;

  /// Dot diameter.
  final double dotSize;

  /// Connector thickness.
  final double connectorThickness;

  /// Dot/connector colour when the entry carries none.
  final Color color;

  /// Gap between rows.
  final double rowGap;

  /// Left inset of the title/content column.
  final double contentStart;

  /// Ambient colour tokens, used to resolve per-entry colours.
  final ShadcnColors colors;

  /// The colour an entry with [entryColor] paints its indicator/connector in.
  Color indicatorFor(ThemedColor? entryColor) {
    return entryColor?.resolve(colors) ?? color;
  }
}

/// Resolves the four theme legs plus widget-leg overrides into concrete
/// build values.
TimelineSurface resolveTimelineSurface(
  BuildContext context, {
  TimelineTheme? widgetTheme,
  BoxConstraints? timeConstraints,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final TimelineTheme resolved =
      resolveComponentStyle<TimelineTheme, TimelineTheme>(
        context,
        widget: widgetTheme,
        select: (t) => t,
        defaults: timelineDefaults,
      );
  final double scaling = theme.scaling;
  final double spacing =
      resolved.spacing ?? theme.density.baseContentPadding * scaling;
  final double dotSize = resolved.dotSize ?? 12 * scaling;
  final double connector = resolved.connectorThickness ?? 2 * scaling;
  return TimelineSurface(
    timeConstraints:
        timeConstraints ??
        resolved.timeConstraints ??
        BoxConstraints(minWidth: 120 * scaling, maxWidth: 120 * scaling),
    spacing: spacing,
    dotSize: dotSize,
    connectorThickness: connector,
    color: resolved.color?.resolve(theme.colors) ?? theme.colors.primary,
    rowGap: resolved.rowGap ?? 16 * scaling,
    contentStart: 4 * scaling,
    colors: theme.colors,
  );
}
