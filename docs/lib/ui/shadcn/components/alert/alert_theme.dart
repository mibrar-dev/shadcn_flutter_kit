// User-owned overrides for the `alert` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `alertDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the destructive row):
//
//   const AlertTheme alertThemeOverrides = AlertTheme(
//     destructive: AlertStyle(
//       background: ThemedColor.ref(ColorRef.destructive, alpha: 0.1),
//     ),
//   );

import 'alert_style.dart';

/// Per-variant overrides applied app-wide through `ComponentThemes`.
const AlertTheme alertThemeOverrides = AlertTheme();
