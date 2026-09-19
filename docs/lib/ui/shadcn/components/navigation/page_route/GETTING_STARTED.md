# Getting Started

`page_route` is a registry component in category `navigation`.

Full-screen page route with the shadcn fade-and-slide transition
(`ShadcnPageRoute` / `ShadcnPage`).

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `page_route.dart`: Widget/composite source file in this folder.
- `page_route.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `_impl/`: Private implementation details that support `page_route`.

## `_impl` Guide

### `core/`
Core rendering/building blocks that implement the main behavior.

## Usage

```dart
Navigator.of(context).push(
  ShadcnPageRoute(builder: (context) => const SettingsPage()),
)
```
