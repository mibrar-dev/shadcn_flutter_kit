# Divider

A themed rule in either orientation, optionally carrying a label. This is
shadcn's `Separator`; the id stays `divider` to match the component directory.

## When to use

- Separating list items, form sections or toolbar groups.
- Marking an "or continue with" break in an auth form.

## Snippets

```dart
const Divider();
```

Vertical:

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: const <Widget>[
    Text('left'),
    Divider(axis: Axis.vertical),
    Text('right'),
  ],
);
```

With a label:

```dart
const Divider(label: Text('or continue with'));
const Divider(
  label: Text('start'),
  labelAlignment: DividerLabelAlignment.start,
);
```

## `Divider` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `axis` | `Axis` | `horizontal` | the rule's orientation |
| `color` | `ThemedColor?` | `border` token | |
| `thickness` | `double?` | 1 | shadcn `h-px` |
| `extent` | `double?` | 1 | cross-axis size (height / width) |
| `indent` / `endIndent` | `double?` | 0 | insets on the leading/trailing edge |
| `label` | `Widget?` | null | omit for a plain rule |
| `labelPadding` | `EdgeInsetsGeometry?` | 8 horizontal | |
| `labelAlignment` | `DividerLabelAlignment?` | `center` | `start` parks the label at the start (collapses the leading rule), `end` at the end |
| `theme` | `DividerTheme?` | null | widget leg of the resolver |

A plain (unlabelled) rule is decorative and excluded from semantics; insets
mirror with text direction in the horizontal orientation.

`AxisAlignmentGeometry` is not needed: the label placement is three alignment
options that read naturally in both orientations and in RTL.

## Theme resolution

`widget theme > ComponentTheme<DividerTheme> in tree > app overrides
(divider_theme.dart) > dividerDefaults`, merged per field.

| `DividerTheme` field | Default |
|---|---|
| `color` | `border` token |
| `thickness` | 1 |
| `extent` | 1 |
| `indent` / `endIndent` | 0 |
| `labelPadding` | 8 horizontal |
| `labelAlignment` | `center` |
| `labelStyle` | 12px; colour falls back to `mutedForeground` |

## Differences from the old `display/divider`

- `Divider` and `VerticalDivider` merge into one widget with `axis`. The old
  `VerticalDivider` had **no `theme` parameter at all** and read
  `colorScheme.border` and `theme.iconTheme` directly, so a themed divider lost
  its theme as soon as it was rotated.
- The old widget implemented `PreferredSizeWidget` with `preferredSize =
  Size(0, height ?? 1)` — a zero-length main axis, which silently collapsed a
  horizontal divider inside a `Column`. The new widget measures itself.
- Three painters plus the `AxisAlignmentGeometry` / `AxisAlignment` /
  `AxisAlignmentDirectional` / `AxisInsets*` hierarchy (all in
  `shared/utils/axis.dart`) are replaced by one private painter and three
  alignment enum values. Nothing in the new tree imports that file.
- The old rule was animated through `AnimatedValueBuilder` +
  `DividerProperties`; shadcn has no divider transition, so the paint is direct.
