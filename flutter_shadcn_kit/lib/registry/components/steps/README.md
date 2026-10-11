# Steps

Vertical numbered step list joined by a connector line. Widgets-only, built on
`primitives/text` for the heading and the step number.

## When to use

- Show progress through a multi-step flow (checkout, onboarding, wizard).
- Present a vertical timeline of ordered stages.

For paging a list use `pagination`; for a location trail use `breadcrumb`.

## Snippets

Minimal:

```dart
Steps(
  children: <Widget>[
    StepItem(title: const Text('Account'), content: const [Text('Email')]),
    StepItem(title: const Text('Profile'), content: const [Text('Name')]),
  ],
);
```

Custom indicators:

```dart
const Steps(
  theme: StepsTheme(
    indicatorColor: ThemedColor.ref(ColorRef.primary),
    indicatorForeground: ThemedColor.ref(ColorRef.primaryForeground),
  ),
  children: <Widget>[StepItem(title: Text('Done'), content: [])],
);
```

## API

| Type | Notes |
|---|---|
| `Steps` | `children` (one widget per step) + optional `theme` |
| `StepItem` | `title` (rendered as an `h4`) + `content` rows |
| `StepsTheme` | per-field override container |

The number is derived from the child's position. `IntrinsicWidth` bounds the
list so an `Expanded` step content works inside a row.

## Theme resolution

`widget (theme:) > ComponentTheme<StepsTheme> in tree > app overrides
(steps_theme.dart through ComponentThemes) > stepsDefaults`, merged per field
with receiver-wins `Mergeable.merge`.

| `StepsTheme` field | Default |
|---|---|
| `indicatorSize` | `28` (× scaling) |
| `spacing` | `18` (× scaling) |
| `indicatorColor` | `muted` |
| `indicatorForeground` | `foreground` |
| `connectorColor` | `muted` |
| `connectorThickness` | `1` (× scaling) |

## Differences from the old steps (`registry/components/layout/steps`)

- The `package:flutter/material.dart` import (for `VerticalDivider`) is gone;
  the connector is a plain `SizedBox` + `ColoredBox`.
- The connector line is no longer drawn under the **last** step (the old code
  drew a trailing line into the bottom padding).
- `StepItem.title` uses the `h4` text modifier from `primitives/text`.

## Getting started

1. Install the component (`flutter_shadcn add steps`) or copy the folder into
   `lib/ui/shadcn/steps/`.
2. Import `steps.dart`; it re-exports `StepsTheme` and `stepsDefaults`.
3. App-wide overrides go in `steps_theme.dart`; per-subtree overrides use
   `ComponentTheme<StepsTheme>(data: ..., child: ...)`.
