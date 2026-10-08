// User-owned overrides for the `accordion` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `accordionDefaults`.
//
// Sparse example (uncomment and complete to customise the sections):
//
//   const AccordionTheme accordionThemeOverrides = AccordionTheme(
//     duration: Duration(milliseconds: 120),
//     dividerColor: ThemedColor.ref(ColorRef.border),
//     arrowIconColor: ThemedColor.ref(ColorRef.foreground),
//   );

import 'package:flutter/widgets.dart';

import 'accordion_style.dart';

/// Accordion overrides applied app-wide through `ComponentThemes`.
const AccordionTheme accordionThemeOverrides = AccordionTheme();
