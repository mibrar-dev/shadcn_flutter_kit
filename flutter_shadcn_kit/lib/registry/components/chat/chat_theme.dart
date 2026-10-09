// User-owned overrides for the `chat` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `chatDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to customise the chat):
//
//   const ChatTheme chatThemeOverrides = ChatTheme(
//     background: ThemedColor.ref(ColorRef.accent),
//     foreground: ThemedColor.ref(ColorRef.accentForeground),
//     variant: ChatBubbleVariant.plain,
//     widthFactor: 0.7,
//   );

import 'package:flutter/widgets.dart';

import 'chat_style.dart';

/// Overrides applied app-wide through `ComponentThemes`.
const ChatTheme chatThemeOverrides = ChatTheme();
