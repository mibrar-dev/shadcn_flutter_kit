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

  static final PrimaryButtonTheme primaryButtonTheme =
      resolvedPrimaryButtonTheme;
  static const String primaryButtonThemeType = 'PrimaryButtonTheme';
  static const PrimaryButtonThemeDefaults primaryButtonThemeDefaults =
      PrimaryButtonThemeDefaults();
  static const PrimaryButtonThemeTokens primaryButtonThemeTokenConfig =
      primaryButtonThemeTokens;

  static final SecondaryButtonTheme secondaryButtonTheme =
      resolvedSecondaryButtonTheme;
  static const String secondaryButtonThemeType = 'SecondaryButtonTheme';
  static const SecondaryButtonThemeDefaults secondaryButtonThemeDefaults =
      SecondaryButtonThemeDefaults();
  static const SecondaryButtonThemeTokens secondaryButtonThemeTokenConfig =
      secondaryButtonThemeTokens;

  static final OutlineButtonTheme outlineButtonTheme =
      resolvedOutlineButtonTheme;
  static const String outlineButtonThemeType = 'OutlineButtonTheme';
  static const OutlineButtonThemeDefaults outlineButtonThemeDefaults =
      OutlineButtonThemeDefaults();
  static const OutlineButtonThemeTokens outlineButtonThemeTokenConfig =
      outlineButtonThemeTokens;

  static final GhostButtonTheme ghostButtonTheme = resolvedGhostButtonTheme;
  static const String ghostButtonThemeType = 'GhostButtonTheme';
  static const GhostButtonThemeDefaults ghostButtonThemeDefaults =
      GhostButtonThemeDefaults();
  static const GhostButtonThemeTokens ghostButtonThemeTokenConfig =
      ghostButtonThemeTokens;

  static final LinkButtonTheme linkButtonTheme = resolvedLinkButtonTheme;
  static const String linkButtonThemeType = 'LinkButtonTheme';
  static const LinkButtonThemeDefaults linkButtonThemeDefaults =
      LinkButtonThemeDefaults();
  static const LinkButtonThemeTokens linkButtonThemeTokenConfig =
      linkButtonThemeTokens;

  static final TextButtonTheme textButtonTheme = resolvedTextButtonTheme;
  static const String textButtonThemeType = 'TextButtonTheme';
  static const TextButtonThemeDefaults textButtonThemeDefaults =
      TextButtonThemeDefaults();
  static const TextButtonThemeTokens textButtonThemeTokenConfig =
      textButtonThemeTokens;

  static final DestructiveButtonTheme destructiveButtonTheme =
      resolvedDestructiveButtonTheme;
  static const String destructiveButtonThemeType = 'DestructiveButtonTheme';
  static const DestructiveButtonThemeDefaults destructiveButtonThemeDefaults =
      DestructiveButtonThemeDefaults();
  static const DestructiveButtonThemeTokens destructiveButtonThemeTokenConfig =
      destructiveButtonThemeTokens;

  static final FixedButtonTheme fixedButtonTheme = resolvedFixedButtonTheme;
  static const String fixedButtonThemeType = 'FixedButtonTheme';
  static const FixedButtonThemeDefaults fixedButtonThemeDefaults =
      FixedButtonThemeDefaults();
  static const FixedButtonThemeTokens fixedButtonThemeTokenConfig =
      fixedButtonThemeTokens;

  static final MenuButtonTheme menuButtonTheme = resolvedMenuButtonTheme;
  static const String menuButtonThemeType = 'MenuButtonTheme';
  static const MenuButtonThemeDefaults menuButtonThemeDefaults =
      MenuButtonThemeDefaults();
  static const MenuButtonThemeTokens menuButtonThemeTokenConfig =
      menuButtonThemeTokens;

  static final MenubarButtonTheme menubarButtonTheme =
      resolvedMenubarButtonTheme;
  static const String menubarButtonThemeType = 'MenubarButtonTheme';
  static const MenubarButtonThemeDefaults menubarButtonThemeDefaults =
      MenubarButtonThemeDefaults();
  static const MenubarButtonThemeTokens menubarButtonThemeTokenConfig =
      menubarButtonThemeTokens;

  static final MutedButtonTheme mutedButtonTheme = resolvedMutedButtonTheme;
  static const String mutedButtonThemeType = 'MutedButtonTheme';
  static const MutedButtonThemeDefaults mutedButtonThemeDefaults =
      MutedButtonThemeDefaults();
  static const MutedButtonThemeTokens mutedButtonThemeTokenConfig =
      mutedButtonThemeTokens;

  static final CardButtonTheme cardButtonTheme = resolvedCardButtonTheme;
  static const String cardButtonThemeType = 'CardButtonTheme';
  static const CardButtonThemeDefaults cardButtonThemeDefaults =
      CardButtonThemeDefaults();
  static const CardButtonThemeTokens cardButtonThemeTokenConfig =
      cardButtonThemeTokens;

  static const ButtonCoreWidgetDefaults coreWidgetDefaults =
      buttonCoreWidgetDefaults;
  static const ButtonCoreWidgetTokens coreWidgetTokenConfig =
      buttonCoreWidgetTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    PrimaryButtonTheme: primaryButtonTheme,
    SecondaryButtonTheme: secondaryButtonTheme,
    OutlineButtonTheme: outlineButtonTheme,
    GhostButtonTheme: ghostButtonTheme,
    LinkButtonTheme: linkButtonTheme,
    TextButtonTheme: textButtonTheme,
    DestructiveButtonTheme: destructiveButtonTheme,
    FixedButtonTheme: fixedButtonTheme,
    MenuButtonTheme: menuButtonTheme,
    MenubarButtonTheme: menubarButtonTheme,
    MutedButtonTheme: mutedButtonTheme,
    CardButtonTheme: cardButtonTheme,
  };

  static T? resolve<T extends ButtonTheme>() {
    return _resolveByType[T] as T?;
  }
}
