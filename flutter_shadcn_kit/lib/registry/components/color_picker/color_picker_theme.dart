// User-owned overrides for the `color_picker` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `colorPickerDefaults` and
// the global tokens, so an empty override keeps the exact token look.
//
//   const ColorPickerTheme colorPickerThemeOverrides = ColorPickerTheme(
//     sliderSize: 16,
//   );

import 'color_picker_style.dart';

/// App-wide colour picker overrides applied through `ComponentThemes`.
const ColorPickerTheme colorPickerThemeOverrides = ColorPickerTheme();
