// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover.dart';

/// HoverTheme defines a reusable type for this registry module.
class HoverTheme extends ComponentThemeData {
  /// Debounce duration for repeated hover events.
  final Duration? debounceDuration;

  /// Hit test behavior for hover detection.
  final HitTestBehavior? hitTestBehavior;

  /// Wait duration before showing hover feedback.
  final Duration? waitDuration;

  /// Minimum duration to keep hover feedback visible.
  final Duration? minDuration;

  /// Duration for hover feedback show animations.
  final Duration? showDuration;

  /// Creates a `HoverTheme` instance.
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

  /// Creates a `HoverTheme` instance.
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

/// Tracks mouse hover state and triggers callbacks.
