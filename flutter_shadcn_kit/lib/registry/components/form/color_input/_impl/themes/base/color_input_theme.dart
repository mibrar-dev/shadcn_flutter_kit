// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../color_input.dart';

/// Theme configuration for [ColorInput] widget styling and behavior.
///
/// Defines the visual properties and default behaviors for color input components
/// including popover presentation, picker modes, and interaction features. Applied
/// globally through [ComponentTheme] or per-instance for customization.
///
/// Supports comprehensive customization of color picker appearance, positioning,
/// and functionality to match application design requirements.
class ColorInputTheme extends ComponentThemeData {
  /// Whether to display alpha (transparency) controls by default.
  ///
  /// When true, color pickers include alpha/opacity sliders and inputs.
  /// When false, only RGB/HSV controls are shown. Individual components
  /// can override this theme setting.
  final bool? showAlpha;

  /// Alignment point on the popover for anchor attachment.
  ///
  /// Determines where the color picker popover positions itself relative
  /// to the anchor widget. When null, uses framework default alignment.
  final AlignmentGeometry? popoverAlignment;

  /// Alignment point on the anchor widget for popover positioning.
  ///
  /// Specifies which part of the trigger widget the popover should align to.
  /// When null, uses framework default anchor alignment.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Internal padding applied to the color picker popover content.
  ///
  /// Controls spacing around the color picker interface within the popover
  /// container. When null, uses framework default padding.
  final EdgeInsetsGeometry? popoverPadding;

  /// Default interaction mode for color input triggers.
  ///
  /// Determines whether color selection opens a popover or modal dialog.
  /// When null, uses framework default prompt mode behavior.
  final PromptMode? mode;

  /// Default color picker interface type.
  ///
  /// Specifies whether to use HSV, HSL, or other color picker implementations.
  /// When null, uses framework default picker mode.
  final ColorPickerMode? pickerMode;

  /// Whether to enable screen color sampling functionality.
  ///
  /// When true, color pickers include tools to sample colors directly from
  /// the screen. Platform support varies. When null, uses framework default.
  final bool? enableEyeDropper;

  /// Whether to display color value labels in picker interfaces.
  ///
  /// When true, shows numeric color values (hex, RGB, HSV, etc.) alongside
  /// visual color pickers. When null, uses framework default label visibility.
  final bool? showLabel;

  /// The orientation of the color input layout.
  final Axis? orientation;

  /// Whether to show the color history panel.
  final bool? showHistory;

  /// Creates a [ColorInputTheme].
  ///
  /// All parameters are optional and fall back to framework defaults when null.
  /// The theme can be applied globally or to specific color input instances.
  const ColorInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.showAlpha,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.mode,
    this.pickerMode,
    this.enableEyeDropper,
    this.showLabel,
    this.orientation,
    this.showHistory,
  });

  /// Creates a copy of this theme with specified properties overridden.
  ///
  /// Each parameter function is called only if provided, allowing selective
  /// overrides while preserving existing values for unspecified properties.
  ColorInputTheme copyWith({
    ValueGetter<bool?>? showAlpha,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? popoverAnchorAlignment,
    ValueGetter<EdgeInsetsGeometry?>? popoverPadding,
    ValueGetter<PromptMode?>? mode,
    ValueGetter<ColorPickerMode?>? pickerMode,
    ValueGetter<bool?>? enableEyeDropper,
    ValueGetter<bool?>? showLabel,
    ValueGetter<Axis?>? orientation,
    ValueGetter<bool?>? showHistory,
  }) {
    return ColorInputTheme(
      showAlpha: showAlpha == null ? this.showAlpha : showAlpha(),
      popoverAlignment: popoverAlignment == null
          ? this.popoverAlignment
          : popoverAlignment(),
      popoverAnchorAlignment: popoverAnchorAlignment == null
          ? this.popoverAnchorAlignment
          : popoverAnchorAlignment(),
      popoverPadding: popoverPadding == null
          ? this.popoverPadding
          : popoverPadding(),
      mode: mode == null ? this.mode : mode(),
      pickerMode: pickerMode == null ? this.pickerMode : pickerMode(),
      enableEyeDropper: enableEyeDropper == null
          ? this.enableEyeDropper
          : enableEyeDropper(),
      orientation: orientation == null ? this.orientation : orientation(),
      showLabel: showLabel == null ? this.showLabel : showLabel(),
      showHistory: showHistory == null ? this.showHistory : showHistory(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorInputTheme &&
        other.showAlpha == showAlpha &&
        other.popoverAlignment == popoverAlignment &&
        other.popoverAnchorAlignment == popoverAnchorAlignment &&
        other.popoverPadding == popoverPadding &&
        other.mode == mode &&
        other.pickerMode == pickerMode &&
        other.enableEyeDropper == enableEyeDropper &&
        other.orientation == orientation &&
        other.showHistory == showHistory &&
        other.showLabel == showLabel;
  }

  @override
  int get hashCode => Object.hash(
    showAlpha,
    popoverAlignment,
    popoverAnchorAlignment,
    popoverPadding,
    mode,
    pickerMode,
    enableEyeDropper,
    orientation,
    showHistory,
    showLabel,
  );
}
