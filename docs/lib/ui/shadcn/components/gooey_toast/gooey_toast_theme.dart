// User-owned overrides for the `gooey_toast` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `gooeyToastDefaults` and the
// global tokens, so an empty override keeps the exact default look.
//
// Sparse example (uncomment and complete to customise the surface):
//
//   const GooeyToastTheme gooeyToastThemeOverrides = GooeyToastTheme(
//     fill: ThemedColor.ref(ColorRef.foreground),
//     roundness: 20,
//     successTone: ThemedColor.ref(ColorRef.primary),
//   );

import 'package:flutter/widgets.dart';

import 'gooey_toast_style.dart';

/// Gooey toast overrides applied app-wide through `ComponentThemes`.
const GooeyToastTheme gooeyToastThemeOverrides = GooeyToastTheme();
