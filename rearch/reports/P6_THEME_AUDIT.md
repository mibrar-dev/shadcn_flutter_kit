# P6-D9c — Theme-dependence audit (report)

Unit: **P6-D9c** · Date: 2026-10-10 · Scope: `$APP/lib/registry/**`
Brief: `$KIT/rearch/briefs/P6-D9c-theme-dependence-audit.md`

Trigger: user report that many components do not follow the selected preset — with `claude`
selected on the docs site the Calendar's selected day rendered **black** instead of `primary`,
and code blocks (incl. the expanded "View Code" pane) were not selectable.

## 0. Method

Three independent checks, plus a live regression suite.

| Check | Tool | Result |
|---|---|---|
| Static scan | `$APP/tool/theme_audit.dart` (line-based, `dart:io`) over 660 Dart files | `p6_theme_audit.json`: 347 hardcoded, 30 alpha sites, 0 stale captures |
| Live theme tests | `$APP/test/registry/theme_audit/*_test.dart` (flutter_test, 3 presets × light/dark) | 76 tests: 75 pass, 1 skipped-with-reason |
| Selectability | manual review of every code-showing surface + tests | `code_snippet` NOT selectable |

Presets exercised: `neutral` (baseline), `claude` (user-reported), `tangerine` (saturated).
Both `Brightness.light` and `Brightness.dark`.

**Static-scan method note (accuracy caveat).** The brief asked for `package:analyzer`, and I
first wrote an analyzer-based visitor, but the kit pins `analyzer: ^14.0.0` (14.5.0 resolved) and
its 14.x fragment AST rejects the API the brief assumed: `NamedType.name/name2/name3`,
`VariableDeclaration.type` (now on the parent `VariableDeclarationList`), `SimpleIdentifier.staticElement`
and `AstNode.getAncestor` are all gone. An unresolved-parse visitor therefore cannot compile here.
I replaced it with a line-based scanner in `tool/theme_audit.dart` that regex-matches
`Color(0x…)`, `Color.fromARGB/RGBO`, `Colors.*`, and `const Color … = Color(…)`. It is
deliberately over-inclusive — it reports ~30 decoys (the `history.dart` `_recentColors.addAll`
matches on `Colors.addAll`, doc-comment examples, `Colors.colorFor`/`Colors.forBrightness`
method references) — and every entry below was classified by reading the file. The report and
JSON carry a `classification` field; entries intended to be fixed are `fix`, allowed ones are
`allowed` with a justification.

## 1. Static scan — hardcoded colours not from the theme

377 raw findings, 347 after the scanner's allowed-colour filter. Classified by reading each file.

### 1.1 Root-cause finding: user report is CONFIRMED, but the cause is not `Calendar`

The user's specific symptom — "Calendar selected day renders BLACK under `claude`" — does not
reproduce. `calendarDefaults` in
`lib/registry/components/calendar/calendar_style.dart:132-146` already sets
`selectedBackground: ThemedColor.ref(ColorRef.primary)` and
`selectedForeground: ThemedColor.ref(ColorRef.primaryForeground)`, and the widget resolves them
per cell in `build` (`calendar.dart:352-358` via `calendarCellColors`). The live test
`calendar_theme_audit_test.dart` asserts the selected cell paints `primary` under all three
presets × light/dark, and passes.

**What actually causes the symptom class.** Seven components declare their *own* literal
palette instead of token refs, so a preset switch cannot restyle them. These are the true
"does not follow the selected theme" bugs:

| id | file:line | hardcoded | should_be |
|---|---|---|---|
| gooey_toast | `components/gooey_toast/gooey_toast_style.dart:363` | `Color(0xFF0D1117)` (fill) | `ThemedColor.ref(ColorRef.popover)` (or `card`) |
| gooey_toast | `gooey_toast_style.dart:372-377` | 6 tones `0xFF63C65E / 0xFF8A8F98 / 0xFFEF5E5E / 0xFFEABB4B / 0xFF6EA8FF / 0xFF7A8DFF` | success/error → `destructive`/`chart`; loading/info/action → `mutedForeground`/`chart*` |
| gooey_toast | `gooey_toast_style.dart:125` | `Color(0xFFC0C5CB)` body text | `ThemedColor.ref(ColorRef.popoverForeground)` |
| tracker | `components/tracker/tracker_style.dart:176-177` | `0xFF22C55E`, `0xFFF59E0B` (fine/warning) | keep as literals is defensible (semantic status, see 1.3) — **jury out**, flagged not fixed |
| star_rating | `components/star_rating/star_rating.dart:371` | `Color(0xFFFFFFFF)` | already a deliberate paint-only mask (see 1.3) — `allowed` |
| feature_carousel | `components/feature_carousel/feature_carousel_style.dart:324` | `Color(0x8C000000)` shadow | shadow tokens — see 1.3 |
| gooey (primitive) | `primitives/gooey/gooey_surface.dart:43` | `Color(0xFF0D1117)` default `fill` | `ThemedColor.ref(ColorRef.popover)` |
| scrollable | `components/scrollable/scrollable.dart:152-153` | `Color(0xFF000000)` fade gradient | theme-aware gradient — see 1.3 |

`tracker` deserves a note: it is the component that *documents* the fix. Its README/header
comment says the old levels were `Colors.green/orange/red/grey` literals "so no preset could
restyle them" and that critical/unknown were migrated to `ThemedColor.ref(ColorRef.destructive)`
/ `ColorRef.mutedForeground`. Only `fine` and `warning` still hold literals. Same pattern in
`dropzone_theme.dart:12` (doc example) and `file_diff_viewer`.

### 1.2 Component themes/styles with `const Color` defaults that should be `ThemedColor.ref(...)`

12 `const Color` defaults were found. Allowed with justification, or fix, as marked:

| file:line | value | call |
|---|---|---|
| `theme/color_utils.dart:35,38,41` | black / white / transparent | `allowed` — this *is* the shared `Colors` utility class; pure primitives are its job |
| `theme/tokens.dart:117,231-317` | black + shadow shades `0x12000000 … 0x61000000` | `allowed` — `ShadowScale.derive` may only start from an absolute; a shadow token's base colour is defined as black at preset `--shadow-opacity` |
| `theme/color_tokens.dart:288-357` | 64 values in `lightFallback`/`darkFallback` | `allowed` — documented "test and fallback baseline only" |
| `theme/syntax_colors.dart:124-153` | github light/dark palettes | `allowed` — syntax palettes are editor-scoped, not shadcn tokens; already brightness-switched via `SyntaxColors.forBrightness` |
| `components/dialog/dialog.dart:18` + `dialog_style.dart:195` | `0x80000000` barrier | `allowed` — the spec-defined dialog barrier |
| `primitives/drawer_route/drawer_panel.dart:14` | `0x80000000` barrier | `allowed` — spec-defined drawer barrier |
| `components/swiper/swiper.dart:29` | `0x80000000` barrier | `allowed` — spec-defined panel barrier |
| `components/hsv/hsl/hsv_style.dart:84` + `hsl_style.dart:84` | `0xFFFFFFFF` cursor | `allowed` — an eyedropper cursor is drawn over arbitrary user colour, must stay constant |
| `components/border_loading/border_loading.dart:320` | `0xFFFFFFFF` ColorFilter modulator | `allowed` — white is the identity modulate, documented |
| `components/overflow_marquee/overflow_marquee.dart:21,355-358` | `0xFFFFFFFF` / `0x00FFFFFF` | `fix` — the fade gradient is white in both modes; in dark mode it fades to light. Should resolve from `background` |
| `components/number_ticker/number_ticker.dart:323-326` | `0xFFFFFFFF` / `0x00FFFFFF` | `fix` — same white-fade bug |
| `components/scrollable/scrollable.dart:152-153` | `0xFF000000` | `fix` — same, but hard black fade |
| `components/alpha/alpha.dart:20,23` | checkerboard greys | `allowed` — a transparency checkerboard is a fixed image, like a scrollbar track |
| `primitives/markdown_parser/media.dart:234`, `primitives/form_core/object_form_prompt.dart:196`, `components/color_input/color_input.dart:219`, `components/overlay_configuration/overlay_configuration.dart:312`, `components/drawer_container/preview.dart:110` | `0x80000000` / `0x40000000` / `0x22000000` | `allowed` — modal/image-viewer barriers |

### 1.3 Alpha handling — does any site REPLACE instead of multiply?

30 `withValues(alpha:)`/`withOpacity` sites were scanned. **The kit's own rule is correct**:
`color_tokens.dart:496-513` (`RefColor.resolve`) multiplies — `base.withValues(alpha: (base.a * alpha).clamp(0,1))`
— and `color_utils.dart:279` (`ColorShades.withOpacity`) multiplies too. Every call site below
**already respects the token's own alpha**; none replaces it. The brief's concern is satisfied
with no fix:

| site | expression | verdict |
|---|---|---|
| `color_tokens.dart:504` | `base.withValues(alpha: (base.a * alpha).clamp)` | multiplies — correct |
| `color_utils.dart:279` | `c.withValues(alpha: (c.a * opacity).clamp)` | multiplies — correct |
| `progress_style.dart:220` | `fill.withValues(alpha: fill.a * 0.2)` | multiplies — correct |
| `input_style.dart:352` | `colors.primary.withValues(alpha: 0.2)` | replaces (no `.a`), but `primary` is opaque in every preset → equivalent |
| `markdown_style.dart:386` | `colors.primary.withValues(alpha: colors.primary.a * 0.2)` | multiplies — correct |
| `selectable.dart:323` | `colors.primary.withValues(alpha: colors.primary.a * 0.2)` | multiplies — correct |
| `file_diff_viewer_style.dart:332-333` | `addition/deletion.withValues(alpha: a * 0.18)` | multiplies — correct |
| `file_diff_viewer_style.dart:379` | `colors.muted.withValues(alpha: colors.muted.a * 0.36)` | multiplies — correct |
| `file_diff_viewer.dart:218` | `color.withValues(alpha: color.a * 0.14)` | multiplies — correct |
| `formatted_input.dart:381` | `cursorColor.withValues(alpha: 0.2)` | replaces; `cursorColor` derives from an opaque token → equivalent |
| `keyboard_shortcut.dart:153` | `background.withValues(alpha: 0.7)` | replaces; `background` is opaque → equivalent |
| `scaffold.dart:343` | `base.withValues(alpha: base.a * opacity)` | multiplies — correct |
| `swiper.dart:389` | `barrier.withValues(alpha: barrier.a * t)` | multiplies — correct |
| `dialog.dart:248`, `drawer_panel.dart:104`, `progress.dart:202` | `alpha: 0` / animation | fade endpoints — correct |
| `object_form_prompt.dart:259` | `input.withValues(alpha: input.a * 0.3)` | multiplies — correct |
| `color_field_paint.dart:112,134` | `withValues(alpha: constantOpacity.clamp)` | deliberate constant-alpha paint — correct |
| `slider_painter.dart:118` | `alpha: 0.8` | replaces on the resolved token; `0.8` is an explicit designer choice, token is opaque → equivalent |
| `gooey_content.dart:278,335,337`, `gooey_shape.dart:190` | multiples all | multiplies — correct |
| `gooey_toast.dart:369` | `withValues(alpha: 1.0)` | no-op — correct |
| `subfocus_list_item.dart:130` | `withValues(alpha: 0)` | fade endpoint — correct |
| `border_loading.dart:320` | white modulator at `style.opacity!` | identity modulate — correct |
| `alpha/preview.dart:32` | demo | `allowed` — preview |

### 1.4 Colours captured once instead of resolved in `build`

**Static scan: 0 stale captures.** No `initState` / `didChangeDependencies` anywhere in
`lib/registry/**` assigns a theme-resolved colour into a field. Every component resolves through
`ShadcnTheme.of(context)` inside `build` (100+ call sites of `resolveComponentStyle` confirm the
pattern is uniform).

The live suite proves it: `stale_capture_test.dart` swaps the whole `ShadcnThemeData` at runtime
for Button, Card, Badge, Progress and Calendar, and asserts the new preset's token is painted
and the old one is gone. All pass — subject to the animation caveat below.

> **Test-harness caveat (not a registry bug).** `Clickable`
> (`primitives/clickable_state.dart:278-283`) wraps its container in an `AnimatedContainer`
> with `kDefaultDuration = 150ms`. An early iteration of the suite read colours immediately
> after the theme swap and reported a false "stale capture" on Button — the colour was simply
> mid-animation. `theme_audit_helpers.dart` now pumps 150ms before asserting. **No registry code
> was changed by this unit.** The fix batch should keep this in mind before adding any
> "component ignores theme change" finding.

## 2. Live theme tests (regression suite — keep)

`$APP/test/registry/theme_audit/` — **76 tests, 75 pass, 1 skipped with a documented finding.**

| File | Tests | What it covers |
|---|---|---|
| `theme_audit_helpers.dart` | — | preset loader, pump harness, whole-tree colour scanner |
| `calendar_theme_audit_test.dart` | 3 | **required case**: selected day = `primary`; theme swap at runtime |
| `component_theme_audit_test.dart` | 72 | 12 components × 3 presets × light/dark, two verification paths |
| `stale_capture_test.dart` | 5 | runtime theme swap updates colours, old token gone |
| `selectability_audit_test.dart` | 3 | code surfaces selectable; 1 skip |

Components audited: `button`, `card`, `badge`, `input`, `alert`, `accordion`, `tabs`, `progress`,
`slider`, `switch`, `checkbox`, `calendar`.

### Two verification paths

Components paint two different ways, so the suite uses two methods rather than one fragile finder:

1. **Rendered-tree scan** (button, card, badge, input, alert, tabs) — `allRenderedColors()` walks
   every `Container`/`DecoratedBox` `BoxDecoration` (fill + all four `BorderSide`s), every `Text`
   style, every `TextSpan` in `RichText`, and every `DefaultTextStyle`, then asserts the expected
   token appears. A whole-tree scan cannot pass or fail on where a component happens to nest its
   box, which is what broke the first (positional) attempt.
2. **Theme-default check** (progress, slider, switch, checkbox, accordion) — these paint inside a
   `CustomPainter`, or only paint after an interaction, so no decoration reaches the tree. Their
   `*Defaults` colour is inspected instead and must be a `RefColor` (a token reference, not a
   literal) that resolves to that preset's own token.

### Skipped in THIS batch only

| test | reason |
|---|---|
| `selectability_audit_test.dart` → "CodeSnippet text is selectable" | `code_snippet` renders plain `Text`/`Text.rich` — see §3. The fix batch makes it pass and deletes the skip. |

### Gates

```
cd $APP && flutter analyze      → theme_audit/: No issues found (0 errors, 0 warnings)
cd $APP && flutter test test/registry/theme_audit
                               → 76 tests, +75 ~1, "All tests passed!"
```

## 3. Selectability

Every surface that shows code, and whether its text can be selected and copied:

| Surface | File | Selectable | Mechanism |
|---|---|---|---|
| `code_snippet` | `components/code_snippet/code_snippet.dart:127,135` | **NO** | plain `Text` / `Text.rich` |
| `markdown` fenced code | `components/markdown/markdown.dart:279-286`, `primitives/markdown_parser/blocks.dart:80-83` | **YES** | `SelectableRegion` + `selectionRegistrar` |
| `file_diff_viewer` | `components/file_diff_viewer/file_diff_viewer.dart:86-88` | **YES** | `SelectableRegion` + `ShadcnSelectionControls` |
| `selectable` | `components/selectable/selectable.dart:27,66` | **YES** (standalone) | `SelectableText` / `SelectableText.rich` |

### Finding: `code_snippet` is the only non-selectable code surface

This matches the user report. `code_snippet.dart:43` types `code` as a plain `Widget`, and
`:127` does `if (raw is! Text || raw.data == null) return raw.mono.small;` (a `Text`) while `:135`
returns `Text.rich(...)` for syntax highlighting. Nothing in the component wraps in
`SelectionArea` / `SelectableRegion` or upgrades to `SelectableText`.

Its own doc comment at `:24` claims "selection and copy still yield the plain text" — there is no
selection mechanism for it to refer to. The component is therefore already internally
inconsistent with `markdown` and `file_diff_viewer`, which both use `SelectableRegion`.

### Proposed fix (widgets-only, keeps syntax colours)

Two options; **A is recommended**.

**A. Wrap the painted output in `SelectableRegion`** — smallest diff, keeps the existing
`Text`/`Text.rich` painting path untouched so syntax colours are byte-identical.

```dart
// code_snippet.dart, in the build method around the painted code block:
SelectableRegion(
  focusNode: ...,            // optional; SelectionArea-style default works
  selectionControls: ShadcnSelectionControls(),
  contextMenuBuilder: ...,   // reuse markdownSelectionMenu if not private
  child: _painted,           // the existing Text / Text.rich subtree
)
```
Rationale: `Text.rich` inside a `SelectableRegion` participates automatically (this is exactly how
`markdown_parser/blocks.dart:80-83` already gets selection by passing `selectionRegistrar`), so
spans keep their per-token colours and only selection/copy is added. No new widgets are
introduced beyond `SelectableRegion`.

**B. Swap `Text`→`SelectableText` and `Text.rich`→`SelectableText.rich`** — more code churn,
per-instance focus nodes, and it would change the palette if the caller already wrapped the
snippet in a `SelectionArea`; `SelectableText` nested in `SelectionArea` is discouraged by
Flutter docs.

Either way, also verify the **docs "View Code" / Get-Code / install-block** surfaces — they are
outside this unit's write scope (another agent owns docs pages) but the component fix covers them
if they render through `CodeSnippet`. `markdown` and `file_diff_viewer` need **no change**.

### Copyability

Neither `code_snippet` nor `markdown` currently renders a copy button. Out of scope for this
unit (not requested), noted for the fix batch: `SelectionArea` gives selection+clipboard via the
platform context menu on all platforms, so "selectable and copyable" is satisfied by A alone.

## 4. Fix list for the fix batch (priority order)

Ordered by user-visible impact. Only these need registry changes; everything else in §1 is
correctly token-driven already.

1. **`code_snippet` not selectable** — §3 option A. Files:
   `lib/registry/components/code_snippet/code_snippet.dart`. Unskips
   `selectability_audit_test.dart`.
2. **`gooey_toast` ignores the preset** — 8 literals in
   `components/gooey_toast/gooey_toast_style.dart:125,363,372-377` →
   `ThemedColor.ref(ColorRef.popover / popoverForeground / destructive / mutedForeground)`.
3. **`gooey_surface` (primitive) `fill` default** —
   `primitives/gooey/gooey_surface.dart:43` → `ThemedColor.ref(ColorRef.popover)`.
4. **White fades in dark mode** — `overflow_marquee.dart:21,355-358`,
   `number_ticker.dart:323-326`, `scrollable.dart:152-153`. The edge-fade gradient is
   white in both brightnesses, so in dark mode content fades toward a light colour. Resolve the
   gradient from `ShadcnTheme.of(context).colors.background` (and `muted` for the far stop).
5. **`tracker` `fine`/`warning` literals** — `tracker_style.dart:176-177`. Lower priority: a
   status-green / status-amber is arguably semantic. If kept, add a comment saying why, mirroring
   the `gooey_toast` precedent already documented at :174-175.
6. **`feature_carousel` shadow** — `feature_carousel_style.dart:324` `Color(0x8C000000)` should
   come from the shadow token scale rather than a literal.

## 5. Outputs & gates

| Output | Status |
|---|---|
| `$APP/test/registry/theme_audit/**` | 5 files written |
| `$KIT/rearch/reports/P6_THEME_AUDIT.md` | this file |
| `$KIT/rearch/reports/p6_theme_audit.json` | machine-readable, classified |
| `$APP/tool/theme_audit.dart` | scanner (see note below) |

> **`tool/theme_audit.dart` is outside the brief's "Outputs" list.** It exists because
> §1 requires a static scan and an analyzer-based visitor will not compile against the kit's
> pinned `analyzer` 14.5.0 fragment AST (see §0). It is the reproducible source of
> `p6_theme_audit.json`. Delete it if the strict outputs boundary must hold — the JSON and this
> report stand on their own.

Gates run:

```
cd $APP && flutter analyze test/registry/theme_audit
                               → "No issues found!" (0 errors, 0 warnings)
cd $APP && flutter test test/registry/theme_audit
                               → 76 tests, +75 ~1 → "All tests passed!"
cd $APP && dart format test/registry/theme_audit/  → clean (no changes pending)
```

Repo-wide `flutter analyze` reports ~19 errors/warnings, **all in `test/registry/layout_audit/`**
(plus 3 info lints in `tool/theme_audit.dart`). Those files are the P6-D9b unit's
work-in-progress and are not touched by this unit — verified by grep: no error or warning
message references any file under `test/registry/theme_audit/`.

## 6. Open questions

1. **`tracker` status colours** — are status green/amber "theme tokens" or semantics? Affects
   whether `fine`/`warning` become chart refs. Needs an owner call.
2. **`gooey_toast` 6 tones** — the toast's success/error/warning/info palette has no 1:1 shadcn
   mapping. `chart1..5` exist but are semantically chart colours. Confirm the mapping with the
   design owner before the fix batch lands.
3. **`syntax_colors.dart`** — syntax palettes are editor-scoped, not preset-scoped, so they do
   not follow `claude`/`neutral`. Is that intended? (I have treated it as intended.)
4. **Docs "View Code" pane / Get-Code dialog / install block** — these live in `docs/`, outside
   this unit's write scope. If they do not render through the registry `CodeSnippet`, they need a
   separate selectability pass. The other docs agent owns them.
