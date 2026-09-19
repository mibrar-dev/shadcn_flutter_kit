# Getting Started

`overlay_configuration` is a registry component in category `overlay`.

Upstream-parity overlay configurations plus `OverlayController`, adapted to the registry `PopoverController` architecture.

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `overlay_configuration.dart`: Widget/composite source file in this folder.
- `overlay_configuration.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `_impl/`: Private implementation details that support `overlay_configuration`.

## `_impl` Guide

### `core/`

- `overlay_configuration.dart`: `OverlayConfiguration`, `showOverlay`, `DelegatedOverlayCompleter`, and all six configuration classes.
- `overlay_controller.dart`: `OverlayController` adapted to `PopoverController`.
