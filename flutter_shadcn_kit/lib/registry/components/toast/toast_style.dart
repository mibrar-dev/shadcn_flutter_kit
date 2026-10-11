// Registry-owned theme data for the `toast` component: the [ToastTheme]
// container and the token-derived `toastDefaults`.
//
// User-owned overrides live in `toast_theme.dart`; CLI updates may replace
// this file. The widget reads the resolved theme through
// `resolveComponentStyle<ToastTheme, ToastTheme>`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Visual and timing contract of a toast stack.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ToastTheme extends ComponentThemeData implements Mergeable<ToastTheme> {
  /// Creates a toast theme.
  const ToastTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.maxWidth,
    this.shadows,
    this.duration,
    this.animationDuration,
    this.pauseOnHover,
    this.showCloseButton,
    this.gap,
    this.offset,
  });

  /// Surface fill. Default: the `popover` token.
  final ThemedColor? background;

  /// Content colour. Default: the `popoverForeground` token.
  final ThemedColor? foreground;

  /// Border colour; null draws no border. Default: the `border` token.
  final ThemedColor? borderColor;

  /// Border width; `0` hides the border. Default: `1`.
  final double? borderWidth;

  /// Corner radius; null resolves the ambient `radiusMd` at build.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding. Default: [toastDefaultPadding] (shadcn `p-4`).
  final EdgeInsetsGeometry? padding;

  /// Maximum card width. Default: `380`.
  final double? maxWidth;

  /// Drop shadows; null resolves the ambient `shadowLg`, `const []` removes.
  final List<BoxShadow>? shadows;

  /// Default auto-dismiss duration. Default: `3s`.
  final Duration? duration;

  /// Entry animation duration. Default: `250ms`.
  final Duration? animationDuration;

  /// Whether hovering or pressing a toast pauses its countdown. Default: `true`.
  final bool? pauseOnHover;

  /// Whether each toast shows a close button. Default: `true`.
  final bool? showCloseButton;

  /// Gap between stacked toasts. Default: `8`.
  final double? gap;

  /// Screen-edge inset of the stack. Default: `EdgeInsets.all(24)`.
  final EdgeInsetsGeometry? offset;

  /// Returns a copy with the given fields replaced.
  ToastTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? maxWidth,
    ValueGetter<List<BoxShadow>?>? shadows,
    ValueGetter<Duration?>? duration,
    ValueGetter<Duration?>? animationDuration,
    ValueGetter<bool?>? pauseOnHover,
    ValueGetter<bool?>? showCloseButton,
    ValueGetter<double?>? gap,
    ValueGetter<EdgeInsetsGeometry?>? offset,
  }) {
    return ToastTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      maxWidth: maxWidth == null ? this.maxWidth : maxWidth(),
      shadows: shadows == null ? this.shadows : shadows(),
      duration: duration == null ? this.duration : duration(),
      animationDuration: animationDuration == null
          ? this.animationDuration
          : animationDuration(),
      pauseOnHover: pauseOnHover == null ? this.pauseOnHover : pauseOnHover(),
      showCloseButton: showCloseButton == null
          ? this.showCloseButton
          : showCloseButton(),
      gap: gap == null ? this.gap : gap(),
      offset: offset == null ? this.offset : offset(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ToastTheme merge(ToastTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ToastTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      maxWidth: maxWidth ?? fallback.maxWidth,
      shadows: shadows ?? fallback.shadows,
      duration: duration ?? fallback.duration,
      animationDuration: animationDuration ?? fallback.animationDuration,
      pauseOnHover: pauseOnHover ?? fallback.pauseOnHover,
      showCloseButton: showCloseButton ?? fallback.showCloseButton,
      gap: gap ?? fallback.gap,
      offset: offset ?? fallback.offset,
    );
  }

  /// Colours, durations and flags step at `t < 0.5`; dimensions and shadows
  /// interpolate.
  static ToastTheme lerp(ToastTheme a, ToastTheme b, double t) {
    return ToastTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      padding: t < 0.5 ? a.padding : b.padding,
      maxWidth: lerpDouble(a.maxWidth, b.maxWidth, t),
      shadows:
          BoxShadow.lerpList(a.shadows, b.shadows, t) ??
          (t < 0.5 ? a.shadows : b.shadows),
      duration: t < 0.5 ? a.duration : b.duration,
      animationDuration: t < 0.5 ? a.animationDuration : b.animationDuration,
      pauseOnHover: t < 0.5 ? a.pauseOnHover : b.pauseOnHover,
      showCloseButton: t < 0.5 ? a.showCloseButton : b.showCloseButton,
      gap: lerpDouble(a.gap, b.gap, t),
      offset: t < 0.5 ? a.offset : b.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ToastTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.foreground == foreground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.maxWidth == maxWidth &&
        Object.hashAll(other.shadows ?? const <BoxShadow>[]) ==
            Object.hashAll(shadows ?? const <BoxShadow>[]) &&
        other.duration == duration &&
        other.animationDuration == animationDuration &&
        other.pauseOnHover == pauseOnHover &&
        other.showCloseButton == showCloseButton &&
        other.gap == gap &&
        other.offset == offset;
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
    maxWidth,
    Object.hashAll(shadows ?? const <BoxShadow>[]),
    duration,
    animationDuration,
    pauseOnHover,
    showCloseButton,
    gap,
    offset,
  );
}

/// Token-derived baseline; every unset override field falls through here.
///
/// `borderRadius` and `shadows` stay null because their real defaults come
/// from the ambient token scale (`radiusMd`, `shadowLg`) and are resolved at
/// build time.
const ToastTheme toastDefaults = ToastTheme(
  background: ThemedColor.ref(ColorRef.popover),
  foreground: ThemedColor.ref(ColorRef.popoverForeground),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: toastDefaultPadding,
  maxWidth: 380,
  duration: Duration(seconds: 3),
  animationDuration: Duration(milliseconds: 250),
  pauseOnHover: true,
  showCloseButton: true,
  gap: 8,
  // The viewport inset the whole toast stack is placed with (the analogue of
  // sonner's `<Toaster offset>`), not component padding, so it does not scale
  // with density.
  offset: EdgeInsets.all(24),
);

/// Default toast card padding: shadcn `p-4`, density-scaled.
const EdgeInsetsGeometry toastDefaultPadding = EdgeInsetsDensity.pxAll(16);
