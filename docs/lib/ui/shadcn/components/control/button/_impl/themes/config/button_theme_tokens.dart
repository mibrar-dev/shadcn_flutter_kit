// ignore_for_file: dead_code,deprecated_member_use,duplicate_import,sort_child_properties_last,unnecessary_import,unnecessary_null_comparison,unused_element_parameter,unused_import,use_null_aware_elements

import 'package:flutter/widgets.dart';

import '../../styles/abstract_button_style.dart';
import '../../styles/button_density.dart';
import '../../styles/button_shape.dart';
import '../../styles/button_size.dart';
import '../../styles/button_style_class.dart';
import '../../styles/button_state_property.dart';
import '../../styles/button_state_property_delegate.dart';
import '../../utils/button_helpers.dart';
import '../variants/button_theme_base.dart';
import '../variants/card_button_theme.dart';
import '../variants/destructive_button_theme.dart';
import '../variants/fixed_button_theme.dart';
import '../variants/ghost_button_theme.dart';
import '../variants/link_button_theme.dart';
import '../variants/menu_button_theme.dart';
import '../variants/menubar_button_theme.dart';
import '../variants/muted_button_theme.dart';
import '../variants/outline_button_theme.dart';
import '../variants/primary_button_theme.dart';
import '../variants/secondary_button_theme.dart';
import '../variants/text_button_theme.dart';
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

typedef _ButtonThemeBuilder<T extends ButtonTheme> =
    T Function({
      ButtonStatePropertyDelegate<Decoration>? decoration,
      ButtonStatePropertyDelegate<MouseCursor>? mouseCursor,
      ButtonStatePropertyDelegate<EdgeInsetsGeometry>? padding,
      ButtonStatePropertyDelegate<TextStyle>? textStyle,
      ButtonStatePropertyDelegate<IconThemeData>? iconTheme,
      ButtonStatePropertyDelegate<EdgeInsetsGeometry>? margin,
    });

ButtonStatePropertyDelegate<T> _asThemeDelegate<T>(
  ButtonStateProperty<T> property,
) {
  return (context, states, value) => property(context, states);
}

T _buildButtonTheme<T extends ButtonTheme>(
  _ButtonVariantThemeTokens tokens,
  _ButtonThemeBuilder<T> builder,
) {
  return builder(
    decoration: _asThemeDelegate(tokens.decoration),
    mouseCursor: _asThemeDelegate(tokens.mouseCursor),
    padding: _asThemeDelegate(tokens.padding),
    textStyle: _asThemeDelegate(tokens.textStyle),
    iconTheme: _asThemeDelegate(tokens.iconTheme),
    margin: _asThemeDelegate(tokens.margin),
  );
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

final PrimaryButtonTheme resolvedPrimaryButtonTheme = _buildButtonTheme(
  primaryButtonThemeTokens,
  PrimaryButtonTheme.new,
);
final SecondaryButtonTheme resolvedSecondaryButtonTheme = _buildButtonTheme(
  secondaryButtonThemeTokens,
  SecondaryButtonTheme.new,
);
final OutlineButtonTheme resolvedOutlineButtonTheme = _buildButtonTheme(
  outlineButtonThemeTokens,
  OutlineButtonTheme.new,
);
final GhostButtonTheme resolvedGhostButtonTheme = _buildButtonTheme(
  ghostButtonThemeTokens,
  GhostButtonTheme.new,
);
final LinkButtonTheme resolvedLinkButtonTheme = _buildButtonTheme(
  linkButtonThemeTokens,
  LinkButtonTheme.new,
);
final TextButtonTheme resolvedTextButtonTheme = _buildButtonTheme(
  textButtonThemeTokens,
  TextButtonTheme.new,
);
final DestructiveButtonTheme resolvedDestructiveButtonTheme = _buildButtonTheme(
  destructiveButtonThemeTokens,
  DestructiveButtonTheme.new,
);
final FixedButtonTheme resolvedFixedButtonTheme = _buildButtonTheme(
  fixedButtonThemeTokens,
  FixedButtonTheme.new,
);
final MenuButtonTheme resolvedMenuButtonTheme = _buildButtonTheme(
  menuButtonThemeTokens,
  MenuButtonTheme.new,
);
final MenubarButtonTheme resolvedMenubarButtonTheme = _buildButtonTheme(
  menubarButtonThemeTokens,
  MenubarButtonTheme.new,
);
final MutedButtonTheme resolvedMutedButtonTheme = _buildButtonTheme(
  mutedButtonThemeTokens,
  MutedButtonTheme.new,
);
final CardButtonTheme resolvedCardButtonTheme = _buildButtonTheme(
  cardButtonThemeTokens,
  CardButtonTheme.new,
);
