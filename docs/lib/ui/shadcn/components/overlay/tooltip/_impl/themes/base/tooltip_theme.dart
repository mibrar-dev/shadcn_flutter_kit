// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../tooltip.dart';

/// Theme data for customizing tooltip container appearance.
class TooltipTheme extends ComponentThemeData {
  /// Stores `surfaceOpacity` state/configuration for this implementation.
  final double? surfaceOpacity;

  /// Stores `surfaceBlur` state/configuration for this implementation.
  final double? surfaceBlur;

  /// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Creates a `TooltipTheme` instance.
  const TooltipTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  /// Creates a `TooltipTheme` instance.
  TooltipTheme copyWith({
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return TooltipTheme(
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      padding: padding == null ? this.padding : padding(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TooltipTheme &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.padding == padding &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    surfaceOpacity,
    surfaceBlur,
    padding,
    backgroundColor,
    borderRadius,
  );
}
