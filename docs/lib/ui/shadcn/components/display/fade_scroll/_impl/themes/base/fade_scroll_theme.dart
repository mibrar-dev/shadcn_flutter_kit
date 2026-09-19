// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../fade_scroll.dart';

/// Theme configuration for [FadeScroll].
class FadeScrollTheme extends ComponentThemeData {
  /// The distance from the start before fading begins.
  final double? startOffset;

  /// The distance from the end before fading begins.
  final double? endOffset;

  /// The gradient colors used for the fade.
  final List<Color>? gradient;

  /// Creates a [FadeScrollTheme].
  const FadeScrollTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.startOffset,
    this.endOffset,
    this.gradient,
  });

  /// Creates a copy of this theme but with the given fields replaced.
  FadeScrollTheme copyWith({
    ValueGetter<double?>? startOffset,
    ValueGetter<double?>? endOffset,
    ValueGetter<List<Color>?>? gradient,
  }) {
    return FadeScrollTheme(
      startOffset: startOffset == null ? this.startOffset : startOffset(),
      endOffset: endOffset == null ? this.endOffset : endOffset(),
      gradient: gradient == null ? this.gradient : gradient(),
    );
  }

  /// Compares two fade scroll values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FadeScrollTheme &&
        other.startOffset == startOffset &&
        other.endOffset == endOffset &&
        listEquals(other.gradient, gradient);
  }

  @override
  int get hashCode => Object.hash(startOffset, endOffset, gradient);
}
