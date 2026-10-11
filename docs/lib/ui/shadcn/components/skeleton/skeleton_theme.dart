// User-owned overrides for the `skeleton` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `skeletonDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const SkeletonTheme skeletonThemeOverrides = SkeletonTheme(
//     fromColor: ThemedColor.ref(ColorRef.accent),
//     toColor: ThemedColor.ref(ColorRef.secondary),
//     duration: Duration(milliseconds: 1200),
//   );

import 'skeleton_style.dart';

/// Per-component overrides applied app-wide through `ComponentThemes`.
const SkeletonTheme skeletonThemeOverrides = SkeletonTheme();
