// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../hover_card.dart';

/// Theme configuration for hover card behavior and appearance.
class HoverCardTheme extends ComponentThemeData {
  /// Stores `debounce` state/configuration for this implementation.
  final Duration? debounce;

  /// Stores `wait` state/configuration for this implementation.
  final Duration? wait;

  /// Stores `popoverAlignment` state/configuration for this implementation.
  final AlignmentGeometry? popoverAlignment;

  /// Stores `anchorAlignment` state/configuration for this implementation.
  final AlignmentGeometry? anchorAlignment;

  /// Stores `popoverOffset` state/configuration for this implementation.
  final Offset? popoverOffset;

  /// Stores `behavior` state/configuration for this implementation.
  final HitTestBehavior? behavior;

  /// Creates a `HoverCardTheme` instance.
  const HoverCardTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.debounce,
    this.wait,
    this.popoverAlignment,
    this.anchorAlignment,
    this.popoverOffset,
    this.behavior,
  });

  /// Creates a `HoverCardTheme` instance.
  HoverCardTheme copyWith({
    ValueGetter<Duration?>? debounce,
    ValueGetter<Duration?>? wait,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? anchorAlignment,
    ValueGetter<Offset?>? popoverOffset,
    ValueGetter<HitTestBehavior?>? behavior,
  }) {
    return HoverCardTheme(
      debounce: debounce == null ? this.debounce : debounce(),
      wait: wait == null ? this.wait : wait(),
      popoverAlignment: popoverAlignment == null
          ? this.popoverAlignment
          : popoverAlignment(),
      anchorAlignment: anchorAlignment == null
          ? this.anchorAlignment
          : anchorAlignment(),
      popoverOffset: popoverOffset == null
          ? this.popoverOffset
          : popoverOffset(),
      behavior: behavior == null ? this.behavior : behavior(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is HoverCardTheme &&
        other.debounce == debounce &&
        other.wait == wait &&
        other.popoverAlignment == popoverAlignment &&
        other.anchorAlignment == anchorAlignment &&
        other.popoverOffset == popoverOffset &&
        other.behavior == behavior;
  }

  @override
  int get hashCode => Object.hash(
    debounce,
    wait,
    popoverAlignment,
    anchorAlignment,
    popoverOffset,
    behavior,
  );
}
