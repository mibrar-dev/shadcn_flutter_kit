// User-owned overrides for the `image` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `imageDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise):
//
//   const ImageTheme imageThemeOverrides = ImageTheme(
//     background: ThemedColor.ref(ColorRef.accent, alpha: 0.4),
//     borderRadius: BorderRadius.all(Radius.circular(8)),
//     duration: Duration(milliseconds: 250),
//   );

import 'image_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const ImageTheme imageThemeOverrides = ImageTheme();
