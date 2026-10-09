# theme/ (layer 1)

Global tokens, ambient theme, and per-component theme resolution.
Widgets-only; no Material/Cupertino. No deprecated aliases or shims.

## Files

- `color_tokens.dart` — `ShadcnColors` (32 tokens + brightness),
  `ColorRef`, `ThemedColor` (literal | ref + alpha multiply), `StateValue`.
- `tokens.dart` — `ShadcnTokens`, `ShadcnFonts` (mode-independent),
  `SpacingScale`, `TrackingScale`, `ShadowScale` (+`derive`, `defaultShadowScale`).
- `theme.dart` — `ShadcnThemeData`, `ShadcnTheme`, `AnimatedShadcnTheme`,
  `ComponentThemeData`, `ComponentTheme<T>`, `ComponentThemes` (app leg),
  `Mergeable`, `resolveComponentStyle`, `ThemeMode`.
- `typography.dart` — `Typography` (+`applyFonts`), `IconThemeProperties`.
- `density.dart` — `Density`, edge-insets helpers, `AdaptiveScaling`(+`AdaptiveScaler`).
- `color_utils.dart` — `ColorShades`, `fromAHSL`, hex helpers, minimal `Colors`.

## Tokens (32)

`background foreground card cardForeground popover popoverForeground`
`primary primaryForeground secondary secondaryForeground muted
mutedForeground accent accentForeground destructive destructiveForeground`
`border input ring chart1..5 sidebar sidebarForeground sidebarPrimary
sidebarPrimaryForeground sidebarAccent sidebarAccentForeground
sidebarBorder sidebarRing` (+ `brightness`; radius/spacing/tracking/shadows/fonts separate).

## Resolution order (per property, per state)

`widget arg > ComponentTheme<T> (tree) > ComponentThemes (user files at the
app root) > defaults`. Slices implement `Mergeable.merge` (receiver wins),
so a leg setting only `hovered` never wipes a lower leg's `rest`.
`ComponentTheme.maybeOf` is tree-only, never `ComponentThemes`.

## Component pattern

```dart
class ButtonVariantStyle implements Mergeable<ButtonVariantStyle> {
  const ButtonVariantStyle({this.background}); // + merge/forVariant…
  final StateValue<ThemedColor>? background;
  @override
  ButtonVariantStyle merge(ButtonVariantStyle? fallback) => …; // receiver wins
}
const buttonDefaults = ButtonTheme(primary: …); // refs only, registry-owned
const buttonThemeOverrides = ButtonTheme(primary: …); // user-owned file
// Generated once per app; ShadcnApp puts it at the root:
const appComponentThemes = <ComponentThemeData>[buttonThemeOverrides];
final style = resolveComponentStyle<ButtonTheme, ButtonVariantStyle>(context,
  widget: widget.theme, select: (t) => t.forVariant(variant),
  defaults: buttonDefaults.forVariant(variant)!);
```
