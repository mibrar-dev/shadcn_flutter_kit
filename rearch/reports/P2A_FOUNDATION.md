# P2A_FOUNDATION — `foundation/` (layer 0) built in `lib/registry_next/`

Unit: P2-A · Builder A (deepseek-v4.1-flash#max) · 2026-10-06
Outputs: `flutter_shadcn_kit/lib/registry_next/foundation/**`,
`flutter_shadcn_kit/test/registry_next/foundation/**`,
`licenses/data_widget.BSD-3-Clause.txt`, `licenses/gap.MIT.txt`.

## 1. New files (LOC)

| File | LOC | Contents |
|---|---|---|
| `foundation/data.dart` | 336 | `Data<T>` (`inherit`/`boundary`, `of`, `maybeOf`, `find`, `maybeFind`, `maybeFindMessenger`, `maybeFindRoot`, `capture`), `DistinctData`, `AlwaysUpdateData`, `DataHolder`, inherited holders, `MultiDataItem`, `MultiData`, `_InheritedData`, `CapturedData` |
| `foundation/data_messenger.dart` | 181 | `DataReceiverRegistry`, `DataMessenger`, `DataMessengerRoot`, `ForwardableData` + states |
| `foundation/captured_wrapper.dart` | 44 | `CapturedWrapper` (+ state): re-injects `CapturedThemes`/`CapturedData` |
| `foundation/gap.dart` | 334 | `Gap`, `SliverGap`, `_RawGap`, `RenderGap`, `RenderSliverGap` (adapted from gap 3.0.1) |
| `foundation/geometry.dart` | 230 | `AxisDirectional`, axis align/inset classes, `subtractByBorder`, `optionallyResolveBorderRadius`, 3 `optionallyResolve` extensions |
| `foundation/platform.dart` | 15 | `isMobile` |
| `foundation/constants.dart` | 5 | `kDefaultDuration`, `degToRad` |
| `foundation/keyboard.dart` | 60 | `KeyboardShortcutDisplayBuilder`, `KeyboardShortcutDisplayHandle`, `shortcutActivatorToKeySet` |
| `foundation/text_input.dart` | 45 | `ReplacementInfo`, `replaceWordAtCaret`, `TextEditingValueExtension.replaceText` |
| `foundation/style_value.dart` | 5 | `styleValue` |
| `foundation/resizer.dart` | 292 | `Resizer` public API (drag/expand/collapse/reset) |
| `foundation/resizer_engine.dart` | 253 | `ResizerEngine` internal borrow/collapse bookkeeping, `BorrowResult` |
| `foundation/resizable_item.dart` | 69 | `ResizableItem` |
| `foundation/time_of_day.dart` | 83 | `TimeOfDay` value type (Material-free) |
| `foundation/util.dart` | 217 | typedefs, `Convert`/`BiDirectionalConvert`, `CachedValue`, `CachedValueWidget`, `CallbackContextAction`, `ListExtension.swapItem`, `Joinable`, `IterableExtension`, `invokeActionOnFocusedWidget`, `unlerpDouble`, `wrapDouble` |
| `foundation/icons/lucide_icons.dart` | 6495 | generated codepoints (exempt from 400-line rule) |
| `foundation/icons/radix_icons.dart` | 1332 | generated codepoints (exempt) |
| `foundation/icons/bootstrap_icons.dart` | 6956 | generated codepoints (exempt) |
| `foundation/README.md` | 52 | layer import rule + file map |

Tests: `test/registry_next/foundation/{data,gap,geometry,keyboard,util,resizer,misc}_test.dart`
(253 + 76 + 157 + 69 + 211 + 101 + 58 = 925 LOC, 57 tests).

Largest non-icon files are `data.dart` (336) and `gap.dart` (334); both under 400.
`check_layers` file-too-long warnings for this layer come only from the three icons.

## 2. Old → new mapping (all 39 `shared_map` entries with `layer: foundation`)

| # | Old file (`lib/registry/shared/…`) | Map action | New home | Note |
|---|---|---|---|---|
| 1 | `icons/bootstrap_icons.dart` | keep | `foundation/icons/bootstrap_icons.dart` | data unchanged; `// ignore_for_file` line + one blank line removed |
| 2 | `icons/bootstrap_icons_list.dart` | delete | not copied | audit: 0 importers |
| 3 | `icons/lucide_icons.dart` | keep | `foundation/icons/lucide_icons.dart` | same as #1 |
| 4 | `icons/lucide_icons_list.dart` | delete | not copied | audit: 0 importers |
| 5 | `icons/radix_icons.dart` | keep | `foundation/icons/radix_icons.dart` | same as #1 |
| 6 | `icons/radix_icons_list.dart` | delete | not copied | audit: 0 importers |
| 7 | `utils/_impl/core/__borrow_info.dart` | keep | `resizer_engine.dart` | private class replaced by the `BorrowResult` record |
| 8 | `utils/_impl/core/axis_alignment.dart` | keep | `geometry.dart` | |
| 9 | `utils/_impl/core/axis_alignment_directional.dart` | keep | `geometry.dart` | |
| 10 | `utils/_impl/core/axis_alignment_geometry.dart` | keep | `geometry.dart` | |
| 11 | `utils/_impl/core/axis_insets.dart` | keep | `geometry.dart` | |
| 12 | `utils/_impl/core/axis_insets_directional.dart` | keep | `geometry.dart` | |
| 13 | `utils/_impl/core/axis_insets_geometry.dart` | keep | `geometry.dart` | |
| 14 | `utils/_impl/core/bi_directional_convert.dart` | split | `util.dart` (`Convert`, `BiDirectionalConvert`) | `ConvertedController` deferred (needs `ComponentController`) |
| 15 | `utils/_impl/core/cached_value_widget.dart` | split | `util.dart` | |
| 16 | `utils/_impl/core/callback_context_action.dart` | split | `util.dart` (`CallbackContextAction`, `OnContextInvokeCallback`) | `OnContextedCallback` deferred with `ContextCallbackAction` |
| 17 | `utils/_impl/core/captured_wrapper.dart` | split | `captured_wrapper.dart` | |
| 18 | `utils/_impl/core/context_callback_action.dart` | split | deferred → `primitives/form_core` | form plumbing (OWNERSHIP §6 #12) |
| 19 | `utils/_impl/core/form_pending_builder.dart` | split | deferred | `FormPendingBuilder`/`FormPendingWidgetBuilder` → `form_core`; `RepeatedAnimationWidgetBuilder` → `animation` |
| 20 | `utils/_impl/core/repeated_animation_builder.dart` | split | deferred → `primitives/animation` | OWNERSHIP §5 explicit owner |
| 21 | `utils/_impl/core/resizer.dart` | keep | `resizer.dart` + `resizer_engine.dart` | split to stay under 400 lines |
| 22 | `utils/_impl/core/separated_flex.dart` | split | deferred → `primitives` | widget-shape helper; duplicate lives in `widget_extensions.dart` (layer primitives) |
| 23 | `utils/_impl/core/time_of_day.dart` | split | `time_of_day.dart` | |
| 24 | `utils/_impl/state/__cached_value_widget_state.dart` | split | `util.dart` | |
| 25 | `utils/_impl/state/__captured_wrapper_state.dart` | split | `captured_wrapper.dart` (state) + `util.dart` (`invokeActionOnFocusedWidget`) | `swapItemInLists` pruned; 3 widget extensions deferred → primitives |
| 26 | `utils/_impl/state/__repeated_animation_builder_state.dart` | split | deferred → `primitives/animation` | |
| 27 | `utils/_impl/state/__separated_flex_state.dart` | split | deferred → `primitives` | `ColumnExtension`, `RowExtension`, `FlexExtension`, `_SeparatedFlexState` |
| 28 | `utils/_impl/utils/converted_controller.dart` | split | deferred → `primitives/form_core` | implements `ComponentController` |
| 29 | `utils/axis.dart` | keep | `geometry.dart` | `AxisDirectional` |
| 30 | `utils/border_utils.dart` | keep | `geometry.dart` | |
| 31 | `utils/constants.dart` | keep | `constants.dart` | `kDefaultDuration`, `degToRad`; `radToDeg` + `SortDirection` pruned |
| 32 | `utils/geometry_extensions.dart` | prune | `geometry.dart` | all 3 extensions kept: every member has call sites (see §5) |
| 33 | `utils/keyboard_shortcut_utils.dart` | keep | `keyboard.dart` | |
| 34 | `utils/platform_utils.dart` | keep | `platform.dart` | |
| 35 | `utils/resizable_item.dart` | keep | `resizable_item.dart` | |
| 36 | `utils/resizer.dart` | keep | `resizer.dart` | barrel became the public facade |
| 37 | `utils/style_value.dart` | keep | `style_value.dart` | |
| 38 | `utils/text_input_utils.dart` | keep | `text_input.dart` | pruned: `WordInfo`, `getWordAtCaret`, `currentWord`, `TextFieldClearIntent`, `clearActiveTextInput` |
| 39 | `utils/util.dart` | split | `util.dart` (+ `time_of_day.dart`, `data.dart`, `captured_wrapper.dart` pieces) + deferred | see §5/§6 |

Single-owner functions `wrapDouble` and `shortcutActivatorToKeySet` are defined only
here (grep over `lib/registry_next`: 1 definition each).

## 3. `data_widget` 0.0.3 — ported vs not ported

Ported (verified against `~/.pub-cache/hosted/pub.dev/data_widget-0.0.3/lib/src/data.dart`):

| Symbol | Ref count in `$REG` | Notes |
|---|---|---|
| `Data<T>` with `Data.inherit`, `Data.boundary`, `data`, `child`, `wrapWidget`, `dataType` | `.inherit` 87 / `.boundary` 15 | direct unnamed constructor was never used → not ported |
| `Data.of` / `maybeOf` | 22 / 96 | dependency marking via `dependOnInheritedWidgetOfExactType<_InheritedData<T>>` |
| `Data.find` / `maybeFind` | 1 / 16 | `findAncestorWidgetOfExactType<Data<T>>`, no listening |
| `Data.maybeFindMessenger` | 4 | holder lookup + ancestry check, identical |
| `Data.maybeFindRoot` | 1 | outermost `Data<T>` above the context |
| `Data.capture` / `CapturedData` | 6 / 10 | capture stops at `to` (exclusive), dedupes by data type |
| `DistinctData`, `AlwaysUpdateData` | 0 direct / via `updateShouldNotify` | `updateShouldNotify` semantics identical: `DistinctData.shouldNotify` when both sides are `DistinctData`, else `oldWidget.data != data` |
| `DataHolder`, `InheritedDataHolderWidget`, `InheritedDataHolder`, `InheritedRootDataHolder` | 0 direct | needed by `maybeFindMessenger` and `ForwardableData` registration |
| `DataMessenger`, `DataMessengerRoot`, `ForwardableData`, `ForwardableDataState` | `ForwardableData` 4, rest 0 direct | full messenger/registration semantics |
| `MultiDataItem`, `MultiData` | `MultiData` 1 (`form/ignore_form`) | |

Deliberately **not ported** (0 registry references): the `Model` family
(`Model`, `ModelBoundary`, `ModelNotifier`, `ModelListenable`, `ModelKey`,
`MultiModel`, `ModelProperty`, `MultiModelItem`, `_InheritedModel`,
`ModelBuilder`, `ModelWidgetBuilder`), `DataNotifier`, `DataBuilder`,
`DataWidgetBuilder`, `OptionalDataWidgetBuilder`, `Data.collect`,
`Data.visitAncestors`, `Data.findMessenger`, `Data.findRoot`, `Data.captureAll`,
the direct `Data(data)` constructor, and the `BuildContextExtension` /
`StateExtension` helpers (`data_widget.dart` does not export them).

**Deviation (documented):** the upstream registration methods
`DataHolder.register/unregister(ForwardableDataState<T>)` were split into a new
`DataReceiverRegistry<T>` (same method names) while `DataHolder<T>` keeps
`findData`. Reason: `Data`’s public `maybeFindMessenger` needs the holder types,
and the holders need `ForwardableDataState`, while `ForwardableDataState.build`
needs `Data` — one shared interface would force an import cycle between
`data.dart` and `data_messenger.dart`. Registry grep: `DataHolder`,
`register(`, `unregister(` have **0** call sites in `$REG`; the migration surface
(`Data.*`, `ForwardableData`, `MultiData`, `CapturedData`) is unchanged.
`ForwardableDataState` also uses an `is DataReceiverRegistry` check instead of an
unconditional `_messenger?.unregister(this)` — same behaviour for both supplied
holders.

## 4. `gap` 3.0.1 — ported vs not ported

Ported: `Gap(mainAxisExtent, {key, crossAxisExtent, color})`, `SliverGap(mainAxisExtent, {key, color})`
and both render objects, including `Scrollable.maybeOf(context)` fallback axis
(so `Gap` works inside `ListView`) and the intrinsic/paint behaviour.
Not ported: `MaxGap`, `Gap.expand` (0 call sites in `$REG`).
`crossAxisExtent`/`color` are unused by the registry today but kept for drop-in
parity with the package (`gap()` wrapper in old `util.dart:249` used
`crossAxisExtent`).

## 5. Members pruned (0 call sites verified by grep over `$REG`)

- `util.dart`: `BinaryOperator` (old util.dart:34), `SearchPredicate` (:43),
  `WidgetTreeChangeDetector` + `WidgetTreeChangeDetectorState` (:214-246, 4 self
  references only), `swapItemInLists` (`__captured_wrapper_state.dart:40`),
  `SafeLerp` + `SafeLerpExtension` (util.dart:71-96), `FutureOrExtension`
  (:170-201), `ListExtension` members `indexOfOrNull`, `lastIndexOfOrNull`,
  `indexWhereOrNull`, `lastIndexWhereOrNull`, `swapItemWhere`, `optGet`
  (:101-166; `swapItem` kept — used by `tabs`), `IterableExtension.buildSeparator`
  (:277-280; `joinSeparator` kept).
- `constants.dart`: `radToDeg` (:8), `SortDirection` (:12-26) — 0 call sites.
- `text_input_utils.dart`: `WordInfo` (:18), `getWordAtCaret` (:48-70),
  `TextEditingControllerExtension.currentWord` (:73-92), `TextFieldClearIntent`
  (:9-12 — the `text_field` component copy wins per OWNERSHIP row 32),
  `clearActiveTextInput` (:109-112).
- `gap.dart`: `MaxGap`, `Gap.expand`.
- Icons `*_list.dart` files (6424 + 4765 + 1021 LOC): not copied (audit: delete).

`geometry_extensions.dart` was marked `prune`; the call-site check found every
member in use, so all three extensions were kept: `.optionallyResolve(context)`
on `AlignmentGeometry` (`avatar_group`, `menu_button_state`,
`button_style_class`, `popover_overlay_widget_state` x3), on
`BorderRadiusGeometry` (`dashed_container`, `tab_pane_state` x2,
`outlined_container`), and on `EdgeInsetsGeometry`
(`popover_overlay_widget_state`). Nothing to prune.

## 6. Items deferred to primitives (Phase 2, not copied here)

| Owner (suggested) | Symbols | Old location |
|---|---|---|
| `primitives/form_core` | `ContextCallbackAction`, `OnContextedCallback` | `_impl/core/context_callback_action.dart`, `callback_context_action.dart` |
| `primitives/form_core` | `FormPendingBuilder`, `FormPendingWidgetBuilder` | `_impl/core/form_pending_builder.dart`, `context_callback_action.dart` (OWNERSHIP §6 #7/#12) |
| `primitives/form_core` | `ConvertedController` | `_impl/utils/converted_controller.dart` (implements `ComponentController`) |
| `primitives/animation` | `RepeatedAnimationBuilder`, `RepeatedAnimationWidgetBuilder`, `_RepeatedAnimationBuilderState` | `_impl/core/repeated_animation_builder.dart`, `form_pending_builder.dart`, `_impl/state/…` |
| `primitives` (layout) | `SeparatedFlex`, `_SeparatedFlexState`, `ColumnExtension`, `RowExtension`, `FlexExtension`, `join`, `SeparatedIterable`, `_SeparatedIterator`, `mutateSeparated` | `separated_flex.dart`, `__separated_flex_state.dart`, `util.dart` |
| `primitives` (widget ext) | `WidgetPaddingExtension`, `WidgetAlignmentExtension`, `WidgetSizingExtension` | `__captured_wrapper_state.dart` |

All of those names (except `join`/`SeparatedIterable`/`mutateSeparated` and the
captured-wrapper extensions) are also declared in
`shared/utils/widget_extensions.dart`, whose `layer` is already `primitives`
(action `prune`) — Phase 2 should keep exactly one copy there and import
`foundation/util.dart` for `NeverWidgetBuilder` (single-owner rule).

## 7. Behaviour-preserving refactors / notes

- `data.dart` was split into `data.dart` / `data_messenger.dart` /
  `captured_wrapper.dart`; the shared ancestor scan was extracted as
  `_isAncestorOf(receiver, context)` with the old loop body unchanged.
- `Resizer` (old 649-line class) split into `resizer.dart` (public API,
  ~292 LOC) + `resizer_engine.dart` (borrow/collapse bookkeeping, ~253 LOC);
  the private `_BorrowInfo` became the `BorrowResult` record. All method bodies
  and state mutations were copied 1:1 (delegation only).
- Icons: only the `// ignore_for_file:` line and the following blank line were
  dropped. `diff` against the old files shows no other change.
- **Preserved quirk:** `CachedValueWidget` keeps `if (T is CachedValue)` from the
  old `__cached_value_widget_state.dart:14`. In Dart a bare type variable in an
  expression position is a `Type` literal, so the check is always false and
  `CachedValue.shouldRebuild` is never consulted — behaviour therefore equals
  `widget.value != oldWidget.value`. Fixing it (`widget.value is CachedValue`)
  would change `select` rebuild behaviour and was left for a follow-up decision.

## 8. Test-failure verdicts (each compared to the old implementation)

1. **`util_test` — “joinSeparator joins a list keeping a list”** → **TEST wrong.**
   Old `$REG/shared/utils/util.dart:254` (`extension Joinable<T extends Widget> on List<T>`)
   vs `:269` (`extension IterableExtension<T> on Iterable<T>`): `List<int>` does
   not satisfy `T extends Widget`, so the call binds to `IterableExtension`,
   which returns the lazy `SkipIterable` (`map().expand().skip(1)`). Test now
   expects the iterable and adds a `List<Widget>` case that exercises `Joinable`.
2. **`keyboard_test` — “expands logical key sets”** → **TEST wrong.**
   Old `$REG/shared/utils/keyboard_shortcut_utils.dart:56-60` copies
   `activator.triggers` verbatim; `LogicalKeySet(LogicalKeyboardKey.keyK).triggers`
   yields only Key K (Meta expands to Meta Left/Right only when Meta is in the
   set). Test now asserts `[keyA, keyK]` order plus a separate Meta-expansion case.
3. **`util_test` — “honours CachedValue.shouldRebuild”** → **TEST wrong; code kept.**
   Old `$REG/shared/utils/_impl/state/__cached_value_widget_state.dart:14`
   (`if (T is CachedValue)`); reproduced with a standalone `dart run`:
   `f<T>() => T is M` with `class C with M` prints `false`, because bare type
   variables in expressions are type literals. The test now documents the actual
   contract (non-equal values rebuild, equal/identical values do not).
4. **`util_test` — “swapItem moves an item backward and inserts missing items”** →
   **TEST wrong.** Old `$REG/shared/utils/util.dart:124-141`: the missing-element
   path is `insert(targetIndex, element)` with no clamp, so target 7 on a
   length-2 list is a `RangeError`. Test now uses a valid insert and asserts the
   `RangeError`.
5. **`gap_test` — “Gap sizes along the Row main axis”** → **passes.** It appeared
   only as a progress line in the earlier failing run; it is green in isolation
   and in the full suite (the four real failures were 1–4).

## 9. Gates (raw output, all run from `flutter_shadcn_kit/`)

```
$ dart format --set-exit-if-changed lib/registry_next/foundation test/registry_next/foundation
Formatted 25 files (0 changed) in 0.10 seconds.
exit=0

$ dart analyze lib/registry_next/foundation test/registry_next/foundation
Analyzing foundation, foundation...
No issues found!
exit=0

$ flutter test test/registry_next/foundation
00:00 +57: All tests passed!

$ dart run tool/rearch/check_layers.dart --root lib/registry_next
check_layers: 24 files scanned, 0 files with syntax errors
  no-material: 0 (error)
  no-part: 0 (error)
  no-ignore-for-file: 0 (error)
  layer-direction: 0 (error)
  undeclared-dependency: 0 (error)
  file-too-long: 7 (warning)
  installable: 0 (error)
  no-impl-dir: 0 (error)

$ dart run tool/rearch/check_single_owner.dart --root lib/registry_next
check_single_owner: 24 files scanned, 134 declarations, 0 files with syntax errors
duplicate names: 0 (public 0, private 0) - identical 0, diverged 0

$ flutter analyze lib/registry
No issues found! (ran in 3.1s)
```

The 7 `file-too-long` warnings are:
- mine, expected (icon data files): `foundation/icons/bootstrap_icons.dart` (6957),
  `foundation/icons/lucide_icons.dart` (6496), `foundation/icons/radix_icons.dart` (1333);
- not mine, pre-existing P2-B theme sizes: `theme/color_tokens.dart` (588),
  `theme/typography.dart` (614), `theme/tokens.dart` (453), `theme/theme.dart` (449).

All other warnings/errors: 0. The old tree is untouched and still analyzes clean.

## RESULT

```
status: done
files_written:
- flutter_shadcn_kit/lib/registry_next/foundation/{data,data_messenger,captured_wrapper,gap,geometry,platform,constants,keyboard,text_input,style_value,resizer,resizer_engine,resizable_item,time_of_day,util}.dart
- flutter_shadcn_kit/lib/registry_next/foundation/icons/{lucide,radix,bootstrap}_icons.dart
- flutter_shadcn_kit/lib/registry_next/foundation/README.md
- flutter_shadcn_kit/test/registry_next/foundation/{data,gap,geometry,keyboard,util,resizer,misc}_test.dart
- licenses/data_widget.BSD-3-Clause.txt, licenses/gap.MIT.txt
- rearch/reports/P2A_FOUNDATION.md
commands_run:
- dart format --set-exit-if-changed … -> 0 changed, exit 0
- dart analyze lib/registry_next/foundation test/registry_next/foundation -> no issues
- flutter test test/registry_next/foundation -> 57 passed
- check_layers --root lib/registry_next -> 0 errors (7 warnings: 3 icons + 4 theme)
- check_single_owner --root lib/registry_next -> 0 duplicates
- flutter analyze lib/registry -> no issues
key_findings:
- data_widget ported without the Model/notifier surface; DataReceiverRegistry split avoids an import cycle (0 registry references to DataHolder).
- CachedValueWidget's `T is CachedValue` is always false in Dart; behaviour preserved deliberately and documented.
- root Resizer split into facade + engine; algorithm copied 1:1.
- wrapDouble / shortcutActivatorToKeySet single-owner rule honoured.
open_questions:
- Confirm the DataReceiverRegistry split is acceptable vs keeping register/unregister on DataHolder.
- Decide whether to fix the `T is CachedValue` quirk when select is migrated (would change rebuild behaviour).
```
