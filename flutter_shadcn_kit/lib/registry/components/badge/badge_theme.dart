// User-owned overrides for the `badge` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `badgeDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise a variant):
//
//   const BadgeTheme badgeThemeOverrides = BadgeTheme(
//     outline: BadgeStyle(
//       background: StateValue(rest: ThemedColor.ref(ColorRef.primary, alpha: 0.1)),
//       borderColor: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
//     ),
//   );

import 'package:flutter/widgets.dart';

import 'badge_style.dart';

/// Per-variant overrides applied app-wide through `ComponentThemes`.
const BadgeTheme badgeThemeOverrides = BadgeTheme();
