// User-owned overrides for the `error_system` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `errorSystemDefaults` and the
// global tokens, so an empty override keeps the exact token look.

import 'error_system_style.dart';

/// Error system overrides applied app-wide through `ComponentThemes`.
const ErrorSystemTheme errorSystemThemeOverrides = ErrorSystemTheme();
