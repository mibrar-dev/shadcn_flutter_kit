// Registry-owned theme data for the `navigation_menu` component.
//
// User-owned overrides live in `navigation_menu_theme.dart`; CLI updates may
// replace this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Theme of the navigation menu bar and its popover.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget).
class NavigationMenuTheme extends ComponentThemeData
    implements Mergeable<NavigationMenuTheme> {
  /// Creates a navigation menu theme.
  const NavigationMenuTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.margin,
    this.offset,
    this.padding,
    this.maxWidth,
  });

  /// Opacity of the popover surface. Default: ambient surface opacity (or 1).
  final double? surfaceOpacity;

  /// Blur under the popover surface. Default: ambient surface blur (or 0).
  final double? surfaceBlur;

  /// Margin around the popover. Default: one density gap step all around.
  final EdgeInsetsGeometry? margin;

  /// Offset of the popover from its trigger. Default: 4px below.
  final Offset? offset;

  /// Padding inside the popover. Default: 0.75 density steps all around.
  final EdgeInsetsGeometry? padding;

  /// Maximum popover width before wrapping. Default: unconstrained.
  final double? maxWidth;

  /// Returns a copy with the given fields replaced.
  NavigationMenuTheme copyWith({
    ValueGetter<double?>? surfaceOpacity,
    ValueGetter<double?>? surfaceBlur,
    ValueGetter<EdgeInsetsGeometry?>? margin,
    ValueGetter<Offset?>? offset,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? maxWidth,
  }) {
    return NavigationMenuTheme(
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      margin: margin == null ? this.margin : margin(),
      offset: offset == null ? this.offset : offset(),
      padding: padding == null ? this.padding : padding(),
      maxWidth: maxWidth == null ? this.maxWidth : maxWidth(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  NavigationMenuTheme merge(NavigationMenuTheme? fallback) {
    if (fallback == null) return this;
    return NavigationMenuTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      surfaceOpacity: surfaceOpacity ?? fallback.surfaceOpacity,
      surfaceBlur: surfaceBlur ?? fallback.surfaceBlur,
      margin: margin ?? fallback.margin,
      offset: offset ?? fallback.offset,
      padding: padding ?? fallback.padding,
      maxWidth: maxWidth ?? fallback.maxWidth,
    );
  }

  /// Geometry interpolates; the rest steps at `t = 0.5`.
  static NavigationMenuTheme lerp(
    NavigationMenuTheme a,
    NavigationMenuTheme b,
    double t,
  ) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return NavigationMenuTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      surfaceOpacity: scale(a.surfaceOpacity, b.surfaceOpacity),
      surfaceBlur: scale(a.surfaceBlur, b.surfaceBlur),
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
      offset: Offset.lerp(a.offset, b.offset, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      maxWidth: scale(a.maxWidth, b.maxWidth),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationMenuTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.margin == margin &&
        other.offset == offset &&
        other.padding == padding &&
        other.maxWidth == maxWidth;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    surfaceOpacity,
    surfaceBlur,
    margin,
    offset,
    padding,
    maxWidth,
  );
}

/// Built-in navigation menu defaults.
const NavigationMenuTheme navigationMenuDefaults = NavigationMenuTheme(
  offset: Offset(0, 4),
  padding: EdgeInsetsDensity.all(0.75),
);
