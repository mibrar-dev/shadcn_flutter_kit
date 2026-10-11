# P2-D — Presets: new JSON schema, 42 migrated presets, JSON → Dart generator

Status: done. 42/42 presets migrated, schema-validated, generated, formatted, analyzed
and widget-tested. Gates green (results in §8).

## 1. Files written

| Path | LOC | What |
|---|---|---|
| `flutter_shadcn_kit/lib/registry_next/themes/themes.schema.json` | 197 | draft 2020-12, `additionalProperties: false` everywhere |
| `flutter_shadcn_kit/lib/registry_next/themes/<id>.json` × 42 | 98–103 each | canonical presets, `schemaVersion: 2` |
| `flutter_shadcn_kit/lib/registry_next/themes/index.json` | 216 | `{schemaVersion, count, themes:[{id,name,file}]}` sorted by id |
| `flutter_shadcn_kit/tool/rearch/migrate_presets.dart` | 699 | one-off converter, re-runnable, idempotent (see §7 caveat) |
| `flutter_shadcn_kit/tool/rearch/gen_app_theme.dart` | 464 | JSON → values-only `app_theme.dart` |
| `flutter_shadcn_kit/test/registry_next/themes/schema_check.dart` | 201 | mini JSON-Schema validator + path helpers |
| `flutter_shadcn_kit/test/registry_next/themes/generated_theme.dart` | 311 | parses a generated `app_theme.dart` back into `ShadcnColors`/`ShadcnTokens` |
| `flutter_shadcn_kit/test/registry_next/themes/preset_schema_test.dart` | 150 | 8 tests: 42 validate, index, token list, alpha, rem/em, provenance |
| `flutter_shadcn_kit/test/registry_next/themes/gen_app_theme_test.dart` | 139 | 6 tests incl. the 42-preset `dart format` + `dart analyze` round trip |
| `flutter_shadcn_kit/test/registry_next/themes/generated_theme_test.dart` | 192 | widget test over 2 generated themes + all-42 value round trip |
| `flutter_shadcn_kit/test/registry_next/themes/colour_parsing_test.dart` | 95 | `#RRGGBBAA` alpha, 256-byte round trip, rejection cases |

Nothing else was created or modified. `$REG/themes_preset/*.json`,
`$REG/manifests/themes.schema.json`, `$REG/manifests/theme.index.json` and
`lib/registry_next/theme/**` were read only.

## 2. Schema summary

`themes.schema.json` — draft 2020-12. Per preset:

| Field | Required | Type / format |
|---|---|---|
| `id` | yes | `^[a-z0-9]+(?:-[a-z0-9]+)*$`, equals the file name |
| `name` | yes | non-empty string |
| `schemaVersion` | yes | `const 2` |
| `light`, `dark` | yes | all **32** colour tokens required in each (no derivation inside a preset) |
| `fonts` | no | `{sans, serif, mono}`, CSS family lists, ≥1 entry if present; **mode-independent** |
| `radius` | yes | number ≥ 0, the shadcn `--radius` **rem with the unit stripped** (0.625rem → 0.625); unitless in Dart |
| `spacing` | yes | number > 0, `--spacing` **rem stripped** (0.25rem → 0.25) |
| `tracking` | yes | `{normal, tight?, wide?}`, **em stripped** (0.025em → 0.025) |
| `shadow` | yes | `{light: shadowAtoms, dark: shadowAtoms}` |
| `shadowAtoms` | yes | `{color, opacity, blur, spread, offsetX, offsetY}`; lengths in px, opacity 0..1 |
| `shadowsDerived` | no | `enum ["cli", "from-legacy"]` — provenance of the atoms |

Colour format: **`#RRGGBB` or `#RRGGBBAA`**, upper case, leading `#`, `0x`
rejected. Six digits mean alpha `FF`; an eight digit value is kept verbatim —
shadcn's `oklch(1 0 0 / 10%)` dark border is `#FFFFFF1A`, never flattened
(the P1-D regression). The int form used by Dart is the usual `0xAARRGGBB`.

**No derived shadow size is ever stored.** The eight sizes always come from
`ShadowScale.derive(color, opacity, blur, spread, offsetX, offsetY)`; storing
them is the bug this schema removes (TOKENS_AUDIT §3: all 84 legacy preset
modes had 8 byte-identical entries).

Unit conversions the generator performs (documented in the schema too):
`spacing * 16` → `ShadcnTokens.spacingBase`, `tracking * 16` →
`trackingNormal`/`Tight`/`Wide` (Flutter letter spacing is logical pixels),
`radius` unchanged (used as a unitless factor, THEME_DESIGN §5.4). Dividing and
multiplying by 16 is exact in IEEE-754, so every legacy px value
(3.68 / 3.84 / 4 / 4.32, 0.5 / -0.4) round trips byte for byte.

## 3. Migration rules and what the data said

`dart run tool/rearch/migrate_presets.dart [--legacy <dir>] [--cli <file>] [--out <dir>] [--report <file>]`

Inputs: `$REG/themes_preset/*.json` (42, read only) and
`$CLI/lib/registry/shared/theme/preset_theme_data.dart`, parsed with
`package:analyzer` `parseString` (unresolved AST; no regex on Dart).

| Data | Source | Cross-check result |
|---|---|---|
| 32 colour tokens × 2 modes (2 688 values) | legacy JSON | **0 mismatches** against the CLI maps. `vercel`'s CLI maps are literally `{}` — its colours can only come from the legacy JSON. |
| shadow atoms | CLI tweakcn atoms | **0 mismatches**: for all 42 presets `derive(light atoms)` reproduces the legacy single `shadow` entry byte for byte (geometry **and** the alpha byte). This independently confirms `color.a * opacity` is the right composition rule. |
| radius / spacing / tracking | legacy JSON light side, converted to rem/em | **0 mismatches** against the CLI for every value the CLI defines (`radius` 42/42, `spacing` 7/7, `tracking` 8/8). |
| fonts | CLI (authoritative per brief) | 7 legacy values are corrupt (see below). |
| dark atoms | CLI `lightTokens` overlaid with `darkTokens` | empty `darkTokens` = "same as light" (brief); partial `darkTokens` override per atom. |

Findings worth carrying forward:

1. **8 presets, not 3, have no CLI shadow atoms.** The brief predicted
   `caffeine`, `claude`, `t3-chat`; the full list is `caffeine`, `candyland`,
   `claude`, `modern-minimal`, `nature`, `northern-lights`, `starry-night`,
   `t3-chat` — i.e. exactly the presets with no font *or* with a reduced font
   block, plus `candyland`. Their atoms were recovered from the legacy single
   shadow entry and flagged `"shadowsDerived": "from-legacy"`: `color` = the
   legacy rgb with alpha forced to `FF`, `opacity` = legacy alpha / 255
   (rounded to 6 dp, which still lands on the exact alpha byte).
   For all 8 the legacy light and dark entries are identical, so both modes
   get the same atoms. The test pins this exact list.
2. **31/42 legacy presets had a dark shadow different from light** (usually
   the Flutter `ThemeData` default `20.5/16.5/25.5/-30/0x12`, i.e. another
   symptom of the same copy bug). The new schema defines both modes from the
   atoms: dark = light overlaid with the CLI `darkTokens` shadow entries, which
   only 7 presets actually override (`bubblegum`, `claymorphism`, `darkmatter`,
   `mocha-mousse`, `doom-64`, `notebook`, `perpetuity`, `soft-pop`,
   `quantum-rose`, `sage-garden`, `solar-dusk`, `twitter`, `vercel`,
   `violet-bloom`). Column "dark≠light (legacy)" in §5 records the old drift.
3. **The legacy JSON has 7 corrupt font values** — the literal string `\`,
   left behind by the old Dart→JSON exporter when a family list started with a
   quote: `amethyst-haze` (serif, mono), `doom-64` (sans, serif, mono),
   `notebook` (serif, mono), `supabase` (serif, truncated mid-family). The CLI
   has the real values, so the CLI won (brief). Do not treat the legacy JSON as
   a font reference.
4. **9 dark font overrides are dropped** (`graphite` sans, `notebook` serif+mono,
   `perpetuity` all three, `quantum-rose` sans) because fonts are
   mode-independent (QA P1-D). The light side wins.
5. **10 presets had a per-mode radius** in the legacy JSON (`amber-minimal`,
   `bubblegum`, `catppuccin`, `darkmatter`, `graphite`, `kodama-grove`, `mono`,
   `sage-garden`, `tangerine`, `twitter` — light ≠ dark, dark usually 0.5).
   The new schema is per preset, so the light value is kept. The CLI confirms
   a differing dark radius for only 2 of the 10 (`sage-garden`, `tangerine`),
   so 8 of them are legacy drift that the new schema drops.
6. **Upstream data quirks kept verbatim** (tweakcn, not migration bugs):
   `mono` and `darkmatter` put a mono family in the `sans`/`serif` slots,
   `perpetuity`'s sans is `Courier New, monospace`, `graphite`'s CLI
   `fontSans` differs between modes, `starry-night` has sans only.
   No preset sets `tracking.tight`/`tracking.wide`.

## 4. Generated `app_theme.dart`

`dart run tool/rearch/gen_app_theme.dart <preset.json> <out.dart> [--theme-import <uri>]`

Shape (THEME_DESIGN §5.2, against the real `registry_next/theme` API):

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: lib/registry_next/themes/claude.json (id: claude).
// Regenerate: dart run tool/rearch/gen_app_theme.dart claude.json app_theme.dart

import 'package:flutter/widgets.dart';
import '<--theme-import>';
import '<--theme-import dir>/color_tokens.dart';
import '<--theme-import dir>/tokens.dart';

/// Colour tokens for the Claude preset, light brightness.
const ShadcnColors claudeLightColors = ShadcnColors(
  brightness: Brightness.light,
  background: Color(0xFFFAF9F5),
  …32 tokens…
);

/// Non-colour tokens for the Claude preset, light brightness.
final ShadcnTokens claudeLightTokens = ShadcnTokens(
  radius: 0.5,
  spacingBase: 3.84,
  trackingNormal: 0.0,
  shadows: ShadowScale.derive(
    color: Color(0xFF000000),
    opacity: 0.070588,
    blur: 25.5,
    spread: -30.0,
    offsetX: 20.5,
    offsetY: 16.5,
  ),
);

/// Builds the ambient theme for the Claude preset.
ShadcnThemeData buildClaudeTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ShadcnThemeData(
    colors: isDark ? claudeDarkColors : claudeLightColors,
    tokens: isDark ? claudeDarkTokens : claudeLightTokens,
  );
}
```

* `const ShadcnColors <id>LightColors` / `<id>DarkColors` (32 tokens, order =
  `ShadcnColors` declaration order = schema `colorMap.required`; the test
  asserts all three are the same list).
* `final ShadcnTokens <id>LightTokens` / `DarkTokens` — **`final`, not `const`**,
  because `ShadowScale.derive` is a factory.
* `const ShadcnFonts <id>Fonts` only when the preset names a family; otherwise
  the constant and the `fonts:` argument are omitted (3 presets).
* `ShadcnThemeData build<Id>Theme(Brightness)`; `<Id>` is the id in camelCase
  with the first letter capitalised (`amber-minimal` → `buildAmberMinimalTheme`,
  `doom-64` → `buildDoom64Theme`, `t3-chat` → `buildT3ChatTheme`), asserted
  against a valid-identifier regex for all 42 ids.
* `--theme-import` (default `package:flutter_shadcn_kit/registry_next/theme/theme.dart`)
  redirects all three imports; the two siblings are derived from the same
  directory, so pointing it at `package:my_app/ui/theme.dart` yields
  `package:my_app/ui/color_tokens.dart` and `…/tokens.dart`.
* **Values only**: no control flow, no types, no imports beyond the four above.
  The tool emits each call on one line when the statement fits in 80 columns
  and exploded with a trailing comma otherwise — exactly what the tall-style
  `dart format` produces, so no `dart_style` dependency is needed and the
  output is format-stable.

## 5. Per-preset table

`fonts` lists the CLI slots that exist. `shadow src` = `cli` (tweakcn atoms) or
`legacy` (recovered). `spacing` is rem, `tracking.normal` is em; multiply by 16
for the Dart px value. Flags: **L** no CLI atoms, **R** legacy dark radius
dropped, **F** dark font override dropped, **f** legacy font value corrupt,
**C** CLI colour maps empty.

| id | name | fonts | shadow src | radius | spacing | tracking.normal | dark≠light (legacy) | flags |
|---|---|---|---|---|---|---|---|---|
| `amber-minimal` | Amber Minimal | sans/serif/mono | cli | 0.375 | 0.25 | 0 | yes | **R** |
| `amethyst-haze` | Amethyst Haze | sans/serif/mono | cli | 0.5 | 0.25 | 0 | yes | **f** |
| `bold-tech` | Bold Tech | sans/serif/mono | cli | 0.625 | 0.24 | 0 | yes | |
| `bubblegum` | Bubblegum | sans/serif/mono | cli | 0.4 | 0.24 | 0 | yes | **R** |
| `caffeine` | Caffeine | — | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `candyland` | Candyland | sans/mono | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `catppuccin` | Catppuccin | sans/serif/mono | cli | 0.35 | 0.24 | 0 | yes | **R** |
| `claude` | Claude | — | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `claymorphism` | Claymorphism | sans/serif/mono | cli | 1.25 | 0.24 | 0 | yes | |
| `clean-slate` | Clean Slate | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | |
| `cosmic-night` | Cosmic Night | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | |
| `cyberpunk` | Cyberpunk | sans/mono | cli | 0.5 | 0.24 | 0 | yes | |
| `darkmatter` | Darkmatter | sans/serif/mono | cli | 0.75 | 0.25 | 0 | yes | **R** |
| `doom-64` | Doom 64 | sans/serif/mono | cli | 0 | 0.25 | 0 | yes | **f** |
| `elegant-luxury` | Elegant Luxury | sans/serif/mono | cli | 0.375 | 0.24 | 0 | yes | |
| `graphite` | Graphite | sans/serif/mono | cli | 0.35 | 0.24 | 0 | yes | **F** **R** |
| `kodama-grove` | Kodama Grove | sans/serif/mono | cli | 0.425 | 0.24 | 0 | yes | **R** |
| `midnight-bloom` | Midnight Bloom | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | |
| `mocha-mousse` | Mocha Mousse | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | |
| `modern-minimal` | Modern Minimal | sans/serif/mono | legacy | 0.375 | 0.24 | 0 | no | **L** |
| `mono` | Mono | sans/serif/mono | cli | 0 | 0.24 | 0 | yes | **R** |
| `nature` | Nature | sans/serif/mono | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `neo-brutalism` | Neo Brutalism | sans/mono | cli | 0 | 0.24 | 0 | yes | |
| `northern-lights` | Northern Lights | sans/serif/mono | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `notebook` | Notebook | sans/serif/mono | cli | 0.625 | 0.25 | 0.03125 | no | **F** **f** |
| `ocean-breeze` | Ocean Breeze | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | |
| `pastel-dreams` | Pastel Dreams | sans/serif/mono | cli | 1.5 | 0.24 | 0 | yes | |
| `perpetuity` | Perpetuity | sans/serif/mono | cli | 0.125 | 0.24 | 0 | yes | **F** |
| `quantum-rose` | Quantum Rose | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | **F** |
| `retro-arcade` | Retro Arcade | sans/mono | cli | 0.25 | 0.24 | 0 | yes | |
| `sage-garden` | Sage Garden | sans/serif/mono | cli | 0.35 | 0.23 | 0 | yes | **R** |
| `soft-pop` | Soft Pop | sans/serif/mono | cli | 1 | 0.25 | 0 | no | |
| `solar-dusk` | Solar Dusk | sans/serif/mono | cli | 0.3 | 0.24 | 0 | yes | |
| `starry-night` | Starry Night | sans | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `sunset-horizon` | Sunset Horizon | sans/serif/mono | cli | 0.625 | 0.24 | 0 | yes | |
| `supabase` | Supabase | sans/serif/mono | cli | 0.5 | 0.24 | 0.025 | yes | **f** |
| `t3-chat` | T3 Chat | — | legacy | 0.5 | 0.24 | 0 | no | **L** |
| `tangerine` | Tangerine | sans/serif/mono | cli | 0.75 | 0.24 | 0 | yes | **R** |
| `twitter` | Twitter | sans/serif/mono | cli | 1.3 | 0.24 | 0 | yes | **R** |
| `vercel` | Vercel | sans/serif/mono | cli | 0.5 | 0.24 | 0 | yes | **C** |
| `vintage-paper` | Vintage Paper | sans/serif/mono | cli | 0.25 | 0.24 | 0 | yes | |
| `violet-bloom` | Violet Bloom | sans/serif/mono | cli | 1.4 | 0.27 | -0.025 | no | |

Totals: 34 CLI-sourced + 8 legacy-recovered; 34 with all three font slots,
5 partial (`candyland`, `cyberpunk`, `neo-brutalism`, `retro-arcade` sans+mono;
`starry-night` sans only), 3 with none (`caffeine`, `claude`, `t3-chat`);
31/42 legacy dark shadows differed from light.

## 6. Tests

`test/registry_next/themes/` — 26 tests, all green.

* `schema_check.dart` — a 130-line draft 2020-12 subset validator
  (`$ref`/`#/$defs`, `type`, `properties`, `required`, `additionalProperties:
  false`, `pattern`, `minLength`, `minProperties`, `minimum`, `maximum`,
  `exclusiveMinimum`, `const`, `enum`). It **reports any keyword it does not
  implement**, so a schema change cannot silently pass. No new dependency.
* `preset_schema_test.dart` — 42/42 validate; `index.json` matches the
  directory 1:1 with matching id/name; the generator's token list equals the
  schema's `colorMap.required`; every colour matches the hex pattern and some
  are 8-digit (`graphite.shadow.light.color == '#3333331A'`); no preset stores
  a derived size; `shadowsDerived` marks exactly the 8 expected ids; rem/em
  conversions (`claude` 3.84px → 0.24rem, `notebook` 0.5px → 0.03125em,
  `sage-garden` 3.68px → 0.23rem).
* `gen_app_theme_test.dart` — generates all 42 files into
  `.dart_tool/rearch_gen/`, then runs **one** `dart format
  --output=none --set-exit-if-changed` and **one** `dart analyze` over the
  directory (batched, ~3 s total) and requires exit 0 / `No issues found!`.
  Also: exact import list, values-only shape (no `if`/`for`/`while`/`class`,
  3 consts + 2 finals + 1 factory), no font block for `claude`, `--theme-import`
  redirection, `siblingUri`, camelCase validity for all ids.
* `generated_theme_test.dart` (5 runtime tests) — `generated_theme.dart` parses
  the generated source with `package:analyzer` and rebuilds real `ShadcnColors`/
  `ShadcnTokens` from the literals **in that file**, so the widget test really
  exercises generated values. For `claude` (legacy atoms, no fonts) and
  `graphite` (CLI atoms with alpha, 3 font slots), in **both** brightnesses,
  it pumps `ShadcnTheme` → `ShadcnTheme.of(context)` and asserts
  (a) primary colour equals the JSON literal, (b) `radius` equals the JSON
  rem value and `radiusMd == radius * 12`, `spacingBase == spacing * 16`,
  (c) `shadowSm` has 2 layers and its **second** layer equals the detail layer
  recomputed from the raw JSON atoms (`Offset(x,1)`, blur 2, spread −1, alpha
  byte = `colorA * opacity * 255`), `2xs`/`2xl` have 1 layer each and `2xl` is
  the stronger — plus a font-block test per preset and a third test that parses
  **all 42** generated files and compares every one of the 2 688 colour values
  with the JSON.
* `colour_parsing_test.dart` (7 tests) — 6-digit defaults to opaque; 8-digit
  keeps the alpha byte (string `#RRGGBBAA` ↔ int `0xAARRGGBB`); all 256 alpha
  bytes round trip; lower case accepted and normalised; `0x…`, `#FFF`, 10 digits
  and `rgb()` rejected; end-to-end graphite alpha (`0x1A * 0.15` → alpha byte 4,
  the legacy `0x04333333`) matching what the generated file produces; and no
  colour token ever gained an alpha suffix.

## 7. Decisions, deviations, caveats

1. **One-off converter kept** (`migrate_presets.dart`), as the brief asks. It is
   deterministic and idempotent: re-running produces byte-identical files
   (verified by `diff -r` against a copy, before and after the compaction in §8).
   It is *not* idempotent in one respect: it overwrites `<id>.json` and
   `index.json` but never removes a file whose preset disappeared, and it
   refuses to run if a legacy preset has no CLI entry.
2. **`radius` / `spacing` / `tracking` are top level, not per mode.** The brief
   lists them without a per-mode marker (only `shadow` is marked "per mode"),
   and the CLI never defines a differing `darkTokens` radius except for
   `sage-garden` and `tangerine`. The 10 presets with a differing legacy dark
   radius lose it (flagged **R**). If per-mode radius is wanted later, the
   schema change is `radius` → `radius: {light, dark}`; the data is in the CLI.
3. **`fonts`, `radius`, `spacing`, `tracking` and the shadow atoms carry no
   `$schema`-incompatible extras**: `shadowsDerived` was added as an optional
   provenance enum, which the brief implies (`mark "shadowsDerived":
   "from-legacy"`).
4. **`spacing: 0.24`** reads oddly next to the CLI's `0.25rem`. It is the
   legacy 3.84 px expressed in rem; `0.24 * 16 == 3.84` exactly, so no value is
   lost. 35 presets have no CLI `spacing` at all and inherit the legacy 3.84 px.
5. **Alpha in colour *maps* is still 0/42.** The legacy data has no translucent
   colour token (P1-D), so all 2 688 map values are 6-digit. The format, the
   parser, the generator and the tests all support 8 digits, and the migrated
   *shadow* colours already use them in **13 places** across 7 presets
   (`bubblegum`, `graphite`, `kodama-grove`, `mocha-mousse`, `perpetuity`,
   `quantum-rose`, `twitter` — every tweakcn `hsl(… / a)` or `rgba(…,a)` atom).
   The first CSS-imported preset will exercise the colour-map path.
6. **`lib/registry_next/themes/` has no README or index schema.** `index.json`
   is covered by the round-trip test instead. A `theme.index.schema.json` would
   be needed once the CLI serves the index over the network.
7. **Line counts.** `migrate_presets.dart` is 699 lines and `gen_app_theme.dart`
   464, over the ~400 guideline. Splitting would require a file outside this
   brief's Outputs (`tool/rearch/src/preset_migrate.dart`), which the hard rules
   forbid, so the guideline was traded away deliberately. `migrate_presets.dart`
   is a one-off migration script, not registry code, and the P2-B threshold is a
   warning anyway. `gen_app_theme.dart` at 464 is mostly the token list, the
   renderers and the 80-column layout logic.
8. **The generated `build<Id>Theme` is checked textually, not called.** Dart
   cannot import a file written at test time, so the widget test parses the
   generated source and rebuilds the values (which is stronger for the numbers
   but does not execute the factory). `dart analyze` proves it compiles and the
   test asserts its exact signature and wiring.
9. `.dart_tool/rearch_gen/` is scratch space. The round-trip test deletes only
   `*_app_theme.dart` in it before writing, because a stale file there would
   fail the `dart analyze` gate. Nothing outside that directory is touched.
10. `tracking.tight` / `tracking.wide` are in the schema and honoured by the
    generator, but no preset sets them, so `trackingTight`/`trackingWide` are
    never emitted today.

## 8. Gates (all run from `flutter_shadcn_kit/`)

```
dart format --set-exit-if-changed tool/rearch test/registry_next/themes
  → Formatted 28 files (0 changed)   exit 0
dart analyze tool/rearch test/registry_next/themes
  → No issues found!
flutter test test/registry_next/themes
  → 00:03 +26: All tests passed!   (26 tests)
flutter test test/rearch
  → 00:00 +33: All tests passed!   (existing tooling tests still green)
```

Extra checks:

* `flutter analyze` (whole package): **7 issues**, the same pre-existing ones in
  `tool/theme/` + `test/registry/` from the Phase 1 baseline. Nothing new.
* `dart run tool/rearch/check_layers.dart --root lib/registry_next` → 0 errors
  (4 pre-existing file-too-long warnings in `theme/`).
* `dart run tool/rearch/check_single_owner.dart --root lib/registry_next` →
  57 declarations, 0 duplicates (untouched: the tools live outside
  `registry_next`).
* `dart run tool/rearch/migrate_presets.dart` twice → byte-identical output and
  identical `--report` JSON.
* No `material.dart` / `cupertino.dart` import in any new file; no
  `ignore_for_file`.

## 9. Open questions for the orchestrator

1. **8 vs 3 presets without CLI shadow atoms** — accepted and flagged
   `from-legacy`; is that the intended marker, or should the CLI repo be asked
   to add the missing atoms for those 8?
2. **Per-mode radius dropped for 10 presets** (§7.2) — confirm light-only is
   the intended loss, or extend the schema to `radius: {light, dark}`.
3. **9 dark font overrides dropped** (§3.4) and **7 corrupt legacy font
   values** (§3.3) — the CLI values are used; confirm the legacy `\` values
   were indeed exporter corruption and not a deliberate escape.
4. **Should the old `lib/registry/themes_preset/` + `manifests/` be deleted at
   cutover**, or kept as the migration source? `migrate_presets.dart` needs them
   to run; re-run it before deleting.
5. **Split `migrate_presets.dart`** (§7.7) if a `tool/rearch/src/` helper file
   is allowed later.
6. `shadowsDerived` provenance is only meaningful while both sources exist; drop
   it (or keep it as documentation) once the legacy tree is gone.