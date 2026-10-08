# Stage Container

Responsive layout helper that snaps its content to breakpoint widths and
centres it with density-aware padding.

## When to use

- A centred, breakpoint-aware page or section (docs, marketing, dashboards).
- Content that should step between fixed widths instead of scaling fluidly.

For a plain max-width box use `ConstrainedBox`; for a full grid use `group`.

## Snippets

Default breakpoints (576 / 768 / 992 / 1200 / 1400):

```dart
StageContainer(
  builder: (context, padding) => Padding(
    padding: padding,
    child: const PageContent(),
  ),
)
```

Constant steps of 120 px:

```dart
StageContainer(
  breakpoint: const ConstantBreakpoint(120),
  builder: (context, padding) => Padding(padding: padding, child: body),
)
```

Custom staged breakpoints:

```dart
StageContainer(
  breakpoint: const StagedBreakpoint([640, 1024, 1280]),
  builder: (context, padding) => Padding(padding: padding, child: body),
)
```

## API

| Member | Notes |
|---|---|
| `StageContainer(builder:, breakpoint:, padding:, theme:)` | the `builder` receives the outer `EdgeInsets` to apply |
| `StageBreakpoint.defaultBreakpoints` | 576 / 768 / 992 / 1200 / 1400 |
| `ConstantBreakpoint(step, {minSize, maxSize})` | width snaps to multiples of `step` |
| `StagedBreakpoint([...])` | width snaps to the nearest listed value |
| `StageContainerTheme` | `breakpoint` + `padding` overrides |

The `builder` owns the box: `StageContainer` only computes the padding, so it
works with any child layout.

## Theme resolution

`widget args > ComponentTheme<StageContainerTheme> in tree > app overrides
(stage_container_theme.dart through ComponentThemes) > stageContainerDefaults`,
merged per field with receiver-wins `Mergeable.merge`.

| `StageContainerTheme` field | Default |
|---|---|
| `breakpoint` | `StageBreakpoint.defaultBreakpoints` |
| `padding` | `EdgeInsetsDensity.symmetric(horizontal: 4.5)` → `baseContainerPadding * 4.5` (72 at the default density) |

A plain `EdgeInsets` override is used as-is; the density-aware
`EdgeInsetsDensity` default scales with the preset's container density.

## Behaviour

Given a container width `size` and a breakpoint strategy `bp`:

- `size < bp.minSize`: horizontal padding drops to zero (full-bleed content).
- `size > bp.maxSize`: the content is centred by adding the free space.
- otherwise: the content snaps down to `bp.getMinWidth(size)` and is centred.

## Differences from the old stage container (`registry/components/layout/stage_container`)

- The old `StageContainerThemeDefaults` hard-coded `EdgeInsets.symmetric(horizontal: 72)`
  while the widget computed `density.baseContainerPadding * 4.5`; the new
  default is the density-aware `EdgeInsetsDensity`, so it follows the preset.
- An unbounded width (inside a horizontal scroll view) produced infinite insets
  and a layout error; it now falls back to the base padding.
- `StageBreakpoint` is a `sealed` class with `ConstantBreakpoint` /
  `StagedBreakpoint` variants; the `StageBreakpoint.constant` / `.staged`
  factories are dropped (use the subclass constructors).
- `StageContainerTheme` is resolved through `resolveComponentStyle`, so the app
  leg and per-field merge work like every other component; the old
  `Styleable` / `ComponentTheme.maybeOf` path and the `gap` dependency are gone.

## Getting started

1. Install the component (`flutter_shadcn add stage_container`) or copy the
   folder into `lib/ui/shadcn/stage_container/`.
2. Import `stage_container.dart`; it re-exports `StageBreakpoint`,
   `ConstantBreakpoint`, `StagedBreakpoint` and `stageContainerDefaults`.
3. App-wide overrides go in `stage_container_theme.dart`; per-subtree overrides
   use `ComponentTheme<StageContainerTheme>(data: ..., child: ...)`.
