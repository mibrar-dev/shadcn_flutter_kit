// User-owned overrides for the `resizable` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `resizableDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the handle):
//
//   const ResizableTheme resizableThemeOverrides = ResizableTheme(
//     handleThickness: 2,
//     hitThickness: 12,
//     handleColor: StateValue(
//       rest: ThemedColor.ref(ColorRef.border),
//       hovered: ThemedColor.ref(ColorRef.primary),
//       pressed: ThemedColor.ref(ColorRef.primary),
//     ),
//   );

import 'resizable_style.dart';

/// Handle overrides applied app-wide through `ComponentThemes`.
const ResizableTheme resizableThemeOverrides = ResizableTheme();
