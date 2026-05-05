part of '../../../text_field.dart';

// This file contains mostly patches from another package/sdk
// due to changes that need to be made but cannot be done normally

/// Theme data for customizing [TextField] appearance.
///
/// This class defines the visual properties that can be applied to
/// [TextField] widgets, including border styling, fill state, padding,
/// and border radius. These properties can be set at the theme level
/// to provide consistent styling across the application.
class TextFieldTheme extends ComponentThemeData {
  /// Border radius for text field corners.
  ///
  /// If `null`, uses default border radius from the theme.
  final BorderRadiusGeometry? borderRadius;

  /// Whether the text field has a filled background.
  ///
  /// When `true`, applies a background fill color.
  final bool? filled;

  /// Padding inside the text field.
  ///
  /// If `null`, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  /// Border style for the text field.
  ///
  /// If `null`, uses default border from the theme.
  final Border? border;

  /// Creates a [TextFieldTheme].
  ///
  /// Parameters:
  /// - [border] (`Border?`, optional): Border style.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): Corner rounding.
  /// - [filled] (`bool?`, optional): Whether background is filled.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): Internal padding.
  const TextFieldTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.border,
    this.borderRadius,
    this.filled,
    this.padding,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// Parameters use value getters to allow `null` values to be explicitly set.
  TextFieldTheme copyWith({
    ValueGetter<Border?>? border,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<bool?>? filled,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return TextFieldTheme(
      border: border == null ? this.border : border(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      filled: filled == null ? this.filled : filled(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextFieldTheme &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        other.filled == filled &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(border, borderRadius, filled, padding);
}

/// Standard height for text field components in logical pixels.
const kTextFieldHeight = 34;

/// Abstract base class for controlling input feature visibility.
///
/// Defines when UI elements like clear buttons, password toggles, or other
/// input features should be visible based on text field state. Supports
/// logical operations (AND, OR, NOT) to combine multiple visibility conditions.
///
/// Example:
/// ```dart
/// // Show clear button when text is not empty and field is focused
/// final visibility = InputFeatureVisibility.textNotEmpty &
///                   InputFeatureVisibility.focused;
/// ```
