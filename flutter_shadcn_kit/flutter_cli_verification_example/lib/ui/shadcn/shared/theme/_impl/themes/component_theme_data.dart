part of '../../theme.dart';

/// ComponentThemeData defines a reusable type for this registry module.
abstract class ComponentThemeData {
  /// Optional density override for this component theme.
  final Density? themeDensity;

  /// Optional spacing token override for this component theme.
  final SpacingScale? themeSpacing;

  /// Optional shadow token override for this component theme.
  final ShadowScale? themeShadows;

  /// Creates a [ComponentThemeData].
  const ComponentThemeData({
    this.themeDensity,
    this.themeSpacing,
    this.themeShadows,
  });
}

/// An inherited widget that provides component-specific theme data.
///
/// Allows components to provide custom theme data that overrides or extends
/// the global theme. The type parameter `T` specifies the theme data type.
///
/// Example:
/// ```dart
/// ComponentTheme<ButtonTheme>(
///   data: ButtonTheme(backgroundColor: Colors.blue),
///   child: MyButton(),
/// )
/// ```
