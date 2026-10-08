// User-owned overrides for the `breadcrumb` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `breadcrumbDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the trail):
//
//   const BreadcrumbTheme breadcrumbThemeOverrides = BreadcrumbTheme(
//     separator: Breadcrumb.slashSeparator,
//     spacing: 8,
//   );

import 'package:flutter/widgets.dart';

import 'breadcrumb_style.dart';

/// Trail overrides applied app-wide through `ComponentThemes`.
const BreadcrumbTheme breadcrumbThemeOverrides = BreadcrumbTheme();
