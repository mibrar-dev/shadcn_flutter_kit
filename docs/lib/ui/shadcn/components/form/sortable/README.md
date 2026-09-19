# Sortable (Form) (`form/sortable`)

Upstream-parity port of the form `RawSortable` primitives (`RawSortableList`, `RawSortableStack`, `SortableListDelegate`, list-change model). Distinct from the `layout/sortable` drag-and-drop system.

---

## When to use

- Use this when:
  - you need the upstream form sortable delegate/change model.
  - you are porting upstream `RawSortable` call sites.
- Avoid when:
  - you need rendered drag-and-drop sorting (use `layout/sortable`).

---

## Install

```bash
flutter_shadcn add sortable
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/form/sortable/sortable.dart';
```

---

## Minimal example

```dart
RawSortableList<String>(
  delegate: SortableChildListDelegate(
    items,
    (context, index, item) => Text(item),
  ),
  builder: (context, index, item) => Text(item),
  onChanged: (changes) {},
)
```

---

## API

### Constructor

- `RawSortableList<T>` — low-level sortable list (WIP stub, like upstream).
- `RawSortableStack`, `RawSortableItemPositioned`, `RawSortableParentData`, `RenderRawSortableStack` — stacking primitives.
- `SortableListDelegate<T>`, `SortableChildListDelegate<T>`, `SortableChildBuilderDelegate<T>` — item sources.
- `ListChanges<T>`, `ListChange<T>`, `ListSwapChange<T>`, `ListRemoveChange<T>`, `ListInsertChange<T>` — change model.
- `SortableItemBuilder<T>`, `SortableWidgetBuilder<T>` — builders.

---

## Theming

- No theme tokens; primitives render with caller-provided widgets.

---

## Accessibility

- Provide non-drag reorder alternatives when required.

---

## Do / Don’t

**Do**
- ✅ Use the delegate/change model with the layout/sortable renderer.

**Don’t**
- ❌ Render RawSortableList directly (it throws, like upstream).

---

## Related components

- `sortable` (layout)

---

## Registry rules

- One public class per file
- Helpers under `_impl/`
