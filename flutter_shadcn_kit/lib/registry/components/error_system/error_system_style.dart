// Registry-owned theme data for the `error_system` component: the
// [ErrorSystemTheme] container and its token-derived `errorSystemDefaults`.
//
// The non-visual machinery (models, rules, scopes, recovery helpers) lives in
// `primitives/error_handling/` and is re-exported by `error_system.dart`.
// User-owned overrides live in `error_system_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Appearance of the error UI.
class ErrorSystemTheme extends ComponentThemeData
    implements Mergeable<ErrorSystemTheme> {
  /// Creates an error system theme.
  const ErrorSystemTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.messageStyle,
    this.cardPadding,
    this.bannerBackground,
    this.bannerBorder,
    this.bannerPadding,
  });

  /// Icon tint; null resolves the `destructive` token.
  final ThemedColor? iconColor;

  /// Icon size; null resolves 36.
  final double? iconSize;

  /// Title text style; its colour falls back to `foreground`.
  final TextStyle? titleStyle;

  /// Message text style; its colour falls back to `mutedForeground`.
  final TextStyle? messageStyle;

  /// Padding inside the full-page card; null resolves
  /// [errorSystemDefaultCardPadding] (shadcn `p-6`, density-scaled).
  final EdgeInsetsGeometry? cardPadding;

  /// Banner fill; null resolves the `card` token.
  final ThemedColor? bannerBackground;

  /// Banner border; null resolves the `destructive` token.
  final ThemedColor? bannerBorder;

  /// Banner padding; null resolves [errorSystemDefaultBannerPadding]
  /// (shadcn `px-4 py-3`, density-scaled).
  final EdgeInsetsGeometry? bannerPadding;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ErrorSystemTheme merge(ErrorSystemTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ErrorSystemTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      iconColor: iconColor ?? fallback.iconColor,
      iconSize: iconSize ?? fallback.iconSize,
      titleStyle: _mergeText(titleStyle, fallback.titleStyle),
      messageStyle: _mergeText(messageStyle, fallback.messageStyle),
      cardPadding: cardPadding ?? fallback.cardPadding,
      bannerBackground: bannerBackground ?? fallback.bannerBackground,
      bannerBorder: bannerBorder ?? fallback.bannerBorder,
      bannerPadding: bannerPadding ?? fallback.bannerPadding,
    );
  }

  static TextStyle? _mergeText(TextStyle? receiver, TextStyle? fallback) {
    if (receiver == null) {
      return fallback;
    }
    return fallback?.merge(receiver) ?? receiver;
  }

  @override
  bool operator ==(Object other) =>
      other is ErrorSystemTheme &&
      other.themeDensity == themeDensity &&
      other.themeSpacing == themeSpacing &&
      other.themeShadows == themeShadows &&
      other.iconColor == iconColor &&
      other.iconSize == iconSize &&
      other.titleStyle == titleStyle &&
      other.messageStyle == messageStyle &&
      other.cardPadding == cardPadding &&
      other.bannerBackground == bannerBackground &&
      other.bannerBorder == bannerBorder &&
      other.bannerPadding == bannerPadding;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    iconColor,
    iconSize,
    titleStyle,
    messageStyle,
    cardPadding,
    bannerBackground,
    bannerBorder,
    bannerPadding,
  );
}

/// Card padding of the full-page error: shadcn `p-6` (24px), density-scaled.
const EdgeInsetsGeometry errorSystemDefaultCardPadding =
    EdgeInsetsDensity.pxAll(24);

/// Banner padding: shadcn `px-4 py-3`, density-scaled.
const EdgeInsetsGeometry errorSystemDefaultBannerPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 16, vertical: 12);

/// Token-derived baseline.
const ErrorSystemTheme errorSystemDefaults = ErrorSystemTheme(
  iconColor: ThemedColor.ref(ColorRef.destructive),
  iconSize: 36,
  titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  messageStyle: TextStyle(fontSize: 14),
  cardPadding: errorSystemDefaultCardPadding,
  bannerBackground: ThemedColor.ref(ColorRef.card),
  bannerBorder: ThemedColor.ref(ColorRef.destructive),
  bannerPadding: errorSystemDefaultBannerPadding,
);
