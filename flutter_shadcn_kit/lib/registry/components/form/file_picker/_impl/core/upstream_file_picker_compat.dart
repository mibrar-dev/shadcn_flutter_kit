// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// Upstream-compatible file picker stub.
///
/// **Work in Progress** — mirrors the upstream `FilePicker` API so callers of
/// the upstream API compile. The registry's fully-implemented file upload
/// system is [FileUpload] (with [FileUploadDragDropOptions],
/// [FileUploadTileOptions] and [FileUploadMobileOptions]); prefer it for real
/// UI.
///
/// Like upstream, [build] throws [UnimplementedError]: there is no faithful
/// mapping from upstream's arbitrary `children: List<Widget>` + [onAdd] model
/// onto the [FileUpload] controller/files model, so this shim preserves the
/// upstream constructor surface for compilation rather than rendering.
///
/// Upstream parity: ported from `file_picker.dart` upstream.
@Deprecated(
  'Upstream API-compat shim; use FileUpload with FileUpload*Options instead.',
)
class FilePicker extends StatelessWidget {
  /// Title widget displayed above the file picker.
  final Widget? title;

  /// Subtitle widget displayed below the title.
  final Widget? subtitle;

  /// Whether drag-and-drop functionality is enabled.
  final bool hotDropEnabled;

  /// Whether a drag-and-drop operation is currently in progress.
  final bool hotDropping;

  /// List of file item widgets to display.
  final List<Widget> children;

  /// Callback when the add file button is pressed.
  final VoidCallback? onAdd;

  /// Creates a [FilePicker].
  ///
  /// Parameters:
  /// - [title] (`Widget?`, optional): Title displayed above picker.
  /// - [subtitle] (`Widget?`, optional): Subtitle below title.
  /// - [hotDropEnabled] (`bool`, default: `false`): Enable drag-and-drop.
  /// - [hotDropping] (`bool`, default: `false`): Currently dropping files.
  /// - [onAdd] (`VoidCallback?`, optional): Called when add button pressed.
  /// - [children] (`List<Widget>`, required): File item widgets.
  const FilePicker({
    super.key,
    this.title,
    this.subtitle,
    this.hotDropEnabled = false,
    this.hotDropping = false,
    this.onAdd,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// Upstream-compatible file item stub.
///
/// Mirrors the upstream `FileItem` constructor surface (widget-based
/// `fileName`/`fileSize`/`fileType` plus `uploadProgress` and action
/// callbacks) so callers of the upstream API compile.
///
/// Named [UpstreamFileItem] — rather than `FileItem` — because the registry's
/// [FileItem] name is already taken by the `FileUpload*` system's item widget
/// (which takes a [FileUploadItem] model). For registry UI, prefer [FileItem]
/// with [FileUploadItem]; use [UpstreamFileItem] only when porting upstream
/// call sites.
///
/// Like upstream, [build] throws [UnimplementedError].
///
/// Upstream parity: ported from `file_picker.dart` upstream.
@Deprecated(
  'Upstream API-compat shim; use FileItem with a FileUploadItem instead.',
)
class UpstreamFileItem extends StatelessWidget {
  /// Upload progress from 0.0 to 1.0, or null if not uploading.
  final double? uploadProgress;

  /// Called when the remove button is pressed.
  final VoidCallback? onRemove;

  /// Called when the retry button is pressed (for failed uploads).
  final VoidCallback? onRetry;

  /// Called when the download button is pressed.
  final VoidCallback? onDownload;

  /// Optional thumbnail widget for the file.
  final Widget? thumbnail;

  /// Called when the preview button is pressed.
  final VoidCallback? onPreview;

  /// Widget displaying the file name.
  final Widget fileName;

  /// Optional widget displaying the file size.
  final Widget? fileSize;

  /// Optional widget displaying the file type/format.
  final Widget? fileType;

  /// Creates an [UpstreamFileItem] with the upstream `FileItem` signature.
  const UpstreamFileItem({
    super.key,
    this.uploadProgress,
    this.onRemove,
    this.onRetry,
    this.onDownload,
    this.thumbnail,
    this.onPreview,
    required this.fileName,
    this.fileSize,
    this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
