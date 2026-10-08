// Registry-owned theme data for the `stage_container` component: the
// [StageBreakpoint] width strategy, the [StageContainerTheme] container and the
// token-derived `stageContainerDefaults`.
//
// User-owned overrides live in `stage_container_theme.dart`; CLI updates may
// replace this file. `StageBreakpoint` lives here because the theme references
// it, so the style layer never imports the widget layer.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// A width strategy for `StageContainer`: it snaps a measured width to the
/// minimum and maximum content widths the layout should use.
sealed class StageBreakpoint {
  /// Const constructor for subclasses.
  const StageBreakpoint();

  /// Default responsive breakpoints: 576, 768, 992, 1200, 1400.
  static const StageBreakpoint defaultBreakpoints =
      StagedBreakpoint.defaultBreakpoints();

  /// The minimum width this strategy allows.
  double get minSize;

  /// The maximum width this strategy allows.
  double get maxSize;

  /// Snapped-down content width for a container of [width].
  double getMinWidth(double width);

  /// Snapped-up content width for a container of [width].
  double getMaxWidth(double width);
}

/// A breakpoint that steps width into uniform multiples of [step].
final class ConstantBreakpoint extends StageBreakpoint {
  /// Creates a constant-step breakpoint.
  const ConstantBreakpoint(
    this.step, {
    this.minSize = 0,
    this.maxSize = double.infinity,
  }) : assert(step > 0, 'step must be positive');

  /// Step size; widths snap to multiples of it.
  final double step;

  @override
  final double minSize;

  @override
  final double maxSize;

  @override
  double getMinWidth(double width) => step * (width / step).floor();

  @override
  double getMaxWidth(double width) => step * (width / step).ceil();
}

/// A breakpoint that snaps width to the nearest value in [breakpoints].
final class StagedBreakpoint extends StageBreakpoint {
  /// Creates a staged breakpoint from ascending [breakpoints].
  ///
  /// [breakpoints] must not be empty; [minSize] / [maxSize] read its ends.
  const StagedBreakpoint(this.breakpoints);

  /// Creates a staged breakpoint with the default responsive values.
  const StagedBreakpoint.defaultBreakpoints()
    : breakpoints = _defaultBreakpoints;

  /// Default responsive breakpoints: mobile, tablet, desktop steps.
  static const List<double> _defaultBreakpoints = <double>[
    576,
    768,
    992,
    1200,
    1400,
  ];

  /// Ascending breakpoint widths.
  final List<double> breakpoints;

  @override
  double get minSize => breakpoints.first;

  @override
  double get maxSize => breakpoints.last;

  @override
  double getMinWidth(double width) {
    for (int i = 1; i < breakpoints.length; i++) {
      if (width < breakpoints[i]) {
        return breakpoints[i - 1];
      }
    }
    return width;
  }

  @override
  double getMaxWidth(double width) {
    for (final double breakpoint in breakpoints) {
      if (width < breakpoint) {
        return breakpoint;
      }
    }
    return maxSize;
  }
}

/// Padding and width strategy of a `StageContainer`.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class StageContainerTheme extends ComponentThemeData
    implements Mergeable<StageContainerTheme> {
  /// Creates a stage container theme.
  const StageContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.breakpoint,
    this.padding,
  });

  /// Width strategy; null resolves [StageBreakpoint.defaultBreakpoints].
  final StageBreakpoint? breakpoint;

  /// Base outer padding. A density-aware `EdgeInsetsDensity` resolves against
  /// the ambient container density; a plain `EdgeInsets` is used as-is.
  final EdgeInsetsGeometry? padding;

  /// Returns a copy with the given fields replaced.
  StageContainerTheme copyWith({
    ValueGetter<StageBreakpoint?>? breakpoint,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return StageContainerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      breakpoint: breakpoint == null ? this.breakpoint : breakpoint(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  StageContainerTheme merge(StageContainerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return StageContainerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      breakpoint: breakpoint ?? fallback.breakpoint,
      padding: padding ?? fallback.padding,
    );
  }

  /// Strategies step at t < 0.5; padding lerps.
  static StageContainerTheme lerp(
    StageContainerTheme a,
    StageContainerTheme b,
    double t,
  ) {
    return StageContainerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      breakpoint: t < 0.5 ? a.breakpoint : b.breakpoint,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StageContainerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.breakpoint == breakpoint &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    breakpoint,
    padding,
  );
}

/// Token-derived baseline: the default breakpoints and a horizontal padding of
/// `baseContainerPadding * 4.5` (72 at the default density). The old default
/// was a hard-coded `EdgeInsets.symmetric(horizontal: 72)` that ignored the
/// preset density; `EdgeInsetsDensity` now scales with it.
const StageContainerTheme stageContainerDefaults = StageContainerTheme(
  breakpoint: StageBreakpoint.defaultBreakpoints,
  padding: EdgeInsetsDensity.symmetric(horizontal: 4.5),
);
