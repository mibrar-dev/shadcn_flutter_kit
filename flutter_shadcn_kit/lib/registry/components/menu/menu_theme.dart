// User-owned overrides for the `menu` component themes.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `menuDefaults`,
// `menuPopupDefaults` and `menubarDefaults`, so empty overrides keep the
// exact token look.
//
//   const MenuTheme menuThemeOverrides = MenuTheme(
//     foreground: StateValue(rest: ThemedColor.ref(ColorRef.accentForeground)),
//   );

import 'menu_style.dart';

/// Per-component overrides applied app-wide through `ComponentThemes`.
const MenuTheme menuThemeOverrides = MenuTheme();

/// Per-component overrides applied app-wide through `ComponentThemes`.
const MenuPopupTheme menuPopupThemeOverrides = MenuPopupTheme();

/// Per-component overrides applied app-wide through `ComponentThemes`.
const MenubarTheme menubarThemeOverrides = MenubarTheme();
