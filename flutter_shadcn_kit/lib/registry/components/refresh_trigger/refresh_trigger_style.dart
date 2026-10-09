// Registry-owned theme data for the `refresh_trigger` component.
//
// User-owned overrides live in `refresh_trigger_theme.dart`; CLI updates
// may replace this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Lifecycle stages of a refresh trigger.
enum TriggerStage {
  /// Waiting for user interaction.
  idle,

  /// Pulling, but below the arming extent.
  pulling,

  /// The refresh callback is running.
  refreshing,

  /// The refresh finished; showing confirmation briefly.
  completed,
}

/// Snapshot of refresh state handed to indicator builders.
class RefreshTriggerStage {
  /// Creates a stage snapshot.
  const RefreshTriggerStage(
    this.stage,
    this.extent,
    this.direction,
    this.reverse,
  );

  /// Current lifecycle stage.
  final TriggerStage stage;

  /// Animated pull extent (0..1 of the arming distance and beyond).
  final Animation<double> extent;

  /// Pull gesture direction.
  final Axis direction;

  /// Whether the pull direction is inverted.
  final bool reverse;

  /// Current numeric pull extent.
  double get extentValue => extent.value;
}

/// Builds the indicator for a [RefreshTriggerStage].
typedef RefreshIndicatorBuilder =
    Widget Function(BuildContext context, RefreshTriggerStage stage);

/// Theme of the pull-to-refresh trigger.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget). Extents
/// are logical pixels multiplied by the ambient scaling at resolve time.
class RefreshTriggerTheme extends ComponentThemeData
    implements Mergeable<RefreshTriggerTheme> {
  /// Creates a refresh trigger theme.
  const RefreshTriggerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.minExtent,
    this.maxExtent,
    this.indicatorBuilder,
    this.curve,
    this.completeDuration,
  });

  /// Pull distance arming the refresh. Default: 75.
  final double? minExtent;

  /// Maximum pull distance. Default: 150.
  final double? maxExtent;

  /// Indicator for a [RefreshTriggerStage]; null uses the default pill.
  final RefreshIndicatorBuilder? indicatorBuilder;

  /// Animation curve for extent changes. Default: `Curves.easeOutSine`.
  final Curve? curve;

  /// How long the completion state shows. Default: 500ms.
  final Duration? completeDuration;

  /// Returns a copy with the given fields replaced.
  RefreshTriggerTheme copyWith({
    ValueGetter<double?>? minExtent,
    ValueGetter<double?>? maxExtent,
    ValueGetter<RefreshIndicatorBuilder?>? indicatorBuilder,
    ValueGetter<Curve?>? curve,
    ValueGetter<Duration?>? completeDuration,
  }) {
    return RefreshTriggerTheme(
      minExtent: minExtent == null ? this.minExtent : minExtent(),
      maxExtent: maxExtent == null ? this.maxExtent : maxExtent(),
      indicatorBuilder: indicatorBuilder == null
          ? this.indicatorBuilder
          : indicatorBuilder(),
      curve: curve == null ? this.curve : curve(),
      completeDuration: completeDuration == null
          ? this.completeDuration
          : completeDuration(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  RefreshTriggerTheme merge(RefreshTriggerTheme? fallback) {
    if (fallback == null) return this;
    return RefreshTriggerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      minExtent: minExtent ?? fallback.minExtent,
      maxExtent: maxExtent ?? fallback.maxExtent,
      indicatorBuilder: indicatorBuilder ?? fallback.indicatorBuilder,
      curve: curve ?? fallback.curve,
      completeDuration: completeDuration ?? fallback.completeDuration,
    );
  }

  /// Scalars interpolate; the rest steps at `t = 0.5`.
  static RefreshTriggerTheme lerp(
    RefreshTriggerTheme a,
    RefreshTriggerTheme b,
    double t,
  ) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return RefreshTriggerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      minExtent: scale(a.minExtent, b.minExtent),
      maxExtent: scale(a.maxExtent, b.maxExtent),
      indicatorBuilder: t < 0.5 ? a.indicatorBuilder : b.indicatorBuilder,
      curve: t < 0.5 ? a.curve : b.curve,
      completeDuration: t < 0.5 ? a.completeDuration : b.completeDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RefreshTriggerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.minExtent == minExtent &&
        other.maxExtent == maxExtent &&
        other.indicatorBuilder == indicatorBuilder &&
        other.curve == curve &&
        other.completeDuration == completeDuration;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    minExtent,
    maxExtent,
    indicatorBuilder,
    curve,
    completeDuration,
  );
}

/// Built-in refresh trigger defaults.
const RefreshTriggerTheme refreshTriggerDefaults = RefreshTriggerTheme(
  minExtent: 75,
  maxExtent: 150,
  curve: Curves.easeOutSine,
  completeDuration: Duration(milliseconds: 500),
);
