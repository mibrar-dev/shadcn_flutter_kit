# Overflow marquee

Scrolls content on its own when it no longer fits its container — news
tickers, long labels, vertical credits. Widgets-only: no Material, no
Cupertino.

## When to use

- A single overflowing line or column that should keep moving.
- Content that fits should not animate at all (the render object measures the
  overflow first and paints a still frame when there is none).

## Snippets

```dart
OverflowMarquee(
  duration: Duration(seconds: 8),
  delayDuration: Duration(seconds: 1),
  fadePortion: 0.15,
  child: Text('A very long ticker line ...'),
);

OverflowMarquee(
  direction: Axis.vertical,
  child: SizedBox(height: 96, child: Text('Vertical credits ...')),
);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `direction` | `Axis.horizontal` | scroll axis |
| `duration` | `1s` | time for one `step`-pixel run; a run scales with the overflow |
| `delayDuration` | `500ms` | pause at each end of a run |
| `step` | `100` | pixels covered per `duration` |
| `fadePortion` | `0.1` | edge fade as a **fraction** of the visible extent, clamped `0..0.5` |
| `curve` | `Curves.linear` | easing of each run |
| `theme` | null | widget-leg `OverflowMarqueeTheme` |

## Theming

`OverflowMarqueeTheme` follows the standard four legs: widget `theme`
argument > nearest `ComponentTheme<OverflowMarqueeTheme>` > app
`ComponentThemes` > `overflowMarqueeDefaults`. Overrides are values only; see
`overflow_marquee_theme.dart`.

## Behaviour notes

- Scroll ping-pongs: rest, run forward, rest, run back.
- Horizontal scrolling follows the ambient text direction (RTL starts at the
  right edge and scrolls the other way).
- Reduced motion (`MediaQuery.disableAnimations`) stops the ticker and holds
  the content at its start position.
- Hit tests follow the scroll offset, so links/controls inside the child
  remain tappable.
- Ticks repaint the layer instead of rebuilding the widget subtree.
