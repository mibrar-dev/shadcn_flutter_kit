# Card

A rounded, bordered surface with the shadcn slot composition (`CardHeader`,
`CardTitle`, `CardDescription`, `CardContent`, `CardFooter`). Widgets-only; it
imports no other component, so later batches can depend on it freely.

## When to use

- Grouping related content on a raised surface.
- A settings panel, a summary panel, a media card.

Use `dialog` for a modal surface and `popover` for one anchored to a trigger.

## Snippets

```dart
Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const CardHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardTitle(child: Text('Deployments')),
            Gap(4),
            CardDescription(child: Text('Ship a new build.')),
          ],
        ),
      ),
      const Gap(16),
      const CardContent(child: Text('Every deploy is immutable.')),
      const Gap(16),
      CardFooter(
        child: Button(onPressed: () {}, child: const Text('Deploy')),
      ),
    ],
  ),
);
```

Bare surface:

```dart
const Card(child: Text('Body'));
```

Pressable card (a card is not a button; compose one):

```dart
Card(
  child: Clickable(onPressed: onTap, child: const Text('Open')),
);
```

## `Card` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | content |
| `padding` | `EdgeInsetsGeometry?` | `cardDefaultPadding` (24) | |
| `background` | `ThemedColor?` | `card` token | |
| `borderColor` | `ThemedColor?` | `border` token | |
| `borderWidth` | `double?` | 1 | `0` hides the border |
| `borderRadius` | `BorderRadiusGeometry?` | ambient `radiusXl` | |
| `shadows` | `List<BoxShadow>?` | ambient `shadowSm` | `const []` removes them |
| `clipBehavior` | `Clip` | `Clip.none` | `antiAlias` clips to the radius |
| `theme` | `CardTheme?` | null | widget leg of the resolver |

## Theme resolution

`widget theme > ComponentTheme<CardTheme> in tree > app overrides
(card_theme.dart) > cardDefaults`, merged per field. `CardTitle` inherits the
`foreground` leg (`cardForeground` by default) through `DefaultTextStyle.merge`;
`CardDescription` always uses `mutedForeground`. Bare `Text` in
`CardContent` inherits the ambient style, not `cardForeground`.

## Sheet overlays

Inside a sheet overlay (see `SheetOverlayHandler` in
`primitives/sheet_overlay.dart`) a card paints **only its padding**: the sheet
already provides the surface, so a second border would draw a border inside a
border. Everywhere else the full surface is painted.

## Differences from the old `layout/card`

- `SurfaceCard` is deleted. Its only difference was a translucent blurred fill
  (`surfaceOpacity` / `surfaceBlur`), which is glass, not a token, plus the
  sheet-overlay branch that now lives in `Card`. The pilot `dialog` and
  `input` already dropped it; `empty_state`, `radio_group` and `object_input`
  should use `Card` (or plain padding inside a sheet).
- The `filled` switch is deleted. Its default `fillColor` was the *border*
  token, so `filled: true` painted a grey block that no shadcn preset defines.
  The fill is now always the `card` token unless `background` overrides it.
- The old widget painted through `OutlinedContainer`, an unported shared
  primitive. `Card` paints its own `DecoratedBox`, so the component installs on
  its own.
- New: the shadcn slot widgets (`CardHeader` / `CardTitle` / `CardDescription`
  / `CardContent` / `CardFooter`) replace hand-written `Column`s.
