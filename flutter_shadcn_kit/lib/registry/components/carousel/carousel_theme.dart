// User-owned overrides for the `carousel` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `carouselDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const CarouselTheme carouselThemeOverrides = CarouselTheme(
//     transition: CarouselTransition.fading,
//     viewportFraction: 0.5,
//     autoplayInterval: Duration(seconds: 4),
//   );

import 'carousel_style.dart';

/// Per-component overrides applied app-wide through `ComponentThemes`.
const CarouselTheme carouselThemeOverrides = CarouselTheme();
