# P3-B report: `button` (+ `button_group`) and `toggle`

Status: **done** — all gates green. Implements `P3_PILOT_DESIGN.md` §0/§1,
including the orchestrator QA fix: disabled = rest colours with the whole
control at opacity 0.5. No Material/Cupertino, no `_impl/`, no `part`, no
`// ignore`; components import foundation/theme/primitives only (never
another component).

## Files written

| File | LOC | Contents |
|---|---|---|
| `lib/registry_next/components/button/button.dart` | 309 | `Button`, per-state paint pipeline, size table, disabled opacity |
| `lib/registry_next/components/button/button_style.dart` | 384 | `ButtonVariant`, `ButtonSize`, `ButtonVariantStyle`, `ButtonTheme`, `buttonDefaults` |
| `lib/registry_next/components/button/button_group.dart` | 222 | `ButtonGroup`, `ButtonGroupData` (radius surgery, RTL, nesting) |
| `lib/registry_next/components/button/button_theme.dart` | 24 | user-owned `const buttonThemeOverrides` (empty + commented example) |
| `lib/registry_next/components/button/preview.dart` | 229 | widgets-only gallery: variants, sizes, states, groups, dark |
| `lib/registry_next/components/button/meta.json` | 62 | manifest (deps/API/theme sections) |
| `lib/registry_next/components/button/README.md` | 136 | when-to-use, snippets, API/theme tables, old-vs-new |
| `lib/registry_next/components/toggle/toggle.dart` | 265 | `Toggle`, `ToggleController`, controlled/uncontrolled asserts, form mixin |
| `lib/registry_next/components/toggle/toggle_style.dart` | 248 | `ToggleStyle`, `ToggleTheme`, `toggleDefaults` |
| `lib/registry_next/components/toggle/toggle_theme.dart` | 24 | user-owned `const toggleThemeOverrides` (empty + commented example) |
| `lib/registry_next/components/toggle/preview.dart` | 176 | widgets-only gallery: controlled, controller, disabled, dark |
| `lib/registry_next/components/toggle/meta.json` | 45 | manifest |
| `lib/registry_next/components/toggle/README.md` | 101 | when-to-use, snippets, API/theme tables, old-vs-new |
| `test/registry_next/components/button_test.dart` | 518 | 8 tests: 7x5 matrix, precedence, keyboard/ring, disabled, group/RTL, dark, theme class |
| `test/registry_next/components/toggle_test.dart` | 384 | 9 tests: controlled/controller/disabled, keys, ring, precedence, dark, form |

Primitives used as built (design `ASSUMED` items resolved):

- `primitives/clickable.dart: Clickable` — real API: `enabled`, `onPressed`,
  `onLongPress`, `onHover`, `onFocus`, `focusNode`, `statesController`,
  `decoration/padding/textStyle/iconTheme/mouseCursor` as
  `WidgetStateProperty`, built-in Enter/Space `ActivateIntent` and semantics.
  The design's `onActivate` does not exist; `onPressed` + `onLongPress` are
  used instead.
- `primitives/focus_outline.dart: FocusOutline` (design called it `FocusRing`)
  — `Clickable` already wraps itself with it and derives the radius from the
  resolved `BoxDecoration`; `Button` does not wrap it a second time.
- `primitives/form_core/form_value.dart: FormValueSupplier<bool, Toggle>` —
  mixed into `Toggle`'s state; `form_core.dart` (barrel) does **not** export
  `form_value.dart`, so toggle imports the file directly.
- `foundation/gap.dart: Gap`, `foundation/data.dart: Data` — used for
  leading/trailing spacing and `ButtonGroupData` propagation.
- `resolveComponentStyle` 3-arg built signature is used (widget-leg merge via
  receiver-wins `Mergeable.merge`), per T2.

## Old → new mapping (button, 64 old files)

| Old | New / fate |
|---|---|
| `_impl/core/button_widget.dart` (Button + 8 named ctors) | `button.dart`: one ctor + `variant`; named ctors deleted (clean break) |
| `_impl/variants/{primary,secondary,outline,ghost,link,text,destructive}_button.dart` (~174 LOC each) | deleted; one `ButtonVariant` enum row each |
| `_impl/variants/{selected_button,selected_button_widget}.dart`, `state/selected_button_state.dart` | `toggle/toggle.dart`; `SelectedButton.style` → `Toggle.style`, `selectedStyle` → `Toggle.activeStyle`; class deleted |
| `_impl/core/toggle{,_widget}.dart`, `controlled_toggle.dart`, `state/toggle_{controller,controller_class,state}.dart` | `toggle/toggle.dart` (`Toggle`, `ToggleController`) |
| `_impl/core/button_group{,_widget,_data}.dart` | `button_group.dart` (`ButtonGroup`, `ButtonGroupData`), shipped inside `button` |
| `_impl/core/button_core.dart`, `button_icon.dart` | folded into `button.dart`; icon = `leading`/`size: .icon`; `IconButton.*` deleted |
| `_impl/styles/*` (15 files) | `ButtonSize` enum + size table; group border surgery kept as `ButtonGroupData.apply`; `Styleable`/`ButtonStyleOverride` machinery deleted (resolver replaces it) |
| `_impl/themes/*` (18 files) | `button_style.dart` + `button_theme.dart` |
| `_impl/themes/variants/{menu,menubar}_button_theme.dart` | not ported (belong to menu/menubar pilots) |
| `_impl/themes/variants/card_button_theme.dart`, `_impl/variants/card_button.dart` | deleted (0 importers) |
| `_impl/themes/variants/{fixed,muted}_button_theme.dart`, `tab_button.dart` | fixed deleted; muted folded into `text`; `TabButton` stays in the old tree for the tabs pilot |
| `_impl/utils/button_helpers.dart` | values became `buttonDefaults` const rows |
| `_impl/state/button_state.dart`, `_impl/extensions/button_style_extension.dart` | deleted; state via `Clickable`, widget-leg `theme:` param instead of the extension |
| `button.dart` barrel, `preview.dart`, `button.meta.json` | rewritten per §0 |

Old bugs found and fixed (not ported), verified in the old sources:

- Destructive label was hardcoded `Colors.white` (old `button_helpers.dart`
  L462) → `destructiveForeground` token.
- Primary disabled used `mutedForeground` as *background* (L164-169), i.e.
  an unreadable fill → rest colours + whole-control `opacity 0.5`.
- Destructive rest was `destructive@0.5` (L446) → the full `destructive`
  token; hover is shadcn `/90`.
- Primary hover was `@0.8` (L172) → shadcn `/90`; secondary keeps `/80`;
  outline/ghost/text/link follow the design table.
- `Button.fixed`/`ButtonStyle.fixed`: the design left this UNVERIFIED.
  Grep result: **2 external old-tree users** —
  `layout/card_image/_impl/state/_card_image_state.dart:27` and
  `navigation/navigation_bar/_impl/state/_navigation_bar_preview_state.dart:34`.
  Phase 4 must map them (likely `size: ButtonSize.icon`); not a pilot blocker
  because the old tree is untouched until cutover.
- `SelectedButton` also has 4 external old-tree users (autocomplete /
  text_field item states, card_image, navigation_bar) — same Phase 4 note.
- `ButtonGroup` previously rewrote radii via a `ButtonStyleOverride` closure;
  now `Button` reads `ButtonGroupData` itself, so the surgery is applied once
  at resolution time, composes multiplicatively for nested groups, and is
  RTL-aware via `Directionality`.

## Deviations from the design (all deliberate, with reasons)

1. **Enums live in `button_style.dart`** (design §1.2 put `ButtonVariant`/
   `ButtonSize` in `button.dart`) so the style layer never imports the widget
   layer; `button.dart` re-exports them, so the public surface is unchanged.
2. **`button_group.dart` is its own file** (design §1.2 listed `ButtonGroup`
   in `button.dart`; the brief's output list has `button_group.dart`). Keeps
   `button.dart` under 400 LOC.
3. **`Button` is a `StatefulWidget` only for `autofocus`** — `Clickable` has
   no `autofocus` param, so the button owns an internal `FocusNode` and
   requests focus post-frame; without autofocus the `Clickable` owns the
   node. All interaction state still lives in `Clickable`.
4. **Density leg read explicitly.** `resolveComponentStyle` returns the slice
   `S` (`ButtonVariantStyle`), not the container `T` (`ButtonTheme`), and the
   slice has no density field; the `ButtonTheme.themeDensity` leg is read via
   `ComponentTheme.maybeOf<ButtonTheme>` then `ComponentThemes.maybeOf`.
   Padding is scaled by `density.baseContentPadding / 16`; `theme.scaling` is
   intentionally not applied to the size table (design: "density-independent
   constants; global Density scales padding").
5. **Toggle API shape.** The §1.5 sketch had `required this.value`, which
   contradicts the controlled/uncontrolled rule; `value` is `bool?` with two
   asserts (controller mode rejects `value`/`onChanged`; controlled mode
   requires `value`). `activeStyle` is the §1.5 text's mapping of
   `SelectedButton.selectedStyle`; `theme` is a generic `ToggleStyle?` widget
   leg merged *under* `style`/`activeStyle` (documented in the ctor).
6. **`ToggleStyle` is defined locally** in `toggle_style.dart` (design §1.6
   said "pair of `ButtonVariantStyle`", §1.8 said "no cross-component
   import"). The toggle defaults duplicate the primary/ghost rows as data;
   no class is defined twice.
7. **Toggle default metrics** are h16/v8, min height 36, text 14/w500 — the
   design gives no toggle size table; these match the old Button/`Toggle`/
   `SelectedButton` default padding so the migration is visually neutral.
8. **User theme files ship empty** (`const ButtonTheme()` /
   `const ToggleTheme()`) with a commented sparse example. An active example
   override would change the token default look; the design says "sparse
   example", the file is user-owned and Studio-editable.
9. **`meta.json`** follows the dialog pilot's in-flight convention: `deps`
   (foundation/theme/primitives/components — now read by `check_layers`),
   plus a legacy `dependencies.components` key, `api` and a hand-written
   `theme` section (the generator `tool/gen_theme_schema.dart` does not exist
   yet). Both `undeclared-dependency` and `unused-dependency` report 0.
10. **Disabled is not a colour row** in either component: no `disabled`
    entries exist in the defaults, `StateValue` falls back to `rest`, and the
    widget wraps the control in `Opacity(0.5)` once (private const per
    component).
11. **Button content layout**: `leading`/`child`/`trailing` are separated by
    `theme.spacing.sm` (8 px) inside a `Row(mainAxisSize: min)`; the design
    did not specify a gap (old code used a scaled density gap).
12. **`link`/`text` pressed states duplicate hovered explicitly** (text
    pressed = `primary`) because `StateValue` never falls back across states,
    per the §1.4 rule.
13. **Previews** use `LucideIcons` from `foundation/icons`; the design's
    non-default preset subtree is skipped ("preset TBD by gallery"), dark is
    included.
14. **`button_test.dart` is 518 lines**, over the ~400 guideline, because the
    brief restricted outputs to `{button,toggle}_test.dart` and the required
    7×5 matrix + widget coverage needs the space. Split is trivial on
    request (matrix → `button_style_test.dart`).

## Test coverage (17 tests, all green)

- `button_test.dart` (8): 7 variants × rest/hover/pressed/disabled/focused
  token matrix incl. disabled-label readability for every variant; rest
  render + padding + icon 36×36 + dark tokens; mouse hover/press decoration
  targets; both disable switches + opacity 0.5 + readable label; Enter/Space
  activation, disabled ignores keys, focus ring on keyboard focus only;
  four-leg per-field precedence + stacked hovered-only override keeping lower
  rest; group first/last/middle radii, single-child full radius, RTL swap;
  `ButtonTheme` exhaustive `forVariant`, merge and lerp.
- `toggle_test.dart` (9): default on/off rows; controlled flip; controller
  mode read/write; null-`onChanged`/`enabled` matrix with opacity 0.5;
  Enter/Space; focus ring keyboard-only; widget > scoped > app precedence
  with `activeStyle`/`theme` merge; dark tokens; form participation through a
  fake `FormFieldHandle` (`false` reported initially, `true` after tap).

## Gates (exact output)

```
$ dart format --set-exit-if-changed lib/registry_next test/registry_next
Formatted 157 files (0 changed) in 0.23 seconds.

$ dart analyze lib/registry_next test/registry_next
Analyzing registry_next, registry_next...
No issues found!

$ flutter test test/registry_next
00:06 +265: All tests passed!

$ dart run tool/rearch/check_layers.dart --root lib/registry_next
check_layers: 119 files scanned, 0 files with syntax errors
  no-material: 0 (error)
  no-part: 0 (error)
  no-ignore-for-file: 0 (error)
  layer-direction: 0 (error)
  undeclared-dependency: 0 (error)
  file-too-long: 9 (warning)
  unused-dependency: 0 (warning)
  installable: 0 (error)
  no-impl-dir: 0 (error)

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 119 files scanned, 359 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0

$ dart run tool/rearch/check_user_theme.dart --root lib/registry_next
check_user_theme: 0 finding(s)
```

The 9 `file-too-long` warnings are pre-existing/other-agent files; none of the
15 P3-B files is over 400 LOC (largest: `button_style.dart` 384, tests 518 /
384). A later `--strict` re-run showed 8 warnings (the concurrent dialog pilot
trimmed `dialog.dart`); all error counts were unchanged and every `--strict`
exit was 0. When P3-B started, `check_layers` flagged every shared import as
`shared-unmapped` (reproduced in a scratch tree); mid-session another agent
updated `tool/rearch` to read `meta['deps']` and added `unused-dependency`, so
the final gate above is clean with the layered `deps` manifest.

## Open questions / notes for QA

- `button_test.dart` LOC (518) — split on request; the brief's outputs list
  only `{button,toggle}_test.dart`, so I did not create a second file.
- `meta.json` `theme` sections are hand-written placeholders until
  `tool/gen_theme_schema.dart` exists.
- `Toggle.theme` precedence (`activeStyle > theme`) is my reading of an
  ambiguous §1.5 sketch; confirm or rename.
- Phase 4 migration notes recorded above: `Button.fixed` has 2 external old
  users and `SelectedButton` has 4; old tree untouched until cutover.
- No visual/UI pass was run (not in this brief); previews are compile-clean
  and widgets-only.
