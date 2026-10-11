# P6 — Docs Website Design (Open Design, HTML mockups)

Design-only phase for the Flutter-web docs rebuild. Every page is a self-contained
HTML file (inline CSS + small vanilla JS, no frameworks, no CDN) so the Flutter
build can follow it exactly. Direction: `modern-minimal` adapted to shadcn tokens
(zinc neutrals, near-black/white, one restrained blue accent); dark-first with a
full light mode. Typography: Geist Sans / Geist Mono stacks with system fallbacks.

## Sitemap → routes → files

| Route | File | Purpose |
|---|---|---|
| `/` | `01-landing.html` | Hero + animated collage, install cmd, preset switcher, features, marquee, 3-step, footer |
| `/docs` | `02-docs-shell.html` | Shell: sidebar + ⌘K, top bar, content, TOC scroll-spy, breadcrumb, prev/next |
| `/docs/components/button` | `03-component-button.html` | Component template instance: Button |
| `/docs/components/dialog` | `04-component-dialog.html` | Component template instance: Dialog (live modal) |
| `/docs/components` | `05-components-index.html` | Search + category filters + cards with mini previews + file counts |
| `/themes` | `06-themes.html` | 12-preset live gallery, re-themed dashboard, token table, radius/density, export, Studio teaser |
| `/docs/installation` | `07-getting-started.html` | Numbered timeline install → init → add → theme, verify checklist |
| `/docs/cli` | `08-cli-reference.html` | add / init / theme / list · remove · doctor with flags + examples |
| overlay (any route, ⌘K) | `09-command-palette.html` | Palette open state + key spec |
| responsive states | `10-mobile.html` | Three 375px frames: landing, component, nav drawer + breakpoint table |

## Per-page spec

- **Landing:** sticky frosted nav (logo, version badge, links, theme toggle, GitHub, CTA);
  hero grid (headline, subline, `$ flutter_shadcn add button` block with 1.5s Copied
  feedback, CTAs, 6-preset switcher re-theming the collage); collage of 8 live pieces
  (button row, switch, card, input, tabs, calendar, toast, ⌘K bar); stats band
  (118 / 42 / 0 / 2); 6-card feature grid; infinite marquee (40s loop, pauses on
  hover); 3-step cards with code; CTA band; 4-column footer.
- **Docs shell:** 270px sticky sidebar (search button with ⌘K hint, 4 section groups,
  active item = accent fill + ring edge, file-count chips); top bar with preset
  `<select>`, theme toggle, GitHub; 768px content; sticky TOC with scroll-spy
  (IntersectionObserver, `-30%/-60%` margins); prev/next pager (lift 2px on hover).
- **Component template (Button/Dialog):** title + file-count + stability badges;
  install tabs (CLI | manual copy, manual lists exact files + ownership note); preview
  card (stage + controls: variant/size/disabled/mode/preset for Button; mode/preset/
  scrim-dismiss for Dialog); Button demo updates live; Dialog opens a real modal
  (scrim/Esc/buttons, focus to first field, focus restore); 4-example gallery; API
  table (params) + theme-fields table (user-owned file badge); keyboard/a11y table;
  dependency chips; 3 related cards.
- **Components index:** sticky toolbar (search with `/` shortcut, 6 category pills,
  live count `n of 118 shown`); 24 representative cards (6 form, 5 overlay, 5 data,
  4 nav, 4 feedback) each with a pure-CSS mini preview + file-count chip; empty state.
- **Themes:** 12 working preset cards (4-swatch, ring selection, badge syncs);
  dashboard (4 KPIs, 7-bar chart-1…5 chart, team table with pills, form row);
  token table (8 rows, CSS→Dart names); radius slider (0–16px → `--radius`) +
  density slider (85–115%); Copy JSON / Copy Dart buttons; dashed Studio teaser card.
- **Getting started:** 4-step timeline (numbered rail, per-step time chips, codeblocks
  with copy); verify checklist (3 rows); pager; reveals staggered 40ms.
- **CLI reference:** 4 command cards (add/init/theme/list·remove·doctor), syntax
  codeblocks with copy, flags tables.
- **Palette:** dimmed inert landing backdrop; 640px panel (query prefilled `but`,
  grouped results, selection = accent fill, footer hints); reopen button after close;
  arrow wrap, Enter navigates, Esc closes with focus restore, manual scroll-window
  math (no scrollIntoView).
- **Mobile:** three fixed 375px device frames (notch, compact nav) + breakpoint table.

## Component mapping (element → registry component / docs-only)

| Docs element | Registry mapping |
|---|---|
| Top bar, buttons, icon buttons, badges | `button`, `badge`, `navigation_menu` |
| Sidebar search, palette, index search | `command`, `input` |
| Sidebar / TOC / drawer nav | `navigation_menu`, `drawer`, `scrollable` |
| Install tabs, preview mode segmented, index pills, dialog tabs demo | `tabs` |
| Copy buttons, preset chips, dependency chips, file-count chips | `chip`, `button`, `badge` |
| Preview cards, feature cards, KPI cards, preset cards, phone frames | `card` |
| Code blocks | `code_snippet` |
| Prose, callout, timeline text | `markdown` |
| API / token / flags / team tables | `table` |
| Dialog, drawer, popover/tooltip demos | `dialog`, `drawer`, `popover`, `tooltip` |
| Toast demo, switch demo, calendar demo, chart bars | `toast`/`gooey_toast`, `switch`, `calendar`, `chart` shapes |
| Marquee row | `overflow_marquee` |
| Selects, sliders, skeletons, avatars, stars, accordion, breadcrumb, pagination | `select`, `slider`, `skeleton`, `avatar`, `star_rating`, `accordion`, `breadcrumb`, `pagination` |
| Docs-only (kept few + simple) | phone device frame, dot-notch, swatch circles, KPI delta text, breakpoint table wrapper |

## Tokens used (→ ShadcnTheme names)

`background, foreground, card, cardForeground, popover, popoverForeground, primary,
primaryForeground, secondary, secondaryForeground, muted, mutedForeground, accent,
accentForeground, destructive, destructiveForeground, border, input, ring,
chart1…chart5, radius`. Preset overrides touch only `primary(+Foreground), ring,
accent(+Foreground)`. Raw palette lives once in `:root` (`--z-*`, `--l-*`,
`--p-*`); theme/preset blocks reference `var()` only (lint requirement).

## Motion spec (implemented; Flutter to match)

Durations 150/200/300/500ms; `--ease: cubic-bezier(0.16,1,0.3,1)` (ease-out-expo);
exits ease-in 150ms; spring-in `cubic-bezier(0.34,1.4,0.64,1)` overshoot ≤4px.
Page/route fade + 8px rise 200ms. Reveals fade + 12px rise 300ms, 40ms stagger,
once via IntersectionObserver. Cards lift 2px + shadow-sm→md 150ms; buttons
colour-only. Preset switch = colour tween 300ms, layout untouched. Hero pieces
spring in (50ms stagger) then idle float ±3px/6s. Copy = 1.5s Copied state.
Overlay: scrim fade 150ms; dialog scale .96→1 + fade 200ms; drawer slide 200ms;
palette scale .97→1 + fade 200ms. `prefers-reduced-motion`: no transforms, opacity
only, ≤150ms; marquee/float off; reveals visible.

## Responsive breakpoints

`≥1100px`: sidebar + content + TOC, 3-col cards, 4-col presets. `760–1100px`: TOC
hidden, 2-col. `<760px`: drawer + hamburger, single column, sticky filter bar,
collage 1-col under 560px. Content max 768px (prose) / 1280px (grids); 4px grid.

## Flutter implementation notes

- Routing: `page_route` per sitemap table; palette = root overlay route (`/` + `⌘K`
  shortcut via `keyboard_shortcut`); drawer shares dialog's dismissal contract.
- Code highlighting: `code_snippet` with the 4-class token scheme used here
  (base/muted `.c`, keyword `.k`, string `.s`); copy buttons reuse the 1.5s pattern.
- Live-preview harness: control row (variant/size/mode/preset/disabled) binds to a
  stateful preview widget; preset/mode switch = `ShadcnTheme` swap with 300ms
  `AnimatedTheme`-style colour lerp; dashboard proves token-only styling.
- Search index: static list of `{name, category, files, route}` (118 entries);
  index page filters locally; palette adds commands + presets groups with wrap-around
  arrow nav; `/` focuses index search, `⌘K` opens palette globally, `Esc` unwinds.
- Contrast: dark `#e5e5e5 on #171717`, light `#333 on #fff`, focus ring = `ring`
  token everywhere; light codeblocks keep the dark code surface.

## Lint results (`opendesign lint --fail-on p1`, all clean at finish)

| File | P0 | P1 | P2 | Fixes applied during design |
|---|---|---|---|---|
| 01-landing | 0 | 0 | 0 | violet preset → tangerine (`ai-default-indigo` flags any violet); theme hexes moved to `:root` palette + `var()` refs (`raw-hex`); `data-od-id` on all sections |
| 02-docs-shell | 0 | 0 | 0 | left-accent callout → icon + full-border card |
| 03-component-button | 0 | 0 | 0 | clean first pass after pattern adoption |
| 04-component-dialog | 0 | 0 | 0 | — |
| 05-components-index | 0 | 0 | 0 | — |
| 06-themes | 0 | 0 | 0 | chart hexes into `:root` palette |
| 07-getting-started | 0 | 0 | 0 | — |
| 08-cli-reference | 0 | 0 | 0 | — |
| 09-command-palette | 0 | 0 | 0 | `scrollIntoView` → manual scroll-window math |
| 10-mobile | 0 | 0 | 0 | — |

## Artifacts + screens

- Open Design project `shadcn-flutter-kit-docs`: artifacts `01-landing.html`,
  `02-docs-shell.html`, `03-component-button.html`, `04-component-dialog.html`,
  `05-components-index.html`, `06-themes.html`, `07-getting-started.html`,
  `08-cli-reference.html`, `09-command-palette.html`, `10-mobile.html` (all v1).
  Note: `01-landing.html` v1 predates a final ≤560px collage media query by minutes;
  the repo file is authoritative (re-create is rejected with 409 by design).
- `opendesign export --format image` is desktop-runtime only on this headless daemon
  (`UPSTREAM_UNAVAILABLE`), so PNGs were captured with `agent-browser` (Chromium):
  desktop-1440 `--full` for all 10, plus 375px viewports for landing + button, plus
  a light-mode × tangerine interaction shot proving the morph.
- `screens/`: `01-landing-desktop.png`, `01-landing-mobile.png`,
  `02-docs-shell-desktop.png`, `03-component-button-desktop.png`,
  `03-component-button-mobile.png`, `04-component-dialog-desktop.png`,
  `05-components-index-desktop.png`, `06-themes-desktop.png`,
  `06-themes-light-tangerine.png`, `07-getting-started-desktop.png`,
  `08-cli-reference-desktop.png`, `09-command-palette-desktop.png`,
  `10-mobile-desktop.png`. All visually reviewed; reveal-gated sections were
  scroll-activated before capture.

## Open questions

- Light-mode screenshots captured for one state only (themes × tangerine); the
  Flutter build should snapshot every route in both modes (see UI-check loop).
- Marquee lists 40 representative names; the build should generate all 118 from the
  search index. Same for the preset gallery (12 live here, 42 in the kit).
- No Flutter/Dart code was written or changed in this phase.
