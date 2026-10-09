// User-owned overrides for the `triple_dots` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `tripleDotsDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the dots):
//
//   const TripleDotsTheme tripleDotsThemeOverrides = TripleDotsTheme(
//     color: ThemedColor.ref(ColorRef.foreground),
//     size: 3,
//   );

import 'triple_dots_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const TripleDotsTheme tripleDotsThemeOverrides = TripleDotsTheme();
