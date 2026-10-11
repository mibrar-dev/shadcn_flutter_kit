# P3-C — `dialog` pilot build report (QA round 2)

Status: **all gates green** (round 1's `undeclared-dependency` blocker was
fixed in the checker by the orchestrator: the rule now reads the new tree's
`deps` shape and reports 0).

Implements `P3_PILOT_DESIGN.md` §0 and §3 with all §5 dialog decisions
(D1 `showShadcnDialog`, D2 Navigator route only, D3 default barrier black a0.5,
D4 Escape dismisses). No Material/Cupertino, no `button` import (dialog actions
are caller-supplied widgets).

## Round 2 changes (F1–F5)

| Fix | What changed |
|---|---|
| F1 live theme | `DialogTheme` + `ShadcnColors` are now resolved **inside the route** on every build: `_DialogShell.build` and the new private `_DialogBarrier` each call `resolveComponentStyle` + `ShadcnTheme.of`. Captured themes (`InheritedTheme.capture(from: caller, to: navigator)`) and captured data are re-injected by `buildPage` / `buildModalBarrier`, wrapping the **widget** (not the build result) so the resolving context sees them. `buildModalBarrier` is overridden and resolves the barrier colour + label per barrier build, keeping the fade-in by driving `ColorTween(...).chain(CurveTween)` off the route animation. |
| F2 | `anchorPoint` deleted from `showShadcnDialog`, `ShadcnDialogRoute`, README and `meta.json`. `ModalRoute.barrierColor` (abstract) is implemented as `null` with a doc note that `buildModalBarrier` owns the colour. |
| F3 | Two theme fields: `padding` = card padding (shadcn `p-6`, `padMd` x density content padding = 24px, kept in full screen) and `insetPadding` = screen-edge inset (`padSm` x density content padding = 16px, `EdgeInsets.zero` when `fullScreen`). Updated in `DialogTheme` (field, `copyWith`, `merge`, `lerp`, `==`, `hashCode`, `dialogDefaults`), README and `meta.json`. |
| F4 | `ShadcnLocalizations.dialogDismiss` added (base `'Dismiss'`) and overridden in **all 39 locale tables** with the value Flutter itself uses for `modalBarrierDismissLabel`, taken verbatim from `$FLUTTER_ROOT/packages/flutter_localizations/lib/src/l10n/material_<locale>.arb` (`zh_Hant` uses `material_zh_TW.arb`). Nothing invented. `kDialogFallbackBarrierLabel` and its TODO are gone; `barrierLabel: null` now resolves `ShadcnLocalizations.of(context).dialogDismiss`. `deps.primitives` = `["localizations"]`. |
| F5 | `meta.json` lost the duplicate top-level `dependencies` block; `deps` is the single source of truth. |

Structural note: `_DialogBarrier` and `_DialogShell` now hold the
`ShadcnDialogRoute` instead of copying its options into 10 constructor
parameters. This removed the duplication that pushed `dialog.dart` over the
400-line gate and keeps the two private widgets in sync with the route by
construction.

## Files

| File | LOC | Notes |
|---|---|---|
| `lib/registry_next/components/dialog/dialog.dart` | 399 | `showShadcnDialog`, `ShadcnDialogRoute`, `_DialogBarrier`, `_DialogShell` |
| `lib/registry_next/components/dialog/dialog_style.dart` | 198 | `DialogTheme` (10 fields) + `dialogDefaults` |
| `lib/registry_next/components/dialog/dialog_theme.dart` | 20 | user-owned `const dialogThemeOverrides` |
| `lib/registry_next/components/dialog/preview.dart` | 267 | widgets-only gallery (own Navigator, dark subtree, radius 1.0 preset) |
| `lib/registry_next/components/dialog/meta.json` | 47 | `deps` only |
| `lib/registry_next/components/dialog/README.md` | 137 | when-to-use, 3 snippets, API/theme tables, live-theme note, old→new deltas |
| `test/registry_next/components/dialog_test.dart` | 545 | 15 tests |
| `lib/registry_next/primitives/localizations/localizations.dart` + 39 locale files | +2 each | `dialogDismiss` |
| `test/registry_next/primitives/localizations_test.dart` | +2 | one assertion for the new key |

## Live-theme mechanics (F1), as verified

- `ComponentThemes` (app leg) is **not** an `InheritedTheme`, so
  `InheritedTheme.capture` cannot carry it into the route. It works because an
  app installs it at the root, above the `Navigator` — the route subtree then
  sees it. The test frame now mirrors that placement (above the navigator);
  the scoped leg (`ComponentTheme<T>`, an `InheritedTheme`) is placed around the
  caller below the navigator and reaches the route through capture.
- Captured themes must wrap the shell/barrier **widget**: wrapping the value
  returned by `build` would leave the resolving `build` context outside them.
  This was the one real bug found while wiring F1.
- `ShadcnTheme` captured from the caller freezes the value, as
  `InheritedTheme.capture` documents; a root-level `ShadcnTheme` above the
  navigator keeps live-switching.

## Deviations from the design (verified against the code)

1. **`RawDialogRoute` is in `widgets.dart`, not Material, in Flutter 3.47.5**
   (`widgets/routes.dart:2593`). The design's premise is stale; its instruction
   (extend `ModalRoute`) is followed.
2. **`anchorPoint` deleted** (QA F2): widgets `ModalRoute` has no anchor point,
   so the old parameter could only ever have been carried unused.
3. **Focus restore lives in the shell's `dispose()`**, not a route hook:
   `Route.didPop` on `LocalHistoryRoute` is `bool didPop(T? result)` (a
   pop-disposition hook), and `RouteAware.didPop` only reaches registered
   observers. The shell schedules
   `addPostFrameCallback → openerFocus.requestFocus()`, which also covers
   barrier, Escape and `removeRoute`.
4. **Focus trap is explicit.** The framework modal scope is not a traversal
   boundary (`FocusNode.isTraversalBoundary` is false unless
   `descendantsAreFocusable`), so Tab could leak below the dialog. The shell's
   `FocusScope.onKeyEvent` handles Tab/Shift+Tab over `traversalDescendants`
   and returns `handled`; `closedLoop` wraps, other edge behaviours halt.
5. **`borderRadius` and `shadows` are not in `dialogDefaults`** — they are
   ambient values (`radiusLg`, `shadowLg`) and cannot live in a `const`
   default; the shell resolves them at build, so preset changes are honoured.
6. **`transitionDuration` is the one value decided at show time**: the framework
   reads it while installing the route, before any route context exists.
   Everything else (colours, radius, padding, barrier, label) resolves per
   build. Documented in the README.
7. Surface opacity/blur/clip (`ModalBackdropTheme`) dropped per design §3.3.

## Tests (`test/registry_next/components/dialog_test.dart`, 15 green)

| §3.7 row / QA item | Test |
|---|---|
| open/close, scale + fade settle | `opens with a scale and fade, closes again` |
| themed shell: card bg, border, radiusLg | `shell paints the themed card` (480 max width wins over 1000 wide content) |
| barrier tap iff `barrierDismissible` | `barrier tap dismisses only when barrierDismissible` |
| Escape iff `barrierDismissible` | `escape dismisses only when barrierDismissible` |
| default barrier opaque black a0.5 + label | `default barrier is black at 50% and honours overrides` (alpha/rgb read from `AnimatedModalBarrier`, `ThemedColor` override, explicit label wins over `dialogDismiss`) |
| full screen: zero radius, no inset | `full screen drops radius, border, shadow and inset` (800x600 card, null radius/border/shadow, content at 24,24 → inner padding kept) |
| **F3** inner padding + outer inset | `card pads its content and keeps an outer inset` (card at 16,16; content 24px inside the card) |
| **F1** live theme | `theme stays live: card and barrier follow a dark switch` (light→dark flip with the dialog open: card colour and barrier colour both follow; a `ComponentTheme<DialogTheme>` around the caller beats the black a0.5 default) |
| focus in, opener restored, Tab cycles | `focus moves into the dialog, cycles, and comes back` |
| `useSafeArea: false` | `useSafeArea insets the card` |
| 3 theme legs + per-field merge | `widget leg beats scoped leg beats app leg beats defaults` |
| result value | `returns the value passed to Navigator.pop`, `barrier dismissal resolves to null` |
| dark tokens | `dark tokens drive the card` |
| transition duration from theme | `transitionDuration from the theme is honoured` |

Plus one assertion in `test/registry_next/primitives/localizations_test.dart`
(F4): `expect(localizations.dialogDismiss, 'Schließen');`.

Not covered: the `alert_dialog` compile check — `alert_dialog` does not exist in
`registry_next` yet.

## Gates

```
$ cd flutter_shadcn_kit

$ dart format --set-exit-if-changed lib/registry_next/components/dialog test/registry_next/components/dialog_test.dart lib/registry_next/primitives/localizations
Formatted 49 files (0 changed) in 0.05 seconds.
exit=0

$ dart analyze lib/registry_next test/registry_next
Analyzing registry_next, registry_next...
No issues found!

$ flutter test test/registry_next/components/dialog_test.dart
00:00 +15: All tests passed!

$ flutter test test/registry_next            # whole suite, no regressions
00:05 +265: All tests passed!

$ dart run tool/rearch/check_layers.dart --root lib/registry_next
check_layers: 119 files scanned, 0 files with syntax errors
  no-material: 0 (error)
  no-part: 0 (error)
  no-ignore-for-file: 0 (error)
  layer-direction: 0 (error)
  undeclared-dependency: 0 (error)
  file-too-long: 8 (warning)
  unused-dependency: 0 (warning)
  installable: 0 (error)
  no-impl-dir: 0 (error)

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 119 files scanned, 359 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0

$ dart run tool/rearch/check_user_theme.dart --root lib/registry_next   # extra gate
check_user_theme: 0 finding(s)
```

### Remaining warning (1 line, needs a QA decision)

`file-too-long: primitives/localizations/localizations.dart — 401 lines (limit 400)`.
The file was already at the cap before this round (400 by the tool's count),
and F4 requires adding a member, so **any** addition trips the rule. The only
ways out are outside this brief: split the class (e.g. move the date/time/
duration members into their own library per §4's LOC guard) or delete unrelated
content. `dialog.dart` is at 399 wc / 400 by the tool's count and is *not*
listed.

## Open questions

1. Split `localizations.dart` (see above), or accept the one-line warning?
2. `alert_dialog` should sit under the new padding model: `DialogTheme.padding`
   (24px) is inherited, so it only has to compose title/description/actions.
3. Should `transitionDuration` also be re-read live (it would need the route's
   animation swapped mid-flight — probably not worth it)?
4. `preview.dart` still wraps its demos in its own `Navigator`; decide whether
   the gallery provides one instead.