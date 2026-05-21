// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import 'file_drop_adapter_stub.dart'
    if (dart.library.html) 'file_drop_adapter_web.dart'
    if (dart.library.io) 'file_drop_adapter_io.dart';
import 'file_like.dart';

/// Platform adapter for drag/drop intake.
///
/// This does not open a file picker. Picker selection remains controlled by
/// the consumer-provided `pickFiles` callback.
abstract class FileDropAdapter {
  bool get supportsDragDrop;

  Widget buildDropTarget({
    required Widget child,
    required bool enabled,
    required bool withData,
    required ValueChanged<bool> onDragActive,
    required ValueChanged<List<FileLike>> onDrop,
    VoidCallback? onTap,
  });
}

FileDropAdapter createFileDropAdapter() => createAdapter();
