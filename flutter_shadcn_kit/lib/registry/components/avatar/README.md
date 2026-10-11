# Avatar

Image or initials tile with an optional badge and an overlapping group.
Widgets-only: no Material, no Cupertino, no component-to-component
dependency.

## When to use

- You show a person, team or entity as a photo with an initials fallback.
- You want a small status badge anchored to a tile corner.
- You want several tiles overlapped with a background ring between them.

## Snippets

Initials:

```dart
const Avatar(initials: 'IB');
```

Photo with an automatic initials fallback and a badge:

```dart
Avatar(
  initials: 'IB',
  image: NetworkImage(photoUrl),
  badge: const AvatarBadge(child: Icon(LucideIcons.check, size: 8)),
);
```

Group:

```dart
const AvatarGroup(
  children: <Widget>[
    Avatar(initials: 'IB'),
    Avatar(initials: 'AC'),
    Avatar(initials: '+4'),
  ],
);
```

## API

| Widget | Parameter | Default | Notes |
|---|---|---|---|
| `Avatar` | `initials` | required | fallback text and semantic label |
| | `image` | null | any `ImageProvider`; failed decodes fall back |
| | `size` | `32 * scaling` | |
| | `borderRadius` | full circle | |
| | `badge` / `badgeAlignment` / `badgeGap` | null / bottom end / 0 | |
| | `theme` | null | widget-leg `AvatarTheme` |
| `AvatarBadge` | `child` | null | coloured with `badgeForeground` |
| `AvatarGroup` | `children` | required | usually `Avatar`s, laid out at `size` |
| | `overlap` | `size * 0.3` | px each tile overlaps the previous one |
| | `ringWidth` | `2` | background ring width |

`Avatar.getInitials` derives up to two uppercase initials from a name
(`'Ibrar Ahmed'` -> `'IA'`).

## Theming

`AvatarTheme` follows the standard four legs: widget `theme` argument >
nearest `ComponentTheme<AvatarTheme>` > app `ComponentThemes` >
`avatarDefaults`. Overrides are values only; see `avatar_theme.dart`.
`size`, `borderRadius` and the badge geometry resolve at build so the
defaults follow the ambient scaling factor.
