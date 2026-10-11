# image

A themed, rounded image slot: shadcn's `aspect-square` + `rounded-lg` +
`object-cover`, plus the loading and error slots the old preview hand-rolled.

The widget is `ShadcnImage` because `package:flutter/widgets.dart` exports an
`Image` of its own; nothing else in this component needs a prefix.

## Getting started

```dart
ShadcnImage(image: NetworkImage(url), width: 200, aspectRatio: 1)
```

> The widget is `ShadcnImage`, not `Image`: `package:flutter/widgets.dart`
> already exports an `Image`, so an unprefixed `Image` would make any file
> importing both libraries fail to compile. The prefix follows the same rule as
> `ShadcnTheme`. `ImageTheme` needs no prefix — no Flutter library declares
> that name.

Placeholders and failures:

```dart
ShadcnImage(
  image: NetworkImage(url),
  width: 200,
  aspectRatio: 1,
  placeholder: const Center(child: Icon(LucideIcons.loader)),
  errorBuilder: (context, error, stackTrace) =>
      const Center(child: Icon(LucideIcons.imageOff)),
)
```

## API

| Member | Type | Notes |
|---|---|---|
| `image` | `ImageProvider<Object>` | Required. The stream is resolved by the component, so the bytes stay cached across rebuilds. |
| `width` / `height` | `double?` | At least one is required — `aspectRatio` alone leaves an axis unbounded. When only one side is given and `aspectRatio` is null, the box defaults to square (the missing side equals the given one). |
| `aspectRatio` | `double?` | shadcn renders a square image (`1`); also the default when a single side is given without one. |
| `fit` | `BoxFit` | Defaults to `BoxFit.cover`. |
| `borderRadius` | `BorderRadiusGeometry?` | null = `ImageTheme.borderRadius`, then `radiusLg`. |
| `background` | `Color?` | Fill behind the image; also the default placeholder. |
| `placeholder` | `Widget?` | Shown under the picture until it decodes. |
| `errorBuilder` | `ImageErrorBuilder?` | Same signature as Flutter's `ImageErrorWidgetBuilder`. |
| `semanticLabel` | `String?` | Wraps the box in `Semantics(image: true)`. |
| `duration` | `Duration?` | Fade-in of the decoded picture. |
| `scale` | `double` | Logical-pixel scale of the decoded image. |
| `alignment` | `AlignmentGeometry` | Alignment inside the box. |

## Theme

`ImageTheme` (see `image_style.dart`) with four resolving legs — widget
argument > nearest `ComponentTheme<ImageTheme>` > `ComponentThemes` app entry >
`imageDefaults`:

| Field | Default |
|---|---|
| `background` | `muted` token |
| `borderRadius` | `radiusLg` from the ambient radius token |
| `duration` | 150 ms |

Customise app-wide in `image_theme.dart` (values only, never overwritten by a
CLI update).

## Differences from the old `utility/image`

| Old | New |
|---|---|
| `image.dart` held a single suppress-all-lints pragma line — **the component did not exist** | a real `Image` widget |
| `preview.dart` importing `material.dart` (`Scaffold`, `CircularProgressIndicator`, `Icon(Icons.error)`, `Colors.grey[200]`) | widgets-only preview with `Spinner`/icons and a themed error slot |
| no theme class | `ImageTheme` + `image_theme.dart` (`ImageTheme` collides with no Flutter name, so it keeps its plain name) |
| `image.meta.json` + `theme.schema.json` | one `meta.json` |