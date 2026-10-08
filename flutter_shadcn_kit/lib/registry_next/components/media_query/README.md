# media_query

Switches a subtree on the viewport width. Install it alone or as a dependency.

## Getting started

```dart
MediaQueryVisibility(
  minWidth: 768,
  alternateChild: const MobileNav(),
  child: const DesktopNav(),
)
```

Set the breakpoints once for a whole screen:

```dart
const MediaQueryVisibilityTheme appBreakpoints = MediaQueryVisibilityTheme(
  minWidth: 640,
  maxWidth: 1280,
);
```

## API

| Member | Type | Notes |
|---|---|---|
| `minWidth` | `double?` | Narrowest **inclusive** width that shows `child`. |
| `maxWidth` | `double?` | Widest **inclusive** width that shows `child`. |
| `child` | `Widget` | Shown while the width is inside the range. |
| `alternateChild` | `Widget?` | Shown outside the range; `null` renders a zero-size box instead of reserving space. |
| `theme` | `MediaQueryVisibilityTheme?` | Widget-leg override. |

With neither bound set, `child` always shows.

## Theme

`MediaQueryVisibilityTheme` carries `minWidth` / `maxWidth` plus the inherited
density/spacing/shadow slots. Four legs resolve, per field:

`widget argument` > nearest `ComponentTheme<MediaQueryVisibilityTheme>` >
`ComponentThemes` app entry > `mediaQueryVisibilityDefaults` (empty).

There are no token values here on purpose — breakpoints are numbers, not design
tokens — so `media_query_theme.dart` ships empty and the widget arguments remain
the primary way to set them.

## Differences from the old `layout/media_query`

| Old | New |
|---|---|
| barrel + two `part`s, a suppress-all-lints pragma | one flat `media_query.dart` |
| theme resolved from `ComponentTheme.maybeOf` only — **the app leg and the widget-defaults leg did not exist** | all four legs resolve per field |
| `MediaQueryVisibilityTheme` did not implement `Mergeable`; a `copyWith` silently dropped `themeDensity` / `themeSpacing` / `themeShadows` | `Mergeable<MediaQueryVisibilityTheme>` + `copyWith` that carries all three |
| `implements Styleable<…>` | plain widget with a `theme` constructor argument |
| out-of-range rendered `SizedBox(child: null)` | `SizedBox.shrink()`, documented as "collapse, don't reserve space" |
| `preview.dart` importing `material.dart` and importing the same library twice | widgets-only preview |