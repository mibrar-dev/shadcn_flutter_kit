// User-owned overrides for the `switcher` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `switcherDefaults`.
//
// Sparse example (uncomment and complete to change the snap-back):
//
//   const SwitcherTheme switcherThemeOverrides = SwitcherTheme(
//     duration: Duration(milliseconds: 250),
//     curve: Curves.easeOutCubic,
//   );

import 'switcher_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const SwitcherTheme switcherThemeOverrides = SwitcherTheme();
