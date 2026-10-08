# Scrollbar

A themed wrapper around Flutter's `RawScrollbar`. The thumb colour comes from
the `border` token, its thickness from the ambient scaling and its radius from
the `radiusSm` token; everything can be overridden per widget, per subtree or
app-wide.

## When to use

- Desktop/web scroll surfaces where the native overlay scrollbar is not
  visible enough.
- Any list that needs a themed, always-visible thumb (`thumbVisibility`).

## Snippets

```dart
Scrollbar(
  thumbVisibility: true,
  child: ListView(controller: controller, children: items),
);
```

Track and custom thickness:

```dart
Scrollbar(
  thumbVisibility: true,
  trackVisibility: true,
  thickness: 10,
  child: SingleChildScrollView(controller: controller, child: content),
);
```

## `Scrollbar` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | the scrollable the bar attaches to |
| `controller` | `ScrollController?` | primary controller | pass the same controller as the scrollable |
| `thumbVisibility` | `bool?` | false | always show the thumb |
| `trackVisibility` | `bool?` | false | paint the track behind the thumb |
| `thickness` | `double?` | 7 × scaling | |
| `radius` | `Radius?` | `radiusSm` token | |
| `minThumbLength` | `double?` | 48 | thumb never shrinks below this |
| `minOverscrollLength` | `double?` | follows `minThumbLength` | iOS-style shrink while dragged past an edge |
| `color` | `ThemedColor?` | `border` token | |
| `interactive` | `bool?` | true | drag support |
| `notificationPredicate` | `ScrollNotificationPredicate?` | default predicate | |
| `scrollbarOrientation` | `ScrollbarOrientation?` | inferred from the scrollable | |
| `theme` | `ScrollbarTheme?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<ScrollbarTheme> in tree > app overrides
(scrollbar_theme.dart) > scrollbarDefaults`, merged per field.

| `ScrollbarTheme` field | Default |
|---|---|
| `color` | `border` token |
| `thickness` | 7 × scaling |
| `radius` | `radiusSm` token |
| `minThumbLength` | 48 |
| `minOverscrollLength` | follows `minThumbLength` |
| `interactive` | true |

## Differences from the old `control/scrollbar`

- The old widget subclassed `RawScrollbarState` and wrote the painter fields by
  hand from a theme cached in `didChangeDependencies`; the new widget resolves
  at build time and hands the values to `RawScrollbar`, which owns the painter.
  The state subclass (119 lines) is deleted.
- The old `Scrollbar.theme` widget-leg parameter was **never read** (the
  wrapper dropped it before building `ShadcnScrollbar`); the new widget feeds
  it through `resolveComponentStyle`.
- `minOverscrollLength` is now exposed, resolving P4-PRIM-1 Q1 at the
  component level: `RawScrollbar` owns the shrink, no custom painter math.
- The old painter padding (`MediaQuery` padding + 1px inset) is replaced by
  `RawScrollbar`'s own default, which already includes `MediaQuery` padding.
