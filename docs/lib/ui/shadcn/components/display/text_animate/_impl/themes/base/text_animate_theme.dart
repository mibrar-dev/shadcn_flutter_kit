// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../text_animate.dart';

/// Theme data for [StreamingText].
class TextAnimateTheme extends ComponentThemeData {
  /// Creates `TextAnimateTheme` for configuring or rendering text animate.
  const TextAnimateTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.style,
    this.typewriter,
    this.effect,
    this.cursor,
  });

  /// Style/theme override that customizes `TextAnimateTheme` appearance.
  final TextStyle? style;

  /// Input parameter used by `TextAnimateTheme` during rendering and behavior handling.
  final TypewriterEffect? typewriter;

  /// Input parameter used by `TextAnimateTheme` during rendering and behavior handling.
  final StreamingTextEffectAdapter? effect;

  /// Input parameter used by `TextAnimateTheme` during rendering and behavior handling.
  final StreamingCursor? cursor;

  TextAnimateTheme copyWith({
    ValueGetter<TextStyle?>? style,
    ValueGetter<TypewriterEffect?>? typewriter,
    ValueGetter<StreamingTextEffectAdapter?>? effect,
    ValueGetter<StreamingCursor?>? cursor,
  }) {
    return TextAnimateTheme(
      style: style == null ? this.style : style(),
      typewriter: typewriter == null ? this.typewriter : typewriter(),
      effect: effect == null ? this.effect : effect(),
      cursor: cursor == null ? this.cursor : cursor(),
    );
  }

  /// Compares two text animate values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextAnimateTheme &&
        other.style == style &&
        other.typewriter == typewriter &&
        other.effect == effect &&
        other.cursor == cursor;
  }

  /// State flag that toggles specific text animate behavior.
  @override
  int get hashCode => Object.hash(style, typewriter, effect, cursor);
}
