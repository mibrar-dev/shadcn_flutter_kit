# Brief P7-U2 — radio group spacing, date/time picker dialogs, form-control spacing audit (user screenshots 2026-10-11)

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit, DOCS=$KIT/docs.
Evidence: `rearch/design/ours/screens/user-bugs-2026-10-11/radio-group-no-gap.png`. Do NOT open/read PNG images yourself (the model crashes on images) — the screenshots are described here precisely; verify every fix with widget tests that read real rects/sizes/colours, light + dark, neutral + claude, density compact/default/comfortable. Design principles: shadcn/ui v4 values (look them up at ui.shadcn.com / the shadcn source via agent-browser, SHORT commands) and Vercel Geist (vercel.com/geist): quiet surfaces, 1px border at the border token, subtle shadow, hover/highlight = accent background only (no thick borders/rings on menu items), focus ring only for keyboard focus (1px–2px ring token at reduced alpha), consistent control heights (h-9 / 36px default, scaled by density), consistent paddings from theme tokens. All spacing from the theme (density/spacing tokens); components hug content — never stretched, never compacted.

You own: registry `radio_group` (+ primitive `selectable_radio`), `checkbox` group usage, `switch`, `toggle`,
`calendar`, `date_picker`, `time_picker`, `dialog` (sizing only), `slider`, `input`, `text_area`, `form`,
`field`-like label rows. Do NOT touch menu/select/command/popup/overlay primitives (agent P7-U1 owns them).

1. RadioGroup: items stack with zero gap (Free/Pro/Team rows touch). shadcn: grid gap-3 (12px × density) between items;
   radio size-4 (16px); label gap-2 (8px) from the radio; text-sm; label row vertically centred; whole row clickable.
   Same check for checkbox lists, switch rows, toggle groups.
2. Date picker / time picker dialogs are far too big. They must feel like ONLY the calendar (or the time wheel/fields)
   plus Cancel / Save: dialog shrink-wraps its content (no min/fixed large width or height), calendar p-3 with cell
   size-8 (32px × density), header caption + chevron nav; footer row right-aligned buttons with gap-2, p-3 top border
   optional; popover variant: w-auto p-0. Time picker: compact columns/fields, same footer. Mobile 375: fits without
   scroll where possible.
3. Audit every form control for spacing consistency (label → control gap 8px, control height h-9 density-scaled,
   helper/error text gap 6px text-sm muted, group gaps 12–16px) and fix deviations at the root.
Tests: radio item gaps == 12×scale; date/time dialog size == content size (+ padding) and ≤ 360×420 at default density;
footer buttons present and aligned; all in light/dark, neutral/claude, 3 densities.
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest/previews/blocks --check (regenerate); docs format/analyze/test/codegen
--check/sync/--check/build web --release (coordinate: if P7-U1 is mid-change and docs fails to compile on ITS files,
report it, don't edit its files). Captures → `rearch/design/ours/screens/p7u2-*.png` (radio group, date picker dialog,
time picker dialog, a form). Report `$KIT/rearch/reports/P7-U2.md`, `## RESULT`. Append progress. No git ops.
