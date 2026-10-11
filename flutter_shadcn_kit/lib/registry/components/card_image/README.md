# Card Image

A pressable card that pairs an image surface with a text block
(`leading` / `title` / `subtitle` / `trailing`, from the `Basic` primitive).
Hovering scales the image; the card itself paints no chrome (the old
`ButtonStyle.fixed` look).

## When to use

- A media tile in a grid or a horizontal rail (a product, a photo, a cover).
- Any pressable card whose primary content is an image.

For a non-pressable surface use `card`; for a paged set of cards use
`carousel`.

## Snippets

```dart
CardImage(
  image: Image.network('https://picsum.photos/200/300', fit: BoxFit.cover),
  title: const Text('Sunset'),
  subtitle: const Text('18:42 · Lisbon'),
  onPressed: () => open(item),
);
```

Horizontal composition (image left, text right):

```dart
CardImage(
  theme: const CardImageTheme(direction: Axis.horizontal),
  image: thumb,
  title: const Text('Track'),
  trailing: const Icon(LucideIcons.chevronRight, size: 16),
);
```

A non-pressable card (no `onPressed`) still renders, but adds no interaction:

```dart
const CardImage(image: thumb, title: Text('Read only'));
```

## `CardImage` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `image` | `Widget` | required | content of the image surface |
| `title` | `Widget?` | null | passed to `Basic` |
| `subtitle` | `Widget?` | null | passed to `Basic` |
| `leading` | `Widget?` | null | passed to `Basic` |
| `trailing` | `Widget?` | null | passed to `Basic` |
| `onPressed` | `VoidCallback?` | null | null disables the card |
| `enabled` | `bool?` | null | overrides `onPressed != null` |
| `focusNode` | `FocusNode?` | null | card-owned when null |
| `autofocus` | `bool` | false | |
| `theme` | `CardImageTheme?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<CardImageTheme> in tree > app overrides
(card_image_theme.dart) > cardImageDefaults`, merged per field.

| Field | Default |
|---|---|
| `direction` | `Axis.vertical` |
| `hoverScale` | 1.05 |
| `normalScale` | 1 |
| `imageBackground` | transparent token |
| `imageBorderColor` | transparent token |
| `imageRadius` | ambient `radiusXl` |
| `gap` | 12 |

## Differences from the old `layout/card_image`

- `package:flutter/material.dart` is gone. The image surface is an
  `OutlinedContainer`; the card runs on `Button(size: ButtonSize.icon)` with
  `cardImageButtonStyle`, a chrome-free `ButtonVariantStyle` that replaces the
  removed `ButtonStyle.fixed`.
- The old `style`, `direction`, `hoverScale`, `normalScale`, `backgroundColor`,
  `borderColor` and `gap` widget arguments are `CardImageTheme` fields now.
- `_CardImageState` leaked a `WidgetStatesController`; the hover state comes
  from `Button.onHover` and no controller is allocated.
- The `Basic` text block is the `primitives/layout.dart` primitive (the old
  `layout/basic` component).
