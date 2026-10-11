// User-owned overrides for the `chip_input` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `chipInputDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise):
//
//   const ChipInputTheme chipInputThemeOverrides = ChipInputTheme(
//     spacing: 8,
//     removable: false,
//     chipTheme: ChipTheme(variant: ButtonVariant.outline),
//   );

import 'chip_input_style.dart';

/// Chip-input overrides applied app-wide through `ComponentThemes`.
const ChipInputTheme chipInputThemeOverrides = ChipInputTheme();
