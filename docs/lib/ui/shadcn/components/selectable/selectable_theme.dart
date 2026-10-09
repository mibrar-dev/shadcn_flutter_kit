// User-owned overrides for the `selectable` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `selectableDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the caret):
//
//   const SelectableTextTheme selectableThemeOverrides = SelectableTextTheme(
//     cursorWidth: 3,
//     cursorColor: ThemedColor.ref(ColorRef.mutedForeground),
//   );

import 'package:flutter/widgets.dart';

import 'selectable_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const SelectableTextTheme selectableThemeOverrides = SelectableTextTheme();
