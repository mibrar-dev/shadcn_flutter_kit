# HoverCard

Rich preview card shown while the pointer rests on its child (long-press on
touch screens), presented through the popover machinery.

## When to use

Use for account previews, link unfurls, and glossary definitions. For a
short delayed label use `tooltip`.

## Snippets

```dart
HoverCard(
  hoverBuilder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('@shadcn'),
      Text('Beautifully designed components.'),
    ],
  ),
  child: Text('@shadcn'),
);
```

```dart
// Instant card.
HoverCard(
  wait: Duration.zero,
  hoverBuilder: (context) => Text('Details'),
  child: Icon(LucideIcons.info),
);
```

## API

| Prop | Meaning |
|---|---|
| `child` | The anchor the card points at |
| `hoverBuilder` | Builds the bare card content (the widget adds the surface) |
| `debounce` / `wait` | Hide/show delays; null resolves 500 ms from the theme |
| `popoverAlignment` / `anchorAlignment` | Card placement; null resolves top/bottom-center |
| `popoverOffset` | Gap between anchor and card; null resolves Offset(0, 8) |
| `controller` | External popover controller; owned internally when null |

## Theme fields

`HoverCardTheme`: `debounce`, `wait`, `popoverAlignment`,
`anchorAlignment`, `popoverOffset`, `behavior`. The surface is fixed tokens
(popover fill, border, radius md, padding 16).

## Differences from old `hover_card`

`adaptiveOverlay` and the handler passthrough are deleted (one show path);
the custom `MouseRegion` timers are the `Hover` primitive; the surface
paints from tokens.
