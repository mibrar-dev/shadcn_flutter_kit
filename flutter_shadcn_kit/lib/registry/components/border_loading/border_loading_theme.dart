// User-owned overrides for the `border_loading` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `borderLoadingDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the loader):
//
//   const BorderLoadingTheme borderLoadingThemeOverrides = BorderLoadingTheme(
//     strokeWidth: 3,
//     mode: BorderLoadingMode.tracer,
//     duration: Duration(seconds: 2),
//   );

import 'border_loading_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const BorderLoadingTheme borderLoadingThemeOverrides = BorderLoadingTheme();
