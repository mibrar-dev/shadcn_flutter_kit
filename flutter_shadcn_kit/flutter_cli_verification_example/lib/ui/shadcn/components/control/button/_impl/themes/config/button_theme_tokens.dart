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
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror ButtonThemeDefaults
// ═══════════════════════════════════════════════════════════

class _ButtonVariantThemeTokens {
  const _ButtonVariantThemeTokens({
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
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final ButtonStateProperty<Decoration> decoration;
  final ButtonStateProperty<MouseCursor> mouseCursor;
  final ButtonStateProperty<EdgeInsetsGeometry> padding;
  final ButtonStateProperty<TextStyle> textStyle;
  final ButtonStateProperty<IconThemeData> iconTheme;
  final ButtonStateProperty<EdgeInsetsGeometry> margin;
  final ButtonSize size;
  final ButtonDensity density;
  final ButtonShape shape;
  final bool disableTransition;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

class PrimaryButtonThemeTokens extends _ButtonVariantThemeTokens {
  const PrimaryButtonThemeTokens()
    : super(
        decoration: buttonPrimaryDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonPrimaryTextStyle,
        iconTheme: buttonPrimaryIconTheme,
        margin: buttonZeroMargin,
      );
}

class SecondaryButtonThemeTokens extends _ButtonVariantThemeTokens {
  const SecondaryButtonThemeTokens()
    : super(
        decoration: buttonSecondaryDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonSecondaryTextStyle,
        iconTheme: buttonSecondaryIconTheme,
        margin: buttonZeroMargin,
      );
}

class OutlineButtonThemeTokens extends _ButtonVariantThemeTokens {
  const OutlineButtonThemeTokens()
    : super(
        decoration: buttonOutlineDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonOutlineTextStyle,
        iconTheme: buttonOutlineIconTheme,
        margin: buttonZeroMargin,
      );
}

class GhostButtonThemeTokens extends _ButtonVariantThemeTokens {
  const GhostButtonThemeTokens()
    : super(
        decoration: buttonGhostDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonGhostTextStyle,
        iconTheme: buttonGhostIconTheme,
        margin: buttonZeroMargin,
      );
}

class LinkButtonThemeTokens extends _ButtonVariantThemeTokens {
  const LinkButtonThemeTokens()
    : super(
        decoration: buttonLinkDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonLinkTextStyle,
        iconTheme: buttonLinkIconTheme,
        margin: buttonZeroMargin,
      );
}

class TextButtonThemeTokens extends _ButtonVariantThemeTokens {
  const TextButtonThemeTokens()
    : super(
        decoration: buttonTextDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonTextTextStyle,
        iconTheme: buttonTextIconTheme,
        margin: buttonZeroMargin,
      );
}

class DestructiveButtonThemeTokens extends _ButtonVariantThemeTokens {
  const DestructiveButtonThemeTokens()
    : super(
        decoration: buttonDestructiveDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonDestructiveTextStyle,
        iconTheme: buttonDestructiveIconTheme,
        margin: buttonZeroMargin,
      );
}

class FixedButtonThemeTokens extends _ButtonVariantThemeTokens {
  const FixedButtonThemeTokens()
    : super(
        decoration: buttonTextDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonStaticTextStyle,
        iconTheme: buttonStaticIconTheme,
        margin: buttonZeroMargin,
      );
}

class MenuButtonThemeTokens extends _ButtonVariantThemeTokens {
  const MenuButtonThemeTokens()
    : super(
        decoration: buttonMenuDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonMenuPadding,
        textStyle: buttonMenuTextStyle,
        iconTheme: buttonMenuIconTheme,
        margin: buttonZeroMargin,
      );
}

class MenubarButtonThemeTokens extends _ButtonVariantThemeTokens {
  const MenubarButtonThemeTokens()
    : super(
        decoration: buttonMenuDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonMenubarPadding,
        textStyle: buttonMenuTextStyle,
        iconTheme: buttonMenuIconTheme,
        margin: buttonZeroMargin,
      );
}

class MutedButtonThemeTokens extends _ButtonVariantThemeTokens {
  const MutedButtonThemeTokens()
    : super(
        decoration: buttonTextDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonPadding,
        textStyle: buttonMutedTextStyle,
        iconTheme: buttonMutedIconTheme,
        margin: buttonZeroMargin,
      );
}

class CardButtonThemeTokens extends _ButtonVariantThemeTokens {
  const CardButtonThemeTokens()
    : super(
        decoration: buttonCardDecoration,
        mouseCursor: buttonMouseCursor,
        padding: buttonCardPadding,
        textStyle: buttonCardTextStyle,
        iconTheme: buttonCardIconTheme,
        margin: buttonZeroMargin,
      );
}

class ButtonCoreWidgetTokens {
  const ButtonCoreWidgetTokens({
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
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final bool disableTransition;
  final bool disableHoverEffect;
  final bool disableFocusOutline;
  final Axis groupDirection;
  final bool groupExpands;
  final ButtonSize iconSize;
  final ButtonDensity iconDensity;
  final ButtonShape iconShape;
  final AbstractButtonStyle primaryStyle;
  final AbstractButtonStyle secondaryStyle;
  final AbstractButtonStyle outlineStyle;
  final AbstractButtonStyle ghostStyle;
  final AbstractButtonStyle linkStyle;
  final AbstractButtonStyle textStyle;
  final AbstractButtonStyle destructiveStyle;
  final AbstractButtonStyle fixedStyle;
  final AbstractButtonStyle cardStyle;
  final ButtonStyle toggleStyle;
  final ButtonStyle selectedStyle;
  final bool controlledToggleEnabled;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const buttonCoreWidgetTokens = ButtonCoreWidgetTokens();

const primaryButtonThemeTokens = PrimaryButtonThemeTokens();
const secondaryButtonThemeTokens = SecondaryButtonThemeTokens();
const outlineButtonThemeTokens = OutlineButtonThemeTokens();
const ghostButtonThemeTokens = GhostButtonThemeTokens();
const linkButtonThemeTokens = LinkButtonThemeTokens();
const textButtonThemeTokens = TextButtonThemeTokens();
const destructiveButtonThemeTokens = DestructiveButtonThemeTokens();
const fixedButtonThemeTokens = FixedButtonThemeTokens();
const menuButtonThemeTokens = MenuButtonThemeTokens();
const menubarButtonThemeTokens = MenubarButtonThemeTokens();
const mutedButtonThemeTokens = MutedButtonThemeTokens();
const cardButtonThemeTokens = CardButtonThemeTokens();
