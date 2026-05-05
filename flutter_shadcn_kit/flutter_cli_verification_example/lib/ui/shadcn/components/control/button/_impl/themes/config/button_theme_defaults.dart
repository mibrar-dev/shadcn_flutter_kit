// ignore_for_file: unused_element_parameter

import 'package:flutter/widgets.dart';

import '../../styles/abstract_button_style.dart';
import '../../styles/button_density.dart';
import '../../styles/button_shape.dart';
import '../../styles/button_size.dart';
import '../../styles/button_style_class.dart';
import '../../styles/button_state_property.dart';
import '../../utils/button_helpers.dart';
import '../../variants/button_variance.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in button variants + style helpers
// ═══════════════════════════════════════════════════════════

class _ButtonVariantThemeDefaults {
  const _ButtonVariantThemeDefaults({
    required this.decoration,
    required this.mouseCursor,
    required this.padding,
    required this.textStyle,
    required this.iconTheme,
    required this.margin,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.normal,
    this.shape = ButtonShape.rectangle,
    this.disableTransition = false,
  });

  final ButtonStateProperty<Decoration> decoration;
  final ButtonStateProperty<MouseCursor> mouseCursor;
  final ButtonStateProperty<EdgeInsetsGeometry> padding;
  final ButtonStateProperty<TextStyle> textStyle;
  final ButtonStateProperty<IconThemeData> iconTheme;
  final ButtonStateProperty<EdgeInsetsGeometry> margin;

  /// From variant widgets: `ButtonSize.normal`
  final ButtonSize size;

  /// From variant widgets: `ButtonDensity.normal`
  final ButtonDensity density;

  /// From variant widgets: `ButtonShape.rectangle`
  final ButtonShape shape;

  /// From variant widgets: `disableTransition = false`
  final bool disableTransition;
}

class PrimaryButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const PrimaryButtonThemeDefaults()
    : super(
        decoration: buttonPrimaryDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonPrimaryTextStyle,
        iconTheme: buttonPrimaryIconTheme,
        margin: buttonZeroMargin,
      );
}

class SecondaryButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const SecondaryButtonThemeDefaults()
    : super(
        decoration: buttonSecondaryDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonSecondaryTextStyle,
        iconTheme: buttonSecondaryIconTheme,
        margin: buttonZeroMargin,
      );
}

class OutlineButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const OutlineButtonThemeDefaults()
    : super(
        decoration: buttonOutlineDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonOutlineTextStyle,
        iconTheme: buttonOutlineIconTheme,
        margin: buttonZeroMargin,
      );
}

class GhostButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const GhostButtonThemeDefaults()
    : super(
        decoration: buttonGhostDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonGhostTextStyle,
        iconTheme: buttonGhostIconTheme,
        margin: buttonZeroMargin,
      );
}

class LinkButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const LinkButtonThemeDefaults()
    : super(
        decoration: buttonLinkDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonLinkTextStyle,
        iconTheme: buttonLinkIconTheme,
        margin: buttonZeroMargin,
      );
}

class TextButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const TextButtonThemeDefaults()
    : super(
        decoration: buttonTextDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonTextTextStyle,
        iconTheme: buttonTextIconTheme,
        margin: buttonZeroMargin,
      );
}

class DestructiveButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const DestructiveButtonThemeDefaults()
    : super(
        decoration: buttonDestructiveDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonDestructiveTextStyle,
        iconTheme: buttonDestructiveIconTheme,
        margin: buttonZeroMargin,
      );
}

class FixedButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const FixedButtonThemeDefaults()
    : super(
        decoration: buttonTextDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonStaticTextStyle,
        iconTheme: buttonStaticIconTheme,
        margin: buttonZeroMargin,
      );
}

class MenuButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const MenuButtonThemeDefaults()
    : super(
        decoration: buttonMenuDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonMenuPadding,
        textStyle: buttonMenuTextStyle,
        iconTheme: buttonMenuIconTheme,
        margin: buttonZeroMargin,
      );
}

class MenubarButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const MenubarButtonThemeDefaults()
    : super(
        decoration: buttonMenuDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonMenubarPadding,
        textStyle: buttonMenuTextStyle,
        iconTheme: buttonMenuIconTheme,
        margin: buttonZeroMargin,
      );
}

class MutedButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const MutedButtonThemeDefaults()
    : super(
        decoration: buttonTextDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonMutedTextStyle,
        iconTheme: buttonMutedIconTheme,
        margin: buttonZeroMargin,
      );
}

class CardButtonThemeDefaults extends _ButtonVariantThemeDefaults {
  const CardButtonThemeDefaults()
    : super(
        decoration: buttonCardDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonCardPadding,
        textStyle: buttonCardTextStyle,
        iconTheme: buttonCardIconTheme,
        margin: buttonZeroMargin,
      );
}

class ButtonCoreWidgetDefaults {
  const ButtonCoreWidgetDefaults({
    this.disableTransition = false,
    this.disableHoverEffect = false,
    this.disableFocusOutline = false,
    this.groupDirection = Axis.horizontal,
    this.groupExpands = false,
    this.iconSize = ButtonSize.normal,
    this.iconDensity = ButtonDensity.icon,
    this.iconShape = ButtonShape.rectangle,
    this.primaryStyle = ButtonVariance.primary,
    this.secondaryStyle = ButtonVariance.secondary,
    this.outlineStyle = ButtonVariance.outline,
    this.ghostStyle = ButtonVariance.ghost,
    this.linkStyle = ButtonVariance.link,
    this.textStyle = ButtonVariance.text,
    this.destructiveStyle = ButtonVariance.destructive,
    this.fixedStyle = ButtonVariance.fixed,
    this.cardStyle = ButtonVariance.card,
    this.toggleStyle = const ButtonStyle.ghost(),
    this.selectedStyle = const ButtonStyle.secondary(),
    this.controlledToggleEnabled = true,
  });

  /// From `Button.*` constructors: `disableTransition = false`
  final bool disableTransition;

  /// From `Button.*` constructors: `disableHoverEffect = false`
  final bool disableHoverEffect;

  /// From `Button.*` constructors: `disableFocusOutline = false`
  final bool disableFocusOutline;

  /// From `ButtonGroup` default: `direction = Axis.horizontal`
  final Axis groupDirection;

  /// From `ButtonGroup` default: `expands = false`
  final bool groupExpands;

  /// From `IconButton.*` constructors: `size = ButtonSize.normal`
  final ButtonSize iconSize;

  /// From `IconButton.*` constructors: `density = ButtonDensity.icon`
  final ButtonDensity iconDensity;

  /// From `IconButton.*` constructors: `shape = ButtonShape.rectangle`
  final ButtonShape iconShape;

  /// From `Button.primary`: `style = ButtonVariance.primary`
  final AbstractButtonStyle primaryStyle;

  /// From `Button.secondary`: `style = ButtonVariance.secondary`
  final AbstractButtonStyle secondaryStyle;

  /// From `Button.outline`: `style = ButtonVariance.outline`
  final AbstractButtonStyle outlineStyle;

  /// From `Button.ghost`: `style = ButtonVariance.ghost`
  final AbstractButtonStyle ghostStyle;

  /// From `Button.link`: `style = ButtonVariance.link`
  final AbstractButtonStyle linkStyle;

  /// From `Button.text`: `style = ButtonVariance.text`
  final AbstractButtonStyle textStyle;

  /// From `Button.destructive`: `style = ButtonVariance.destructive`
  final AbstractButtonStyle destructiveStyle;

  /// From `Button.fixed`: `style = ButtonVariance.fixed`
  final AbstractButtonStyle fixedStyle;

  /// From `Button.card`: `style = ButtonVariance.card`
  final AbstractButtonStyle cardStyle;

  /// From `Toggle` and `ControlledToggle`: `style = const ButtonStyle.ghost()`
  final ButtonStyle toggleStyle;

  /// From `SelectedButton`: `selectedStyle = const ButtonStyle.secondary()`
  final ButtonStyle selectedStyle;

  /// From `ControlledToggle`: `enabled = true`
  final bool controlledToggleEnabled;
}

const buttonCoreWidgetDefaults = ButtonCoreWidgetDefaults();
