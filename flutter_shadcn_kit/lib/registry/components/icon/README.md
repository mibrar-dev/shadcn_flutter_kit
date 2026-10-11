# Icon

Theme-driven icon modifiers plus a filled icon container. Widgets-only.

Ported from the old `display/icon` component with a clean break: only the
extension members with real call sites survive, the `WrappedIcon` wrapper is
gone, and the deprecated `IconContainer` constructor arguments are regular
overrides again.

## When to use

- Apply a size from the global icon scale to any widget:
  `const Icon(LucideIcons.chevronRight).iconSmall()`.
- Colour an icon with a token: `.iconMutedForeground()`.
- Put an icon in a filled rounded square: `IconContainer`.

## Snippets

```dart
const Icon(LucideIcons.chevronRight).iconSmall();

const Icon(LucideIcons.x).iconSmall().iconMutedForeground();

const IconContainer(icon: Icon(LucideIcons.check));
```

## API

| Member | Slot |
|---|---|
| `iconX3Small()` | 8px |
| `iconXSmall()` | 12px |
| `iconSmall()` | 16px |
| `iconMedium()` | 20px |
| `iconLarge()` | 24px |
| `iconMutedForeground()` | `mutedForeground` colour |

The size members read `ShadcnTheme.iconTheme`, so they follow the ambient
scaling factor. The colour member wins over an ambient `IconTheme` colour
(the old helper merged the other way around).

`IconContainerTheme` fields: `backgroundColor` (`primary`), `iconColor`
(`primaryForeground`), `padding` (`padXs` x container density),
`borderRadius` (`radiusMd`).

## Note on the theme class name

The component theme class is `IconContainerTheme`, not `IconTheme`:
`package:flutter/widgets.dart` already exports an `IconTheme` widget, and a
same-named class would shadow the framework widget for every importer.
