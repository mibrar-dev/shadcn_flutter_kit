import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/clickable.dart';
import '../styles/abstract_button_style.dart';
import '../styles/button_state_property_delegate.dart';
import '../styles/copy_with_button_style.dart';

/// Extension methods on [AbstractButtonStyle] for convenient style modifications.
///
/// Provides utility methods to create modified copies of button styles with
/// selective property changes. These methods enable fluent style customization
/// without manually implementing [ButtonVariance] instances.
extension ButtonStyleExtension on AbstractButtonStyle {
  /// Creates a copy of this style with selectively replaced properties.
  ///
  /// Each parameter is a [ButtonStatePropertyDelegate] that can modify or
  /// replace the corresponding style property. If all parameters are `null`,
  /// returns the original style unchanged for efficiency.
  ///
  /// Example:
  /// ```dart
  /// final customStyle = ButtonVariance.primary.copyWith(
  ///   decoration: (context, states, defaultDecoration) {
  ///     // Custom decoration logic
  ///     return myCustomDecoration;
  ///   },
  /// );
  /// ```
  AbstractButtonStyle copyWith({
    ButtonStatePropertyDelegate<Decoration>? decoration,
    ButtonStatePropertyDelegate<MouseCursor>? mouseCursor,
    ButtonStatePropertyDelegate<EdgeInsetsGeometry>? padding,
    ButtonStatePropertyDelegate<TextStyle>? textStyle,
    ButtonStatePropertyDelegate<IconThemeData>? iconTheme,
    ButtonStatePropertyDelegate<EdgeInsetsGeometry>? margin,
  }) {
    if (decoration == null &&
        mouseCursor == null &&
        padding == null &&
        textStyle == null &&
        iconTheme == null &&
        margin == null) {
      return this;
    }
    return CopyWithButtonStyle(
      this,
      decoration,
      mouseCursor,
      padding,
      textStyle,
      iconTheme,
      margin,
    );
  }

  /// Creates a copy with custom background colors for different states.
  ///
  /// Modifies the decoration to apply state-specific background colors.
  /// Only works with [BoxDecoration]; other decoration types are returned unchanged.
  ///
  /// Parameters:
  /// - [color]: Background color for normal state
  /// - [hoverColor]: Background color when hovered
  /// - [focusColor]: Background color when focused
  /// - [disabledColor]: Background color when disabled
  ///
  /// Example:
  /// ```dart
  /// final style = ButtonVariance.primary.withBackgroundColor(
  ///   color: Colors.blue,
  ///   hoverColor: Colors.blue.shade700,
  /// );
  /// ```
  AbstractButtonStyle withBackgroundColor({
    Color? color,
    Color? hoverColor,
    Color? focusColor,
    Color? disabledColor,
  }) {
    return copyWith(
      decoration: (context, states, decoration) {
        if (decoration is BoxDecoration) {
          return decoration.copyWith(
            color: states.disabled
                ? disabledColor ?? decoration.color
                : states.hovered
                ? hoverColor ?? decoration.color
                : states.focused
                ? focusColor ?? decoration.color
                : color,
          );
        }
        return decoration;
      },
    );
  }

  /// Creates a copy with custom foreground colors for different states.
  ///
  /// Modifies both text style and icon theme to apply state-specific foreground
  /// colors for text and icons.
  ///
  /// Parameters:
  /// - [color]: Foreground color for normal state
  /// - [hoverColor]: Foreground color when hovered
  /// - [focusColor]: Foreground color when focused
  /// - [disabledColor]: Foreground color when disabled
  ///
  /// Example:
  /// ```dart
  /// final style = ButtonVariance.outline.withForegroundColor(
  ///   color: Colors.black,
  ///   disabledColor: Colors.grey,
  /// );
  /// ```
  AbstractButtonStyle withForegroundColor({
    Color? color,
    Color? hoverColor,
    Color? focusColor,
    Color? disabledColor,
  }) {
    return copyWith(
      textStyle: (context, states, textStyle) {
        return textStyle.copyWith(
          color: states.disabled
              ? disabledColor ?? textStyle.color
              : states.hovered
              ? hoverColor ?? textStyle.color
              : states.focused
              ? focusColor ?? textStyle.color
              : color,
        );
      },
      iconTheme: (context, states, iconTheme) {
        return iconTheme.copyWith(
          color: states.disabled
              ? disabledColor ?? iconTheme.color
              : states.hovered
              ? hoverColor ?? iconTheme.color
              : states.focused
              ? focusColor ?? iconTheme.color
              : color,
        );
      },
    );
  }

  /// Creates a copy with custom borders for different states.
  ///
  /// Modifies the decoration to apply state-specific borders.
  /// Only works with [BoxDecoration]; other decoration types are returned unchanged.
  ///
  /// Parameters:
  /// - [border]: Border for normal state
  /// - [hoverBorder]: Border when hovered
  /// - [focusBorder]: Border when focused
  /// - [disabledBorder]: Border when disabled
  ///
  /// Example:
  /// ```dart
  /// final style = ButtonVariance.outline.withBorder(
  ///   border: Border.all(color: Colors.blue),
  ///   hoverBorder: Border.all(color: Colors.blue.shade700, width: 2),
  /// );
  /// ```
  AbstractButtonStyle withBorder({
    Border? border,
    Border? hoverBorder,
    Border? focusBorder,
    Border? disabledBorder,
  }) {
    return copyWith(
      decoration: (context, states, decoration) {
        if (decoration is BoxDecoration) {
          return decoration.copyWith(
            border: states.disabled
                ? disabledBorder ?? decoration.border
                : states.hovered
                ? hoverBorder ?? decoration.border
                : states.focused
                ? focusBorder ?? decoration.border
                : border,
          );
        }
        return decoration;
      },
    );
  }

  /// Creates a copy with custom border radius for different states.
  ///
  /// Modifies the decoration to apply state-specific border radius.
  /// Only works with [BoxDecoration]; other decoration types are returned unchanged.
  ///
  /// Parameters:
  /// - [borderRadius]: Border radius for normal state
  /// - [hoverBorderRadius]: Border radius when hovered
  /// - [focusBorderRadius]: Border radius when focused
  /// - [disabledBorderRadius]: Border radius when disabled
  ///
  /// Example:
  /// ```dart
  /// final style = ButtonVariance.primary.withBorderRadius(
  ///   borderRadius: BorderRadius.circular(8),
  ///   hoverBorderRadius: BorderRadius.circular(12),
  /// );
  /// ```
  AbstractButtonStyle withBorderRadius({
    BorderRadiusGeometry? borderRadius,
    BorderRadiusGeometry? hoverBorderRadius,
    BorderRadiusGeometry? focusBorderRadius,
    BorderRadiusGeometry? disabledBorderRadius,
  }) {
    return copyWith(
      decoration: (context, states, decoration) {
        if (decoration is BoxDecoration) {
          return decoration.copyWith(
            borderRadius: states.disabled
                ? disabledBorderRadius ?? decoration.borderRadius
                : states.hovered
                ? hoverBorderRadius ?? decoration.borderRadius
                : states.focused
                ? focusBorderRadius ?? decoration.borderRadius
                : borderRadius,
          );
        }
        return decoration;
      },
    );
  }

  /// Creates a copy with custom padding for different states.
  ///
  /// Modifies the padding to apply state-specific values.
  ///
  /// Parameters:
  /// - [padding]: Padding for normal state
  /// - [hoverPadding]: Padding when hovered
  /// - [focusPadding]: Padding when focused
  /// - [disabledPadding]: Padding when disabled
  ///
  /// Note: The implementation currently doesn't change padding based on state
  /// due to a limitation in the state resolution logic, but the API is provided
  /// for consistency with other style properties.
  AbstractButtonStyle withPadding({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? hoverPadding,
    EdgeInsetsGeometry? focusPadding,
    EdgeInsetsGeometry? disabledPadding,
  }) {
    return copyWith(
      padding: (context, states, padding) {
        return states.disabled
            ? disabledPadding ?? padding
            : states.hovered
            ? hoverPadding ?? padding
            : states.focused
            ? focusPadding ?? padding
            : padding;
      },
    );
  }
}
