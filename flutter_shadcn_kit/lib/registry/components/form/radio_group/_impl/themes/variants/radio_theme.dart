// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../radio_group.dart';

/// Theme data for customizing [Radio] widget appearance.
///
/// This class defines the visual properties that can be applied to
/// [Radio] widgets, including colors for different states and sizing.
/// These properties can be set at the theme level to provide consistent
/// styling across the application.
///
/// The theme affects the radio button's visual appearance in both
/// selected and unselected states, including border, background,
/// and active indicator colors.
class RadioTheme extends ComponentThemeData {
  /// Color of the radio indicator when selected.
  final Color? activeColor;

  /// Border color of the radio button.
  final Color? borderColor;

  /// Background color of the radio button.
  final Color? backgroundColor;

  /// Size of the radio button.
  final double? size;

  /// Creates a [RadioTheme].
  ///
  /// Parameters:
  /// - [activeColor] (`Color?`, optional): Selected indicator color.
  /// - [borderColor] (`Color?`, optional): Border color.
  /// - [backgroundColor] (`Color?`, optional): Background color.
  /// - [size] (`double?`, optional): Radio button size.
  const RadioTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.activeColor,
    this.borderColor,
    this.size,
    this.backgroundColor,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ///
  /// Parameters:
  /// - [activeColor] (`ValueGetter<Color?>?`, optional): New active color.
  /// - [borderColor] (`ValueGetter<Color?>?`, optional): New border color.
  /// - [backgroundColor] (`ValueGetter<Color?>?`, optional): New background color.
  /// - [size] (`ValueGetter<double?>?`, optional): New size.
  ///
  /// Returns: A new [RadioTheme] with updated properties.
  RadioTheme copyWith({
    ValueGetter<Color?>? activeColor,
    ValueGetter<Color?>? borderColor,
    ValueGetter<double?>? size,
    ValueGetter<Color?>? backgroundColor,
  }) {
    return RadioTheme(
      activeColor: activeColor == null ? this.activeColor : activeColor(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      size: size == null ? this.size : size(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioTheme &&
        other.activeColor == activeColor &&
        other.borderColor == borderColor &&
        other.size == size &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode =>
      Object.hash(activeColor, borderColor, size, backgroundColor);
}
