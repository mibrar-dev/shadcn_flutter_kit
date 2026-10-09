# P6 — shadcn/ui site capture + exact build spec for our docs site

Reference: https://ui.shadcn.com/ (captured 2026-10-09). Our product stays
`shadcn_flutter_kit` / CLI `flutter_shadcn`: **structure, layout, spacing,
typography, colour, components and interactions are reproduced; their logo,
brand name, and prose are not.** All quoted strings below are measurement
data (CSS classes and computed values), not copy.

## 0. How this was measured (evidence)

**Screens** — `rearch/design/shadcn-ref/screens/`, 115 PNGs, naming
`<page>-<w>-<mode>.png`, `-full` = full-page, `-state-*` = interaction state.
Pages: `home, docs, installation, components, button, dialog, datatable,
theming, darkmode, create, cli, blocks, charts` × `{1440×900, 375×812}` ×
`{light, dark}` (above-fold + full-page), plus 11 state shots
(`commandmenu`, `commandmenu-typed`, `codeview`, `installtabs`,
`copycopied`, `sidebarhover`, `mobilenav`, `customizer`).
Notes:
- Captures ran in an **isolated `agent-browser --session p6a2`**; the default
  session was concurrently driven by another agent (the tab jumped to a local
  docs app mid-run), so every page batch was re-captured in the isolated session.
- Theme is `localStorage.theme = "light"|"dark"` (next-themes). Each batch set
  it explicitly and reloaded.
- **Verification**: mean luminance of the top 900 px per PNG vs the mode in the
  filename → **0 mismatches across all 115 files** (PIL audit).
- The `read` tool returned stale/cached bitmaps for some later image reads, so
  visual claims below are backed by DOM/CSS measurements, not by those reads.

**Live measurements** — `agent-browser eval` computed styles / `getBoundingClientRect`
at 1920/1600/1536/1440/1280/1100/1024/1000/900/768/640/639/600/480/375 px.

**Site source read (raw.githubusercontent.com, `shadcn-ui/ui@main`, `apps/v4`)** —
`app/globals.css` (458 L: `@theme`, `:root`, `.dark`, `container`,
`container-wrapper`, `step`, code-figure rules), `app/(app)/layout.tsx`,
`app/(app)/docs/layout.tsx`, `app/(app)/docs/[[...slug]]/page.tsx`,
`app/(app)/(root)/page.tsx`, `components/{site-header,main-nav,docs-sidebar,
docs-toc,docs-page-links,docs-copy-page,component-preview,component-preview-tabs,
command-menu,code-block-command,copy-button,mobile-nav,components-list,
page-header,site-footer,announcement,markdown}.tsx`, `mdx-components.tsx`,
`lib/config.ts`, `app/(app)/(typeset)/typeset.css` (490 L — the whole prose
engine, served at `/typeset.css` by `app/typeset.css/route.ts`).
Deployed CSS was also read verbatim from
`ui.shadcn.com/_next/static/immutable/chunks/{1bbr_h5s3c2yz,25s5of5h9ua6p,
42uyid6qgfue6,2lq3yd3_t7nmt}.css` (authored `:root`/`.dark` hex values and the
compiled `.typeset` block).

**Registry facts** (our side, read from disk): `flutter_shadcn_kit/lib/registry/`
= `components/` (118 dirs: display 28, form 29, navigation 8, overlay 20,
control 6, layout 21, utility 6), `foundation/`, `theme/` (6 files),
`primitives/`, `manifests/registry.json`, `themes/` (44 entries = 42 presets +
`index.json` + `themes.schema.json`).

---

## 1. Sitemap for OUR site (mirrors theirs 1:1 where it makes sense)

| Ours | Mirrors theirs | Notes |
|---|---|---|
| `/` Home | `/` | announcement badge → H1 → description → 2 pill CTAs → live component collage → one-line footer |
| `/docs` Introduction | `/docs` | docs shell (sidebar + 640 px article + TOC) |
| `/docs/installation` | `/docs/installation` | numbered H3 steps (`.step` counters), install command blocks |
| `/docs/theming` | `/docs/theming` | token tables + CSS/Dart snippets |
| `/docs/dark-mode` | `/docs/dark-mode` | toggle explanation + snippet |
| `/docs/cli` | `/docs/cli` | command reference, flags tables from `cli_snapshot.txt` |
| `/docs/components` | `/docs/components` | **link grid, not a card grid** — "New"/"All" H2 + 2/3-col links |
| `/docs/components/<id>` × **118** | `/docs/components/{base,radix,aria}/<id>` | one template route; no library switcher (we have one implementation) |
| `/themes` | `/create` (their `/themes` redirects here) | customizer-style: left 192 px rail + live preview, 42 presets |
| — | `/blocks` | **not shipped in P6** (see §5 recommendation) |
| — | `/charts/*` | **not shipped** — we have no chart component |

Their nav items (`lib/config.ts`): Home, Docs, Components, Blocks, Charts,
Directory, Typeset, Create. **Ours: Home, Docs, Components, Themes** (4 items —
we have no Directory/Typeset/Blocks/Charts equivalents; dropping them is a
deliberate, documented reduction).

Their docs sidebar groups, top to bottom: **Sections** (Introduction,
Components, Installation, Theming, CLI, Typeset, Skills, Registry, Changelog),
then **Components** (every component, alphabetical), **Get Started**
(installation/framework pages), `@shadcn/*`, **Forms**, **Utilities**,
**Registry**. Ours: **Sections** (Introduction, Components, Installation,
Theming, Dark Mode, CLI) → **Components** (118) → **Get Started** (optional
later: FAQ, registry/CLI extras). No "New" blue dot unless we mark a page new
(`size-2 rounded-full bg-blue-500`).

Not reproduced (framework-specific, React-only, or off-product): Directory,
Typeset, Skills, Registry docs, Changelog, Monorepo, RTL, per-framework
installation/dark-mode tabs (Next/Vite/Astro/…), `base|radix|aria` library
switcher, v0/ChatGPT/Claude/Open-in-v0 CTAs, Vercel sponsor promo card.

---

## 2. Per-page structure (measured)

### 2.0 App shell — every route

`app/(app)/layout.tsx`: `div[data-slot=layout]` (`group/layout relative z-10
flex min-h-svh flex-col bg-background`) → `SiteHeader` → `main.flex.min-h-0
flex-1.flex-col` → `SiteFooter`.

**Header** (`components/site-header.tsx`)

```
header.sticky.top-0.z-50.w-full.bg-background      ← position sticky, z 50,
  │                                                   bg = --background,
  │                                                   NO border, NO blur/shadow
  └─ div.container-wrapper.px-6                     ← x-padding 24 px, full width
       └─ div.flex.h-(--header-height).items-center  ← 64 px ≥lg, 56 px <lg
            ├─ MobileNav  .flex.lg:hidden            ← hamburger, 73×32 @375
            ├─ MainNav    .hidden.lg:flex            ← 8 ghost links, gap 0
            └─ div.ml-auto.flex.items-center.gap-2.md:flex-1.md:justify-end
                 ├─ search trigger (hidden below md)
                 ├─ separator (h-4, ml-2, hidden lg:block)
                 ├─ GitHub star link (icon + count)
                 ├─ separator
                 ├─ theme toggle icon button
                 ├─ [layout toggle on /create only]
                 └─ separator + primary "New" button (h-[31px] rounded-lg)
```

- `--header-height = calc(var(--spacing)*14)` = **56 px**; `lg:` →
  `calc(var(--spacing)*16)` = **64 px**.
- Nav link: ghost button `size=sm px-2.5`, **14 px/500**, radius 8, height 32,
  measured box 58×32; active route → `data-active` (colour only, no pill).
- Search trigger: `h-8 rounded-lg border-none bg-muted pl-3 shadow-none
  hover:bg-muted/50 md:w-48 lg:w-40 xl:w-64 dark:bg-card`; measured
  **256×32 @xl**, 192 @md, 160 @lg, hidden <md; label "Search documentation…"
  ≥xl, "Search…" below.

**Footer** (`components/site-footer.tsx`) — rendered but **hidden on
`body:has([data-slot=docs])`** (all `/docs*`) and on `/create`.

```
footer  (no border, no bg)
  └─ div.container-wrapper.px-4.xl:px-6
       └─ div.flex.h-(--footer-height)   ← 56 px <xl, 96 px ≥xl
            └─ div.w-full.px-1.text-center.text-xs.leading-loose
                 .text-muted-foreground.sm:text-sm   ← 12 px → 14 px ≥sm,
                                                       centred, links 500+underline
```

Our footer line is one centred sentence with 3 links (docs, GitHub, npm/CLI) —
**original wording** (their line is "Built by … at Vercel …").

### 2.1 Home `/`

```
PageHeader (section.border-grid)
  └─ .container-wrapper > .container
       .flex.flex-col.items-center.gap-2.px-6.py-8.text-center
       .md:py-16 .lg:py-20 .xl:gap-4          ← 32/64/80 px vertical
     ├─ Announcement badge   207×22, rounded-full, px-2 py-0.5, 12 px/500,
     │                       bg --secondary, gap-1 + arrow icon, links to /docs
     ├─ h1  max-w-4xl(896)  text-3xl → xl:text-5xl, font-semibold,
     │       lg:leading-[1.1], xl:tracking-tighter, **color: text-primary**
     │       measured @1440: 48 px / 52.8 lh / 600 / -2.4 px ls / 811×53
     ├─ p   max-w-4xl(896)  text-base sm:text-lg → measured 18/28, foreground
     └─ PageActions  flex w-full items-center justify-center gap-2 pt-2
         ├─ Get Started      h-[35px] rounded-4xl (26 px) primary, 14 px/500
         └─ View Components  h-9     rounded-4xl secondary, 14 px/500

Collage (md:block, mobile = static screenshot instead)
  div.theme-neutral.relative.flex.w-full.flex-col.gap-(--gap)
      .overflow-hidden.bg-muted.p-12.pb-0! .lg:p-6 .lg:[--gap:--spacing(6)]
      .min-[1900px]:p-12 .dark:bg-background
      → @1440 measured: padding 24 px 24 px 0, gap 24 px, bg #0a0a0a (dark)
  └─ div.mx-auto.grid.gap-(--gap).md:grid-cols-2.md:max-w-3xl
      .lg:grid-cols-3.lg:max-w-none .xl:max-w-[1600px] .min-[1400px]:grid-cols-4!
      .min-[1900px]:grid-cols-5!
      → @1440: 4 columns × 326.25 px, gap 24 px, 5 column stacks
      ├─ cards: rounded-[min(var(--radius-4xl),24px)] (=24 px) bg-card text-sm
      │         shadow-sm ring-1 ring-foreground/5 py-(--card-spacing)
      ├─ bottom fade: absolute inset-x-0 bottom-0 h-48 (lg:h-80 xl:h-64)
      │   bg-linear-to-t from-background via-muted/80 to-transparent
      └─ top fade (light only): h-120 from-background via-muted to-transparent
  <768 px: a single static screenshot image instead of the card grid
           (`.section -mx-4 w-[140vw] overflow-hidden md:hidden`)
```

Home cards are live registry components (buttons, inputs, switch, radio, chart
bars, lists, mini forms). **We do not have a chart component** → the
"Contribution History" bar card is replaced by a non-chart card or a docs-only
paint (see §4/§5).

### 2.2 Docs shell (`/docs/*`) — layout grid, sidebar, TOC

```
div.container-wrapper.flex.flex-1.flex-col.px-2        ← 8 px gutters
  └─ div  (SidebarProvider)
       [--sidebar-width: calc(var(--spacing)*72) = 288 px]
       [--top-spacing: 0 ; lg: calc(var(--spacing)*4) = 16 px]
       .min-h-min.flex-1.items-start.px-0
       .lg:grid .lg:grid-cols-[var(--sidebar-width)_minmax(0,1fr)]
       ├─ DocsSidebar (288 px col)   ← hidden below lg
       └─ div.h-full.w-full          ← article column (flex-1)
```

**Sidebar** (`components/docs-sidebar.tsx`, measured @1440)

| Property | Value |
|---|---|
| position | `sticky top-[calc(var(--header-height)+0.6rem)]` → **73.6 px** |
| size | 288 × `calc(100svh-10rem)` → 740 px @900 vh; `overflow-hidden` |
| visibility | `hidden lg:flex` (≥1024) |
| right rule | `absolute top-12 right-2 bottom-0 w-px` `linear-gradient(to bottom, transparent 0%, var(--border) 10%, var(--border) 90%, transparent 100%)` |
| inner scroll | `w-(--sidebar-menu-width)` = **224 px**, `scroll-fade scrollbar-none overflow-x-hidden pl-2.5` (10 px) |
| first group | `pt-12` (48 px) |
| group label | 198×32, `text-xs` **12/16, 500**, muted, `px-2`, radius 8 |
| item | **30 px** tall, `p-2` (8), radius 8, `text-[0.8rem]` **12.8/18.29, 500**, gap 8, `border border-transparent` |
| item pitch | 34 px in "Sections" (gap-1), 32 px in Components (gap-0.5) |
| active | `bg-accent border-accent` (#404040 dark / #f5f5f5 light) + text `--sidebar-accent-foreground` |
| hover | `hover:bg-sidebar-accent hover:text-sidebar-accent-foreground` |
| scroll behaviour | scroll position persisted per route (sessionStorage); on route change the active item is auto-scrolled into view (longest-match rule, then nearest-to-centre) |
| "new" marker | `size-2 rounded-full bg-blue-500` dot after the label |

**Right column (TOC)** (`docs/[[...slug]]/page.tsx` line 188)

```
div.sticky.top-[calc(var(--header-height)+1px)] z-30 ml-auto
    .hidden.h-[90svh].w-(--sidebar-width).flex-col.gap-4.overflow-hidden.pb-8.xl:flex
  ├─ spacer h-(--top-spacing)
  ├─ div.flex.scroll-fade.scrollbar-none.flex-col.gap-8.overflow-y-auto.px-8
  │    └─ DocsTableOfContents  div.flex.flex-col.gap-2.p-4.pt-0.text-sm
  │         ├─ p.h-6.bg-background.text-xs.font-medium.text-muted-foreground
  │         │    "On This Page"  → 12/16, 500, muted, 192×24
  │         └─ a.text-[0.8rem].text-muted-foreground
  │              hover:text-foreground
  │              data-[active=true]:font-medium data-[active=true]:text-foreground
  │              data-[depth=3]:pl-4 data-[depth=4]:pl-6
  │              → 12.8/18.28, 192 px wide, pitch 26–27 px, NO indicator bar/rail
  └─ div.hidden.flex-1.flex-col.gap-6.px-6.xl:flex  → sponsor card
       240×248, rounded-2xl (18 px), bg-surface, p-6 (24), text-sm
```

Active-heading detection: `IntersectionObserver` with
`rootMargin: "0% 0% -80% 0%"` (a heading becomes active when it crosses the
top 20 % of the viewport). `html { scroll-padding-top: var(--header-height) }`.

**No breadcrumb.** Verified `false` for `[data-slot=breadcrumb]` /
`nav[aria-label=breadcrumb]` on `/docs`, `/docs/installation`,
`/docs/components/button` (their `docs-breadcrumb.tsx` is used elsewhere —
UNVERIFIED where; not on the pages we captured).

### 2.3 Docs article + prose typography (all `/docs*`)

```
div[data-slot=docs].flex.scroll-mt-24.items-stretch.pb-8
    .text-[1.05rem].sm:text-[15px].xl:w-full     ← base type 16.8 → 15 px ≥sm
  ├─ div.flex.min-w-0.flex-1.flex-col
  │    ├─ div.h-(--top-spacing)                  ← 0 <lg, 16 px ≥lg
  │    ├─ div.mx-auto.w-full.max-w-160.min-w-0.flex-1.flex-col.gap-6
  │    │    .px-4.py-6.md:px-0.lg:py-8           ← **article max-width 640 px**
  │    │    │                                       (max-w-160 = 40 rem)
  │    │    ├─ title block  flex.flex-col.gap-2
  │    │    ├─ div.typeset.w-full.flex-1.pb-16.sm:pb-0
  │    │    └─ bottom pager  .hidden.h-16.w-full.items-center.gap-2
  │    │                       .px-4.sm:flex.sm:px-0   (64 px row, ≥sm only)
  │    └─ (article column ends)
  └─ TOC column (see §2.2)
```

**Title block** (measured)

```
div.flex.items-center.justify-between.md:items-start
  ├─ h1.scroll-m-24.text-3xl.font-semibold.tracking-tight
  │     → **30 px / 36 lh / 600 / -0.75 px ls / foreground**
  └─ div.docs-nav.flex.items-center.gap-2
       ├─ Copy Page group  (hidden <sm)
       │    div.group/buttons.relative.flex.rounded-lg.bg-secondary
       │      ├─ Button h-8 md:h-7 md:text-[0.8rem] px-3  (106×28 @1440,
       │      │     radius 8, bg --secondary, 12.8 px/500, icon + label,
       │      │     label swaps to check for **2000 ms** after click)
       │      ├─ divider  absolute top-1 right-8 h-5 bg-foreground/5
       │      └─ chevron dropdown trigger (sm+) → menu (0 radius, `animate-none`)
       └─ prev / next icon buttons  size-8 md:size-7 → **28×28 @1440**, radius 8,
            bg --secondary, icon only, sr-only "Previous"/"Next"
div.text-[1.05rem].text-muted-foreground.sm:text-base.sm:text-balance.md:max-w-[80%]
  → **description: 16/24 muted, max-width 80 % ≥md** (16.8 px <sm)
```

**Prose (`.typeset`, source `apps/v4/app/(app)/(typeset)/typeset.css`)** —
base font 15 px ≥768 (`--typeset-size:1em`), ×1.125 below 768, inside the
16.8 px wrapper <640 → body copy **15/26.25 @1440** (leading 1.75, flow 1.25em).

| Element | Value (measured / rule) |
|---|---|
| `p` | 15/26.25, 400, foreground, `margin-top: 1.25em` (18.75 px), no bottom margin |
| `h1` (in prose) | 1.75 em → 26.25 px, lh 1.3, 600, mt 1.25 em, font-heading |
| `h2` | 1.25 em → **18.75/26.25, 600**, mt `flow*1.4` → **32.8 px** |
| `h3` | 1.125 em → **16.875/24.47, 600**, mt 16.875 px |
| `h4` / `h5` / `h6` | 1 em / .875 em muted 500 / .8125 em uppercase `ls .08em` muted 500 |
| heading anchor | `<h2 id><a class="group no-underline"><span>Title</span><span class="ml-2 text-muted-foreground opacity-0 group-hover:opacity-100">#</span></a></h2>` — "#" fades in on hover, `margin, opacity 0.2s linear` |
| `a` (in prose) | inherit colour, underline at 30 % colour → 100 % on hover, weight 500; `a[data-slot]` (component links) → **no underline, weight inherit** |
| `strong` | 600 |
| inline `code` | Geist Mono, `.85em` → **12.75 px**, `bg --muted`, radius `min(radius*.6,.35em)` → **4.46 px**, pad `.125em .3em` → 1.59/3.83, foreground |
| `pre` (code block) | wrapper `figure[data-rehype-pretty-code-figure]`: **bg `--code`, radius 18 px (radius-2xl), border 0, mt 24 px, overflow hidden, -mx-1**; inner `pre` `px-4 py-3.5` (16/14), font-size **14 px**, lh 24.5, Geist Mono, `code-foreground`; shiki token colours; optional title bar `border-b border-border/30 py-2.5 px-4 text-sm font-mono` |
| lists | `ul` disc / `ol` decimal, `padding-inline-start 1.5em`, `li` mt .5 em, marker colour `--typeset-muted`, nested circle/square |
| `blockquote` | `border-inline-start: 2px solid var(--typeset-rule)`, `padding-inline-start 1em` |
| `hr` | 1 px top rule, `margin-top 2.4em` |
| table | `border-collapse: separate`, row `border-bottom 1px var(--typeset-rule)`, `th` `.65em 1em` 500, `td` `.75em 1em`, 15/1.5, `tabular-nums`, wrapped in `.typeset-scroll.scroll-fade-x` (horizontal scroll) |
| `kbd` | 1 px rule, `border-radius min(radius*.6,.35em)`, `border-bottom 2px`, pad `.0625em .35em`, `.85em`, 500 |
| callout (`alert`) | measured: 648×72, radius 18, 1 px border, pad 12/16, text-sm muted, bg tinted, `mb 24` |
| `.step` counter | `counter-increment: step`; `h3:before` = `size-6 rounded-full border bg-muted font-mono text-sm` centred number → `md:` becomes `size-9 border-4 absolute ml-[-50px] mt-[-4px]` (installation steps) |

### 2.4 Component page `/docs/components/<id>`

Same shell as §2.3, plus:

```
.typeset
  ├─ DocsBaseSwitcher  div.not-typeset.inline-flex.w-full.items-center.gap-6.mb-4
  │     (their library tabs — WE OMIT; single implementation)
  ├─ [data-slot=component-preview]
  │     .group.relative.mt-4.mb-12.flex.flex-col.overflow-hidden.rounded-2xl.border
  │     → measured 640×399, **border 1 px --border, radius 18 px,
  │        margin 16 px top / 48 px bottom**
  │     ├─ [data-slot=preview]
  │     │    div.preview.relative.flex.h-72.w-full.justify-center.p-10
  │     │      .data-[align=center]:items-center  …→ **288 px tall, 40 px pad,
  │     │      centred** (chromeless variant: h-auto, p-0)
  │     └─ [data-slot=code]  (collapsed teaser, measured 638×109)
  │          .relative.overflow-hidden
  │          .**:data-[slot=copy-button]:hidden …until expanded
  │          .[&_[data-rehype-pretty-code-figure]]:m-0! …:rounded-t-none
  │          .[&_pre]:max-h-72
  │          content: 3-line source teaser + absolute gradient
  │          linear-gradient(to top, var(--color-code),
  │                          color-mix(in oklab, var(--color-code) 60%, transparent),
  │                          transparent)  + centred Button
  │          "View Code" (size=sm variant=outline rounded-lg bg-background
  │          shadow-none dark:bg-background)
  │          click → data-mobile-code-visible=true, full source, pane 289 px,
  │          copy button appears top-right (right-4)
  ├─ h2 sections … (Installation, Usage, then one h2 per variant/example,
  │                 each with its own component-preview card)
  └─ bottom pager (see §2.3)
```

**Installation block** (measured @1440, 640 wide)

```
figure[data-rehype-pretty-code-figure]  bg --code, radius 18, mt 24
  └─ Tabs (variant "line" for Command/Manual, gap-0)
       ├─ div.flex.items-center.gap-2.border-b.border-border/50.px-3.py-1  (640×45)
       │    ├─ terminal glyph: size-4 rounded-[1px] bg-foreground opacity-70
       │    ├─ TabsList.rounded-none.bg-transparent.p-0
       │    │    └─ TabsTrigger.h-7.border.border-transparent.pt-0.5
       │    │         text-sm(14)/500 rounded-md px-2
       │    │         active: border-input + bg-background (dark: bg-input/30)
       │    │         → pnpm 52×28 etc., measured pitch incl. 6 px gap
       │    └─ copy ghost Button (top-2 right-2 size-7 opacity-70→100,
       │         icon swaps copy→check, resets after **2000 ms**)
       └─ TabsContent.px-4.py-3.5 → pre > code.font-mono.text-sm.leading-none
            "pnpm dlx shadcn@latest add <id>"   (our CLI: flutter_shadcn add <id>)

Line tabs "Command | Manual": TabsList h-9 (36) px-0, triggers text-base(16)/500,
pb-3 (12), transparent border; active → border-b-2 **border-primary** +
text-foreground; inactive → muted, hover:text-primary. Measured boxes
76×29 / 55×29, pitch 100 px.
```

**Bottom pager**: row `h-16` (64 px) ≥sm, previous left / next right, secondary
buttons **32 px tall, radius 8, px-10(→0 10 px), 14/500, shadow-none**, icon +
page name.

### 2.5 Components index `/docs/components`

Plain prose page (no search box, no pills, no cards):

```
h1 "Components"            (30/36 600 -0.75)
h2 "New Components"        (18.75/26.25 600, mt 32.8, "#" hover anchor)
div.mt-8.grid.grid-cols-2.gap-4.md:grid-cols-3.md:gap-x-8
    .lg:gap-x-16.lg:gap-y-6.xl:gap-x-20
   → @1440: 3 columns × 160 px, col gap 80, row gap 24, mt 32
   links: .inline-flex.items-center.gap-2.text-lg.font-medium
          .underline-offset-4.hover:underline.md:text-base
          → **16/500 ≥md (18 <md)**, colour foreground, hover underline
          + optional blue "new" dot (size-2)
h2 "All Components" → same grid with all 118
hr → 1 px rule
p  closing sentence (muted? measured foreground)
```

### 2.6 Other docs pages

- **Installation / Theming / Dark Mode / CLI** = the same shell + prose as
  §2.3; content differences only (code blocks, `.step`-numbered H3s,
  tables, `CodeBlockCommand` install blocks). No bespoke layouts — the old
  plan's "4-step timeline" and "4 command cards" are replaced by prose +
  numbered headings + code figures (§5).
- The docs shell `gap-6` (24 px) separates title block / prose / pager; the
  article is centred in its column by `mx-auto` with `max-w-160`.

### 2.7 Themes page — our `/themes` in their `/create` customizer style

Their `/create` (their `/themes` redirects here) — structure measured
(screens: `create-1440-{light,dark}.png` = welcome dialog,
`create-1440-dark-state-customizer.png` = open customizer):

```
main.flex.min-h-0.flex-1.flex-col
  └─ div.relative.z-10.flex.min-h-0.flex-1          (1440×836 under 64 px header)
       ├─ LEFT RAIL 192 px (24 px from edge)
       │   div.group/card.flex.flex-col.gap-(--card-spacing).overflow-hidden
       │     ├─ card-header  192×49  px-(--card-spacing)  → "Menu" + collapse icon
       │     ├─ scroll area  192×527  .px-(--card-spacing).no-scrollbar
       │     │    rows (label 12 px muted over value 14 px + swatch/glyph):
       │     │    Style / Base Color / Theme / Chart Color / Heading / Font /
       │     │    Icon Library / Radius
       │     └─ 2 × footer cards  rounded-b-xl.border-t.bg-muted/50.p-(--card-spacing)
       │          rows: preset id pill, "Open Preset", "Shuffle", "Get Code"
       └─ PREVIEW AREA 1176×806
            div.relative.flex.flex-1.flex-col.justify-center
              ├─ div.relative.z-0.mx-auto.flex.w-full   ← live themed card grid
              └─ div.dark.absolute.right-3.bottom-3.z-20  (80×36 action chip)
```

- First visit: welcome dialog `384×397`, `fixed top-1/2 left-1/2`, backdrop
  `fixed inset-0 bg-black/10`; body `aspect-[2/1]` logo panel + `p-4` copy +
  `rounded-b-xl.border-t` action row (32 px button).
- Header on `/create` swaps the "New" button for "Open in v0" + "Get Code".

**Our `/themes` adaptation (spec):** same two-pane frame —
left rail 192 px listing **our 42 presets** (id + 4 swatches + mode), footer
actions (Copy JSON / Copy Dart / Shuffle / Get Code), right = live preview of
registry cards re-theming through `AnimatedShadcnTheme` (300 ms colour tween,
our theme layer). Radius row = `slider` 0–16 px; mode row = toggle.
Optional first-visit welcome dialog in the same 384 px card shape.
No KPI/bar-chart dashboard: **their page has none**, and we have no chart
component (§5 removes the old `D:BarChart` deviation).

### 2.8 Interaction states (captured)

| State | File(s) | Spec |
|---|---|---|
| Command menu open | `docs-1440-{dark,light}-state-commandmenu.png`, `docs-1440-dark-state-commandmenu-typed.png`, `button-1440-light-state-commandmenu.png` | `Dialog` content `fixed top-[15%] left-1/2 -translate-x-1/2 z-50 w-full max-w-[calc(100%-2rem)] sm:max-w-lg` → **512 px** @1440, `rounded-xl (14) p-2 pb-11 shadow-2xl ring-4 ring-neutral-200/80 dark:bg-neutral-900`, **no overlay/backdrop** (`<DialogOverlay/>` is commented out — verified: no scrim element in DOM, screenshot shows an undimmed page), `duration-200 ease`. Input row `h-9 rounded-md border border-input bg-input/50`, 14 px. Group headings 12/16 500 muted `p-3 pb-1`. Items `h-9 px-3 rounded-md text-sm/500`, selected `border-input bg-input/50`, 496×36. List `min-h-80` (320) no-scrollbar. Footer `h-10 rounded-b-xl border-t bg-neutral-50 px-4 text-xs/500 muted dark:bg-neutral-800` with `↵ Go to Page` + `⌘C copy` hints. Trigger: header search button (§2.0), `⌘K` |
| Mobile nav open | `docs-375-{dark,light}-state-mobilenav.png` | Hamburger `flex lg:hidden` → popper `no-scrollbar w-(--radix-popper-available-height…-width) rounded-none border-none bg-background/90 p-0 shadow-none backdrop-blur duration-100`, content `flex flex-col gap-12 px-6 py-6`, group label `text-sm font-medium text-muted-foreground`, links `flex flex-col gap-3`, full-width under the 56 px header. **Not a side drawer** |
| Code tab selected | `button-{1440}-state-codeview.png` (dark+light) | `View Code` → `data-mobile-code-visible=true`; pane grows 109 → **289 px** (`pre max-h-72` = 288 + 1 px top border), copy button revealed at `right-4` |
| Install tabs | `button-1440-dark-state-installtabs.png` | `pnpm|npm|yarn|bun` pill tabs; active = `border-input bg-background` (+ `dark:bg-input/30`); command text updates (`npx shadcn@latest add …` ↔ ours `flutter_shadcn add …`) |
| Copy "copied" | `button-1440-dark-state-copycopied.png` | icon `copy → check`, **resets after 2000 ms** (`copy-button.tsx:83`, `code-block-command.tsx:37`); sr-only label stays "Copy" |
| Sidebar hover | `button-1440-dark-state-sidebarhover.png` | item `hover:bg-sidebar-accent hover:text-sidebar-accent-foreground`, 150 ms `cubic-bezier(.4,0,.2,1)` |
| Theme/customizer | `create-1440-dark-state-customizer.png` | see §2.7 |

### 2.9 Responsive matrix (measured, docs article page)

| Width | header | left nav | search | sidebar | TOC | article padding | article box |
|---|---|---|---|---|---|---|---|
| ≥1280 (xl) | 64 | links | 256 | grid 288 + 1fr | **shown (288)** | py 32, px 0 | 640 max |
| 1024–1279 (lg) | 64 | links | 160 | grid 288 + 1fr | hidden | py 32, px 0 | 640 |
| 768–1023 | **56** | hamburger 73×32 | 192 | stacked, hidden | hidden | py 24, px 0 | 640 |
| 640–767 (sm) | 56 | hamburger | hidden | hidden | hidden | py 24, px **16** | ≤640 |
| <640 | 56 | hamburger | hidden | hidden | hidden | py 24, px 16 | fills (344 @375) |

Breakpoints: `sm 640, md 768, lg 1024, xl 1280, 2xl 1536 (--breakpoint-2xl:
96rem), 3xl 1600, 4xl 2000` (3xl/4xl defined in `globals.css` `@theme`; their
`3xl:fixed:*` rules only apply with the `layout-fixed` variant — **off by
default**, header stays full-bleed at 1920).

### 2.10 Blocks & Charts (reference only, our recommendation)

- **Blocks** (`/blocks`): hero `section.border-grid` + `.container`
  (`max-w-[1400px] px-4 lg:px-8`) with H1 "Building Blocks…" + description,
  then a 64 px filter/nav strip (`container flex items-center
  justify-between`), then `section-soft md:py-12` content = `flex flex-col
  gap-12 md:gap-24` of large preview cards (iframe/screenshot, `aspect-[4/2.5]
  rounded-2xl border`). Blocks are composed, page-level layouts (dashboards,
  forms, sidebars) shipped as registry items.
- **Charts** (`/charts/area`): same hero pattern (`H1 "Beautiful Charts &
  Graphs"`), 60 px category nav strip, then `container.pb-6` →
  `section.theme-container` grid of chart cards with code view.
- **Recommendation: do not ship either in P6.** We have no `chart` component
  (P6 coverage check) and no block-level composite items; inventing them would
  break "component facts are generated from the registry". Keep both URLs out
  of the nav; revisit Blocks after Phase 4/6 when composite demos exist.

---

## 3. Global system

### 3.1 Colour tokens (`:root` = light, `.dark`; authored hex from the deployed
stylesheet, identical in intent to `apps/v4/app/globals.css` oklch values)

| CSS var | light | dark | our `ShadcnTheme` / preset JSON name |
|---|---|---|---|
| `--background` | `#ffffff` | `#0a0a0a` | `background` |
| `--foreground` | `#000000` | `#fafafa` | `foreground` |
| `--card` | `#ffffff` | `#171717` | `card` |
| `--card-foreground` | `#000000` | `#fafafa` | `cardForeground` |
| `--popover` | `#ffffff` | `#171717` | `popover` |
| `--popover-foreground` | `#000000` | `#fafafa` | `popoverForeground` |
| `--primary` | `#000000` | `#e5e5e5` | `primary` |
| `--primary-foreground` | `#fafafa` | `#171717` | `primaryForeground` |
| `--secondary` | `#f5f5f5` | `#262626` | `secondary` |
| `--secondary-foreground` | `#171717` | `#fafafa` | `secondaryForeground` |
| `--muted` | `#f5f5f5` | `#262626` | `muted` |
| `--muted-foreground` | `#737373` | `#a1a1a1` | `mutedForeground` |
| `--accent` | `#f5f5f5` | `#404040` | `accent` |
| `--accent-foreground` | `#171717` | `#fafafa` | `accentForeground` |
| `--destructive` | `#e40014` | `#ff6568` | `destructive` |
| `--destructive-foreground` | `#fcf3f3` | `#df2225` | `destructiveForeground` |
| `--border` | `#e5e5e5` | `#ffffff1a` (white/10 %) | `border` |
| `--input` | `#e5e5e5` | `#ffffff26` (white/15 %) | `input` |
| `--ring` | `#a1a1a1` | `#737373` | `ring` |
| `--chart-1..5` | `#90c5ff #3080ff #155dfc #1447e6 #193cb8` | same | `chart1..chart5` |
| `--sidebar` | `#fafafa` | `#171717` | `sidebar` |
| `--sidebar-foreground` | `#000000` | `#fafafa` | `sidebarForeground` |
| `--sidebar-primary` | `#171717` | `#1447e6` | `sidebarPrimary` |
| `--sidebar-primary-foreground` | `#fafafa` | `#fafafa` | `sidebarPrimaryForeground` |
| `--sidebar-accent` | `#f5f5f5` | `#262626` | `sidebarAccent` |
| `--sidebar-accent-foreground` | `#171717` | `#fafafa` | `sidebarAccentForeground` |
| `--sidebar-border` | `#e5e5e5` | `#ffffff1a` | `sidebarBorder` |
| `--sidebar-ring` | `#a1a1a1` | `#525252` | `sidebarRing` |
| `--radius` | `.625rem` = **10 px** | same | `radius` |

Site-only tokens **not in our preset schema** (same names, docs-app scope):
`--surface` (`#f8f8f8` / `#161616`), `--surface-foreground`
(`var(--foreground)` / `#a1a1a1`), `--code` (= `--surface`),
`--code-foreground`, `--code-highlight` (`#f2f2f2` / `#262626`),
`--code-number` (`#747474` / `#a4a4a4`), `--selection` (`#000` / `#e5e5e5`),
`--selection-foreground` (`#fff` / `#171717`).
→ **Recommendation:** keep the preset schema untouched (REARCH §6.1) and define
these7 as docs-app constants derived from `surface`/`muted` (they are
presentation tokens of the docs site, not of the design system).

### 3.2 Fonts, type scale, radii, shadows, spacing

- `--font-sans: "Geist"`, `--font-mono: "Geist Mono"`,
  `--font-heading: "Geist"` (body also `--default-font-family: Geist`),
  `--font-serif: ui-serif, Georgia, …`. `font-synthesis-weight: none`,
  `text-rendering: optimizeLegibility`, `antialiased` on body.
  Our docs already ship Geist (see P6_DOCS_BUILD_PLAN §1.1) ✓.
- Type utilities: `xs 12, sm 14, base 16, lg 18, xl 20, 2xl 24, 3xl 30, 4xl 36,
  5xl 48` (px); leading `tight 1.25, snug 1.375, normal 1.5, relaxed 1.625,
  loose 2`; tracking `tight -0.025em, tighter -0.05em, wide 0.025em,
  wider 0.05em, widest 0.1em, normal 0`.
  *(A second set exists for style presets, e.g. `--text-3xl: 1.3rem` under
  `.theme-*` scopes — ignore; docs pages use the default set, verified by the
  measured 30 px H1.)*
- Radius: `--radius: 10px`; `xs 2 (0.125rem), sm 6 (0.6×), md 8 (0.8×),
  lg 10 (1×), xl 14 (1.4×), 2xl 18 (1.8×), 3xl 22 (2.2×), 4xl 26 (2.6×)`;
  `rounded-full` for badges/pills. Measured live ✓.
- Shadows (measured from the runtime default theme):
  `xs 0 1px 2px rgb(0 0 0/.05)` ·
  `sm 0 1px 3px rgb(0 0 0/.1), 0 1px 2px -1px rgb(0 0 0/.1)` ·
  `md 0 4px 6px -1px .1, 0 2px 4px -2px .1` ·
  `lg 0 10px 15px -3px .1, 0 4px 6px -4px .1` ·
  `xl 0 20px 25px -5px .1, 0 8px 10px -6px .1` ·
  `2xl 0 25px 50px -12px .25`.
  Cards use `shadow-sm` + `ring-1 ring-foreground/5`; command panel
  `shadow-2xl ring-4 ring-neutral-200/80 (dark: ring-neutral-800)`.
- Spacing: `--spacing: 0.25rem` (4 px base); all spacing utilities derive from it.
- `--header-height 56/64`, `--footer-height 56 (<xl) / 96 (≥xl)`,
  `--top-spacing 0 (<lg) / 16 (≥lg)`, `--sidebar-width 288`,
  `--sidebar-menu-width 224`.
- Containers: `.container-wrapper { margin-inline:auto; width:100%; padding:0 8px }`
  (+ header/footer overrides `px-6` / `px-4 xl:px-6`); `.container { max-width:
  1400px; padding: 0 16px; lg: padding-inline 32px }`. Docs article ignores
  `.container` and uses `max-w-160` = **640 px**.
- Breakpoints: `sm 640, md 768, lg 1024, xl 1280, 2xl 1536, 3xl 1600, 4xl 2000`
  (3xl/4xl declared in `@theme`; `3xl:fixed` gated by `.layout-fixed`, off).

### 3.3 Motion — what actually exists (measured inventory on
`/docs/components/button`, no scroll/entrance animation found)

| Duration / easing | Where | Count (elements) |
|---|---|---|
| **150 ms `cubic-bezier(.4,0,.2,1)`** (`--default-transition-duration/timing-function`) — `transition-all`, colour-only, and `width/height/padding` | buttons, tabs, sidebar items, links, tables — everything | 98 `all`, 24 colour-only, 109 `width,height,padding` |
| 100 ms same easing | popover/popper open-close, mobile nav (`duration-100`) | 2 |
| **200 ms `ease`** (`duration-200`) | dialog/command panel enter-exit | 1 |
| 200 ms `linear` — `transition: margin, opacity` | heading `#` anchor reveal on hover | 8 |
| 1000 ms `linear` | `spin` spinner | 3 |
| 1 ms `ease-in-out` | `scroll-fade-reveal-*` masks (fade masks at scroll edges) | 3 |
| — | `a:active, button:active { opacity: .6 } md:opacity-1` (global press feedback) | global |
| — | **no** scroll-reveal, parallax, marquee, spring, stagger or page-transition animation found on docs/home pages | — |

Theme toggling on their side is a CSS variable swap (no tween). Our
`AnimatedShadcnTheme` 300 ms tween (P6 plan §1.4) is therefore **our**
addition — keep or drop per §5.

---

## 4. Element → our registry component map

`R:` = `flutter_shadcn_kit/lib/registry/components/<id>` (118, flat ids);
`D:` = docs-only widget under `docs/lib/widgets/`. UNVERIFIED = API detail the
build batch must confirm against the component source.

| Their element | Ours | Notes |
|---|---|---|
| `SiteHeader` shell (sticky, bg, px-6, h-56/64) | **D:DocsHeader** | pure layout; no blur/border |
| nav links (ghost, 14/500, radius 8) | `R:button` ghost `size: sm` | px 10, radius from button theme |
| search trigger (h-32, radius 10, bg muted/card, fixed widths) | `R:button` custom width | width switches 192/160/256 at md/lg/xl |
| separators | `R:divider` | h-4 vertical |
| GitHub star link, theme toggle, CTA | `R:anchor`, `R:button` icon, `R:button` primary | our own icons (`R:icon`) |
| hamburger (73×32, icon + label) | `R:button` | opens the mobile nav |
| mobile nav popper (full width, `bg-background/90`, blur, gap-12) | `R:popup` (anchored overlay) **or** `R:drawer` fallback | recommend `R:popup`; NOT a side drawer |
| command palette (`⌘K`) | `R:command` (spike) else `R:dialog` + `R:input` rows | panel 512 px, top 15 %, **no scrim**, footer hint bar |
| kbd hints (`↵`, `⌘C`) | `R:keyboard_shortcut` | |
| docs sidebar (288 sticky, gradient rule, 224 scroll area) | **D:DocsSidebar** + `R:scrollable` + `R:divider` | gradient 1 px rule = docs-only paint |
| sidebar group label (12/16 500 muted, h-32) | **D:SectionLabel** (Text) | not worth a registry component |
| sidebar item (30 px, 12.8/500, active accent, hover sidebar-accent) | `R:button` with a docs `SidebarItemTheme` | theme override lives in the docs app |
| "new" dot | `R:badge` or an 8 px docs-only dot | |
| TOC column + scroll spy | **D:ScrollSpy** + `R:scrollable` + text links | scroll-position observer + auto-centre of active item |
| TOC "On This Page" label | **D:SectionLabel** | |
| sponsor card | **omit** | not our product |
| breadcrumb | **omit** | they have none on docs pages |
| H1 / description / prose | **D:Typeset** (markdown → widgets, §2.3 metrics), possibly wrapping `R:markdown` | UNVERIFIED: can `R:markdown` carry typeset metrics without Material |
| heading `#` anchor | **D:HeadingAnchor** (opacity 0→1, 200 ms linear) | |
| inline code | **D:InlineCode** (or `R:code_snippet` inline variant — UNVERIFIED) | bg muted, radius 4.46 px, mono 12.75 |
| code block figure (bg code, radius 18, px-4 py-3.5, 14/24.5) | `R:code_snippet` | pre-generated spans (P6 plan §1.6) |
| copy button + 2000 ms check | `R:button` ghost icon + timer (**2 s**, not 1.5 s) | optional `R:toast` |
| Copy Page group + chevron menu | `R:button` + `R:dropdown_menu` | group bg secondary, divider `bg-foreground/5` |
| prev/next icon buttons (28×28) | `R:button` secondary icon `size: sm` | 28 px ≥md, 32 px below |
| bottom pager (64 px row, labelled) | `R:button` secondary with icon + label | |
| component preview frame (border 1 px, radius 18, mt 16 mb 48) | `R:card` **if** it can be border-only/no-padding; else **D:PreviewFrame** | UNVERIFIED — decide in D3 |
| preview stage (288 px, p-40, centred) | **D:PreviewStage** (layout only) | hosts deferred `preview.dart` |
| code teaser + gradient + "View Code" | **D:CodeTeaser** + `R:code_snippet` + `R:button` outline sm | gradient = docs-only `LinearGradient` |
| Command/Manual line tabs | `R:tabs` (`variant: line`) | UNVERIFIED line variant exists; else **D:LineTabs** |
| pnpm/npm/yarn/bun pill tabs | `R:tabs` (default) | ours: package managers / `flutter_shadcn` commands |
| install figure + header row + terminal glyph | `R:code_snippet` + **D:CodeHeader** + `R:icon` | |
| prose table | `R:table` | typeset metrics (§2.3) |
| `hr` | `R:divider` | 1 px, mt 2.4 em |
| callout/alert | `R:alert` | radius 18, pad 12/16 |
| numbered steps (`.step`) | `R:steps` | installation page |
| components index link grid | **D:ComponentLinkGrid** + `R:anchor` | 2/3 cols, hover underline |
| home badge | `R:badge` | rounded-full, 12/500, bg secondary |
| home H1/description/CTAs | **D:Hero** + `R:button` primary/secondary (radius 26) | |
| home collage | `R:card` `R:button` `R:input` `R:switch` `R:radio_group` `R:tabs` `R:badge` `R:progress` `R:table` `R:tooltip` | composition docs-only |
| home bar-chart card | **replace** (no `chart` component) | KPI/number card instead |
| home <768 static screenshot | **D:AssetImage** | we ship our own PNG |
| footer (one centred line) | **D:DocsFooter** | our own wording |
| themes rail (192 px) | **D:ThemeRail** + `R:button` rows + `R:slider` (radius) + `R:chip` swatches | 42 presets from `themes/*.json` |
| themes live preview | `R:card` composition under `AnimatedShadcnTheme` | |
| welcome dialog (384 px card) | `R:dialog` | optional |
| page transitions | `R:page_route` | **their site has none** — see §5 |
| app shell / theming | `R:app` (`ShadcnApp.router`), `R:drawer`, `R:toast`, `R:skeleton`, `R:spinner` | per P6 plan §1.1 |

---

## 5. Delta vs `rearch/reports/P6_DOCS_BUILD_PLAN.md`

The plan was written against the **Open Design mockups**
(`rearch/design/docs/*.html`, `P6_DOCS_DESIGN.md`). Reference changed → the
following changes, by plan section.

### 5.1 §3 page map

| Plan item | Was (Open Design) | Now (shadcn site) | Effect |
|---|---|---|---|
| **01 landing** | hero + install code block + 6-preset chip switcher, 8-piece collage, **stats band**, **feature grid (6 cards)**, **marquee of 118 names**, **3-step cards**, **CTA band**, **4-col footer** | announcement badge → H1 48 px `text-primary` → description 18 px → 2 pill CTAs (radius 26) → full-bleed **live card collage** (4 cols @1440, gap 24, padding 24/24/0, top+bottom gradient fades, `<768` = static PNG) → **one-line centred footer** | delete `D:Stats`, `R:overflow_marquee` marquee, feature grid, steps, CTA band, 4-col footer; add `D:Announcement`, revised `D:Hero`, `D:Collage` + fades, `D:DocsFooter`; hero preset chips removed (preset UI lives on `/themes`) |
| **02 docs shell** | 270 px sidebar, 4 groups, file-count `R:badge` chips, accent fill + **ring edge**, palette button inside sidebar, content **max 768**, **breadcrumb**, prev/next pager cards with 2 px lift, mobile **R:drawer** | sidebar **288** (menu 224), 3 groups (Sections/Components/Get Started), 12 px group labels, active = `bg-accent` + 1 px `border-accent` (no ring, no badges), 1 px gradient right rule, scroll-fade mask, **no palette button**, content **max 640**, **no breadcrumb**, prev/next = 28 px icon buttons in the title row + labelled 64 px bottom row (no lift), mobile = **full-width popper** under the header | update §3.2 literally: `R:navigation_menu` sidebar → **D:DocsSidebar**; drop `R:breadcrumb`; drop file-count badges; `R:drawer` → `R:popup`; 768 → 640 max width; add scroll-position persistence + TOC auto-centre |
| **03 component template** | install tabs (CLI\|manual), preview card **with PreviewControls** (variant/size segmented, disabled switch, mode/preset selects), gallery of 4 example cards, **API table, theme-fields table, keyboard table, dependency chips, related cards** | install block = **line tabs (Command\|Manual)** + **pill tabs (package managers)** + copy; preview card = stage (288 px, p-40) + 3-line code teaser + gradient + **View Code** (expands to 289 px); no controls; **one preview per H2 section**; **no tables/chips/related cards** | drop `D:PreviewControls` entirely (mode/preset move to header toggle + `/themes`); render examples inline per H2; **recommendation: keep the generated API/theme/keyboard tables** but as typeset H2 sections "API"/"Theme"/"Accessibility" after Usage (ground rule 3 still needs them) — drop dependency chips + related cards. Decision needed (§6) |
| **04 dialog instance** | preview controls incl. scrim-dismiss switch | preview stage button opens the registry dialog; mode/preset/scrim via header + theme | smaller `D:PreviewStage`, no controls |
| **05 components index** | sticky search `R:input` + category `R:chip` pills + live count + 118 cards with `D:MiniPreview` + `D:EmptyState` | **plain link grid**: H2 "New Components" + H2 "All Components", 2 cols → 3 cols ≥768 (gap 80/24 @xl), links 16/500 hover-underline, blue dot for new | delete `D:SearchToolbar`, `D:MiniPreview`, `D:EmptyState`, index-side `R:input`; search = header ⌘K only. ~400–600 LOC saved |
| **06 themes** | 12→42 preset cards + **dashboard (KPI cards, D:BarChart, team table)** + token table + radius & density sliders + Copy JSON/Dart + Studio teaser | **customizer**: 192 px left rail (presets + Style/Radius/… rows + footer actions) + live preview area, optional 384 px welcome dialog, header actions | **remove `D:Dashboard`, `D:BarChart`, `D:Swatches`-gallery, density slider** (no chart component; their page has none) → the plan's only "no registry component" deviation disappears; keep radius slider in the rail, keep Copy JSON/Dart as rail actions; token table moves to `/docs/theming` |
| **07 getting started** | 4-step **D:Timeline** rail + verify **D:CheckRow** | typeset page, **`.step` numbered H3 counters** (6 px → md 9 px circles), code figures | drop `D:Timeline`; use `R:steps` (exists) or docs-only counter; checklist optional |
| **08 CLI reference** | 4 command **cards** | typeset page: code figures + tables | render `cli_snapshot.txt` inside `R:code_snippet` figures, not cards |
| **09 palette** | **dimmed inert D:Scrim** + **640 px** panel | **no backdrop at all**, **512 px** (`sm:max-w-lg`), `top:15%`, radius 14, `p-2 pb-11`, `ring-4`, min list 320 px, items h-9 (`selected: bg-input/50 + border-input`), **40 px footer bar** (`↵ Go to Page`, `⌘C`), trigger = **header search button** (256/192/160) | delete `D:Scrim`; resize panel; add footer bar; move trigger to header; `R:command` spike target re-scoped |
| **10 mobile** | three `D:DeviceFrame` frames + breakpoint table | real responsive behaviour (§2.9); home `<768` shows a static collage PNG | drop `D:DeviceFrame` from the build (optional docs page only); breakpoint table optional in `/docs/theming` |

Navigation: header shows **Home, Docs, Components, Themes** (4 items) instead
of the plan's implied full nav; right side = search button, GitHub, theme
toggle, primary CTA.

### 5.2 §4 motion map

| Plan row | Status |
|---|---|
| Route fade + 8 px rise (`R:page_route`) | **REMOVE** — the reference site has no route transition; navigation is instant |
| `D:Reveal` fade + 12 px rise, 40 ms stagger | **REMOVE** — no scroll reveals on the reference |
| Card lift 2 px + shadow-sm→md 150 ms | **REMOVE** — cards are static; hover = colour only, 150 ms |
| Buttons colour-only 150 ms `cubic-bezier(.4,0,.2,1)` | **KEEP** (matches `--default-transition-*`) |
| Preset switch colour tween 300 ms `kEaseOutExpo` | **KEEP as our deviation** (reference swaps instantly) — scope it to `/themes` preview + header toggle |
| Hero spring-in + idle float ±3 px | **REMOVE** |
| Copy = **1.5 s** Copied | **CHANGE → 2000 ms** (`copy-button.tsx:83`, `code-block-command.tsx:37`) |
| Scrim fade 150 ms (dialog/drawer/palette) | **KEEP for `R:dialog`/`R:drawer`**, but the **palette has no scrim** |
| Palette scale .97→1 + fade 200 ms | **KEEP** (`duration-200 ease` measured on the panel) |
| Drawer slide 200 ms | keep only where we still use `R:drawer` (component demos), **not** for the mobile nav |
| Marquee 40 s | **REMOVE** (no marquee exists) |
| `prefers-reduced-motion` (`D:MotionScope`) | **KEEP** (cheap, correct), even though the reference has nothing to disable |
| — **ADD** | heading `#` anchor: opacity 0→1 (+ `margin`) **200 ms linear**; `active` press `opacity .6` below md; mobile nav popper **100 ms**; scroll-fade gradient masks on sidebar/TOC (static masks, no animation); spinner 1 s linear |

### 5.3 §6 batches D1–D6

- **D1** (shell/router/state): unchanged files; changes — default brightness =
  **system** (their `next-themes` default; verified `dark` on a system-dark
  browser, `light` after toggle), header = 4 nav items + search button widths
  192/160/256, no sidebar palette button, `kEaseOutExpo` constant retained only
  for the themes tween. Route table loses nothing but gains `/themes` rail route.
- **D2** (codegen): unchanged outputs; **plus** `kComponentLinks` for the index
  grid (id + name only), palette groups **Pages / Components / Presets**
  (reference groups: Pages, Styles, Components, Colors, Blocks), and install
  command strings already correct (`flutter_shadcn add <id>`).
- **D3** (landing/shell/palette/index): rewrite of scope — landing loses
  stats/marquee/steps/CTA/4-col footer and gains badge + gradient-fade collage +
  one-line footer + optional mobile PNG; shell: 288/224 sidebar, 640 content,
  no breadcrumb, icon prev/next + labelled bottom pager, header search; palette
  spike → 512 px, no scrim, footer bar; index → link grid. Estimate **2200 →
  ~1600 LOC**. New/changed widget files: `announcement`, `collage`, `docs_footer`,
  `component_link_grid`, `heading_anchor`, `code_teaser`, `preview_stage`,
  `scroll_fade` (mask); deleted: `search_toolbar`, `mini_preview`,
  `device_frame` (or moved to docs), `stats`, `marquee_section`, `steps`.
- **D4** (component template/themes/install/CLI): drop `preview_controls`,
  `dashboard`, `bar_chart`, `swatches`; add `theme_rail` + live preview +
  typeset tables. Template = title row + typeset + per-H2 previews + install
  figure + tables. Estimate **2400 → ~2100 LOC**.
- **D5** (motion/responsive): reduced to colour-only hovers, `#` anchor reveal,
  2 s copy timer, palette 200 ms, popper 100 ms, reduced-motion audit.
  Breakpoints are now **exact**: 640 / 768 / 1024 / 1280 (TOC) with the §2.9
  table as the checklist. No drawer swap (popper), no 375 px device frames,
  no reveal/spring/float tests. Estimate **600 → ~300 LOC**.
- **D6** (UI check): reference set changes from `rearch/design/docs/screens/*.png`
  (13 Open Design shots) to **`rearch/design/shadcn-ref/screens/*.png` (115
  captures)** — same-width, same-mode, same-state comparison; add the 11 state
  shots to the checklist; the light-mode gap noted in §8.9 of the plan is closed
  (every route captured in both modes at both viewports).
- Plan §1.5/§8 open questions superseded: palette panel width (640 → **512**),
  sidebar width (270 → **288/224**), copy duration (1500 → **2000 ms**),
  pill set on the index (no pills at all), `R:drawer` for mobile nav (→
  `R:popup`).

---

## 6. Open questions / UNVERIFIED

1. Keep the generated API/theme/keyboard tables on component pages? (Recommend:
   yes, typeset-styled, after Usage — the reference has none, but our ground
   rule 3 requires generated facts.)
2. `R:tabs` line/underline variant — UNVERIFIED (else docs-only `D:LineTabs`).
3. `R:card` border-only / no-padding preview frame — UNVERIFIED (else
   `D:PreviewFrame`).
4. `R:popup` as full-width header-anchored mobile nav — UNVERIFIED (fallback
   `R:drawer` or docs-only overlay).
5. `R:markdown` can render the typeset metrics without Material — UNVERIFIED
   (else docs-only `D:Typeset` widget tree).
6. `R:command` palette API vs docs-only panel (the old plan's D4 spike; target
   shape now fixed at 512 px / no scrim / footer bar).
7. Default brightness: system (reference behaviour) vs fixed dark (old plan)?
   Recommendation: system + persist.
8. Home `<768` static collage PNG: we must produce our own asset (D3).
9. Their `docs-breadcrumb.tsx` usage — UNVERIFIED (absent on all pages we
   captured).
10. Whether `R:steps` supports the `.step` counter layout (md: 9 px circle,
    `-50px` offset) — UNVERIFIED.

## RESULT
status: done
files_written:
- /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/design/shadcn-ref/screens/ (115 PNGs: 13 pages × 2 viewports × 2 modes × (above-fold + full-page) = 104, plus 11 state captures)
- /Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit/rearch/reports/P6_SHADCN_SITE_SPEC.md
commands_run:
- agent-browser (isolated --session p6a2): 4 page batches (dark/light × 1440×900/375×812, above-fold + full-page, localStorage theme forced + verified) -> 104 page PNGs
- agent-browser: state batches (⌘K, typed query, View Code, npm install tab, copy click, sidebar hover, mobile hamburger, /create welcome-dialog dismissal) -> 11 state PNGs
- agent-browser eval: CSS custom-property dump (:root/.dark), computed-style probes for header/sidebar/TOC/article/typography/code/tabs/pager/cards/palette/footer, transition+animation inventory, breakpoint sweep at 1920/1600/1536/1440/1280/1100/1024/1000/900/768/640/639/600/480/375
- curl: GitHub API tree of shadcn-ui/ui@main; raw fetches of apps/v4/app/globals.css, (app) layouts, docs [[...slug]] page, root page, and 20 components (site-header, docs-sidebar, docs-toc, component-preview(-tabs), command-menu, code-block-command, copy-button, mobile-nav, components-list, page-header, site-footer, announcement, mdx-components, lib/config) + apps/v4/app/(app)/(typeset)/typeset.css
- curl: deployed stylesheet chunks (4) -> authored :root/.dark hex tokens, compiled .typeset block, breakpoints, default transition, shadows
- curl: registry.npmjs.org shadcn@4.21.4 tarball (confirmed dist/tailwind.css has no typeset block -> source traced to apps/v4/app/(app)/(typeset)/typeset.css via app/typeset.css/route.ts)
- python3+PIL: luminance audit of all 115 PNGs vs filename mode -> 0 mismatches
- shell (read-only): registry inventory (118 component dirs, 7 category histogram from meta.json, 44 theme files), plan reads (REARCHITECTURE_PLAN.md, P6_DOCS_BUILD_PLAN.md)
key_findings:
- The reference is structurally much simpler than the current plan: docs article is a 640 px column (max-w-160) between a 288 px sidebar and a 288 px TOC; the components index is a plain link grid; component pages have no controls, no API/theme/keyboard tables, and no related cards; there is no breadcrumb and no chart dashboard.
- Motion on the site is minimal and fully inventoried: 150 ms cubic-bezier(.4,0,.2,1) transitions everywhere, 200 ms dialog, 100 ms popper, 200 ms linear heading-# reveal, 1 s spinner, 2000 ms copy reset, active-press opacity — no scroll reveals, springs, marquee or route transitions.
- The command palette has NO backdrop/scrim (DialogOverlay commented out), is 512 px at top 15%, radius 14, ring-4, with a 40 px footer hint bar; its trigger is the header search button (256/192/160 px by breakpoint).
- Removing the Open Design dashboard+bar-chart from /themes eliminates the plan's only "no registry chart component" deviation; the reference's theme UI is a 192 px customizer rail + live preview.
- Live tokens are the classic shadcn neutral palette (light #fff/#000/#e5e5e5/#737373, dark #0a0a0a/#fafafa/#e5e5e5/#a1a1a1, border white/10, radius 10 px), identical to our preset schema names, plus 7 site-only tokens (surface/code/selection family) that should stay docs-app constants.
- Screenshots are verified (luminance audit, isolated browser session) because the default agent-browser session was concurrently used by another agent and the image read tool served stale bitmaps mid-run.
open_questions:
- Generated API/theme/keyboard tables kept (recommended) vs dropped to mirror the reference exactly; system-default brightness; R:tabs line variant, R:card border-only frame, R:popup mobile nav, R:markdown typeset metrics, R:command palette API, R:steps counter layout (all UNVERIFIED); our own mobile collage PNG asset; docs-breadcrumb.tsx usage upstream.

## 7. Orchestrator decisions (2026-10-09, binding for D3–D6)
- Keep the GENERATED API / theme-field / keyboard tables on component pages, styled exactly like shadcn's typeset
  tables, under an "API Reference" H2 (shadcn pages carry API references too; Flutter users need them).
- Default brightness = system (their next-themes default); toggle cycles light/dark.
- Every "UNVERIFIED R:<component>" fit is verified by the builder against the real registry API; if a registry
  component cannot reproduce the measured look, fix the gap with a docs-only widget and list it — never fake facts.
- Our own simple logo mark + product name `shadcn_flutter_kit`; no shadcn/Vercel branding, no "Deploy on Vercel" card;
  the Base UI / React Aria / Radix tabs do not exist on our component pages.
