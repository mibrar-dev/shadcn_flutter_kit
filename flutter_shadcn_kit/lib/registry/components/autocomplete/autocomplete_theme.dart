// User-owned overrides for the `autocomplete` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `autocompleteDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the suggestion list):
//
//   const AutoCompleteTheme autocompleteThemeOverrides = AutoCompleteTheme(
//     itemBackground: StateValue(
//       rest: ThemedColor.ref(ColorRef.muted),
//       hovered: ThemedColor.ref(ColorRef.accent),
//       selected: ThemedColor.ref(ColorRef.accent),
//     ),
//   );

import 'package:flutter/widgets.dart';

import 'autocomplete_style.dart';

/// Suggestion-list overrides applied app-wide through `ComponentThemes`.
const AutoCompleteTheme autocompleteThemeOverrides = AutoCompleteTheme();
