// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../formatted_input.dart';

/// Theme configuration for [FormattedInput] widget styling.
///
/// Defines visual properties for formatted input components including
/// height and padding. Applied globally through [ComponentTheme] or per-instance.
class FormattedInputTheme extends ComponentThemeData {
  /// The height of the formatted input.
  final double? height;

  /// Internal padding for the formatted input.
  final EdgeInsetsGeometry? padding;

  /// Creates a [FormattedInputTheme].
  const FormattedInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.height,
    this.padding,
  });

  /// Creates a copy of this theme with specified properties overridden.
  FormattedInputTheme copyWith({
    ValueGetter<double?>? height,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return FormattedInputTheme(
      height: height == null ? this.height : height(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormattedInputTheme &&
        other.height == height &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(height, padding);
}
