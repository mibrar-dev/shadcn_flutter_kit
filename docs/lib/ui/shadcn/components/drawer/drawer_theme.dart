// User-owned overrides for the `drawer` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `drawerDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the panel):
//
//   const DrawerTheme drawerThemeOverrides = DrawerTheme(
//     maxSize: 360,
//     borderRadius: BorderRadius.all(Radius.circular(12)),
//     barrierColor: ThemedColor.ref(ColorRef.foreground, alpha: 0.4),
//   );

import 'drawer_style.dart';

/// Panel overrides applied app-wide through `ComponentThemes`.
const DrawerTheme drawerThemeOverrides = DrawerTheme();
