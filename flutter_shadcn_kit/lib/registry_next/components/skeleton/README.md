# Skeleton

Widgets-only loading placeholder with a repeating shimmer sweep. No Material,
no Cupertino, no component dependency, and no `package:skeletonizer`.

## When to use

- A block of content is loading and you do not want the layout to jump.
- A list of rows, a card or a media tile needs a neutral placeholder.

## Snippets

Wrap any widget; it keeps its box and is painted only once the data arrived:

```dart
Skeleton(
  enabled: loading,
  child: Text('Summary'),
);
```

Custom shape:

```dart
const Skeleton(
  borderRadius: BorderRadius.all(Radius.circular(40)),
  child: SizedBox(width: 80, height: 80),
);
```

Widget-leg theme override (beats the app and the tree legs):

```dart
Skeleton(
  enabled: loading,
  theme: SkeletonTheme(duration: Duration(milliseconds: 1600)),
  child: content,
);
```

App-wide override in `skeleton_theme.dart`:

```dart
const SkeletonTheme skeletonThemeOverrides = SkeletonTheme(
  fromColor: ThemedColor.ref(ColorRef.accent),
  toColor: ThemedColor.ref(ColorRef.secondary),
);
```

## API

| Widget | Parameter | Default | Notes |
|---|---|---|---|
| `Skeleton` | `child` | required | laid out always, painted only when `enabled` is false |
| | `enabled` | `true` | false renders the child unchanged |
| | `borderRadius` | null | null uses `SkeletonTheme.borderRadius`, then `borderRadiusMd` |
| | `theme` | null | widget leg of `SkeletonTheme` |

## Theme fields

| Field | Default | Notes |
|---|---|---|
| `fromColor` | `ColorRef.muted` | leading sweep fill |
| `toColor` | `ColorRef.accent` | trailing sweep fill |
| `duration` | 300 ms | one full sweep, start to end |
| `curve` | `Curves.linear` | sweep easing |
| `borderRadius` | `borderRadiusMd` | corner radius |

## Migrating from the old skeleton

| Old | New |
|---|---|
| `ShadcnSkeletonizerConfigLayer(theme: material.ThemeData(...))` | deleted; wrap the content in `Skeleton` |
| `content.asSkeleton()` | `Skeleton(child: content)` |
| `content.asSkeleton(enabled: loading)` | `Skeleton(enabled: loading, child: content)` |
| `content.asSkeleton(snapshot: s)` | `Skeleton(enabled: !s.hasData, child: content)` |
| `content.asSkeletonSliver()` | `Skeleton(child: content)` inside a `SliverToBoxAdapter` |
| `content.ignoreSkeleton()` | `Skeleton(enabled: false, child: content)` |
| `content.excludeSkeleton()` | `Skeleton(enabled: false, child: content)` |
| `SkeletonTheme(fromColor:, toColor:, duration:, enableSwitchAnimation:)` | `SkeletonTheme(fromColor:, toColor:, duration:)`; `enableSwitchAnimation` is gone (it never affected any widget in the old component) |