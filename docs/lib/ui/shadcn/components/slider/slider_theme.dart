// User-owned overrides for the `slider` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `sliderDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise a variant):
//
//   const SliderTheme sliderThemeOverrides = SliderTheme(
//     soft: SliderStyle(
//       fill: StateValue(rest: ThemedColor.ref(ColorRef.destructive)),
//       thumbBorder: StateValue(rest: ThemedColor.ref(ColorRef.destructive)),
//     ),
//   );

import 'slider_style.dart';

/// Per-variant overrides applied app-wide through `ComponentThemes`.
const SliderTheme sliderThemeOverrides = SliderTheme();
