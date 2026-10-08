// User-owned overrides for the `card_image` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `cardImageDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the card):
//
//   const CardImageTheme cardImageThemeOverrides = CardImageTheme(
//     hoverScale: 1.02,
//     imageRadius: BorderRadius.all(Radius.circular(8)),
//     gap: 8,
//   );

import 'package:flutter/widgets.dart';

import 'card_image_style.dart';

/// Card image overrides applied app-wide through `ComponentThemes`.
const CardImageTheme cardImageThemeOverrides = CardImageTheme();
