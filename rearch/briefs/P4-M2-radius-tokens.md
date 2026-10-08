# Brief P4-M2 — radius tokens match shadcn v4 + size-audit product calls

## 1. Radius token bug (theme layer, `lib/registry_next/theme/theme.dart:79-82`)
shadcn v4 (`globals.css`): `--radius-sm: calc(var(--radius) - 4px)`, `--radius-md: calc(var(--radius) - 2px)`,
`--radius-lg: var(--radius)`, `--radius-xl: calc(var(--radius) + 4px)` (with `--radius: 0.625rem` = 10px → 6/8/10/14).
Ours: sm = radius*8, md = radius*12, lg = radius*16, xl = radius*20 → 5/7.5/10/12.5 — only lg is right.
Fix: lg = radius*16 (px of the rem value); sm = max(0, lg-4); md = max(0, lg-2); xl = lg+4. Check presets with
radius 0 (all radii must be 0 — clamp) and large radii. Update the token docs (tokens.dart:377), THEME_DESIGN note,
and every test that hard-coded the old values. Add `test/registry_next/theme/radius_tokens_test.dart` for radius
0 / 0.5 / 0.625 / 1.0. Run the whole suite — any component test that changes must change for the right reason.

## 2. Product calls from P4-M1 (decided by the orchestrator)
- card: radius `radiusXl` (shadcn v4 `rounded-xl` → 14 after §1).
- table header text: `foreground` + font-medium (shadcn v4 TableHead `text-foreground`), not mutedForeground.
- switch: checked thumb travel = track width − thumb − 2 = 14 (shadcn `translate-x-[calc(100%-2px)]`).
- badge `rounded-md` (v4) — keep. markdown prose density — keep.
Add/adjust size assertions in the size_audit tests.

## Outputs
`lib/registry_next/theme/**`, `components/{card,table,switch}/**`, tests under `test/registry_next/**` that encode
radii/sizes, `rearch/reports/THEME_DESIGN.md` (one-line note), `rearch/reports/P4-M2.md`.
Other batches are in flight — touch only these paths.

## Gates
`cd $KIT && rearch/qa_gate.sh` (full) — report its output; must be clean except other batches' in-flight files.
