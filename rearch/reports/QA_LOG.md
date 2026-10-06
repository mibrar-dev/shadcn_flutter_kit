# QA log (orchestrator)

## P1-A theme design — muse-spark-1.3-contributor
- r1 REJECTED: file truncated at line 421 (literal "...[truncated 15865 chars]"); §3.1–§8 missing.
- r2 complete (1,181 lines). REJECTED WITH AMENDMENTS:
  - A1 blocker: user-owned `button_theme.dart` declared `const` but uses `WidgetStateProperty.resolveWith(closure)` → does not compile, and closures are not Studio-serializable → introduce const `StateValue<T>`.
  - A2 major: opacity not representable (`ThemedColor.ref` has no alpha) → add `alpha`.
  - A3 major: `ComponentTheme.maybeOf` falls back to the global registry that holds app overrides → scoped/app legs overlap → tree-only lookup + separate app leg + one generic resolver.
  - A4 minor: generated `component_themes.dart` missing imports / wrong install path.
  - A5: orchestrator decisions recorded (destructiveForeground un-deprecated, shadow calibration + marker, linear radius kept, surface* fields grep-then-cut).
- r3: pending.

## P1-D token audit — fledge-alpha-free
- ACCEPTED. Orchestrator re-verified:
  - shadows identical in 84/84 preset modes (all 42 presets, light + dark) ✔
  - 0 colour values with alpha < 0xFF across all 42 presets, while shadcn v4 dark `--border/--input` use alpha
    (`oklch(1 0 0 / 10%)`) → alpha is never preserved; the converter must keep it (8-digit ARGB in JSON).
- Weak evidence noted: colour comparison used `mono` vs `neutral.css` (different themes); not used for decisions.
- Decisions taken from this report:
  - add base shadow atoms (`shadowColor/Opacity/Blur/Spread/OffsetX/OffsetY`) to the JSON schema; sizes derived.
  - fonts are mode-independent: move `fontSans/Serif/Mono` to a top-level `fonts` block (no per-mode fonts).
  - JSON colours may carry alpha; converter preserves it.
  - root cause of the shadow bug: identical literals in `shared/theme/generated/*/preset_themes.dart`, copied by
    `tool/theme/theme_preset_dart_parser.dart:178-186` — both files are deleted in the new design.
- r3 ACCEPTED after two orchestrator corrections applied directly in THEME_DESIGN.md:
  - resolver call site merged as `base.merge(override)`; with first-non-null-wins semantics the fully populated
    defaults always win → overrides never applied. Fixed to `override?.merge(base) ?? base`.
    Phase 2 must add a resolver test proving each leg overrides the one below it.
  - `RefColor.resolve` replaced alpha (`withValues(alpha: alpha)`); fixed to multiply (`base.a * alpha`) so
    alpha-bearing tokens (dark border 10%) stay correct.

## P1-B guardrail tooling — deepseek-v4.1-flash
- ACCEPTED. Orchestrator re-ran: `dart format --set-exit-if-changed` clean, `dart analyze tool/rearch test/rearch`
  0 issues, `flutter test test/rearch` 27/27, each script ~5.7s on the full registry.
- Spot-check: InputClearFeature (identical copy), AutoComplete / FormKey (diverged) and ValidationResult all flagged.
- Baseline: 166 duplicate names (131 public, 35 private; 107 identical copies, 59 diverged); no-part 2,246 directives
  (1,123 files); no-ignore-for-file 1,964; no-material 205; layer-direction 1; undeclared-dependency 71;
  file-too-long 92. Full-project `flutter analyze`: 7 pre-existing issues in tool/theme + test/registry.
- Decisions on its open questions:
  - preview.dart stays under `no-material` (the gallery must prove Material-free) but is excluded from
    `undeclared-dependency` (previews may use other components for demos). → small follow-up in Phase 2 tooling.
  - `tab_list` has no entry file; `form_sortable` / `fade_scroll_display` id≠dir mismatches → resolve in P1-C/Phase 4.

## P1-C ownership audit — space-bunny-free
- ACCEPTED WITH CORRECTIONS.
- Cross-check vs check_single_owner: audit covers 157/166 names; the 9 missing are top-level functions/variables
  (out of the brief's declaration scope): buildEditableTextContextMenu, colorToHex, getBullet, kDoubleTapMinTime,
  menuPopupThemeTokens, menubarThemeTokens, registerComponentThemeGlobalConfigs, shortcutActivatorToKeySet,
  wrapDouble. Orchestrator rule: identical copies → the lowest-layer copy owns it (e.g. wrapDouble →
  foundation, shortcutActivatorToKeySet → foundation); *ThemeTokens / registerComponentThemeGlobalConfigs are
  deleted by the theme redesign.
- Shared map: 142 files = 253 shared − 27 theme − 84 generated preset Dart ✔.
- Correction: sortable / fade_scroll are NOT duplicate ids — the CLI installs them as `form_sortable` /
  `fade_scroll_display` vs `sortable` / `fade_scroll` (manifests/components.json). The merges still stand
  because the flat layout makes the directory names collide. Canonical: the layout versions (`sortable`,
  `fade_scroll`); the other variants' unique behaviour is merged in.
- Correction for the pilot: input's proposed `_impl/features/` (15 files) violates the component rules →
  group features into ≤ 3 files (no `_impl/`), split only by responsibility and the ~400 LOC limit.
- Notable facts adopted: data_widget spans 80 components / gap 117 → replaced in Phase 2 foundation;
  72 non-preview files import material.dart; display/text becomes primitives/text; 0 dead declarations,
  1,272 internal-only prune candidates.

## P2-B theme layer — muse-spark-1.3-contributor
- r1: gates re-run by orchestrator — format clean, analyze 0, 21/21 tests, 0 duplicates, imports only
  widgets/foundation/dart:ui + sibling theme files. Shadow test is NOT circular (defaultShadowScale is a literal
  transcription of old ThemeData defaults). REJECTED WITH FIXES (rearch/briefs/fixes/P2-B-r2.md):
  - F1 bug: ShadowScale.derive used subtractive deltas → negative offsets/blur for real shadcn bases; replace with
    the tweakcn formula (absolute detail layers 1/2/4/8 px, blur 2/4/6/10, multipliers 0.5 / 1 / 2.5).
  - F2: static mutable ComponentThemes registry → inherited app-root widget.
  - F3: resolver merge lambda → `Mergeable<S>` so override-wins cannot be miswired.
  - F4: two `// ignore` comments (Styleable, deprecated member) — removed with the Styleable interface.
  - F5: typography.dart 613 lines → prune unused members.
- r2 ACCEPTED. Orchestrator re-ran gates: format clean, analyze 0, tests 22/22 → 23/23 with orchestrator test.
  Verified in code: tweakcn derive with absolute detail layers (1/2, 2/4, 4/6, 8/10) and 0.5/1/2.5 multipliers;
  resolver constrained to `S extends Mergeable<S>` with `slice.merge(acc)`; ComponentThemes is an inherited
  widget (no static state); no `// ignore`, no Styleable.
  - Orchestrator fix: fallback `destructiveForeground` was 0x00000000 (transparent) in lightFallback/darkFallback
    → destructive buttons would have invisible text without a preset. Set to white (shadcn v4 + old Colors.white);
    added test/registry_next/theme/fallback_colors_test.dart.
  - Accepted: typography.dart 613 lines (all 38 members have consumers); fontSerif stored but unwired;
    tracking.normal not auto-applied (same as old runtime).

## P2-C tooling updates — fledge-alpha-free
- ACCEPTED. Orchestrator re-ran: format clean, analyze 0, `flutter test test/rearch` 33/33.
- `installable` on the old tree: 6 failures (tab_list, layout/group, form/hsl, form/hsv missing entry files;
  form/sortable and display/fade_scroll id≠dir). undeclared-dependency 71 → 19 after preview exclusion.
- Probed check_user_theme with a planted bad file: caught non-const decl, resolveWith, closure, function decl.
- Ops: two hung OpenCode starts (P2-A first launch, P2-D first launch) — launchers now use `--standalone`.

## P2-D presets — space-bunny-free
- ACCEPTED. Orchestrator re-ran: format clean, analyze 0, `flutter test test/registry_next/themes` 26/26,
  `test/rearch` 33/33. Round-trip test really runs `dart format` + `dart analyze` on all 42 generated themes.
- Spot-checks: amber-minimal shadow atoms equal the CLI tweakcn source (blur 8, offsetY 4, opacity 0.1, spread −1);
  generator converts rem → px (`spacing 0.25` → `spacingBase: 4.0`).
- Verified its "per-mode radius dropped for 10 presets": every legacy dark radius is 0.5 = old ThemeData default →
  same copy bug as shadows; a single radius is correct.
- Decisions on its open questions: keep `shadowsDerived: "from-legacy"` for the 8 presets without CLI atoms;
  legacy `\` font values are exporter corruption (CLI values used); legacy themes_preset/ + manifests deleted at
  cutover; tool scripts > 400 LOC accepted (not shipped to users); index schema deferred to Phase 5 (CLI serving).

## P2-A foundation — deepseek-v4.1-flash
- r1 cut off by ECONNRESET: code clean but 4/54 tests failing, no report → r2 (rearch/briefs/fixes/P2-A-r2.md).
- r2 ACCEPTED. Orchestrator re-ran: format clean, analyze 0, `flutter test test/registry_next` 106/106,
  check_layers 0 errors, single_owner 0 duplicates, `flutter analyze lib/registry` still clean.
- Agent verdicts on the 4 failures (all test-side) checked; two of them were faithful ports of OLD BUGS, fixed by the
  orchestrator (clean break → production-ready, not bug-compatible):
  - `CachedValueWidget` tested `T is CachedValue` (a Type literal → always false), so `shouldRebuild` was never used.
    Now checks the values (`value is CachedValue && oldValue is CachedValue`). 0 implementers in the old registry.
  - `List.swapItem` inserted a missing item at an unclamped index (RangeError). Now clamps to [0, length].
  Tests updated to assert the fixed behaviour.
- Accepted deviation: register/unregister moved from DataHolder to DataReceiverRegistry (breaks an import cycle;
  0 external references).

## P3-A pilot design (muse-spark, ses_ef114babeffeIXcJ7ljUsKecJH) — ACCEPTED after r2 + orchestrator fix
- r1 rejected: input depended on autocomplete component (breaks install-alone); stock EditableText would drop
  selection/handles/copy-paste; dialog barrier 0.8 (shadcn is bg-black/50).
- r2: dependency inverted (autocomplete → input), widgets-only `primitives/text_editing.dart` specified with tests,
  barrier 0.5, recommendation per approval item. Verified by grep.
- Orchestrator fix: button variant table ported an old bug (primary disabled bg = fg = mutedForeground → invisible
  label; destructive rest a0.5). Now disabled = rest at opacity 0.5, hover /90 (primary, destructive), /80 secondary.
- Note: D1 rationale is slightly off (widgets has no `showDialog`; rename still avoids clashing with Material apps).
- 13 decisions (B1–B4, I1–I3, D1–D4, T1–T2) await user approval before Phase 3 build.
- 2026-10-06: user (Ibrar) approved ALL 13 decisions (B1–B4, I1–I3, D1–D4, T1–T2) as recommended.
