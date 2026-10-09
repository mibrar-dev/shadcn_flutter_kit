// User-owned overrides for the `spinner` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `spinnerDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the spinner):
//
//   const SpinnerTheme spinnerThemeOverrides = SpinnerTheme(
//     size: 20,
//     color: ThemedColor.ref(ColorRef.mutedForeground),
//   );

import 'package:flutter/widgets.dart';

import 'spinner_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const SpinnerTheme spinnerThemeOverrides = SpinnerTheme();
