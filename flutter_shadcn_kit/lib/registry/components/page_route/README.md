# page_route

The widgets-only replacement for `MaterialPageRoute` and `MaterialPage`. It
depends on nothing outside `package:flutter/widgets.dart`.

## Getting started

```dart
Navigator.of(context).push(
  ShadcnPageRoute(builder: (context) => const SettingsPage()),
);
```

Declarative navigation (`Navigator.pages`, `go_router`, …):

```dart
ShadcnPage(
  key: const ValueKey('settings'),
  child: const SettingsPage(),
)
```

## API

| Member | Type | Notes |
|---|---|---|
| `ShadcnPageRoute.builder` | `WidgetBuilder` | Required. |
| `maintainState` | `bool` | Default `true`. |
| `opaque` | `bool` | Default `true`; routes behind stop being built when the transition ends. |
| `transitionDuration` | `Duration` | Default `kShadcnPageTransitionDuration` (300 ms). |
| `barrierLabel` | `String?` | Semantics label for the (invisible) barrier. |
| `fullscreenDialog` | `bool` | Passed to [PageRoute]. |
| `ShadcnPageTransition` | widget | Reusable transition: fade + 2 % slide, `Curves.easeOutCubic`. |

## Theme

None. A route paints no surface, so there is no `<name>_style.dart` /
`<name>_theme.dart` pair.

## Differences from the old `navigation/page_route`

| Old | New |
|---|---|
| barrel + `part`, a suppress-all-lints pragma | one flat `page_route.dart` |
| `canTransitionTo(nextRoute) => nextRoute is ShadcnPageRoute` — **pushing any non-page route (dialog, drawer, sheet) over a page skipped the page's exit transition** | inherits the framework's `true` |
| `static final Animatable<double> _fadeIn` / `_slideIn` (lazily-initialised global mutable state) | `static const` curve/offset plus per-build `CurveTween`/`Tween` |
| `debugLabel` interpolated `settings.name` unconditionally, printing `PageRoute(null)` | prints the bare label when the route has no name |
| `kDefaultPageTransitionDuration` | `kShadcnPageTransitionDuration` (unambiguous against foundation's `kDefaultDuration` = 150 ms) |
| `preview.dart` | widgets-only gallery that also pushes the `dialog` component over a page |