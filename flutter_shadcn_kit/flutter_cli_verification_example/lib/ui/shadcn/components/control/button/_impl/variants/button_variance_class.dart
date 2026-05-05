import 'package:flutter/widgets.dart';

import '../styles/abstract_button_style.dart';
import '../utils/button_helpers.dart';
import '../styles/button_state_property.dart';
import '../styles/component_theme_button_style.dart';
import '../themes/base/button_theme.dart';

/// ButtonVariance defines a reusable type for this registry module.
class ButtonVariance implements AbstractButtonStyle {
  /// Primary button variant with prominent filled appearance.
  ///
  /// Features high-contrast styling suitable for the main action on a screen.
  static const AbstractButtonStyle primary =
      ComponentThemeButtonStyle<PrimaryButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonPrimaryDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonPrimaryTextStyle,
          iconTheme: buttonPrimaryIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Secondary button variant with muted appearance.
  ///
  /// Features subtle styling suitable for supporting or alternative actions.
  static const AbstractButtonStyle secondary =
      ComponentThemeButtonStyle<SecondaryButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonSecondaryDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonSecondaryTextStyle,
          iconTheme: buttonSecondaryIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Outline button variant with border and transparent background.
  ///
  /// Features a visible border without filled background, suitable for secondary actions.
  static const AbstractButtonStyle outline =
      ComponentThemeButtonStyle<OutlineButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonOutlineDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonOutlineTextStyle,
          iconTheme: buttonOutlineIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Ghost button variant with minimal visual presence.
  ///
  /// Features no background or border by default, only showing on hover.
  static const AbstractButtonStyle ghost =
      ComponentThemeButtonStyle<GhostButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonGhostDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonGhostTextStyle,
          iconTheme: buttonGhostIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Link button variant resembling a text hyperlink.
  ///
  /// Features inline link styling with underline decoration.
  static const AbstractButtonStyle link =
      ComponentThemeButtonStyle<LinkButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonLinkDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonLinkTextStyle,
          iconTheme: buttonLinkIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Text button variant with only text content.
  ///
  /// Features minimal styling with no background or border decoration.
  static const AbstractButtonStyle text =
      ComponentThemeButtonStyle<TextButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonTextDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonTextTextStyle,
          iconTheme: buttonTextIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Destructive button variant for delete/remove actions.
  ///
  /// Features warning colors (typically red) to indicate data-destructive actions.
  static const AbstractButtonStyle destructive =
      ComponentThemeButtonStyle<DestructiveButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonDestructiveDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonDestructiveTextStyle,
          iconTheme: buttonDestructiveIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Fixed button variant with consistent dimensions.
  ///
  /// Features fixed sizing regardless of content, suitable for icon buttons.
  static const AbstractButtonStyle fixed =
      ComponentThemeButtonStyle<FixedButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonTextDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonStaticTextStyle,
          iconTheme: buttonStaticIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Menu button variant for dropdown menu triggers.
  ///
  /// Features appropriate spacing and styling for menu contexts.
  static const AbstractButtonStyle menu =
      ComponentThemeButtonStyle<MenuButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonMenuDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonMenuPadding,
          textStyle: buttonMenuTextStyle,
          iconTheme: buttonMenuIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Menubar button variant for horizontal menu bars.
  ///
  /// Features optimized padding and styling for menubar contexts.
  static const AbstractButtonStyle menubar =
      ComponentThemeButtonStyle<MenubarButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonMenuDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonMenubarPadding,
          textStyle: buttonMenuTextStyle,
          iconTheme: buttonMenuIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Muted button variant with subdued appearance.
  ///
  /// Features low-contrast styling for minimal visual impact.
  static const AbstractButtonStyle muted =
      ComponentThemeButtonStyle<MutedButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonTextDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonPadding,
          textStyle: buttonMutedTextStyle,
          iconTheme: buttonMutedIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  /// Card button variant with elevated appearance.
  ///
  /// Features subtle shadows and borders creating a card-like elevated look.
  static const AbstractButtonStyle card =
      ComponentThemeButtonStyle<CardButtonTheme>(
        fallback: ButtonVariance(
          decoration: buttonCardDecoration,
          mouseCursor: buttonMouseCursor,
          padding: buttonCardPadding,
          textStyle: buttonCardTextStyle,
          iconTheme: buttonCardIconTheme,
          margin: buttonZeroMargin,
        ),
      );

  @override
  /// Stores `decoration` state/configuration for this implementation.
  final ButtonStateProperty<Decoration> decoration;
  @override
  /// Stores `mouseCursor` state/configuration for this implementation.
  final ButtonStateProperty<MouseCursor> mouseCursor;
  @override
  /// Stores `padding` state/configuration for this implementation.
  final ButtonStateProperty<EdgeInsetsGeometry> padding;
  @override
  /// Stores `textStyle` state/configuration for this implementation.
  final ButtonStateProperty<TextStyle> textStyle;
  @override
  /// Stores `iconTheme` state/configuration for this implementation.
  final ButtonStateProperty<IconThemeData> iconTheme;
  @override
  /// Stores `margin` state/configuration for this implementation.
  final ButtonStateProperty<EdgeInsetsGeometry> margin;

  /// Creates a custom [ButtonVariance] with the specified style properties.
  ///
  /// All parameters are required [ButtonStateProperty] functions that resolve
  /// values based on the button's current state.
  const ButtonVariance({
    required this.decoration,
    required this.mouseCursor,
    required this.padding,
    required this.textStyle,
    required this.iconTheme,
    required this.margin,
  });

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ButtonVariance &&
        other.decoration == decoration &&
        other.mouseCursor == mouseCursor &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.iconTheme == iconTheme &&
        other.margin == margin;
  }

  @override
  int get hashCode {
    return Object.hash(
      decoration,
      mouseCursor,
      padding,
      textStyle,
      iconTheme,
      margin,
    );
  }

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'ButtonVariance(decoration: $decoration, mouseCursor: $mouseCursor, padding: $padding, textStyle: $textStyle, iconTheme: $iconTheme, margin: $margin)';
  }
}

/// A button state property delegate that always returns the same value.
///
/// [ButtonStylePropertyAll] implements a [ButtonStatePropertyDelegate] that
/// ignores the context, states, and default value parameters, always returning
/// its stored [value]. This is useful for creating static style properties that
/// don't change based on button state.
///
/// Example:
/// ```dart
/// final alwaysRedDecoration = ButtonStylePropertyAll<Decoration>(
///   BoxDecoration(color: Colors.red),
/// );
/// ```
