// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color_input.dart';

/// A controlled color input widget integrating with form state management.
///
/// Implements [ControlledComponent] to provide automatic form integration,
/// validation, and state management for color selection.
class ControlledColorInput extends StatelessWidget
    with ControlledComponent<ColorDerivative> {
  @override
  final ColorDerivative initialValue;

  @override
  final ValueChanged<ColorDerivative>? onChanged;

  @override
  final bool enabled;

  @override
  final ColorInputController? controller;

  /// Whether to show alpha channel controls.
  final bool? showAlpha;

  /// Alignment of the popover relative to the anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popover.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover.
  final EdgeInsetsGeometry? popoverPadding;

  /// Placeholder widget when no color is selected.
  final Widget? placeholder;

  /// The prompt display mode for the color picker.
  final PromptMode? promptMode;

  /// Title widget for the dialog mode.
  final Widget? dialogTitle;

  /// Whether to show color labels.
  final bool? showLabel;

  /// Orientation of color controls.
  final Axis? orientation;

  /// Whether to enable the eye dropper tool.
  final bool? enableEyeDropper;

  /// The initial color picker mode to display.
  final ColorPickerMode? initialMode;

  /// Callback invoked while the color is being changed (live updates).
  final ValueChanged<ColorDerivative>? onChanging;

  /// Creates a controlled color input.
  const ControlledColorInput({
    super.key,
    required this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.controller,
    this.showAlpha,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.placeholder,
    this.promptMode,
    this.dialogTitle,
    this.showLabel,
    this.orientation,
    this.enableEyeDropper,
    this.initialMode,
    this.onChanging,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return ControlledComponentAdapter<ColorDerivative>(
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      controller: controller,
      builder: (context, data) {
        return ColorInput(
          value: data.value,
          onChanged: data.onChanged,
          enableEyeDropper: enableEyeDropper,
          initialMode: initialMode,
          onChanging: onChanging,
          showAlpha: showAlpha,
          popoverAlignment: popoverAlignment,
          popoverAnchorAlignment: popoverAnchorAlignment,
          popoverPadding: popoverPadding,
          placeholder: placeholder,
          promptMode: promptMode,
          dialogTitle: dialogTitle,
          showLabel: showLabel,
          orientation: orientation,
          enabled: data.enabled,
        );
      },
    );
  }
}
