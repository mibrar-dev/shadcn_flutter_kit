# flutter_shadcn_kit — Re-architecture Plan (draft v2, 2026-10-06)

## 1. Goals
1. Easy to read and contribute: few files per component, no duplication, no `part of`, no blanket `ignore_for_file`.
2. A standalone design system on `package:flutter/widgets.dart` only — a sibling of `material_ui` / `cupertino_ui` (Flutter 3.47 split). No Material/Cupertino imports anywhere.
3. CLI-installable: every component/shared module resolves its dependencies deterministically, and every symbol is installed exactly once.
4. Theming keeps today's token system and presets; token names match shadcn 1:1; every component has its own isolated, Studio-editable theme.

## 2. Baseline findings (measured)
| Area | Today |
|---|---|
| Components | 145 in 7 category folders, 1,800 Dart files, ~200k LOC, median 10 files/component |
| Largest | text_field 74 files, button 64 (7,770 LOC), form 52, error_system 42, shadcn_localizations 42, table 39 |
| Duplication | **148 classes/enums defined in more than one place.** `input` and `text_field` both define the same ~25 input-feature classes (and input depends on text_field → conflicts when both installed). autocomplete ↔ text_field share 10; form ↔ shared/primitives share 7 (FormKey, ValidationResult, FormValueSupplier…); tabs ↔ tab_container ↔ tab_pane share 21+ |
| Button variants | 6 wrapper classes × ~174 LOC that re-declare 25 props and only differ by ~5 lines of colour; 13 theme classes × 44 LOC; 15 style files re-implementing `WidgetStateProperty` |
| Per-component theme | 4 Dart config files (config/defaults/tokens/schema) + 13 variant theme files + `theme.schema.json`; a generated global registry importing every component's config |
| Global theme | `shared/theme` (~3.1k LOC) + 42 preset JSONs + 168 generated Dart preset files; CLI applies a theme by regex-patching the `ColorScheme(` block in Dart |
| Shared | 253 files / ~61k LOC, 61 shared IDs, no layering; `theme` used by 119 components |
| Material | ~20 component files import `material.dart` |
| Possible bug | `themes_preset/claude.json`: all 8 shadow sizes have identical values — shadow derivation looks wrong (verify in Phase 1) |
| CLI | v1 multi-registry rewrite done (328/328 tests). 4 uncommitted installer files + pubspec.lock |

## 3. Decisions (adopted defaults — correct any)
- Branch `refactor/rearchitecture` from `chore/upstream-parity-audit`; CLI uncommitted changes reviewed and committed separately first.
- Flat layout `components/<name>/`, category stored in `meta.json`.
- Consolidated APIs (e.g. `Button(variant: .ghost)`), old names kept one release as `@Deprecated` one-line aliases; CLI `migrate` command rewrites user code.
- Keep common callbacks only (`onPressed`, `onLongPress`, `onHover`, `onFocusChange`); rare gestures via `GestureDetector`.
- Replace `gap` and `data_widget` with local code in foundation.
- "Demo mode" = docs gallery + per-component `preview.dart`.

## 4. Target structure
```
registry/
  foundation/   L0  no deps: Gap, DataScope, geometry/platform helpers, constants
  theme/        L1  tokens, ShadcnTheme, ComponentTheme<T>, theme resolution
  primitives/   L2  clickable, focus, hover, overlay/popover, text, form_core, animation
  components/   L3  <name>/
                      <name>.dart          widget(s), state, layout, semantics
                      <name>_style.dart    <Name>Theme class, defaults from tokens, variant table
                      <name>_theme.dart    USER-OWNED overrides (values only; Studio rewrites it)
                      preview.dart
                      meta.json            single manifest (generated deps)
                      README.md            includes getting-started
  themes/           presets as JSON (42 kept); Dart generated on install only for the chosen preset
```

### Component code rules
1. Variants are data: one `enum` + one exhaustive `switch` style table. Never a class per variant.
2. One concept per component; different behaviour = its own small component (toggle, button_group).
3. Interaction lives in primitives (`Clickable` = hover/focus/press/keyboard/semantics).
4. State styling uses Flutter's `WidgetStateProperty` / `WidgetState` (from widgets.dart).
5. Split a file only by responsibility, and only when it passes ~400 LOC (`_controller.dart` if stateful).

## 5. Single-owner rule (shared code)
- **Every class/enum/extension/typedef is defined exactly once in the registry.** Enforced by `tool/check_single_owner.dart` (CI fails; baseline 148 → 0).
- Placement:
  - used by 1 component → lives in that component;
  - it is part of another component's public API (AutoComplete, input features) → it stays in that owner component; the others declare `components: [owner]` in meta.json and import it;
  - generic helper used by 2+ → moves to the lowest shared layer that fits.
- Known resolutions (final call in Phase 1 audit):
  - `input` + `text_field` → one component `input` (shadcn name) that owns the feature system; `text_field` becomes a deprecated alias.
  - `autocomplete` owns AutoComplete; `input` depends on it.
  - Form state (FormKey, ValidationResult, FormValueSupplier…) lives once in `primitives/form_core`; the `form` component only holds the Form UI.
  - tabs / tab_container / tab_pane → one owner for shared tab types.
- Layers only import downward (`tool/check_layers.dart`). `meta.json` dependencies are generated from real imports (`tool/gen_manifest.dart`) so they can never drift.
- CLI: topological install of shared → components; preflight refuses to install if a symbol would be defined twice in the target app.

## 6. Theming

### 6.1 Global tokens — identical to shadcn
Dart/JSON name = camelCase of the shadcn CSS variable, no renames. The current preset JSON already follows this; it stays.

| shadcn CSS | Theme JSON / Dart |
|---|---|
| `--background`, `--foreground` | `background`, `foreground` |
| `--card(-foreground)`, `--popover(-foreground)` | `card`, `cardForeground`, `popover`, `popoverForeground` |
| `--primary/secondary/muted/accent(-foreground)` | `primary`, `primaryForeground`, … |
| `--destructive` (+ legacy `--destructive-foreground`) | `destructive`, `destructiveForeground` (derived for contrast when absent, as in shadcn v4) |
| `--border`, `--input`, `--ring` | `border`, `input`, `ring` |
| `--chart-1..5` | `chart1..chart5` |
| `--sidebar(-foreground/-primary/-primary-foreground/-accent/-accent-foreground/-border/-ring)` | `sidebar`, `sidebarForeground`, … |
| `--radius` (+ derived sm/md/lg/xl) | `radius` |
| `--font-sans/-serif/-mono` | `fontSans`, `fontSerif`, `fontMono` |
| `--tracking-normal`, `--spacing` | `tracking.normal`, `spacing.base` |
| `--shadow-color/-opacity/-blur/-spread/-offset-x/-offset-y` → `--shadow-2xs..2xl` | `shadows.shadow2xs..shadow2xl` (derived per size, not copied) |

Light + dark for every color token. All 42 existing presets are kept and re-validated against the schema.

### 6.2 CLI theme converter (future feature; designed for now)
`shadcn theme import <file.css | url | theme.json>`
- Parses shadcn / tweakcn CSS (`:root {}` + `.dark {}`), colors in oklch / hsl / hex / rgb; oklch → sRGB with gamut clamping.
- Output: canonical theme JSON (schema-validated) → generated `lib/ui/shadcn/theme/app_theme.dart` (values-only file, fully rewritten; no regex patching).
- Missing tokens fall back to derivation (destructiveForeground, sidebar*, shadows, radius steps).
- Fixtures: the 10 CSS files in `themes-css/` + 42 presets; round-trip tests (CSS → JSON → Dart → compare).

### 6.3 Per-component themes — isolated and Studio-editable
Resolution order for every property:
`widget argument  >  nearest ComponentTheme<ButtonTheme> in the tree  >  app overrides in button_theme.dart  >  defaults derived from global tokens`

- `button_style.dart` (registry-owned logic): `ButtonTheme` with nullable fields, `copyWith`, `merge`, `lerp`; defaults computed from tokens; variant table. CLI updates may replace this file.
- `button_theme.dart` (user-owned, values only): per-variant overrides. **CLI updates never overwrite it.** Values can be token references (`ThemeRef.primary`) or literals, so a customised button still follows preset switches unless a literal was chosen.
- A button override only touches `ButtonTheme`; no other component reads it → full isolation.
- The editor schema is **generated** from the `ButtonTheme` fields (`tool/gen_theme_schema.dart`) — replaces the hand-maintained `theme.schema.json` + `*_theme_schema.dart` + config/defaults/tokens files.
- The CLI generates one `component_themes.dart` registry containing only the components installed in that app (replaces the global 145-import file).

### 6.4 Studio theme builder (future; contract fixed now)
1. Studio scans the lockfile → installed components.
2. Reads each component's generated schema → renders editor controls.
3. On save, rewrites only that component's `<name>_theme.dart` (deterministic, formatted output) → hot reload.
4. Global tokens are edited the same way via `app_theme.dart`.

### 6.5 Theme code minimization (targets)
Measured today: component theme code = 370 Dart files / 33k LOC + 142 `theme.schema.json` + 141 `*.meta.json`;
global theme = 27 Dart files / 9.3k LOC (`preset_themes.dart` alone 4.4k) + 168 generated preset files.

| Today | Target |
|---|---|
| per component: `_impl/themes/base`, `config/{config,defaults,tokens,schema}`, `variants/*` (button: 18 files) | `<name>_style.dart` (theme class + token defaults + variants) and user-owned `<name>_theme.dart` — 2 files |
| `theme.schema.json` + `*.meta.json` + `meta.json` | one `meta.json` (install deps, docs metadata, generated `theme` editor schema section) |
| global `component_theme_global_configs.dart` importing all 145 | generated in the user app for installed components only |
| `shared/theme` 27 files | ~5 files: `tokens.dart` (ColorScheme, radius, shadows, fonts, spacing), `theme.dart` (ShadcnTheme, ThemeData, ComponentTheme<T>, lerp/animated), `typography.dart`, `density.dart` (merged adaptive scaling), `color_utils.dart` (shades/HSL) |
| `preset_themes.dart` (4.4k LOC, all 42 presets) + 168 generated preset files | presets stay JSON only; CLI generates one `app_theme.dart` for the chosen preset |
| `component_schema.dart` 738 LOC hand-written schema model | schema generated by `tool/gen_theme_schema.dart`; small runtime model only if Studio needs it |

## 7. Agent team
| Role | Model |
|---|---|
| Planner / architect | `opencode-go/muse-spark-1.3-contributor` (max reasoning) |
| Builder A | `opencode-go/deepseek-v4.1-flash` (max reasoning) |
| Builder B / bug hunter | `opencode-go/space-bunny-free` (max reasoning) |
| Mechanical (barrels, manifests, analyze runs) | `opencode/fledge-alpha-free` (Zen free tier) |
| QA reviewer (large context) | Gemini CLI `gemini-3.1-pro` |
| UI check (vision) | Gemini CLI `gemini-3.8-flash` |
| Orchestrator + final QA gate | Claude (this session) |
Antigravity `agy` symlink is broken → Gemini models via Gemini CLI 0.58.
Phase 0 result: all four OpenCode models respond. Gemini CLI OAuth fails with quota exhausted ("Resource has been exhausted") and no API key is set → until it recovers, QA review uses `muse-spark-1.3-contributor` and UI vision checks use `opencode-go/deepseek-v4-flash-vision-exp`. No Claude subagents.

## 8. Loop per component
1. **Plan** (muse-spark): file split, owner decisions for shared symbols, API + migration aliases.
2. **Build** (deepseek / space-bunny, separate worktrees, waves of 5–8).
3. **Test**: `flutter analyze` (0 new issues), widget tests, `check_layers`, `check_single_owner`, no material/cupertino import, CLI install into a scratch app compiles together with its dependents.
4. **QA review** (Gemini Pro + Claude): conventions, exported-symbol diff, theme resolution order.
5. **UI check** (Gemini Flash vision): preview screenshots light/dark + 3 presets, pixel diff vs baseline.
6. **Find bugs** (space-bunny): focus/keyboard, RTL, disabled, dark mode, theme overrides isolated.
Fail → back to Build with findings; 3 failed rounds → escalate to Claude. One commit per passing component.

## 9. Phases
0. **Baseline** — branch; commit CLI changes; record analyzer count, tests, screenshots of every preview, CLI install of all 145; verify Gemini model access.
1. **Audit (read-only)** — dependency graph, the 148 duplicates with owner decisions, dead code, preset shadow bug; draft ARCHITECTURE v2 + CONTRIBUTING. → **user review**
2. **Foundation + theme + primitives** — layers, token system (6.1), ComponentTheme resolution (6.3), check/gen scripts. Sequential.
3. **Pilot**: button, input (merged with text_field), dialog — full loop incl. Studio-style rewrite of `button_theme.dart`. → **user review**
4. **Migrate remaining components** by category through the loop.
5. **CLI**: flat paths, topological shared install, single-owner preflight, user-owned theme files preserved on update, `migrate` command, theme JSON → Dart generation. (Theme CSS importer + Studio builder can follow as separate work on top of this contract.)
6. **Docs gallery + mirror sync, full QA, PR.**
