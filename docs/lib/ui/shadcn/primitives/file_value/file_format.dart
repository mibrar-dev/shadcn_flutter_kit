// Presentation data for the file components: loading modes, the status labels
// and the byte-size formatter.
//
// Ported from the old `form/file_picker/_impl/core/file_upload_options.dart`
// (loading modes, status labels) and
// `_impl/utils/file_upload_formatters.dart` (the byte-size formatter).

import 'dart:math' as math;

import 'file_value.dart';

/// How a surface presents itself while loading.
enum FileSurfaceLoadingMode {
  /// Swap the surface content for the loading widget.
  replace,

  /// Hide the surface entirely.
  hide,

  /// Keep the surface visible under a wrapper.
  wrap,
}

/// How a file row presents its transfer progress.
enum FileItemLoadingMode {
  /// A determinate linear progress bar.
  linear,

  /// No indicator.
  none,

  /// A component-supplied widget.
  custom,
}

/// Statuses a row's loading indicator is rendered for.
const Set<FileStatus> defaultFileItemLoadingStatuses = <FileStatus>{
  FileStatus.uploading,
};

/// Labels for the transfer states.
///
/// The defaults are the shadcn English wording; a localized component reads
/// `ShadcnLocalizations` and passes translated values instead.
class FileStatusLabels {
  /// Creates a label set.
  const FileStatusLabels({
    this.queued = 'Queued',
    this.uploading = 'Uploading',
    this.completed = 'Completed',
    this.failed = 'Failed',
  });

  /// Label for [FileStatus.queued].
  final String queued;

  /// Label for [FileStatus.uploading].
  final String uploading;

  /// Label for [FileStatus.success].
  final String completed;

  /// Label for [FileStatus.error].
  final String failed;

  /// The label for [status].
  String resolve(FileStatus status) => switch (status) {
    FileStatus.queued => queued,
    FileStatus.uploading => uploading,
    FileStatus.success => completed,
    FileStatus.error => failed,
  };
}

/// Formats a byte count the way a file row shows it.
///
/// The old `_formatFileSize` used one significant digit below ten units and
/// none above, so 1024 bytes read `1.0 KB` and 9.99 MB read `10.0 MB` while
/// 1023 B could round up to `1024 B`. This keeps the same unit ladder but never
/// rounds into the next unit.
String formatFileSize(int bytes, {int decimals = 1}) {
  if (bytes <= 0) {
    return '0 B';
  }
  const units = <String>['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unitIndex = 0;
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex += 1;
  }
  if (unitIndex == 0) {
    return '${size.round()} ${units[unitIndex]}';
  }
  // Round down so 1023.99 KB stays 1023.9 KB instead of becoming 1024.0 KB.
  final factor = math.pow(10, decimals);
  final truncated = (size * factor).floor() / factor;
  return '${truncated.toStringAsFixed(decimals)} ${units[unitIndex]}';
}
