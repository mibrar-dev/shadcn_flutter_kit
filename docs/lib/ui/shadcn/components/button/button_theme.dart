// User-owned overrides for the `button` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `buttonDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise a variant):
//
//   const ButtonTheme buttonThemeOverrides = ButtonTheme(
//     outline: ButtonVariantStyle(
//       background: StateValue(
//         rest: ThemedColor.ref(ColorRef.primary, alpha: 0.1),
//         hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.2),
//         pressed: ThemedColor.ref(ColorRef.primary, alpha: 0.2),
//       ),
//     ),
//   );

import 'package:flutter/widgets.dart';

import 'button_style.dart';

/// Per-variant overrides applied app-wide through `ComponentThemes`.
const ButtonTheme buttonThemeOverrides = ButtonTheme();
