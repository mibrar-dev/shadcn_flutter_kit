# Getting Started

`pinned_sheet` is a registry component in category `display`.

Upstream-parity controller-driven sheet that snaps between stages with drag gestures and backdrop transforms.

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `pinned_sheet.dart`: Widget/composite source file in this folder.
- `pinned_sheet.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `_impl/`: Private implementation details that support `pinned_sheet`.

## `_impl` Guide

### `core/`

- `pinned_sheet_types.dart`: `PinnedSheetBuilder`, `SheetStageResolution`, `SheetStage` and all stage subtypes (faithful upstream port).
- `sheet_controller.dart`: `SheetController` with upstream-identical API.
- `pinned_sheet.dart`: `PinnedSheet` widget with upstream-identical constructor.

### `state/`

- `pinned_sheet_state.dart`: animation-driven offset state with drag-to-snap (simplified upstream render-object machinery).
