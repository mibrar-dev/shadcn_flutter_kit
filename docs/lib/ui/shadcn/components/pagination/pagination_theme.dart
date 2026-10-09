// User-owned overrides for the `pagination` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `paginationDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the control):
//
//   const PaginationTheme paginationThemeOverrides = PaginationTheme(
//     gap: 8,
//     showLabel: false,
//   );

import 'pagination_style.dart';

/// Pagination overrides applied app-wide through `ComponentThemes`.
const PaginationTheme paginationThemeOverrides = PaginationTheme();
