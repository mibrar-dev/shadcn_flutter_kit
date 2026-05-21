// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

import '../../../../utility/alpha/alpha.dart';
import '../../../../../shared/theme/theme.dart';

part 'hsl_color_slider_type.dart';

part '../state/_hsl_color_slider_state.dart';
part 'hsl_color_slider_painter.dart';

/// A slider widget for adjusting HSL color components.
///
/// [HSLColorSlider] provides an interactive slider for modifying different
/// aspects of an HSL color (hue, saturation, lightness, and combinations).
/// The slider displays a gradient representing the selected color channel(s)
/// and allows users to drag to adjust values.
///
/// Example:
/// ```dart
/// HSLColorSlider(
///   color: HSLColor.fromColor(Colors.blue),
///   sliderType: HSLColorSliderType.hue,
///   onChanged: (newColor) {
///     print('New hue: ${newColor.hue}');
///   },
/// )
/// ```
class HSLColorSlider extends StatefulWidget {
  /// The current HSL color value.
  final HSLColor color;

  /// Called while the slider is being dragged.
  final ValueChanged<HSLColor>? onChanging;

  /// Called when the slider interaction is complete.
  final ValueChanged<HSLColor>? onChanged;

  /// The type of HSL component(s) this slider controls.
  final HSLColorSliderType sliderType;

  /// Whether to reverse the slider direction.
  final bool reverse;

  /// Corner radius for the slider.
  final Radius radius;

  /// Padding around the slider.
  final EdgeInsets padding;

  /// Creates an [HSLColorSlider].
  const HSLColorSlider({
    super.key,
    required this.color,
    this.onChanging,
    this.onChanged,
    required this.sliderType,
    this.reverse = false,
    this.radius = const Radius.circular(0),
    this.padding = const EdgeInsets.all(0),
  });

  /// Creates the `State` object for this widget.
  @override
  State<HSLColorSlider> createState() => _HSLColorSliderState();
}
