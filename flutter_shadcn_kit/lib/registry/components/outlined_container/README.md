# Outlined Container

A themed bordered surface. The fill comes from the `background` token, the
border from `muted`, the radius from the ambient `borderRadiusXl`; everything
is overridable per widget, per subtree or app-wide. The module also ships
`SurfaceBlur` and the dashed border helpers.

## When to use

- Cards, panels and list rows that need the kit's outline look.
- Translucent surfaces (`surfaceOpacity`) and frosted surfaces
  (`surfaceBlur`).
- Dashed outlines for drop zones and empty states.

## Snippets

```dart
OutlinedContainer(
  padding: const EdgeInsets.all(16),
  child: const Text('Card body'),
);
```

Translucent + blurred:

```dart
OutlinedContainer(
  surfaceOpacity: 0.6,
  surfaceBlur: 12,
  child: const Text('Frosted'),
);
```

Dashed border:

```dart
DashedContainer(
  child: Padding(padding: const EdgeInsets.all(16), child: content),
);
DashedLine();
```

## `OutlinedContainer` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | |
| `backgroundColor` | `ThemedColor?` | `background` token | |
| `borderColor` | `ThemedColor?` | `muted` token | |
| `borderRadius` | `BorderRadiusGeometry?` | `borderRadiusXl` | |
| `borderWidth` | `double?` | 1 × scaling | |
| `borderStyle` | `BorderStyle?` | solid | |
| `boxShadow` | `List<BoxShadow>?` | none | |
| `padding` | `EdgeInsetsGeometry?` | zero | |
| `clipBehavior` | `Clip` | `antiAlias` | |
| `surfaceOpacity` | `double?` | null | multiplies the fill alpha |
| `surfaceBlur` | `double?` | null | backdrop blur sigma |
| `width` / `height` | `double?` | null | |
| `duration` | `Duration?` | null | decoration animation |
| `theme` | `OutlinedContainerTheme?` | null | widget leg of the resolver |

`SurfaceBlur` wraps a child in `ClipRRect` + `BackdropFilter`. It always keeps
the blur layer in the tree (sigma 0 when disabled), so toggling the blur does
not remount the child.

`DashedContainer` / `DashedLine` take `strokeWidth`, `gap`, `thickness` and a
`ThemedColor? color`; the defaults are 8/5/1 × scaling and the `border` token.

## Theme resolution

`widget theme > ComponentTheme<OutlinedContainerTheme> in tree > app overrides
(outlined_container_theme.dart) > outlinedContainerDefaults`, merged per field.

## Differences from the old `layout/outlined_container`

- The `shared/primitives/outlined_container.dart` fork is deleted; its stable
  blur wrapper is merged into `SurfaceBlur` (the old component copy dropped the
  `KeyedSubtree`, so toggling the blur remounted the child).
- The old `OutlinedContainer.theme` widget leg was **never read** (the state
  only looked at `ComponentTheme.maybeOf`); the new widget feeds it through
  `resolveComponentStyle`, so all four legs work.
- `Color?` parameters became `ThemedColor?`, so overrides can follow preset
  switches (`ThemedColor.ref`) instead of pinning literals.
- The dashed widgets are repainted directly: the two public properties classes
  (`DashedContainerProperties`, `DashedLineProperties`) and the second painter
  class collapse into one private painter, and a zero `width + gap` can no
  longer loop forever. `DashedContainerProperties.lerp` was only reachable
  through the deleted `AnimatedValueBuilder` plumbing, and no component
  imported any of those names. Like `Divider`, shadcn has no dashed-border
  transition, so the paint is direct.
