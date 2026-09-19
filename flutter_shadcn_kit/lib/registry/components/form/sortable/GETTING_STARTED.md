# Getting Started

`sortable` is a registry component in category `form`.

Upstream-parity port of the form `RawSortable` primitives (`RawSortableList`, `RawSortableStack`, `SortableListDelegate`, list-change model). Distinct from the `layout/sortable` drag-and-drop system.

## Folder Map

- `README.md`: Primary component docs and usage guidance for contributors/users.
- `meta.json`: Registry metadata used for manifests, dependencies, and tooling.
- `preview.dart`: Preview/demo entry used by gallery/docs environments.
- `sortable.dart`: Widget/composite source file in this folder.
- `sortable.meta.json`: Generated readme/meta companion used by docs/index tooling.
- `_impl/`: Private implementation details that support `sortable`.

## `_impl` Guide

### `core/`
Core rendering/building blocks that implement the main behavior.

- `raw_sortable_list.dart`: Core implementation part of the widget/composite.
- `raw_sortable_stack.dart`: Core implementation part of the widget/composite.
- `sortable_builders.dart`: Core implementation part of the widget/composite.
- `sortable_changes.dart`: Core implementation part of the widget/composite.
- `sortable_list_delegate.dart`: Core implementation part of the widget/composite.

### `extensions/`
Extension methods used by this widget.

- (empty)

### `state/`
State objects, controllers, and mutable interaction logic.

- (empty)

### `styles/`
Style classes and style-resolution helpers.

- (empty)

### `themes/`
Theme data and ThemeExtension integration.

- (empty)

### `utils/`
Small reusable helper functions/models.

- (empty)

### `variants/`
Alternative visual or behavior variants.

- (empty)

## Suggested Reading Order

1. `README.md`
2. `meta.json`
3. `sortable.dart`
4. `preview.dart`
5. `_impl/core/`
6. `_impl/state/`
7. `_impl/styles/`
8. `_impl/themes/`
9. `_impl/variants/`
10. `_impl/utils/`
11. `_impl/extensions/`
