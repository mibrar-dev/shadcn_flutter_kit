# Swiper

Swipe-to-open wrapper that reveals a `drawer` or `sheet` panel when the user
drags its child towards the panel's edge. The panel is painted in-tree so the
gesture can scrub it open and closed.

## When to use

- Edge navigation you want to reveal with a swipe (mobile-style drawers).
- A bottom sheet that follows a swipe-up gesture.

Provide a non-swipe trigger (a button) for keyboard and assistive-technology
users: a swipe alone is not accessible. Disable swipes where they conflict with
horizontal scrolling.

## Snippets

Swipe right to open a drawer:

```dart
Swiper(
  position: OverlayPosition.left,
  builder: (context) => const DrawerContent(),
  child: const PageBody(),
)
```

Swipe up to open a sheet:

```dart
Swiper(
  position: OverlayPosition.bottom,
  variant: SwiperVariant.sheet,
  builder: (context) => const SheetContent(),
  child: const PageBody(),
)
```

Drive it from a button (accessibility):

```dart
final controller = SwiperController();

Swiper(
  controller: controller,
  position: OverlayPosition.end,
  builder: (context) => const DrawerContent(),
  child: PageBody(onMenu: controller.open),
)
```

## API

| Member | Notes |
|---|---|
| `Swiper(position:, builder:, child:, variant:, enabled:, controller:, theme:)` | wraps `child`; the panel follows the drag |
| `SwiperVariant.drawer` | side panel (`expands: false`, draggable) |
| `SwiperVariant.sheet` | edge sheet (`expands: true`, not draggable) |
| `SwiperController` | `open()` / `close()` / `isOpen` / `progress` |
| `SwiperTheme` | behavioural overrides (see below) |
| `swiperDefaults(variant)` | baseline per variant |

The drag scrubs the panel (a full drag equals the panel's own extent, not the
screen). On release the panel settles open when the drag passed `threshold` of
the panel **or** the release velocity passed `kSwiperOpenVelocity` (300 px/s) in
the reveal direction; otherwise it settles closed. Tapping the barrier or
pressing Escape closes it.

## Theme resolution

`widget (theme:) > ComponentTheme<SwiperTheme> in tree > app overrides
(swiper_theme.dart through ComponentThemes) > swiperDefaults(variant)`, merged
per field with receiver-wins `Mergeable.merge`.

| `SwiperTheme` field | Default |
|---|---|
| `expands` | drawer `false`, sheet `true` |
| `draggable` / `barrierDismissible` / `useSafeArea` | `true` (sheet `draggable: false`) |
| `showDragHandle` / `borderRadius` / `maxSize` | null → `DrawerTheme` |
| `barrierColor` | black at 50% |
| `behavior` | `HitTestBehavior.translucent` |
| `threshold` | `0.5` |

The panel's fill, border, radius, shadow and drag handle come from the `drawer`
component's `DrawerTheme` (resolved by the swiper and painted through the shared
`primitives/drawer_route` surface), so a `DrawerTheme` override applies to both
a swiped panel and an `openDrawer` panel.

## Differences from the old swiper (`registry/components/overlay/swiper`)

- `SwiperHandler` (a strategy pair) is replaced by the `SwiperVariant` enum.
- The panel is in-tree, not a pushed route: a `Navigator` route cancels active
  pointers when pushed, so a route cannot follow an in-flight gesture. The
  in-tree panel scrubs correctly; barrier tap, Escape and drag-to-dismiss are
  kept. Because it is not a route, `Navigator.pop` and route-level focus
  restoration do not apply (a `SwiperController` replaces programmatic pop).
- `backdropBuilder`, `transformBackdrop`, `surfaceOpacity`, `surfaceBlur` are
  dropped; `dragHandleSize` moved to `DrawerTheme`.
- The old handler forced `expands: true` for drawers, so a side drawer covered
  the whole screen; the new default keeps the drawer's `maxSize` width.
- `_impl/`, `Styleable`, `ComponentTheme.maybeOf` resolution and the `gap`
  dependency are gone; a programmatic `SwiperController` is added.

## Getting started

1. Install the component (`flutter_shadcn add swiper`) or copy the folder into
   `lib/ui/shadcn/swiper/`; `drawer` and `primitives/drawer_route` install
   automatically.
2. Import `swiper.dart`; it re-exports `SwiperTheme`, `SwiperVariant`,
   `SwiperController` and `swiperDefaults`.
3. App-wide overrides go in `swiper_theme.dart`; per-subtree overrides use
   `ComponentTheme<SwiperTheme>(data: ..., child: ...)`.
