// User-owned overrides for the `scrollbar` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `scrollbarDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the bar):
//
//   const ScrollbarTheme scrollbarThemeOverrides = ScrollbarTheme(
//     color: ThemedColor.ref(ColorRef.mutedForeground),
//     thickness: 10,
//   );

import 'package:flutter/widgets.dart';

import 'scrollbar_style.dart';

/// Scrollbar overrides applied app-wide through `ComponentThemes`.
const ScrollbarTheme scrollbarThemeOverrides = ScrollbarTheme();
