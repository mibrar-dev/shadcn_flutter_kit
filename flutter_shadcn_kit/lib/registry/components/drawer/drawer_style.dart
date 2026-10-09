// Registry-owned theme data for the `drawer` component: the [DrawerTheme]
// container and the token-derived `drawerDefaults`.
//
// User-owned overrides live in `drawer_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<DrawerTheme, DrawerTheme>`; the panel shell (in
// `primitives/drawer_route/`) reads it through [DrawerRouteTheme].

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../primitives/drawer_route/drawer_route.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Surface, border, barrier and sizing contract of a drawer or sheet.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class DrawerTheme extends ComponentThemeData
    implements Mergeable<DrawerTheme>, DrawerRouteTheme {
  /// Creates a drawer theme.
  const DrawerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.barrierColor,
    this.maxSize,
    this.showDragHandle,
    this.dragHandleSize,
    this.dragHandleColor,
    this.transitionDuration,
    this.shadows,
  });

  /// Panel fill. Default: the `background` token.
  @override
  final ThemedColor? background;

  /// Panel content colour. Default: the `foreground` token.
  @override
  final ThemedColor? foreground;

  /// Inner-edge border colour; null draws no border. Default: `border`.
  @override
  final ThemedColor? borderColor;

  /// Border width; `0` hides the border. Default: `1`.
  @override
  final double? borderWidth;

  /// Inner-corner radius; null resolves the ambient `radiusLg` at build.
  @override
  final BorderRadius? borderRadius;

  /// Panel padding. Default: `EdgeInsets.all(24)`.
  @override
  final EdgeInsetsGeometry? padding;

  /// Barrier colour. Default: black at 50%.
  @override
  final ThemedColor? barrierColor;

  /// Panel extent along its slide axis. Default: `320`; ignored when the call
  /// expands it.
  @override
  final double? maxSize;

  /// Whether the drag handle is drawn. Default: `true`.
  @override
  final bool? showDragHandle;

  /// Drag handle size. Default: `Size(36, 4)`.
  @override
  final Size? dragHandleSize;

  /// Drag handle colour. Default: the `muted` token.
  @override
  final ThemedColor? dragHandleColor;

  /// Open/close transition duration. Default: `250ms`.
  @override
  final Duration? transitionDuration;

  /// Drop shadows; null resolves the ambient `shadowLg`, `const []` removes.
  @override
  final List<BoxShadow>? shadows;

  /// Returns a copy with the given fields replaced.
  DrawerTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadius?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<ThemedColor?>? barrierColor,
    ValueGetter<double?>? maxSize,
    ValueGetter<bool?>? showDragHandle,
    ValueGetter<Size?>? dragHandleSize,
    ValueGetter<ThemedColor?>? dragHandleColor,
    ValueGetter<Duration?>? transitionDuration,
    ValueGetter<List<BoxShadow>?>? shadows,
  }) {
    return DrawerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      barrierColor: barrierColor == null ? this.barrierColor : barrierColor(),
      maxSize: maxSize == null ? this.maxSize : maxSize(),
      showDragHandle: showDragHandle == null
          ? this.showDragHandle
          : showDragHandle(),
      dragHandleSize: dragHandleSize == null
          ? this.dragHandleSize
          : dragHandleSize(),
      dragHandleColor: dragHandleColor == null
          ? this.dragHandleColor
          : dragHandleColor(),
      transitionDuration: transitionDuration == null
          ? this.transitionDuration
          : transitionDuration(),
      shadows: shadows == null ? this.shadows : shadows(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  DrawerTheme merge(DrawerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return DrawerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      barrierColor: barrierColor ?? fallback.barrierColor,
      maxSize: maxSize ?? fallback.maxSize,
      showDragHandle: showDragHandle ?? fallback.showDragHandle,
      dragHandleSize: dragHandleSize ?? fallback.dragHandleSize,
      dragHandleColor: dragHandleColor ?? fallback.dragHandleColor,
      transitionDuration: transitionDuration ?? fallback.transitionDuration,
      shadows: shadows ?? fallback.shadows,
    );
  }

  /// Colours, durations and flags step at `t < 0.5`; geometry and shadows
  /// interpolate.
  static DrawerTheme lerp(DrawerTheme a, DrawerTheme b, double t) {
    return DrawerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      barrierColor: t < 0.5 ? a.barrierColor : b.barrierColor,
      maxSize: lerpDouble(a.maxSize, b.maxSize, t),
      showDragHandle: t < 0.5 ? a.showDragHandle : b.showDragHandle,
      dragHandleSize: Size.lerp(a.dragHandleSize, b.dragHandleSize, t),
      dragHandleColor: t < 0.5 ? a.dragHandleColor : b.dragHandleColor,
      transitionDuration: t < 0.5 ? a.transitionDuration : b.transitionDuration,
      shadows:
          BoxShadow.lerpList(a.shadows, b.shadows, t) ??
          (t < 0.5 ? a.shadows : b.shadows),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DrawerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.barrierColor == barrierColor &&
        other.maxSize == maxSize &&
        other.showDragHandle == showDragHandle &&
        other.dragHandleSize == dragHandleSize &&
        other.dragHandleColor == dragHandleColor &&
        other.transitionDuration == transitionDuration &&
        Object.hashAll(other.shadows ?? const <BoxShadow>[]) ==
            Object.hashAll(shadows ?? const <BoxShadow>[]);
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    barrierColor,
    maxSize,
    showDragHandle,
    dragHandleSize,
    dragHandleColor,
    transitionDuration,
    Object.hashAll(shadows ?? const <BoxShadow>[]),
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `borderRadius` and `shadows` stay null because their real defaults come
/// from the ambient token scale (`radiusLg`, `shadowLg`) and are resolved at
/// build time.
const DrawerTheme drawerDefaults = DrawerTheme(
  background: ThemedColor.ref(ColorRef.background),
  foreground: ThemedColor.ref(ColorRef.foreground),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: EdgeInsets.all(24),
  barrierColor: ThemedColor.value(Color(0x80000000)),
  maxSize: 320,
  showDragHandle: true,
  dragHandleSize: Size(36, 4),
  dragHandleColor: ThemedColor.ref(ColorRef.muted),
  transitionDuration: Duration(milliseconds: 250),
);
