// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../text_animate.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME DEFAULTS
// Built-in defaults (never changes)
// Extracted from hard-coded values in text animate widgets
// ═══════════════════════════════════════════════════════════

class TextAnimateThemeDefaults {
  const TextAnimateThemeDefaults({
    this.style = const TextStyle(),
    this.typewriter = const TypewriterEffect(),
    this.effect = const NoEffect(),
    this.cursor = const StreamingCursor.none(),
  });

  /// From `StreamingTextState`: `defaultValue: const TextStyle()`
  final TextStyle style;

  /// From `StreamingTextState`: `defaultValue: const TypewriterEffect()`
  final TypewriterEffect typewriter;

  /// From `StreamingTextState`: `defaultValue: const NoEffect()`
  final StreamingTextEffectAdapter effect;

  /// From `StreamingTextState`: `defaultValue: const StreamingCursor.none()`
  final StreamingCursor cursor;
}
