// ═══════════════════════════════════════════════════════════
// COMPONENT THEME CONFIG
// Registration wiring (do not edit manually)
// ═══════════════════════════════════════════════════════════

import '../../../tabs.dart';
import 'tabs_theme_defaults.dart';
import 'tabs_theme_tokens.dart';

class TabsThemeConfig {
  const TabsThemeConfig._();

  static const TabsTheme? global = null;
  static const String globalType = 'TabsTheme';
  static const TabsThemeDefaults defaults = TabsThemeDefaults();
  static const TabsThemeTokens tokens = tabsThemeTokens;

  static const TabContainerTheme? tabContainerTheme = null;
  static const String tabContainerThemeType = 'TabContainerTheme';
  static const TabContainerThemeDefaults tabContainerThemeDefaults =
      TabContainerThemeDefaults();
  static const TabContainerThemeTokens tabContainerThemeTokenConfig =
      tabContainerThemeTokens;

  static const TabListTheme? tabListTheme = null;
  static const String tabListThemeType = 'TabListTheme';
  static const TabListThemeDefaults tabListThemeDefaults =
      TabListThemeDefaults();
  static const TabListThemeTokens tabListThemeTokenConfig = tabListThemeTokens;

  static const TabPaneTheme? tabPaneTheme = null;
  static const String tabPaneThemeType = 'TabPaneTheme';
  static const TabPaneThemeDefaults tabPaneThemeDefaults =
      TabPaneThemeDefaults();
  static const TabPaneThemeTokens tabPaneThemeTokenConfig = tabPaneThemeTokens;

  static final Map<Type, Object?> _resolveByType = <Type, Object?>{
    TabsTheme: global,
    TabContainerTheme: tabContainerTheme,
    TabListTheme: tabListTheme,
    TabPaneTheme: tabPaneTheme,
  };

  static T? resolve<T>() {
    return _resolveByType[T] as T?;
  }
}
