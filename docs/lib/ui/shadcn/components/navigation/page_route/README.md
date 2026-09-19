# Page Route (`page_route`)

Full-screen page route with the shadcn fade-and-slide transition
(`ShadcnPageRoute` / `ShadcnPage`).

---

## When to use

- Use this when:
  - you need push/pop navigation with the shadcn transition.
- Avoid when:
  - you need dialogs, sheets, or drawers instead of full pages.

---

## Install

```bash
flutter_shadcn add page_route
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/navigation/page_route/page_route.dart';
```

---

## Minimal example

```dart
Navigator.of(context).push(
  ShadcnPageRoute(builder: (context) => const SettingsPage()),
)
```

Declarative navigation:

```dart
Navigator(
  pages: [
    ShadcnPage(key: ValueKey('home'), child: const HomePage()),
    if (showSettings)
      ShadcnPage(key: ValueKey('settings'), child: const SettingsPage()),
  ],
  onDidRemovePage: (page) => ...,
)
```

---

## API

### Constructors

- `ShadcnPageRoute<T>`
  - `builder` (`WidgetBuilder`, required)
  - `maintainState` (`bool`, default `true`)
  - `fullscreenDialog` (`bool`, default `false`)
  - `transitionDuration` (`Duration`, default `kDefaultPageTransitionDuration`)
  - `barrierLabel` (`String?`)
- `ShadcnPage<T>` — `Page` equivalent for declarative navigation.
- `ShadcnPageTransition` — fade + short vertical slide.
- `kDefaultPageTransitionDuration` — 300ms.

---

## Accessibility

- Provide a `barrierLabel` when the route is used as a dialog.

---

## Do / Don't

- Do use `ShadcnPage` for declarative navigation (Router, go_router).
- Don't mix with MaterialPageRoute when a consistent transition matters.

---

## Related

- `pagination`
