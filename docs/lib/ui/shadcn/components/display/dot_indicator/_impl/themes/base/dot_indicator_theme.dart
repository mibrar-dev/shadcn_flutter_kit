// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../dot_indicator.dart';

/// Theme data for [DotIndicator] and children.
class DotIndicatorTheme extends ComponentThemeData {
  /// Layout/size setting that affects dot indicator rendering.
  final double? spacing;

  /// Layout/size setting that affects dot indicator rendering.
  final EdgeInsetsGeometry? padding;

  /// Input parameter used by `DotIndicatorTheme` during rendering and behavior handling.
  final DotBuilder? dotBuilder;

  /// Layout/size setting that affects dot indicator rendering.
  final double? size;

  /// Layout/size setting that affects dot indicator rendering.
  final double? borderRadius;

  /// Color value used by dot indicator painting or state styling.
  final Color? activeColor;

  /// Color value used by dot indicator painting or state styling.
  final Color? inactiveColor;

  /// Color value used by dot indicator painting or state styling.
  final Color? inactiveBorderColor;

  /// Layout/size setting that affects dot indicator rendering.
  final double? inactiveBorderWidth;

  /// Creates `DotIndicatorTheme` for configuring or rendering dot indicator.
  const DotIndicatorTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.padding,
    this.dotBuilder,
    this.size,
    this.borderRadius,
    this.activeColor,
    this.inactiveColor,
    this.inactiveBorderColor,
    this.inactiveBorderWidth,
  });

  DotIndicatorTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<DotBuilder?>? dotBuilder,
    ValueGetter<double?>? size,
    ValueGetter<double?>? borderRadius,
    ValueGetter<Color?>? activeColor,
    ValueGetter<Color?>? inactiveColor,
    ValueGetter<Color?>? inactiveBorderColor,
    ValueGetter<double?>? inactiveBorderWidth,
  }) {
    return DotIndicatorTheme(
      spacing: spacing == null ? this.spacing : spacing(),
      padding: padding == null ? this.padding : padding(),
      dotBuilder: dotBuilder == null ? this.dotBuilder : dotBuilder(),
      size: size == null ? this.size : size(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      activeColor: activeColor == null ? this.activeColor : activeColor(),
      inactiveColor: inactiveColor == null
          ? this.inactiveColor
          : inactiveColor(),
      inactiveBorderColor: inactiveBorderColor == null
          ? this.inactiveBorderColor
          : inactiveBorderColor(),
      inactiveBorderWidth: inactiveBorderWidth == null
          ? this.inactiveBorderWidth
          : inactiveBorderWidth(),
    );
  }

  /// Compares two dot indicator values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DotIndicatorTheme &&
        other.spacing == spacing &&
        other.padding == padding &&
        other.dotBuilder == dotBuilder &&
        other.size == size &&
        other.borderRadius == borderRadius &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.inactiveBorderColor == inactiveBorderColor &&
        other.inactiveBorderWidth == inactiveBorderWidth;
  }

  @override
  int get hashCode => Object.hash(
    spacing,
    padding,
    dotBuilder,
    size,
    borderRadius,
    activeColor,
    inactiveColor,
    inactiveBorderColor,
    inactiveBorderWidth,
  );
}
