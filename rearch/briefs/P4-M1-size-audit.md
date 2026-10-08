# Brief P4-M1 — size audit of already-accepted components vs shadcn/ui

The pilot follow-up found buttons 16px too tall: padding applied OUTSIDE a ConstrainedBox/minHeight stacked on top
of it (md 52 instead of 36). Components accepted before that rule may have the same bug or other size drift.

## Components to audit (all in `lib/registry_next/components/`)
alert_dialog, badge, card, checkbox, chip, divider, switch, slider, avatar, spinner, progress, triple_dots, icon,
selectable, scrollbar, scrollview, outlined_container, collapsible, accordion, dot_indicator, table, markdown
(markdown: only code-block/inline-code/heading/paragraph spacing).

## Do
1. For each, write metric assertions with `tester.getSize`/`getRect` in
   `test/registry_next/components/size_audit_test.dart` (split into `size_audit_a_test.dart` / `_b_` if > ~400
   lines) against shadcn/ui new-york values from the shadcn source (e.g. badge px-2 py-0.5 text-xs h≈22, checkbox
   size-4 = 16, switch h-[1.15rem] w-8 = 18.4×32 with size-4 thumb, avatar size-8 = 32, card p-6 / gap-6 / radius-xl,
   alert-dialog max-w-lg 512 p-6, accordion trigger py-4 text-sm, progress h-2, divider 1px, table cell p-2,
   chip ≈ badge-like). Cite the shadcn class for each expected value in a comment.
2. Where a test fails, FIX the component (style tables / padding placement) — never loosen the test to the wrong
   value. Keep files ≤ ~400 lines and all existing tests green (update tests that encoded wrong sizes; list them).
3. `selectable` builds its own EditableText style: switch it to `resolveEditableTextStyle` from
   `primitives/text_editing/editable_text_style.dart` (theme font) + a test.
4. Report `rearch/reports/P4-M1.md`: table component → measured before → shadcn value → after, and every file changed.

## Outputs (only these)
The listed component folders, their existing tests, the new size_audit test files, `rearch/reports/P4-M1.md`.
Other batches are being built in parallel: never touch other folders.

## Gates
`cd $KIT && rearch/qa_batch.sh <every component you changed>` — clean.
