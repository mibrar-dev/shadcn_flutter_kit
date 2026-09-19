# Getting Started

`backdrop_transform` is a registry component in category `overlay`.

Upstream-parity backdrop transforms (`BackdropTransform`, `NoBackdropTransform`, `ScaleBackdropTransform`) for sheet/drawer zoom-out effects.

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `backdrop_transform.dart`: Widget/composite source file in this folder.
- `backdrop_transform.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `_impl/`: Private implementation details that support `backdrop_transform`.

## `_impl` Guide

### `core/`

- `backdrop_transform.dart`: `BackdropTransform`, `NoBackdropTransform`, `ScaleBackdropTransform` ported from upstream.
