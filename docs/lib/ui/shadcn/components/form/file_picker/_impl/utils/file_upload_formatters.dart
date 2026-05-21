// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// Maps [FileUploadState] values to [DropzoneState] for shared styling.
DropzoneState _mapDropzoneState(FileUploadState state) {
  switch (state) {
    case FileUploadState.dragging:
      return DropzoneState.dragging;
    case FileUploadState.uploading:
      return DropzoneState.uploading;
    case FileUploadState.success:
      return DropzoneState.success;
    case FileUploadState.error:
      return DropzoneState.error;
    case FileUploadState.disabled:
      return DropzoneState.disabled;
    case FileUploadState.idle:
      return DropzoneState.idle;
  }
}

/// Formats byte counts into human-readable strings.
String _formatFileSize(int bytes) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unitIndex = 0;
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex += 1;
  }
  final value = size < 10 ? size.toStringAsFixed(1) : size.toStringAsFixed(0);
  return '$value ${units[unitIndex]}';
}
