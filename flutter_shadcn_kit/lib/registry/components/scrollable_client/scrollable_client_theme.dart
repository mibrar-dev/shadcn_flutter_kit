// User-owned overrides for the `scrollable_client` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `scrollableClientDefaults`.
//
// Sparse example (uncomment and complete to customise the surface):
//
//   const ScrollableClientTheme scrollableClientThemeOverrides =
//       ScrollableClientTheme(
//         diagonalDragBehavior: DiagonalDragBehavior.free,
//         overscroll: true,
//       );

import 'package:flutter/widgets.dart';

import 'scrollable_client_style.dart';

/// Scrollable client overrides applied app-wide through `ComponentThemes`.
const ScrollableClientTheme scrollableClientThemeOverrides =
    ScrollableClientTheme();
