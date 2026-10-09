// Registry-owned theme data for the `alert` component: the [AlertStyle]
// variant slice, the [AlertTheme] container and the token-derived
// `alertDefaults` rows.
//
// User-owned overrides live in `alert_theme.dart`; CLI updates may replace
// this file. The [AlertVariant] enum lives here (not in `alert.dart`) so the
// style layer never imports the widget layer.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual variants of the alert component.
///
/// The shadcn `default` variant is called [base] because `default` is a Dart
/// reserved word.
enum AlertVariant { base, destructive }

/// One variant's styling slice.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class AlertStyle implements Mergeable<AlertStyle> {
  /// Creates a variant style slice.
  const AlertStyle({
    this.background,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.titleStyle,
    this.contentStyle,
    this.titleColor,
    this.contentColor,
    this.iconColor,
    this.gap,
  });

  /// Surface fill.
  final ThemedColor? background;

  /// Border colour.
  final ThemedColor? borderColor;

  /// Corner radius; null resolves the ambient `radiusLg` (shadcn `rounded-lg`).
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  /// Title text style; its colour falls back to [titleColor].
  final TextStyle? titleStyle;

  /// Content text style; its colour falls back to [contentColor].
  final TextStyle? contentStyle;

  /// Title colour.
  final ThemedColor? titleColor;

  /// Content colour.
  final ThemedColor? contentColor;

  /// Leading icon colour.
  final ThemedColor? iconColor;

  /// Space between the leading icon and the text column.
  final double? gap;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  AlertStyle merge(AlertStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return AlertStyle(
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      titleStyle: titleStyle == null
          ? fallback.titleStyle
          : (fallback.titleStyle?.merge(titleStyle) ?? titleStyle),
      contentStyle: contentStyle == null
          ? fallback.contentStyle
          : (fallback.contentStyle?.merge(contentStyle) ?? contentStyle),
      titleColor: titleColor ?? fallback.titleColor,
      contentColor: contentColor ?? fallback.contentColor,
      iconColor: iconColor ?? fallback.iconColor,
      gap: gap ?? fallback.gap,
    );
  }

  /// Colours step at `t = 0.5`; dimensions are lerped.
  static AlertStyle lerp(AlertStyle a, AlertStyle b, double t) {
    return AlertStyle(
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      contentStyle: TextStyle.lerp(a.contentStyle, b.contentStyle, t),
      titleColor: t < 0.5 ? a.titleColor : b.titleColor,
      contentColor: t < 0.5 ? a.contentColor : b.contentColor,
      iconColor: t < 0.5 ? a.iconColor : b.iconColor,
      gap: lerpDouble(a.gap, b.gap, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AlertStyle &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.titleStyle == titleStyle &&
        other.contentStyle == contentStyle &&
        other.titleColor == titleColor &&
        other.contentColor == contentColor &&
        other.iconColor == iconColor &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(
    background,
    borderColor,
    borderRadius,
    padding,
    titleStyle,
    contentStyle,
    titleColor,
    contentColor,
    iconColor,
    gap,
  );
}

/// Per-variant theme container for the alert component.
class AlertTheme extends ComponentThemeData implements Mergeable<AlertTheme> {
  /// Creates an alert theme with one nullable slice per variant.
  const AlertTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.base,
    this.destructive,
  });

  /// Style for [AlertVariant.base].
  final AlertStyle? base;

  /// Style for [AlertVariant.destructive].
  final AlertStyle? destructive;

  /// The composed slice for [variant].
  ///
  /// A leg that sets only the destructive colours still inherits its own
  /// [base] row (and below it the defaults), because the destructive row is
  /// merged over the base row before the resolver merges legs.
  AlertStyle? forVariant(AlertVariant variant) {
    return switch (variant) {
      AlertVariant.base => base,
      AlertVariant.destructive => destructive?.merge(base) ?? base,
    };
  }

  /// Returns a copy with the given variant rows replaced.
  AlertTheme copyWith({
    ValueGetter<AlertStyle?>? base,
    ValueGetter<AlertStyle?>? destructive,
  }) {
    return AlertTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      base: base == null ? this.base : base(),
      destructive: destructive == null ? this.destructive : destructive(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  AlertTheme merge(AlertTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return AlertTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      base: base?.merge(fallback.base) ?? fallback.base,
      destructive:
          destructive?.merge(fallback.destructive) ?? fallback.destructive,
    );
  }

  /// Lerps each row; state scales step at `t = 0.5`.
  static AlertTheme lerp(AlertTheme a, AlertTheme b, double t) {
    AlertStyle? row(AlertStyle? x, AlertStyle? y) {
      if (x == null) {
        return y;
      }
      if (y == null) {
        return x;
      }
      return AlertStyle.lerp(x, y, t);
    }

    return AlertTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      base: row(a.base, b.base),
      destructive: row(a.destructive, b.destructive),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AlertTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.base == base &&
        other.destructive == destructive;
  }

  @override
  int get hashCode =>
      Object.hash(themeDensity, themeSpacing, themeShadows, base, destructive);
}

/// Default alert title: shadcn `text-sm font-medium`.
const TextStyle alertDefaultTitleStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

/// Default alert content: shadcn `text-sm`.
const TextStyle alertDefaultContentStyle = TextStyle(fontSize: 14);

/// Token-derived baseline rows; every unset override field falls through here.
///
/// shadcn alert: `bg-card text-card-foreground rounded-lg border px-4 py-3`
/// (padding 16/12, radius `--radius` = [ShadcnThemeData.radiusLg]) with a
/// 12px icon-to-text gap. The destructive variant only swaps the three
/// foreground colours to the `destructive` token; the surface stays a card.
const AlertTheme alertDefaults = AlertTheme(
  base: AlertStyle(
    background: ThemedColor.ref(ColorRef.card),
    borderColor: ThemedColor.ref(ColorRef.border),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    titleStyle: alertDefaultTitleStyle,
    contentStyle: alertDefaultContentStyle,
    titleColor: ThemedColor.ref(ColorRef.foreground),
    contentColor: ThemedColor.ref(ColorRef.mutedForeground),
    iconColor: ThemedColor.ref(ColorRef.foreground),
    gap: 12,
  ),
  destructive: AlertStyle(
    titleColor: ThemedColor.ref(ColorRef.destructive),
    contentColor: ThemedColor.ref(ColorRef.destructive),
    iconColor: ThemedColor.ref(ColorRef.destructive),
  ),
);
