# File Upload (`file_picker`)

UI-only file upload surfaces with pluggable file picking.

---

## When to use

- Use this when:
  - you want upload/dropzone UI without coupling to a specific picker plugin.
  - you need one constructor with variant behavior controlled by `options`.
    - drag + drop
    - tile picker (no drag)
    - mobile trigger (icon/button)
- Avoid when:
  - you only need basic native picker calls and no upload/list UI.

---

## Install

```bash
flutter_shadcn add file_picker
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/form/file_picker/file_picker.dart';
```

---

## Picker integration

This component is UI-only. Provide your own `pickFiles` callback and wire it to any package.

```dart
Future<List<FileLike>> onPick(FileUploadPickRequest request) async {
  // Bridge request.allowMultiple / request.allowedExtensions / request.allowedMimeTypes
  // to any picker package and return FileLike objects.
  return [];
}
```

---

## Variants (`options`)

### 1) Drag & Drop

```dart
FileUpload(
  pickFiles: onPick,
  title: const Text('Upload files'),
  options: const FileUploadDragDropOptions(
    subtitle: Text('PDFs, images, and other supported files.'),
    hint: Text('Drag files here or click the dropzone to pick.'),
    idleLabel: 'Drag files here or click to pick files.',
  ),
)
```

Notes:
- No browse action button is rendered in drag-drop mode.
- Dropzone click can still trigger your `pickFiles` callback.
- Drag/drop intake is built into the web target and does not use
  `package:file_picker`. Native picker selection still comes from your
  `pickFiles` callback.

### 2) Tile Picker (No Drag and Drop)

```dart
FileUpload(
  pickFiles: onPick,
  title: const Text('Attach files'),
  options: const FileUploadTileOptions(
    actionLabel: 'Add files',
    subtitle: Text('No file chosen'),
    hint: Text('Good for touch-first layouts.'),
  ),
)
```

### 3) Mobile Trigger (Icon/Button)

```dart
FileUpload(
  pickFiles: onPick,
  options: const FileUploadMobileOptions(
    popover: true,
    popoverItems: [
      FileUploadPickOption.pickFiles,
      FileUploadPickOption.pickImages,
    ],
  ),
)
```

---

## Upload support

All three variants support uploads with `uploadFn` and `FileUploadController`.
List layout groups files by status (`Uploading`, `Completed`, `Waiting`, `Failed`).
You can override these labels via `statusLabels`.

```dart
FileUpload(
  pickFiles: onPick,
  title: const Text('Upload assets'),
  subtitle: const Text('Make it match your product voice'),
  statusLabels: const FileUploadStatusLabels(
    uploading: 'In progress',
    completed: 'Done',
    waiting: 'Queued',
    failed: 'Needs attention',
  ),
  tileEmptySelectionLabel: 'Nothing selected',
  tileSelectionTextBuilder: (files) =>
      files.isEmpty ? 'Nothing selected' : '${files.length} files selected',
)
```

### Optional Helpful Constraints Info

Show accepted file types and max size derived from your widget options:

```dart
FileUpload(
  pickFiles: onPick,
  allowedExtensions: const ['csv', 'xlsx', 'xls'],
  maxFileSizeBytes: 5 * 1024 * 1024,
  showHelpfulInfo: true,
  options: const FileUploadDragDropOptions(),
)
```

### Optional Loading Surface Modes

Set loading behavior per variant through `options.loading`:

```dart
FileUpload(
  pickFiles: onPick,
  options: FileUploadDragDropOptions(
    loading: const FileUploadLoadingOptions(
      isLoading: true,
      mode: FileUploadLoadingMode.replace,
      loadingWidget: Center(child: Text('Preparing upload...')),
    ),
  ),
)
```

Hide surface while loading:

```dart
FileUpload(
  pickFiles: onPick,
  options: const FileUploadTileOptions(
    loading: FileUploadLoadingOptions(
      isLoading: true,
      mode: FileUploadLoadingMode.hide,
    ),
  ),
)
```

Wrap surface while loading (for `border_loading`-style wrappers):

```dart
FileUpload(
  pickFiles: onPick,
  options: FileUploadTileOptions(
    loading: FileUploadLoadingOptions(
      isLoading: true,
      mode: FileUploadLoadingMode.wrap,
      wrapperBuilder: (context, child) {
        return BorderLoading(child: child);
      },
    ),
  ),
)
```

### Optional File Item Loading Modes

Set list-item loading behavior per parent via variant options:

```dart
FileUpload(
  pickFiles: onPick,
  options: const FileUploadDragDropOptions(
    itemLoading: FileUploadItemLoadingOptions(
      mode: FileUploadItemLoadingMode.linear,
      showForStatuses: {FileUploadItemStatus.uploading},
    ),
  ),
)
```

Use custom per-item loading widget:

```dart
FileUpload(
  pickFiles: onPick,
  options: FileUploadTileOptions(
    itemLoading: FileUploadItemLoadingOptions(
      mode: FileUploadItemLoadingMode.custom,
      customBuilder: (context, item) {
        return Text('Uploading ${item.file.name}...');
      },
    ),
  ),
)
```

If multiple `FileUpload` widgets share one controller, each parent can still
provide its own `itemLoading` style without coupling through the controller.

Customize placement and rendering:

```dart
FileUpload(
  pickFiles: onPick,
  allowedExtensions: const ['pdf'],
  maxFileSizeBytes: 10 * 1024 * 1024,
  showHelpfulInfo: true,
  helpfulInfoPlacement: FileUploadHelpfulInfoPlacement.belowSurface,
  helpfulInfoBuilder: (context, info) => const Text(
    'Accepts PDF • Up to 10 MB',
  ),
)
```

---

## API

- `FileUpload` + `options`:
  - `FileUploadDragDropOptions`
  - `FileUploadTileOptions`
  - `FileUploadMobileOptions`
- `pickFiles` (`FileUploadPickFiles?`)
- `uploadFn` (`UploadFn?`)
- `files` (`List<FileLike>?`), `controller` (`FileUploadController?`)
- `allowMultiple`, `maxFiles`, `maxFileSizeBytes`, `allowedExtensions`, `allowedMimeTypes`
- `maxConcurrentUploads` (`int`, default `1`) for sequential/batched uploads
- `onFilesSelected`, `onFilesChanged`, `onProgress`, `onComplete`, `onError`

---

## Theming

- `FileUploadDropzoneTheme` controls drag-drop surface styling.

---

## Related components

- `dropzone`
- `file_input`
- `linear_progress_indicator`

---

## Registry rules

- One public class per file
- Helpers under `_impl/`
