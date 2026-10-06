# Dialog

Modal dialog route plus a themed card shell, built on the widgets
[`ModalRoute`](https://api.flutter.dev/flutter/widgets/ModalRoute-class.html).
No Material, no Cupertino, no component-to-component dependency: the shell
paints its own `DecoratedBox` from `DialogTheme`.

## When to use

- You need a modal that blocks the route below, traps focus and returns a
  result.
- You want one card look driven by tokens (`card`, `border`, `radiusLg`,
  `shadowLg`) that follows light and dark themes.

Avoid when a non-modal popover, a sheet or an inline card is enough.

## Snippets

Minimal:

```dart
await showShadcnDialog<void>(
  context: context,
  builder: (context) => const Text('Hello dialog'),
);
```

With a result (actions are caller supplied widgets — the dialog never imports
a button component):

```dart
final confirmed = await showShadcnDialog<bool>(
  context: context,
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Text('Delete this project?'),
      MyConfirmButton(onPressed: () => Navigator.pop(context, true)),
      MyCancelButton(onPressed: () => Navigator.pop(context, false)),
    ],
  ),
);
```

Full screen, custom theme leg:

```dart
await showShadcnDialog<void>(
  context: context,
  fullScreen: true,
  theme: const DialogTheme(maxWidth: 640, shadows: <BoxShadow>[]),
  builder: (context) => const SettingsPanel(),
);
```

## `showShadcnDialog` API

| Parameter | Default | Notes |
|---|---|---|
| `context` / `builder` | required | `builder` receives the route context, so `Navigator.pop(context, value)` works |
| `useRootNavigator` | `true` | passed to `Navigator.of` |
| `barrierDismissible` | `true` | barrier tap **and** Escape |
| `barrierColor` | theme value | `ThemedColor`; null uses `DialogTheme.barrierColor` |
| `barrierLabel` | `ShadcnLocalizations.dialogDismiss` | semantic label of the dismissible barrier |
| `useSafeArea` | `true` | wraps the card in `SafeArea` |
| `routeSettings` | null | forwarded to the route |
| `traversalEdgeBehavior` | `closedLoop` | Tab wraps inside the dialog instead of leaving it |
| `alignment` | `Alignment.center` | card alignment inside the route |
| `fullScreen` | `false` | no radius, border, shadow or screen inset |
| `theme` | null | widget leg of the resolver |

## `DialogTheme` fields

| Field | Default |
|---|---|
| `background` | `card` token |
| `borderColor` | `border` token |
| `borderWidth` | `1.0` |
| `borderRadius` | ambient `radiusLg` |
| `padding` | card padding: `padMd` x density content padding (shadcn `p-6`, 24px) |
| `insetPadding` | screen edge inset: `padSm` x density content padding (16px); `EdgeInsets.zero` when `fullScreen` |
| `barrierColor` | black at 50% |
| `maxWidth` | `480` (null = unconstrained) |
| `transitionDuration` | `150ms` |
| `shadows` | ambient `shadowLg` |

Resolution order is `defaults < app (ComponentThemes) < scoped
(ComponentTheme) < widget`, merged per field with receiver-wins
(`resolveComponentStyle`). User values live in the user-owned
`dialog_theme.dart` (`const dialogThemeOverrides`).

## Live theme

The card and the barrier resolve `DialogTheme` and the shadcn colors on every
build, inside themes captured from the caller, so a light/dark switch or a
preset change restyles a dialog that is already open. The themes and data
captured at show time are re-injected into the route; the app leg
(`ComponentThemes`) has to sit above the navigator, which is where the app root
installs it.

Only `transitionDuration` is decided when the route is pushed, because the
framework reads it while installing the route.

## Differences from the old dialog (`registry/components/overlay/dialog`)

Deleted:

- `DialogOverlayHandler`, `DialogOverlayFullScreenHandler` and
  `DialogOverlayCompleter` — the overlay show path is gone; the pilot pushes a
  real `ModalRoute`.
- `ModalContainer` / `ModalBackdrop` and their `Styleable` themes, plus the
  `surfaceClip` / `surfaceBlur` / `surfaceOpacity` fields (glass belongs to a
  future surface primitive).
- `SurfaceBarrierPainter` (the cut-out barrier).
- The `OverlayHandlerStateMixin` wrapper: the shell keeps focus handling and
  nothing else.

Renamed / changed:

- `showDialog` -> `showShadcnDialog` (no clash with the widgets `showDialog`).
- `DialogRoute` -> `ShadcnDialogRoute`, extending the widgets `ModalRoute`
  instead of `RawDialogRoute`; it takes a builder instead of a
  `pageBuilder` + `transitionBuilder` pair and resolves `DialogTheme` itself.
  The old `anchorPoint` parameter is gone: widgets `ModalRoute` has no anchor
  point, so it could only ever have been carried.
- `ModalBackdropTheme` -> `DialogTheme`, with `padding` split into the card
  padding (shadcn `p-6`) and the new `insetPadding` screen inset.
- `ModalContainer` / `ModalBackdrop` are gone; the shell paints the card itself.

Fixed (not ported):

- Default barrier was transparent, so a "modal" dialog looked non-modal. The
  default is now black at 50% (shadcn `bg-black/50`).
- `barrierLabel` was a hardcoded English string; it now reads
  `ShadcnLocalizations.dialogDismiss`, translated in every shipped locale with
  the word Flutter itself uses for `modalBarrierDismissLabel`.

Behaviour added:

- Escape dismisses the dialog when `barrierDismissible` is true (the old code
  had no shortcut wiring).
- Focus is trapped: Tab and Shift+Tab cycle inside the dialog, honouring
  `traversalEdgeBehavior`, and the opener node is refocused when the dialog
  closes.
- The theme stays live: the card and the barrier re-resolve on every build, so
  a light/dark switch or a preset change restyles an open dialog.