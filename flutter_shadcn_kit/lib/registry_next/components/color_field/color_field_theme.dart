// User-owned overrides for the `color_field` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `colorFieldDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete):
//
//   const ColorFieldTheme colorFieldThemeOverrides = ColorFieldTheme(
//     borderRadius: BorderRadius.only(
//       topLeft: Radius.circular(8),
//       topRight: Radius.circular(8),
//     ),
//   );

import 'package:flutter/widgets.dart';

import 'color_field_style.dart';

/// App-wide overrides applied through `ComponentThemes`.
const ColorFieldTheme colorFieldThemeOverrides = ColorFieldTheme();
