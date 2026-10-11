# P6 — Docs Website Build Plan (Flutter web, from the new registry)

Status: **planning (read-only)**. No app code is written here. This plan turns
the accepted Open Design mockups (`rearch/design/docs/*.html`, 13 screenshots
in `screens/`, spec `rearch/reports/P6_DOCS_DESIGN.md`) into a Flutter web app
at `$KIT/docs/` built ONLY on the post-cutover registry
(`flutter_shadcn_kit/lib/registry/`: `foundation/`, `theme/`, `primitives/`,
`components/<name>/`, `themes/` + manifest `lib/registry/manifests/registry.json`,
schema `rearch/reports/registry_manifest.v2.schema.json`).

Binding ground rules (from the user):

1. The docs app CONSUMES components the way a user would: installed with the
   new CLI (`flutter_shadcn init` + `add --all`) into
   `docs/lib/ui/shadcn/{foundation,theme,primitives,components/<name>}`.
   Until the new CLI lands, a temporary mirror copy of that same layout is
   acceptable (same files, same paths). The final step re-installs via the CLI
   and must produce no diff (CI-enforced, §7).
2. Modern, motion-rich, exactly per the mockups + motion spec; widgets-only
   (no `package:flutter/material.dart`, no `cupertino.dart`) wherever the kit
   provides it; `prefers-reduced-motion` respected.
3. All component facts (API params, theme fields, deps, file counts, keyboard
   tables, stats) are GENERATED from the real registry (manifest + meta.json +
   README.md + source via `package:analyzer` at build time / a codegen tool) —
   never typed by hand. Live previews use each component's `preview.dart`.

## 0. Verified inputs (measured 2026-10-09)

- **Registry**: 118 component dirs under `lib/registry_next/components/`;
  categories measured from `meta.json`: display 28, form 29, navigation 8,
  overlay 20, control 6, layout 21, utility 6 (= 118). 42 presets +
  `index.json` (`schemaVersion: 2`, `count: 42`) + `themes.schema.json`.
- **Theme layer** (`lib/registry_next/theme/`, 6 files): `theme.dart` (456
  lines) already provides `ShadcnTheme`, `AnimatedShadcnTheme`
  (`ImplicitlyAnimatedWidget`, takes `data` + `duration` + `curve`),
  `ShadcnThemeData.lerp`, `ShadcnThemeDataTween`, `ComponentTheme<T>`,
  `ComponentThemes`, `resolveComponentStyle`. `gen_app_theme.dart` is
  VM-safe (no Flutter import) and emits values-only `app_theme.dart`
  (`build<Id>Theme(Brightness)`) from any preset JSON; 32 colour tokens in
  `colorTokenKeys`.
- **App shell**: `app` component exports `ShadcnApp`, `ShadcnUI`
  (WidgetsApp-based shell installing theme + ComponentThemes + overlay
  manager + localizations). `page_route` component = widgets-only page route
  with the shadcn fade + slide transition.
- **Mockups**: 10 HTML files, 1962 lines total; 13 PNGs in `screens/`
  (desktop-1440 full-page for all 10, 375px for landing + button, one
  light-mode × tangerine shot). Landing defaults to
  `data-theme="dark" data-preset="modern-minimal"`.
- **Coverage check** (every P6_DESIGN §"Component mapping" id vs the tree):
  all exist EXCEPT `popover` and `chart`. `popup` (anchored floating surface,
  tags include `popover`) covers popover demos; the themes-dashboard bar chart
  has no registry component and must be docs-only (§4 deviations). `tabs`
  depends on the `sortable` component (component→component edge) — `add --all`
  covers it, but the codegen must list it in the install tab.
- **Current docs app**: Material-based (`main.dart` 520 lines, go_router with
  ~17 routes, `syntax_highlight` highlighter, `shared_preferences` settings,
  `web_bridge*.dart` js_interop custom events, `loaders/docs_image_loader.dart`
  256 lines, `theme/` controller 531 lines over the OLD generated
  `preset_themes.dart`, `scripts/` sync/install/generate/barrel/refresh,
  deploy `.github/workflows/docs-deploy.yml` via
  `bluefireteam/flutter-gh-pages@v9`, `workingDir: docs`,
  `baseHref: /shadcn_flutter_kit/`, `webRenderer: canvaskit`).
- **meta.json shape** (button/dialog/command verified): `api` =
  `{classes, enums, constants, functions, types, ...}` (free-form keys, used
  for the CLI single-owner preflight); `theme` =
  `{class, userFile, defaults, fields: {field: "Type? - description"}}`;
  `deps` = `{foundation, theme, primitives, components}`; `files[]` excludes
  `preview.dart` and user-owned files. `import` strings still omit
  `components/` (P5 §3 discrepancy — fixed at cutover per orchestrator
  decision 6; the docs install tab must render the corrected path).
- **READMEs**: API tables, theme-resolution notes and keyboard/behavior notes
  exist but keyboard/a11y sections are NOT uniform (dialog documents
  Esc/Tab-trap/focus-restore in prose; command mentions arrow keys inline).
  Codegen parses them heuristically and marks gaps explicitly (§5).
- `analyzer: ^6.4.1` is already a dev dependency of `flutter_shadcn_kit` —
  the codegen tool lives in the kit package and uses `parseString`.

## 1. Architecture

### 1.1 App shell

- Root: `ShadcnApp.router` (registry `app` component) with a docs-level
  `RouterDelegate` (§1.2). No `MaterialApp`/`CupertinoApp` anywhere.
- Above the router: `DocsState` (docs-only `ChangeNotifier`: preset id,
  brightness, radius, density scale) → `AnimatedShadcnTheme(duration: 300ms,
  curve: ease-out-expo)` → `ShadcnTheme` + `ComponentThemes`. Persistence via
  `shared_preferences` (plugin only, no Material dependency — UNVERIFIED that
  the current version pulls no Material widgets into the tree; batch D1
  verifies with `flutter build web --analyze-size` + import scan, else replace
  with `window.localStorage` via `package:web`).
- Global overlay entries owned by the shell: command palette route (§1.2),
  toast layer (registry `toast`), web-bridge theme events (keep the
  `web_bridge*.dart` pattern, re-emit on `ShadcnThemeData` change).
- Fonts: keep the checked-in Geist Sans/Mono `@font-face` wiring
  (`docs/assets/fonts/`, `web/index.html`); the theme fonts block comes from
  the preset JSON like any other token.

### 1.2 Routing — minimal router, NOT go_router

Decision: a docs-only `RouterDelegate` + `RouteInformationParser` (~150
lines), transitions via the registry `page_route` component
(`ShadcnPageRoute`: fade + 8px rise, 200ms in / 120–150ms out per spec).

Justification:

1. Route table is tiny and static: `/`, `/docs`, `/docs/installation`,
   `/docs/cli`, `/docs/components`, `/docs/components/:id`, `/themes`,
   plus the palette as a root overlay entry. go_router's matching, guards
   and redirection buy nothing here.
2. Transitions must be the registry transition, not go_router's
   Material/Cupertino defaults — with a custom delegate the registry route
   is the ONLY route class, so mockup fidelity is structural, not patched.
3. One fewer third-party dependency in the docs pubspec; deep-linking, back
   button, URL sync and prev/next pager are all covered by the Router API
   (`RouteInformationReporting`, `BackButtonDispatcher`).
4. The palette (`⌘K` anywhere, `/` on the index, `Esc` unwinds with focus
   restore) is a root-level overlay entry owned by the delegate, matching
   mockup 09 exactly (dimmed inert backdrop + 640px panel).

UNVERIFIED: whether `go_router`'s own source imports `material.dart` (if it
does not, keeping it would still be defensible on familiarity grounds, but
reasons 1–2 stand on their own; the delegate stays the default).

### 1.3 State (theme mode, preset, density/radius)

- Single `DocsState extends ChangeNotifier` (docs-only, `lib/state/`):
  `presetId` (default `modern-minimal`, matching the mockups — NOT the CLI
  `--yes` default `vercel`, which is for user apps), `brightness`
  (default dark, matching the mockups), `radius` (0–16px slider →
  `--radius`), `densityScale` (85–115%).
- Derived per build: `ShadcnThemeData` = `build<Preset>Theme(brightness)`
  (generated `app_theme.dart` output, checked in) with radius/density applied
  on top. Preset switch and mode switch both go through
  `AnimatedShadcnTheme` 300ms — colour tween only, layout untouched (spec).
- Persist `presetId/brightness/radius/densityScale` (shared_preferences or
  localStorage, see §1.1). No URL-sync of theme state (mockups show
  `<select>` + toggle only; deep links stay clean).

### 1.4 Live re-theming

`AnimatedShadcnTheme(data: next, duration: 300ms, curve: Cubic(0.16,1,0.3,1))`
sits above `ShadcnApp.router`'s child (or wraps the app; exact placement
verified in D1 against `AnimatedShadcnTheme` + `ShadcnApp` interplay —
`ShadcnThemeData.lerp` already exists so no docs-side lerp code is written).
Open dialogs re-resolve per build (registry dialog behaviour, verified in its
README) so the themes-dashboard + preset switcher re-theme live surfaces.

### 1.5 Search index (generated)

`docs_data.dart` (§5) emits `kDocsSearchIndex: List<DocsSearchEntry>` with
118 component entries `{id, name, category, fileCount, route}` + command
entries (install/add/theme/preset strings) + preset entries (42). Components
index filters locally (live count `n of 118 shown`); palette groups results
(Components / Commands / Presets) with wrap-around arrow nav and manual
scroll-window math (no `scrollIntoView`, per mockup 09 lint fix).

### 1.6 Code highlighting — replace `syntax_highlight`

The mockups use a 4-class token scheme (base, muted `.c` comment, keyword
`.k`, string `.s`) on a dark code surface in BOTH modes. The codegen (§5)
emits per-snippet `TextSpan` trees built with `package:analyzer` Dart
tokenizer + tiny regex grammars for `bash`/`json`/`yaml` (install commands,
theme JSON), rendered inside the registry `CodeSnippet` component (classes:
`CodeSnippet`, `CodeSnippetTheme`). `syntax_highlight` and its async
theme-loading `FutureBuilder` path are deleted; highlighting is synchronous,
zero-dependency, and matches the mockup colours by construction. Copy buttons
reuse the 1.5s Copied pattern (registry button + toast).

### 1.7 Web build + GitHub Pages deploy

- Keep `.github/workflows/docs-deploy.yml` shape (flutter-gh-pages,
  `workingDir: docs`, `baseHref: /shadcn_flutter_kit/`); batch D1 verifies
  the pinned action version + renderer flag still work on stable and updates
  only what is broken. Keep `docs/web/index.html` (update title/meta/
  description; keep `$FLUTTER_BASE_HREF`).
- Keep the `web_bridge` ready/theme-changed custom events (adapted to
  `ShadcnThemeData`; used by embedders, harmless otherwise).

### 1.8 Performance budget

- First paint: landing route ships only shell + landing widgets; ALL 118
  `preview.dart` files are `deferred as` imports, one per component page
  (deferred loading per component page). The generated `docs_data.dart` is
  data-only (no widget imports) so the search index + catalog cost ~0.
- `app_theme.dart` contains all 42 presets' `build<Id>Theme` factories;
  trees-shaking keeps it small (const colour maps); verified by
  `--analyze-size` in D1 with a written budget (UNVERIFIED exact KB until
  measured — D1 records `main.dart.js` size for landing and for a component
  page and stores the numbers in this file's successor note).
- Reveal-on-scroll uses a single shared `ScrollNotification` observer, not
  one `IntersectionObserver` per section; marquee is a single
  `overflow_marquee` instance with the full 118-name list.

## 2. Codegen — `docs/tool/gen_docs_data.dart`

Lives in the DOCS package (`docs/tool/`, runnable with
`dart run tool/gen_docs_data.dart --registry <path> --out lib/generated/`),
NOT in the kit package (it reads the kit tree + manifest as INPUT). It may
import `package:analyzer` — so `analyzer` must be added to `docs/pubspec.yaml`
`dev_dependencies` (allowed: the brief's pubspec rule is about the kit tree,
and this is build-time-only; it never ships in `main.dart.js`).

### 2.1 Exact inputs

1. `--registry` root (post-cutover `flutter_shadcn_kit/lib/registry/`):
   `manifests/registry.json` (file list, deps, api symbols, theme class refs,
   preset ids, `fileHashes`), `themes/*.json` + `themes/index.json`.
2. Per component `components/<id>/`: `meta.json` (fallback when the manifest
   is stale), `README.md` (snippets, tables, keyboard prose), `<id>.dart`
   + `<id>_style.dart` (analyzer source for API/theme extraction),
   `preview.dart` (only to record its exported preview class name —
   `<Pascal>Preview` — NEVER imported by the tool).
3. `docs/tool/cli_snapshot.txt` (hand-maintained paste of
   `flutter_shadcn --help` output per command; the CLI reference page renders
   it inside `CodeSnippet` + generated flags tables — see §4, CLI page).

### 2.2 Exact outputs (all under `docs/lib/generated/`, all `// GENERATED` + `dart format` clean)

- `docs_data.dart` — `kComponents: List<DocsComponent>` (`id, name, category,
  description, install, import, fileCount, stability`), `kPresets`
  (42 ids + names + modes), `kStats` (`components: 118`, `presets: 42`,
  `materialImports: 0`, `modes: 2` — each with its derivation comment so the
  landing stats band can never be hand-typed).
- `docs_api.dart` — per component `DocsApiTable` (constructor params from the
  analyzer: `name, type, default, doc` — required-first order) and
  `DocsThemeTable` (fields from `<Name>Theme` in `<id>_style.dart` +
  user-owned file badge from `userOwned`). Components whose entry file has no
  analyzer-readable constructor (e.g. `popup`'s function-first API) emit an
  empty table + `hasApiTable: false`; the page then shows snippets only.
- `docs_tables.dart` — `keyboardRows` per component parsed from README
  sections whose heading matches `/keyboard|a11y|accessib|behavior|behaviour/i`
  (prose → `key`/`action` rows via a small documented heuristic; components
  with no match emit `[]` and the page HIDES the keyboard table — never render
  invented rows), `depChips` (union of manifest `deps`, with component→component
  edges flagged, e.g. tabs→sortable), `relatedIds` (same category, max 3).
- `docs_search.dart` — `kDocsSearchIndex` (§1.5).
- `docs_snippets.dart` — highlighted `TextSpan` builders for every README
  ```dart/```bash/```json block reused on pages (§1.6) + install-tab manual
  file lists (`files[]` + ownership note "user-owned `*_theme.dart` is never
  overwritten").
- `app_theme.dart` — byte-identical output of kit `gen_app_theme.dart` run
  over all 42 presets with `--theme-import` pointed at the docs mirror
  (`package:docs/ui/shadcn/theme/theme.dart` sibling libs). A test asserts
  byte-equality with the kit generator's output for the same presets.

### 2.3 CI freshness (`--check` mode)

`gen_docs_data.dart --check` regenerates into memory and diffs against the
checked-in files; non-empty diff fails CI. A second job, `mirror-check`,
asserts the temporary mirror equals the registry tree: for every relPath in
the manifest, `sha256(docs/lib/ui/shadcn/<path>) == fileHashes[path]`, and no
extra `.dart` files exist under the mirror. The final CLI-install step
(`flutter_shadcn init --theme modern-minimal && flutter_shadcn add --all`
over a clean checkout) must leave `git status --porcelain docs/lib/ui/shadcn`
empty — this is the acceptance gate for ground rule 1.

## 3. Page → widget map (every mockup element → registry component or docs-only)

Conventions: `R:<id>` = registry component consumed from the docs mirror
(`package:docs/ui/shadcn/components/<id>/<id>.dart`); `D:` = docs-only widget
(`lib/widgets/`, kept few + simple per the design). Every page composes the
docs shell (§3.2).

- **01 landing** (`/`): frosted sticky nav → D:TopBar (ColoredBox + blur,
  content: R:button link rows, R:badge version, R:button icon theme-toggle +
  GitHub, CTA R:button primary). Hero grid → D:Hero (headline Text,
  install `CodeBlock` = R:code_snippet + 1.5s Copied R:button, CTAs R:button,
  6-preset switcher = R:chip select chips driving `DocsState.setPreset`).
  Collage (8 live pieces) → R:button row, R:switch, R:card, R:input,
  R:tabs, R:calendar, R:toast demo button, ⌘K bar (R:button opening the
  palette). Stats band → D:Stats (values ONLY from `kStats`). Feature grid
  (6) → R:card. Marquee → R:overflow_marquee with all 118 names from the
  search index. 3-step cards (code) → R:card + R:code_snippet. CTA band +
  4-col footer → D:Footer (Text + R:button link style).
- **02 docs shell** (wrapper for all `/docs*` + `/themes`): 270px sticky
  sidebar → R:navigation_menu (4 section groups, active = accent fill + ring
  edge, file-count R:badge chips) + palette-open R:button with ⌘K hint;
  top bar → R:select preset + theme toggle + GitHub R:button; content max
  768px; sticky TOC → R:scrollable + D:ScrollSpy (scroll offset listener);
  breadcrumb → R:breadcrumb; prev/next pager → R:button outline (lift 2px
  hover); mobile `<760px` → R:drawer + hamburger (shares dialog dismissal
  contract per design).
- **03 component template** (`/docs/components/:id`, Button instance):
  title + file-count R:badge + stability R:badge; install tabs
  (CLI | manual) → R:tabs (manual lists generated `files[]` + user-owned
  note); preview card → R:card stage + D:PreviewControls (R:tabs segmented
  variant/size, R:switch disabled, R:select mode/preset) bound to a
  `StatefulWidget` rendering the DEFERRED `preview.dart` export
  (`ButtonPreview`) with per-control narrowed demos (NOT the whole gallery —
  the full gallery renders below in "Examples"); gallery (4 examples) →
  R:card grid with generated snippets; API table → R:table from `docs_api`;
  theme-fields table → R:table + user-owned file R:badge; keyboard table →
  R:table from `docs_tables` (hidden when empty); dependency chips →
  R:chip; related cards (3) → R:card.
- **04 dialog instance**: same template; preview controls = mode/preset/
  scrim-dismiss R:switch; live modal via `showShadcnDialog` (scrim/Esc/
  buttons, focus to first field, focus restore — all registry-owned).
- **05 components index** (`/docs/components`): sticky toolbar → R:input
  search (`/` focuses) + 6 category R:chip pills (ALL + display/form/
  navigation/overlay/control/layout/utility — 7 counting All; the mockup's
  "6 category pills" = All + 5 shown... UNVERIFIED exact pill set until the
  HTML is re-read in D3; pills are generated from manifest categories so any
  count is correct by construction) + live count Text; 24 representative
  cards → generated catalog (ALL 118, filterable; mockup shows 24, build
  shows all) each R:card with D:MiniPreview (pure-widget sparkline per
  category — docs-only, token-coloured) + file-count R:badge; empty state →
  D:EmptyState (Text + reset R:button).
- **06 themes** (`/themes`): 12-preset live gallery in the mockup becomes
  ALL 42 generated preset cards → R:card (4 D:Swatch circles each —
  docs-only, selection ring, badge syncs to `DocsState`); dashboard →
  R:card KPIs (4), D:BarChart (docs-only CustomPaint, bars use
  `chart1..chart5` tokens — deviation, no registry chart), R:table team
  table with R:badge pills, form row (R:input + R:button); token table
  (8 rows, CSS→Dart names) → R:table from generated token map;
  radius slider (0–16) → R:slider → `DocsState.setRadius`; density slider
  (85–115%) → R:slider; Copy JSON / Copy Dart R:button (1.5s feedback);
  Studio teaser → R:card dashed (docs-only border style).
- **07 getting started** (`/docs/installation`): 4-step timeline →
  D:Timeline rail (numbered, per-step time R:badge chips, R:code_snippet
  blocks with copy) + verify checklist (3 rows, R:checkbox disabled-checked
  or D:CheckRow) + pager; reveals staggered 40ms (§4).
- **08 CLI reference** (`/docs/cli`): 4 command cards
  (add/init/theme/list·remove·doctor) → R:card each with syntax
  R:code_snippet (from `cli_snapshot.txt`) + flags R:table (generated from
  the snapshot by a documented line parser; UNVERIFIED until the new CLI
  `--help` text exists — page falls back to snapshot-only rendering if a
  command section is missing, never invented flags).
- **09 palette** (overlay, any route, ⌘K): dimmed inert D:Scrim +
  640px R:dialog-styled panel (or R:command `showCommandDialog` if its
  API fits the mockup's grouped rows + footer hints — D4 spikes this and
  picks exactly one; fallback is a docs-only panel reusing R:input rows)
  with wrap-around arrows, Enter navigates, Esc closes + focus restore,
  manual scroll-window math.
- **10 mobile** (responsive states, NOT a route): three 375px D:DeviceFrame
  frames (notch, compact nav) reusing the real landing/component/drawer
  widgets at 375px constraints — docs-only chrome around registry content;
  breakpoint table → R:table.

Deviations from P6_DESIGN §mapping (all forced by verified registry facts):
chart bars → D:BarChart; popover/tooltip demos → R:popup / R:tooltip;
phone frames, dot-notch, swatches, KPI deltas, breakpoint wrapper stay
docs-only. No other docs-only widgets may be added without updating this
section.

## 4. Motion implementation map (spec item → Flutter mechanism)

Ease constant `kEaseOutExpo = Cubic(0.16, 1, 0.3, 1)` lives once in
`lib/motion/ease.dart`; durations 150/200/300/500ms as constants. Exits use
`Curves.easeIn` 150ms. Reduced-motion (see bottom) overrides ALL of these.

| Spec item | Mechanism |
|---|---|
| Page/route fade + 8px rise 200ms | `ShadcnPageRoute` (R:page_route) used by every delegate push; reverse 120–150ms ease-in |
| Reveals fade + 12px rise 300ms, 40ms stagger, once | D:Reveal (docs-only; single shared scroll observer via `ScrollNotification`, `AnimatedOpacity` + `SlideTransition`, `Interval`-staggered; fires once per element) |
| Cards lift 2px + shadow-sm→md 150ms | R:card hovered state via R:clickable `Hover` primitive (colour/shadow only, no layout shift — translate via `Transform.translate` 2px inside the card, spec's "lift" without reflow) |
| Buttons colour-only | Free from R:clickable (no scale/translate on press — enforced in review) |
| Preset switch = colour tween 300ms, layout untouched | `AnimatedShadcnTheme` 300ms + kEaseOutExpo (§1.4); assert in D6: no `layout`/`size` animation widgets on the preset path |
| Hero pieces spring in (50ms stagger) then idle float ±3px/6s | Entrance: `CurvedAnimation(Cubic(0.34, 1, 1.4→clamped, 0.64, 1))` — overshoot ≤4px asserted by test on the curve's max deviation; idle: single looping `AnimationController` 6s sine ±3px shared by all pieces (one ticker, offsets by phase) |
| Copy = 1.5s Copied state | D:CopyButton (R:button ghost + `Timer` 1.5s label swap + R:toast on fleet paths) |
| Scrim fade 150ms | Registry dialog/drawer/palette barrier (owns its animation; docs pass `transitionDuration` only where the theme exposes it, e.g. `DialogTheme.transitionDuration` default 150ms) |
| Dialog scale .96→1 + fade 200ms | Registry R:dialog (verified behaviour; docs do not re-implement) |
| Drawer slide 200ms | Registry R:drawer |
| Palette scale .97→1 + fade 200ms | Chosen palette implementation (§3, 09); docs-side tween only if docs-only fallback wins the spike |
| Marquee 40s loop, pause on hover | R:overflow_marquee (`duration: 40s`, hover-pause prop — UNVERIFIED prop name until source read in D3; wrap in D: if the registry API differs, note the delta here) |
| `prefers-reduced-motion` | D:MotionScope (`MediaQuery.disableAnimations` + `window.matchMedia` via `package:web` at startup → `ValueNotifier<bool>`): no transforms, opacity-only ≤150ms, marquee/float off, reveals render visible immediately |

## 5. Old docs code: delete / keep / rewrite

| Path | Disposition | Notes |
|---|---|---|
| `lib/main.dart` | REWRITE | New shell (§1.1–1.4), ~120 lines; deferred-preview registry; no Material |
| `lib/pages/**` (all, incl. `components/*_page.dart` ×118) | DELETE | Replaced by shell + landing + index + template + themes + install + CLI ref + generated data; 118 hand pages collapse into ONE template route |
| `lib/code_highlighter.dart` | DELETE | Replaced by generated spans + R:code_snippet (§1.6) |
| `lib/web_bridge*.dart` (3 files) | REWRITE (keep pattern) | Same custom events over `ShadcnThemeData`; ~30 lines total |
| `lib/loaders/docs_image_loader.dart` | DELETE | UNVERIFIED whether any `assets/docs_images` reference survives the redesign — D1 greps; if orphaned, delete loader + images |
| `lib/theme/**` (2 files, 531 lines) | DELETE | Replaced by `DocsState` + generated `app_theme.dart` |
| `lib/ui/shadcn/**` (old mirror, category dirs) | DELETE + re-mirror | Flat-layout mirror of post-cutover registry (§2.3 freshness job) |
| `lib/shadcn.dart`, `lib/shadcn_ui.dart`, `lib/debug.dart` | DELETE | Barrel dropped per CLI decision 4; debug helpers re-added only if needed |
| `tool/generate_component_pages.dart`, `scripts/*.py` (5), `scripts/*.dart` (2) | DELETE | Replaced by `docs/tool/gen_docs_data.dart` + `mirror-check`; no Python in the loop |
| `pubspec.yaml` | REWRITE deps | Keep: `flutter` (widgets-only usage), `shared_preferences` (or localStorage — D1 decides), `intl`/`flutter_localizations` (registry localizations contract), `analyzer` (dev, codegen). Drop: `go_router`, `syntax_highlight`, `font_awesome_flutter`, `gap`/`data_widget` (registry foundation owns these now), `skeletonizer`/`country_flags`/`phonecodes`/`email_validator`/`expressions`/`animation_kit`/`cross_file`/`file_picker`/`widget_visibility_checker`/`visibility_detector` (re-add ONLY with a per-dep justification line; `visibility_detector` may survive for D:Reveal — D3 decides). Add nothing Material-pulling — every candidate dep gets an import scan in D1 |
| `web/index.html` | KEEP + edit | Title/meta/description; keep base-href placeholder |
| `assets/fonts/**` (Geist) | KEEP | Mockups are Geist-first; theme font stacks reference them |
| `assets/registry/components.json`, `assets/markdown/**`, `assets/docs_images/**`, `docs.json` | DELETE unless D1 proves a reader | Generated data replaces the JSON; markdown assets replaced by R:markdown + generated spans |
| `.shadcn/`, `shadcn.lock` (v1) | DELETE + regenerate | New CLI `init`/`add --all` writes lock v2 |
| `test/**` | REWRITE | Codegen golden tests + `--check` wiring (no 118 page tests — template tested once with 3 sample ids) |
| `.github/workflows/docs-deploy.yml` | KEEP + verify | D1 proves the pinned action + renderer on current stable; minimal edits only |

## 6. Build batches (parallel agents, each ≤ ~3k LOC, exact outputs + deps)

Ordering: D1 → {D2 ∥ D3} → D4 → D5 → D6. D2 (codegen) and D3 (shell/pages
against a STUB `generated/` checked in by D1) run in parallel; D4 consumes
both. Total estimate ~9–11k LOC, two-thirds generated.

- **D1 — Shell, router, state, pubspec, deploy proof** (~900 LOC hand-written).
  Outputs: `docs/pubspec.yaml` (rewritten deps + justification comments),
  `lib/main.dart`, `lib/state/docs_state.dart`, `lib/motion/ease.dart` +
  `lib/motion/motion_scope.dart`, `lib/routing/docs_router.dart`
  (delegate + parser + palette overlay entry),
  `lib/generated/stub_docs_data.dart` (typed stub with 3 sample components so
  D3 compiles; DELETED by D2), `lib/web_bridge*.dart` (rewritten),
  `web/index.html` edits, `.github/workflows/docs-deploy.yml` verification
  note. Proves: `flutter analyze` 0 issues, `flutter build web` succeeds,
  `--analyze-size` budget recorded, no `material.dart`/`cupertino.dart`
  import anywhere (`grep -rn` gate), deploy action still valid.
- **D2 — Codegen + generated data** (~700 LOC tool + generated outputs).
  Outputs: `docs/tool/gen_docs_data.dart`, `docs/tool/cli_snapshot.txt`,
  `lib/generated/{docs_data,docs_api,docs_tables,docs_search,docs_snippets,app_theme}.dart`,
  `docs/tool/gen_docs_data_test.dart` (goldens: button/dialog/command API +
  theme tables vs checked-in expectations; byte-equality of `app_theme.dart`
  vs kit generator output; `--check` self-test). Deletes the D1 stub. Needs:
  post-cutover registry + manifest (read-only). Proves: `dart format` clean,
  `--check` passes, keyboard-table gaps listed (never filled by hand).
- **D3 — Landing, shell, palette, index** (~2200 LOC).
  Outputs: `lib/widgets/{top_bar,hero,collage,stats,marquee_section,steps,footer,
  docs_shell,scroll_spy,search_toolbar,mini_preview,device_frame,copy_button,
  reveal,code_block}.dart`, `lib/pages/{landing,index,component_template_scaffold}.dart`,
  palette implementation (spike R:command vs docs-only recorded in-code).
  Needs: D1 shell + D2 data (or D1 stub for layout start). Proves: routes
  `/`, `/docs`, `/docs/components` render in both modes; `/` focuses search;
  ⌘K/Esc/focus-restore verified by widget test.
- **D4 — Component template (all 118), themes, install, CLI ref** (~2400 LOC).
  Outputs: `lib/pages/{component_page,themes,getting_started,cli_reference}.dart`,
  deferred-import registry `lib/previews/component_previews.dart`
  (118 `deferred as` imports + loader map — generated by D2, checked in),
  `lib/widgets/{preview_controls,dashboard,bar_chart,timeline,swatches}.dart`.
  Needs: D2 + D3. Proves: 3 sample component pages (button/dialog/command)
  golden-tested light+dark; themes dashboard re-themes live incl. open dialog;
  install tabs show exact generated file lists; CLI page renders snapshot-only
  where the new CLI help is missing.
- **D5 — Motion + responsive pass** (~600 LOC + edits).
  Outputs: hero spring/float, reveal stagger, card hover, marquee wiring,
  760/1100 breakpoints + drawer swap, 375px frames, reduced-motion audit
  (every §4 row re-verified with `disableAnimations: true`).
  Needs: D3 + D4. Proves: widget tests for overshoot ≤4px curve bound,
  1.5s copy timer, 300ms preset tween duration constant; manual checklist in
  the batch report.
- **D6 — UI check vs mockups (vision batch)** (no app code; screenshots +
  report). Outputs: `rearch/reports/P6_UI_CHECK.md` with per-route table.
  Procedure: `flutter build web --release`, serve, screenshot EVERY route at
  1440px + landing/component at 375px, each in light + dark (26 captures min),
  side-by-side against `rearch/design/docs/screens/*.png`; pixel-diff +
  vision review; file P1 deltas back to D3–D5 owners. Needs: D5. Gate: zero
  P1 visual deltas before the CLI-reinstall final step (§2.3).

Agent rules for all batches: only touch the listed outputs; no Material/
Cupertino imports; `dart format` + `flutter analyze` zero issues without
ignores; files ≤ ~400 lines; ground rule 3 (no hand-typed component facts —
reviewers reject any literal that the codegen should emit).

## 7. Acceptance gates (orchestrator QA, in order)

1. `flutter analyze` 0 issues; `dart format --set-exit-if-changed` clean.
2. `gen_docs_data.dart --check` passes (generated data fresh).
3. `mirror-check` passes (mirror == registry manifest hashes).
4. No `material.dart`/`cupertino.dart`/`go_router`/`syntax_highlight` imports
   in `docs/lib` (grep gate).
5. Widget tests: router deep-links, palette keyboard contract, preset/mode
   tween wiring, copy 1.5s, reduced-motion branch — all green.
6. D6 UI check: zero P1 deltas across 26 captures.
7. Final: delete mirror, `flutter_shadcn init --theme modern-minimal` +
   `add --all`, `git status --porcelain docs/lib/ui/shadcn` EMPTY,
   `flutter build web` green. Only then commit.

## 8. Open questions (for the orchestrator, not the build agents)

1. Pill set on the components index (All + how many?) — generated from
   manifest categories regardless; mockup re-read in D3 settles the visual.
2. `shared_preferences` vs `package:web` localStorage (D1 import-scan decides;
   UNVERIFIED until run).
3. `visibility_detector` survival for D:Reveal (D3 decides; manual observer
   preferred if trivially equivalent).
4. `R:command showCommandDialog` vs docs-only palette panel (D3 spike).
5. `overflow_marquee` hover-pause/duration prop names (UNVERIFIED until source
   read in D3).
6. CLI reference flags source: new-CLI `--help` text does not exist yet —
   `cli_snapshot.txt` starts as a paste of the P5 command surface (§2) and is
   re-pasted when the CLI lands; flags tables stay snapshot-derived.
7. Exact `main.dart.js` KB budget (UNVERIFIED until D1 `--analyze-size` run).
8. `assets/docs_images` + `docs.json` readers (D1 grep decides delete/keep).
9. Light-mode screenshots exist for one state only (themes × tangerine) — D6
   captures every route in both modes to close the gap noted in P6_DESIGN.

## RESULT
status: done
files_written:
- /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P6_DOCS_BUILD_PLAN.md
commands_run:
- read: REARCHITECTURE_PLAN.md, P6_DOCS_DESIGN.md, P5_CLI_PLAN.md (+ §9 orchestrator decisions), registry_manifest.v2.schema.json
- read: docs/pubspec.yaml, docs/lib/main.dart (520 lines), docs/lib/code_highlighter.dart, docs/tool/generate_component_pages.dart, docs/lib/web_bridge_web.dart, docs/lib/theme/theme_controller.dart, docs/Makefile
- read: registry_next button {meta.json, README.md, preview.dart}, dialog/command meta.json, dialog README keyboard excerpt, theme/{README.md, theme.dart AnimatedShadcnTheme}, tool/rearch/gen_app_theme.dart, popup/tooltip/page_route/app meta descriptions, kit pubspec (analyzer ^6.4.1)
- shell (read-only): registry_next tree counts (118 components, 42 presets, theme/foundation/primitives files), category histogram (display 28, form 29, navigation 8, overlay 20, control 6, layout 21, utility 6), mockup line counts (1962), screens inventory (13 PNGs), component coverage check (all mapping ids exist except popover/chart), old-docs page sizes, deploy workflow, sync/install/generate scripts
key_findings:
- Registry coverage is complete except two forced deviations: no `popover` component (use `popup`, whose tags include popover) and no `chart` component (themes-dashboard bars must be docs-only CustomPaint on chart1..5 tokens).
- `AnimatedShadcnTheme` (300ms-capable), `ShadcnThemeData.lerp`, `ShadcnApp.router`, and `ShadcnPageRoute` already exist — shell, live re-theming, and routing all compose registry-owned pieces; only the ~150-line RouterDelegate and DocsState are docs-only.
- `gen_app_theme.dart` is VM-safe and reusable: docs `app_theme.dart` must be byte-identical to its output (test-enforced), with `--theme-import` retargeted at the docs mirror.
- Keyboard/a11y README sections are non-uniform prose, so the codegen hides (never invents) empty keyboard tables; CLI flags tables are snapshot-derived until the new CLI `--help` text exists.
- Old docs collapses hard: 118 hand-written component pages become one template route; go_router, syntax_highlight, Python scripts, and the category-dir mirror are all deleted.
open_questions:
- shared_preferences vs localStorage, visibility_detector survival, command-palette implementation spike, overflow_marquee prop names, pill set, JS size budget — all assigned to D1/D3 with decision procedures (see §8).


