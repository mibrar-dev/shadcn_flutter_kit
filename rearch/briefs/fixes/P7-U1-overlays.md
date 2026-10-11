# Brief P7-U1 — overlay / menu / select / command fixes (user screenshots 2026-10-11)

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit, DOCS=$KIT/docs.
Evidence (for the record): `rearch/design/ours/screens/user-bugs-2026-10-11/*.png`. Do NOT open/read PNG images yourself (the model crashes on images) — the screenshots are described here precisely; verify every fix with widget tests that read real rects/sizes/colours, light + dark, neutral + claude, density compact/default/comfortable. Design principles: shadcn/ui v4 values (look them up at ui.shadcn.com / the shadcn source via agent-browser, SHORT commands) and Vercel Geist (vercel.com/geist): quiet surfaces, 1px border at the border token, subtle shadow, hover/highlight = accent background only (no thick borders/rings on menu items), focus ring only for keyboard focus (1px–2px ring token at reduced alpha), consistent control heights (h-9 / 36px default, scaled by density), consistent paddings from theme tokens. All spacing from the theme (density/spacing tokens); components hug content — never stretched, never compacted.

You own: registry `menu`, `menubar`, `dropdown_menu`, `context_menu`, `navigation_menu`, `popup`, `select`,
`multi_select`, `command`, `autocomplete` and primitives `menu_nav`, `menu_rows`, `popover*`, `select_popup`,
`overlay*`.

1. Menu popup (home card "Menu bar"/sidebar demo): the popup opened from a trigger is NOT anchored to it — it appears
   shifted left/down, overlapping other cards, and is far too wide (~570px for two short items). Fix anchoring: popup
   aligns to the trigger (start edge, sideOffset 4px, flips/shifts to stay on screen, RTL aware) and sizes to content
   (min-width 8rem / 128px, max = viewport − margin). The highlighted item shows a thick light/white border ring —
   remove it: highlighted/hovered item = rounded-sm accent background + accent-foreground text, no border; item padding
   px-2 py-1.5 text-sm, popup p-1, rounded-md, 1px border, shadow-md, bg popover. Apply to every menu-like popup.
2. Select popup collapses to a tiny width so each option wraps per character ("6 / a", "1 / 0 / a"). Popup width =
   max(trigger width, widest option intrinsic width), never narrower than the trigger, options single-line
   (ellipsis only if the viewport forces it), check indicator on the right (pr-8), items py-1.5 pl-2 text-sm, max height
   = available space with internal scroll. Same for multi_select / autocomplete / combobox-style popups.
3. Command (palette and inline): the input row is oversized with a heavy rounded focus border while list items are
   small. shadcn: input row h-9 (density-scaled) with bottom border only, search icon size-4 at 50% opacity, text-sm,
   no ring around the input inside the command surface; list p-1, items px-2 py-1.5 text-sm rounded-sm, group headings
   text-xs muted px-2 py-1.5, no separators between every item (only between groups), max list height 300px scroll.
   The command surface itself: rounded-lg border bg-popover; dialog variant: max-w-lg, p-0, shadow-lg.
4. Audit every other overlay (popover, hover_card, tooltip, dialog headers, sheet menus) for the same anchoring/width/
   highlight issues and fix.
Tests: anchoring rect vs trigger (±1px) at 1440/375 incl. near-edge flipping; popup width rules; no border on
highlighted item; select option single-line; command input height == item height scale per density.
Gates: `cd $KIT && rearch/qa_gate.sh`; manifest/previews/blocks --check (regenerate); docs format/analyze/test/codegen
--check/sync (run sync)/--check/build web --release. Captures via agent-browser (home menu card, a select demo,
⌘K palette, /docs/components/select, /docs/components/command) → `rearch/design/ours/screens/p7u1-*.png`.
Report `$KIT/rearch/reports/P7-U1.md`, `## RESULT`. Append progress as you go. No git ops.
