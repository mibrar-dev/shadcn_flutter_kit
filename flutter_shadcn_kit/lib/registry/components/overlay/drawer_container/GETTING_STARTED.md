# Getting Started

`drawer_container` is a registry component in category `overlay`.

Upstream-parity drawer/sheet chrome (`AxisSize` algebra, `DrawerRawContainer`, `SheetRawContainer`, `DrawerContainerData`, `DrawerContainer`, `SheetContainer`) for pinned sheets and drawer overlays.

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `drawer_container.dart`: Widget/composite source file in this folder.
- `drawer_container.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `_impl/`: Private implementation details that support `drawer_container`.

## `_impl` Guide

### `core/`

- `axis_size.dart`: `AxisSize` algebra (`Fixed`, `Fraction`, `Additive`, `Subtracted`, `Multiplied`, `Divided`) ported verbatim from upstream.
- `drawer_container.dart`: `DrawerRawContainer`, `SheetRawContainer`, `DrawerContainerData`, `DrawerContainer`, `SheetContainer` with upstream-identical constructors.
