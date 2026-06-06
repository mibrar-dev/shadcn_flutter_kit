// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../phone_input.dart';

/// Theme data for [PhoneInput].
class PhoneInputTheme extends ComponentThemeData {
  /// The padding of the [PhoneInput].
  final EdgeInsetsGeometry? padding;

  /// The border radius of the [PhoneInput].
  final BorderRadiusGeometry? borderRadius;

  /// The constraints of the country selector popup.
  final BoxConstraints? popupConstraints;

  /// The maximum width of the [PhoneInput].
  final double? maxWidth;

  /// The height of the flag.
  final double? flagHeight;

  /// The width of the flag.
  final double? flagWidth;

  /// The gap between the flag and the country code.
  final double? flagGap;

  /// The gap between the country code and the text field.
  final double? countryGap;

  /// The shape of the flag.
  final Shape? flagShape;

  /// Theme data for [PhoneInput].
  const PhoneInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.padding,
    this.borderRadius,
    this.popupConstraints,
    this.maxWidth,
    this.flagHeight,
    this.flagWidth,
    this.flagGap,
    this.countryGap,
    this.flagShape,
  });

  /// Creates a copy of this [PhoneInputTheme] with the given values overridden.
  PhoneInputTheme copyWith({
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<BoxConstraints?>? popupConstraints,
    ValueGetter<double?>? maxWidth,
    ValueGetter<double?>? flagHeight,
    ValueGetter<double?>? flagWidth,
    ValueGetter<double?>? flagGap,
    ValueGetter<double?>? countryGap,
    ValueGetter<Shape?>? flagShape,
  }) {
    return PhoneInputTheme(
      padding: padding != null ? padding() : this.padding,
      borderRadius: borderRadius != null ? borderRadius() : this.borderRadius,
      popupConstraints: popupConstraints != null
          ? popupConstraints()
          : this.popupConstraints,
      maxWidth: maxWidth != null ? maxWidth() : this.maxWidth,
      flagHeight: flagHeight != null ? flagHeight() : this.flagHeight,
      flagWidth: flagWidth != null ? flagWidth() : this.flagWidth,
      flagGap: flagGap != null ? flagGap() : this.flagGap,
      countryGap: countryGap != null ? countryGap() : this.countryGap,
      flagShape: flagShape != null ? flagShape() : this.flagShape,
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhoneInputTheme &&
        other.padding == padding &&
        other.borderRadius == borderRadius &&
        other.popupConstraints == popupConstraints &&
        other.maxWidth == maxWidth &&
        other.flagHeight == flagHeight &&
        other.flagWidth == flagWidth &&
        other.flagGap == flagGap &&
        other.countryGap == countryGap &&
        other.flagShape == flagShape;
  }

  @override
  int get hashCode => Object.hash(
    padding,
    borderRadius,
    popupConstraints,
    maxWidth,
    flagHeight,
    flagWidth,
    flagGap,
    countryGap,
    flagShape,
  );

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return 'PhoneInputTheme(padding: $padding, borderRadius: $borderRadius, popupConstraints: $popupConstraints, maxWidth: $maxWidth, flagHeight: $flagHeight, flagWidth: $flagWidth, flagGap: $flagGap, countryGap: $countryGap, flagShape: $flagShape)';
  }
}
