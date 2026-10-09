// User-owned overrides for the `navigation_bar` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `navigationBarDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the sidebar items):
//
//   const NavigationBarTheme navigationBarThemeOverrides = NavigationBarTheme(
//     itemStyle: NavigationItemStyle(
//       foreground: StateValue(rest: ThemedColor.ref(ColorRef.sidebarForeground)),
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     ),
//     activeItemStyle: NavigationItemStyle(
//       background: StateValue(rest: ThemedColor.ref(ColorRef.sidebarAccent)),
//       foreground: StateValue(
//         rest: ThemedColor.ref(ColorRef.sidebarAccentForeground),
//       ),
//     ),
//   );

import 'navigation_bar_style.dart';

/// Navigation bar overrides applied app-wide through `ComponentThemes`.
const NavigationBarTheme navigationBarThemeOverrides = NavigationBarTheme();
