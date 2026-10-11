# Tokens Audit — themes_preset (P1-D)

Scope: all 42 files in `flutter_shadcn_kit/lib/registry/themes_preset/*.json`, checked against
`flutter_shadcn_kit/lib/registry/manifests/themes.schema.json`, the shadcn CSS var list, and the
source CSS in `themes-css/` (12 files: blue, gray, green, neutral, orange, red, rose, slate, stone, violet, yellow, zinc).

Converter/validator used: `/tmp/audit/audit.py`, `/tmp/audit/colormatch.py` (coloraide oklch→sRGB, gamut-clamped; jsonschema for validation).

## 1. Key-set consistency (light / dark / tokens.light / tokens.dark)

- All 42 presets have **identical** `light` (32 keys) and `dark` (32 keys) key sets — matching the schema's required/optional color list exactly. No missing/extra color keys anywhere.
- `tokens.light` modal set = 7 keys: `radius`, `spacing`, `tracking`, `shadows`, `fontSans`, `fontSerif`, `fontMono`.
- `tokens.dark` modal set = 4 keys: `radius`, `spacing`, `tracking`, `shadows` (fonts absent).
- Diffs found (all are font-token presence/absence, everything else consistent):

| Preset | Section | Δ |
|---|---|---|
| bubblegum | tokens.dark | +fontSans, +fontSerif, +fontMono (has fonts) |
| doom-64, graphite, notebook, perpetuity, quantum-rose, soft-pop, vercel, violet-bloom | tokens.dark | +fontSans, +fontSerif, +fontMono (have fonts) |
| caffeine, claude, t3-chat | tokens.light | no `fontSans/Serif/Mono` |
| candyland, cyberpunk, neo-brutalism, retro-arcade | tokens.light | no `fontSerif` (cyberpunk/neo-brutalism/retro-arcade also verified to lack only fontSerif; candyland lacks fontSerif only) |
| starry-night | tokens.light | only `fontSans` present; missing fontSerif + fontMono |

Note: `tokens.dark` in 33/42 presets has no fonts at all — i.e. dark font overrides exist in only 9 presets. Likely unintended drift (fonts are mode-independent).

## 2. Coverage of the shadcn CSS variable list

CSS var → JSON home mapping check (camelCase of CSS name, e.g. `chart-1`→`chart1`, `shadow-2xs`→`shadow2xs`):

- **All 32 color vars** (background … sidebarRing) have a JSON home in every preset's `light`/`dark`.
- `radius` → `tokens.<side>.radius` ✓; `tracking-normal` → `tokens.<side>.tracking.normal` ✓; `spacing` → `tokens.<side>.spacing.base` ✓.
- `chart-1..5` → `chart1..5` ✓; `shadow`/`sm`/`md`/`lg`/`xl`/`2xl`/`2xs`/`xs` → `shadows.shadow*` ✓.
- `font-sans/-serif/-mono` → `fontSans/fontSerif/fontMono` ✓ (schema: `themes.schema.json` `$defs.tokens.properties`) — but see §1: present in `tokens.light` for only 26/42 presets (19 lack at least one), and in `tokens.dark` for only 9/42. **Gap to fix for uniform coverage.**
- **No JSON home anywhere** (verified by scanning all keys of all 42 presets):
  - `shadow-color`, `shadow-opacity`, `shadow-blur`, `shadow-spread`, `shadow-offset-x`, `shadow-offset-y` — the base shadow atoms that shadcn/tweakcn uses to *derive* `--shadow-2xs..2xl`. The schema instead stores only the derived per-size lists (`themes.schema.json` `$defs.shadowScale`), so the base values are not round-trippable.
  - `tracking-tight`, `tracking-wide` are not in the supplied CSS list but the schema reserves `tracking.tight`/`tracking.wide`; no preset sets them (only `tracking.normal` appears). `--letter-spacing` has no JSON key at all (schema uses `tracking` — acceptable, but undocumented).
  - `destructive-foreground` is declared required in the schema and present in all presets, but absent from 10 of the 12 `themes-css/*.css` sources (neutral.css has no `--destructive-foreground`) — derivation path implied.

## 3. Shadow identity bug — all 42 presets

For **every** preset, in **both** light and dark, the 8 sizes `shadow2xs, shadowXs, shadowSm, shadow, shadowMd, shadowLg, shadowXl, shadow2xl` serialize to the **same single-layer value**. Examples:

- `claude.json` `tokens.light.shadows` (line 84–…): all 8 = `[{x:20.5, y:16.5, blur:25.5, spread:-30, color:0x12000000}]` — a 25.5px blur with −30 spread for *all* sizes including 2xs.
- `vercel.json`: all 8 = `[{x:0,y:1,blur:2,spread:0,color:0x2E000000}]`; `mono.json`: all 8 = `[{x:0,y:1,blur:0,spread:0,color:0x00000000}]` (fully transparent → invisible shadow).

Per shadcn/tweakcn, each size should be a **derived** value (2-layer stack from sm..xl, different opacity multipliers), not a copy of the base. No derivation/converter exists in the repo yet — `REARCHITECTURE_PLAN.md` §6.2 marks the CSS→JSON converter as a *future* feature and explicitly says shadows should be “derived per size, not copied” (plan line 85).

**Root cause (with file:line):**
1. The source Dart presets already contain the defect: each generated preset literal repeats one identical `BoxShadow` across all 8 `ShadowScale` fields — e.g. `flutter_shadcn_kit/lib/registry/shared/theme/generated/claude/preset_themes.dart:133` (`shadow2xs:`), `:141`, `:149`, `:157`, `:165`, `:173`, `:181`, `:189` all use `Offset(20.5, 16.5), blurRadius: 25.5, spreadRadius: -30` (line 135ff). Same pattern in every `generated/<name>/preset_themes.dart`.
2. The JSON exporter copies those values verbatim without per-size derivation:
   - `flutter_shadcn_kit/tool/theme/theme_preset_export_all.dart` — `parseThemePresetsFromDart(...)` → `withThemeSchema(...)` writes `preset['shadows']` as-is.
   - `flutter_shadcn_kit/tool/theme/theme_preset_dart_parser.dart:40–48` defines `_shadowFields` and `:178–186` copies each field's array literally into the JSON map.
   - CLI side has only the raw base atoms (`shadcn_flutter_cli/lib/registry/shared/theme/preset_theme_data.dart:121–126` etc.: `shadowBlur/shadowColor/shadowOffsetX/shadowOffsetY/shadowOpacity/shadowSpread`) and never expands them into `shadow2xs..2xl` — grep for `shadow2xs|ShadowScale` in `shadcn_flutter_cli` has no hits.

So the bug is **upstream in the generated Dart data** (identical literals per size), propagated 1:1 by the exporter; the missing per-size derivation rule is the fix.

## 4. Color comparison vs `themes-css/` (3 closest pairs)

No preset matches a CSS file by name, so I scored all 42×12 pairs by |channels| within 1 unit and took the 3 best (`mono` is a grayscale theme, nearest to the neutral/zinc defaults):

| Pair | within-1/62 tokens | Notes |
|---|---|---|
| `themes-css/neutral.css` ↔ `themes_preset/mono.json` | 40/62 | primary/ring/charts differ (see below) |
| `themes-css/zinc.css` ↔ `themes_preset/mono.json` | 25/62 | same pattern as neutral |
| `themes-css/blue.css` ↔ `themes_preset/mono.json` | 27/62 | mono drops blue primary entirely |

Mismatches > 1 unit/channel (per channel `err=(r,g,b)`):

**neutral.css vs mono.json**
- light `chart-1..5`: CSS colored hues (e.g. chart-1 `(245,73,0)`) vs JSON flat `(115,115,115)`; primary `(23,23,23)` vs `(115,115,115)`; muted-foreground err (2,2,2).
- dark: border/input are `oklch(1 0 0 / 10%|15%)` (alpha 26/38) but JSON stores opaque `(56,56,56)`/`(82,82,82)`; primary `(229,229,229)` vs `(115,115,115)`; primary-foreground inverted `(23,23,23)` vs `(250,250,250)`; sidebar-primary/primary-foreground similarly inverted; charts flat gray.

**zinc.css vs mono.json**
- Same flat-gray `chart-1..5` and primary discrepancies; small hue drift ≤ (0,0,10) on muted/ring (zinc has slight blue tint `(113,113,123)` vs mono `(113,113,113)`); dark border/input alpha-vs-opaque mismatch as above; dark accent/popover off by (25,25,22)/(14,14,11).

**blue.css vs mono.json**
- light/dark `primary`, `sidebar-primary`, `chart-1..5` expected blue hues vs mono gray — e.g. light primary `(20,71,230)` vs `(115,115,115)`, dark sidebar-primary `(43,127,255)` vs `(250,250,250)`; remaining neutrals match within hue drift ≤ (0,0,10).

Takeaways: (a) alpha-bearing CSS colors (`--border: oklch(1 0 0/10%)`) were flattened to opaque equivalents in JSON — a real alpha-handling gap; (b) `mono` intentionally desaturates charts/primary, so its chart palette is a single gray — worth flagging as a suspicious conversion result if mono was meant to track shadcn defaults.

## 5. Schema validation (all 42)

`themes.schema.json` (draft 2020-12, `additionalProperties:false`, required 32-color scheme per side, `shadowScale` ≤8 items, boxShadow required x/y/blur/spread/color): **42/42 pass, zero failures**.

## Open items
1. Fix shadow derivation (base atoms → 8 derived sizes, 2-layer sm..xl); then `shadow-color/-opacity/-blur/-spread/-offset-x/-offset-y` become real JSON keys (currently homeless).
2. Normalize font tokens: every preset should carry `fontSans/fontSerif/fontMono` in `tokens.light` (26/42 do) — and decide whether `tokens.dark` fonts are ever needed (9/42 have them).
3. Decide alpha policy for colors like dark `--border`/`--input` (preserve alpha in JSON or document the flattening).
4. `mono` chart palette collapsing to one gray — confirm intended.
