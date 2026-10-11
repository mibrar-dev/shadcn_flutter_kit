// User-owned overrides for the `star_rating` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `starRatingDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise):
//
//   const StarRatingTheme starRatingThemeOverrides = StarRatingTheme(
//     style: StarRatingStyle(
//       activeColor: ThemedColor.value(Color(0xFFF59E0B)),
//       size: 28,
//     ),
//   );

import 'star_rating_style.dart';

/// Star appearance overrides applied app-wide through `ComponentThemes`.
const StarRatingTheme starRatingThemeOverrides = StarRatingTheme();
