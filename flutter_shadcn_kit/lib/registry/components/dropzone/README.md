# Dropzone

An upload surface: a 1 px outline, an upload icon, a localized status line, an
optional hint, and a browse button. Presentational — you hand it a state, it
does not listen to a drag stream. Widgets-only.

## When to use

- A single upload target on a form.
- A drag-and-drop hint next to an existing file list (pair it with
  `FileValue` from `primitives/file_value/` for the list itself).

## Snippets

```dart
Dropzone(
  state: DropzoneState.idle,
  hint: const Text('Up to 10 MB each.'),
  onBrowse: _pickFiles,
)
```

While a drag hovers:

```dart
Dropzone(isDragOver: true, onBrowse: _pickFiles)
```

No action button, extra content instead:

```dart
Dropzone(
  showAction: false,
  content: const Text('Drop a folder here to upload it whole.'),
)
```

## `Dropzone` API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `state` | `DropzoneState` | `idle` | the last committed outcome |
| `isDragOver` | `bool` | false | the live hover signal; wins over `state` for the border and the icon scale |
| `enabled` | `bool` | true | false dims the whole surface and disables the button |
| `focused` | `bool` | false | the focus ring |
| `icon` | `Widget?` | null | null uses the upload glyph |
| `hint` | `Widget?` | null | helper line under the status |
| `content` | `Widget?` | null | extra content below the action |
| `actionLabel` | `String?` | null | null = "Browse files" |
| `onBrowse` | `VoidCallback?` | null | null renders a disabled button |
| `actionVariant` | `ButtonVariant` | `outline` | |
| `showAction` | `bool` | true | false drops the button |
| `theme` | `DropzoneTheme?` | null | widget leg of the resolver |

## States

| `DropzoneState` | Status line | Border |
|---|---|---|
| `idle` | "Browse to upload files" | `border` |
| `dragging` | "Drop files to upload" | `primary` |
| `uploading` | "Uploading files..." | `primary` |
| `success` | "Files ready" | `accent` |
| `error` | "Fix errors to continue" | `destructive` |
| `disabled` | "File uploads disabled" | none |

All six strings and the browse label come from `primitives/localizations`; the
other 45 locales inherit the English until someone adds a translation.

## Theme resolution

`widget theme > ComponentTheme<DropzoneTheme> in tree > app overrides
(dropzone_theme.dart) > dropzoneDefaults`, merged per field.

| `DropzoneTheme` field | Default |
|---|---|
| `background` | null (no fill) |
| `borderColor` | `border` at rest; the `DropzoneState` token wins per state |
| `dragBorder` | `primary` — the border while a drag hovers |
| `borderWidth` / `borderRadius` | 1 / the ambient `radiusLg` |
| `padding` / `minHeight` | 24 / 0 |
| `iconColor` / `iconSize` | `mutedForeground` / 28 |
| `statusStyle` / `hintStyle` | 14 / 12, both `mutedForeground` |
| `gap` / `hintGap` / `actionGap` | 16 / 4 / 24 |
| `focusRingColor` / `focusRingSpread` | `ring` / 2 |
| `hoverScale` / `duration` | 1.05 / 150 ms |

## Differences from the old `form/dropzone`

- `FileDropzone` is now `Dropzone`: the old name implied it owned a file list,
  which it never did — that is `primitives/file_value/`.
- `hotDropEnabled` / `hotDropping` are replaced by `DropzoneState` plus
  `isDragOver`. The old pair could disagree with each other and with `state`,
  and `_resolveBorderColor` had to reconcile all three before it could pick a
  colour.
- `OutlineButton` is `Button(variant: ButtonVariant.outline)`.
- `showDefaultContent` is gone: the default content is now what you get when
  you pass nothing, and `content` always appends below it. The old pair had a
  state (`showDefaultContent: false` with `content: null`) that rendered an
  empty box.

Fixed (not ported):

- The status line and the browse label were hard-coded English strings built by
  `_resolveStatusLabel()`. They are `ShadcnLocalizations` getters now.
- `_resolveBorderColor` returned `null` for `idle`, and the outline was then
  painted with `color: null` — which `Border.all` rejects at runtime, so an
  idle dropzone (the default!) crashed instead of drawing a quiet outline. The
  idle border is the ambient `border` token now.
- `OutlinedContainer` drew a 1 px border for every state but only changed its
  colour, while `_resolveBorderColor` returned `null` for the disabled state —
  so `DropzoneState.disabled` and `enabled: false` disagreed about whether the
  surface was outlined at all. One state drives both now.
- The surface height came from a `LayoutBuilder` that set `height:
  constraints.maxHeight` when bounded, so inside a `Column` with a finite
  height the dropzone filled the whole parent instead of hugging its content.
  Only `minHeight` constrains it now.
- `focused` was a hand-rolled `BoxShadow` ring drawn *under* the container
  (`boxShadow:` on `OutlinedContainer`) rather than as a focus outline, so it
  was invisible against most backgrounds and ignored the `ring` token's alpha.
  `focused` now paints the ring from the token.
- `showDefaultContent: true` with a `content` widget rendered *both*, separated
  by `gapLg`; with `showDefaultContent: false` it rendered only the content. The
  icon, status and button were therefore impossible to keep while hiding the
  default action, even though `onPressed` being null already did that.
