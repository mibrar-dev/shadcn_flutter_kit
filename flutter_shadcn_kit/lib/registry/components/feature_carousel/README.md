# Feature Carousel

An animated card carousel with a stacked-card look, autoplay, swipe, keyboard
navigation, nav arrows and a call to action. Widgets-only; it depends on no
other component.

## When to use

- An onboarding / marketing hero that cycles a handful of feature cards.
- A spotlight rail where one card is the focus and the rest are ghosts.

For a plain paged carousel use `carousel`; for a single hero surface use `card`.

## Snippets

```dart
FeatureCarousel(
  items: const <FeatureCarouselItem>[
    FeatureCarouselItem(
      title: 'Fast',
      description: 'Ship a build in seconds.',
      icon: LucideIcons.zap,
    ),
    FeatureCarouselItem(title: 'Safe', icon: LucideIcons.shield),
  ],
);
```

Drive it from a controller (autoplay off, custom CTA label):

```dart
final controller = FeatureCarouselController(
  autoPlay: false,
  primaryActionLabel: 'Get started',
  onPrimaryAction: (item, index) => open(item),
);

FeatureCarousel(items: items, controller: controller);
```

A custom card:

```dart
FeatureCarousel(
  items: items,
  cardBuilder: (context, item, index, theme) =>
      MyCard(item: item, theme: theme),
);
```

## `FeatureCarousel` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `items` | `List<FeatureCarouselItem>` | required | empty renders a zero-size box |
| `controller` | `FeatureCarouselController?` | null | created and owned when null |
| `width` | `double?` | 420 | card viewport width |
| `height` | `double?` | 370 | card viewport height |
| `theme` | `FeatureCarouselTheme?` | null | widget leg of the resolver |
| `cardBuilder` | `FeatureCarouselCardBuilder?` | null | replaces the centre card |

## `FeatureCarouselController`

| Member | Type | Notes |
|---|---|---|
| `index` | `int` | active item; setter notifies + fires `onIndexChanged` |
| `showCta` / `showNavArrows` | `bool` | chrome switches |
| `autoPlay` / `autoPlayInterval` | `bool` / `Duration` | timer |
| `animationStyle` | `FeatureCarouselAnimationStyle` | one of nine |
| `enableKeyboardNavigation` / `enableSwipe` | `bool` | input switches |
| `primaryActionLabel` | `String` | CTA label (English fallback) |
| `onPrimaryAction` / `onIndexChanged` | callbacks | |

The old `update()`, `cycleAnimationStyles`, `next`/`previous` and the
`primaryActionLabel` setter are dropped (clean break).

## Theme resolution

`widget theme > ComponentTheme<FeatureCarouselTheme> in tree > app overrides
(feature_carousel_theme.dart) > featureCarouselDefaults`, merged per field.

| Field | Default |
|---|---|
| `cardFill` | `card` token |
| `cardBorder` | `border` token |
| `ghostFill` | `muted` token |
| `controlBackground` | `muted` at 35% alpha |
| `controlForeground` | `mutedForeground` token |
| `accentColor` | `primary` token |
| `radius` | 12 |
| `transitionDuration` | 260 ms |

## Differences from the old `display/feature_carousel`

- `package:flutter/material.dart` (imported by three files for `Icons` and
  `Colors`) is gone. The arrows use the Lucide chevrons; every colour is a
  `ThemedColor` token.
- The old `FeatureCarouselThemeData.defaults()` was a dark-only literal set
  (`#121212` etc.) applied only when `widget.theme == null`. It is a
  token-derived `FeatureCarouselTheme` resolved through the four legs now.
- `FeatureCardCarousel` is renamed `FeatureCarousel`; `FeatureCarouselThemeData`
  is `FeatureCarouselTheme`.
- An empty `items` list no longer throws: the old `initState` called
  `clamp(0, items.length - 1)` (`clamp(0, -1)`).
- The nav arrows and CTA are `Clickable` (keyboard + focus + semantics); the old
  raw `GestureDetector` controls had none.
- `LogicalKeySet` (deprecated) is `SingleActivator`.
- The old hover replaced alpha (`withValues(alpha: 0.16)`); the new hover
  multiplies the base alpha.
- `titleBuilder` / `descriptionBuilder` / `backgroundBuilder` / `ctaBuilder` are
  dropped; `cardBuilder` covers all of them. The nine per-style transition trees
  moved to `primitives/animation.dart` (`AnimatedStyleTransition`).
- `FeatureCarouselCenterCard` / `FeatureCarouselGhostCard` are framework-internal
  (public only because Dart privacy is per-library); they live in
  `feature_carousel_style.dart` so both files stay under 400 lines.
