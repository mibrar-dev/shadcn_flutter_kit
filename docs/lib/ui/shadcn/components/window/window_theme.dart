// User-owned overrides for the `window` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `windowDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete):
//
//   const WindowTheme windowThemeOverrides = WindowTheme(
//     titleBarHeight: 40,
//     snapOverlayColor: ThemedColor.ref(ColorRef.primary, alpha: 0.2),
//   );

import 'window_style.dart';

/// App-wide overrides applied through `ComponentThemes`.
const WindowTheme windowThemeOverrides = WindowTheme();
