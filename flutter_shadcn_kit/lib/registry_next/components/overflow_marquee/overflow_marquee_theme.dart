// User-owned overrides for the `overflow_marquee` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `overflowMarqueeDefaults`
// and the built-in timing, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the marquee):
//
//   const OverflowMarqueeTheme overflowMarqueeThemeOverrides =
//       OverflowMarqueeTheme(
//         duration: Duration(seconds: 6),
//         delayDuration: Duration(seconds: 1),
//         fadePortion: 0.15,
//       );

import 'package:flutter/widgets.dart';

import 'overflow_marquee_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const OverflowMarqueeTheme overflowMarqueeThemeOverrides =
    OverflowMarqueeTheme();
