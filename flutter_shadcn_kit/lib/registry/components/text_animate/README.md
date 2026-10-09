# TextAnimate

Stream-aware animated text renderer for incremental updates (AI/chat output,
live logs). Pass each new revision of the full text: the shared prefix stays
settled and only the tail animates. A `Markdown` document streams the same
way through `withTextStreaming`, committing stable lines verbatim.

## When to use

- Text arrives chunk-by-chunk and newly appended units should animate.
- A markdown reply streams in and must stay readable mid-stream.

## Snippets

Plain stream:

```dart
TextAnimate(text: streamedText)
```

Blur-in with a blinking cursor:

```dart
TextAnimate(
  text: streamedText,
  effect: const TextAnimateEffect.blur(maxBlurSigma: 6, slideUpPx: 2),
  cursor: const TextAnimateCursor.blink(showWhenSettled: false),
)
```

Word-by-word scramble:

```dart
TextAnimate(
  text: streamedText,
  animateByWord: true,
  effect: const TextAnimateEffect.scramble(),
)
```

Streaming markdown:

```dart
Markdown(data: streamedMarkdown).withTextStreaming(
  effect: const TextAnimateEffect.fade(
    duration: Duration(milliseconds: 220),
  ),
)
```

Theme override (all four legs: widget arg, scoped, app, defaults):

```dart
ComponentTheme<TextAnimateTheme>(
  data: const TextAnimateTheme(
    effect: TextAnimateEffect.slide(offsetY: 16),
  ),
  child: TextAnimate(text: streamedText),
)
```

## `TextAnimate` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `text` | `String` | required | latest full revision |
| `style` | `TextStyle?` | theme (ambient) | merged over theme + ambient |
| `typewriter` | `TextAnimateTypewriter?` | theme (48/s) | `enabled`, `charsPerSecond` |
| `animateByWord` | `bool` | false | word units instead of characters |
| `effect` | `TextAnimateEffect?` | theme (none) | `none`/`fade`/`slide`/`blur`/`scramble`/`combined` |
| `cursor` | `TextAnimateCursor?` | theme (hidden) | `none`/`blink`/`solid` |
| `textAlign` | `TextAlign?` | start | |
| `smoothLayout` | `bool` | true | `AnimatedSize` on wrap changes |
| `layoutAnimationDuration`/`layoutAnimationCurve` | `Duration`/`Curve` | 180ms/`easeOutCubic` | smooth-layout motion |
| `onSettled` | `TextAnimateSettled?` | null | once per revision, with full text |
| `theme` | `TextAnimateTheme?` | null | widget-leg override |

`withTextStreaming` takes `typewriter` (default disabled), `effect`
(default 220ms fade) and `animateByWord`. Reduced motion
(`MediaQuery.disableAnimations`) renders everything settled with no ticker.

## Differences from old `text_animate`

- `StreamingText` is now `TextAnimate`; the seven effect classes are one
  `TextAnimateEffect` with const named constructors (plan "animation-style
  rows"); `TypewriterEffect`/`StreamingCursor`/`StreamingTextSettled` are
  `TextAnimateTypewriter`/`TextAnimateCursor`/`TextAnimateSettled`.
- Custom adapters implement `wrap` only (the shared `buildSpan` handles
  spans); the `ComposableStreamingTextEffect` mixin is gone.
- The theme resolves all four legs (the old state read widget + scoped
  only, so app overrides were silently ignored); per-field widget params
  (`style`, `typewriter`, `effect`, `cursor`) win over theme rows.
- `withTextStreaming` drops the `cursor` parameter (the old adapter accepted
  it but never rendered it) and the removed `Markdown` fields (`sourceType`,
  `followLinks`, `loading`, `errorBuilder`).
- `textDirection`, `locale`, `textWidthBasis`, `textHeightBehavior`,
  `softWrap`, `overflow` and `maxLines` are gone (ambient context covers
  them; the sibling `Markdown` renderer never exposed them either).
- Word splitting keeps whitespace (`\S+\s*|\s+`); the old word path dropped
  leading whitespace so units no longer joined back to the input.
- Reduced motion renders the settled frame with no ticker or `AnimatedSize`;
  screen readers get one live label with the full text.
