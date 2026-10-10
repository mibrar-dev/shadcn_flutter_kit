// Registry-owned theme data for the `keyboard_shortcut` component: the
// [KeyboardShortcutTheme] cap styling and the token-derived
// [keyboardShortcutDefaults].
//
// shadcn shortcut hint: one small rounded cap per key, a translucent background
// so overlapping surfaces read through, and no shadow. User-owned overrides
// live in `keyboard_shortcut_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Default horizontal gap between two caps (shadcn `gap-0.5` = 2).
const double keyboardShortcutDefaultSpacing = 2;

/// Default padding inside one cap: shadcn `px-1.5 py-0.5`, density-scaled.
///
/// Typed [EdgeInsets] (the value an override leg is compared against) but
/// built as an [EdgeInsetsDensity]: its stored sides are shadcn-px multipliers
/// (6/16, 4/16), so [KeyboardKeyCap] resolves it against
/// `density.baseContentPadding * scaling` and a literal override passes
/// through unchanged.
const EdgeInsets keyboardShortcutDefaultKeyPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 6, vertical: 4);

/// Fallback label text style (shadcn `text-xs` = 12).
const TextStyle keyboardShortcutDefaultTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

/// Styling of one key cap.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class KeyboardShortcutTheme extends ComponentThemeData
    implements Mergeable<KeyboardShortcutTheme> {
  /// Creates a keyboard-shortcut theme.
  const KeyboardShortcutTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.keyPadding,
    this.keyBackground,
    this.keyForeground,
    this.keyBorderRadius,
    this.keyTextStyle,
    this.keyShadows,
  });

  /// Horizontal gap between two caps; null resolves
  /// [keyboardShortcutDefaultSpacing].
  final double? spacing;

  /// Padding inside one cap; null resolves
  /// [keyboardShortcutDefaultKeyPadding] (density-scaled).
  final EdgeInsetsGeometry? keyPadding;

  /// Fill of one cap; null resolves `background` at 70% alpha.
  final ThemedColor? keyBackground;

  /// Label colour of one cap; null resolves `mutedForeground`.
  final ThemedColor? keyForeground;

  /// Corner radius of one cap; null resolves the ambient `radiusMd`.
  final BorderRadiusGeometry? keyBorderRadius;

  /// Label text style; null resolves [keyboardShortcutDefaultTextStyle].
  final TextStyle? keyTextStyle;

  /// Shadows under one cap; null draws none (the shadcn look).
  final List<BoxShadow>? keyShadows;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  KeyboardShortcutTheme merge(KeyboardShortcutTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return KeyboardShortcutTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      spacing: spacing ?? fallback.spacing,
      keyPadding: keyPadding ?? fallback.keyPadding,
      keyBackground: keyBackground ?? fallback.keyBackground,
      keyForeground: keyForeground ?? fallback.keyForeground,
      keyBorderRadius: keyBorderRadius ?? fallback.keyBorderRadius,
      keyTextStyle: keyTextStyle == null
          ? fallback.keyTextStyle
          : (fallback.keyTextStyle?.merge(keyTextStyle) ?? keyTextStyle),
      keyShadows: keyShadows ?? fallback.keyShadows,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is KeyboardShortcutTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.spacing == spacing &&
        other.keyPadding == keyPadding &&
        other.keyBackground == keyBackground &&
        other.keyForeground == keyForeground &&
        other.keyBorderRadius == keyBorderRadius &&
        other.keyTextStyle == keyTextStyle &&
        _shadowsEqual(other.keyShadows, keyShadows);
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    spacing,
    keyPadding,
    keyBackground,
    keyForeground,
    keyBorderRadius,
    keyTextStyle,
    Object.hashAll(keyShadows ?? const <BoxShadow>[]),
  );

  static bool _shadowsEqual(List<BoxShadow>? a, List<BoxShadow>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null || a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i].color != b[i].color ||
          a[i].offset != b[i].offset ||
          a[i].blurRadius != b[i].blurRadius ||
          a[i].spreadRadius != b[i].spreadRadius) {
        return false;
      }
    }
    return true;
  }
}

/// Token-derived baseline values; unset override fields fall through here.
///
/// `keyBackground` is intentionally left unset: the default is
/// `background` scaled to 70% alpha, which the widget computes so it tracks the
/// ambient palette instead of being frozen at construction.
const KeyboardShortcutTheme keyboardShortcutDefaults = KeyboardShortcutTheme(
  spacing: keyboardShortcutDefaultSpacing,
  keyPadding: keyboardShortcutDefaultKeyPadding,
  keyTextStyle: keyboardShortcutDefaultTextStyle,
);
