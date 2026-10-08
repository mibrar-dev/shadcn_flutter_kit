// User-owned overrides for the `icon` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `iconContainerDefaults`
// and the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the container):
//
//   const IconContainerTheme iconContainerThemeOverrides = IconContainerTheme(
//     backgroundColor: ThemedColor.ref(ColorRef.secondary),
//     iconColor: ThemedColor.ref(ColorRef.secondaryForeground),
//   );

import 'package:flutter/widgets.dart';

import 'icon_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const IconContainerTheme iconContainerThemeOverrides = IconContainerTheme();
