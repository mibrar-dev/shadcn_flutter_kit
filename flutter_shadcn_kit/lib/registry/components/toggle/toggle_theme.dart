// User-owned overrides for the `toggle` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `toggleDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise a state):
//
//   const ToggleTheme toggleThemeOverrides = ToggleTheme(
//     off: ToggleStyle(
//       background: StateValue(
//         rest: ThemedColor.ref(ColorRef.accent),
//         hovered: ThemedColor.ref(ColorRef.accent, alpha: 0.8),
//         pressed: ThemedColor.ref(ColorRef.accent, alpha: 0.8),
//       ),
//     ),
//   );

import 'package:flutter/widgets.dart';

import 'toggle_style.dart';

/// On/off overrides applied app-wide through `ComponentThemes`.
const ToggleTheme toggleThemeOverrides = ToggleTheme();
