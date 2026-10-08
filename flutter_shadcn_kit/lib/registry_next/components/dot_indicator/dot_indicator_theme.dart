// User-owned overrides for the `dot_indicator` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `dotIndicatorDefaults`.
//
// Sparse example (uncomment and complete to customise the rows):
//
//   const DotIndicatorTheme dotIndicatorThemeOverrides = DotIndicatorTheme(
//     active: DotStyle(
//       background: StateValue(
//         rest: ThemedColor.ref(ColorRef.destructive),
//         hovered: ThemedColor.ref(ColorRef.destructive, alpha: 0.9),
//       ),
//       size: 16,
//     ),
//     spacing: 12,
//     duration: Duration(milliseconds: 250),
//   );

import 'package:flutter/widgets.dart';

import 'dot_indicator_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const DotIndicatorTheme dotIndicatorThemeOverrides = DotIndicatorTheme();
