# Scrollable

`FadedScrollableViewport` fades the leading and trailing edges of a scrollable
subtree whenever there is more content in that direction. It is
notification-driven, so it works with scrollables whose `ScrollController` you
do not own.

## When to use

- Long lists and horizontal strips where the content should fade out at the
  edges instead of being clipped hard.
- Any scrollable you cannot attach a `ScrollController` to (the separate
  `FadeScroll` primitive needs one).

## Snippet

```dart
FadedScrollableViewport(
  child: SingleChildScrollView(child: content),
);
```

## `FadedScrollableViewport` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | the scrollable subtree |
| `fadeExtent` | `double?` | 20 | scroll distance to full fade |
| `fadeSize` | `double?` | 50 | gradient length |
| `theme` | `ScrollableTheme?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<ScrollableTheme> in tree > app overrides
(scrollable_theme.dart) > scrollableDefaults`, merged per field.

| `ScrollableTheme` field | Default |
|---|---|
| `fadeExtent` | 20 |
| `fadeSize` | 50 |

## Differences from the old `layout/scrollable`

- The old directory was two things at once: a `ScrollableClient*` fork (moved
  to the `scrollable_client` component) and this fade viewport. Only the fade
  viewport stays; all `ScrollableClient*` names are deleted here.
- **Fixed:** the old viewport rebuilt on every `ScrollNotification`, including
  no-op updates. It now rebuilds only when the metrics snapshot changes.
- **Fixed:** the gradient was always vertical (`topCenter → bottomCenter`), so
  a horizontal scrollable faded top/bottom. The direction now follows the
  scroll axis.
- The fade math now comes from `primitives/scroll_metrics.dart`
  (`leadingFadeFraction` / `trailingFadeFraction`), which also handles a
  non-zero `minScrollExtent`; gradient stops are clamped monotonic so short
  content cannot produce a crossed gradient.
