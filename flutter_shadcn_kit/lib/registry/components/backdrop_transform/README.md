# backdrop_transform

Strategy describing how the content **behind** a sheet or drawer moves while it
opens. Consumed by `pinned_sheet`, `drawer` and `drawer_container`.

## Getting started

```dart
const BackdropTransform transform = ScaleBackdropTransform();

AnimatedBuilder(
  animation: controller,
  builder: (context, _) => transform.wrapBackdrop(context, appContent, value),
)
```

Anything that shrinks the backdrop also frees layout space; ask for it so a
drawer can slide into the gap:

```dart
final Size freed = transform.resolveExtraSize(viewportSize, value);
```

`BackdropTransform.none` is the identity transform for sheets that should leave
the content alone.

## API

| Member | Type | Notes |
|---|---|---|
| `wrapBackdrop(context, child, t, {isRoot})` | `Widget Function` | `t` is the open progress (`0` closed, `1` open). Root layers may clip their corners. |
| `resolveExtraSize(size, t, {isRoot})` | `Size Function` | Space freed per axis, never negative. |
| `ScaleBackdropTransform.minScale` | `double` | Default `0.95`, asserted in `(0, 1]`. |
| `ScaleBackdropTransform.cornerRadius` | `double?` | null = `radiusXxl` of the ambient theme. |
| `ScaleBackdropTransform.scaleAt(t)` | `double Function` | `1.0` at `t = 0`, `minScale` at `t = 1`, clamped in between. |

## Theme

None. The transform is a strategy object configured through its constructor;
the only theme-derived value is the root corner radius, read from
`ShadcnTheme.of(context)` at wrap time. There is no `<name>_style.dart` /
`<name>_theme.dart` pair.

## Differences from the old `overlay/backdrop_transform`

| Old | New |
|---|---|
| barrel + `part` + a suppress-all-lints pragma | one flat file |
| `resolveExtraSize` divided the scaled extent by `minScale` for the root layer, which is `0` at `t = 1` and negative (then clamped to `0`) at every other `t` — the root layer never freed any layout space | one formula, `size * (1 - scale)`, clamped at `0` |
| `minScale` was unchecked: `0` divided by zero, `> 1` grew the backdrop past its box | asserted to be in `(0, 1]` |
| `scaleAt(t)` extrapolated outside `0..1` on overshooting curves | progress clamped to `0..1` |
| `cornerRadius` fell back to the old `Theme.of(context).radiusXxl` | `ShadcnTheme.of(context).radiusXxl` |
| blank `theme.schema.json` | none |