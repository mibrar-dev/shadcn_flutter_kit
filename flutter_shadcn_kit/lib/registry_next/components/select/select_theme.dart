// User-owned overrides for the `select` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `selectDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle every select):
//
//   const SelectTheme selectThemeOverrides = SelectTheme(
//     variant: ButtonVariant.secondary,
//     itemPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     maxHeight: 320,
//   );

import 'package:flutter/widgets.dart';

import 'select_style.dart';

/// Select overrides applied app-wide through `ComponentThemes`.
const SelectTheme selectThemeOverrides = SelectTheme();
