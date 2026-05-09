// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../chip.dart';

/// Theme config for chips that share padding/style defaults.
class ChipTheme extends ComponentThemeData {
  /// Layout/size setting that affects chip rendering.
  final EdgeInsetsGeometry? padding;

  /// Style/theme override that customizes `ChipTheme` appearance.
  final AbstractButtonStyle? style;

  /// Creates `ChipTheme` for configuring or rendering chip.
  const ChipTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.padding,
    this.style,
  });

  ChipTheme copyWith({
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<AbstractButtonStyle?>? style,
  }) {
    return ChipTheme(
      padding: padding == null ? this.padding : padding(),
      style: style == null ? this.style : style(),
    );
  }

  /// Compares two chip values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChipTheme &&
        other.padding == padding &&
        other.style == style;
  }

  /// State flag that toggles specific chip behavior.
  @override
  int get hashCode => Object.hash(padding, style);
}
