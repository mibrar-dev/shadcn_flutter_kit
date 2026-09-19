# Fade Scroll (`fade_scroll`)

Edge fade overlays for scrollable content.

---

## When to use

- Use this when:
  - you need a visual cue that scrollable content continues.
  - you want gradient fades at the start/end of a scroll view.
- Avoid when:
  - the content always fits without scrolling.

---

## Install

```bash
flutter_shadcn add fade_scroll
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/display/fade_scroll/fade_scroll.dart';
```

---

## Minimal example

```dart
FadeScroll(
  controller: controller,
  child: ListView(
    controller: controller,
    children: const [Text('Item 1'), Text('Item 2')],
  ),
)
```

---

## Common patterns

### Pattern: Horizontal fade

```dart
FadeScroll(
  controller: controller,
  startOffset: 24,
  endOffset: 24,
  child: SingleChildScrollView(
    controller: controller,
    scrollDirection: Axis.horizontal,
    child: Row(children: items),
  ),
)
```

---

## API

### Constructor

- `FadeScroll`
  - `child` (`Widget`, required)
  - `controller` (`ScrollController`, required)
  - `startOffset` / `endOffset` (`double?`)
  - `startCrossOffset` / `endCrossOffset` (`double`)
  - `gradient` (`List<Color>?`)
- `FadeScrollTheme` — `startOffset`, `endOffset`, `gradient`.

### Callbacks

- None — the widget listens to `controller` directly.

---

## Theming

- `FadeScrollTheme` provides default offsets and gradient colors.

---

## Accessibility

- Keep fades subtle so edge content stays readable.

---

## Do / Don’t

**Do**
- ✅ Share one `ScrollController` between `FadeScroll` and its child.

**Don’t**
- ❌ Use separate controllers for the fade wrapper and the scroll view.

---

## Related components

- `carousel`
- `scrollable`

---

## Registry rules

- One public class per file
- Helpers under `_impl/`
