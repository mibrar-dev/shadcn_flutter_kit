# Brief P7-U1b — finish P7-U1 in a fresh session

Binding brief: `rearch/briefs/fixes/P7-U1-overlays.md`. Progress so far: `rearch/reports/P7-U1.md` (items 1–9 done,
item 10 ⏳). The previous session died ("reasoning item expired").
1. Your Select API change broke docs callers: `docs/lib/widgets/studio_blocks/studio_tabs.dart:340` and
   `docs/lib/widgets/collage_cards_forms.dart:175` (`items` now required, `child` removed). Migrate every docs/registry
   caller of the changed APIs (grep the whole repo: docs/lib, lib/registry/blocks, previews) to the new API.
2. Item 10: docs sync (run) + --check, codegen --check, docs format/analyze/test, `flutter build web --release`,
   `rearch/qa_gate.sh`, manifest/previews/blocks generators --check; agent-browser captures listed in the brief.
3. Update `rearch/reports/P7-U1.md` (mark 10 done, gate outputs) and its `## RESULT` block.
Other agents are editing blocks (P7-B1), forms/pickers (P7-U2), component QA (P7-Q1/Q2b), meta listed flags (P7-Q0):
don't revert their files; if a gate fails only on their in-flight files, record it. Pipe long outputs through `tail`.
Do NOT open PNG images. No git ops.
