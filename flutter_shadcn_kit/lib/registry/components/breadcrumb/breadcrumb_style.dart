// Registry-owned theme data for the `breadcrumb` component: the
// [BreadcrumbTheme] container and the token-derived `breadcrumbDefaults`.
//
// User-owned overrides live in `breadcrumb_theme.dart`; CLI updates may
// replace this file. The widget reads the resolved theme through
// `resolveComponentStyle<BreadcrumbTheme, BreadcrumbTheme>`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Visual contract of the breadcrumb trail.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class BreadcrumbTheme extends ComponentThemeData
    implements Mergeable<BreadcrumbTheme> {
  /// Creates a breadcrumb theme.
  const BreadcrumbTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.separator,
    this.padding,
    this.spacing,
  });

  /// Widget drawn between two crumbs. `null` resolves the default chevron
  /// ([Breadcrumb.arrowSeparator]); use `Breadcrumb.slashSeparator` for `/`.
  final Widget? separator;

  /// Padding around the whole strip. Default: `EdgeInsets.zero`.
  final EdgeInsetsGeometry? padding;

  /// Gap on each side of the separator, in logical pixels. Default: `6`,
  /// multiplied by the ambient scaling at build.
  final double? spacing;

  /// Returns a copy with the given fields replaced.
  BreadcrumbTheme copyWith({
    ValueGetter<Widget?>? separator,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? spacing,
  }) {
    return BreadcrumbTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      separator: separator == null ? this.separator : separator(),
      padding: padding == null ? this.padding : padding(),
      spacing: spacing == null ? this.spacing : spacing(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  BreadcrumbTheme merge(BreadcrumbTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return BreadcrumbTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      separator: separator ?? fallback.separator,
      padding: padding ?? fallback.padding,
      spacing: spacing ?? fallback.spacing,
    );
  }

  /// Widgets step at `t < 0.5`; dimensions are lerped.
  static BreadcrumbTheme lerp(BreadcrumbTheme a, BreadcrumbTheme b, double t) {
    return BreadcrumbTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      separator: t < 0.5 ? a.separator : b.separator,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: lerpDouble(a.spacing, b.spacing, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BreadcrumbTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.separator == separator &&
        other.padding == padding &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    separator,
    padding,
    spacing,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `separator` stays null: the default chevron is a widget from `breadcrumb.dart`
/// and cannot be referenced from this const.
const BreadcrumbTheme breadcrumbDefaults = BreadcrumbTheme(
  padding: EdgeInsets.zero,
  spacing: 6,
);
