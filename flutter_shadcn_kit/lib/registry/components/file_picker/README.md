# file_picker

A file selection surface with validation, a concurrent upload queue and the
`FileUploadRow` list. Three surfaces share one engine: `dragDrop` (the
`dropzone` component), `tile` (a one-line picker) and `mobile` (a compact
button).

Platform file picking and drag intake are **caller-supplied callbacks**, so the
component installs with no file/web package and works on every platform.

```dart
FileUpload(
  pick: (request) => myPlatformPicker.pick(request), // Future<List<FileValue>>
  upload: (file) => myApi.upload(file),              // Stream<double> progress
  constraints: const FileConstraints(
    allowMultiple: true,
    maxFiles: 5,
    maxFileSizeBytes: 10 * 1024 * 1024,
    allowedExtensions: <String>['pdf', 'png'],
  ),
  onComplete: (files) => print('uploaded: $files'),
)
```

## API

- `FileUpload` — the surface + list; `variant`, `controller`, `constraints`,
  `pick`, `upload`, `dropTargetBuilder`, `onFilesChanged`, `onComplete`,
  `onError`, `layout` (list/grid), `gridColumns`, `groupKey`,
  `groupHeaderBuilder`, `iconBuilder`, `itemsMaxHeight`,
  `maxConcurrentUploads`, `enabled`, `theme`.
- `FileUploadItemsView` — the rows alone (list, grid or caller-keyed groups)
  for callers that lay out their own surface.
- `FileUploadController` — external list/upload state (`primitives/file_value`);
  pass it as `controller` for controlled mode, or let the widget own one.
- `FileUploadRow` + `FileUploadRowTheme` — the row widget and its theme
  (`primitives/file_value`); rows are customizable through `FileUploadRowTheme`.
- `FileValue` / `FileItem` / `FileConstraints` / `FileStatusLabels` — value
  types (`primitives/file_value`).

`pick` receives a `FileUploadPickRequest` (`allowMultiple`,
`allowedExtensions`, `allowedMimeTypes`) and returns `FileValue`s. Set
`FileValue.bytes` when you want the image thumbnail; otherwise the row shows
the extension icon from `defaultFileIcon`.

Drag-and-drop needs a platform drag source. Wrap the surface with
`dropTargetBuilder` and call `onDrop` with the `FileValue`s your platform layer
read; without it the `dragDrop` surface is click-to-pick only.

## Theming

`FileUploadTheme` (surface) resolves `widget > tree > app > defaults`
(`fileUploadDefaults`). Row styling is the separate `FileUploadRowTheme`
primitive, provided through `ComponentThemes` or a tree
`ComponentTheme<FileUploadRowTheme>`. The user-owned file is
`file_picker_theme.dart`; the CLI never overwrites it.

## Behaviour notes

- Removing a file hides that file's errors with it; the controller keeps its
  own error list, so the component filters the removed ids locally.
- A `dragDrop` surface with no `pick` callback renders disabled (not just
  keyboard-dead): its visuals now match its behaviour.
- An owned `FileUploadController` is created in `didChangeDependencies` (it
  needs a context for localizations), not in `build`.

## Fixed (not ported)

- `web` + `cross_file` package dependencies (dart:html drop adapter) — the
  platform intake is a callback now.
- Upload errors were appended to a list that a later validation replaced,
  losing them; the controller keeps them until the file retries.
- `FileUploadItem.copyWith` cleared `progress` on every call, so a status
  change reset a running bar; progress is cleared only when asked.
- The old controller validated with its own constraints while the widget
  validated with the widget's, so the two sets could disagree; validation now
  runs once with `FileUpload.constraints`.
- The row's Material `LinearProgressIndicator` and the Material icon map are
  gone (Radix icons; the `progress` component).
- Picking failures were swallowed into an unlocalized English string; they now
  report a localized `onError`.
- Upload failures never wired the retry action; `FileUploadRow.onRetry` calls
  `FileUploadController.retry`, which re-queues the file.

## Deviations

- Old named option classes (`FileUploadDragDropOptions`, `FileUploadTileOptions`,
  `FileUploadMobileOptions`) collapse into `FileUploadVariant` with flat
  arguments; per-variant label overrides are gone (the localized defaults and
  `FileUploadRowTheme` cover them).
- The compact popover picker, the `FileUpload`/`UpstreamFileItem` shims,
  `onFilesSelected` (covered by `onFilesChanged`), `onUploadStart`, `hint`,
  `icon` and `actionLabel` are dropped (clean break; the old tree has no
  external users). `withData` is always on for the pick request.
- `groupListByStatus` is generalised to `groupKey` + `groupHeaderBuilder`
  (status grouping is `groupKey: (item) => item.status.name`); `FileIconProvider`
  is replaced by the `iconBuilder` callback.
- The upload engine, row widget and row theme moved to
  `primitives/file_value` (P4-B22, Q7) so the component keeps its three-Dart-file
  folder.
