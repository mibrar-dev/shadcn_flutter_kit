// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../input_otp.dart';

/// Theme data for customizing [InputOTP] widget appearance.
///
/// This class defines the visual properties that can be applied to
/// [InputOTP] widgets, including spacing between OTP input fields
/// and the height of the input containers. These properties can be
/// set at the theme level to provide consistent styling across the application.
class InputOTPTheme extends ComponentThemeData {
  /// Horizontal spacing between OTP input fields.
  final double? spacing;

  /// Height of each OTP input container.
  final double? height;

  /// Creates an [InputOTPTheme].
  ///
  /// Parameters:
  /// - [spacing] (`double?`, optional): Space between input fields.
  /// - [height] (`double?`, optional): Height of input containers.
  const InputOTPTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.height,
  });

  /// Creates a copy of this theme with specified properties overridden.
  ///
  /// Parameters:
  /// - [spacing] (`ValueGetter<double?>?`, optional): New spacing value.
  /// - [height] (`ValueGetter<double?>?`, optional): New height value.
  ///
  /// Returns: A new [InputOTPTheme] with updated properties.
  InputOTPTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<double?>? height,
  }) {
    return InputOTPTheme(
      spacing: spacing == null ? this.spacing : spacing(),
      height: height == null ? this.height : height(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputOTPTheme &&
        other.spacing == spacing &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(spacing, height);
}
