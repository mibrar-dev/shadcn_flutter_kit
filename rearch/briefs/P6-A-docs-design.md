# Brief P6-A — design the new docs website with Open Design (design only, no Flutter code)

## Product
`shadcn_flutter_kit` — a shadcn/ui-style design system for Flutter, distributed as copy-paste source through a CLI
(`flutter_shadcn add button`). 118 components, every one installable on its own; widgets-only (no Material/Cupertino);
theme = shadcn CSS-variable tokens (background, foreground, card, popover, primary, secondary, muted, accent,
destructive, border, input, ring, chart-1..5, sidebar-*, radius) with 42 presets; each component has a user-owned,
Studio-editable theme file. Audience: Flutter developers who know shadcn/ui and want the same quality in Flutter.

## Goal
A modern, motion-rich, Linear/Vercel-grade docs website that will be REBUILT IN FLUTTER (web) using only the kit's own
registry components. Design it first in Open Design, as HTML mockups, so the Flutter build can follow it exactly.

## Tooling — Open Design CLI (binary `opendesign`; `od` on this machine is the unix octal-dump tool, do not use it)
- Daemon already running: `export OD_DAEMON_URL=http://127.0.0.1:7456`; project id `shadcn-flutter-kit-docs`.
- Direction: `opendesign tools directions --id modern-minimal` (palette, font stacks, posture) — adapt it to shadcn
  tokens (zinc neutrals, near-black/white, one restrained accent); dark-first, with a full light mode.
- For each page: write a self-contained HTML file (inline CSS + small vanilla JS for motion/interaction, no frameworks,
  no CDN), then `opendesign artifacts create --name <page>.html --input <file> --project shadcn-flutter-kit-docs`,
  lint with `opendesign lint <file> --fail-on p1` (fix every P0/P1), and export PNGs with
  `opendesign export <file> --project shadcn-flutter-kit-docs --format image --out <png>` at desktop 1440 and mobile 375
  (if export cannot set width, add a ?w= or separate mobile file).

## Pages / states to design
1. Landing: hero with an animated collage of REAL component shapes (button, card, input, switch, tabs, calendar,
   toast, command palette) that assemble on load; headline + subline; install command block with copy feedback;
   live preset switcher that re-themes the collage with a smooth colour morph; feature grid (installable alone,
   token theming + 42 presets, widgets-only Flutter, user-owned theme files / Studio-ready, accessible + keyboard);
   infinite component marquee; "how it works" 3-step (init → add → own the code); footer.
2. Docs shell: left sidebar (search with ⌘K hint, sections: Getting started, Theming, Components by category, CLI),
   top bar (logo, version badge, docs/components/themes/CLI links, preset picker, light/dark toggle, GitHub),
   content column, right "On this page" TOC with scroll-spy, breadcrumb, prev/next pager.
3. Component page (template — show it for Button and Dialog): title, description, install tabs (CLI | manual copy),
   live preview card with controls (variant, size, disabled, light/dark, preset) and a code tab with copy; examples
   gallery; API tables (constructor params, theme fields with types/defaults); keyboard & accessibility table;
   "dependencies" chips (primitives/components it pulls in); related components.
4. Components index: search + category filters + grid of cards each with a small live preview and install count of files.
5. Themes: 42-preset gallery with swatches; live re-theme of a sample dashboard (cards, chart, table, form);
   token table; radius + density controls; export (JSON / Dart app_theme) — "Studio" teaser.
6. Getting started: numbered steps timeline (install CLI → init → add → theme) with code blocks.
7. CLI reference: commands table with flags and examples.
8. Command palette (⌘K) overlay; mobile (375) layouts for landing + component page + nav drawer.

## Motion spec (write it precisely — the Flutter build implements it)
Durations 150 / 200 / 300 / 500 ms; default easing cubic-bezier(0.16, 1, 0.3, 1) (ease-out-expo), exits ease-in 150ms.
Page/route: fade + 8px rise, 200ms. Scroll reveals: fade + 12px rise, 300ms, 40ms stagger, once. Hover: cards lift
2px + shadow-sm→md 150ms; buttons are colour-only. Preset switch: colour tween 300ms across all tokens (no layout jump).
Hero collage: pieces spring in (stiffness feel ~ 0.5s, slight overshoot ≤ 4px) then idle float ±3px over 6s.
Copy button: icon swap + 1.5s "Copied" state. Respect prefers-reduced-motion (no transforms, opacity only, ≤ 150ms).
Everything must be implementable in Flutter with implicit/explicit animations — no WebGL, no canvas particle systems.

## Constraints
- Every UI element must map to a registry component (button, card, input, tabs, select, command, dialog, drawer,
  navigation_menu, scrollview, scrollable, tooltip, badge, code_snippet, markdown, table, accordion, switch, toggle,
  chip, calendar, chart-like shapes may be drawn, etc. — see `flutter_shadcn_kit/lib/registry_next/components/`).
  Where nothing fits, mark it "docs-only widget" and keep those few and simple.
- Typography: Geist Sans / Geist Mono; 4px spacing grid; max content width ~ 768 for prose, 1280 for grids.
- Accessible contrast (WCAG AA) in both modes; visible focus rings (ring token).
- Do NOT write or change Flutter/Dart code.

## Outputs (only these, in the kit repo `$KIT`)
- `$KIT/rearch/design/docs/*.html` (one per page/state) and `$KIT/rearch/design/docs/screens/*.png`
- `$KIT/rearch/reports/P6_DOCS_DESIGN.md`: sitemap + routes, per-page spec, component mapping table (element →
  registry component / docs-only), design tokens used (mapped to ShadcnTheme token names), full motion spec, responsive
  breakpoints, Flutter implementation notes (routing, code highlighting, live-preview harness, search index), and the
  lint results per file. Include the Open Design artifact names you created.
Finish with the `## RESULT` block.
