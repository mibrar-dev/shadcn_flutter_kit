// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../circular_progress_indicator.dart';

/// Theme data for [CircularProgressIndicator].
class CircularProgressIndicatorTheme extends ComponentThemeData {
  /// Color value used by circular progress indicator painting or state styling.
  final Color? color;

  /// Color value used by circular progress indicator painting or state styling.
  final Color? backgroundColor;

  /// Layout/size setting that affects circular progress indicator rendering.
  final double? size;

  /// Layout/size setting that affects circular progress indicator rendering.
  final double? strokeWidth;

  /// Creates `CircularProgressIndicatorTheme` for configuring or rendering circular progress indicator.
  const CircularProgressIndicatorTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.backgroundColor,
    this.size,
    this.strokeWidth,
  });

  CircularProgressIndicatorTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<double?>? size,
    ValueGetter<double?>? strokeWidth,
  }) {
    return CircularProgressIndicatorTheme(
      color: color == null ? this.color : color(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      size: size == null ? this.size : size(),
      strokeWidth: strokeWidth == null ? this.strokeWidth : strokeWidth(),
    );
  }

  /// Compares two circular progress indicator values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CircularProgressIndicatorTheme &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.size == size &&
        other.strokeWidth == strokeWidth;
  }

  /// State flag that toggles specific circular progress indicator behavior.
  @override
  int get hashCode => Object.hash(color, backgroundColor, size, strokeWidth);
}
