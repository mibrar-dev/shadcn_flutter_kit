# Pinned Sheet

In-tree sheet that slides in from an edge, drags, and snaps between snap
stages. Publish chrome by wrapping the child in a `DrawerContainer`; the
sheet publishes a `DrawerContainerData` ancestor for it.

## When to use

- Bottom sheets pinned in the layout (maps, players, editors).
- Panels that rest at peek/half/expanded detents.

For modal edge panels pushed on the navigator use `drawer`.

## Snippets

```dart
final controller = SheetController();

PinnedSheet(
  controller: controller,
  stages: const [
    SheetStage.closed(),
    SheetStage.fraction(0.4),
    SheetStage.expanded(),
  ],
  child: const DrawerContainer(child: Text('Sheet content')),
);

// Later:
controller.animateTo(const SheetStage.fraction(0.4));
if (controller.stage == SheetStage.expanded() - SheetStage.fixed(100)) { ... }
```

## API

- `PinnedSheet(position, child, controller, stages, initialStage, backdrop,
  backdropTransform, draggable, showDragHandle, expands, contentExpands,
  modal, barrierDismissible, barrierColor, borderRadius, dragHandleSize,
  constraints, duration)`.
- `SheetController` — `offset`, `fraction`, `isOpen`, `stage` (live,
  comparable against derived stages), `animateTo`, `jumpTo`, `open`,
  `close`, `stage` setter.
- `SheetStage.closed/expanded/fixed/fraction/peekDragHandle` + `+ - * /`
  arithmetic; `SheetStage.live` builds a live stage from readers.
- `barrierColor` is a `ThemedColor?`; null draws no barrier. Its alpha
  multiplies with openness. No theme file: the sheet paints no surface of
  its own (chrome comes from `DrawerContainer`).

## Differences from old pinned_sheet

- `surfaceOpacity`/`surfaceBlur` glass dropped (future backdrop primitive).
- `contentIntrinsic` dropped (stored, never read). `PinnedSheetBuilder`
  dropped (zero callers). `draggableBackdrop` dropped (zero consumers).
- `barrierColor` is `ThemedColor?` (was `Color?`); barrier alpha multiplies
  the token alpha instead of replacing it.
- `borderRadius` narrows to `BorderRadius?` (what `DrawerContainerData`
  takes). The published data drops `size`/`stackIndex` (gone upstream) and
  sets `isSheet: true`.
- Peek stages use the handle width on horizontal sheets (old always height).
- Stage model lives in `primitives/sheet_stage.dart` (position math, like
  `drag_sort`); the component keeps controller + widget + state.
