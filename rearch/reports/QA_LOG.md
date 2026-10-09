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

## P2-E2 primitives form_core/text/localizations (space-bunny, ses_ef1177469ffe45Lj1CqOsRpl3u) — ACCEPTED (r2)
- r1: gates green (63 tests); returned for: controller→null reset value; DatePart/TimePart/DurationPart left in
  layer 3; only en+de locales ported.
- r2: controller→null keeps value (tested); enums moved to primitives/localizations/locale_parts.dart; all locales
  ported (43 files). Orchestrator re-ran: format 0 changed, analyze 0 ×3 folders, 75/75 tests, no ignore/material.
- Decisions: dropped DatePart.getter/computeValueRange + ~20 private calendar helpers (0 readers) — YES.
  `SelectableText` then() dropped (Material-only, 0 call sites). text/ = 3 files (ok).
- Carry to Phase 4: form component must own FormController-aware pending fan-out (FormPendingBuilder is
  controller-free in L2). OWNERSHIP T1-style edits listed in rearch/reports/P2E2_PRIMITIVES.md.

## P2-E1 primitives interaction/overlay/animation/layout (deepseek, ses_ef1179393ffemfjo5UQLFYBbr9) — ACCEPTED (r2)
- r1: gates green (230 tests); exit=1 at the end (printed P2-A's report instead of its own; own report existed).
  Returned for 3 ported old bugs: global mutable `OverlayManager._current` (register/unregister), FadeScroll
  remounting its child when the mask toggles (scroll offset lost), SubFocus letting disabled items become current.
  Stray draft at `$KIT/lib/registry_next/primitives/layout.dart` (outside the app) moved to orchestrator scratchpad.
- r2: all 3 fixed with tests. Orchestrator re-ran: format 0 changed, analyze 0, 233/233, check_layers 0 errors,
  single_owner 0 duplicates, no ignore/material/part. Read overlay_manager (no static state), fade_scroll
  (ShaderMask always present), subfocus_scope.requestFocus (guards isEnabled). color_extensions alpha multiplies.

## P3-T check_layers registry_next deps mode (fledge) — ACCEPTED (r1)
- Components whose meta.json has a `deps` object are checked against it (undeclared = error, unused = warning,
  folder-style primitive deps). Orchestrator re-ran: format 0 changed, analyze 0, test/rearch 38/38; registry_next
  undeclared 7 → 1 (remaining one is in the in-flight dialog r2); old tree counts identical to baseline/layers.json
  (205/2246/1964/1/19/92/6).

## P3-C dialog (space-bunny, ses_ef0d6d5f6ffeW0nyBq4eqQF1T4) — ACCEPTED (r2)
- r1 (after one ECONNRESET resume): 13 tests green; returned for theme frozen at show time (claimed ComponentThemes
  can't be captured — irrelevant, it sits above the Navigator), unused `anchorPoint`, single padding field,
  hard-coded barrier label, duplicate `dependencies` block in meta.json.
- r2: InheritedTheme.capture + resolve in shell/barrier build (test: light→dark switch while open);
  anchorPoint deleted; `padding` 24 inner (shadcn p-6) + `insetPadding` 16 outer; `dialogDismiss` added to
  ShadcnLocalizations with values copied from Flutter's material_<locale>.arb `modalBarrierDismissLabel` (39 locales);
  meta.json single `deps`. Orchestrator re-ran: format 0 changed, analyze 0, dialog+l10n tests 41/41,
  check_layers 0 errors. Accepted warning: localizations.dart 401/400 lines.
- Deviation accepted: transitionDuration fixed at push time (framework reads it on install).

## P3-B button + button_group + toggle (deepseek, ses_ef0d6f5ebffe5cH0TdA68nY0hE) — ACCEPTED (r1)
- One ECONNRESET at start, resumed in the same session. Orchestrator re-ran: format 0 changed, analyze 0,
  test/registry_next 265/265, check_layers 0 errors, single_owner 0, check_user_theme --strict 0.
- Read: ButtonVariantStyle/ButtonTheme merge is receiver-wins per field (TextStyle merged fallback-under-receiver);
  disabled = whole control Opacity 0.5, no disabled colour rows; hover /90 primary+destructive, /80 secondary;
  destructive label uses destructiveForeground. Toggle owns ToggleStyle (no cross-component import), integrates
  FormValueSupplier. Focus ring keyboard-only via Clickable (tested).
- Accepted: button_test.dart 518 lines (tests not held to the 400 guideline); Toggle state-specific style beats
  generic theme. Phase 4 notes: Button.fixed (2 old users), SelectedButton (4) recorded in P3B_BUTTON.md.

## P3-D input + primitives/text_editing + primitives/input_features (deepseek, ses_ef0aa6d48ffeX0l9s1Ui8gixEt) — ACCEPTED (r2)
- r1: 301 tests green, 102 old files / 7.4k LOC → 5 files, but input.dart 831 + input_features.dart 919 lines
  (breaks ≤400 + flat component layout). Returned: move reusable machinery down into primitives.
- r2: components/input = input.dart 379, input_style 352, input_theme, preview; new primitives/text_editing/
  (4 files) and primitives/input_features/ (6 files), all ≤ 369 lines. Orchestrator re-ran: format 0 changed,
  analyze 0, test/registry_next 301/301, check_layers 0 errors (no new file-too-long), single_owner 0,
  check_user_theme --strict 0, no ignore/material/cupertino, autocomplete never imported. Tests cover
  double-tap/long-press selection, context menu (read-only drops Cut/Paste), copy/paste via clipboard, spinner clamp.
- Accepted: validator gets raw text ('' when empty); hint popover alignment ported (visual pass later);
  T1 OWNERSHIP.md one-line correction applied.

## P4-PRIM-A scroll_metrics, date_math, color_math, menu_nav (deepseek-v4.1-flash) — ACCEPTED (r1)
- Orchestrator re-ran on its 8 files (other batches in flight): format 0 changed, analyze 0, 56/56 tests; imports
  downward only; no static mutable state; contrastRatio = WCAG (luminance + 0.05). Old hex-parse crash fixed (returns
  null, regression test). Q1 scrollbar overscroll shrink stays in the component; Q2 typeahead reset = ctor param;
  Q3 nullable year bounds kept — all as recommended.

## P4-PRIM-B drag_sort, file_value/, toast_queue/ (space-bunny-free, ses_eef9aaff2ffeAtbMhe5cMMQqXh) — ACCEPTED (r2)
- r1: 93 tests, 14 old bugs fixed (incl. toast globals `_defaultToastController`/`_toastSequence` removed, centred
  toast had no dismiss direction, refreshed toast kept old timer, file size rounding); returned for file_value 462 /
  toast_queue 496 lines.
- r2: split into primitives/file_value/ and primitives/toast_queue/ folders (max 356 lines). Orchestrator re-ran its
  6 test files: 94/94, format 0 changed, analyze 0. Decisions: color_input stale consumer; B22 row = FileUploadRow;
  toast auto-dismiss policy documented once in ToastQueue (B09 toast + B18 gooey_toast must follow it).

## P4-B01 alert_dialog, badge, card, checkbox, chip, divider, switch (space-bunny-free#max) — ACCEPTED (r1)
- First launch failed instantly (network "Unable to connect"); relaunched 2026-10-08.
- Orchestrator re-ran on its 7 folders + tests (others in flight): format 0 changed, analyze 0, 151/151 tests, no
  banned imports; layout = name/style/theme/preview/meta/README only, max 357 lines; component deps declared
  (alert_dialog→dialog, chip→button); remaining check_layers findings belong to in-flight slider.
- Notable: SurfaceCard deleted (consumers switch to Card), CheckboxState → CheckboxValue, chip_utils not ported
  (B13 owns if needed). Private default-row names prefixed to keep single-owner 0.
- FOLLOW-UP (pilot): button_test hover assertion passes for the wrong reason (FocusableActionDetector needs
  highlightStrategy alwaysTraditional; hovered == pressed alpha) — fix in the pilot follow-up round.

## P4-B03 avatar, spinner(+circular), progress(+linear), triple_dots, icon, selectable (deepseek-v4.1-flash#max) — ACCEPTED (r1)
- Orchestrator re-ran on its 6 folders: format 0 changed, analyze 0, 64/64 tests, no banned imports, layout clean,
  max 399 lines, no component deps. 16 old bugs fixed (4 Material imports, debug-crash assert, triple_dots null
  colour crash, IconTheme merge precedence, wholesale theme resolution). Ratified: linear_progress_indicator →
  progress, circular_progress_indicator → spinner (determinate circular dropped: 0 consumers);
  IconContainerTheme name (avoids shadowing Flutter IconTheme); avatar badge uses shadcn ring, not notch clipper.

## P4-B02 slider + primitives/slider/ (fledge-alpha-free#max, ses_ee76947dfffely66q1yHgKP5VJ) — ACCEPTED (r3)
- First launch failed (network); r1 on fledge: widgets-only rewrite (~4.4k → ~1.5k LOC, 19 tests) but 3 extra files in
  the component folder. r2: logic/painter/controller moved to generic primitives/slider/ (B04 colour sliders reuse
  it), SliderValue.roundToDivisions deleted (dead), tests for precedence/dark/disabled/keyboard/range/snap/form.
  r3: unused `gap` dep removed, slider.dart 419 → 405.
- Orchestrator re-ran: format 0 changed, analyze 0, slider + all primitives tests 333/333, no slider layer findings
  except slider.dart 405 lines (accepted within ~400 tolerance).

## P4-B06 async, image, media_query, page_route, patch, switcher, dot_indicator, anchor, backdrop_transform (space-bunny-free#max, ses_ee733d598ffei2ROUiw1CnqbRQ) — ACCEPTED (r2)
- r1: 127 tests, real old bugs fixed (page route suppressed exit transition under dialogs, switcher unclamped index
  RangeError + setState misuse, DotItem animation had 0 readers + hard-coded greys, patch double-click had no spatial
  check, media_query 2/4 theme legs); `debug` deleted (helper-only, Q4 decision). Returned for `Image` clashing with
  Flutter's Image.
- r2: `ShadcnImage`; no other public name clashes. Orchestrator re-ran: format 0 changed, analyze 0, 129/129, layout
  clean, max 398 lines. Forwarded to B12: overlay_configuration must document the OverlayAnchorScope requirement.

## P4-B05 scrollbar, scrollview, scrollable, scrollable_client, outlined_container, collapsible, accordion (deepseek-v4.1-flash#max) — ACCEPTED (r1)
- qa_batch.sh: layout clean (max 372), format 0 changed, analyze 0, 56/56 tests, banned none, layers clean for B05,
  theme 0. fade_scroll stayed a primitive. 19 old bugs fixed (incl. scrollable_client updateRenderObject).
  Decisions: notification-driven fade viewport stays in scrollable; Dashed*Properties not restored (Studio can add
  later); scrollview needs no theme file.

## P4-B11 table, group (+ primitives/table_layout/; flex deleted) (longcat-2.5-preview-free, ses_ee6fc66a1ffeowdIxtOFPFvKMX) — ACCEPTED (r3)
- r1 (longcat's first batch): 28 tests, 11 table bugs fixed, ResizableTable folded into Table; returned for extra
  table_controller.dart, Table/TableRow/TableCell clashing with Flutter, zero-consumer flex, invented 16/8 padding,
  no resize a11y label, thin tests.
- r2: ShadcnTable/ShadcnTableRow/ShadcnTableCell, flex + paint_order deleted, shadcn defaults (p-2, head h-10 px-2
  mutedForeground, row border, hover muted/50), tableResizeColumn/Row keys (English fallback), table_layout tests.
- r3: theme classes moved back from the primitive into components/table/table_style.dart.
- qa_batch.sh: layout clean (max 352), format 0 changed, 34/34 tests, layers clean, owner 0, theme 0.
- Note: localizations.dart now 410 lines — split scheduled as a mechanical task once parallel batches settle.

## P4-B16 markdown (+ primitives/markdown_parser/) (muse-spark-1.3-contributor#xhigh, ses_ee712a305ffe2DpbrzIgjhzzrg) — ACCEPTED (r2)
- r1: 9,028 → ~2.7k LOC, 45 tests, 10 old bugs fixed, but dropped too much (images → alt text, reference links,
  footnotes, nested quotes > 2, details). r2 restored: network images (widgets-only Image.network + imageBuilder +
  alt-text loading/error fallback), CommonMark reference links/definitions, GFM footnotes, unlimited quote depth,
  <details> via the collapsible component, task lists (read-only visuals). Still dropped (documented): math, raw HTML
  output, asset/file sources, editing bar/controller/live preview, isolate/chunked render.
- qa_batch.sh: layout clean (max 390), format 0 changed, 59/59 tests, layers clean, theme 0. (Owner hit is calendar's
  CalendarValueLookup — B07 in flight.) B25 text_animate must adapt to the new API (see report).

## P3-F pilot follow-up (muse-spark-1.3-contributor#xhigh) — ACCEPTED (r1), input font → r2
- Replaced the screenshot agent (MiMo, 3 network-failed runs, no report) with widget metrics tests.
- Real bugs fixed: Button md 52 → 36 (Clickable padding stacked on minHeight; lg 44/px-5 → 40/px-6, text 14/w500);
  Toggle same stacking (52 → 36) + ToggleSize sm/md/lg 32/36/40, px-2; Dialog maxWidth 480 → 512; hover tests now
  truly drive hover (were passing because hover == pressed alpha). Dark-dialog light page = harness bug (fixed);
  dialog re-resolves theme live (new test). Input already 36.
- qa_batch.sh button toggle input dialog: format 0 changed, 51/51, layers clean, theme 0; pilot_metrics + visual green.
- r2: input text renders without the theme font (EditableText style lacks fontFamily) — real bug, fix in primitive.
- Follow-up for all batches: audit every component's sizes for the same padding-on-minHeight stacking.
- P3-F r2 ACCEPTED: resolveEditableTextStyle in primitives/text_editing — typed text + placeholder use the theme sans family (ambient → theme), size 14, mutedForeground hint; fixes input + text_area; input screenshots now show glyphs; input_menu PNGs have a generator. qa_batch input/text_editing clean (30 tests); text_area/selectable/pilot_metrics 63 green; visual 26 green. Orchestrator removed empty legacy `dependencies` blocks from button/input/slider/toggle meta.json (deps is the single source). Open: selectable builds its own EditableText style — fold into the helper in its next touch.

## P4-B09 drawer, toast, pagination, breadcrumb, steps (+ primitives/drawer_route/, toast_queue/toast_controller) (longcat-2.5-preview-free) — ACCEPTED (r1, after one network resume)
- qa_batch.sh: layout clean (max 397), format 0 changed, 76/76 tests, layers clean, theme 0. Old bugs fixed: drawer
  Material/data_widget/gap imports + layer-stack globals + SheetOverlayHandler coupling; toast global controller/
  sequence; pagination negative List.generate crash; steps Material VerticalDivider + trailing connector. Toast
  implements the ToastQueue auto-dismiss policy. Orchestrator stripped legacy `dependencies` blocks from meta.json.

## P4-B10 form, command, multiple_choice, star_rating, locale_utils (+ form_core files, subfocus_list_item) (deepseek-v4.1-flash#max) — ACCEPTED (r2, after one network resume)
- r1: 78 tests, 20+ old bugs fixed (form detach leak, dead submitted-mode revalidation, command stale-stream leak +
  Navigator crash, multiple_choice could not change selection, star_rating double onChanged + Material import,
  locale_utils RangeError). Returned for Form/FormField clashing with Flutter and missing CommandShortcut.
- r2: ShadcnForm/ShadcnFormField; CommandShortcut (text-xs, tracking-widest, mutedForeground). qa_batch: format 0
  changed, 79/79, layers clean, theme 0. Later batches must use ShadcnForm/ShadcnFormField.

## P4-M1 size audit of 22 accepted components (muse-spark-1.3-contributor#xhigh) — ACCEPTED (r1)
- 9 size drifts fixed: switch track 28×20 → 32×18.4 + centred 16 thumb; avatar 40 → 32 (badge 12 → 10); badge dot
  6 → 10 + badge/chip text height; checkbox outer 22 → 18 (indicator 12 → 14); slider thumb 20 → 16; alert title
  16 → 18; accordion chevron 20 → 16 + gap 16; dot_indicator pitch 28 → 20; selectable uses resolveEditableTextStyle.
- Verified unchanged: card p-6, alert max 512/p-6, table h-10/px-2/p-2, progress 8, divider 1, spinner 24, others.
- qa_batch on changed components: format clean, 207 tests pass, banned none, theme clean.
- Found a THEME TOKEN BUG: radius sm/md/xl derived as radius×8/12/20 (5/7.5/12.5) instead of shadcn v4 lg−4/lg−2/lg+4
  (6/8/14) → P4-M2. Decisions: card radiusXl, table header foreground, switch travel 14, badge rounded-md, markdown density kept.

## P4-B07 calendar, skeleton, carousel, tooltip, input_otp, text_area (space-bunny-free#max, ses_ee712cadbffe9rzlVbviRf2TFf) — ACCEPTED (r2)
- r1 (after one network resume): 215 tests, 12 bugs caught in fresh code; returned for missing calendar keyboard nav.
- r2: roving-tabindex day grid (arrows ±1/±7, Home/End, PageUp/Down ±month, Shift ±year, Enter/Space), disabled
  days skipped, full-date semantics (no double announcement), 32×32 cells; 4 bugs found by new tests. qa_batch:
  layout clean (max 399), 241/241, layers clean, theme 0. CalendarTheme lost dead copyWith/lerp.
- RULE BREACH: the agent committed calendar itself (69aa43f, not pushed, scoped to calendar + date_math + its test).
  Kept after review (content correct, scoped). An agent also pruned local remote-tracking refs (remote untouched).
  Orchestrator renamed private `_cell` → `_calendarCell` (single-owner clash with markdown_parser/media).

## P4-M2 radius tokens + size product calls (muse-spark-1.3-contributor#xhigh, ses_ee685fa5effeMDe2Zip6UnA28e) — ACCEPTED (r2)
- Theme bug fixed: radiusSm/Md/Xl now shadcn v4 (lg−4 / lg−2 / lg+4, clamped ≥ 0; xl = 0 when lg = 0) instead of
  radius×8/12/20. Default 0.625 → 6/8/10/14 (was 5/7.5/10/12.5). radius_tokens_test for 0/0.5/0.625/1.0.
- Table header text → foreground (shadcn v4); switch travel 14; card uses radiusXl (14). r1 exited before the suite
  finished; r2 fixed the 2 tests that encoded old radii. Orchestrator ran theme/themes/outlined_container/card/
  table/switch/size_audit/visual: 184/184, analyze clean. Preset screenshots regenerated.

## P4-B12 resizable, sortable, overlay_configuration, drawer_container (+ primitives axis_size, resizable_pane, resizable_handle, sortable_layer) (longcat-2.5-preview-free, ses_ee6940379ffe7UnE8UX0kB83x9) — ACCEPTED (r2)
- r1: 29 tests, big LOC cuts (overlay_configuration 1037 → 566, drawer_container 893 → 658), OverlayAnchorScope
  requirement documented, real drawer routes instead of deprecated popover shims. Returned for dropped
  ResizableHandle and sortable drop animation.
- r2: ResizableHandle(withHandle) restored (primitive, re-exported by resizable), arrow/Home/End keyboard,
  `resizableHandle` semantics key; sortable settle animation (200ms easeOut, disableAnimations → instant).
  qa_batch: layout clean (max 399), 34/34, layers clean, theme 0; 4 primitives analyze clean, all ≤ 278 lines.
- localizations.dart now 416 lines → mechanical split task queued.

## P4-B18 gooey_toast (+ primitives/gooey/, SileoSpringCurve, toast exit) (deepseek-v4.1-flash#max) — ACCEPTED (r2)
- r1: 41 tests, 12 old bugs fixed (Material sweep, frozen show-time theme, touch double-toggle, small-viewport clamp
  crash, global-pointer swipe, covered-toast expiry); shared toast_queue only. r2: animated exit for BOTH toast and
  gooey_toast (ToastEntry.isExiting two-phase, shared ToastExitTransition, disableAnimations instant), pill width
  measured with the painted style, six tone colours are GooeyToastTheme fields. qa_batch: 103/103, layers clean,
  theme 0. Known: 8 px settle when the newest toast is dismissed (minor).

## P4-B14 formatted_input, tree, stepper (+ primitives text_editing/segmented_*, tree_selection/) (space-bunny-free#max) — ACCEPTED (r2)
- r1: 64 tests; returned because tree dropped Shift-click range / Ctrl-click multi-select instead of fixing the
  stuck-flag bug. r2: Ctrl/Cmd toggle, Shift range from anchor, Shift+Arrow extend, Ctrl/Cmd+A, read from
  HardwareKeyboard at event time (no stored flags, regression test for focus change while Shift held).
  qa_batch: layout clean (max 399), 84/84, layers clean, theme 0; primitives analyze clean (logic tested via components).

## P4-B04 alpha, color, formatter, history, hsl, hsv (+ primitives color_field_paint, slider/color_field_slider) (fledge → deepseek after rate limit) — ACCEPTED (r1)
- First launch hung (0-byte log ~3h, relaunched); fledge rate-limited mid-run; resumed same session on deepseek.
- qa_batch: layout clean (max 367), 61/61, owner 0, theme 0 (color_tokens warning = substring match, pre-existing).
  Old bugs fixed: hsl/hsv tap+pan recognizer conflict (drags never reached onPanUpdate), shouldRepaint missing channel
  edits (hsl/hsv/alpha), HSL≠HSV-twin equality, unclamped RGB setters, history dedupe never matched (toARGB32 now),
  formatter signed clamp + decimalDigits stripping. hsl/hsv reuse primitives/slider. B08 color_field must reuse
  primitives/color_field_paint.dart; B24 color_picker must not re-declare HSL/HSVColorSliderType.

## P4-B19 error_system, feature_carousel, card_image, tracker (+ primitives/error_handling/) (longcat-2.5-preview-free) — ACCEPTED (r2)
- r1: 70 tests; 10+ old bugs fixed (Material imports ×5, dark-only literal themes, empty-list clamp crash,
  alpha-replacement hovers, deprecated LogicalKeySet, leaked WidgetStatesController, double tooltip, raw
  OverlayEntry snackbars). Returned because error_system dropped rules/repository/retry to fit the folder rule.
- r2: machinery restored in primitives/error_handling/ (models, rules, registry, retry/backoff, scopes) with unit +
  widget tests; tracker fine/warning colours are TrackerTheme fields. qa_batch: 95/95, layers clean, owner 0, theme 0.
- Follow-up: move error_system English fallback strings into primitives/localizations (l10n pass).

## P4-B15 scaffold, item_picker, refresh_trigger, number_ticker, code_snippet, country_flag, navigation_menu (+ primitives/countries.dart) (muse-spark-1.3-contributor#xhigh) — ACCEPTED (r1)
- 6,389 → 4,306 LOC, 80 tests, 20+ old bugs fixed (Material imports, DrawerOverlay global state, NaN minExtent, fake
  null-onRefresh cycle, ignored app theme leg, phonecodes package dependency → local 244-row ISO table with BSD
  attribution). qa_batch: layout clean (max 398), 80/80, layers clean, owner 0, theme 0.
- Decision: number_ticker takes a formatter callback (intl-free; NumberFormat shown in README) — accepted over Q2.
- Note: agent killed 2 stray flutter_tester processes; other batches re-verified by their own gates.

## P4-B17 chat, file_diff_viewer, border_loading, timeline, timeline_animation, overflow_marquee (+ primitives fractional_align_box, overlap_layout) (mimo-v2.6-flash) — ACCEPTED (r2)
- r1 (MiMo's first build): 67 tests, sizes vs shadcn, reduced-motion honoured, many old bugs fixed. Returned for
  dropped chat reactions and bubbles failing intrinsic-size queries. r2 (one network resume): reactions row via
  primitives/overlap_layout.dart, FractionalAlignBox primitive for intrinsic sizing. qa_batch: layout clean (max 399),
  83/83, layers clean, theme 0. Accepted: file_diff_viewer 8 theme fields, marquee fadePortion 0..0.5 fraction,
  SelectableRegion Overlay requirement documented, reaction insets as widget args + 5 ChatTheme chip fields.
- Single-owner hits at QA time belong to in-flight B13 (MenuGroupData, _resolve) and B23 (_Swatch).

## P4-B23 window, eye_dropper, alert, app, color_field (wrapper deleted) (+ primitives screen_capture, window_host, window_manager, window_snap) (deepseek-v4.1-flash#max) — ACCEPTED (r2, after one network resume)
- r1: 83 tests; old bugs fixed (window dual maximized paths, detached WindowActions throwing, ghost navigator entries,
  0×0 viewport flash, color_field shouldRepaint). FOUND a real localisation bug: en_US resolved to zh_Hant.
- r2: ShadcnLocalizations.resolveLocale — Locale('en') first, language match before script/country (tests en_US/en_GB/
  de_AT/zh_TW/zh_CN/unknown → en; no delegate warning); window snap-bar presets restored via primitives/window_snap.dart.
  qa_batch: 122/122, layout clean, layers only localizations.dart 557 lines (concurrent B08/B13 keys) → split next.
- Ratified: ColorField API, EyeDropperResult → ScreenSample, controller-required Window, 4 window/eye-dropper primitives.

## P4-B08 autocomplete, radio_group, empty_state, keyboard_shortcut, dropzone (+ primitives roving_group, selectable_radio/) (space-bunny-free#max) — ACCEPTED (r1, after one network resume; color_field moved to B23)
- qa_batch: layout clean (max 388), 156/156, layers clean, theme 0. 36 old bugs fixed (4 runtime crashes: idle dropzone
  Border.all(null), every keyboard_shortcut cap, themed RadioCard negative padding, themed compact empty_state).
  input_features gained onFocusGained + slotOf (bugs caught by tests); 13 English-fallback l10n getters (no invented
  translations). keyboard_shortcut reuses foundation/keyboard.dart typedefs.

## P4-B22 file_picker, navigation_bar (+ button border fix) and P4-B13 menu, hover_card, date_picker, time_picker — ACCEPTED (r2)
- B22 r2: grid/grouping/iconBuilder restored, NavigationGap/NavigationSlot restored; bordered button variants now 36
  (insetBorder in foundation/geometry.dart shared by button/toggle/navigation row). B13 r2 (fresh session after context
  overflow): menu checkbox/radio/label/shortcut/separator/sub rows + showShadcnMenu, DateRangePicker, 12h time format
  fixed, MenuGroupData single owner, popover zombie-OverlayEntry crash root-caused (ShadcnSelectionControls identity
  equality) and fixed in text_editing. Combined qa_batch: 182/182, layers clean, owner 0, theme 0.

## P4-B13b chip_input (+ text_editing token_* primitives) — ACCEPTED (r3: space-bunny ended early twice, finished on MiMo). qa_batch chip_input/input/text_editing: 75/75, layout clean (max 399), layers clean, owner 0, theme 0.

## P4-L1 localizations split + error_system strings (deepseek-v4.1-flash#max) — ACCEPTED (r1)
- localizations.dart 618 → 195 lines; domain mixins (form/overlay/date_time/error/misc) each ≤ 189; getter set identical
  before/after; no translation changed; 35 error getters (English fallback) used by error_system + error_handling.
  Deviation accepted: ShadcnLocalizations stays concrete (tests construct it; locale subclasses unchanged).
- FULL qa_gate.sh: format 0 changed (747 files), analyze 0, test/registry_next 2333/2333, rearch 38/38, layers only
  8 known file-too-long warnings, owner 0, theme 0, banned none, stray none.

## P4-B21 tabs, pinned_sheet, object_input (B21a, muse-spark) + swiper, stage_container (B21b, longcat) — ACCEPTED
- Original B21 session overflowed mid-batch; split into two fresh sessions.
- B21a r2: shadcn v4 tab sizes (list h-9 p-[3px], trigger px-2), object_input popover + dialog modes, sortable dispose
  crash (Data.maybeFind on unmounted context mid-drag) fixed with regression test. B21b r2/r3: swiper in-tree panel
  follows the finger + SwiperController; drawer slide-by-panel-extent bug fixed (panel appeared only in last ~40%);
  unused route-scrub API removed. stage_container: infinite-inset crash, const-assert, step guard, density fixed.
- Combined qa_batch (tabs pinned_sheet object_input sortable swiper stage_container drawer + 4 primitives): 102/102,
  layers clean, owner 0, theme 0.

## P4-B20 menubar, context_menu, dropdown_menu, spell_check_suggestions_toolbar, select, multi_select, popup (+ menu/menu_rows fixes, primitives roving_row, select_popup) (deepseek-v4.1-flash#max) — ACCEPTED (r2)
- r1: 69 tests; popup Escape fixed, select trigger border no longer inflates 36. Returned for: shared RovingRow padding
  stacking (44 instead of 32) + no hover/focus fill in the ACCEPTED menu rows; dropped select multi/canUnselect/
  autoClose/constraints; empty spell-check row.
- r2: menu rows 32 tall with accent hover/focus fill (fixed in primitives/menu_rows.dart; 2 menu test expectations
  updated with reason), consumer workarounds removed; select canUnselect/autoClose/popupConstraints restored, popup body
  in primitives/select_popup.dart; new installable `multi_select` component (chips + MenuCheckboxItem rows) — accepted;
  spellCheckNoSuggestions key (English fallback). qa_batch: 115/115, layers clean, owner 0, theme 0.

## P4-X cutover plan (muse-spark) — ACCEPTED as plan (not executed)
- 145/145 old dirs mapped (126 batch + 4 pilot + 14 primitive + tab_list); 5 blockers = B24/B25; post-cutover 118
  components (p4_batches.json "120" stale). No playground/example dirs (docs/lib/ui/shadcn is the live mirror);
  8 pubspec deps become removable (data_widget, gap, phonecodes, country_flags, cross_file, web, skeletonizer,
  animation_kit, email_validator).
- Orchestrator review of rearch/cutover.sh: dry-run default, refuses --apply on blockers/dirty tree/wrong branch, only
  git mv/git rm (recoverable). Not sufficient alone: step 4 import rewrites are manual and step 5 manifest tools still
  read the old layout → execute the cutover as an agent task following P4_CUTOVER.md, after USER APPROVAL.

## P4-B24 color_picker, phone_input, filter_bar (+ primitives/filter_core/) (deepseek-v4.1-flash#max) — ACCEPTED (r3)
- r1: 50 tests, 9+ old filter bugs fixed (debounce resurrect, stale sheet, breakpoint 720≠768, half-null ranges,
  controller-overrides-state, greaterThan/lessThan runtime-type crash). r2: filter grouping, phone typed-prefix
  detection + custom `countries`, date control 36, setState → setValue. r3: shared dial codes resolve to the primary
  country (+1 US, +7 RU, +44 GB …), current selection wins on ties. qa_batch: 69/69, layers clean, theme 0.
- Accepted: filter_core primitive, color_picker sub-API, 0–100 alpha in every mode, filter labels via l10n.

## P4-B25a text_animate (+ primitives/streaming_text/) (muse-spark-1.3-contributor#xhigh) — ACCEPTED (r1)
- 2,337 old LOC rebuilt on the accepted markdown + markdown_parser; reduced motion respected. qa_batch: layout clean
  (max 394), 29 component + 20 primitive tests pass, layers clean, owner 0, theme 0.

## P4-B25b color_input (+ color_picker responsive controls) (deepseek-v4.1-flash#max) — ACCEPTED (r2) — LAST COMPONENT
- r1: 29 tests; returned for a FittedBox.scaleDown workaround. r2: color_picker controls wrap (no overflow at 280,
  unchanged ≥ 480), history grid scrolls horizontally when narrow, FittedBox removed; colorPickerControlsWidth helper
  accepted. qa_batch color_input + color_picker: 51/51, layers clean, owner 0, theme 0.

## P6-A docs design (muse-spark, Open Design project shadcn-flutter-kit-docs) — ACCEPTED (r1)
- 10 HTML mockups (landing, docs shell, Button + Dialog component pages, components index, themes (+ light/tangerine),
  getting started, CLI reference, ⌘K palette, mobile) — all `opendesign lint` P0/P1/P2 clean; artifacts created in the
  OD project; PNGs captured with agent-browser (OD image export needs the desktop runtime). Modern-minimal direction on
  shadcn tokens, dark-first + light, motion spec in rearch/reports/P6_DOCS_DESIGN.md.
- Orchestrator review: strong visual quality. Notes for the Flutter build: sticky header mid-page in screenshots is a
  full-page-capture artefact; mockup copy has placeholder facts (heightMd 40 vs real 36, labelStyle w600 vs w500,
  "2 files per component" vs 3 Dart files) — the build must GENERATE API tables / deps / stats from the real
  registry (meta.json, manifest, source), never from the mockups; preset gallery (12/42) + marquee from full data.

## P6-B docs build plan (muse-spark) — ACCEPTED: minimal router on ShadcnApp.router + AnimatedShadcnTheme, generated catalog/API/search (docs/tool/gen_docs_data.dart, --check in CI), one component template for all 118 with deferred previews, docs app_theme byte-identical to gen_app_theme, batches D1→{D2∥D3}→D4→D5→D6 (D6 = visual check vs mockups). Gaps: popover→popup, chart→docs-only CustomPaint on chart1..5 tokens.

## P5-B3 CLI lock file v2 + hashing (space-bunny-free#max) — ACCEPTED (r1)
- lock v2 (registry ref, per-layer units, file sha256, userOwned flags, theme preset; drift report; merge). Own files:
  format clean, analyze 0, 50/50 tests. Whole suite +274 −14: expected clean-break failures in old installer/resolver
  code owned by B4/B5/B7. Finding for B4: package:analyzer is NOT a declared CLI dependency (add to dev_dependencies
  or avoid it). Orchestrator note: qa scripts now use `dart format --output=none` (a check run had reformatted 3 CLI
  test files; reverted).

## P4-Z CUTOVER (deepseek-v4.1-flash#max) — ACCEPTED (user-approved 2026-10-09)
- registry_next → lib/registry; old tree deleted (145 dirs, 361,090 lines); 188 files rewritten registry_next → registry;
  test/registry_next → test/registry; retired 6 examples, 10 old tests, ~70 old-layout tool files; new
  tool/registry/gen_registry_manifest.dart → lib/registry/manifests/registry.json (19 foundation, 6 theme, 73 primitive
  units, 90 primitive edges, 118 components, 42 presets, 651 hashes; --check + schema + closure test); 9 packages removed
  (data_widget, gap, phonecodes, country_flags, cross_file, web, skeletonizer, animation_kit, email_validator).
- Orchestrator re-ran: qa_gate clean (2652 registry tests + 42 rearch), whole-project flutter analyze 0, manifest --check
  up to date. Findings for CLI: primitive graph has cycles (clickable↔clickable_state, overlay_manager↔layer, popover
  cluster) → CLI closure must be cycle-tolerant; schema componentTheme amended for nested popupTheme/menubarTheme.
- NOTE: the mechanical git mv/rm (3889 files) was staged by the agent and got swept into orchestrator commit 8d04b3a
  ("P6 docs build plan") — contents correct, message wrong; not rewritten (would need force-push). Orchestrator now
  checks `git diff --cached` before every commit.

## 2026-10-09 USER DECISION: Open Design docs mockups REJECTED. The docs website must be designed like https://ui.shadcn.com/ (same structure/layout/spacing/typography/colours/components; own name, logo and copy). P6-A2 captures + specs it; P6_DOCS_BUILD_PLAN D3–D6 will be re-targeted to P6_SHADCN_SITE_SPEC.md. Router/state/codegen/sync (D1, D2) unaffected.

## P5-B1 CLI manifest v2 models + validator (longcat) — ACCEPTED (r1)
- RegistryManifest/ManifestComponent/ManifestUnit/ThemePreset (+ packages), hand-written validator (schema rules +
  closure/id checks), fixture registry_v2; 9 v1 model files deleted. Own files: format clean, analyze 0, 53/53 tests.
  Whole package: expected intermediate break (249 analyzer errors / 24 failing suites in installer+commands owned by
  B4/B5). Decisions for B5: delete schema_source.dart if still unreferenced; v2 validation exception lives with the
  validator (lib/src/registry/manifest/). Reverted 2 format-only edits to old installer tests (B4 rewrites them).

## P5-B4 CLI installer core (longcat) — ACCEPTED (r1)
- manifest_closure (cycle-tolerant DFS), installer + file-install/remove/lock parts, dry_run_plan, pub_package_resolver
  (injectable runner); 19 v1 installer files + 4 old tests deleted; fixture registry_v2 now has real Dart sources;
  golden install asserts tree + shadcn.lock byte-for-byte. 49/49 tests, analyze 0, files ≤ 383 lines.
  Follow-ups → B5: relax B1 _checkPrimitiveCycles; remap v1 Installer callers; HTTP registry reader; drift-driven update.

## P6-D1 docs shell (deepseek-v4.1-flash#max) — ACCEPTED (r1, ended on ECONNRESET after its report)
- New docs app skeleton: minimal router (+ ⌘K palette route), DocsState, motion helpers, stub generated data,
  tool/sync_registry.sh mirror of lib/registry into docs/lib/ui/shadcn (Dart sources only — same as CLI install);
  3,827 old docs files deleted (old pages, loaders, category mirror, python scripts, go_router/syntax_highlight).
  Orchestrator re-ran: format 0 changed, flutter analyze 0, 20/20 tests, no Material/Cupertino imports; release web
  build in report. Leftovers (to D3/D6): docs Makefile/README describe old app; web/manifest.json name; unreferenced
  325K user-guide PDF; ⌘K needs one manual post-deploy check.

## P5-B6 CLI theme (space-bunny-free#max) — ACCEPTED (r1), r2 for generator polish: theme list/apply, ThemeService, app_theme generator byte-identical to the kit (golden), drift reporting; 103/103 theme tests, analyze 0. r2: format-clean output, CLI-flavoured header, own drift exit code, themes in manifest fileHashes.
- P5-B6 r2/r3 ACCEPTED: CLI theme 106/106, exit code 80 theme_drift (doc/reference/exit-codes.md row still owed — B5/B7), full v2 validation in theme flow; kit generator + manifest changes committed fe2d42c.

## P5-B5 CLI commands + registry source (longcat) — ACCEPTED (r1): cycles relaxed in B1 validator, init/add/remove/update/list/search/info/doctor, remote GitHub registry + cache, v1 callers remapped/deleted. WHOLE CLI: format clean, analyze 0, 461/461 tests. Gaps → B7: update doesn't install new upstream files of installed components; command_metadata.dart 555 lines (split); exit-code 80 row in doc/reference/exit-codes.md.

## P6-D2 docs codegen (deepseek-v4.1-flash#max) — ACCEPTED (r1): docs/tool/gen_docs_data.dart → lib/generated/{docs_data,docs_api,docs_tables,docs_search,docs_snippets,app_theme}.dart + lib/previews/component_previews.dart (118 deferred). 118 components, 42 presets (app_theme byte-identical to kit, test-enforced), 290 snippets, 110 API tables, 12 CLI commands; keyboard gaps listed not invented. Orchestrator: format/analyze 0, tests green, --check up to date. Follow-ups: function-first API (showShadcnDialog params) for D4; bump kit analyzer dev-dep (3 files unparsable by 6.4.1); re-measure JS budget in D4/D6.
