// User-owned overrides for the `media_query` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to
// `mediaQueryVisibilityDefaults`.
//
// Sparse example (uncomment and complete to set the app's breakpoints once):
//
//   const MediaQueryVisibilityTheme mediaQueryVisibilityThemeOverrides =
//       MediaQueryVisibilityTheme(minWidth: 640, maxWidth: 1280);

import 'media_query_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const MediaQueryVisibilityTheme mediaQueryVisibilityThemeOverrides =
    MediaQueryVisibilityTheme();
