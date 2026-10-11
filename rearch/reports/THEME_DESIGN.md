# Theme system design (P1-A)

Status: design only. No implementation. All file paths below are absolute or
relative to `REG = flutter_shadcn_kit/lib/registry`.
Dart snippets are Dart 3.10+ and import only `package:flutter/widgets.dart`.
Facts were read from the code; anything inferred is marked `UNVERIFIED`.

## 0. What exists today (measured)

- Global theme: 27 non-generated Dart files (`shared/theme`, excluding
  `generated/` + `README.md`), `preset_themes.dart` (4,389 LOC, all presets),
  168 generated preset files (`generated/<id>/`, 4 files x 42), 42 preset JSONs
  (`themes_preset/`, `ls | wc -l` = 42).
- Component theme code (PLAN figure): ~370 Dart files / ~33k LOC.
- Button theme files: 18 (1 base barrel + 4 config + 13 variant files).
- Consumption (grep, `REG/components`): `Theme.of(context)` 246 files,
  `ComponentTheme` 267 files, `Styleable` 111 files, `shared/theme` imports
  187 files, `radiusSm|…|borderRadius` 340 files, `Density` 199 files,
  `Typography` 14 files, `AdaptiveScaling` 37 files, `generated_colors` 7 files,
  `SpacingScale|TrackingScale|ShadowScale` 0 files, `IconThemeProperties`
  0 files (reached via `ThemeData.iconTheme`, UNVERIFIED),
  `AnimatedTheme|ThemeDataTween|ThemeData.lerp` 1 file.
- CLI applies a preset by regex-patching the `ColorScheme(` block
  (`theme_css.dart`: `_findBlock` + `_updateBlock` on `lightDefaultColor` /
  `darkDefaultColor`). Studio syncs previews per installed component
  (`studio_manager.dart`: `_generateStudioRegistry`).

## 1. Global tokens

### 1.1 Names

Dart/JSON name = camelCase of the shadcn CSS variable, no renames (PLAN §6.1).
Authoritative key list = the keys of `themes_preset/claude.json`
(`light`/`dark` identical key sets; `tokens.light`/`tokens.dark` identical
key sets — verified by reading the file).

### 1.2 Color tokens (31 keys, light + dark each)

`background`, `foreground`, `card`, `cardForeground`, `popover`,
`popoverForeground`, `primary`, `primaryForeground`, `secondary`,
`secondaryForeground`, `muted`, `mutedForeground`, `accent`,
`accentForeground`, `destructive`, `destructiveForeground`, `border`,
`input`, `ring`, `chart1`, `chart2`, `chart3`, `chart4`, `chart5`, `sidebar`,
`sidebarForeground`, `sidebarPrimary`, `sidebarPrimaryForeground`,
`sidebarAccent`, `sidebarAccentForeground`, `sidebarBorder`, `sidebarRing`.

CSS mapping notes:

| shadcn CSS | Dart/JSON | Notes |
|---|---|---|
| `--background`, `--foreground` | `background`, `foreground` | direct |
| `--card`, `--card-foreground`, `--popover`, `--popover-foreground` | `card`, `cardForeground`, `popover`, `popoverForeground` | direct |
| `--primary`, `--primary-foreground`, `--secondary`, …, `--accent`, `--accent-foreground` | same camelCase | direct |
| `--destructive` | `destructive` | direct |
| `--destructive-foreground` (often absent; `slate.css` has none — verified) | `destructiveForeground` | derived for contrast when absent (see §5.3) |
| `--border`, `--input`, `--ring` | `border`, `input`, `ring` | direct |
| `--chart-1..5` | `chart1..chart5` | direct |
| `--sidebar*` (8 vars) | `sidebar*` (8 keys) | direct; derived from base tokens when absent (see §5.3) |
| `--radius` (rem number, e.g. `0.625rem`) | `radius` (double factor, e.g. `0.5`) | JSON stores the rem number; Dart px = `radius * step` |
| `--font-sans/-serif/-mono` | `fontSans`, `fontSerif`, `fontMono` | nullable strings; absent in 3/42 presets (`caffeine`, `claude`, `t3-chat` — measured), fallback §1.4 |
| `--tracking-normal`, `--spacing` | `tracking.normal`, `spacing.base` | `tracking` gains optional `tight`/`wide` (schema already allows them) |
| `--shadow-2xs..2xl` | `shadows.shadow2xs..shadow2xl` | derived per size, never copied (see §1.5) |

### 1.3 Radius (+ derived steps)

`radius` is a unitless factor. Derived getters (verified in
`_impl/themes/theme_data.dart`):

```dart
import 'package:flutter/widgets.dart';

double radiusXs(double radius) => radius * 4;
double radiusSm(double radius) => radius * 8;
double radiusMd(double radius) => radius * 12;
double radiusLg(double radius) => radius * 16;
double radiusXl(double radius) => radius * 20;
double radiusXxl(double radius) => radius * 24;
```

`claude.json` has `radius: 0.5` both modes, so `radiusMd = 6.0`.
`BorderRadius.circular(radiusMd)` etc. stay as getters on the theme data.

NOTE (P4-M2): radius steps now follow shadcn v4 `globals.css` — `lg = radius * 16` px, `sm = max(0, lg - 4)`, `md = max(0, lg - 2)`, `xl = lg + 4` (only `lg` matched before); `xs`/`xxl` stay on the old linear steps.

### 1.4 Fonts, tracking, spacing

- `fontSans` (body), `fontSerif` (serif option), `fontMono` (code):
  nullable family strings, e.g. `"Inter, sans-serif"` (measured in
  `amber-minimal.json`). Resolution: first family in the comma list becomes
  `TextStyle.fontFamily`; the rest become `fontFamilyFallback`.
  Missing (3 presets) or empty → body falls back to a bundled default
  (`GeistSans`-equivalent constant, owned by `typography.dart`; exact
  bundling is Phase 2 work, UNVERIFIED which asset ships).
- `tracking.normal` (double, `0` in claude) → default `letterSpacing`
  applied to body text styles. `tight`/`wide` optional variants.
- `spacing.base` (double, `3.84` in claude) → `SpacingScale(base)` with
  `xs=base, sm=base*2, md=base*3, lg=base*4, xl=base*6, xxl=base*8`
  (verified in `_impl/core/design_tokens.dart`). Missing → `4.0`
  (today's `ThemeData` default).

### 1.5 Shadows (base values + derived scale, and today's bug)

`claude.json` (and the 5 other presets sampled — all measured) has all 8
shadow sizes byte-identical
(`x: 20.5, y: 16.5, blur: 25.5, spread: -30, color: 0x12000000`).
This confirms the PLAN §2 shadow-derivation bug: the generator copied one
value 8 times. The hardcoded `ThemeData` defaults, by contrast, have a real
progression (`shadowSm` 1–2 layers … `shadow2xl` single deep layer —
verified). New rule:

- JSON keeps explicit per-size lists when they differ (canonical).
- When all 8 entries are identical (or `shadows` absent), the CLI/generator
  derives the scale from one base ambient shadow with fixed per-size
  multipliers (offsets/blur grow `2xs → 2xl`, spread stays negative-large
  per today's shape). Exact multipliers are Phase 2 calibration against
  today's hardcoded defaults (open question §8.1).
- Runtime shape is unchanged: `ShadowScale` with 8 `List<BoxShadow>`
  fields, `copyWith`, `lerp` via `BoxShadow.lerpList`.

### 1.6 New global types (`tokens.dart`)

```dart
import 'package:flutter/widgets.dart';

/// The 31 shadcn color tokens for one brightness. Field order and names
/// match themes_preset/claude.json exactly.
class ShadcnColors {
  const ShadcnColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
    required this.brightness,
  });

  final Brightness brightness;
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;

  /// All tokens are non-nullable, so copyWith takes plain optional values.
  ShadcnColors copyWith({
    Brightness? brightness,
    Color? background,
    Color? foreground,
    // ... one optional parameter per field ...
    Color? sidebarRing,
  }) {
    return ShadcnColors(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      // ... pass-through for every field ...
      sidebarRing: sidebarRing ?? this.sidebarRing,
    );
  }

  static ShadcnColors lerp(ShadcnColors a, ShadcnColors b, double t) {
    Color mix(Color x, Color y) => Color.lerp(x, y, t)!;
    return ShadcnColors(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      background: mix(a.background, b.background),
      foreground: mix(a.foreground, b.foreground),
      // ... Color.lerp for every color field ...
      sidebarRing: mix(a.sidebarRing, b.sidebarRing),
    );
  }
}

/// Non-color tokens for one brightness.
class ShadcnTokens {
  const ShadcnTokens({
    required this.radius,
    required this.spacingBase,
    required this.trackingNormal,
    this.trackingTight,
    this.trackingWide,
    required this.shadows,
    this.fontSans,
    this.fontSerif,
    this.fontMono,
  });

  final double radius;
  final double spacingBase;
  final double trackingNormal;
  final double? trackingTight;
  final double? trackingWide;
  final ShadowScale shadows;
  final String? fontSans;
  final String? fontSerif;
  final String? fontMono;

  SpacingScale get spacing => SpacingScale(spacingBase);
  TrackingScale get tracking => TrackingScale(
        normal: trackingNormal,
        tight: trackingTight,
        wide: trackingWide,
      );

  ShadcnTokens copyWith({
    double? radius,
    double? spacingBase,
    double? trackingNormal,
    double? Function()? trackingTight,
    double? Function()? trackingWide,
    ShadowScale? shadows,
    String? Function()? fontSans,
    String? Function()? fontSerif,
    String? Function()? fontMono,
  }) {
    return ShadcnTokens(
      radius: radius ?? this.radius,
      spacingBase: spacingBase ?? this.spacingBase,
      trackingNormal: trackingNormal ?? this.trackingNormal,
      trackingTight: trackingTight == null ? this.trackingTight : trackingTight(),
      trackingWide: trackingWide == null ? this.trackingWide : trackingWide(),
      shadows: shadows ?? this.shadows,
      fontSans: fontSans == null ? this.fontSans : fontSans(),
      fontSerif: fontSerif == null ? this.fontSerif : fontSerif(),
      fontMono: fontMono == null ? this.fontMono : fontMono(),
    );
  }
}

/// Reference to a global color token. Stored in user-owned theme files so a
/// customised component still follows preset switches; resolved at build.
enum ColorRef {
  background,
  foreground,
  card,
  cardForeground,
  popover,
  popoverForeground,
  primary,
  primaryForeground,
  secondary,
  secondaryForeground,
  muted,
  mutedForeground,
  accent,
  accentForeground,
  destructive,
  destructiveForeground,
  border,
  input,
  ring,
  chart1,
  chart2,
  chart3,
  chart4,
  chart5,
  sidebar,
  sidebarForeground,
  sidebarPrimary,
  sidebarPrimaryForeground,
  sidebarAccent,
  sidebarAccentForeground,
  sidebarBorder,
  sidebarRing;

  Color resolve(ShadcnColors colors) {
    switch (this) {
      case ColorRef.background:
        return colors.background;
      case ColorRef.foreground:
        return colors.foreground;
      // ... one arm per token ...
      case ColorRef.sidebarRing:
        return colors.sidebarRing;
    }
  }
}

/// A color that is either a literal or a token reference.
/// Const-constructible so user-owned files stay values-only and Studio can
/// rewrite them deterministically. Alpha is data: an explicit opacity in
/// 0..1 applied on top of the resolved color (absolute, not multiplicative).
sealed class ThemedColor {
  const ThemedColor();
  const factory ThemedColor.value(Color color) = LiteralColor;
  const factory ThemedColor.ref(ColorRef ref, {double alpha = 1.0}) =
      RefColor;

  Color resolve(ShadcnColors colors);
}

final class LiteralColor extends ThemedColor {
  const LiteralColor(this.color);
  final Color color;
  @override
  Color resolve(ShadcnColors colors) => color;
}

final class RefColor extends ThemedColor {
  const RefColor(this.ref, {this.alpha = 1.0});
  final ColorRef ref;
  final double alpha;
  @override
  Color resolve(ShadcnColors colors) {
    final base = ref.resolve(colors);
    if (alpha == 1.0) return base;
    // Multiply, never replace: tokens may carry their own alpha (QA fix).
    return base.withValues(alpha: base.a * alpha);
  }
}

/// Const per-state value. Implements WidgetStateProperty so it plugs
/// directly into Flutter state APIs, but carries only data (nullable per
/// state) — no closures — so user-owned files stay `const` and Studio can
/// read and rewrite every state cell.
class StateValue<T> implements WidgetStateProperty<T?> {
  const StateValue({
    this.rest,
    this.hovered,
    this.pressed,
    this.focused,
    this.selected,
    this.disabled,
  });

  final T? rest;
  final T? hovered;
  final T? pressed;
  final T? focused;
  final T? selected;
  final T? disabled;

  /// Precedence: disabled > pressed > hovered > focused > selected > rest.
  /// Each state falls back to [rest] (never to another state).
  @override
  T? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) return disabled ?? rest;
    if (states.contains(WidgetState.pressed)) return pressed ?? rest;
    if (states.contains(WidgetState.hovered)) return hovered ?? rest;
    if (states.contains(WidgetState.focused)) return focused ?? rest;
    if (states.contains(WidgetState.selected)) return selected ?? rest;
    return rest;
  }

  /// Per-state first-non-null-wins: each state field keeps `this` value
  /// unless null, then takes `other`. Enables per-state (not
  /// whole-property) merge across resolution legs.
  StateValue<T> merge(StateValue<T>? other) {
    if (other == null) return this;
    return StateValue<T>(
      rest: rest ?? other.rest,
      hovered: hovered ?? other.hovered,
      pressed: pressed ?? other.pressed,
      focused: focused ?? other.focused,
      selected: selected ?? other.selected,
      disabled: disabled ?? other.disabled,
    );
  }
}
```

`ThemeRef.primary`-style access from the brief is `ColorRef.primary`
(plus `ThemedColor.ref(ColorRef.primary)` where a const union is needed).

## 2. `shared/theme` collapses to 5 files

### 2.1 Disposition of all 27 files

Counts: top-level 8 + `_impl/core` 9 + `_impl/themes` 9 + `schema` 1 = 27
(`generated/` and `README.md` excluded per brief).

| # | File today | Target | Why / consumer reliance |
|---|---|---|---|
| 1 | `theme/app_theme.dart` (52 LOC) | `theme.dart` (fold `AppTheme.light/dark` builders in) | tiny; only references preset singletons |
| 2 | `theme/app_theme_preset.dart` (12 LOC) | DELETED | replaced by generated `app_theme.dart` in the user app (§5); `InstalledThemePreset.current` has no component consumers (only `AppTheme`) |
| 3 | `theme/color_scheme.dart` (barrel + `_fromAHSL`) | `tokens.dart` (merge `ColorScheme`→`ShadcnColors`; move `_fromAHSL` to `color_utils.dart`) | 187 component files import theme barrels; `ColorScheme.of` used alongside `Theme.of` (142 files use `colorScheme.`) — keep a deprecated alias one release (see §7) |
| 4 | `theme/component_theme_global_registry.dart` (23 LOC) | `theme.dart` (moved as-is, plus `ComponentThemes.app<T>()` accessor) | app-overrides leg read by the generic resolver; 267 files reference `ComponentTheme` |
| 5 | `theme/generated_colors.dart` (379 LOC, `Colors` + palettes) | `color_utils.dart` (move, keep names) | only 7 component files import it; `Colors.white` hardcoded in destructive text style (see §3.3 — replace with token) |
| 6 | `theme/preset_themes.dart` (4,389 LOC) | DELETED | presets stay JSON-only; CLI generates one `app_theme.dart` (§5) |
| 7 | `theme/theme.dart` (barrel + parts) | `theme.dart` (no `part`/`part of`; plain imports) | every themed component imports this barrel |
| 8 | `theme/typography.dart` (544 LOC) | `typography.dart` (keep; wire `fontSans/Mono` + `tracking` in) | 14 direct + every `theme.typography.*` call site; also drop the `Gap` import (PLAN: replace `gap` with local code — `theme.dart` currently imports `package:gap/gap.dart`) |
| 9 | `_impl/core/adaptive_scaler.dart` (54 LOC) | `density.dart` (merge) | widget applying `AdaptiveScaling`; 37 files mention adaptive |
| 10 | `_impl/core/adaptive_scaling.dart` (87 LOC) | `density.dart` (merge `AdaptiveScaling` + `scale()`) | see §6 for kept behaviour |
| 11 | `_impl/core/chart_color_scheme.dart` (37 LOC) | `tokens.dart` (merge: `chartColors` getter on `ShadcnColors`) | small interface; check `implements` users in Phase 1 audit (UNVERIFIED count) |
| 12 | `_impl/core/color_scheme.dart` (671 LOC) | `tokens.dart` (`ShadcnColors` + `copyWith`/`lerp`) | heaviest reliance: 246 `Theme.of` + 142 `colorScheme.` files; `destructiveForeground` is `@Deprecated('Legacy color')` — keep field, un-deprecate or re-decide in Phase 1 (flag §8.5) |
| 13 | `_impl/core/color_schemes.dart` (78 LOC) | DELETED (defaults become the generated `app_theme.dart` + one `ShadcnColors.fallback` const for tests) | `lightDefaultColor`/`darkDefaultColor` are the regex-patch targets; CLI-tested fallback only |
| 14 | `_impl/core/color_shades.dart` (411 LOC) | `color_utils.dart` (`ColorShades`, `fromAccent` HSL generation) | 0 direct component references by class name (reached via `Colors.*` palettes); keep public names |
| 15 | `_impl/core/density.dart` (520 LOC) | `density.dart` (keep `Density`, `fromSpacingScale`, pad/gap multipliers, `EdgeInsetsDensity` helpers) | 199 files reference `Density`; `Density.fromSpacingScale` bridges preset spacing → density |
| 16 | `_impl/core/design_tokens.dart` (199 LOC) | `tokens.dart` (`SpacingScale`, `TrackingScale`, `ShadowScale`) | 0 direct class-name references; always reached via `ThemeData` — safe to move |
| 17 | `_impl/core/single_chart_color_scheme.dart` (40 LOC) | `tokens.dart` (merge) | same as #11 |
| 18 | `_impl/themes/__animated_theme_state.dart` (33 LOC) | `theme.dart` (merge into `AnimatedTheme` file section) | 1 consumer file; behaviour kept (§6) |
| 19 | `_impl/themes/animated_theme.dart` (31 LOC) | `theme.dart` (keep `AnimatedTheme`) | kept behaviour (§6) |
| 20 | `_impl/themes/component_theme.dart` (78 LOC) | `theme.dart` (keep `ComponentTheme<T>`, `ThemeMode`; `maybeOf` becomes tree-only; add generic `resolveComponentStyle`) | 267 files; resolution order changes only in *what the component does after lookup* (§3.5), not in this class's tree lookup |
| 21 | `_impl/themes/component_theme_data.dart` (35 LOC) | `theme.dart` (keep `ComponentThemeData` + `themeDensity/Spacing/Shadows` overrides) | base of every `*Theme` class |
| 22 | `_impl/themes/icon_theme_properties.dart` (208 LOC) | `typography.dart` (merge; it is type-scale, driven by `textScaling`) | 0 direct references; reached via `theme.iconTheme` + `AdaptiveScaling.scale` |
| 23 | `_impl/themes/styleable.dart` (23 LOC) | `theme.dart` (keep `Styleable<T>` + contract comment) | 111 files `implements Styleable`; semantics change flagged in §3.5 |
| 24 | `_impl/themes/theme.dart` (80 LOC) | `theme.dart` (rename `Theme`→`ShadcnTheme`; keep `_ensureReadableDarkTheme` behaviour, §6) | 246 files call `Theme.of`; rename needs a one-release alias (see §7) |
| 25 | `_impl/themes/theme_data.dart` (505 LOC) | `theme.dart` (`ShadcnThemeData`: colors, tokens, radius getters, scaling, typography, iconTheme, surface/… flags, `copyWith`, `lerp`) | the hub; `surfaceOpacity/surfaceBlur/enableFeedback/platform` kept as-is (UNVERIFIED which components read them — Phase 1 grep) |
| 26 | `_impl/themes/theme_data_tween.dart` (24 LOC) | `theme.dart` (keep `ThemeDataTween`→`ShadcnThemeDataTween`) | kept behaviour (§6) |
| 27 | `theme/schema/component_schema.dart` (738 LOC) | DELETED as hand-written model; replaced by `tool/gen_theme_schema.dart` output (meta.json `theme` sections). Small runtime model only if Studio needs it — decision: none (Studio reads JSON; §4) | imported by generated `*_theme_schema.dart` files (button + badge verified); the meta.json manifests that embed it are regenerated |

New `shared/theme` (registry side) is 5 files: `tokens.dart`, `theme.dart`,
`typography.dart`, `density.dart`, `color_utils.dart`. `no part of`, no
`ignore_for_file`, no Material/Cupertino imports.

## 3. Component theme pattern (shown for Button)

### 3.1 Today's button variants — full inventory (13 theme classes)

`_impl/themes/variants/`: base + 12 concrete classes, each 44 LOC and
structurally identical (verified: `primary` and `ghost` read fully, md5s
differ only by class name). All 12 carry the same 6 delegate fields from
`ButtonTheme` base (73 LOC): `decoration`, `mouseCursor`, `padding`,
`textStyle`, `iconTheme`, `margin`.

| Theme class | Style functions it binds (verified in `button_helpers.dart`) | Verdict |
|---|---|---|
| `PrimaryButtonTheme` | primary bg (`primary`, hover 0.8, disabled `mutedForeground`), `primaryForeground` text/icons | KEEP — shadcn default |
| `SecondaryButtonTheme` | secondary bg, `secondaryForeground` text | KEEP |
| `OutlineButtonTheme` | transparent bg + `border` outline | KEEP |
| `GhostButtonTheme` | transparent, hover accent (UNVERIFIED — inferred from family; ghost helpers not re-read) | KEEP |
| `LinkButtonTheme` | transparent, foreground text, underline on hover (verified) | KEEP |
| `DestructiveButtonTheme` | `destructive` bg @0.5 (hover 0.8), hardcoded `Colors.white` text (verified — must become `destructiveForeground` token, §1.2) | KEEP |
| `TextButtonTheme` | transparent, `mutedForeground`→`primary` on hover, no underline (verified) | COLLAPSE into `ghost` family: keep a `text` **data row** (§3.3) only if gallery review shows a visible delta vs ghost; default is a `@Deprecated` alias row pointing at `ghost`. Distinct delta today: hover changes fg, no bg wash. |
| `MutedButtonTheme` | `buttonTextDecoration` + muted text style (verified in tokens file) | COLLAPSE into `text` row (same transparent shape; fg differs only in resting color — one row with resting-fg data, or alias to `text`) |
| `FixedButtonTheme` | `buttonTextDecoration` + static text style | DELETE — internal static style for toggle machinery; move the const into the toggle file (UNVERIFIED all call sites — Phase 1 grep `FixedButtonTheme\|ButtonStyle.fixed`) |
| `MenuButtonTheme` / `MenubarButtonTheme` | transparent resting; `accent` wash + `radiusSm` on hovered/focused/selected, `accentForeground` text (verified lines 84-115); menubar differs only in padding (`buttonMenuPadding` vs `buttonMenubarPadding`) | MOVE out of button: menu-item styling belongs to the menu component. Button keeps no menu rows. Menubar vs menu differ by padding only — one row with a padding parameter at the new owner. |
| `CardButtonTheme` | card bg + `border` outline + `radiusXl`, `cardForeground` text (verified lines 50-82) | MOVE out of button: card-surface styling belongs to the card component. |
| `GhostButtonTheme` (correction) | transparent resting (`muted` at alpha 0), hover `muted` wash at 0.8, `foreground` text / `mutedForeground` when disabled (verified lines 302-345) — **not** accent wash | KEEP. Correction: earlier draft said "hover accent" UNVERIFIED; now verified as `muted` wash. Text-vs-ghost delta stands (text changes fg on hover with no bg wash; ghost adds bg wash with constant fg). |

Widget-side inventory (verified): `ButtonStyle` has named consts
`primary, secondary, outline, ghost, link, text, destructive, fixed, menu,
menubar, muted` + `*Icon` consts + `card`; `ButtonVariance` is the same shape
(`button_variance_class.dart`). Wrapper widgets today: `PrimaryButton`,
`SecondaryButton`, `OutlineButton`, `GhostButton`, `LinkButton`,
`TextButton`, `DestructiveButton`, `CardButton`, `TabButton`, `IconButton`,
`Toggle`, `SelectedButton`, `ButtonGroup` (from `meta.json` api section).

Net: `ButtonVariant` enum = `primary, secondary, outline, ghost, link,
text, destructive` (7 data rows). `muted` collapses into `text`;
`fixed/menu/menubar/card` move to their owner components; all removed names
survive one release as `@Deprecated` one-line aliases (PLAN §3).

### 3.2 `button_style.dart` (registry-owned logic)

One file replaces today's 15 `_impl/styles/` files for theming purposes
(`ButtonSize/Density/Shape` stay as widget-API enums where they are; only
the theme layer collapses here).

```dart
import 'package:flutter/widgets.dart';

/// The 7 surviving button variants (§3.1).
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  link,
  text,
  destructive,
}

/// Per-variant style. Every field is nullable: null means "fall through to
/// the next resolution leg" (§3.5). State-dependent values use the const
/// data class StateValue (§1.6) — never closures — so every layer including
/// user files stays const-constructible.
class ButtonVariantStyle {
  const ButtonVariantStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.textStyle,
    this.decoration,
  });

  /// Background per state. Null (not transparent) = fall through.
  final StateValue<ThemedColor>? background;

  /// Text and icon color per state.
  final StateValue<ThemedColor>? foreground;

  /// Outline color per state. Null = no outline.
  final StateValue<ThemedColor>? borderColor;

  /// Outline width in logical px. Null = 1.0 when borderColor != null.
  final double? borderWidth;

  /// Content padding. Null = density-derived default.
  final EdgeInsetsGeometry? padding;

  /// Base text style (size/weight family). Color comes from [foreground].
  final TextStyle? textStyle;

  /// Text decoration per state (link underlines on hover). Null = none.
  final StateValue<TextDecoration>? decoration;

  ButtonVariantStyle copyWith({
    StateValue<ThemedColor>? Function()? background,
    StateValue<ThemedColor>? Function()? foreground,
    StateValue<ThemedColor>? Function()? borderColor,
    double? Function()? borderWidth,
    EdgeInsetsGeometry? Function()? padding,
    TextStyle? Function()? textStyle,
    StateValue<TextDecoration>? Function()? decoration,
  }) {
    return ButtonVariantStyle(
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      padding: padding == null ? this.padding : padding(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
      decoration: decoration == null ? this.decoration : decoration(),
    );
  }

  /// Merge is per state field, not per property: StateValue legs merge
  /// state-by-state (first non-null wins per state); scalar fields are
  /// first-non-null-wins. A higher-priority leg that sets only `hovered`
  /// no longer wipes the lower leg's `rest`.
  ButtonVariantStyle merge(ButtonVariantStyle? other) {
    if (other == null) return this;
    return ButtonVariantStyle(
      background: _mergeState(background, other.background),
      foreground: _mergeState(foreground, other.foreground),
      borderColor: _mergeState(borderColor, other.borderColor),
      borderWidth: borderWidth ?? other.borderWidth,
      padding: padding ?? other.padding,
      textStyle: textStyle ?? other.textStyle,
      decoration: _mergeState(decoration, other.decoration),
    );
  }
}

StateValue<T>? _mergeState<T>(StateValue<T>? base, StateValue<T>? override) {
  if (base == null) return override;
  if (override == null) return base;
  return base.merge(override);
}
```
```dart
/// Sparse per-variant overrides for one scope. Missing variant = fall
/// through to the next resolution leg.
class ButtonTheme extends ComponentThemeData {
  const ButtonTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.primary,
    this.secondary,
    this.outline,
    this.ghost,
    this.link,
    this.text,
    this.destructive,
  });

  final ButtonVariantStyle? primary;
  final ButtonVariantStyle? secondary;
  final ButtonVariantStyle? outline;
  final ButtonVariantStyle? ghost;
  final ButtonVariantStyle? link;
  final ButtonVariantStyle? text;
  final ButtonVariantStyle? destructive;

  ButtonVariantStyle? forVariant(ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return primary;
      case ButtonVariant.secondary:
        return secondary;
      case ButtonVariant.outline:
        return outline;
      case ButtonVariant.ghost:
        return ghost;
      case ButtonVariant.link:
        return link;
      case ButtonVariant.text:
        return text;
      case ButtonVariant.destructive:
        return destructive;
    }
  }

  ButtonTheme copyWith({
    ValueGetter<ButtonVariantStyle?>? primary,
    ValueGetter<ButtonVariantStyle?>? secondary,
    ValueGetter<ButtonVariantStyle?>? outline,
    ValueGetter<ButtonVariantStyle?>? ghost,
    ValueGetter<ButtonVariantStyle?>? link,
    ValueGetter<ButtonVariantStyle?>? text,
    ValueGetter<ButtonVariantStyle?>? destructive,
  }) {
    return ButtonTheme(
      primary: primary == null ? this.primary : primary(),
      secondary: secondary == null ? this.secondary : secondary(),
      outline: outline == null ? this.outline : outline(),
      ghost: ghost == null ? this.ghost : ghost(),
      link: link == null ? this.link : link(),
      text: text == null ? this.text : text(),
      destructive: destructive == null ? this.destructive : destructive(),
    );
  }

  /// Field-wise lerp. State properties step at t = 0.5 (they are
  /// discrete per-state values); scalar/style fields interpolate. Full
  /// light/dark animation still flows through ShadcnThemeData.lerp (§6):
  /// this lerp only covers explicit two-theme tweens.
  static ButtonTheme lerp(ButtonTheme a, ButtonTheme b, double t) {
    ButtonVariantStyle? mix(ButtonVariantStyle? x, ButtonVariantStyle? y) {
      if (x == null) return y;
      if (y == null) return x;
      return ButtonVariantStyle(
        background: t < 0.5 ? x.background : y.background,
        foreground: t < 0.5 ? x.foreground : y.foreground,
        borderColor: t < 0.5 ? x.borderColor : y.borderColor,
        borderWidth: _mixDouble(x.borderWidth, y.borderWidth, t),
        padding: _mixInsets(x.padding, y.padding, t),
        textStyle: _mixText(x.textStyle, y.textStyle, t),
        decoration: t < 0.5 ? x.decoration : y.decoration,
      );
    }
    return ButtonTheme(
      primary: mix(a.primary, b.primary),
      secondary: mix(a.secondary, b.secondary),
      outline: mix(a.outline, b.outline),
      ghost: mix(a.ghost, b.ghost),
      link: mix(a.link, b.link),
      text: mix(a.text, b.text),
      destructive: mix(a.destructive, b.destructive),
    );
  }
}

double? _mixDouble(double? a, double? b, double t) {
  if (a == null) return b;
  if (b == null) return a;
  return a + (b - a) * t;
}

EdgeInsetsGeometry? _mixInsets(
  EdgeInsetsGeometry? a,
  EdgeInsetsGeometry? b,
  double t,
) {
  if (a == null) return b;
  if (b == null) return a;
  return EdgeInsetsGeometry.lerp(a, b, t);
}

TextStyle? _mixText(TextStyle? a, TextStyle? b, double t) {
  if (a == null) return b;
  if (b == null) return a;
  return TextStyle.lerp(a, b, t);
}
```

### 3.3 Variant defaults (exhaustive, const, refs with alpha)

Defaults are a single `const ButtonTheme` built only from
`ThemedColor.ref(...)` (alpha included as data) — no `colors` parameter,
no closures — so Studio can render the default editor state directly.
Values verified against `button_helpers.dart`. Shared base text style
(`small.merge(medium)` today) is the const
`buttonDefaultTextStyle = TextStyle(fontSize: 14, fontWeight:
FontWeight.w500)`; shared density padding is null (resolver substitutes
the density default).

| variant | background StateValue | foreground StateValue | border | decoration |
|---|---|---|---|---|
| primary | rest ref primary, hovered ref primary alpha 0.8, disabled ref mutedForeground | rest ref primaryForeground, disabled ref mutedForeground | none | none |
| secondary | rest ref secondary, hovered ref secondary alpha 0.8, disabled ref primaryForeground | rest ref secondaryForeground, disabled ref mutedForeground | none | none |
| outline | rest ref input alpha 0.3, hovered ref input alpha 0.5, disabled transparent (ref input alpha 0) | rest ref foreground, disabled ref mutedForeground | ref input, 1.0 | none |
| ghost | rest ref muted alpha 0, hovered ref muted alpha 0.8, disabled ref muted alpha 0 | rest ref foreground, disabled ref mutedForeground | none | none |
| link | rest null (transparent all states) | rest ref foreground, disabled ref mutedForeground | none | hovered underline, rest none |
| text | rest null (transparent all states) | rest ref mutedForeground, hovered ref primary, disabled ref mutedForeground | none | none |
| destructive | rest ref destructive alpha 0.5, hovered ref destructive alpha 0.8, disabled ref primaryForeground | rest ref destructiveForeground, disabled ref mutedForeground | none | none |

No resolver-side alpha mechanism exists: what the table says is what the
const holds. (`scaleAlpha(0.8)` / `withValues(alpha: 0)` call sites in
today's helpers map 1:1 onto the alpha values above.)

```dart
import 'package:flutter/widgets.dart';

/// Base text style shared by all variants (today: small.merge(medium)).
const TextStyle buttonDefaultTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

/// Token defaults for every variant. Const, refs only.
const ButtonTheme buttonDefaults = ButtonTheme(
  primary: ButtonVariantStyle(
    background: StateValue(
      rest: ThemedColor.ref(ColorRef.primary),
      hovered: ThemedColor.ref(ColorRef.primary, alpha: 0.8),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.primaryForeground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    textStyle: buttonDefaultTextStyle,
  ),
  secondary: ButtonVariantStyle(
    background: StateValue(
      rest: ThemedColor.ref(ColorRef.secondary),
      hovered: ThemedColor.ref(ColorRef.secondary, alpha: 0.8),
      disabled: ThemedColor.ref(ColorRef.primaryForeground),
    ),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.secondaryForeground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    textStyle: buttonDefaultTextStyle,
  ),
  outline: ButtonVariantStyle(
    background: StateValue(
      rest: ThemedColor.ref(ColorRef.input, alpha: 0.3),
      hovered: ThemedColor.ref(ColorRef.input, alpha: 0.5),
      disabled: ThemedColor.ref(ColorRef.input, alpha: 0),
    ),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.foreground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    borderColor: StateValue(rest: ThemedColor.ref(ColorRef.input)),
    borderWidth: 1,
    textStyle: buttonDefaultTextStyle,
  ),
  ghost: ButtonVariantStyle(
    background: StateValue(
      rest: ThemedColor.ref(ColorRef.muted, alpha: 0),
      hovered: ThemedColor.ref(ColorRef.muted, alpha: 0.8),
      disabled: ThemedColor.ref(ColorRef.muted, alpha: 0),
    ),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.foreground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    textStyle: buttonDefaultTextStyle,
  ),
  link: ButtonVariantStyle(
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.foreground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    textStyle: buttonDefaultTextStyle,
    decoration: StateValue(hovered: TextDecoration.underline),
  ),
  text: ButtonVariantStyle(
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.mutedForeground),
      hovered: ThemedColor.ref(ColorRef.primary),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    textStyle: buttonDefaultTextStyle,
  ),
  destructive: ButtonVariantStyle(
    background: StateValue(
      rest: ThemedColor.ref(ColorRef.destructive, alpha: 0.5),
      hovered: ThemedColor.ref(ColorRef.destructive, alpha: 0.8),
      disabled: ThemedColor.ref(ColorRef.primaryForeground),
    ),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.destructiveForeground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
    textStyle: buttonDefaultTextStyle,
  ),
);
```

### 3.4 `button_theme.dart` (USER-OWNED, values only)

Complete example. Token references (`ThemedColor.ref`) follow preset
switches; literals (`ThemedColor.value`) do not. CLI updates never
overwrite this file; Studio rewrites it deterministically (sorted fields,
`dart format` clean).

```dart
import 'package:flutter/widgets.dart';

// Registry-owned logic (button_style.dart). This import is stable across
// CLI updates; the file below is never overwritten by the CLI.
import 'button_style.dart';

/// App overrides for Button. Sparse: any null variant/field falls through
/// to token defaults (§3.5).
const ButtonTheme buttonThemeOverrides = ButtonTheme(
  primary: ButtonVariantStyle(
    background: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.primaryForeground),
    ),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  destructive: ButtonVariantStyle(
    // Literal: stays this red even when the preset changes.
    background: StateValue(
      rest: ThemedColor.value(Color(0xFFE7000B)),
    ),
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.destructiveForeground),
    ),
  ),
  link: ButtonVariantStyle(
    foreground: StateValue(
      rest: ThemedColor.ref(ColorRef.foreground),
      disabled: ThemedColor.ref(ColorRef.mutedForeground),
    ),
  ),
);
```

Rules for this file (enforced by `tool/check_user_theme.dart`, Phase 2):
only `const` constructors, `ThemedColor`, `StateValue`, `EdgeInsets`,
`TextStyle`, `Color` literals. Banned: `resolveWith`, any other closure,
any function of `BuildContext` (resolution happens in
§3.5, so overrides stay preset-relative). Anything else fails
`tool/check_user_theme.dart` (Phase 2).

### 3.5 Resolution order + generic resolver

Order per property (PLAN §6.3):
widget arg > nearest `ComponentTheme<ButtonTheme>` (tree only) > app
overrides (`button_theme.dart` via registry) > token defaults
(`buttonDefaults`).

The two middle legs must be distinct sources. Today
`ComponentTheme.maybeOf` falls back to the global registry, so a tree
lookup can silently return the app overrides (double apply) and the app
leg is skipped whenever an ancestor exists. Redesign (in `theme.dart`,
used by every component):

- `ComponentTheme.maybeOf<T>(context)` = tree only, no registry fallback.
- `ComponentThemes.app<T>()` = registry leg (what the generated
  `component_themes.dart` feeds, §3.6).
- One generic resolver merges the four legs per component-selected slice:

```dart
import 'package:flutter/widgets.dart';

/// Generic four-leg resolver. [select] picks the component's slice out of
/// a theme container (e.g. one ButtonVariantStyle out of ButtonTheme);
/// [merge] is the slice's own per-state merge. Leg order: defaults <
/// app (registry) < scoped (tree) < widget.
S resolveComponentStyle<T extends ComponentThemeData, S>(
  BuildContext context, {
  S? widget,
  required S? Function(T) select,
  required S defaults,
  required S Function(S base, S? override) merge,
}) {
  var acc = defaults;
  final app = ComponentThemes.app<T>();
  if (app != null) {
    final slice = select(app);
    if (slice != null) acc = merge(acc, slice);
  }
  final scoped = ComponentTheme.maybeOf<T>(context);
  if (scoped != null) {
    final slice = select(scoped);
    if (slice != null) acc = merge(acc, slice);
  }
  if (widget != null) acc = merge(acc, widget);
  return acc;
}
```

Button call site (~5 lines at the widget's build):

```dart
final style = resolveComponentStyle<ButtonTheme, ButtonVariantStyle>(
  context,
  widget: widget.theme,
  select: (t) => t.forVariant(variant),
  defaults: buttonDefaults.forVariant(variant)!,
  // Override wins: StateValue.merge keeps `this` first, so call it on the
  // override (QA fix — base.merge(override) would let defaults always win).
  merge: (base, override) => override?.merge(base) ?? base,
);
```

Behaviour changes (explicit, both vs today): (1) merge is per state
field, not whole-property replace — a widget-level style setting only
`hovered` no longer wipes the ancestor's `rest` (PLAN's "for every
property" semantic; old `Styleable` replace semantics verified in
`badge_widgets.dart` are retired); (2) `maybeOf` no longer falls back to
the registry, so existing direct `maybeOf` callers that relied on the
fallback (badge verified) must migrate to `resolveComponentStyle` or add
an explicit `ComponentThemes.app<T>()` leg — Phase 4 rewrites every
`maybeOf` call site (grep-gated). Mitigation for both: resolver unit
tests for every precedence combination + one gallery case with stacked
widget/ancestor/app overrides.

### 3.6 `component_themes.dart` (generated in the user app)

Replaces `component_theme_global_configs.dart` (145 imports). Generated by
the CLI from the lockfile: one registration per installed component that
ships a `<name>_theme.dart`. Exact shape:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: .shadcn/lock.json (installed components: button, badge).
// Regenerate: flutter_shadcn sync.

import 'package:flutter/widgets.dart';
import 'ui/shadcn/components/button/button_style.dart';
import 'ui/shadcn/components/badge/badge_style.dart';
import 'ui/shadcn/components/button/button_theme.dart' as button_theme;
import 'ui/shadcn/components/badge/badge_theme.dart' as badge_theme;
import 'ui/shadcn/theme/theme.dart';

/// Registers app overrides (user-owned *_theme.dart files) as the
/// registry leg read by ComponentThemes.app<T>(). Tree-scoped
/// ComponentTheme widgets are a separate leg and take precedence (§3.5).
void registerComponentThemes() {
  ComponentThemeGlobalRegistry.register<ButtonTheme>(
    () => button_theme.buttonThemeOverrides,
  );
  ComponentThemeGlobalRegistry.register<BadgeTheme>(
    () => badge_theme.badgeThemeOverrides,
  );
}
```

Uninstalled components register nothing; installing a component appends one
import + one registration. No 145-import barrel ever ships to the app.

## 4. Editor schema

### 4.1 `theme` section inside `meta.json` (Button example)

One `meta.json` per component holds install deps, docs metadata, and the
generated `theme` editor-schema section (replaces `theme.schema.json` +
`*.meta.json` + hand `meta.json` trio). `theme` is generated; everything
else is hand-written. Truncated to two variants for brevity — the real
section repeats the same field shape per variant:

```json
{
  "id": "button",
  "name": "Button",
  "category": "control",
  "theme": {
    "schemaVersion": 1,
    "variants": ["primary", "secondary", "outline", "ghost", "link", "text", "destructive"],
    "groups": [
      {
        "title": "Primary / Background",
        "variant": "primary",
        "fields": [
          {
            "type": "color",
            "name": "background",
            "label": "Background",
            "states": true,
            "tokenBinding": { "family": "colors" },
            "defaultValue": { "ref": "primary" }
          },
          {
            "type": "color",
            "name": "foreground",
            "label": "Foreground",
            "states": true,
            "tokenBinding": { "family": "colors" },
            "defaultValue": { "ref": "primaryForeground" }
          }
        ]
      },
      {
        "title": "Primary / Dimensions",
        "variant": "primary",
        "fields": [
          {
            "type": "padding",
            "name": "padding",
            "label": "Padding",
            "defaultValue": null
          },
          {
            "type": "number",
            "name": "borderWidth",
            "label": "Border width",
            "validation": { "min": 0, "max": 8, "step": 0.5, "unit": "px" },
            "defaultValue": null
          }
        ]
      }
    ]
  }
}
```

Conventions: `defaultValue` is `{ "ref": "<ColorRef>" }`, `{ "value": … }`,
or null (null = token default, falls through). `states: true` renders the
resting/hovered/focused/pressed/disabled matrix.

### 4.2 `tool/gen_theme_schema.dart` (derives §4.1 from `*_style.dart`)

Parses with `package:analyzer` (`parseString`, unresolved AST — already a
dev dependency, ^6.4.1; no regex per repo rules). Input: the component's
`<name>_style.dart`. It finds `<Name>Theme` (the `ComponentThemeData`
subclass with per-variant fields) and `<Name>VariantStyle`, then maps each
field type to an editor control:

| Dart field type | Editor control | Notes |
|---|---|---|
| `StateValue<ThemedColor>` | `color` + state matrix | `tokenBinding.family = colors`; default = the StateValue in `buttonDefaults` (ref + alpha per state); matrix cells edit ref-or-literal + alpha |
| `StateValue<TextDecoration>` | `select` + state matrix | options: none/underline/lineThrough |
| `double` | `slider` | range from `@EditorRange` annotation or default 0..64; `borderWidth` 0..8 |
| `int` | `stepper` | |
| `bool` | `switch` | |
| `String` | `input` | |
| enum (e.g. `ButtonVariant`) | `select` / `segmented` | options from enum values; variants list itself is **not** a field — derived from `forVariant` switch cases (exhaustiveness checked) |
| `TextStyle` | `textStyle` | family/size/weight sub-controls; color sub-control bound to sibling foreground |
| `EdgeInsetsGeometry` | `padding` | symmetric/horizontal/vertical/all presets |
| `Duration` | `duration` (ms) | |
| `List<BoxShadow>` | `shadowList` | tokenBinding to `shadows` scale |
| anything else | `object` + generator warning | fails CI only if the field is non-nullable without default (strict mode) |

Nullable field → `"required": false`, non-nullable → required with the
constructor's default. `copyWith`/`merge`/`lerp`/`forVariant` members are
skipped (name blocklist). Output: the `theme` section rewritten in place
in `meta.json` (keys sorted, 2-space JSON), leaving hand-written sections
untouched.

Runtime model decision: **no** Dart schema model ships. Studio reads
`meta.json` JSON directly. `schema/component_schema.dart` (738 LOC) and all
`*_theme_schema.dart` files are deleted (§2, row 27).

## 5. Presets

### 5.1 JSON stays canonical

All 42 `themes_preset/*.json` files are kept and re-validated against
`manifests/themes.schema.json`. `preset_themes.dart` (4,389 LOC) and all
168 `generated/<id>/` files are deleted; nothing in the registry imports a
preset at runtime.

### 5.2 Generated `app_theme.dart` (values-only, one preset)

The CLI writes this file into the user app for the chosen preset only
(`lib/ui/shadcn/theme/app_theme.dart`). Full rewrite on preset switch —
no regex patching. Exact shape (one brightness shown; the other is
identical in shape; `// …` marks elided per-token lines):

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: themes_preset/claude.json (id: claude).
// Regenerate: flutter_shadcn theme use <id>.
import 'package:flutter/widgets.dart';

/// Token values for the claude preset, light brightness.
const ShadcnColors claudeLightColors = ShadcnColors(
  brightness: Brightness.light,
  background: Color(0xFFFAF9F5),
  foreground: Color(0xFF3D3929),
  // ... one line per token, 31 total, order = §1.2 ...
  sidebarRing: Color(0xFFB5B5B5),
);

/// Token values for the claude preset, dark brightness.
const ShadcnColors claudeDarkColors = ShadcnColors(
  brightness: Brightness.dark,
  background: Color(0xFF262624),
  // ... 31 lines ...
  sidebarRing: Color(0xFFB5B5B5),
);

/// Non-color tokens, light.
const ShadcnTokens claudeLightTokens = ShadcnTokens(
  radius: 0.5,
  spacingBase: 3.84,
  trackingNormal: 0,
  shadows: ShadowScale(
    shadow2xs: [BoxShadow(offset: Offset(1, 1), blurRadius: 2)],
    // ... one entry per size, 8 total (derived, §1.5) ...
    shadow2xl: [BoxShadow(offset: Offset(0, 25), blurRadius: 50)],
  ),
);

/// Non-color tokens, dark.
const ShadcnTokens claudeDarkTokens = ShadcnTokens(
  radius: 0.5,
  spacingBase: 3.84,
  trackingNormal: 0,
  shadows: ShadowScale(
    // ... 8 entries ...
  ),
);

/// Builds the ambient theme for one brightness.
ShadcnThemeData buildClaudeTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ShadcnThemeData(
    colors: isDark ? claudeDarkColors : claudeLightColors,
    tokens: isDark ? claudeDarkTokens : claudeLightTokens,
  );
}
```

`ShadcnThemeData`'s constructor derives `radiusXs…`, `spacing`,
`tracking`, `density` (via `Density.fromSpacingScale`), typography
(font wiring, §1.4), and `brightness` (from `colors.brightness`) — so the
generated file holds raw values only.

### 5.3 CLI generation + derivation rules (missing tokens)

`theme use <id>`: JSON → validate → write `app_theme.dart` (above).
`theme import <file.css | url | theme.json>` (future): parse shadcn /
tweakcn CSS (`:root {}` + `.dark {}`), oklch/hsl/hex/rgb → sRGB with
gamut clamping, emit canonical JSON, then generate as above. Fixtures:
10 `themes-css/` files + 42 presets; round-trip tests
(CSS → JSON → Dart → compare).

Measured derivation needs (verified: `slate.css` has none of these;
`slate.css` also lacks `--destructive-foreground`, `--font-*`,
`--shadow-*`, `--spacing`, `--tracking`):

| Missing in source | Rule |
|---|---|
| `destructiveForeground` | contrast pick: white or black, whichever has higher WCAG contrast vs `destructive` (shadcn v4 behaviour per PLAN §6.1) |
| `sidebar*` (8) | `sidebar=background`, `sidebarForeground=foreground`, `sidebarPrimary=primary`, `sidebarPrimaryForeground=primaryForeground`, `sidebarAccent=accent`, `sidebarAccentForeground=accentForeground`, `sidebarBorder=border`, `sidebarRing=ring`, per brightness |
| `shadows` | derive per-size from one base ambient shadow (§1.5); NEVER copy one entry 8× (today's bug) |
| `radius` | CSS `--radius: <n>rem` → JSON number `<n>` (strip unit); absent → `0.625` (shadcn default) |
| `spacing.base` / `tracking.normal` | absent → `4.0` / `0` (today's `ThemeData` defaults) |
| `fontSans/Serif/Mono` | absent → null (bundled fallback at build, §1.4) |

### 5.4 Radius semantics + converter rule (QA c — verified)

Preset JSON `radius` is the **rem number**, not px: measured values across
presets are 0, 0.125, 0.25, 0.3, 0.375, 0.4, 0.425, 0.5, 0.625 — the shadcn
`--radius` vocabulary (`slate.css`: `--radius: 0.625rem`). Today's Dart
math (`radius * {4,8,12,16,20,24}`, verified getters) is therefore read as:
**`radiusLg (= radius × 16)` is the anchor and equals the CSS `--radius` in
px at 16 px/rem** (0.625 → 10 px). The other steps are linear
approximations of shadcn's `calc()` steps, with small known deltas (at
radius 0.625: md 7.5 vs shadcn 8; sm 5 vs 6). Converter rule: strip the
`rem` unit, store the number, keep the getters unchanged (no visual
change). Recalibrating steps to exact shadcn calc values is a Phase 2
option with gallery cost — open question §8.6.

## 6. Runtime switching + animated transitions (behaviour preserved)

Keep all of today's mechanisms (all verified in `_impl/themes/`), renamed
`Theme*` → `ShadcnTheme*`:

1. **Ambient lookup**: `ShadcnTheme.of(context)` returns the nearest
   `ShadcnThemeData`, defaulting to `const ShadcnThemeData()` (today:
   `Theme.of`, lines 20-24).
2. **Dark readability normalization**: `_ensureReadableDarkTheme` patches
   near-black-on-dark foregrounds (`foreground`, `mutedForeground`,
   `cardForeground`, `popoverForeground`, `sidebarForeground`) against
   luminance floors (verified lines 26-55). Keep as-is; it fires rarely
   (only when `background.computeLuminance() < 0.5` in dark mode). Flag:
   consider a debug assert instead of silent patching — Phase 2 call.
3. **Light/dark builders**: `AppTheme.light()/dark()` become
   `buildXTheme(Brightness)` + system lookup. `ThemeMode.system/light/
   dark` enum kept (today at end of `component_theme.dart`).
4. **Implicit animation**: `AnimatedTheme(data:…, duration:…, curve:…,
   child:…)` + `_AnimatedThemeState.forEachTween` visiting a
   `ShadcnThemeDataTween` (verified 33 + 31 + 24 LOC). `lerp` covers
   colors, radius, scaling, density, spacing, tracking, shadows, icon
   theme, typography, surface flags (verified `ThemeData.lerp`).
5. **Preset swap**: setting a new `ShadcnThemeData` above an
   `AnimatedTheme` animates everything token-derived (all default-built
   component styles, since they resolve from ambient colors at build).
   Explicit `ComponentTheme<T>` overrides and widget args step unless
   wrapped in their own animation (same as today — `ComponentTheme` is an
   `InheritedTheme` with no tween).
6. **Tree scoping**: `ComponentTheme<T>.wrap` unchanged; `maybeOf` is
   tree-only (registry fallback removed, §3.5); the generated
   `component_themes.dart` feeds the separate registry leg read by
   `ComponentThemes.app<T>` (§3.6).
7. **Adaptive scaling**: `AdaptiveScaling.desktop/mobile` constants and
   `scale(theme)` (radius/size/text factors; verified 87 LOC) move into
   `density.dart`; the `AdaptiveTheme`-style applicator widget
   (`adaptive_scaler.dart`, 54 LOC) moves with it.
8. **Density bridge**: `Density.fromSpacingScale` /
   `toSpacingScale` (verified) stays the preset-spacing ↔ density bridge;
   `ThemeData.copyWith` density→spacing auto-derivation kept.

## 7. Migration map

### 7.1 `shared/theme` (27 files → 5)

| Old file | New location |
|---|---|
| `theme/app_theme.dart` | `theme/theme.dart` (`AppTheme` builders fold in) |
| `theme/app_theme_preset.dart` | DELETED → generated `app_theme.dart` in user app (§5.2) |
| `theme/color_scheme.dart` | `theme/tokens.dart` (`ShadcnColors`; `_fromAHSL` → `color_utils.dart`) |
| `theme/component_theme_global_registry.dart` | `theme/theme.dart` (moved as-is) |
| `theme/generated_colors.dart` | `theme/color_utils.dart` (names kept) |
| `theme/preset_themes.dart` | DELETED (JSON canonical, §5.1) |
| `theme/theme.dart` | `theme/theme.dart` (barrel → real file, no parts) |
| `theme/typography.dart` | `theme/typography.dart` (+ font/tracking wiring; absorbs icon theme props) |
| `theme/_impl/core/adaptive_scaler.dart` | `theme/density.dart` |
| `theme/_impl/core/adaptive_scaling.dart` | `theme/density.dart` |
| `theme/_impl/core/chart_color_scheme.dart` | `theme/tokens.dart` (`chartColors` getter) |
| `theme/_impl/core/color_scheme.dart` | `theme/tokens.dart` (`ShadcnColors`) |
| `theme/_impl/core/color_schemes.dart` | DELETED → generated `app_theme.dart` + `ShadcnColors.fallback` test const |
| `theme/_impl/core/color_shades.dart` | `theme/color_utils.dart` |
| `theme/_impl/core/density.dart` | `theme/density.dart` |
| `theme/_impl/core/design_tokens.dart` | `theme/tokens.dart` (`SpacingScale`, `TrackingScale`, `ShadowScale`) |
| `theme/_impl/core/single_chart_color_scheme.dart` | `theme/tokens.dart` |
| `theme/_impl/themes/__animated_theme_state.dart` | `theme/theme.dart` |
| `theme/_impl/themes/animated_theme.dart` | `theme/theme.dart` (`AnimatedTheme` kept) |
| `theme/_impl/themes/component_theme.dart` | `theme/theme.dart` (`ComponentTheme<T>`, `ThemeMode` kept) |
| `theme/_impl/themes/component_theme_data.dart` | `theme/theme.dart` (base class kept) |
| `theme/_impl/themes/icon_theme_properties.dart` | `theme/typography.dart` |
| `theme/_impl/themes/styleable.dart` | `theme/theme.dart` (contract kept; merge semantics §3.5) |
| `theme/_impl/themes/theme.dart` | `theme/theme.dart` (`Theme` → `ShadcnTheme`; one-release alias below) |
| `theme/_impl/themes/theme_data.dart` | `theme/theme.dart` (`ShadcnThemeData`) |
| `theme/_impl/themes/theme_data_tween.dart` | `theme/theme.dart` (tween kept) |
| `theme/schema/component_schema.dart` | DELETED → `tool/gen_theme_schema.dart` output (§4.2) |

`Theme` → `ShadcnTheme` rename ships with a one-release compat alias
(generic `InheritedTheme` subclass, no statics to forward — statics move):
`class Theme extends ShadcnTheme` marked `@Deprecated`, deleted next
release; CLI `migrate` rewrites call sites. Same for `ThemeData` →
`ShadcnThemeData`, `ColorScheme` → `ShadcnColors`.

### 7.2 Button theme files (18 files → 2, listed individually)

Base (1):

| Old file | New location |
|---|---|
| `_impl/themes/base/button_theme.dart` (17 LOC barrel) | DELETED (single `button_style.dart` needs no barrel) |

Config (4):

| Old file | New location |
|---|---|
| `_impl/themes/config/button_theme_config.dart` (140 LOC registration wiring) | DELETED → generated `component_themes.dart` registration (§3.6) |
| `_impl/themes/config/button_theme_defaults.dart` (63 LOC alias subclasses) | `button_style.dart` → `buttonDefaults` const (§3.3) |
| `_impl/themes/config/button_theme_tokens.dart` (350 LOC user-custom layer) | user app `button_theme.dart` (values-only, §3.4); token *functions* it referenced become `buttonDefaults` rows |
| `_impl/themes/config/button_theme_schema.dart` (236 LOC generated schema) | DELETED → `meta.json` `theme` section via `tool/gen_theme_schema.dart` (§4) |

Variants (13):

| Old file | New location |
|---|---|
| `_impl/themes/variants/button_theme_base.dart` (73 LOC abstract, 6 delegates) | `button_style.dart` → `ButtonVariantStyle` + `ButtonTheme` (6 delegates collapse to 5 fields: `margin` dropped — always `EdgeInsets.zero`; `mouseCursor` derived from enabled) |
| `_impl/themes/variants/primary_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.primary` row |
| `_impl/themes/variants/secondary_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.secondary` row |
| `_impl/themes/variants/outline_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.outline` row |
| `_impl/themes/variants/ghost_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.ghost` row |
| `_impl/themes/variants/link_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.link` row |
| `_impl/themes/variants/text_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.text` row (gallery-gated; fallback alias → ghost) |
| `_impl/themes/variants/destructive_button_theme.dart` (44 LOC) | `button_style.dart` → `ButtonVariant.destructive` row (text → `destructiveForeground` token) |
| `_impl/themes/variants/fixed_button_theme.dart` (44 LOC) | DELETED → const moved into toggle implementation file |
| `_impl/themes/variants/menu_button_theme.dart` (44 LOC) | MOVED → menu component theme (one row, menu padding) |
| `_impl/themes/variants/menubar_button_theme.dart` (44 LOC) | MOVED → menu component theme (same row, menubar padding) |
| `_impl/themes/variants/muted_button_theme.dart` (44 LOC) | COLLAPSED → `ButtonVariant.text` row (alias) |
| `_impl/themes/variants/card_button_theme.dart` (44 LOC) | MOVED → card component theme |

Also deleted/consolidated around the button (not theme files, listed for
completeness): 6 wrapper variant widgets → `Button(variant:)` + deprecated
aliases; `button_state_property*.dart` → Flutter `WidgetStateProperty`;
`theme.schema.json` + `button.meta.json` + `meta.json` → one `meta.json`
with generated `theme` section.

## 8. Risks + open questions

1. **Shadow derivation needs calibration. DECIDED:** transcribe
   multipliers from today's hardcoded `ThemeData` defaults in Phase 2,
   prove with preset-vs-gallery screenshots, and gate derivation behind
   the explicit `shadowsDerived: true` marker the importer writes (never
   silent all-8-identical heuristics). All sampled presets carry 8
   identical shadow entries, so no preset tells us the intended per-size
   progression; the only correct scale is today's hardcoded defaults.
2. **Styleable merge-vs-replace changes widget behaviour.** Field-wise
   merge (§3.5) is the PLAN semantic but differs from today's replace.
   Mitigation: resolver unit tests for every precedence combination +
   one gallery case with stacked widget/ancestor/app overrides.
3. **Rename churn.** `Theme`/`ThemeData`/`ColorScheme` → `Shadcn*` touches
   ~250+ files in Phase 4; the alias + CLI `migrate` path must land first
   or the tree will not compile mid-migration.
4. **Moved-variant ownership UNVERIFIED.** `menu/menubar/card/fixed`
   moves assume no outside imports; Phase 1 must grep
   (`MenuButtonTheme|MenubarButtonTheme|CardButtonTheme|FixedButtonTheme|
   ButtonStyle.(menu|menubar|card|fixed)`) and either confirm or keep a
   re-export shim one release.
5. **`destructiveForeground` deprecation conflict. DECIDED:**
   un-deprecate and keep the field; contrast-derivation applies only when
   the token is absent from the source (CSS import path, §5.3). The field
   is `@Deprecated('Legacy color')` in `ColorScheme` yet required by the
   preset schema and needed by destructive buttons.
6. **Radius step calibration. DECIDED:** keep the linear getters (no
   visual change). Exact shadcn `calc()` steps (md −2 px, sm −4 px from
   lg) stay a documented future option requiring gallery pixel-diff.
7. **oklch → sRGB converter.** No converter exists in-repo (UNVERIFIED
   whether CLI has color helpers — Phase 5 inventory). Pure-Dart
   implementation + gamut clamping + round-trip tests required before
   `theme import` ships; `theme use` (JSON → Dart) has no such dependency
   and can land first.
8. **Studio JSON contract versioning.** `meta.json` `theme.schemaVersion`
   starts at 1; Studio must reject unknown versions loudly, not render
   partial editors. `defaultValue: null` (fall through) vs explicit null
   override needs a sentinel if a future control allows "force null".
9. **`surfaceOpacity/surfaceBlur/enableFeedback/platform` retention.
   DECIDED:** grep consumers in Phase 2, cut if zero references. Until
   then carried into `ShadcnThemeData` unexamined (UNVERIFIED consumers);
   cutting shrinks `lerp`/`copyWith`.

Note on snippets: `// ...` comments in `ShadcnColors.copyWith/lerp`,
`ColorRef.resolve`, and `app_theme.dart` mark elided per-token repetitions
of an identical, mechanical pattern. The implementation (or its generator)
must expand every arm — an exhaustive `switch` over all 31 tokens and all
7 variants, verified by `gen_theme_schema.dart` exhaustiveness checks and
`dart analyze` (non-exhaustive switches fail the build).

## RESULT
status: done
files_written: [/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/THEME_DESIGN.md]
commands_run: [head -420 truncate of broken tail -> marker gone; 9 heredoc appends (16-141 lines each) -> file 1181 lines; ghost helper re-read (lines 302-345) -> hover is muted wash, corrected from UNVERIFIED; radius audit (42 preset JSONs: 0-0.625 rem vocabulary; radiusLg = radius x 16 = CSS px anchor) -> converter rule stated]
key_findings: [ghost hover verified as muted 0.8 wash (not accent); menu/menubar verified as accent wash + radiusSm differing only in padding; JSON radius is the rem number with radiusLg as px anchor; all 18 button theme files + all 27 shared files individually mapped]
open_questions: [§8.1-8.9 unchanged in substance; .6 radius calibration and .4 moved-variant grep carry into Phase 1/2]
## RESULT (round 2 amendments, QA A1–A5)

- A1 (blocker): added const `StateValue<T> implements
  WidgetStateProperty<T?>` (§1.6, precedence disabled > pressed > hovered
  > focused > selected > rest, each ?? rest, per-state merge);
  `ButtonVariantStyle` now uses `StateValue<ThemedColor>` /
  `StateValue<TextDecoration>` (§3.2, merge is per-state); §3.4 example is
  fully const (`resolveWith` banned by `check_user_theme`); §4.2 type
  table maps `StateValue<T>` to state-matrix controls.
- A2 (major): `ThemedColor.ref` gains `{double alpha = 1.0}`, applied
  absolutely in `RefColor.resolve` via `withValues` (§1.6); §3.3 table
  expresses every wash as data; resolver-side alpha mechanism deleted;
  defaults are the const `buttonDefaults` (§3.3, refs only).
- A3 (major): `ComponentTheme.maybeOf` = tree-only,
  `ComponentThemes.app<T>()` = registry leg, generic
  `resolveComponentStyle<T, S>` in theme.dart with 5-line Button call
  site (§3.5); behaviour change vs today's maybeOf fallback noted;
  §2.1 rows 4/20, §6.6, §7.2 reworded to the split legs.
- A4 (minor): §3.6 now imports style files + theme barrel and uses flat
  layout paths `ui/shadcn/components/<name>/<name>_theme.dart`.
- A5: §8 items 1/5/6/9 marked DECIDED per orchestrator rulings.
