// User-owned overrides for the `avatar` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `avatarDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise a row):
//
//   const AvatarTheme avatarThemeOverrides = AvatarTheme(
//     backgroundColor: ThemedColor.ref(ColorRef.secondary),
//     badgeColor: ThemedColor.value(Color(0xFF16A34A)),
//   );

import 'package:flutter/widgets.dart';

import 'avatar_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const AvatarTheme avatarThemeOverrides = AvatarTheme();
