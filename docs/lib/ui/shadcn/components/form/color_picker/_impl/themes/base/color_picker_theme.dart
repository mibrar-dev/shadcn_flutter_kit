// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../color_picker.dart';

/// Theme configuration for [ColorPicker] widget styling and layout.
///
/// Defines visual and layout properties for color picker components including
/// spacing, orientation, and feature availability. Applied globally through
/// [ComponentTheme] or per-instance.
class ColorPickerTheme extends ComponentThemeData {
  /// Spacing between major color picker sections.
  final double? spacing;

  /// Spacing between individual controls within sections.
  final double? controlSpacing;

  /// Layout orientation (horizontal or vertical).
  final Axis? orientation;

  /// Whether to enable the eye dropper feature.
  final bool? enableEyeDropper;

  /// The size of color sliders.
  final double? sliderSize;

  /// Creates a [ColorPickerTheme].
  const ColorPickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.controlSpacing,
    this.orientation,
    this.enableEyeDropper,
    this.sliderSize,
  });

  /// Creates a copy of this theme with specified properties overridden.
  ColorPickerTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<double?>? controlSpacing,
    ValueGetter<Axis?>? orientation,
    ValueGetter<bool?>? enableEyeDropper,
    ValueGetter<double?>? sliderSize,
  }) {
    return ColorPickerTheme(
      spacing: spacing == null ? this.spacing : spacing(),
      controlSpacing: controlSpacing == null
          ? this.controlSpacing
          : controlSpacing(),
      orientation: orientation == null ? this.orientation : orientation(),
      enableEyeDropper: enableEyeDropper == null
          ? this.enableEyeDropper
          : enableEyeDropper(),
      sliderSize: sliderSize == null ? this.sliderSize : sliderSize(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorPickerTheme &&
        other.spacing == spacing &&
        other.controlSpacing == controlSpacing &&
        other.orientation == orientation &&
        other.sliderSize == sliderSize &&
        other.enableEyeDropper == enableEyeDropper;
  }

  @override
  int get hashCode => Object.hash(
    spacing,
    controlSpacing,
    orientation,
    enableEyeDropper,
    sliderSize,
  );
}
