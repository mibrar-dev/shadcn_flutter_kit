// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../outlined_container.dart';

/// Theme data for [OutlinedContainer].
class OutlinedContainerTheme extends ComponentThemeData {
  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `borderColor` state/configuration for this implementation.
  final Color? borderColor;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Stores `borderStyle` state/configuration for this implementation.
  final BorderStyle? borderStyle;

  /// Stores `borderWidth` state/configuration for this implementation.
  final double? borderWidth;

  /// Stores `boxShadow` state/configuration for this implementation.
  final List<BoxShadow>? boxShadow;

  /// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;

  /// Stores `surfaceOpacity` state/configuration for this implementation.
  final double? surfaceOpacity;

  /// Stores `surfaceBlur` state/configuration for this implementation.
  final double? surfaceBlur;

  /// Creates a `OutlinedContainerTheme` instance.
  const OutlinedContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderStyle,
    this.borderWidth,
    this.boxShadow,
    this.padding,
    this.surfaceOpacity,
    this.surfaceBlur,
  });

  /// Creates a `OutlinedContainerTheme` instance.
  OutlinedContainerTheme copyWith({
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<Color?>? borderColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<BorderStyle?>? borderStyle,
    ValueGetter<double?>? borderWidth,
    ValueGetter<List<BoxShadow>?>? boxShadow,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
  }) {
    return OutlinedContainerTheme(
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      borderStyle: borderStyle == null ? this.borderStyle : borderStyle(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      boxShadow: boxShadow == null ? this.boxShadow : boxShadow(),
      padding: padding == null ? this.padding : padding(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is OutlinedContainerTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.borderStyle == borderStyle &&
        other.borderWidth == borderWidth &&
        other.boxShadow == boxShadow &&
        other.padding == padding &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    borderColor,
    borderRadius,
    borderStyle,
    borderWidth,
    boxShadow,
    padding,
    surfaceOpacity,
    surfaceBlur,
  );
}
