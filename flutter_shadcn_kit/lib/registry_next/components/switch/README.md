# Switch

A boolean form control with a sliding thumb, controlled and controller-driven
modes, keyboard activation and form participation. Separate from `Toggle`:
a toggle is a momentary button that keeps a selected look, a switch is a
dedicated setting control.

## When to use

- A settings row (`Show sidebar`, `Auto-update`).
- A `bool` form field that reads as on/off.

Use `toggle` for toolbar-style boolean buttons and `checkbox` when the value is
part of a group or a form agreement.

## Snippets

```dart
Switch(
  value: enabled,
  onChanged: (value) => setState(() => enabled = value),
  label: const Text('Airplane mode'),
);
```

Controller-driven (fires no `onChanged`; the controller is the source of truth):

```dart
final controller = SwitchController();
Switch(controller: controller, label: const Text('Notifications'));
// controller.toggle();
```

## `Switch` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `value` | `bool` | false | required in controlled mode |
| `controller` | `SwitchController?` | null | controller mode; `value`/`onChanged` must be null (asserted) |
| `onChanged` | `ValueChanged<bool>?` | null | null disables a controlled switch |
| `enabled` | `bool?` | null | null means "controlled or controller-driven" |
| `label` | `Widget?` | null | text next to the track |
| `focusNode` / `autofocus` | | null / false | as in `Button` |
| `onHover` / `onFocusChange` | `ValueChanged<bool>?` | null | observation only |
| `theme` | `SwitchStyle?` | null | widget leg of the resolver |

`SwitchController extends ValueNotifier<bool>` with `toggle()`.
`kSwitchTrackKey` and `kSwitchThumbKey` are exposed for tests and golden tools.

## Theme resolution

`widget theme > ComponentTheme<SwitchTheme> in tree > app overrides
(switch_theme.dart) > switchDefaults`, merged per field and per state.

| `SwitchTheme` field | Default |
|---|---|
| `on` | `primary` track, `background` thumb, hover+press `@0.9` |
| `off` | `input` track, `foreground` thumb, hover+press `@0.8` |
| `trackSize` | 28 x 20 (shadcn `h-5 w-7`) |
| `thumbSize` | 16 (shadcn `size-4`) |
| `travel` | derived from the track and thumb sizes at build |
| `borderColor` / `borderWidth` | null / 0 (shadcn draws a transparent border) |
| `gap` | 8 |
| `labelStyle` | 14px; colour falls back to `foreground` |

Disabled is rest colours plus whole-control `Opacity(0.5)`.

## Differences from the old `form/switch`

- `ControlledSwitch` and the `ControlledComponent` adapter are deleted: one
  widget with two modes. `SwitchController` is unchanged.
- The old widget built its own `GestureDetector` + `FocusableActionDetector`
  + `FocusOutline` stack, so it never published `WidgetState` data and the
  hover/press rows of `SwitchTheme` were unreachable. Interaction now lives in
  `Clickable`, and the private `_SwitchTrack` reads the published
  `WidgetStatesData` to paint the resolved rows.
- `leading` / `trailing` / `gap` / `activeColor` / `inactiveColor` /
  `activeThumbColor` / `inactiveThumbColor` are replaced by `label` plus
  `SwitchStyle` rows (the colours are `ThemedColor`s, so they follow presets).

Fixed (not ported):

- The old `ControlledSwitch(enabled: true)` combined with
  `Switch._enabled = widget.enabled ?? widget.onChanged != null` produced a
  switch that *looked* enabled but could not be flipped. One `_isEnabled`
  getter now drives the cursor, the focus ring and the tap target.
- The disabled rows painted `muted` for the track and `mutedForeground` for the
  thumb, so a disabled switch lost its on/off colour identity; they are now the
  rest rows at 50% opacity.
- The disabled cursor was `SystemMouseCursors.forbidden`; it is now the system
  arrow, like every other control in the kit.
- The old widget ignored `SwitchTheme`'s app leg.
