// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../star_rating.dart';

/// Theme data for customizing [StarRating] widget appearance.
///
/// This class defines the visual properties that can be applied to
/// [StarRating] widgets, including colors for filled and unfilled stars,
/// star sizing, and spacing between stars. These properties can be set
/// at the theme level to provide consistent styling across the application.
class StarRatingTheme extends ComponentThemeData {
  /// The color of the filled portion of the stars.
  final Color? activeColor;

  /// The color of the unfilled portion of the stars.
  final Color? backgroundColor;

  /// The size of each star.
  final double? starSize;

  /// The spacing between stars.
  final double? starSpacing;

  /// Creates a [StarRatingTheme].
  const StarRatingTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.activeColor,
    this.backgroundColor,
    this.starSize,
    this.starSpacing,
  });

  /// Returns a copy of this theme with the given fields replaced.
  StarRatingTheme copyWith({
    ValueGetter<Color?>? activeColor,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<double?>? starSize,
    ValueGetter<double?>? starSpacing,
  }) {
    return StarRatingTheme(
      activeColor: activeColor == null ? this.activeColor : activeColor(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      starSize: starSize == null ? this.starSize : starSize(),
      starSpacing: starSpacing == null ? this.starSpacing : starSpacing(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StarRatingTheme &&
        other.activeColor == activeColor &&
        other.backgroundColor == backgroundColor &&
        other.starSize == starSize &&
        other.starSpacing == starSpacing;
  }

  @override
  int get hashCode =>
      Object.hash(activeColor, backgroundColor, starSize, starSpacing);
}
