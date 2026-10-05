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
