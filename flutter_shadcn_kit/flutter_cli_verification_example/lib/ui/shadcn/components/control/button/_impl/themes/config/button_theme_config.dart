// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

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

import 'button_theme_defaults.dart';
import 'button_theme_tokens.dart';

class ButtonThemeConfig {
  const ButtonThemeConfig._();

  static const PrimaryButtonTheme? primaryButtonTheme = null;
  static const String primaryButtonThemeType = 'PrimaryButtonTheme';
  static const PrimaryButtonThemeDefaults primaryButtonThemeDefaults =
      PrimaryButtonThemeDefaults();
  static const PrimaryButtonThemeTokens primaryButtonThemeTokenConfig =
      primaryButtonThemeTokens;

  static const SecondaryButtonTheme? secondaryButtonTheme = null;
  static const String secondaryButtonThemeType = 'SecondaryButtonTheme';
  static const SecondaryButtonThemeDefaults secondaryButtonThemeDefaults =
      SecondaryButtonThemeDefaults();
  static const SecondaryButtonThemeTokens secondaryButtonThemeTokenConfig =
      secondaryButtonThemeTokens;

  static const OutlineButtonTheme? outlineButtonTheme = null;
  static const String outlineButtonThemeType = 'OutlineButtonTheme';
  static const OutlineButtonThemeDefaults outlineButtonThemeDefaults =
      OutlineButtonThemeDefaults();
  static const OutlineButtonThemeTokens outlineButtonThemeTokenConfig =
      outlineButtonThemeTokens;

  static const GhostButtonTheme? ghostButtonTheme = null;
  static const String ghostButtonThemeType = 'GhostButtonTheme';
  static const GhostButtonThemeDefaults ghostButtonThemeDefaults =
      GhostButtonThemeDefaults();
  static const GhostButtonThemeTokens ghostButtonThemeTokenConfig =
      ghostButtonThemeTokens;

  static const LinkButtonTheme? linkButtonTheme = null;
  static const String linkButtonThemeType = 'LinkButtonTheme';
  static const LinkButtonThemeDefaults linkButtonThemeDefaults =
      LinkButtonThemeDefaults();
  static const LinkButtonThemeTokens linkButtonThemeTokenConfig =
      linkButtonThemeTokens;

  static const TextButtonTheme? textButtonTheme = null;
  static const String textButtonThemeType = 'TextButtonTheme';
  static const TextButtonThemeDefaults textButtonThemeDefaults =
      TextButtonThemeDefaults();
  static const TextButtonThemeTokens textButtonThemeTokenConfig =
      textButtonThemeTokens;

  static const DestructiveButtonTheme? destructiveButtonTheme = null;
  static const String destructiveButtonThemeType = 'DestructiveButtonTheme';
  static const DestructiveButtonThemeDefaults destructiveButtonThemeDefaults =
      DestructiveButtonThemeDefaults();
  static const DestructiveButtonThemeTokens destructiveButtonThemeTokenConfig =
      destructiveButtonThemeTokens;

  static const FixedButtonTheme? fixedButtonTheme = null;
  static const String fixedButtonThemeType = 'FixedButtonTheme';
  static const FixedButtonThemeDefaults fixedButtonThemeDefaults =
      FixedButtonThemeDefaults();
  static const FixedButtonThemeTokens fixedButtonThemeTokenConfig =
      fixedButtonThemeTokens;

  static const MenuButtonTheme? menuButtonTheme = null;
  static const String menuButtonThemeType = 'MenuButtonTheme';
  static const MenuButtonThemeDefaults menuButtonThemeDefaults =
      MenuButtonThemeDefaults();
  static const MenuButtonThemeTokens menuButtonThemeTokenConfig =
      menuButtonThemeTokens;

  static const MenubarButtonTheme? menubarButtonTheme = null;
  static const String menubarButtonThemeType = 'MenubarButtonTheme';
  static const MenubarButtonThemeDefaults menubarButtonThemeDefaults =
      MenubarButtonThemeDefaults();
  static const MenubarButtonThemeTokens menubarButtonThemeTokenConfig =
      menubarButtonThemeTokens;

  static const MutedButtonTheme? mutedButtonTheme = null;
  static const String mutedButtonThemeType = 'MutedButtonTheme';
  static const MutedButtonThemeDefaults mutedButtonThemeDefaults =
      MutedButtonThemeDefaults();
  static const MutedButtonThemeTokens mutedButtonThemeTokenConfig =
      mutedButtonThemeTokens;

  static const CardButtonTheme? cardButtonTheme = null;
  static const String cardButtonThemeType = 'CardButtonTheme';
  static const CardButtonThemeDefaults cardButtonThemeDefaults =
      CardButtonThemeDefaults();
  static const CardButtonThemeTokens cardButtonThemeTokenConfig =
      cardButtonThemeTokens;

  static const ButtonCoreWidgetDefaults coreWidgetDefaults =
      buttonCoreWidgetDefaults;
  static const ButtonCoreWidgetTokens coreWidgetTokenConfig =
      buttonCoreWidgetTokens;

  static T? resolve<T extends ButtonTheme>() {
    if (T == PrimaryButtonTheme) {
      return primaryButtonTheme as T?;
    }
    if (T == SecondaryButtonTheme) {
      return secondaryButtonTheme as T?;
    }
    if (T == OutlineButtonTheme) {
      return outlineButtonTheme as T?;
    }
    if (T == GhostButtonTheme) {
      return ghostButtonTheme as T?;
    }
    if (T == LinkButtonTheme) {
      return linkButtonTheme as T?;
    }
    if (T == TextButtonTheme) {
      return textButtonTheme as T?;
    }
    if (T == DestructiveButtonTheme) {
      return destructiveButtonTheme as T?;
    }
    if (T == FixedButtonTheme) {
      return fixedButtonTheme as T?;
    }
    if (T == MenuButtonTheme) {
      return menuButtonTheme as T?;
    }
    if (T == MenubarButtonTheme) {
      return menubarButtonTheme as T?;
    }
    if (T == MutedButtonTheme) {
      return mutedButtonTheme as T?;
    }
    if (T == CardButtonTheme) {
      return cardButtonTheme as T?;
    }
    return null;
  }
}
