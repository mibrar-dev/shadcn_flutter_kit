# P6-D4b — theming + dark-mode pages, shell Tab order, JS size

Spec: `rearch/reports/P6_SHADCN_SITE_SPEC.md` (§1/§2.6/§7) wins over
`P6_DOCS_BUILD_PLAN.md`. Reference captures: `rearch/design/shadcn-ref/screens/
theming-*.png`, `darkmode-*.png`. The Open Design mockups were not used.

## 1. `/docs/theming` and `/docs/dark-mode`

Both routes were `DocsPlaceholderPage`; they are now real pages, composed from
the docs shell (`DocsLayout` + `DocsArticle`) exactly like the other prose
pages, with the generated token table and hand-written code samples.

### Theming (`lib/pages/theming_page.dart`)

Mirrors the reference structure with our facts:

| Section | Content |
|---|---|
| intro | tokens → `ShadcnColors` / `ShadcnThemeData`, read with `ShadcnTheme.of(context)` |
| Tokens | camelCase of the shadcn CSS variable (`--card-foreground` → `cardForeground`) + a Dart sample |
| Token Convention | semantic background/foreground pairs + a `BoxDecoration` sample |
| Theme Tokens | the generated 33-row table (32 colours + `radius`) |
| Radius Scale | `radius` is a unitless rem factor; `radiusLg = radius*16`, `sm`/`md` step down 4/2 px, `xl` up 4 px (the kit's actual derivation in `theme.dart`) + sample |
| Presets | `kStats.presets` (43) presets, CLI default `neutral`, `flutter_shadcn theme apply <preset>` + a `bash` sample |
| Component Themes | precedence `widget arg > ComponentTheme<T> > ComponentThemes (user *_theme.dart) > token defaults` + a sample |
| Animated Theming | `AnimatedShadcnTheme(data, duration, curve)` colour tween + sample |

### Dark mode (`lib/pages/dark_mode_page.dart`)

The reference's framework-picker cards do not exist here (one implementation),
so the page is prose + samples: how brightness works (`ShadcnColors.brightness`),
`ShadcnApp(theme:, darkTheme:, themeMode:)`, `ThemeMode.system | light | dark`,
toggling + persisting an explicit mode, and following the system.

### Facts source (no hand-typed registry facts)

The token table is generated. `docs/tool/src/registry_scan.dart` now parses the
registry theme layer with `package:analyzer` (`ShadcnColors` `Color` fields in
declaration order + `ShadcnTokens.radius`) and derives each shadcn CSS variable
(`cardForeground` → `--card-foreground`, `chart1` → `--chart-1`).
`render_files.dart` emits `DocsThemeToken` + `kThemeTokens` into
`lib/generated/docs_data.dart`. The per-token prose ("what it controls") stays
docs-side in `lib/widgets/theme_token_table.dart`, and a test asserts every
generated token has a description, so a new registry token fails loudly.

### Code samples

`lib/widgets/docs_samples.dart` holds every sample as a source string.
`test/theming_page_test.dart` runs `parseString` (analyzer) on each Dart sample
and asserts zero diagnostics, and a widget test builds
`ShadcnApp` + `AnimatedShadcnTheme` + `ComponentTheme<ButtonTheme>` + `Button`
with the same APIs the samples name. `DocsCodeFigure` renders them (the shared
`--code` surface, 18 px radius, copy button).

## 2. Shell Tab order — header → sidebar → content → TOC

The default `ReadingOrderTraversalPolicy` interleaved the article and TOC
columns and reached the header (which lives outside the docs navigator) only
after the article (D5 open question 2). Fix:

- `lib/widgets/docs_tokens.dart` — `DocsFocusOrder` (`NumericFocusOrder` slots
  per region, per scope).
- `lib/widgets/docs_shell.dart` — the shell wraps header / navigator / footer in
  `FocusTraversalOrder` and uses `OrderedTraversalPolicy`; `DocsLayout` does the
  same for sidebar / article / TOC.
- `lib/widgets/docs_article.dart` — the TOC column gets the last slot.
- `lib/widgets/docs_header.dart` — the first header control autofocuses so a
  fresh load starts the shell order at the header instead of the page scope.

Verified by two tests in `test/focus_test.dart`: the first Tab on a fresh app
lands in the header, and the region cycle after navigation is
`header → sidebar → content → toc`. All 8 pre-existing focus-reachability tests
still pass.

## 3. Web JS size + deferred loading

`flutter build web --release` after the change:

```
main.dart.js          2,835,756 bytes raw / 786,780 bytes gzip
```

- D1 baseline (landing, stub pages): 1,470,007 raw / 447,198 gzip.
- Before this batch's deferral: 3,184,154 raw / 870,184 gzip.
- After deferring the component page: **−348 KB raw / −83 KB gzip**.

`--analyze-size` is not a web flag in Flutter 3.47 (re-confirmed), so the
contributor list is source size + chunk size, not a JS attribution:

| Contributor | Size | Bundle |
|---|---|---|
| `docs_api.dart` | 354 KB | now deferred (component chunk) |
| `docs_preset_sources.dart` | 287 KB | eager (`/themes` → `theme_export.dart`) |
| `docs_snippets.dart` | 190 KB | now deferred |
| `app_theme.dart` | 164 KB | eager (all 43 presets; `buildDocsTheme` references every one) |
| `docs_data.dart` | 67 KB | eager (routing / `kComponentLinks`) |
| `docs_tables.dart` | 62 KB | now deferred |
| `docs_search.dart` | 40 KB | eager (palette) |

Deferred loading: `lib/routing/deferred_page.dart` + `main.dart` imports
`pages/component_page.dart` with `deferred as`. That moves `docs_api` +
`docs_snippets` + `docs_tables` into `main.dart.js_564.part.js` (350,831 bytes);
the 118 `preview.dart` chunks (already deferred) make up most of the 497 chunks
(2.19 MB total). The `/themes` deferral was implemented and reverted — see open
questions.

## 4. Files

New: `lib/pages/theming_page.dart`, `lib/pages/dark_mode_page.dart`,
`lib/widgets/code_figure.dart`, `lib/widgets/docs_samples.dart`,
`lib/widgets/theme_token_table.dart`, `lib/routing/deferred_page.dart`,
`test/theming_page_test.dart`.

Modified: `lib/main.dart`, `lib/widgets/{docs_shell,docs_article,docs_header,
docs_tokens}.dart`, `lib/pages/placeholder_page.dart`, `test/focus_test.dart`,
`tool/src/registry_scan.dart`, `tool/src/render_files.dart`,
`tool/gen_docs_data_test.dart`, regenerated `lib/generated/{docs_data,docs_api,
docs_snippets,docs_tables}.dart`.

## 5. Gate output

```
cd $KIT/docs
dart format --output=none --set-exit-if-changed lib test tool
# Formatted 737 files (0 changed) in 1.72 seconds.

flutter analyze
# No issues found! (ran in 4.2s)

flutter test
# 00:15 +84: All tests passed!

grep -rnE "package:flutter/(material|cupertino).dart" lib
# matches only registry-mirror comments; the import-only grep is empty:
grep -rnE "^\s*import\s+['\"]package:flutter/(material|cupertino)\.dart" lib
# (empty)

flutter build web --release
# ✓ Built build/web   (main.dart.js 2,835,756 raw / 786,780 gzip)

dart run tool/gen_docs_data.dart --check
# generated data is up to date (8 files checked).

bash tool/sync_registry.sh --check
# mirror is up to date.

flutter test tool/gen_docs_data_test.dart
# +22: All tests passed!
```

## 6. Decisions

1. **Token table is codegen-driven**, not hand-typed: the codegen parses
   `theme/color_tokens.dart` + `theme/tokens.dart` with analyzer and derives the
   CSS variable names. Prose descriptions stay docs-side; a test enforces
   coverage.
2. **Samples are analyzer-checked source strings** (`parseString`) plus a widget
   test that exercises the same APIs, per the brief.
3. **`OrderedTraversalPolicy` + `FocusTraversalOrder`** for the shell order,
   with an initial autofocus on the first header control. `WidgetOrderTraversalPolicy`
   was tried first and rejected: it cycled within the page focus scope and never
   reached the header.
4. **Component page is deferred**; `/themes` is not (see open questions).
5. **Radius Scale describes the kit's real derivation** (`theme.dart`), not
   shadcn's CSS `calc()` multipliers, which differ.

## 7. Cross-agent state (important)

Another agent is fixing `ShadcnApp` shortcuts. Its uncommitted changes are in
this working tree: `flutter_shadcn_kit/lib/registry/components/app/{app.dart,
README.md}` (merge `shortcuts`/`actions` over the `WidgetsApp` defaults) and
`docs/lib/main.dart` (the docs-side workaround spread removed).

That left the tree inconsistent — `main.dart` relied on the new merge, but the
docs mirror `lib/ui/shadcn/components/app/app.dart` was still the old
forwarding version, so Tab traversal was dead and every focus test failed. I ran
the sanctioned `tool/sync_registry.sh` (Dart-only mirror), which changed exactly
one file: `docs/lib/ui/shadcn/components/app/app.dart`. I did not hand-edit the
mirror. Regenerating also picked up the `app` README's new "Keyboard shortcuts
and actions" section, so `kKeyboardGaps` went 115 → 114; I updated the D2
golden (`kComponents.length - 4`) accordingly.

`docs/lib/generated/docs_tables.dart` shows a large diff: the current Dart
formatter's tall style reformats the `kKeyboardRows` const map on regeneration.
The file is `dart format` clean and `--check` passes.

## 8. Open questions

1. **`/themes` deferral reverted.** Deferring `pages/themes.dart` (287 KB
   `docs_preset_sources.dart`) moved the chunk out but `loadLibrary()` did not
   resolve under the fake widget-test clock, so the page rendered the
   `DeferredPage` placeholder forever in `flutter test` (it passed in isolation,
   failed in the full run). The component-page deferral works; the themes one
   needs a test-harness preload (`tester.runAsync`) or a registry-side split of
   `docs_preset_sources`.
2. **`app_theme.dart` is eager and untree-shaken** (164 KB, all 43 presets):
   `buildDocsTheme` switches over every id, so dart2js keeps them all. Deferring
   it needs an initial-preset fallback.
3. **`--analyze-size` is unavailable for web**, so the contributor list is a
   source-size proxy. A `dart2js --dump-info` build would give a real
   attribution.
4. **Initial focus + deferred pages**: the autofocus starts the shell order at
   the header on a fresh load; after an in-app navigation the framework moves
   focus into the page scope, so the first Tab starts at the page. The relative
   cycle is always header → sidebar → content → toc.
5. **Mirror sync is pending on the other agent**: the committed mirror is the
   old `app.dart`; the tree only works because I synced it. The orchestrator
   should run `tool/sync_registry.sh` as part of the merge.
