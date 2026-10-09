// User-owned overrides for the `swiper` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `swiperDefaults` and the
// global tokens, so an empty override keeps the exact default look.
//
// Sparse example (uncomment and complete to customise the swipe):
//
//   const SwiperTheme swiperThemeOverrides = SwiperTheme(
//     threshold: 0.35,
//     maxSize: 280,
//     barrierDismissible: false,
//   );

import 'package:flutter/widgets.dart';

import 'swiper_style.dart';

/// Swipe overrides applied app-wide through `ComponentThemes`.
const SwiperTheme swiperThemeOverrides = SwiperTheme();
