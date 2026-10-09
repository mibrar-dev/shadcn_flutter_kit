// User-owned overrides for the `input` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `inputDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the surface):
//
//   const InputTheme inputThemeOverrides = InputTheme(
//     background: StateValue(
//       rest: ThemedColor.ref(ColorRef.secondary, alpha: 0.4),
//       hovered: ThemedColor.ref(ColorRef.secondary, alpha: 0.6),
//     ),
//     borderRadius: BorderRadius.all(Radius.circular(10)),
//   );

import 'input_style.dart';

/// Input overrides applied app-wide through `ComponentThemes`.
const InputTheme inputThemeOverrides = InputTheme();
