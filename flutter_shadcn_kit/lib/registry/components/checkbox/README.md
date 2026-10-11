# Checkbox

A tri-state form checkbox with controlled and controller-driven modes, keyboard
activation, `Clickable` interaction and form participation through
`FormValueSupplier`. Widgets-only; it imports no other component.

## When to use

- A `bool` form field (terms accepted, notifications on).
- A partially selected group ("select all" with a mixed row).

Use `switch` for a settings toggle with a sliding thumb, and `radio_group` for
mutually exclusive choices.

## Snippets

```dart
Checkbox(
  value: accepted,
  onChanged: (value) => setState(() => accepted = value),
  label: const Text('I accept the terms'),
);
```

Tri-state:

```dart
Checkbox(
  tristate: true,
  value: value,
  onChanged: (next) => setState(() => value = next),
  label: const Text('All notifications'),
);
```

Controller-driven (fires no `onChanged`; the controller is the source of truth):

```dart
final controller = CheckboxController();
Checkbox(controller: controller, label: const Text('Remember me'));
// controller.check(); controller.setIndeterminate();
```

## `Checkbox` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `value` | `CheckboxValue` | `unchecked` | required in controlled mode |
| `controller` | `CheckboxController?` | null | controller mode; `value`/`onChanged` must be null (asserted) |
| `onChanged` | `ValueChanged<CheckboxValue>?` | null | null disables a controlled checkbox |
| `tristate` | `bool` | false | tap cycles unchecked → checked → indeterminate |
| `enabled` | `bool?` | null | null means "controlled or controller-driven" |
| `label` | `Widget?` | null | text next to the box |
| `size` / `gap` / `padding` | | size table | per-widget metric overrides |
| `focusNode` / `autofocus` | | null / false | as in `Button` |
| `onHover` / `onFocusChange` | `ValueChanged<bool>?` | null | observation only |
| `theme` | `CheckboxStyle?` | null | widget leg of the resolver |

`CheckboxController extends ValueNotifier<CheckboxValue>` with `check()`,
`uncheck()`, `setIndeterminate()`, `toggle()` and `cycle()`.

## Theme resolution

`widget theme > ComponentTheme<CheckboxTheme> in tree > app overrides
(checkbox_theme.dart) > checkboxDefaults`. The value rows answer "what does the
box look like"; the `StateValue`s inside them answer "how does it react".

| `CheckboxTheme` field | Default |
|---|---|
| `checked` | `primary` fill / border, `primaryForeground` indicator, hover+press `@0.9` |
| `unchecked` | `input@0` fill, `input` border, no indicator |
| `indeterminate` | `primary` fill / border, dash indicator |
| `size` | 16 (shadcn `size-4`) |
| `borderRadius` | ambient `radiusSm` |
| `borderWidth` | 1 |
| `indicatorSize` | `size * 0.75` |
| `gap` | 8 (shadcn `gap-2`) |
| `padding` | 2, so the focus ring is never clipped |
| `labelStyle` | 14px; colour falls back to `foreground` |

Disabled is rest colours plus whole-control `Opacity(0.5)`, like every other
interactive component.

## Semantics

The checkbox reports `checked` / `mixed` / `enabled` and, when [label] is a
`Text`, uses its `data` as the semantic label. A checkbox is never `toggled`.

## Differences from the old `form/checkbox`

- `ControlledCheckbox` and the `ControlledComponent` adapter are deleted: one
  widget with two modes, exactly like `Toggle`. `CheckboxController` keeps
  `check()`, `uncheck()`, `indeterminate()` (-> `setIndeterminate()`, since
  `indeterminate` is now the enum's value name), `toggle()` and
  `toggleTristate()` (-> `cycle()`).
- The value enum is `CheckboxValue`, not `CheckboxState`: the old name
  collided with `State<Checkbox>` and made `_CheckboxState` ambiguous.
- `leading` / `trailing` are replaced by shadcn's single `label`.
- `AnimatedCheckPainter` is deleted; the indicator is the shadcn `check` /
  `minus` glyph with a 100ms fade.

Fixed (not ported):

- `enabled` was honoured for the cursor but **not** for the tap target:
  `Clickable(enabled: widget.onChanged != null)` ignored `widget.enabled`, so
  `enabled: true` with no `onChanged` painted a click cursor on a control that
  could not be pressed. One `_isEnabled` getter now drives both.
- The old state held `final bool _focusing = false` and never updated it, so
  the "focused border is 2px" branch was dead code. Focus is now a
  `FocusOutline` ring, keyboard-only, from `Clickable`.
- `SizedBox(width: gap)` was inserted on **both** sides unconditionally, so a
  label-less checkbox was 16px wider than its box. The gap is only inserted
  between the box and a label.
- The disabled rows swapped in `muted` / `mutedForeground` instead of dimming
  the rest style, so a disabled checkbox lost its colour identity.
- The old widget had **no** `Semantics` at all: screen readers announced an
  unlabelled group.
- The old widget read `ComponentTheme.maybeOf<CheckboxTheme>(context)` and
  ignored the widget argument entirely, so only one of the four theme legs
  existed. All four now resolve, per field and per state.
- The tri-state cycle was `checked → unchecked → indeterminate`; it is now the
  intuitive `unchecked → checked → indeterminate` order.
