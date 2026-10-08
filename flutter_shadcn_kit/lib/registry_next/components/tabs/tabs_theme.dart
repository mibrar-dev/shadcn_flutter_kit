// User-owned overrides for the `tabs` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `tabsDefaults` and
// `tabPaneDefaults`.
//
// Sparse example (uncomment and complete to customise the strip):
//
//   const tabsThemeOverrides = TabsTheme(
//     selectedColor: StateValue(
//       rest: ThemedColor.ref(ColorRef.primary, alpha: 0.12),
//     ),
//   );

import 'tabs_style.dart';

/// App-wide overrides for [Tabs].
const TabsTheme tabsThemeOverrides = TabsTheme();

/// App-wide default builders for [TabContainer].
const TabContainerTheme tabContainerThemeOverrides = TabContainerTheme();

/// App-wide overrides for [TabPane].
const TabPaneTheme tabPaneThemeOverrides = TabPaneTheme();
