# Group

A manual layout surface that places each child at an explicit offset and size.
It is a `Stack` driven by absolute coordinates: useful for fine-tuned layouts,
overlays and any composition that standard `Row` / `Column` / `Stack` sizing
cannot express. Widgets-only; no theme and no other component dependency.

## When to use

- You need manual, absolute positioning of children.
- You want a child pinned to a specific edge (`top`, `left`, `right`, `bottom`).

Avoid it for ordinary responsive layout — prefer `Row`, `Column` or `Stack`.

## Snippets

```dart
SizedBox(
  width: 260,
  height: 160,
  child: Group(
    children: <Widget>[
      GroupPositioned(top: 12, left: 12, child: Text('top-left')),
      GroupPositioned(top: 12, right: 12, child: Text('top-right')),
      GroupPositioned.fromRect(
        rect: const Rect.fromLTWH(60, 60, 140, 48),
        child: Text('boxed'),
      ),
      GroupPositioned.fill(child: Text('fills the group')),
    ],
  ),
);
```

## `Group` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `children` | `List<Widget>` | `const []` | each child should be a `GroupPositioned` |

## `GroupPositioned` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `top` / `left` / `right` / `bottom` | `double?` | null | edge distances |
| `width` / `height` | `double?` | null | fixed extents |
| `child` | `Widget` | required | the positioned content |

- `GroupPositioned.fill(...)` pins every edge to `0`.
- `GroupPositioned.fromRect(rect: ...)` places the child at `rect`.

Giving both `left` and `right` (or `top` and `bottom`) makes the child fill the
span; giving only one pins that edge. When the group is unbounded on an axis the
child takes its natural size there.

## Differences from the old `layout/group`

- The old directory shipped only `group_widget.dart`, so `flutter_shadcn add
  group` could not find an entry file. This file is the `group.dart` entry.
- `GroupWidget` is renamed `Group` (clean break; no alias).
- The `ignore_for_file`, `part` and `_impl/` structure is gone; the render
  object and parent data are plain declarations.
- **Bug fixed:** `RenderGroup.performLayout` used `constraints.biggest` for its
  own size, which is infinite under unbounded constraints and crashed. It now
  sizes from the children's extents and constrains the result. Children pinned
  to `bottom` / `right` only are offset against that resolved size instead of
  the (possibly infinite) incoming constraints.
