# AlertDialog

The shadcn alert dialog: an optional header icon, a title, a description and a
row of actions, pushed on the `dialog` component's modal route. Widgets-only.

## When to use

- A confirmation that must block the route below it and return a result.
- A destructive-action prompt with a cancel/confirm footer.

Use the plain `dialog` component for free-form modal content with no
title/description structure, and `sheet` / `drawer` for non-blocking surfaces.

## Snippets

```dart
final confirmed = await showAlertDialog<bool>(
  context: context,
  icon: const Icon(LucideIcons.triangleAlert),
  title: const Text('Delete this project?'),
  description: const Text('This cannot be undone.'),
  actions: <Widget>[
    Button(
      variant: ButtonVariant.outline,
      onPressed: () => Navigator.pop(context, false),
      child: const Text('Cancel'),
    ),
    Button(
      variant: ButtonVariant.destructive,
      onPressed: () => Navigator.pop(context, true),
      child: const Text('Delete'),
    ),
  ],
);
```

Inline (already inside a route, or inside `showShadcnDialog`):

```dart
const AlertDialog(
  title: Text('Heads up'),
  description: Text('Your session expires in five minutes.'),
);
```

## `AlertDialog` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `title` | `Widget?` | null | headline, usually a `Text` |
| `description` | `Widget?` | null | supporting text below the title |
| `icon` | `Widget?` | null | leading glyph, tinted with `iconColor` |
| `actions` | `List<Widget>` | `const []` | footer controls, laid out at the end |
| `theme` | `AlertDialogTheme?` | null | widget leg of the resolver |

`showAlertDialog` additionally takes the `dialog` parameters
`useRootNavigator`, `barrierDismissible`, `barrierColor`, `alignment`,
`routeSettings` and returns the route result.

## Theme resolution

Only the header/footer is themed here; the card, its 24px padding (shadcn
`p-6`), the radius, the shadow and the barrier belong to `DialogTheme`, so a
scoped `ComponentTheme<DialogTheme>` restyles an open alert too.

`widget theme > ComponentTheme<AlertDialogTheme> in tree > app overrides
(alert_dialog_theme.dart) > alertDialogDefaults`, merged per field.

| `AlertDialogTheme` field | Default |
|---|---|
| `iconColor` | `mutedForeground` token |
| `titleStyle` | 16px w600; colour falls back to `foreground` |
| `descriptionStyle` | 14px; colour falls back to `mutedForeground` |
| `iconGap` | 16 |
| `headerGap` | 8 (title to description) |
| `footerGap` | 24 (header to footer) |
| `actionGap` | 8 |
| `footerAlignment` | `MainAxisAlignment.end` |

## Differences from the old `overlay/alert_dialog`

Deleted:

- `ModalBackdrop` + `ModalContainer` and the `surfaceBlur` / `surfaceOpacity`
  / `surfaceClip` parameters (glass is not a token; the dialog owns the card).
- The `AlertDialogState` class: the widget is stateless.
- `leading` / `trailing` / `content` are renamed to `icon` / `trailing` /
  `description` (shadcn naming); `trailing` is gone.
- The hard-coded 560px max width: `DialogTheme.maxWidth` (480) applies.

Fixed (not ported):

- The barrier was black at **80%** and ignored `DialogTheme.barrierColor`
  entirely. It now inherits the dialog barrier (black at 50%), and an explicit
  `barrierColor` still wins.
- The old widget read `Theme.of(context)` directly and never consulted
  `ComponentTheme`/`ComponentThemes`; the header now resolves through the
  four-leg resolver.

Behaviour added:

- The theme stays live: the card and the barrier re-resolve on every build
  inside the themes captured when the route was pushed, so a light/dark switch
  restyles an open alert.
- Escape and barrier dismissal come from the `dialog` route.

## Getting started

1. Install the component (`flutter_shadcn add alert_dialog`) or copy the folder.
2. Import `alert_dialog.dart`; it re-exports `AlertDialogTheme` and
   `alertDialogDefaults`.
3. App-wide overrides live in the user-owned `alert_dialog_theme.dart`.
