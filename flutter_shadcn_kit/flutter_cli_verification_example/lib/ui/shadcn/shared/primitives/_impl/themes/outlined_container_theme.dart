part of '../../outlined_container.dart';

/// OutlinedContainerTheme defines a reusable type for this registry module.
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
}

/// A container widget with customizable border and surface effects.
