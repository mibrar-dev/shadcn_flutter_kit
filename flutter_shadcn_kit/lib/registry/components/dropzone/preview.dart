// Named examples for the `dropzone` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'dropzone.dart';

/// The idle zone, with the browse action.
Widget _dropzoneDefault(BuildContext context) {
  return const Dropzone(
    hint: Text('Up to 10 MB each.'),
    onBrowse: _dropzoneBrowse,
  );
}

void _dropzoneBrowse() {}

/// The zone while a drag hovers over it.
Widget _dropzoneDragOver(BuildContext context) {
  return const Dropzone(
    isDragOver: true,
    hint: Text('Release to upload.'),
    onBrowse: _dropzoneBrowse,
  );
}

/// The uploading state, then a success one.
Widget _dropzoneUploading(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: const <Widget>[
      Dropzone(state: DropzoneState.uploading),
      SizedBox(height: 24),
      Dropzone(state: DropzoneState.success),
    ],
  );
}

/// The error state plus the disabled one.
Widget _dropzoneError(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: const <Widget>[
      Dropzone(state: DropzoneState.error),
      SizedBox(height: 24),
      Dropzone(enabled: false),
    ],
  );
}

/// The zone with a custom hint instead of the default content.
Widget _dropzoneCustom(BuildContext context) {
  return const Dropzone(
    showAction: false,
    content: Text('Drop a folder here to upload it whole.'),
  );
}

/// Named docs examples for `dropzone`; the first entry is the default.
const List<ComponentPreview> dropzonePreviews = <ComponentPreview>[
  ComponentPreview('Default', _dropzoneDefault),
  ComponentPreview('Drag over', _dropzoneDragOver),
  ComponentPreview('Uploading', _dropzoneUploading),
  ComponentPreview('Error', _dropzoneError),
  ComponentPreview('Custom content', _dropzoneCustom),
];
