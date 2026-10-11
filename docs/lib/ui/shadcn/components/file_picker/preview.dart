// Named examples for the `file_picker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Each example
// owns its controller, so no state is shared between examples. The fixed width
// is inherent: the dropzone surface stretches (`double.infinity`), so the
// example must hand it a bounded box.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'file_picker.dart';

/// Fake platform picker used by the examples.
Future<List<FileValue>> _fakePick(FileUploadPickRequest request) async {
  return <FileValue>[
    const FileValue(
      id: 'pick-pdf',
      name: 'report.pdf',
      size: 482000,
      mimeType: 'application/pdf',
    ),
    if (request.allowMultiple)
      const FileValue(
        id: 'pick-png',
        name: 'photo.png',
        size: 1200000,
        mimeType: 'image/png',
      ),
  ];
}

/// Items caught mid-upload, showing the transfer states.
List<FileItem> _uploadingItems() {
  return <FileItem>[
    const FileItem(
      file: FileValue(id: 'queued', name: 'notes.txt', size: 1200),
    ),
    FileItem(
      file: const FileValue(id: 'uploading', name: 'design.pdf', size: 842000),
      status: FileStatus.uploading,
      progress: 0.45,
    ),
  ];
}

/// Settled items for the compact surfaces.
List<FileItem> _settledItems() {
  return <FileItem>[
    const FileItem(
      file: FileValue(id: 'queued', name: 'notes.txt', size: 1200),
    ),
    FileItem(
      file: const FileValue(id: 'settled', name: 'archive.zip', size: 5400000),
      status: FileStatus.success,
      progress: 1,
    ),
  ];
}

/// Drag-and-drop surface with a live transfer list.
class _DropzoneExample extends StatefulWidget {
  const _DropzoneExample();

  @override
  State<_DropzoneExample> createState() => _DropzoneExampleState();
}

class _DropzoneExampleState extends State<_DropzoneExample> {
  late final FileUploadController _controller = FileUploadController(
    initialItems: _uploadingItems(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: FileUpload(
        pick: _fakePick,
        controller: _controller,
        upload: (_) => const Stream<double>.empty(),
      ),
    );
  }
}

Widget _dropzone(BuildContext context) => const _DropzoneExample();

/// One-line picker tile (label + chosen file name).
class _TileExample extends StatefulWidget {
  const _TileExample();

  @override
  State<_TileExample> createState() => _TileExampleState();
}

class _TileExampleState extends State<_TileExample> {
  late final FileUploadController _controller = FileUploadController(
    initialItems: _settledItems(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: FileUpload(
        variant: FileUploadVariant.tile,
        pick: _fakePick,
        controller: _controller,
      ),
    );
  }
}

Widget _tile(BuildContext context) => const _TileExample();

/// Compact trigger for small layouts.
Widget _trigger(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: FileUpload(variant: FileUploadVariant.mobile, pick: _fakePick),
  );
}

/// Named docs examples for `file_picker`; the first entry is the default.
const List<ComponentPreview> filePickerPreviews = <ComponentPreview>[
  ComponentPreview('Dropzone', _dropzone),
  ComponentPreview('Tile', _tile),
  ComponentPreview('Trigger', _trigger),
];
