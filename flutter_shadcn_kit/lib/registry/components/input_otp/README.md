# InputOtp

One-time-password / verification-code input. One hidden `EditableText` drives a
row of character slots, so typing, pasting, the caret, undo and every text
shortcut behave like a normal text field. Widgets-only: no Material, no
component dependency.

## When to use

- A 4-6 digit SMS or authenticator code.
- A short PIN.

## Snippets

Plain code:

```dart
InputOtp(length: 6, onCompleted: (code) => verify(code));
```

Grouped with separators after every third slot:

```dart
InputOtp(
  length: 6,
  separatorEvery: 3,
  separator: const Text('-'),
  onChanged: (code) => print(code),
);
```

Alphanumeric with a filter and obscuring:

```dart
InputOtp(
  length: 8,
  keyboardType: TextInputType.text,
  obscureText: true,
  filter: (character) => RegExp(r'^[a-zA-Z0-9]$').hasMatch(character),
);
```

Externally controlled:

```dart
final controller = TextEditingController(text: '123456');
InputOtp(length: 6, controller: controller, onChanged: controller.notifyListeners);
```

## API

| Widget | Parameter | Default | Notes |
|---|---|---|---|
| `InputOtp` | `length` | required | number of slots, asserted > 0 |
| | `controller` | null | owns the whole code; created internally when null |
| | `initialValue` | null | ignored when `controller` is given |
| | `onChanged` | null | the whole code, on every change (including clamping) |
| | `onCompleted` | null | fires **once**, the first time every slot is filled |
| | `onSubmitted` | null | Enter / platform action; also the trigger `submitted` mode waits for |
| | `keyboardType` | `TextInputType.number` | |
| | `obscureText` | false | each character becomes a bullet |
| | `readOnly` | false | |
| | `enabled` | true | false dims the row to 50% and ignores pointers |
| | `autofocus` | false | |
| | `filter` | null | rejects a character when it returns false |
| | `separator` / `separatorEvery` | null / null | separator drawn after every N slots |
| | `validator` / `autovalidateMode` | null / changed | message rendered under the row, once every slot is filled |

`autovalidateMode` selects the trigger: `initial` validates on mount, `changed`
(every keystroke) on every change, `submitted` when the field is submitted.
The validator always receives `null` until all slots are filled.
| | `theme` | null | widget leg of `InputOtpTheme` |

## Theme fields

| Field | Default | Notes |
|---|---|---|
| `background` | `input` @0.3 rest / @0.5 hovered | per-state slot fill |
| `borderColor` | `input` | per-state slot border |
| `borderWidth` | 1 | |
| `borderRadius` | `borderRadiusMd` | |
| `padding` | 6 x 0 | |
| `textStyle` | 14 px | its colour is ignored |
| `boxSize` | 36 | slot size |
| `spacing` | density base gap | gap between slots |
| `separatorTextStyle` | `typography.base` | |
| `cursorColor` | `ring` | caret of the focused slot |

## Fixed bugs

Old → new:

1. **Slot focus nodes were never disposed** — `_InputOTPState` had no
   `dispose` at all, leaking one `FocusNode` per slot.
2. **`didReplaceFormValue` only called `onChanged`** and never wrote the value
   into the slots, so a form-driven replacement left the visible boxes stale.
3. **`onSubmitted` fired on every keystroke** once all slots were full
   (`val.every((e) => e != null)` ran on every change).
4. **Overflow characters were forwarded by reaching into the next slot's private
   `TextEditingController`**, and the same substring was assigned three times
   in three branches; the last slot silently dropped the rest of a paste.
5. **A surrogate pair occupied two slots** (`String.fromCharCode(codeUnitAt(0))`
   splits a non-BMP character).
6. `_InputOTPSpacing` read only `ComponentTheme.maybeOf<InputOTPTheme>` and
   ignored the widget's own `theme`, so a widget-level spacing override never
   applied.
7. `WidgetInputOTPChild` was 32x32 while the character slot was 36x36, so
   separators sat at a different height than the slots.
8. `InputOTPChild.character()` with no flag set produced a predicate that
   rejected every character: the field could not be typed into at all.
9. `InputOTPChildData` was a public class exposing the private
   `_InputOTPState` and `GlobalKey<_OTPCharacterInputState>` fields, so no
   caller could ever build one.
10. `IntrinsicWidth` wrapped a `Row` whose children were `Expanded`: the flex was
    meaningless under an intrinsic pass.

Found while porting:

11. **Every callback fired twice per edit.** The hidden field's
    `EditableText.onChanged` and the host's controller listener both report the
    same edit; only the listener is wired.
12. **`onChanged` fired with an empty code right after mounting.** Focusing the
    field selects offset 0 — a controller notification with unchanged text. The
    reported text is compared against the last one, so a selection-only change
    is not a code change.
13. **The filter ran after truncation**, so `1a2b3` in a 4-slot field lost the
    valid `3`: truncation cut at the last *unfiltered* character. Filtering now
    runs first.
14. **`autovalidateMode` was a dead knob.** It was compared in
    `didUpdateWidget` and never acted on. All three modes now have a trigger:
    `initial` on mount, `changed` on every change, `submitted` on submit — plus
    any mode when the validator itself changes.

## Migrating from the old OTP

| Old | New |
|---|---|
| `InputOTP(children: [InputOTPChild.input(), ...])` | `InputOtp(length: 6)` |
| `InputOTPChild.input(predicate:)` | `InputOtp(filter:)` |
| `InputOTPChild.character(allowDigit: true)` | `InputOtp(keyboardType: TextInputType.number, filter:)` |
| `InputOTPChild.separator` / `.space` / `.empty` | `separator` + `separatorEvery`, or the `spacing` theme row |
| `initialValue: OTPCodepointList` | `initialValue: '123456'` (a `String`) |
| `onChanged(OTPCodepointList)` | `onChanged(String)` |
| `InputOTPChildData` (public, unbuildable) | deleted |
| `OTPCodepointListExtension.otpToString()` | use the `String` directly |