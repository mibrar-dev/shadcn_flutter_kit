# Toggle

On/off button with two modes — controlled (`value` + `onChanged`) and
uncontrolled (`controller`) — built on `Clickable` and reporting its value to
the nearest form through `FormValueSupplier`. Widgets-only; installable on its
own (it never imports another component).

## When to use

- A boolean setting (`Bold`, `Show sidebar`, `Notifications`) that persists
  while the widget stays on screen.
- A selection row where one of several options is active (old
  `SelectedButton`).
- A form field that submits a `bool`.

Use `Button` for one-shot actions; use a radio group for mutually exclusive
choices that are not toggle-shaped.

## Snippets

Controlled:

```dart
Toggle(
  value: bold,
  onChanged: (value) => setState(() => bold = value),
  child: const Text('Bold'),
);
```

Controller-driven (fires no `onChanged`; the controller is the source of
truth):

```dart
final controller = ToggleController();
Toggle(controller: controller, child: const Text('Show sidebar'));
// controller.toggle();
```

Active style override (old `SelectedButton.selectedStyle`):

```dart
Toggle(
  value: selected,
  onChanged: onSelect,
  activeStyle: const ToggleStyle(
    background: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
  ),
  child: const Text('Option'),
);
```

## `Toggle` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | label or icon |
| `value` | `bool?` | null | required in controlled mode |
| `controller` | `ToggleController?` | null | controller mode; `value`/`onChanged` must be null (asserted) |
| `onChanged` | `ValueChanged<bool>?` | null | null disables a controlled toggle |
| `enabled` | `bool?` | null | null means "controlled or controller-driven" |
| `style` / `activeStyle` | `ToggleStyle?` | null | widget legs for off / on |
| `theme` | `ToggleStyle?` | null | generic widget leg, merged under the state one |
| `onHover` / `onFocusChange` | `ValueChanged<bool>?` | null | observation only |
| `focusNode` / `autofocus` | | null / false | as in `Button` |

`ToggleController extends ValueNotifier<bool>` with `toggle()`; dispose it
with the owning widget.

## Theme resolution

`widget (style/activeStyle/theme) > ComponentTheme<ToggleTheme> in tree > app
overrides (toggle_theme.dart) > toggleDefaults`, merged per field and state.
Defaults: `on` is the button primary row, `off` is the button ghost row
(design §1.6); disabled is rest colours + whole-control `opacity 0.5`.

| `ToggleTheme` field | Default |
|---|---|
| `on` | `primary` fill / `primaryForeground`, hover+press `primary@0.9` |
| `off` | `muted@0` rest, `muted@0.8` hover+press, `foreground` label |
| `padding` | 16 x 8 |
| `textStyle` | 14 / w500 |

## Differences from the old button module

- `Toggle` moves out of the old combined `button` component into its own
  installable component (`components/toggle/`), so it can be installed alone.
- `SelectedButton` is deleted; `SelectedButton.style` maps to
  `Toggle.style` and `selectedStyle` maps to `Toggle.activeStyle`.
- The old `Toggle` (`value` + `style`) becomes the controlled mode; the
  controller mode rejects `value`/`onChanged` with a debug assert instead of
  silently preferring one of them.
- State handling moved to `Clickable`; form reporting uses the new
  `FormValueSupplier` mixin from `primitives/form_core`.

## Getting started

1. Install the component (`flutter_shadcn add toggle`) or copy the folder.
2. Import `toggle.dart`; it re-exports `ToggleStyle`, `ToggleTheme` and
   `toggleDefaults`.
3. App-wide overrides live in the user-owned `toggle_theme.dart`.
