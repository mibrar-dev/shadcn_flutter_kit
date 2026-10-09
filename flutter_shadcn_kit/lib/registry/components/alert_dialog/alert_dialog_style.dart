// Registry-owned theme data for the `alert_dialog` component: the
// [AlertDialogTheme] container and its token-derived `alertDialogDefaults`.
//
// The card, its padding, the radius, the shadow and the barrier belong to the
// `dialog` component ([DialogTheme]); this theme only owns the alert-specific
// header/footer typography and spacing. User-owned overrides live in
// `alert_dialog_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Typography and spacing of the alert dialog header and footer.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class AlertDialogTheme extends ComponentThemeData
    implements Mergeable<AlertDialogTheme> {
  /// Creates an alert dialog theme.
  const AlertDialogTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
    this.iconGap,
    this.headerGap,
    this.footerGap,
    this.actionGap,
    this.footerAlignment,
  });

  /// Colour of the header icon. Default: the `mutedForeground` token.
  final ThemedColor? iconColor;

  /// Title text style; its colour falls back to the `foreground` token when
  /// the style carries none.
  final TextStyle? titleStyle;

  /// Description text style; its colour falls back to the `mutedForeground`
  /// token when the style carries none.
  final TextStyle? descriptionStyle;

  /// Space between the header icon and the title/description column.
  /// Default: 16.
  final double? iconGap;

  /// Space between the title and the description. Default: 8.
  final double? headerGap;

  /// Space between the header block and the footer action row. Default: 24.
  final double? footerGap;

  /// Space between the footer action buttons. Default: 8.
  final double? actionGap;

  /// Main-axis alignment of the footer action row. Default:
  /// [MainAxisAlignment.end].
  final MainAxisAlignment? footerAlignment;

  /// Returns a copy with the given fields replaced.
  AlertDialogTheme copyWith({
    ValueGetter<ThemedColor?>? iconColor,
    ValueGetter<TextStyle?>? titleStyle,
    ValueGetter<TextStyle?>? descriptionStyle,
    ValueGetter<double?>? iconGap,
    ValueGetter<double?>? headerGap,
    ValueGetter<double?>? footerGap,
    ValueGetter<double?>? actionGap,
    ValueGetter<MainAxisAlignment?>? footerAlignment,
  }) {
    return AlertDialogTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      iconColor: iconColor == null ? this.iconColor : iconColor(),
      titleStyle: titleStyle == null ? this.titleStyle : titleStyle(),
      descriptionStyle: descriptionStyle == null
          ? this.descriptionStyle
          : descriptionStyle(),
      iconGap: iconGap == null ? this.iconGap : iconGap(),
      headerGap: headerGap == null ? this.headerGap : headerGap(),
      footerGap: footerGap == null ? this.footerGap : footerGap(),
      actionGap: actionGap == null ? this.actionGap : actionGap(),
      footerAlignment: footerAlignment == null
          ? this.footerAlignment
          : footerAlignment(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  AlertDialogTheme merge(AlertDialogTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return AlertDialogTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      iconColor: iconColor ?? fallback.iconColor,
      // `TextStyle.merge` lets the argument win, so the fallback is merged
      // under the receiver to keep this leg's fields.
      titleStyle: titleStyle == null
          ? fallback.titleStyle
          : (fallback.titleStyle?.merge(titleStyle) ?? titleStyle),
      descriptionStyle: descriptionStyle == null
          ? fallback.descriptionStyle
          : (fallback.descriptionStyle?.merge(descriptionStyle) ??
                descriptionStyle),
      iconGap: iconGap ?? fallback.iconGap,
      headerGap: headerGap ?? fallback.headerGap,
      footerGap: footerGap ?? fallback.footerGap,
      actionGap: actionGap ?? fallback.actionGap,
      footerAlignment: footerAlignment ?? fallback.footerAlignment,
    );
  }

  /// Colours step at `t = 0.5`; dimensions are lerped.
  static AlertDialogTheme lerp(
    AlertDialogTheme a,
    AlertDialogTheme b,
    double t,
  ) {
    return AlertDialogTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      iconColor: t < 0.5 ? a.iconColor : b.iconColor,
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      descriptionStyle: TextStyle.lerp(
        a.descriptionStyle,
        b.descriptionStyle,
        t,
      ),
      iconGap: lerpDouble(a.iconGap, b.iconGap, t),
      headerGap: lerpDouble(a.headerGap, b.headerGap, t),
      footerGap: lerpDouble(a.footerGap, b.footerGap, t),
      actionGap: lerpDouble(a.actionGap, b.actionGap, t),
      footerAlignment: t < 0.5 ? a.footerAlignment : b.footerAlignment,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AlertDialogTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.iconColor == iconColor &&
        other.titleStyle == titleStyle &&
        other.descriptionStyle == descriptionStyle &&
        other.iconGap == iconGap &&
        other.headerGap == headerGap &&
        other.footerGap == footerGap &&
        other.actionGap == actionGap &&
        other.footerAlignment == footerAlignment;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    iconColor,
    titleStyle,
    descriptionStyle,
    iconGap,
    headerGap,
    footerGap,
    actionGap,
    footerAlignment,
  );
}

/// Default alert dialog title: shadcn `text-lg` (18px), semibold.
const TextStyle alertDialogDefaultTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

/// Default alert dialog description: 14px, regular.
const TextStyle alertDialogDefaultDescriptionStyle = TextStyle(fontSize: 14);

/// Token-derived baseline values; unset override fields fall through here.
///
/// Only the alert-owned values live here: the card itself (background,
/// padding, radius, shadow, barrier) is themed by the `dialog` component, so
/// an alert dialog inherits `DialogTheme.padding` of 24 at default density.
const AlertDialogTheme alertDialogDefaults = AlertDialogTheme(
  iconColor: ThemedColor.ref(ColorRef.mutedForeground),
  titleStyle: alertDialogDefaultTitleStyle,
  descriptionStyle: alertDialogDefaultDescriptionStyle,
  iconGap: 16,
  headerGap: 8,
  footerGap: 24,
  actionGap: 8,
  footerAlignment: MainAxisAlignment.end,
);
