import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'color_tokens.dart';
import 'density.dart';
import 'tokens.dart';
import 'typography.dart';

/// Ambient shadcn theme data: colors, tokens, fonts, typography and flags.
class ShadcnThemeData {
  const ShadcnThemeData({
    this.colors = ShadcnColors.lightFallback,
    this.tokens = const ShadcnTokens(),
    this.fonts = ShadcnFonts.empty,
    this.typography = const Typography.geist(),
    this.iconTheme = const IconThemeProperties(),
    this.scaling = 1,
    this.density = Density.defaultDensity,
    this.spacing = const SpacingScale(4.0),
    this.tracking = const TrackingScale(),
    TargetPlatform? platform,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.enableFeedback,
  }) : _platform = platform;

  /// Color tokens for the current brightness.
  final ShadcnColors colors;

  /// Non-color tokens (radius factor, spacing base, tracking, shadows).
  final ShadcnTokens tokens;

  /// Mode-independent font families.
  final ShadcnFonts fonts;

  /// Text styles.
  final Typography typography;

  /// Icon sizes.
  final IconThemeProperties iconTheme;

  /// Global size scaling factor.
  final double scaling;

  /// Container/content padding and gap bases.
  final Density density;

  /// Spacing scale for padding/margins.
  final SpacingScale spacing;

  /// Letter-spacing scale.
  final TrackingScale tracking;

  final TargetPlatform? _platform;

  /// Surface overlay opacity for popups/cards (read by surface components).
  final double? surfaceOpacity;

  /// Surface blur radius for popups/cards.
  final double? surfaceBlur;

  /// Haptic/sound feedback toggle for interactive controls.
  final bool? enableFeedback;

  /// Effective platform (override or ambient default).
  TargetPlatform get platform => _platform ?? defaultTargetPlatform;

  /// Explicit platform override, if any.
  TargetPlatform? get specifiedPlatform => _platform;

  /// Current brightness, from the color tokens.
  Brightness get brightness => colors.brightness;

  /// Base radius factor: the preset `radius` rem number (e.g. 0.625).
  ///
  /// Derived steps follow shadcn `globals.css`: `lg` is the rem value in
  /// px (`radius * 16`); `sm`/`md` step down 4/2 px and `xl` steps up
  /// 4 px, clamped at zero so small radii (and 0) never go negative.
  /// `xl` additionally collapses to 0 when `lg` is 0, so square-corner
  /// presets (`radius: 0`) stay square on `rounded-xl` surfaces too.
  /// `xs`/`xxl` are kit extensions that keep the old linear steps.
  double get radius => tokens.radius;
  double get radiusXs => radius * 4;
  double get radiusSm => max(0.0, radiusLg - 4);
  double get radiusMd => max(0.0, radiusLg - 2);
  double get radiusLg => radius * 16;
  double get radiusXl => radiusLg <= 0 ? 0 : radiusLg + 4;
  double get radiusXxl => radius * 24;

  BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  BorderRadius get borderRadiusXxl => BorderRadius.circular(radiusXxl);

  ShadcnThemeData copyWith({
    ValueGetter<ShadcnColors>? colors,
    ValueGetter<ShadcnTokens>? tokens,
    ValueGetter<ShadcnFonts>? fonts,
    ValueGetter<Typography>? typography,
    ValueGetter<IconThemeProperties>? iconTheme,
    ValueGetter<double>? scaling,
    ValueGetter<Density>? density,
    ValueGetter<SpacingScale>? spacing,
    ValueGetter<TrackingScale>? tracking,
    ValueGetter<TargetPlatform>? platform,
    ValueGetter<double>? surfaceOpacity,
    ValueGetter<double>? surfaceBlur,
    ValueGetter<bool>? enableFeedback,
  }) {
    final nextDensity = density == null ? this.density : density();
    final nextSpacing = spacing == null
        ? (density == null ? this.spacing : nextDensity.toSpacingScale())
        : spacing();
    return ShadcnThemeData(
      colors: colors == null ? this.colors : colors(),
      tokens: tokens == null ? this.tokens : tokens(),
      fonts: fonts == null ? this.fonts : fonts(),
      typography: typography == null ? this.typography : typography(),
      iconTheme: iconTheme == null ? this.iconTheme : iconTheme(),
      scaling: scaling == null ? this.scaling : scaling(),
      density: nextDensity,
      spacing: nextSpacing,
      tracking: tracking == null ? this.tracking : tracking(),
      platform: platform == null ? _platform : platform(),
      surfaceOpacity: surfaceOpacity == null
          ? this.surfaceOpacity
          : surfaceOpacity(),
      surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
      enableFeedback: enableFeedback == null
          ? this.enableFeedback
          : enableFeedback(),
    );
  }

  static ShadcnThemeData lerp(ShadcnThemeData a, ShadcnThemeData b, double t) {
    return ShadcnThemeData(
      colors: ShadcnColors.lerp(a.colors, b.colors, t),
      tokens: ShadcnTokens.lerp(a.tokens, b.tokens, t),
      fonts: ShadcnFonts.lerp(a.fonts, b.fonts, t),
      typography: Typography.lerp(a.typography, b.typography, t),
      iconTheme: IconThemeProperties.lerp(a.iconTheme, b.iconTheme, t),
      scaling: lerpDouble(a.scaling, b.scaling, t)!,
      density: Density.lerp(a.density, b.density, t),
      spacing: SpacingScale.lerp(a.spacing, b.spacing, t),
      tracking: TrackingScale.lerp(a.tracking, b.tracking, t),
      platform: t < 0.5 ? a._platform : b._platform,
      surfaceOpacity: lerpDouble(a.surfaceOpacity, b.surfaceOpacity, t),
      surfaceBlur: lerpDouble(a.surfaceBlur, b.surfaceBlur, t),
      enableFeedback: t < 0.5 ? a.enableFeedback : b.enableFeedback,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShadcnThemeData &&
        other.colors == colors &&
        other.tokens == tokens &&
        other.fonts == fonts &&
        other.typography == typography &&
        other.iconTheme == iconTheme &&
        other.scaling == scaling &&
        other.density == density &&
        other.spacing == spacing &&
        other.tracking == tracking &&
        other._platform == _platform &&
        other.surfaceOpacity == surfaceOpacity &&
        other.surfaceBlur == surfaceBlur &&
        other.enableFeedback == enableFeedback;
  }

  @override
  int get hashCode => Object.hash(
    colors,
    tokens,
    fonts,
    typography,
    iconTheme,
    scaling,
    density,
    spacing,
    tracking,
    _platform,
    surfaceOpacity,
    surfaceBlur,
    enableFeedback,
  );
}

/// Provides [ShadcnThemeData] to descendants.
class ShadcnTheme extends InheritedTheme {
  const ShadcnTheme({super.key, required this.data, required super.child});

  /// Theme data for this subtree.
  final ShadcnThemeData data;

  /// Nearest ambient data, defaulting to `const ShadcnThemeData()`.
  /// Dark themes pass through readability normalisation.
  static ShadcnThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<ShadcnTheme>();
    final data = theme?.data ?? const ShadcnThemeData();
    return ensureReadableDarkTheme(data);
  }

  /// Patches near-black-on-dark foregrounds against luminance floors.
  /// Fires only for dark themes on dark backgrounds; kept from the old
  /// `Theme._ensureReadableDarkTheme` verbatim (thresholds included).
  static ShadcnThemeData ensureReadableDarkTheme(ShadcnThemeData data) {
    final scheme = data.colors;
    if (scheme.brightness != Brightness.dark) return data;
    if (scheme.background.computeLuminance() >= 0.5) return data;
    const defaults = ShadcnColors.darkFallback;
    Color readable(Color color, Color fallback, double minLuminance) {
      return color.computeLuminance() < minLuminance ? fallback : color;
    }

    final normalized = scheme.copyWith(
      foreground: readable(scheme.foreground, defaults.foreground, 0.5),
      mutedForeground: readable(
        scheme.mutedForeground,
        defaults.mutedForeground,
        0.35,
      ),
      cardForeground: readable(
        scheme.cardForeground,
        defaults.cardForeground,
        0.45,
      ),
      popoverForeground: readable(
        scheme.popoverForeground,
        defaults.popoverForeground,
        0.45,
      ),
      sidebarForeground: readable(
        scheme.sidebarForeground,
        defaults.sidebarForeground,
        0.45,
      ),
    );
    if (normalized == scheme) return data;
    return data.copyWith(colors: () => normalized);
  }

  @override
  bool updateShouldNotify(covariant ShadcnTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestor = context.findAncestorWidgetOfExactType<ShadcnTheme>();
    return identical(this, ancestor)
        ? child
        : ShadcnTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ShadcnThemeData>('data', data));
  }
}

/// Animates [ShadcnThemeData] changes implicitly.
class AnimatedShadcnTheme extends ImplicitlyAnimatedWidget {
  const AnimatedShadcnTheme({
    super.key,
    required this.data,
    required super.duration,
    super.curve,
    required this.child,
  });

  /// Target theme data.
  final ShadcnThemeData data;

  /// Widget below this widget in the tree.
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedShadcnTheme> createState() =>
      _AnimatedShadcnThemeState();
}

class _AnimatedShadcnThemeState
    extends AnimatedWidgetBaseState<AnimatedShadcnTheme> {
  ShadcnThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(
              _data,
              widget.data,
              (dynamic value) =>
                  ShadcnThemeDataTween(begin: value as ShadcnThemeData),
            )
            as ShadcnThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(data: _data!.evaluate(animation), child: widget.child);
  }
}

/// Tween for [ShadcnThemeData].
class ShadcnThemeDataTween extends Tween<ShadcnThemeData> {
  ShadcnThemeDataTween({super.begin, super.end});

  @override
  ShadcnThemeData lerp(double t) {
    if (end == null) return begin!;
    return ShadcnThemeData.lerp(begin!, end!, t);
  }
}

/// Base of every `<Name>Theme` component theme class. Carries optional
/// density/spacing/shadow overrides scoped to that component.
abstract class ComponentThemeData {
  const ComponentThemeData({
    this.themeDensity,
    this.themeSpacing,
    this.themeShadows,
  });

  /// Optional density override for this component theme.
  final Density? themeDensity;

  /// Optional spacing override for this component theme.
  final SpacingScale? themeSpacing;

  /// Optional shadow override for this component theme.
  final ShadowScale? themeShadows;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComponentThemeData &&
          runtimeType == other.runtimeType &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode =>
      Object.hash(runtimeType, themeDensity, themeSpacing, themeShadows);
}

/// Tree-scoped component theme. Lookup is tree-only: it never falls back to
/// the app leg (that leg is [ComponentThemes], read separately by
/// [resolveComponentStyle]).
class ComponentTheme<T extends ComponentThemeData> extends InheritedTheme {
  const ComponentTheme({super.key, required this.data, required super.child});

  /// Theme data for type [T] in this subtree.
  final T data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestor = context.findAncestorWidgetOfExactType<ComponentTheme<T>>();
    if (identical(this, ancestor)) return child;
    return ComponentTheme<T>(data: data, child: child);
  }

  /// Nearest tree ancestor data. Throws when absent.
  static T of<T extends ComponentThemeData>(BuildContext context) {
    final data = maybeOf<T>(context);
    assert(data != null, 'No ComponentTheme<$T> found in context');
    return data!;
  }

  /// Nearest tree ancestor data, or null. Never reads [ComponentThemes].
  static T? maybeOf<T extends ComponentThemeData>(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<ComponentTheme<T>>();
    return widget?.data;
  }

  @override
  bool updateShouldNotify(covariant ComponentTheme<T> oldWidget) {
    return oldWidget.data != data;
  }
}

/// App-override leg: user-owned `<name>_theme.dart` values, one entry per
/// installed component, provided once at the app root (the generated
/// `component_themes.dart` exports `const appComponentThemes`, a
/// `List<ComponentThemeData>` passed here by the app widget).
/// A different widget type from [ComponentTheme], so the app leg and the
/// tree-scoped leg stay distinct; read together only by [resolveComponentStyle].
class ComponentThemes extends InheritedWidget {
  const ComponentThemes({
    super.key,
    required this.themes,
    required super.child,
  });

  /// App-override entries, one per component type.
  final List<ComponentThemeData> themes;

  /// Entry of type [T] from the nearest [ComponentThemes], or null.
  static T? maybeOf<T extends ComponentThemeData>(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<ComponentThemes>();
    if (widget == null) return null;
    for (final theme in widget.themes) {
      if (theme is T) return theme;
    }
    return null;
  }

  @override
  bool updateShouldNotify(covariant ComponentThemes oldWidget) {
    if (identical(oldWidget.themes, themes)) return false;
    if (oldWidget.themes.length != themes.length) return true;
    for (var i = 0; i < themes.length; i++) {
      if (oldWidget.themes[i] != themes[i]) return true;
    }
    return false;
  }
}

/// Which theme mode to use.
enum ThemeMode { system, light, dark }

/// Generic four-leg resolver. [select] picks the component's slice out of a
/// theme container; legs merge via [Mergeable.merge] so a higher-priority
/// leg setting only one state never wipes a lower leg's other states.
/// Leg order: defaults < app ([ComponentThemes]) < scoped ([ComponentTheme]
/// in tree) < widget.
S resolveComponentStyle<T extends ComponentThemeData, S extends Mergeable<S>>(
  BuildContext context, {
  S? widget,
  required S? Function(T) select,
  required S defaults,
}) {
  var acc = defaults;
  final app = ComponentThemes.maybeOf<T>(context);
  if (app != null) {
    final slice = select(app);
    if (slice != null) acc = slice.merge(acc);
  }
  final scoped = ComponentTheme.maybeOf<T>(context);
  if (scoped != null) {
    final slice = select(scoped);
    if (slice != null) acc = slice.merge(acc);
  }
  if (widget != null) acc = widget.merge(acc);
  return acc;
}
