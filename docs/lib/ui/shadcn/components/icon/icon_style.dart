// Registry-owned theme data for the `icon` component: the
// [IconContainerTheme] container and the token-derived `iconContainerDefaults`.
//
// User-owned overrides live in `icon_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<IconContainerTheme, IconContainerTheme>` from
// `theme/theme.dart`.
//
// The class is named `IconContainerTheme` (not `IconTheme`) because
// `package:flutter/widgets.dart` already exports an `IconTheme` widget;
// reusing that name would shadow the framework class for every importer.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// One icon container's visual contract.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. `borderRadius` resolves at
/// build from the ambient radius token.
class IconContainerTheme extends ComponentThemeData
    implements Mergeable<IconContainerTheme> {
  /// Creates an icon container theme.
  const IconContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.borderRadius,
  });

  /// Container fill; null resolves the `primary` token.
  final ThemedColor? backgroundColor;

  /// Icon colour; null resolves the `primaryForeground` token.
  final ThemedColor? iconColor;

  /// Inner padding; null resolves `padXs` x container density.
  final EdgeInsetsGeometry? padding;

  /// Corner radius; null resolves `radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Returns a copy with the given fields replaced.
  IconContainerTheme copyWith({
    ValueGetter<ThemedColor?>? backgroundColor,
    ValueGetter<ThemedColor?>? iconColor,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return IconContainerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      backgroundColor: backgroundColor == null
          ? this.backgroundColor
          : backgroundColor(),
      iconColor: iconColor == null ? this.iconColor : iconColor(),
      padding: padding == null ? this.padding : padding(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  IconContainerTheme merge(IconContainerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return IconContainerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      backgroundColor: backgroundColor ?? fallback.backgroundColor,
      iconColor: iconColor ?? fallback.iconColor,
      padding: padding ?? fallback.padding,
      borderRadius: borderRadius ?? fallback.borderRadius,
    );
  }

  /// Colours and styles step at t < 0.5; dimensions are lerped.
  static IconContainerTheme lerp(
    IconContainerTheme a,
    IconContainerTheme b,
    double t,
  ) {
    return IconContainerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
      iconColor: t < 0.5 ? a.iconColor : b.iconColor,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is IconContainerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.backgroundColor == backgroundColor &&
        other.iconColor == iconColor &&
        other.padding == padding &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    backgroundColor,
    iconColor,
    padding,
    borderRadius,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const IconContainerTheme iconContainerDefaults = IconContainerTheme(
  backgroundColor: ThemedColor.ref(ColorRef.primary),
  iconColor: ThemedColor.ref(ColorRef.primaryForeground),
  padding: EdgeInsetsDensity.all(padXs),
);
