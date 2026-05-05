# Refresh Trigger (`refresh_trigger`)

Pull-to-refresh wrapper with customizable indicator, extents, and completion animations.

---

## When to use

- Use this when:
  - you need a pull-to-refresh interaction on scrollables.
  - you want custom indicator visuals.
- Avoid when:
  - you already use platform-specific refresh controls.

---

## Install

```bash
flutter_shadcn add refresh_trigger
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/refresh_trigger/refresh_trigger.dart';
```

---

## Minimal example

```dart
RefreshTrigger(
  onRefresh: () async {
    await fetchLatest();
  },
  child: ListView(
    children: const [Text('Item')],
  ),
)
```

---

## Common patterns

### Pattern: Custom indicator

```dart
RefreshTrigger(
  indicatorBuilder: (context, stage) => DefaultRefreshIndicator(stage: stage),
  onRefresh: () async {},
  child: ListView(children: const [Text('Item')]),
)
```

---

## API

### Types

- `RefreshTrigger`
- `RefreshTriggerStage`
- `RefreshIndicatorBuilder`
- `RefreshTriggerTheme`

---

## Theming

- `RefreshTriggerTheme` controls min/max extents, curves, and completion duration.

---

## Accessibility

- Ensure the refresh action also has a non-gesture alternative (button/shortcut).

---

## Do / Don’t

**Do**
- ✅ Keep `minExtent` reachable without excessive pulling.

**Don’t**
- ❌ Trigger long-running refresh operations without feedback.

---

## Related components

- `scrollview`
- `spinner`

---

## Registry rules

- One public class per file
- Helpers under `_impl/`
