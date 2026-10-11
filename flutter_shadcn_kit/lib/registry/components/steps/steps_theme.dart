// User-owned overrides for the `steps` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `stepsDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the indicators):
//
//   const StepsTheme stepsThemeOverrides = StepsTheme(
//     indicatorSize: 32,
//     indicatorColor: ThemedColor.ref(ColorRef.primary),
//     indicatorForeground: ThemedColor.ref(ColorRef.primaryForeground),
//   );

import 'steps_style.dart';

/// Step overrides applied app-wide through `ComponentThemes`.
const StepsTheme stepsThemeOverrides = StepsTheme();
