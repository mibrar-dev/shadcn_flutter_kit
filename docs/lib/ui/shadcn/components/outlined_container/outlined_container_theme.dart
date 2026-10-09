// User-owned overrides for the `outlined_container` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `outlinedContainerDefaults`
// and the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the surface):
//
//   const OutlinedContainerTheme outlinedContainerThemeOverrides =
//       OutlinedContainerTheme(
//         borderColor: ThemedColor.ref(ColorRef.input),
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//         surfaceOpacity: 0.8,
//       );

import 'package:flutter/widgets.dart';

import 'outlined_container_style.dart';

/// Outlined container overrides applied app-wide through `ComponentThemes`.
const OutlinedContainerTheme outlinedContainerThemeOverrides =
    OutlinedContainerTheme();
