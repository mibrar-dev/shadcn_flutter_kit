# Timeline

Vertical timeline of chronological entries on `package:flutter/widgets.dart`
only — time label, indicator dot with a connecting line, then the title and
optional content. No Material, no Cupertino (the old `VerticalDivider` is a
painted `Container` now).

## When to use

- Activity/history lists, schedules, release notes, event logs.

## Snippets

```dart
Timeline(
  data: [
    TimelineData(
      time: Text('09:00'),
      title: Text('Kickoff'),
      content: Text('Project kickoff meeting.'),
    ),
    TimelineData(
      time: Text('11:00'),
      title: Text('Design review'),
      color: ThemedColor.value(Color(0xFFE7000B)),
    ),
  ],
);
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `data` | required | rows, top to bottom |
| `timeConstraints` | `120 * scaling` | width of the time column |
| `theme` | null | widget-leg `TimelineTheme` |

| `TimelineData` | Notes |
|---|---|
| `time` / `title` | required widgets; styled with the `primitives/text` modifiers |
| `content` | detail line under the title |
| `color` | per-entry indicator + connector colour (`ThemedColor`) |

## Theming

`TimelineTheme` follows the standard four legs: widget `theme` argument >
nearest `ComponentTheme<TimelineTheme>` > app `ComponentThemes` >
`timelineDefaults`. Overrides are values only; see `timeline_theme.dart`.
Sizes resolve at build from the ambient `scaling` and `density`.

## Behaviour notes

- The last row draws no connector.
- The dot is a circle, or a square when the ambient `radius` token is `0`
  (kept from the old component).
- Rows are separated by `rowGap`; the title/content column starts
  `4 * scaling` to the right of the indicator column.
