# Gooey Toast

Gooey-style transient notifications: a compact pill whose metaball silhouette
morphs into an expanded body. Built on the shared `primitives/toast_queue`
stack (the same queue `toast` uses, with the same auto-dismiss policy);
widgets-only, no Material.

## When to use

- Status changes that deserve a bit of delight (`Deployed`, `Payment failed`).
- Toasts that carry a short description and an inline action.

For a plain, quieter toast use `toast`; for decisions use `dialog`.

## Setup

Place a `GooeyToastLayer` under the theme and above the navigator:

```dart
ShadcnTheme(
  data: theme,
  child: GooeyToastLayer(child: myApp),
);
```

## Snippets

Through the ambient layer:

```dart
showGooeyToast(
  context,
  const GooeyToastOptions(
    title: 'Saved',
    description: 'Your changes are on the server.',
    state: GooeyToastState.success,
    position: GooeyToastPosition.left,
  ),
);
```

Through an owned controller:

```dart
final controller = GooeyToastController();
GooeyToastLayer(controller: controller, child: myApp);
controller.showGooeyToast(
  const GooeyToastOptions(title: 'Deployed', state: GooeyToastState.info),
  behavior: GooeyToastNewToastBehavior.transition,
);
```

## API

| Type | Notes |
|---|---|
| `GooeyToastLayer` | owns/accepts a `GooeyToastController`, renders the stack |
| `GooeyToastController` | `extends ToastQueue<GooeyToastOptions>`; `showGooeyToast(...)` returns the id |
| `showGooeyToast(context, options)` | convenience over the nearest layer |
| `GooeyToastOptions` | title, description, state, position, expand direction, duration, icon, custom body, action, autopilot, persistence |
| `GooeyToastState` | `success/loading/error/warning/info/action`; picks icon + tone |
| `GooeyToastAnimationStyle` | `sileo/smooth/snappy/bouncy/fluid/springEasing` |
| `GooeyToastShapeStyle` | `defaultShape/soft/sharp/capsule` |
| `GooeyToastBodyAnimationStyle` | `fade/fadeSlide/fadeScale/none` |
| `GooeyToastNewToastBehavior` | `stack/dismissPrevious/transition` |

`showGooeyToast(context, options, {id, behavior, duration, autoDismiss, onDismissed})`.
An explicit `duration` wins over `options.duration`, which wins over the theme
default; `autoDismiss: false` (or `persistUntilDismissed`) keeps the toast up.

## Auto-dismiss policy

Exactly the policy documented on `ToastQueue` (shared with `toast`):

1. A toast's countdown is its own; a neighbour in the same slot never shortens,
   restarts or cancels it.
2. Hover or pointer-down on a toast pauses **that** toast and it resumes from
   the remaining budget.
3. While a slot holds more than one toast, every non-newest toast pauses; the
   slot resumes when it is single again.

`GooeyToastController` defaults to `singlePerSlot: false` (the old `stack`
default); pass `GooeyToastNewToastBehavior.dismissPrevious` per show to replace
the slot, or `transition` to update the newest toast in place.

## Theme resolution

`widget (GooeyToastLayer(theme:)) > ComponentTheme<GooeyToastTheme> in tree >
app overrides (gooey_toast_theme.dart through ComponentThemes) >
gooeyToastDefaults`, merged per field with receiver-wins `Mergeable.merge`.

| `GooeyToastTheme` field | Default |
|---|---|
| `width` / `fill` | `350` / literal `#0D1117` |
| `roundness` | `18` (× shape style) |
| `titleStyle` | `13.2` / `w500` + state tone |
| `descriptionStyle` | `14` / `w400` / `#C0C5CB` |
| `duration` / `animationStyle` | `6s` / `sileo` |
| `shapeStyle` / `bodyAnimationStyle` | `defaultShape` / `fade` |
| `enableGooeyBlur` | `true` |
| `successTone` … `actionTone` | six literal accents (`#63C65E`, `#8A8F98`, `#EF5E5E`, `#EABB4B`, `#6EA8FF`, `#7A8DFF`); each is a direct `ThemedColor?` theme field |

## Differences from the old gooey toast

- The stack is `primitives/toast_queue`; the old controller, its overlay
  entries, region bookkeeping and `activeToasts`/`GooeyToastDetails` snapshots
  are gone (use `entries` / `entriesIn` / `contains`).
- The metaball renderer moved to `primitives/gooey/` (`gooey_shape`,
  `gooey_frame`, `gooey_surface`, `gooey_content`, `gooey_swipe`,
  `gooey_stack`); the Material imports, `Icons`, `CircularProgressIndicator`
  and `TextButton` are gone.
- `centerLeft` / `centerRight` positions are dropped: the shared queue slot
  model has no centre-band anchor. `GooeyToastPosition.alignment` is
  directional (`centerStart` / `centerEnd`), resolved against the ambient
  `Directionality` where the toast renders.
- The staged `transitionAfterClosed` timer choreography is gone; `transition`
  updates the live toast in place and the pill morphs.
- Stack control chips (`Collapse` / `Clear all`) and the
  `overlapStackWhenMultiple` / `maxVisibleCount` / `dismissWholeStackWhenMultiple`
  options are dropped (the queue policy owns stacking).
- Visual fields resolve at build time, so a theme change while a toast is open
  is live (the old controller froze them at show time).
- Dismissal animates out (fade + slide, 200 ms `easeIn`) through the shared
  `ToastExitTransition` before the queue removes the entry; remaining toasts
  animate into their new offsets. `MediaQuery.disableAnimations` removes
  instantly.

## Getting started

1. Install the component (`flutter_shadcn add gooey_toast`) or copy the folder
   into `lib/ui/shadcn/gooey_toast/` (plus `primitives/gooey/`,
   `primitives/toast_queue/` and `primitives/animation.dart`).
2. Wrap the app in `GooeyToastLayer`; import `gooey_toast.dart` (re-exports
   `GooeyToastTheme`, the enums, `gooeyToastDefaults` and the queue placement
   types).
3. App-wide overrides go in `gooey_toast_theme.dart`; per-subtree overrides use
   `ComponentTheme<GooeyToastTheme>(data: ..., child: ...)`.
