// User-owned overrides for the `dropzone` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `dropzoneDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the error surface):
//
//   const DropzoneTheme dropzoneThemeOverrides = DropzoneTheme(
//     borderColor: StateValue(
//       rest: ThemedColor.ref(ColorRef.border),
//       selected: ThemedColor.value(Color(0xFFD97706)),
//     ),
//     borderRadius: BorderRadius.all(Radius.circular(4)),
//   );

import 'dropzone_style.dart';

/// Dropzone overrides applied app-wide through `ComponentThemes`.
const DropzoneTheme dropzoneThemeOverrides = DropzoneTheme();
