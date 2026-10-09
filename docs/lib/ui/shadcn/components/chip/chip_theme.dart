// User-owned overrides for the `chip` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `chipDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle every chip):
//
//   const ChipTheme chipThemeOverrides = ChipTheme(
//     variant: ButtonVariant.outline,
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//   );

import 'package:flutter/widgets.dart';

import 'chip_style.dart';

/// Chip overrides applied app-wide through `ComponentThemes`.
const ChipTheme chipThemeOverrides = ChipTheme();
