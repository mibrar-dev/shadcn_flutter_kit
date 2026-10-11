# P4-PRIM-B — Phase 4 missing primitives (drag_sort, file_value, toast_queue)

Batch: `P4-PRIM-5`, `P4-PRIM-6`, `P4-PRIM-7` (P0, run before B08/B09/B12/B18/B21/B22).
Nothing outside the three primitives was touched except
`lib/registry_next/primitives/README.md` (file list) and this report.
Round 2 (QA F1): the two over-long files were split into `file_value/` and
`toast_queue/` folders, `form_core/` style. No behaviour change; every test from
round 1 still exists and passes (93 → 94 with the one added policy test).

## Summary

| Primitive | Old source(s) | Old LOC | New LOC | Tests |
|---|---|---|---|---|
| `primitives/drag_sort.dart` | `layout/sortable/_impl/core/sortable_drop_location.dart`, `_impl/state/sortable_state_part1.dart` (bounds maths), `form/sortable/_impl/core/sortable_changes.dart` | 71 + ~120 + 106 | 356 (1 file) | 25 |
| `primitives/file_value/` (`file_value.dart`, `file_validation.dart`, `file_format.dart`) | `form/file_picker/_impl/utils/file_like.dart`, `file_validation.dart`, `file_upload_models.dart`, `file_upload_options.dart`, `file_upload_formatters.dart` | 70 + 96 + 97 + ~230 + 35 | 274 + 104 + 99 | 14 + 11 + 9 |
| `primitives/toast_queue/` (`toast_placement.dart`, `toast_entry.dart`, `toast_queue.dart`) | `overlay/toast/_impl/utils/toast_controller.dart`, `overlay/gooey_toast/_impl/core/gooey_toast_controller.dart` (record/timer parts) | 286 + ~400 of 1361 | 116 + 169 + 252 | 7 + 28 |

Longest file is now 356 lines (`drag_sort.dart`, unchanged); the folders peak at
274 (`file_value.dart`) and 252 (`toast_queue.dart`).

`meta.json` for the consumers is unaffected: `check_layers` resolves a folder
entry by prefix (`depEntryCovers`: `primitives/file_value/…`), so B08/B09/B18/B22
declare `"primitives": ["file_value"]` / `["toast_queue"]` exactly as before and
import the file they need.

Split rationale (by responsibility, matching `form_core/` / `input_features/`):

| File | Responsibility |
|---|---|
| `file_value/file_value.dart` | model: `FileValue`, `FileStatus`, `FileItem`, `FileErrorCode`, `FileError`, `FileValidationResult`, `FileConstraints` |
| `file_value/file_validation.dart` | the checks: `validateFiles` and its per-file helper |
| `file_value/file_format.dart` | presentation data: loading-mode enums, `FileStatusLabels`, `formatFileSize` |
| `toast_queue/toast_placement.dart` | anchor metadata: `ToastSwipeDirection`, `ToastPlacement`, `ToastSlot` |
| `toast_queue/toast_entry.dart` | one toast's countdown: `ToastEntry` |
| `toast_queue/toast_queue.dart` | the stack: `ToastQueue` (ids, slots, order, dismissal, **the auto-dismiss policy**) |

The layer-2 files are bigger than their old sources because they carry the
*generic* contract for two consumers each (sortable + tabs, file_picker +
dropzone, toast + gooey_toast) where the old code duplicated it per component,
and because the bug-fix rationale lives in doc comments and tests.
Nothing that stayed in the old components was copied here: the widgets,
`OverlayEntry` insertion, `Matrix4` transform plumbing, `Clickable` wiring and
the upload controller all stay with their owner.

### Old → new file mapping

| Old | New | Kept / dropped |
|---|---|---|
| `layout/sortable/_impl/core/sortable_drop_location.dart` (`_SortableDropLocation`, `_getPosition`) | `drag_sort.dart` (`DragDropEdge`, `resolveDragDropEdge`) | kept, bug-fixed; old names private and sortable-specific, new names generic |
| `layout/sortable/_impl/state/sortable_state_part1.dart` (`_handleDrag` clamp maths, `_DraggingSession`) | `drag_sort.dart` (`DragBounds`) | maths kept as a value type; the session (GlobalKey, ValueNotifier, ghost widget) stays in the component |
| `form/sortable/_impl/core/sortable_changes.dart` (`ListChanges`, `ListChange`, `ListSwapChange`, `ListRemoveChange`, `ListInsertChange`) | `drag_sort.dart` (`ReorderChanges`, `ReorderChange` + sealed subclasses) | kept, renamed, bounds-checked |
| `form/sortable/_impl/core/sortable_list_delegate.dart`, `raw_sortable_list.dart`, `raw_sortable_stack.dart` | — | not migrated: `RawSortableList.build` threw `UnimplementedError` and the delegates/stack had zero non-preview readers (verified by grep across `lib/` + `test/`). Nothing in the new architecture needs them; `raw_sortable_stack.dart` is a self-contained widget stack the `sortable` component may re-derive if it wants one. |
| `form/file_picker/_impl/utils/file_like.dart` (`FileLike`) | `file_value/file_value.dart` (`FileValue`) | kept, bug-fixed, `source` stays `Object?` |
| `form/file_picker/_impl/utils/file_upload_models.dart` | `file_value/file_value.dart` (`FileStatus`, `FileItem`, `FileErrorCode`, `FileError`, `FileValidationResult`) | kept; `FileUploadPickRequest` / `UploadFn` / `FileUploadPickFiles` typedefs left to the `file_picker` component (they describe a picker, not a value) |
| `form/file_picker/_impl/utils/file_validation.dart` (`validateFiles`) | `file_value/file_validation.dart` (`validateFiles`) | kept, messages moved out to an `onError` callback, overflow bug fixed |
| `form/file_picker/_impl/core/file_upload_options.dart` (`FileUploadLoadingMode`, `FileUploadItemLoadingMode`, `FileUploadStatusLabels`, `FileUploadHelpfulInfoData`, `FileUploadItemLoadingOptions`) | `file_value/file_value.dart` (`FileConstraints`) + `file_value/file_format.dart` (`FileSurfaceLoadingMode`, `FileItemLoadingMode`, `FileStatusLabels`) | loading enums + labels kept (shared by the file components); `HelpfulInfoData` collapsed into `FileConstraints`; the per-variant `FileUpload*Options` classes stay in the component — they hold widget builders and per-variant labels |
| `form/file_picker/_impl/utils/file_upload_formatters.dart` (`_formatFileSize`) | `file_value/file_format.dart` (`formatFileSize`) | kept, formatting bug fixed |
| `form/dropzone/dropzone.dart` (`DropzoneState`) | `file_value/file_value.dart` (`FileStatus`) | the dropzone state enum is the same value set as the file-picker's `FileUploadState` (both `idle, dragging, uploading, success, error, disabled`); one `FileStatus` replaces both plus `FileUploadItemStatus`, and the old `_mapDropzoneState` switch disappears |
| `overlay/toast/toast.dart` (`ToastSwipeDirection`, `ToastLocation`), `overlay/toast/_impl/utils/toast_controller.dart` (`_autoDismissDirections`, `_groupKey`) | `toast_queue/toast_placement.dart` (`ToastSwipeDirection`, `ToastPlacement`, `ToastSlot`) | directions and grouping kept, now derived from the placement instead of raw edge insets |
| `overlay/toast/_impl/utils/toast_controller.dart` (`ToastController`, `_ToastItem`) | `toast_queue/toast_queue.dart` (`ToastQueue`) + `toast_queue/toast_entry.dart` (`ToastEntry`) | queue/ids/slots kept; `OverlayEntry` creation and the top-level `showToast` global stay with the component |
| `overlay/gooey_toast/_impl/core/gooey_toast_controller.dart` (`_GooeyToastRecord` bookkeeping, `_scheduleAutoDismiss`, `_pauseAutoDismiss`, `_resumeAutoDismiss`, `_regionRecords`) | `toast_queue/toast_entry.dart` (countdown) and `toast_queue/toast_queue.dart` (`pauseSlot`/`resumeSlot`, `entriesIn`) | timer and ordering logic kept once; the goo renderer, transition choreography and `GooeyToastDetails` stay with the component |

## Old bugs fixed (each has a regression test)

### drag_sort.dart

1. **`_getPosition` axis bias.** A target accepting `top` + `bottom` returned
   `top` for the entire upper half, even when the pointer sat essentially on the
   left edge of a wide box, because the axes were tested in a fixed order.
   `resolveDragDropEdge` scores every accepted edge by normalised distance and
   picks the closest (ties: `top`, `left`, `right`, `bottom`). Single-axis cases
   are unchanged. Test: *the nearest accepted edge wins on both axes*.
2. **`_handleDrag` inverted clamp.** When the dragged item was larger than the
   layer along an axis, `min(low, high)`/`max(low, high)` turned the inverted
   range into a drag that moved the ghost the *opposite* way. `DragBounds` pins
   that axis to zero (`maxTranslationOn` returns 0 when the item does not fit)
   and the other axis keeps working. Test: *an item larger than the layer pins
   the axis instead of inverting*.
3. **`ListChange` range crashes.** `ListSwapChange.apply` and
   `ListRemoveChange.apply` indexed without a bounds check, so a stale index from
   a running animation threw a `RangeError`. Every change is bounds checked now
   and reports the skip. `ReorderInsert` clamps instead of throwing.
   Test: *out-of-range swap, remove and insert are skipped, not thrown*.
4. **Unstable drop index.** There was no helper for "where does the item land";
   `reorderIndex` addresses the list *without* the moved item and clamps.

### file_value.dart

5. **`FileItem.copyWith` dropped progress.** The old `FileUploadItem.copyWith`
   wrote `progress: progress` unconditionally, so any call without an explicit
   progress cleared it — a progress tick followed by a status change silently
   reset the bar to 0. `copyWith` keeps the value and `resetProgress: true`
   expresses the clear. Test: *copyWith keeps progress when only the status
   changes*.
6. **`FileLike.resolvedExtension` read a leading dot as an extension.**
   `'.gitignore'.split('.')` yielded `['gitignore']`, so the file claimed to be a
   `gitignore` image-free "extension" and failed every extension allow-list for
   the wrong reason. A leading or trailing dot now yields `''`.
   Tests: *a leading dot is not an extension*, *a file with no extension fails an
   extension allow-list*.
7. **Validation messages were hard-coded English.** The old `validateFiles`
   built `'Too many files selected.'` inline, so every locale got English.
   `onError` is now a required parameter and the caller supplies the wording
   from `ShadcnLocalizations`.
8. **`validateFiles` abandoned the rest of a drop.** On the first file over the
   count limit it `break`ed out of the loop, so the remaining files produced no
   error at all. The overflow is now reported once per batch and every later file
   is still checked for size and type. Tests: *the overflow is reported once and
   the rest is still checked*, *a file can trip several checks at once*.
9. **`_formatFileSize` rounded up into the next unit and lost precision.** One
   significant digit below ten and none above meant `9.99 MB` printed as
   `10.0 MB`, and `1023.99 KB` could print as `1024.0 KB` — a value larger than
   the input's true value. It now truncates at the requested precision.
   Tests: *never rounds up into the next unit*, *honours the decimals argument*.

### toast_queue.dart

10. **Global mutable toast state.** `overlay/toast` held a file-level
    `_defaultToastController` and a file-level `int _toastSequence`; the gooey
    controller had its own `_nonce`. Both are gone: every `ToastQueue` owns its
    counter, so two queues never collide and there is no process-wide state
    (P2-E1 already rejected the same pattern in `OverlayManager`).
    Test: *nextId is unique per queue and never global*.
11. **A centred toast could not be swiped away.** `_autoDismissDirections`
    derived directions from raw edge insets; a `topCenter` toast has both `left`
    and `right` set, so it received *neither* a vertical nor a horizontal
    direction (`if (top != null)` produced `up`, but the centred path passed
    `left`/`right` and the vertical inset was null). Directions now come from the
    placement. Test: *a centred toast still swipes away vertically*.
12. **A refreshed toast kept the old timer.** `ToastController.show` with an
    existing id bumped `refreshSignal` and left the running `Timer` alone, so
    "Uploading…" refreshed at 2 s of a 3 s duration still vanished at 3 s.
    `ToastEntry.update` restarts the countdown; setting `autoDismiss: false`
    cancels it outright. Tests: *replaces the payload and restarts the
    countdown*, *autoDismiss false stops the countdown*.
13. **Re-showing an id left a stale slot claim.** Moving a live toast to another
    slot left `_slotActive` pointing at the old slot, so the old slot looked
    occupied forever and `singlePerSlot` could not reuse it. Test: *reusing an id
    moves the toast to the new slot*.
14. **A closed `Duration` could not be represented.** `pausing keeps the toast and
    preserves the remaining time` covers the pause/resume budget (ported from
    `_pauseAutoDismiss`/`_resumeAutoDismiss`) with an injected clock so the test
    is deterministic.

## Deviations

- **`FileStatus` replaces three old enums** (`DropzoneState`,
  `FileUploadState`, `FileUploadItemStatus`). The three had the same value set
  apart from `dragging`, and the old `_mapDropzoneState` switch existed only to
  translate between them. One enum means a dropzone and a file row cannot drift.
  B08 (`dropzone`) and B22 (`file_picker`) must both use it.
- **Old names dropped (clean break).** `FileLike` → `FileValue`,
  `FileUploadItem` → `FileItem`, `ListChange`/`ListSwapChange` →
  `ReorderChange`/`ReorderSwap`, `ToastLocation` → `ToastPlacement`,
  `FileUploadLoadingMode` → `FileSurfaceLoadingMode`. No aliases, no
  deprecated members, per the plan's clean-break decision.
- **No `ListChange` extensions.** The old base class was documented as
  extendable; it is `sealed` here so the switch surface stays finite.
- **The queue has no widgets.** `ToastQueue` decides what is in the stack and when
  a toast leaves; overlay entry creation, positioning, theming and animation stay
  with the `toast` / `gooey_toast` components, which reach the overlay through
  `OverlayManager` as the batch notes require.
- **Localizations keys were not added.** `validateFiles` takes its wording from
  the caller, and `FileStatusLabels` takes labels as constructor values, so this
  layer adds no new `ShadcnLocalizations` keys. The keys the file components
  need for their own labels (dropzone state copy, status badges, the shadcn
  "Upload a file"/"Drag and drop files here" strings) belong to B08/B22, which own
  the widgets that render them.
- **`ToastEntry.onExpired` is public** so the queue can wire it; it is a
  `VoidCallback` with a no-op default, never a nullable timer callback.
- **Folder primitives (QA F1).** `file_value` and `toast_queue` are folders,
  `form_core/` style; `drag_sort` stays a single file. Consumers import the file
  they need, e.g. `import '../../primitives/file_value/file_value.dart';`, and
  declare the folder name in `meta.json` (`"primitives": ["file_value"]`), which
  `check_layers` resolves by prefix.
- **Auto-dismiss policy is now written down** (QA decision c). It lives in the
  `ToastQueue` class doc as *the* rule both `toast` (B09) and `gooey_toast`
  (B18) must follow: a countdown runs on its own and is never touched by a
  neighbour; interacting with one toast pauses only that toast via
  `setInteracting`; a slot holding more than one toast pauses its non-primary
  toasts via `pauseSlot(selector: (e) => !isPrimary(e))` and resumes them via
  `resumeSlot` when it drops back to one. The old `pauseAutoDismissWhenMultiple`
  existed only inside the gooey controller, which is why the two components
  disagreed. Pinned by the test *a stacked slot holds its non-primary toasts*.
- **`FileItem` stays the primitive's name** (QA decision b); B22 names its row
  widget `FileUploadRow`, so there is no clash.
- **`color_input` is a stale consumer entry** (QA decision a): the old
  `color_input` only uses a hex field and a controller, no file values. Nothing
  in this primitive mentions it and B23 needs no action.

## Not done / out of scope

- `form/sortable`'s `RawSortableStack` / `RawSortableParentData` /
  `RawSortableItemPositioned` render objects were **not** migrated. They have one
  caller (the old `form/sortable` preview) and that directory is being merged
  into the `sortable` component (B12). If B12 wants a clamped drag stack it can
  re-derive it; moving a render object into layer 2 for a single component would
  break the single-owner placement rule.
- Platform file picking, the upload controller (`FileUploadController`) and its
  concurrency queue stay with B22 — they are behaviour, not value types.

## Gates

```
cd $KIT && rearch/qa_gate.sh lib/registry_next
format:  Formatted 196 files (0 changed) in 0.52 seconds.
analyze: No issues found! | tests: No issues found!
test:    +461: All tests passed!
rearch:  +38: All tests passed!
layers:    file-too-long: 8 (warning)
owner:   duplicate names: 0 (public 0, private 0) - identical 0, diverged 0
theme:   check_user_theme: 0 finding(s)
banned:
stray:
```

`file-too-long` is back to the pre-batch baseline of 8 warnings, and none of them
is a file from this batch:

```
foundation/icons/bootstrap_icons.dart   primitives/localizations/localizations.dart
foundation/icons/lucide_icons.dart     theme/color_tokens.dart
foundation/icons/radix_icons.dart      theme/theme.dart
                                         theme/tokens.dart
                                         theme/typography.dart
```

Per-file verification (only this batch's files):

```
$ dart analyze lib/registry_next/primitives/drag_sort.dart \
    lib/registry_next/primitives/file_value \
    lib/registry_next/primitives/toast_queue \
    test/registry_next/primitives/drag_sort_test.dart \
    test/registry_next/primitives/file_value_test.dart \
    test/registry_next/primitives/file_validation_test.dart \
    test/registry_next/primitives/file_format_test.dart \
    test/registry_next/primitives/toast_placement_test.dart \
    test/registry_next/primitives/toast_queue_test.dart
No issues found!

$ flutter test test/registry_next/primitives/drag_sort_test.dart        -> 25/25
$ flutter test test/registry_next/primitives/file_value_test.dart      -> 14/14
$ flutter test test/registry_next/primitives/file_validation_test.dart -> 11/11
$ flutter test test/registry_next/primitives/file_format_test.dart     ->  9/9
$ flutter test test/registry_next/primitives/toast_placement_test.dart ->  7/7
$ flutter test test/registry_next/primitives/toast_queue_test.dart     -> 28/28
                                                                 total 94/94
```

Round 1 was 93 tests (25 + 34 + 34); round 2 keeps all of them and adds the one
that pins the auto-dismiss policy.

## Open questions

None outstanding. Resolved in round 2:

1. ~~Should `file_value.dart` be split?~~ — done: `file_value/` and `toast_queue/`
   folders, `form_core/` style (QA F1).
2. ~~`FileItem` naming.~~ — `FileItem` stays here; B22 names its row widget
   `FileUploadRow` (QA decision b).
3. ~~Does `color_input` need this primitive?~~ — no, stale consumer entry
   (QA decision a); nothing to do in B23.
4. ~~Auto-dismiss policy for a stacked slot.~~ — written into the `ToastQueue`
   doc comment as the house rule for B09 and B18 (QA decision c) and pinned by
   the test *a stacked slot holds its non-primary toasts*.