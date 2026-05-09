// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../spinner.dart';

/// Theme data for [Spinner].
class SpinnerTheme extends ComponentThemeData {
  /// Color value used by spinner painting or state styling.
  final Color? color;

  /// Layout/size setting that affects spinner rendering.
  final double? size;

  /// Creates `SpinnerTheme` for configuring or rendering spinner.
  const SpinnerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.size,
  });

  SpinnerTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<double?>? size,
  }) {
    return SpinnerTheme(
      color: color == null ? this.color : color(),
      size: size == null ? this.size : size(),
    );
  }

  /// Compares two spinner values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpinnerTheme && other.color == color && other.size == size;
  }

  /// State flag that toggles specific spinner behavior.
  @override
  int get hashCode => Object.hash(color, size);
}
