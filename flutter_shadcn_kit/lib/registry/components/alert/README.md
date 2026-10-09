# Alert

A bordered callout banner for status, warning and info messages.

```dart
Alert(
  leading: const Icon(LucideIcons.info),
  title: const Text('Heads up'),
  content: const Text('You can add components from the registry.'),
);

Alert(
  variant: AlertVariant.destructive,
  title: const Text('Session expired'),
  content: const Text('Please log in again.'),
);
```

## API

| Member | Notes |
|---|---|
| `leading` / `title` / `content` / `trailing` | optional slots |
| `variant` | `AlertVariant.base` (default) or `AlertVariant.destructive` |
| `theme` | widget-leg `AlertTheme` override |

shadcn variants are `default` / `destructive`; `default` is a Dart reserved
word, so the row is called `base` here.

## Theme

`AlertTheme` has one `AlertStyle` row per variant. A destructive row that sets
only colours inherits the matching `base` row of the same leg, so an app
override can restyle only the destructive foregrounds:

```dart
const AlertTheme alertThemeOverrides = AlertTheme(
  destructive: AlertStyle(titleColor: ThemedColor.ref(ColorRef.destructive)),
);
```

Defaults (shadcn new-york): `bg-card`, 1px `border`, `rounded-lg`
(`radiusLg`), padding 16/12, title 14/w500, content 14 `mutedForeground`,
12px icon gap, 16px leading icon.

## Differences from the old `layout/alert`

- `Alert.destructive(...)` becomes `Alert(variant: AlertVariant.destructive)`.
- The old widget used Material (`package:flutter/material.dart`) and the
  `Styleable<AlertTheme>` bag; both are gone.
- The old `AlertTheme` only exposed `padding`/`backgroundColor`/`borderColor`,
  so destructive colours could not be themed. Both variants are rows now.
- Old destructive styling replaced `IconTheme`/`DefaultTextStyle` for the whole
  banner; slot styles are applied per slot so a caller's text style on the
  content slot no longer leaks into the title (and vice versa).
- The old `gap`/`data_widget` package imports are gone; the layout is
  `primitives/basic_layout.dart`.
