# P3V visual follow-up: sizes vs shadcn, hover test, dark dialog (P3-F)

Status: **done** — all gates green (`rearch/qa_batch.sh button toggle input
dialog` clean; `flutter test test/registry_next/visual` green, 24/24 PNGs
regenerated).

## 1. Sizes vs shadcn/ui (new-york, default density)

New test: `test/registry_next/components/pilot_metrics_test.dart` (13 tests,
`tester.getSize` / `tester.getRect` only — no pixel probing).

Root cause (button + toggle): the `Clickable` padding wraps the inner
`ConstrainedBox`, so any vertical padding **stacks** on top of `minHeight`
instead of behaving like CSS border-box. md measured 36 + 2×8 = **52**;
same for toggle (36 + 2×8 = 52) and lg (44 + 2×10 = 64). Fix: vertical
padding zero (height comes from `minHeight` + centering) plus a border-box
helper (`_innerMin` / `innerMinWidth/Height`) that subtracts the *resolved*
padding from the inner minima, so themed padding overrides cannot re-stack
(e.g. 16px icon + 16px padding still measures 36×36, not 52×36).

| Check (shadcn) | Before | After |
|---|---|---|
| Button xs height (h-7, 28) | 36 | 28 |
| Button sm height (h-8, 32) | 44 | 32 |
| Button md height (h-9, 36) | 52 | 36 |
| Button lg height (h-10, 40) | 64 | 40 |
| Button icon (size-9, 36×36) | 36×36 | 36×36 (unchanged; no icon-sm/lg sizes exist — asserted) |
| Button padding sm/md/lg (px-3/4/6) | 12/16/20 + vertical | 12/16/24, vertical 0 |
| Button text | 12/13/14/15 by size | 14 w500 all sizes (shadcn `text-sm font-medium`) |
| Input height (h-9, 36) | 36 | 36 (unchanged — shell already constrains outside padding) |
| Input padding / border / radius | px-3, 1px, radiusMd | unchanged, now asserted |
| Toggle md (h-9, 36; min-w 36, px-2) | 52 high, px-4 | 36 high, min-width 36, px-2 (8) |
| Toggle sm / lg (h-8/h-10) | did not exist | new `ToggleSize.sm/lg` (32/40); default `md` so existing call sites compile unchanged |
| Dialog max-width (sm:max-w-lg, 512) | 480 | 512 |
| Dialog padding (p-6, 24) | 24 | 24 (unchanged, now asserted) |
| Dialog radius | radiusLg (8 at default radius) | unchanged, now asserted against the token |
| Dialog header/body/footer gap (gap-4, 16) | example cards used 8/24 | 16; asserted on a canonical column (gap is caller-owned — the shell only pads) |

Tests updated that had encoded the wrong sizes (all still green after the
fix): `button_test.dart` (md padding `h16v8` → `h16`; hover test rewritten,
§2), `dialog_test.dart` (default width 480 → 512 in two comments/assertions;
radius 8 kept = `borderRadiusLg` at default radius, metrics test asserts the
token directly). `toggle_test.dart` gained `ToggleSize` coverage implicitly
(default `md` keeps every existing assertion passing).

## 2. Hover test that passed for the wrong reason

`button_test.dart`: hovered and pressed shared alpha 0.9, so the old
assertion (`hover == primary@0.9`, then `press == primary@0.9`) could not
distinguish a real hover from a press. Rewrote with distinct fills
(rest yellow / hovered green / pressed red via the widget leg): mouse
`TestGesture` + `highlightStrategy = alwaysTraditional` (restored with
`addTearDown`) must report `onHover == true` and paint green; tap-down must
paint red. Added the same distinct-fill hover test to `toggle_test.dart`
(which had no hover test at all), including the `flutter/gestures.dart`
import it was missing.

## 3. Dark-mode dialog background

Verdict: **screenshot harness, not a dialog bug** — no dialog code changed
for this item.

Evidence: `pilot_metrics_test.dart` → "dark mode: card uses dark tokens"
pumps a dark `ShadcnTheme` + explicit dark page background, opens a real
`showShadcnDialog` route and asserts the card resolves to
`darkFallback.card` (it does — the route re-resolves the theme live on every
build via `_DialogShell`/`_DialogBarrier`, and `dialog_test.dart` "theme
stays live" already proved a mid-session light→dark switch restyles card and
barrier). The current `dialog_dark.png` on disk also shows the correct dark
page + dark card, so no stale-theme path exists in the component.

Harness hardening (in `pilot_screenshots_test.dart`, allowed output):
`_DialogPage` was a transparent `SizedBox.expand()` that relied on the
ancestor `ColoredBox` for its background — a future stale-theme regression
would have been invisible. It now paints `ShadcnTheme.of(context).colors.background`
explicitly. `_DialogCard` gaps corrected to 16/16 (was 8/24) per §1.

## 4. Regenerated screenshot verdicts (after fixes)

| PNG (light + dark unless noted) | Verdict |
|---|---|
| `button` | OK — md/lg visibly shorter; hovered + focused rows render |
| `button_group` | OK — joined radii unchanged, heights follow button fix |
| `toggle` | OK — pills visibly shorter (36 high) |
| `dialog` | OK — dark page is dark, card is dark `card` token; gaps 16 |
| `preset_button` (violet-bloom) | OK — same geometry under preset tokens |
| `preset_dialog` | OK — dark card follows preset dark tokens |
| `preview_button` | OK |
| `preview_toggle` | OK |
| `input`, `input_context_menu`, `preset_input`, `preview_input` | ISSUE (pre-existing, unchanged by this brief) — filled values render as solid bars: `EditableText` uses `typography.small` with no font family, so the test engine falls back to Ahem tofu while `Text` placeholders inherit loaded GeistSans. Needs a follow-up (wire family into the input text style or the harness), not a metrics regression: widget-test height (36) and surface tokens are asserted green. |
| `input_menu_*` (stale, 2026-10-06, no generator) | Not evaluated — left untouched |

## Files changed

- `lib/registry_next/components/button/button.dart` — vertical padding 0,
  lg 44→40 / horiz 20→24, all text 14 w500, `_innerMin` border-box helper.
- `lib/registry_next/components/toggle/toggle_style.dart` — new `ToggleSize`
  (sm/md/lg), `toggleDefaultPadding` 16v8→h8.
- `lib/registry_next/components/toggle/toggle.dart` — `size` param (default
  `md`), border-box inner minima.
- `lib/registry_next/components/dialog/dialog_style.dart` — maxWidth 480→512.
- `lib/registry_next/components/dialog/preview.dart` — body gaps 8/16→16/16.
- `test/.../button_test.dart`, `toggle_test.dart`, `dialog_test.dart` —
  distinct-fill hover tests; padding/width corrections (§1).
- `test/.../pilot_metrics_test.dart` — new, 13 tests.
- `test/registry_next/visual/pilot_screenshots_test.dart` — themed dialog
  page background; card gaps 16/16.
- `rearch/screenshots/pilot/*.png` — regenerated (24 files).

## Round 2: editable-text theme font (real bug, not harness)

Bug: `EditableText` ignores the ambient `DefaultTextStyle`, and
`resolveInputSurface` built its style from `theme.typography.small` (size 14
only, no family). `Text` widgets inherited the theme font (Geist) from the
gallery/app `DefaultTextStyle`; typed text fell back to the platform default
(in tests: Ahem tofu bars in every filled field of `input_*.png`).

Fix (in `primitives/text_editing/`, so all consumers benefit): new
`primitives/text_editing/editable_text_style.dart` with
`resolveEditableTextStyle(context, {base, overrides, color})`. It keeps the
existing merge order (text-sm base < theme-leg < widget-leg, colour
foreground / mutedForeground fallbacks — no behaviour change there) and
fills only what was missing: `fontFamily`/`fontFamilyFallback` from the
ambient style when set, else from `theme.typography.sans` (bare apps with no
ambient style still get the theme font), plus ambient `height` when the
merged style has none. `resolveInputSurface` now routes both the typed style
and the hint style through it. This fixes `input` and `text_area` (reuses
`resolveInputSurface`); `input_otp` needs no change (visible digits are
`Text` widgets, its `EditableText` is an invisible `Opacity(0)` field);
`selectable` keeps its own style (out of scope, colour assertion still
green). Behaviour nuance: a hint override without its own size now keeps the
text-sm 14 instead of dropping the base (more correct; no test depended on
the old drop).

Tests: `input_test.dart` gains "editable text uses the theme font family"
(`fontFamily == typography.sans.fontFamily`, size 14, foreground),
"placeholder uses mutedForeground" and "explicit style override wins over
the theme font"; `text_editing_test.dart` gains a `resolveEditableTextStyle`
group (sans fallback, ambient-beats-sans, override-beats-all).
`text_area`/`selectable`/`pilot_metrics` suites re-run green (no regressions;
input height stays 36).

Screenshots: regenerated — `input_light/dark.png`, `preset_input_*` and
`preview_input_*` now show real glyphs, so the Round 1 verdict for those
files flips from ISSUE to OK. `input_menu_light/dark.png` (stale since
2026-10-06, no generator) now have one: an `input_menu` scene reusing the
`input_context_menu` build + interact was added to
`pilot_screenshots_test.dart` (no files deleted), and both PNGs regenerated
with real glyphs and the Cut/Copy/Select-all toolbar visible.
