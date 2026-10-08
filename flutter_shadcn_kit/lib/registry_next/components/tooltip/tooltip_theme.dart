// User-owned overrides for the `tooltip` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `tooltipDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
//   const TooltipTheme tooltipThemeOverrides = TooltipTheme(
//     background: ThemedColor.ref(ColorRef.accent),
//     foreground: ThemedColor.ref(ColorRef.accentForeground),
//     borderRadius: BorderRadius.all(Radius.circular(4)),
//   );

import 'tooltip_style.dart';

/// Per-component overrides applied app-wide through `ComponentThemes`.
const TooltipTheme tooltipThemeOverrides = TooltipTheme();
