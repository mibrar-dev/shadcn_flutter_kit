// User-owned overrides for the `switch` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `switchDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the on state):
//
//   const SwitchTheme switchThemeOverrides = SwitchTheme(
//     on: SwitchStyle(
//       trackColor: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
//       thumbColor: StateValue(rest: ThemedColor.ref(ColorRef.background)),
//     ),
//   );

import 'switch_style.dart';

/// On/off overrides applied app-wide through `ComponentThemes`.
const SwitchTheme switchThemeOverrides = SwitchTheme();
