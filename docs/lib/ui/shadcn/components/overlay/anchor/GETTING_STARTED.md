# Getting Started

`anchor` is a registry component in category `overlay`.

Upstream-parity anchor primitives (`Anchor`, `ContextAnchor`, `LinkedAnchor`) and the overlay anchor registry/scope used for position-tracked overlays.

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `anchor.dart`: Widget/composite source file in this folder.
- `anchor.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `_impl/`: Private implementation details that support `anchor`.

## `_impl` Guide

### `core/`

- `anchor_api.dart`: `Anchor`, `AnchorSubscription`, `anchorTransformRelativeTo`, `ContextAnchor`, `LinkedAnchor` and their subscriptions.
- `overlay_anchor.dart`: `OverlayAnchorEntry`, `OverlayAnchorRegistry`, `OverlayAnchorScope`, `OverlayAnchor`, `RenderOverlayAnchor`.
