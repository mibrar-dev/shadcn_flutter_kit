// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../progress.dart';

/// Theme data for [Progress].
class ProgressTheme extends ComponentThemeData {
  /// Color value used by progress painting or state styling.
  final Color? color;

  /// Color value used by progress painting or state styling.
  final Color? backgroundColor;

  /// Layout/size setting that affects progress rendering.
  final BorderRadiusGeometry? borderRadius;

  /// Layout/size setting that affects progress rendering.
  final double? minHeight;

  /// Creates `ProgressTheme` for configuring or rendering progress.
  const ProgressTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.minHeight,
  });

  ProgressTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<double?>? minHeight,
  }) {
    return ProgressTheme(
      color: color == null ? this.color : color(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      minHeight: minHeight == null ? this.minHeight : minHeight(),
    );
  }

  /// Compares two progress values for structural equality.
  @override
  bool operator ==(Object other) {
    return other is ProgressTheme &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.minHeight == minHeight;
  }

  @override
  int get hashCode =>
      Object.hash(color, backgroundColor, borderRadius, minHeight);
}
