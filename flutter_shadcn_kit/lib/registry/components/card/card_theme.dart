// User-owned overrides for the `card` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `cardDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the surface):
//
//   const CardTheme cardThemeOverrides = CardTheme(
//     background: ThemedColor.ref(ColorRef.popover),
//     borderColor: ThemedColor.ref(ColorRef.input),
//     padding: EdgeInsets.all(16),
//   );

import 'card_style.dart';

/// Surface overrides applied app-wide through `ComponentThemes`.
const CardTheme cardThemeOverrides = CardTheme();
