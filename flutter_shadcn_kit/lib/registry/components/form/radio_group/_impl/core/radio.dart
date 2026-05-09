// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../radio_group.dart';

/// A radio button widget that displays a circular selection indicator.
///
/// [Radio] provides a visual representation of a selectable option within
/// a radio group. It displays as a circular button with an inner dot when
/// selected and an empty circle when unselected. The widget supports focus
/// indication and customizable colors and sizing.
///
/// The radio button animates smoothly between selected and unselected states,
/// providing visual feedback to user interactions. It integrates with the
/// focus system to provide accessibility support and keyboard navigation.
///
/// Typically used within [RadioItem] or [RadioGroup] components rather than
/// standalone, as it only provides the visual representation without the
/// interaction logic.
///
/// Example:
/// ```dart
/// Radio(
///   value: isSelected,
///   focusing: hasFocus,
///   size: 20,
///   activeColor: Colors.blue,
/// );
/// ```
class Radio extends StatelessWidget {
  /// Whether this radio button is selected.
  ///
  /// When true, displays the inner selection indicator.
  /// When false, shows only the outer circle border.
  final bool value;

  /// Whether this radio button currently has focus.
  ///
  /// When true, displays a focus outline around the radio button
  /// for accessibility and keyboard navigation indication.
  final bool focusing;

  /// Size of the radio button in logical pixels.
  ///
  /// Controls both the width and height of the circular radio button.
  /// If null, uses the size from the current [RadioTheme].
  final double? size;

  /// Color of the inner selection indicator when selected.
  ///
  /// Applied to the inner dot that appears when [value] is true.
  /// If null, uses the activeColor from the current [RadioTheme].
  final Color? activeColor;

  /// Color of the outer border circle.
  ///
  /// Applied to the border of the radio button in both selected and
  /// unselected states. If null, uses the borderColor from the current [RadioTheme].
  final Color? borderColor;

  /// Background color of the radio button circle.
  ///
  /// Applied as the fill color behind the border. If null, uses the
  /// backgroundColor from the current [RadioTheme].
  final Color? backgroundColor;

  /// Creates a [Radio] with the specified selection state and styling.
  ///
  /// The [value] parameter is required and determines whether the radio
  /// appears selected. All other parameters are optional and will fall
  /// back to theme values when not specified.
  ///
  /// Parameters:
  /// - [value] (bool, required): Whether the radio button is selected
  /// - [focusing] (bool, default: false): Whether the radio has focus
  /// - [size] (double?, optional): Size of the radio button in pixels
  /// - [activeColor] (Color?, optional): Color of the selection indicator
  /// - [borderColor] (Color?, optional): Color of the outer border
  /// - [backgroundColor] (Color?, optional): Color of the background fill
  ///
  /// Example:
  /// ```dart
  /// Radio(
  ///   value: selectedValue == itemValue,
  ///   focusing: focusNode.hasFocus,
  ///   size: 18,
  /// );
  /// ```
  const Radio({
    super.key,
    required this.value,
    this.focusing = false,
    this.size,
    this.activeColor,
    this.borderColor,
    this.backgroundColor,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<RadioTheme>(context);
    final size = styleValue<double>(
      widgetValue: this.size,
      themeValue: compTheme?.size,
      defaultValue: 16 * theme.scaling,
    );
    final activeColor = styleValue<Color>(
      widgetValue: this.activeColor,
      themeValue: compTheme?.activeColor,
      defaultValue: theme.colorScheme.primary,
    );
    final borderColor = styleValue<Color>(
      widgetValue: this.borderColor,
      themeValue: compTheme?.borderColor,
      defaultValue: theme.colorScheme.input,
    );
    final backgroundColor = styleValue<Color>(
      widgetValue: this.backgroundColor,
      themeValue: compTheme?.backgroundColor,
      defaultValue: theme.colorScheme.input.scaleAlpha(0.3),
    );
    final innerSize = value ? (size - (6 + 2) * theme.scaling) : 0.0;
    return FocusOutline(
      focused: focusing,
      shape: BoxShape.circle,
      child: AnimatedContainer(
        duration: kDefaultDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: kDefaultDuration,
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activeColor,
            ),
          ),
        ),
      ),
    );
  }
}
