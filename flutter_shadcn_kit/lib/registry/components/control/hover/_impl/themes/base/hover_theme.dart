// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../../shared/theme/theme.dart';

/// Theme configuration for hover-related widgets and behaviors.
///
/// [HoverTheme] provides configurable durations and behaviors for hover
/// interactions throughout the application. It can be registered in the
/// component theme system to customize hover behavior globally.
///
/// Example:
/// ```dart
/// HoverTheme(
///   debounceDuration: Duration(milliseconds: 100),
///   hitTestBehavior: HitTestBehavior.opaque,
/// )
/// ```
class HoverTheme extends ComponentThemeData {
  /// Debounce duration for repeated hover events.
  ///
  /// When set, hover callbacks are throttled to fire at most once per this duration.
  final Duration? debounceDuration;

  /// Hit test behavior for hover detection.
  ///
  /// Determines how the widget participates in hit testing for mouse events.
  final HitTestBehavior? hitTestBehavior;

  /// Wait duration before showing hover feedback (e.g., tooltips).
  ///
  /// Delays the appearance of hover-triggered UI to avoid flashing on quick passes.
  final Duration? waitDuration;

  /// Minimum duration to keep hover feedback visible once shown.
  ///
  /// Prevents hover UI from disappearing too quickly.
  final Duration? minDuration;

  /// Duration for hover feedback show animations.
  final Duration? showDuration;

  /// Creates a [HoverTheme] with optional configuration values.
  const HoverTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.debounceDuration,
    this.hitTestBehavior,
    this.waitDuration,
    this.minDuration,
    this.showDuration,
  });

  /// Creates a copy of this theme with selectively replaced properties.
  ///
  /// Parameters are [ValueGetter] functions to allow setting values to `null`.
  HoverTheme copyWith({
    ValueGetter<Duration?>? debounceDuration,
    ValueGetter<HitTestBehavior?>? hitTestBehavior,
    ValueGetter<Duration?>? waitDuration,
    ValueGetter<Duration?>? minDuration,
    ValueGetter<Duration?>? showDuration,
  }) {
    return HoverTheme(
      debounceDuration: debounceDuration == null
          ? this.debounceDuration
          : debounceDuration(),
      hitTestBehavior: hitTestBehavior == null
          ? this.hitTestBehavior
          : hitTestBehavior(),
      waitDuration: waitDuration == null ? this.waitDuration : waitDuration(),
      minDuration: minDuration == null ? this.minDuration : minDuration(),
      showDuration: showDuration == null ? this.showDuration : showDuration(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is HoverTheme &&
        other.debounceDuration == debounceDuration &&
        other.hitTestBehavior == hitTestBehavior &&
        other.waitDuration == waitDuration &&
        other.minDuration == minDuration &&
        other.showDuration == showDuration;
  }

  @override
  int get hashCode => Object.hash(
    debounceDuration,
    hitTestBehavior,
    waitDuration,
    minDuration,
    showDuration,
  );
}
