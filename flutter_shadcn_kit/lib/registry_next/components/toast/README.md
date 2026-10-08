# Toast

Transient, non-blocking notifications anchored to a screen edge. Built on the
shared `primitives/toast_queue` stack; widgets-only.

## When to use

- Confirm a background action (`Saved`, `Copied`) without stealing focus.
- Report a short status that does not need a response.

For anything that needs a decision use `dialog`; for inline validation use
`input` / `form`.

## Setup

Place a `ToastLayer` under the theme and above the navigator so toasts sit over
every route:

```dart
ShadcnTheme(
  data: theme,
  child: ToastLayer(child: myApp),
);
```

## Snippets

Through the ambient layer:

```dart
showToast(context, builder: (context) => const Text('Saved'));
```

Through an owned controller (also usable from outside the tree):

```dart
final controller = ToastController();
ToastLayer(controller: controller, child: myApp);
controller.showToast(
  placement: ToastPlacement.topCenter,
  builder: (context) => const Text('Deployed'),
);
```

## API

| Type | Notes |
|---|---|
| `ToastLayer` | owns/accepts a `ToastController`, renders the stack |
| `ToastController` | `extends ToastQueue<ToastBuilder>`; `showToast(...)` returns the id |
| `showToast(context, ...)` | convenience over the nearest layer |
| `ToastBuilder` | `Widget Function(BuildContext)` |
| `ToastPlacement` | `top/bottom` × `leading/center/trailing` (from `toast_queue`) |
| `ToastSwipeDirection` | directions that dismiss a toast (from `toast_queue`) |

`ToastController.showToast({builder, placement, duration, autoDismiss, id, onDismissed})`.

## Auto-dismiss policy

The single policy documented on `ToastQueue` (shared with `gooey_toast`):

1. A toast's countdown is its own; a neighbour in the same slot never shortens,
   restarts or cancels it.
2. Hover or pointer-down on a toast pauses **that** toast (when
   `pauseOnHover`), and it resumes from the remaining budget.
3. While a slot holds more than one toast, every non-newest toast pauses; the
   slot resumes when it is single again.

`ToastQueue.singlePerSlot` (default `true`) dismisses the previous toast in a
slot when a new one arrives.

## Theme resolution

`widget (ToastLayer(theme:)) > ComponentTheme<ToastTheme> in tree > app overrides
(toast_theme.dart through ComponentThemes) > toastDefaults`, merged per field
with receiver-wins `Mergeable.merge`.

| `ToastTheme` field | Default |
|---|---|
| `background` / `foreground` | `popover` / `popoverForeground` |
| `borderColor` / `borderWidth` | `border` / `1` |
| `borderRadius` / `shadows` | null → ambient `radiusMd` / `shadowLg` |
| `padding` / `maxWidth` | `EdgeInsets.all(16)` / `380` |
| `duration` / `animationDuration` | `3s` / `250ms` |
| `pauseOnHover` / `showCloseButton` | `true` / `true` |
| `gap` / `offset` | `8` / `EdgeInsets.all(24)` |

## Differences from the old toast (`registry/components/overlay/toast`)

- The stack is `primitives/toast_queue`; the old `ToastController` /
  `_ToastItem` bookkeeping is gone.
- The global `_defaultToastController` and `_toastSequence` mutable globals are
  gone — the layer owns its controller (or takes one).
- The upstream compat shims (`ToastLayer` upstream shape, `ExpandMode`,
  `UpstreamToastEntry`, `ToastStackScope`/`ToastStackContext`) are dropped.
- `OverlayEntry` insertion is replaced by a `Stack` inside `ToastLayer`.
- Exit animation is not animated (the queue removes entries immediately); the
  entry animation is a fade. Swipe/close are instant. Flagged as an open item.

## Getting started

1. Install the component (`flutter_shadcn add toast`) or copy the folder into
   `lib/ui/shadcn/toast/`.
2. Wrap the app in `ToastLayer`; import `toast.dart` (re-exports
   `ToastTheme`, `ToastPlacement`, `toastDefaults`).
3. App-wide overrides go in `toast_theme.dart`; per-subtree overrides use
   `ComponentTheme<ToastTheme>(data: ..., child: ...)`.
