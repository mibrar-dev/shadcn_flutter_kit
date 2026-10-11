# RadioGroup

A single-select group with a row shape and a card shape, controlled and
controller-driven modes, roving arrow-key traversal and form participation.
Widgets-only.

## When to use

- Picking one option out of a short list (`Free` / `Pro` / `Team`).
- A size or plan picker where the options are cards.

Use `checkbox` for independent booleans, `select` for a long list presented in
an overlay, and `toggle` for a toolbar-style on/off control.

## Snippets

```dart
ShadcnRadioGroup<String>(
  value: plan,
  onChanged: (value) => setState(() => plan = value),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <Widget>[
      RadioItem<String>(value: 'free', label: Text('Free')),
      RadioItem<String>(value: 'pro', label: Text('Pro')),
    ],
  ),
);
```

Controller-driven (fires no `onChanged`; the controller is the source of truth):

```dart
final controller = ShadcnRadioGroupController<String>('pro');
ShadcnRadioGroup<String>(controller: controller, child: items);
// controller.select('free');
```

Card options:

```dart
ShadcnRadioGroup<String>(
  value: plan,
  onChanged: (value) => setState(() => plan = value),
  child: Column(children: <Widget>[
    RadioCard<String>(value: 'pro', child: const Text('Pro — $20/mo')),
  ]),
)
```

## `ShadcnRadioGroup` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | the items, laid out by the caller |
| `value` | `T?` | null | required in controlled mode |
| `controller` | `ShadcnRadioGroupController<T>?` | null | controller mode; `onChanged` must be null (asserted) |
| `onChanged` | `ValueChanged<T>?` | null | null disables the group |
| `enabled` | `bool?` | null | null means "interactive when driven" |
| `direction` | `Axis` | vertical | arrow-key reading order |
| `theme` | `RadioGroupTheme?` | null | widget leg of the resolver |

`ShadcnRadioGroupController<T> extends ValueNotifier<T?>` with `select(T?)`.
The class is prefixed because Flutter 3.47 exports its own `RadioGroup` from
`package:flutter/widgets.dart`; the kit never asks a user to `hide` a name.

`RadioItem<T>` (the row) and `RadioIndicator` (the circle) come from
`primitives/selectable_radio/`, so `select`, `menu` and `tabs` can reuse them.
`RadioCard<T>` (the surface shape) and `SelectableCardTheme` stay with this
component, because a card is a component-layer surface and a layer 2 primitive
may not import `Card`. `kRadioIndicatorKey`, `kRadioIndicatorDotKey` and
`kRadioCardKey` are exposed for tests and golden tools.

## Keyboard

| Key | Effect |
|---|---|
| ArrowDown / ArrowRight | select the next enabled item and focus it |
| ArrowUp / ArrowLeft | select the previous enabled item and focus it |
| Space / Enter | activate the focused item |

Disabled items are skipped and the walk wraps around. Tab moves out of the
group without changing the value.

## Theme resolution

`widget theme > ComponentTheme<RadioGroupTheme> in tree > app overrides
(radio_group_theme.dart) > radioGroupDefaults`, merged per field and per state.

| `RadioGroupTheme` field | Default |
|---|---|
| `direction` | `Axis.vertical` |
| `items` (`SelectableRadioTheme`) | `unselected`: `input` border, transparent fill; `selected`: `primary` border + `primary` fill + `primaryForeground` dot; `gap` 8; `itemPadding` 2 all round; `labelStyle` `text-sm` (14) |
| `card` (`SelectableCardTheme`) | rest border `border`, hover `accent`, selected border `primary`; `borderWidth` 1; `padding` 16; `gap` 12 |

Sizes are shadcn's: a 16 px circle (`size-4`) with an 8 px dot (`size-2`).
Disabled is the rest style plus whole-item `Opacity(0.5)`.

## Differences from the old `form/radio_group`

- `ControlledRadioGroup` and the `ControlledComponent` adapter are deleted: one
  widget with two modes. `ShadcnRadioGroupController` replaces
  `RadioGroupController`.
- `RadioCard` is now a themed card item (`RadioCard<T>`) rather than a separate
  widget with its own border arithmetic, and `Radio` becomes `RadioIndicator`,
  both themed through the group's own rows.
- The group published its state through `data_widget`'s global registry; it is
  `Data` data now, and the selection scope compares by value so an unrelated
  rebuild does not re-notify the items.
- The public `NextItemIntent` / `PreviousItemIntent` are the primitive's
  `NextRovingItemIntent` / `PreviousRovingItemIntent`: unambiguous, and `command`
  keeps its own private pair.
- The arrow keys are registered on each item's `Clickable` (`shortcuts` +
  `actions`), not on a `Shortcuts` above the items. `Clickable` binds the arrow
  keys to directional focus traversal and the nearest `Shortcuts` wins, so a
  group-level `Shortcuts` was unreachable. A vertical group binds up/down, a
  horizontal one left/right; the unused pair keeps `Clickable`'s own focus
  traversal.

Fixed (not ported):

- `RadioItem` selected itself on *focus* (`onShowFocusHighlight` called
  `_setSelected`), so tabbing into a group changed the value before the user
  pressed anything. Selection now comes from a tap, from space/enter, or from
  an arrow key.
- `NextItemIntent` and `PreviousItemIntent` were registered by *every* item and
  both just selected that item, so the arrow keys never moved anywhere. The
  group owns a roving traversal (`primitives/roving_group.dart`) that skips
  disabled items and wraps.
- `RadioCard` drew a 2 px border plus an `AnimatedPadding` compensation and
  computed it as `borderWidth - selectedBorderWidth`, which went negative — and
  threw — whenever a theme set a wider selected border. The border width is
  constant now and only the colour changes.
- `RadioCard` called `Card(filled:, fillColor:, boxShadow:)`, an API the accepted
  `Card` no longer has, so a themed card crashed at runtime.
- `RadioItem` had no label slot: the label had to be passed as `leading`, so the
  circle floated between two arbitrary widgets. `label` is its own slot and the
  indicator leads.
- `IntrinsicHeight` + `Row` in every item row (a full extra layout pass per
  row) is gone.