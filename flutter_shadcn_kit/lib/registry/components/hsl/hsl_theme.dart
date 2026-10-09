// User-owned overrides for the `hsl` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `hslSliderDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const HSLSliderTheme hslSliderThemeOverrides = HSLSliderTheme(
//     slider: HSLSliderStyle(cursorWidth: 3),
//   );

import 'hsl_style.dart';

/// App-wide HSL slider overrides applied through `ComponentThemes`.
const HSLSliderTheme hslSliderThemeOverrides = HSLSliderTheme();
