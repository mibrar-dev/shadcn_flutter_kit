// User-owned overrides for the `hsv` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `hsvSliderDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const HSVSliderTheme hsvSliderThemeOverrides = HSVSliderTheme(
//     slider: HSVSliderStyle(cursorWidth: 3),
//   );

import 'hsv_style.dart';

/// App-wide HSV slider overrides applied through `ComponentThemes`.
const HSVSliderTheme hsvSliderThemeOverrides = HSVSliderTheme();
