// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../avatar.dart';

/// AvatarTheme defines theme tokens and defaults for the avatar widget.
class AvatarTheme extends ComponentThemeData {
  /// Layout/size setting that affects avatar rendering.
  final double? size;

  /// Layout/size setting that affects avatar rendering.
  final double? borderRadius;

  /// Color value used by avatar painting or state styling.
  final Color? backgroundColor;

  /// Controls how avatar content is aligned within available space.
  final AlignmentGeometry? badgeAlignment;

  /// Layout/size setting that affects avatar rendering.
  final double? badgeGap;

  /// Data consumed by `AvatarTheme` to render avatar content.
  final TextStyle? textStyle;

  /// Creates `AvatarTheme` for configuring or rendering avatar.
  const AvatarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.size,
    this.borderRadius,
    this.backgroundColor,
    this.badgeAlignment,
    this.badgeGap,
    this.textStyle,
  });

  AvatarTheme copyWith({
    ValueGetter<double?>? size,
    ValueGetter<double?>? borderRadius,
    ValueGetter<Color?>? backgroundColor,
    ValueGetter<AlignmentGeometry?>? badgeAlignment,
    ValueGetter<double?>? badgeGap,
    ValueGetter<TextStyle?>? textStyle,
  }) {
    return AvatarTheme(
      size: size == null ? this.size : size(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      badgeAlignment: badgeAlignment == null
          ? this.badgeAlignment
          : badgeAlignment(),
      badgeGap: badgeGap == null ? this.badgeGap : badgeGap(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
    );
  }

  /// Compares two avatar values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AvatarTheme &&
        other.size == size &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.badgeAlignment == badgeAlignment &&
        other.badgeGap == badgeGap &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(
    size,
    borderRadius,
    backgroundColor,
    badgeAlignment,
    badgeGap,
    textStyle,
  );
}
