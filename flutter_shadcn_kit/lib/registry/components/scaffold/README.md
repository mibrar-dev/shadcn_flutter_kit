# Scaffold

App screen shell: optional header/footer bars around a body, with a loading
bar, keyboard avoidance and floating-bar overlay modes. `AppBar` is the title
bar for headers and footers. Widgets-only; the loading bar is the `progress`
component, so install that too (declared in `meta.json`).

## When to use

- The root layout of a screen: navigation on top, actions at the bottom.
- Showing determinate or indeterminate loading above the header.
- Overlaying translucent bars over full-bleed content (`floatingHeader`).

Drawers need no host: `openDrawer`/`openSheet` push Navigator routes and work
inside any `Scaffold`.

## Snippets

Minimal:

```dart
Scaffold(
  headers: [AppBar(title: const Text('Inbox'))],
  child: const MessageList(),
);
```

Loading with footers:

```dart
Scaffold(
  headers: [AppBar(title: const Text('Sync'))],
  footers: [AppBar(subtitle: const Text('Last synced 09:41'))],
  loadingProgress: 0.4,
  showLoadingSparks: true,
  child: const Body(),
);
```

Full AppBar:

```dart
AppBar(
  leading: [Button(variant: ButtonVariant.ghost, onPressed: back, child: const Text('Back'))],
  title: const Text('Settings'),
  subtitle: const Text('Workspace'),
  trailing: [Button(onPressed: save, child: const Text('Save'))],
);
```

## `Scaffold` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | main content |
| `headers` / `footers` | `List<Widget>` | `[]` | usually `AppBar` bars |
| `loadingProgress` | `double?` | null | null hides the bar unless indeterminate |
| `loadingProgressIndeterminate` | `bool` | false | animated bar without a value |
| `floatingHeader` / `floatingFooter` | `bool` | false | overlay the body instead of pushing it |
| `backgroundColor` | `ThemedColor?` | theme | body fill |
| `headerBackgroundColor` / `footerBackgroundColor` | `ThemedColor?` | transparent | section fills |
| `showLoadingSparks` | `bool?` | theme (false) | sparks on the loading bar |
| `resizeToAvoidBottomInset` | `bool?` | theme (true) | pad the body for the keyboard |
| `theme` | `ScaffoldTheme?` | null | widget-leg override |

`ScaffoldBarData` (read with `Data.maybeOf<ScaffoldBarData>`) tells a bar
whether it is a header or footer and its index among its siblings; `AppBar`
uses it for edge-aware `SafeArea` handling.

## `AppBar` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `leading` / `trailing` | `List<Widget>` | `[]` | edge widget groups |
| `title` | `Widget?` | null | large medium primary line |
| `header` | `Widget?` | null | muted small line above the title |
| `subtitle` | `Widget?` | null | muted small line below the title |
| `child` | `Widget?` | null | custom center (not with `title`) |
| `trailingExpanded` | `bool` | false | trailing takes the free space |
| `alignment` | `AlignmentGeometry` | center | center content alignment |
| `padding` | `EdgeInsetsGeometry?` | theme | inner padding |
| `backgroundColor` | `ThemedColor?` | theme (`card`) | bar fill |
| `leadingGap` / `trailingGap` | `double?` | theme (4 scaled) | gaps inside edge groups |
| `height` | `double?` | null | null sizes to the content |
| `surfaceBlur` / `surfaceOpacity` | `double?` | theme | backdrop blur; opacity multiplies the fill |
| `useSafeArea` | `bool` | true | respect system intrusions |
| `theme` | `AppBarTheme?` | null | widget-leg override |

## Differences from old `scaffold`

- Deleted: `DrawerOverlay` (global mutable layer state), the root
  `Overlay(...)`, the custom render flex and padding storage, the
  `material.dart` import, per-bar `Data` generics (now `ScaffoldBarData`).
- Floating bars overlay the body (Stack); they no longer grow the
  `MediaQuery` padding. Give floating content its own top/bottom padding.
- The loading bar is `Progress`: the old `backgroundColor: transparent`
  override is gone (the token track is the design) and `showSparks` maps 1:1.
- Colors are `ThemedColor` (stay live on preset switches); surface opacity
  multiplies the resolved fill instead of replacing it.
- Dropped params: none besides the internals above.
