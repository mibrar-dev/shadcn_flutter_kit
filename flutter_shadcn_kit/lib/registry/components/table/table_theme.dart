// User-owned overrides for the `table` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `tableDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the grid):
//
//   const TableTheme tableThemeOverrides = TableTheme(
//     background: ThemedColor.ref(ColorRef.background),
//     borderColor: ThemedColor.ref(ColorRef.border),
//     borderWidth: 1,
//     borderRadius: BorderRadius.zero,
//     resizerColor: ThemedColor.ref(ColorRef.ring),
//   );

import 'package:flutter/widgets.dart';

import 'table_style.dart';

/// Table overrides applied app-wide through `ComponentThemes`.
const TableTheme tableThemeOverrides = TableTheme();
