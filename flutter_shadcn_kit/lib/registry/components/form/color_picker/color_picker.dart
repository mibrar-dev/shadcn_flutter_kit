// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart'
    hide Theme, TextField, IconButton, ButtonStyle;
import 'package:flutter/services.dart';

import '../../control/button/button.dart';
import '../../utility/color/color.dart';
import '../../overlay/eye_dropper/eye_dropper.dart';
import '../formatter/formatter.dart';
import '../history/history.dart';
import '../select/select.dart';
import '../text_field/text_field.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '_impl/core/hsl_color_slider.dart';
import '_impl/core/hsv_color_slider.dart';

part '_impl/core/color_picker_mode.dart';

part '_impl/state/_color_picker_state.dart';
part '_impl/core/_color_value_input.dart';
part '_impl/state/_color_value_input_state.dart';
part '_impl/core/color_controls.dart';
part '_impl/themes/base/color_picker_theme.dart';

/// A comprehensive color picker widget with multiple color mode support.
///
/// [ColorPicker] provides an interactive interface for selecting colors using
/// various color representation models (RGB, HSL, HSV, HEX). It supports alpha
/// channel control, eye dropper functionality, and customizable layout.
///
/// Features:
/// - Multiple color modes (RGB, HSL, HSV, HEX)
/// - Optional alpha/opacity control

/// - Screen color sampling with eye dropper
/// - Flexible layout orientation
/// - Real-time color updates
/// - Mode switching during use
///
/// Example:
/// ```dart
/// ColorPicker(
///   value: ColorDerivative.fromColor(Colors.blue),
///   onChanged: (color) {
///     print('Selected: ${color.toColor()}');
///   },
///   showAlpha: true,
///   initialMode: ColorPickerMode.hsv,
///   enableEyeDropper: true,
/// )
/// ```
class ColorPicker extends StatefulWidget {
  /// The current color value.
  final ColorDerivative value;

  /// Called when the color is finalized.
  final ValueChanged<ColorDerivative>? onChanged;

  /// Called continuously while the color is being changed.
  final ValueChanged<ColorDerivative>? onChanging;

  /// Whether to show alpha (opacity) controls.
  final bool showAlpha;

  /// Whether to show the color history button.
  final bool showHistoryButton;

  /// Whether to show the color history panel initially.
  final bool initialShowHistory;

  /// The initial color picker mode.
  final ColorPickerMode initialMode;

  /// Called when the color picker mode changes.
  final ValueChanged<ColorPickerMode>? onModeChanged;

  /// Called when the eye dropper button is pressed.
  final VoidCallback? onEyeDropperRequested;

  /// Whether to enable the eye dropper feature.
  final bool? enableEyeDropper;

  /// Layout orientation of the color picker.
  final Axis? orientation;

  /// Spacing between major sections.
  final double? spacing;

  /// Spacing between individual controls.
  final double? controlSpacing;

  /// Size of the color sliders.
  final double? sliderSize;

  /// Creates a [ColorPicker] widget.
  const ColorPicker({
    super.key,
    required this.value,
    this.onChanged,
    this.onChanging,
    this.showAlpha = false,
    this.initialMode = ColorPickerMode.rgb,
    this.onModeChanged,
    this.enableEyeDropper,
    this.onEyeDropperRequested,
    this.orientation,
    this.spacing,
    this.controlSpacing,
    this.sliderSize,
    this.showHistoryButton = true,
    this.initialShowHistory = false,
  });

  /// Creates the `State` object for this widget.
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

// Removed _FocusBuilder in favor of _ColorValueInput which internally
// handles focus state and onChanged gating.
