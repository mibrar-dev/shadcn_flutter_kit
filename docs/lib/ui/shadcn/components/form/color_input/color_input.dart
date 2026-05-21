// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme, IconButton, ButtonStyle;
import 'package:gap/gap.dart';

import '../../control/button/button.dart';
import '../../utility/color/color.dart';
import '../color_picker/color_picker.dart';
import '../../overlay/eye_dropper/eye_dropper.dart';
import '../form_field/form_field.dart';
import '../history/history.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/primitives/form_value_supplier.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/icons/lucide_icons.dart';

part '_impl/themes/base/color_input_theme.dart';

part '_impl/state/_color_input_state.dart';
part '_impl/utils/color_input_controller.dart';
part '_impl/core/controlled_color_input.dart';

/// A color input widget that allows users to select and edit colors.
///
/// [ColorInput] provides a comprehensive color selection interface with support
/// for multiple color spaces (HSV, HSL), alpha channel control, and eye dropper
/// functionality. The widget can be displayed in a popover or modal dialog.
///
/// The color picker supports:
/// - Multiple color representation modes (HSV, HSL)
/// - Optional alpha/opacity control
/// - Screen color sampling with eye dropper
/// - Customizable layout orientation
/// - Flexible positioning via popovers or dialogs
///
/// Example:
/// ```dart
/// ColorInput(
///   value: ColorDerivative.fromColor(Colors.blue),
///   onChanged: (color) {
///     print('Selected color: ${color.toColor()}');
///   },
///   showAlpha: true,
///   enableEyeDropper: true,
/// )
/// ```
class ColorInput extends StatefulWidget {
  /// The current color value.
  final ColorDerivative value;

  /// Called when the color is being changed (while dragging sliders, etc.).
  final ValueChanged<ColorDerivative>? onChanging;

  /// Called when the color change is complete (after releasing sliders, etc.).
  final ValueChanged<ColorDerivative>? onChanged;

  /// Whether to show alpha (opacity) controls.
  final bool? showAlpha;

  /// The initial color picker mode (HSV, HSL, etc.).
  final ColorPickerMode? initialMode;

  /// Whether to enable the eye dropper (screen color sampling) feature.
  final bool? enableEyeDropper;

  /// The alignment of the popover relative to the anchor.
  final AlignmentGeometry? popoverAlignment;

  /// The alignment point on the anchor widget for popover positioning.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Internal padding for the popover content.
  final EdgeInsetsGeometry? popoverPadding;

  /// Widget displayed when no color is selected.
  final Widget? placeholder;

  /// The mode for presenting the color picker (popover or modal).
  final PromptMode? promptMode;

  /// Title widget for the dialog when using modal mode.
  final Widget? dialogTitle;

  /// Whether to show color value labels.
  final bool? showLabel;

  /// Whether the color input is enabled.
  final bool? enabled;

  /// The layout orientation of the color input.
  final Axis? orientation;

  /// Whether to show the color history button.
  final bool showHistory;

  /// Creates a [ColorInput] widget.
  const ColorInput({
    super.key,
    required this.value,
    this.onChanging,
    this.onChanged,
    this.showAlpha,
    this.initialMode,
    this.enableEyeDropper = true,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.placeholder,
    this.promptMode,
    this.dialogTitle,
    this.showLabel,
    this.orientation,
    this.enabled,
    this.showHistory = true,
  });

  /// Creates the `State` object for this widget.
  @override
  State<ColorInput> createState() => _ColorInputState();
}
