// User-owned overrides for the `progress` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `progressDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the bar):
//
//   const ProgressTheme progressThemeOverrides = ProgressTheme(
//     color: ThemedColor.ref(ColorRef.chart2),
//     height: 6,
//     showSparks: true,
//   );

import 'progress_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const ProgressTheme progressThemeOverrides = ProgressTheme();
