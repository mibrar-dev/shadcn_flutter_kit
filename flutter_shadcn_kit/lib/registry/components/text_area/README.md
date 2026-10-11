# TextArea

Multi-line text input. A thin wrapper over `Input` with three-line defaults,
a multiline keyboard and sentence capitalisation. Controller, validation, form
participation, features, focus ring and the theme legs are all `Input`'s, so
this component owns no visual property of its own and ships no theme class.

## When to use

- A comment or message box.
- Any multi-line prose field.

## Snippets

Default (three lines):

```dart
TextArea(initialValue: 'Hello, World!');
```

Placeholder and a taller box:

```dart
TextArea(
  placeholder: const Text('Type your message here...'),
  minLines: 6,
);
```

Grows with the content, no cap:

```dart
TextArea(hintText: 'Paste a long paragraph', minLines: 2, maxLines: 8);
```

With validation:

```dart
TextArea(
  minLines: 4,
  validator: (value) => (value ?? '').length < 8 ? 'At least 8 characters' : null,
);
```

Fills its parent:

```dart
SizedBox(height: 240, child: TextArea(expands: true, maxLines: null, minLines: null));
```

## API

| Parameter | Default | Notes |
|---|---|---|
| `minLines` | `TextArea.textAreaMinLines` (3) | smallest height in lines |
| `maxLines` | `TextArea.textAreaMaxLines` (null) | null grows with the content |
| `expands` | false | fills the parent instead of growing; pair with null `min`/`maxLines` |
| `keyboardType` | `TextInputType.multiline` | no `Enter`-to-submit |
| `textCapitalization` | `sentences` | differs from `Input`'s `none` |
| `hintText` / `placeholder` | null | |
| `controller` / `initialValue` | null | forwarded to `Input`, mutually exclusive |
| `focusNode` / `undoController` / `statesController` | null | forwarded |
| `textAlign` | `TextAlign.start` | forwarded |
| `style` / `padding` / `decoration` / `border` / `borderRadius` / `filled` | null | forwarded widget-leg overrides |
| `maxLength` / `maxLengthEnforcement` | null / null | forwarded |
| `readOnly` / `enabled` | false / true | `enabled: false` dims to 50% |
| `autofocus` / `autocorrect` / `enableSuggestions` | false / true / true | forwarded |
| `cursorColor` / `scrollPadding` | null / `EdgeInsets.all(20)` | forwarded |
| `features` | `[]` | forwarded; e.g. `InputClearFeature()` |
| `validator` / `autovalidateMode` | null / changed | forwarded |
| `onChanged` / `onSubmitted` / `onEditingComplete` | null | forwarded |
| `theme` | null | widget leg of `InputTheme` |

`InputTheme`, `InputSurface` and `resolveInputSurface` are re-exported from
`text_area.dart`, so an app that only uses text areas still gets the type.

## Theming

There is no `text_area_theme.dart`: every visual row is `InputTheme`'s. The
`theme:` parameter forwards straight to `Input`, and all four precedence legs
(widget arg → nearest `ComponentTheme` → app `ComponentThemes` → defaults)
behave exactly as they do for `Input`. A dedicated theme class would duplicate
the same ten rows and let the two drift apart.

## Fixed bugs

Old → new:

1. **`TextArea` extended `TextField`** just to override `expands`, `maxLines`
   and `minLines` through `widget.copyWith`, so the old widget's `build` read
   three properties that no caller could ever set differently.
2. **The drag handle ignored `isFinite`.** `initialWidth` defaults to
   `double.infinity`, and `onPanUpdate` then added `details.delta.dx` to it
   whenever `expandableWidth` was set — `infinity` arithmetic on every frame of
   a drag.
3. **`_height`/`_width` were clamped but never reported on settle.** The
   callback fired from inside `onPanUpdate`, so a drag that ended on a clamp
   boundary reported the pre-clamp value.
4. **`Stack(fit: StackFit.passthrough)` over a `SizedBox`** gave the field no
   size of its own: the box came only from `initialHeight`/`initialWidth`, so a
   longer message silently overflowed instead of scrolling.
5. **The handle was painted outside the box** (`bottom: -scaling`,
   `right: -scaling`) with `clipBehavior: Clip.none`, so it overlapped the
   field's own border and its 16px hit box swallowed taps aimed at the last
   line of text.

Found while porting:

6. **`TextArea` forwarded ~80 `TextField` parameters** (`contentInsertionConfiguration`,
   `magnifierConfiguration`, `spellCheckConfiguration`, `stylusHandwritingEnabled`,
   `enableIMEPersonalizedLearning`, …), none of which any caller in the registry
   set. The port keeps the 30 that a text area actually uses.
7. **`placeholder` and `hintText` were two spellings of one concept**; only
   `hintText` is kept, with `placeholder` for a custom widget, as in `Input`.
8. **The preview imported `package:flutter/material.dart`** and returned a
   `Scaffold`; the port is widgets-only.

## Migrating from the old TextArea

| Old | New |
|---|---|
| `TextArea(initialHeight: 150)` | `TextArea(minLines: 6)` |
| `expandableHeight` / `expandableWidth` | `maxLines` / `minLines`, or `expands: true` |
| `initialWidth: double.infinity` | dropped; the field fills its parent |
| `minWidth`/`minHeight`/`maxWidth`/`maxHeight` | `minLines`/`maxLines` |
| `onHeightChanged` / `onWidthChanged` | dropped with the handle |
| `decoration` / `border` / `borderRadius` / `filled` / `padding` | same names, forwarded to `Input` |
| drag-resize handle | gone; size with `minLines`/`maxLines`/`expands` |
| `InputOTP`-style `parts` split | single file; no `_impl/`, no `part` |