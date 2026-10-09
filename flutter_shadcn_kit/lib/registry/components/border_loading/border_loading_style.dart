// Registry-owned theme data for the `border_loading` component: the
// [BorderGradientSpec] shader spec, the [BorderLoadingTheme] container and
// the token-derived `borderLoadingDefaults`.
//
// Gradient colours are `ThemedColor`s so the default rainbow follows the
// preset tokens instead of the old hardcoded hex list. The old copy had no
// component theme at all; geometry/timing/opacity are themable now.

import 'dart:math' as math;
import 'dart:ui' show Shader, lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual rendering mode of [BorderLoading].
enum BorderLoadingMode {
  /// Rotating border that loops forever.
  sweepGradient,

  /// One or more tracer segments travelling around the outline.
  tracer,

  /// Determinate upload-style progress (`0.0 -> 1.0`).
  progress,

  /// A complete, non-animated border.
  staticBorder,
}

/// Gradient family supported by [BorderGradientSpec].
enum BorderGradientType { sweep, linear, radial }

/// Abstract shader spec: extend it for custom border painting.
@immutable
abstract class BorderLoadingSpec {
  /// Base constructor for all border shader specs.
  const BorderLoadingSpec();

  /// Creates the frame shader for [bounds] at normalized [progress].
  ///
  /// [colors] are the resolved gradient colours (the ambient tokens when the
  /// spec does not carry its own).
  Shader createShader({
    required Rect bounds,
    required double progress,
    required List<Color> colors,
  });
}

/// The built-in sweep/linear/radial gradient configuration.
@immutable
class BorderGradientSpec extends BorderLoadingSpec {
  /// Creates a gradient configuration.
  const BorderGradientSpec({
    this.type = BorderGradientType.sweep,
    this.colors,
    this.stops,
    this.gap = 0.22,
    this.rotateWithProgress = true,
    this.startAngle = -math.pi / 2,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.shiftWithProgress = false,
    this.center = Alignment.center,
    this.radius = 0.8,
    this.pulseWithProgress = false,
  });

  /// Gradient family to render.
  final BorderGradientType type;

  /// Gradient colours; null uses the token-derived default palette.
  final List<ThemedColor>? colors;

  /// Optional stops for [colors].
  final List<double>? stops;

  /// Sweep only: unpainted arc fraction (`0` = full ring).
  final double gap;

  /// Sweep only: rotates the gradient over time.
  final bool rotateWithProgress;

  /// Sweep only: start angle before runtime rotation.
  final double startAngle;

  /// Linear only: gradient begin alignment.
  final Alignment begin;

  /// Linear only: gradient end alignment.
  final Alignment end;

  /// Linear only: small animated alignment drift.
  final bool shiftWithProgress;

  /// Radial only: gradient centre alignment.
  final Alignment center;

  /// Radial only: base radius.
  final double radius;

  /// Radial only: animated radius pulsing.
  final bool pulseWithProgress;

  @override
  Shader createShader({
    required Rect bounds,
    required double progress,
    required List<Color> colors,
  }) {
    final List<Color> safe = colors.length < 2
        ? <Color>[...colors, ...colors]
        : colors;
    return switch (type) {
      BorderGradientType.linear => _linear(this, safe, bounds, progress),
      BorderGradientType.radial => _radial(this, safe, bounds, progress),
      BorderGradientType.sweep => _sweep(this, safe, bounds, progress),
    };
  }
}

/// One full rotation.
const double _kTau = math.pi * 2;

Shader _sweep(
  BorderGradientSpec spec,
  List<Color> colors,
  Rect bounds,
  double progress,
) {
  final double sweep = (1.0 - spec.gap).clamp(0.0, 1.0);
  final double rotation = spec.rotateWithProgress ? _kTau * progress : 0;
  return SweepGradient(
    startAngle: spec.startAngle,
    endAngle: spec.startAngle + _kTau * sweep,
    colors: colors,
    stops: spec.stops,
    transform: GradientRotation(rotation),
  ).createShader(bounds);
}

Shader _linear(
  BorderGradientSpec spec,
  List<Color> colors,
  Rect bounds,
  double progress,
) {
  Alignment begin = spec.begin;
  Alignment end = spec.end;
  if (spec.shiftWithProgress) {
    final double wiggle = math.sin(progress * _kTau) * 0.08;
    begin = Alignment(begin.x + wiggle, begin.y - wiggle);
    end = Alignment(end.x - wiggle, end.y + wiggle);
  }
  return LinearGradient(
    begin: begin,
    end: end,
    colors: colors,
    stops: spec.stops,
  ).createShader(bounds);
}

Shader _radial(
  BorderGradientSpec spec,
  List<Color> colors,
  Rect bounds,
  double progress,
) {
  double radius = spec.radius;
  if (spec.pulseWithProgress) {
    radius = (spec.radius + 0.08 * math.sin(progress * _kTau)).clamp(0.0, 2.0);
  }
  return RadialGradient(
    center: spec.center,
    radius: radius,
    colors: colors,
    stops: spec.stops,
  ).createShader(bounds);
}

/// Token-derived fallback palette: primary in the middle, `chart2`/`chart3`
/// outboard, transparent at both ends so the ring fades into nothing.
const List<ThemedColor> borderLoadingGradientColors = <ThemedColor>[
  ThemedColor.ref(ColorRef.primary, alpha: 0),
  ThemedColor.ref(ColorRef.primary),
  ThemedColor.ref(ColorRef.chart2),
  ThemedColor.ref(ColorRef.chart3),
  ThemedColor.ref(ColorRef.primary, alpha: 0),
];

/// Geometry, timing and opacity of one border loader.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class BorderLoadingTheme extends ComponentThemeData
    implements Mergeable<BorderLoadingTheme> {
  /// Creates a border-loading theme.
  const BorderLoadingTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.mode,
    this.strokeWidth,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.duration,
    this.curve,
    this.opacity,
  });

  /// Rendering mode; null falls through to the widget, then `sweepGradient`.
  final BorderLoadingMode? mode;

  /// Outline thickness; null resolves `2`.
  final double? strokeWidth;

  /// Gap between the painted border and the child; null resolves
  /// `EdgeInsets.all(strokeWidth)`.
  final EdgeInsetsGeometry? padding;

  /// Corner radius; null resolves `12`.
  final BorderRadiusGeometry? borderRadius;

  /// Fill behind the child; null draws none.
  final ThemedColor? backgroundColor;

  /// Cycle duration of the looping modes; null resolves `1200ms`.
  final Duration? duration;

  /// Easing applied to normalized progress; null resolves `Curves.linear`.
  final Curve? curve;

  /// Stroke opacity (`0..1`); null resolves `1`.
  final double? opacity;

  /// Returns a copy with the given fields replaced.
  BorderLoadingTheme copyWith({
    ValueGetter<BorderLoadingMode?>? mode,
    ValueGetter<double?>? strokeWidth,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<ThemedColor?>? backgroundColor,
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
    ValueGetter<double?>? opacity,
  }) {
    return BorderLoadingTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      mode: mode == null ? this.mode : mode(),
      strokeWidth: strokeWidth == null ? this.strokeWidth : strokeWidth(),
      padding: padding == null ? this.padding : padding(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
      opacity: opacity == null ? this.opacity : opacity(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  BorderLoadingTheme merge(BorderLoadingTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return BorderLoadingTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      mode: mode ?? fallback.mode,
      strokeWidth: strokeWidth ?? fallback.strokeWidth,
      padding: padding ?? fallback.padding,
      borderRadius: borderRadius ?? fallback.borderRadius,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
      duration: duration ?? fallback.duration,
      curve: curve ?? fallback.curve,
      opacity: opacity ?? fallback.opacity,
    );
  }

  /// Discrete values step at t < 0.5; scalars are lerped.
  static BorderLoadingTheme lerp(
    BorderLoadingTheme a,
    BorderLoadingTheme b,
    double t,
  ) {
    return BorderLoadingTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      mode: t < 0.5 ? a.mode : b.mode,
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
      duration: t < 0.5 ? a.duration : b.duration,
      curve: t < 0.5 ? a.curve : b.curve,
      opacity: lerpDouble(a.opacity, b.opacity, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BorderLoadingTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.mode == mode &&
        other.strokeWidth == strokeWidth &&
        other.padding == padding &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.duration == duration &&
        other.curve == curve &&
        other.opacity == opacity;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    mode,
    strokeWidth,
    padding,
    borderRadius,
    backgroundColor,
    duration,
    curve,
    opacity,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const BorderLoadingTheme borderLoadingDefaults = BorderLoadingTheme(
  strokeWidth: 2,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  duration: Duration(milliseconds: 1200),
  curve: Curves.linear,
  opacity: 1,
);

/// Resolves the four theme legs plus widget-leg overrides into concrete
/// build values.
BorderLoadingTheme resolveBorderLoadingStyle(
  BuildContext context, {
  BorderLoadingTheme? widgetTheme,
  BorderLoadingMode? mode,
  double? strokeWidth,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
  Color? backgroundColor,
  Duration? duration,
  Curve? curve,
  double? opacity,
}) {
  final BorderLoadingTheme resolved =
      resolveComponentStyle<BorderLoadingTheme, BorderLoadingTheme>(
        context,
        widget: widgetTheme,
        select: (t) => t,
        defaults: borderLoadingDefaults,
      );
  final double stroke = strokeWidth ?? resolved.strokeWidth ?? 2;
  return BorderLoadingTheme(
    mode: mode ?? resolved.mode ?? BorderLoadingMode.sweepGradient,
    strokeWidth: stroke,
    padding: padding ?? resolved.padding ?? EdgeInsets.all(stroke),
    borderRadius:
        borderRadius ??
        resolved.borderRadius ??
        const BorderRadius.all(Radius.circular(12)),
    backgroundColor: backgroundColor == null
        ? resolved.backgroundColor
        : ThemedColor.value(backgroundColor),
    duration:
        duration ?? resolved.duration ?? const Duration(milliseconds: 1200),
    curve: curve ?? resolved.curve ?? Curves.linear,
    opacity: (opacity ?? resolved.opacity ?? 1).clamp(0.0, 1.0),
  );
}
