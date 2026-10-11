// User-owned overrides for the `feature_carousel` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `featureCarouselDefaults`
// and the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the carousel):
//
//   const FeatureCarouselTheme featureCarouselThemeOverrides =
//       FeatureCarouselTheme(
//         accentColor: ThemedColor.ref(ColorRef.chart2),
//         radius: 16,
//       );

import 'feature_carousel_style.dart';

/// Carousel overrides applied app-wide through `ComponentThemes`.
const FeatureCarouselTheme featureCarouselThemeOverrides =
    FeatureCarouselTheme();
