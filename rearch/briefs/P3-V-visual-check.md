# Brief P3-V — visual check of the Phase 3 pilot (screenshots + review)

## Goal
Render every pilot component to PNG screenshots and review them visually against shadcn/ui (new-york style) so the
user can trust they look right before ~100 components copy this pattern. Do NOT change component code — report.

## 1. Screenshot harness (test-only)
Write `$APP/test/registry_next/visual/pilot_screenshots_test.dart` that, with `flutter test`, renders each scene at
device pixel ratio 2 inside `ShadcnTheme` (+ `ComponentThemes` at root) and writes PNGs to
`$KIT/rearch/screenshots/pilot/<scene>_<light|dark>.png` (use `RepaintBoundary` + `toImage` inside
`tester.runAsync`, or `matchesGoldenFile` with `--update-goldens` — whichever reliably produces real PNG files).
Load a real font (the presets' sans font from the repo assets if available, else Roboto from the Flutter SDK
`bin/cache/artifacts/material_fonts/`) via `FontLoader`, otherwise text renders as boxes — say which you used.
Scenes (light AND dark each):
- button: all 6 variants × sizes xs/sm/md/lg/icon, plus disabled row, plus a keyboard-focused button (focus ring)
  and a hovered button (use a `TestGesture` mouse hover)
- button_group: horizontal + vertical
- toggle: off, on, disabled
- input: empty with placeholder, filled, focused, disabled, error state, with clear + password features, a
  spinner input, and the context menu open over a selection
- dialog: open dialog with title, body text and two caller-supplied buttons, barrier visible (400×300 surface)
- one non-default preset (pick e.g. a violet/rose preset from `registry_next/themes/`) for button + input + dialog
Use each component's `preview.dart` where it already covers a scene.

## 2. Review
Look at every PNG yourself. Compare against shadcn/ui defaults: button h-9 (md) / px-4, radius from token,
text 14px medium; outline = 1px border; focus ring = 3px ring colour at 50%; input h-9, 1px input border, px-3,
placeholder mutedForeground; dialog max-w ~512, p-6, rounded-lg, border, shadow-lg, 50% black overlay; good
contrast in dark mode; nothing clipped, overflowing, misaligned, invisible, or using a fallback/transparent colour.

## Outputs (only these)
- `$APP/test/registry_next/visual/pilot_screenshots_test.dart`
- `$KIT/rearch/screenshots/pilot/*.png`
- `$KIT/rearch/reports/P3V_VISUAL.md`: per scene → PNG path, verdict (OK / ISSUE), and for each ISSUE: what is
  wrong, the measured value vs the shadcn value, the likely file/line responsible, suggested fix. End with a ranked
  issue list.

## Gates
```
cd $APP
dart format --set-exit-if-changed test/registry_next/visual
dart analyze test/registry_next/visual                 # 0 issues
flutter test test/registry_next/visual                 # green, PNGs written (ls -la the folder in the report)
flutter test test/registry_next                        # still all green
```
