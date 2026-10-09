# NavigationMenu

Horizontal navigation bar: entries act as buttons, open dropdown content on
hover or press, and show a chevron while open. Content renders in a themed
popover (`OutlinedContainer` surface) that follows between entries with a
hover grace period and closes on Escape. Widgets-only.

## When to use

- Top-level site/app navigation with rich dropdown panels.
- Mega-menu style grids via `NavigationMenuContentList`.

## Snippets

Minimal:

```dart
NavigationMenu(
  children: [
    NavigationMenuItem(onPressed: goHome, child: const Text('Home')),
    NavigationMenuItem(
      content: const NavigationMenuContentList(
        children: [
          NavigationMenuContent(title: Text('Web Apps')),
          NavigationMenuContent(title: Text('Mobile Apps')),
        ],
      ),
      child: const Text('Products'),
    ),
  ],
);
```

Rich content entry:

```dart
NavigationMenuContent(
  leading: const Icon(LucideIcons.layoutDashboard, size: 16),
  title: const Text('Dashboard'),
  content: const Text('Analytics and insights'),
  onPressed: openDashboard,
);
```

## API

| Class | Key parameters |
|---|---|
| `NavigationMenu` | `children`, `surfaceOpacity` / `surfaceBlur`, `theme` |
| `NavigationMenuItem` | `child` (required), `content`, `onPressed` |
| `NavigationMenuContent` | `title` (required), `content`, `leading`, `trailing`, `onPressed` |
| `NavigationMenuContentList` | `children`, `crossAxisCount` (3), `spacing`, `runSpacing`, `reverse` |

Keyboard: entries focus and activate with Enter/Space through `Button`;
Escape closes the open popover while focus is inside it (wrap content in an
autofocus `Focus` to take focus on open). Arrow-key traversal between entries
is not implemented (entries are tabbable in order).

## Differences from old `navigation_menu`

- Dropped: the mobile adaptive path through `overlay_configuration`
  (desktop popover presentation only) and its `adaptiveOverlay` flag.
- `RadixIcons` becomes Lucide; the old `Button` style-closure API becomes a
  plain `theme` row (`ButtonVariant.ghost`, muted fill while active).
- Content entries close the menu before firing `onPressed`.
