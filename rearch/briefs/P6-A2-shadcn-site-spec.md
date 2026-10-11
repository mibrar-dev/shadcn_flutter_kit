# Brief P6-A2 — capture ui.shadcn.com and write an exact build spec for our docs site

## Why
The user rejected the Open Design mockups. Our docs website must be designed LIKE the shadcn/ui website
(https://ui.shadcn.com/) — same structure, layout, spacing, typography, colours, components, interactions — rebuilt in
Flutter with our registry components. shadcn/ui is MIT-licensed (site source: github.com/shadcn-ui/ui, `apps/v4`), so
reproducing its design is fine. Do NOT copy their logo, the "shadcn" brand name, or their prose verbatim: our product is
`shadcn_flutter_kit` (Flutter, CLI `flutter_shadcn`), with our own text and an original simple logo mark.

## Capture (use `agent-browser`; run `agent-browser skills get core` first)
Viewports 1440×900 and 375×812, light AND dark (site has a theme toggle). Save PNGs to
`$KIT/rearch/design/shadcn-ref/screens/<page>-<w>-<mode>.png` (full-page where useful + above-the-fold).
Pages: home `/`; `/docs` (introduction); `/docs/installation`; `/docs/components` (index); `/docs/components/button`;
`/docs/components/dialog`; `/docs/components/data-table` or another long page (TOC + code blocks); `/docs/theming`;
`/docs/dark-mode`; the themes/customize page (find it from the nav, e.g. Create or /themes); `/docs/cli`; `/blocks` and
`/charts` (reference only — we may not ship them); states: command menu open (⌘K / "Search…"), mobile nav menu open,
code tab selected on a component preview, install-command tabs, copy-button "copied" state, hover on sidebar item.

## Measure (exact values — `agent-browser eval` / `get styles` / `get box`)
Header (height, blur/background, border), container max-widths and side padding per breakpoint, docs sidebar width +
item heights/padding/font/active state, content max-width, right TOC width + active indicator, breadcrumb, H1/H2/H3/
lead/paragraph/inline-code/code-block typography (family, size, weight, line-height, letter-spacing, colour), component
preview frame (border, radius, padding, min-height, background), Preview/Code tabs, install tabs, copy button, prev/next
pager, footer, cards on home, CSS variables in `:root` and `.dark` (all tokens incl. radius), breakpoints, transitions
(durations/easings actually used — the site is restrained; record what exists, do not invent motion).
Also read the site source on GitHub (`apps/v4/components/site-header.tsx`, docs sidebar/layout/TOC/component-preview/
code-block/command-menu components, `app/(app)/...` page layouts, `styles/globals.css`) via raw.githubusercontent.com to
confirm classes — cite file paths.

## Write `$KIT/rearch/reports/P6_SHADCN_SITE_SPEC.md`
1. Sitemap for OUR site mirroring theirs: Home, Docs (Introduction, Installation, Theming, Dark mode, CLI, …),
   Components (index + 118 pages), Themes (our 42 presets in their customize/theme UI style); Blocks/Charts: list what
   they are and recommend whether we include them (we have no chart component; don't invent).
2. Per page: structure tree with exact measurements/tokens/typography, states, responsive behaviour, interactions.
3. Global: tokens (map their CSS vars → our ShadcnTheme token names — they are the same names), fonts (Geist), radii,
   shadows, breakpoints, motion actually used.
4. Element → our registry component map (`flutter_shadcn_kit/lib/registry/components/`), docs-only widgets where needed.
5. Delta vs our current plan `rearch/reports/P6_DOCS_BUILD_PLAN.md` (§3 page map, §4 motion, §6 batches D3–D6): what
   changes now that the reference is shadcn's site instead of the Open Design mockups.
Do not write Flutter code. Finish with the `## RESULT` block.

## Outputs (only these)
`$KIT/rearch/design/shadcn-ref/**`, `$KIT/rearch/reports/P6_SHADCN_SITE_SPEC.md`.
