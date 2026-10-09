// User-owned overrides for the `color_input` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `colorInputDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete):
//
//   const ColorInputTheme colorInputThemeOverrides = ColorInputTheme(
//     showAlpha: false,
//     swatchSize: 32,
//   );

import 'color_input_style.dart';

/// App-wide colour-input overrides applied through `ComponentThemes`.
const ColorInputTheme colorInputThemeOverrides = ColorInputTheme();
