// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// Visual trigger style used by the compact/mobile file picker variant.
enum FileUploadCompactTrigger { icon, button }

/// Available top-level layouts for [FileUpload].
enum FileUploadVariant { dragDrop, tile, mobile }

/// Loading behavior for the file upload surface.
enum FileUploadLoadingMode { replace, hide, wrap }

/// Loading behavior for file items in the uploaded list.
enum FileUploadItemLoadingMode { linear, none, custom }

/// Internal mode for compact/mobile picker rendering.
enum _FileUploadMobileMode { button, popover }

/// Shared options contract for all [FileUpload] variants.
abstract class FileUploadOptions {
  const FileUploadOptions();

  /// Declares which surface should be rendered.
  FileUploadVariant get variant;
}

/// Options for desktop-style dropzone upload surface.
class FileUploadDragDropOptions extends FileUploadOptions {
  const FileUploadDragDropOptions({
    this.enableDragDrop = true,
    this.enableDropzoneClick = true,
    this.dropTargetBuilder,
    this.icon,
    this.subtitle,
    this.hint,
    this.idleLabel,
    this.clickToPickLabel,
    this.draggingLabel,
    this.uploadingLabel,
    this.successLabel,
    this.errorLabel,
    this.disabledLabel,
    this.loading = const FileUploadLoadingOptions(),
    this.itemLoading = const FileUploadItemLoadingOptions(),
  });

  /// Enables built-in drag/drop intake where the current platform supports it.
  final bool enableDragDrop;

  /// Allows tapping the dropzone to invoke [FileUploadPickFiles].
  final bool enableDropzoneClick;

  /// Optional wrapper that can replace the built-in drop target.
  final FileUploadDropTargetBuilder? dropTargetBuilder;

  /// Optional icon shown in the drag-drop surface.
  final Widget? icon;

  /// Optional subtitle shown inside the drag-drop surface.
  final Widget? subtitle;

  /// Optional hint shown inside the drag-drop surface.
  final Widget? hint;

  /// Override label for idle state when drag-and-drop is enabled.
  final String? idleLabel;

  /// Override label for idle state when click-only mode is active.
  final String? clickToPickLabel;

  /// Override label for active dragging state.
  final String? draggingLabel;

  /// Override label while upload is in progress.
  final String? uploadingLabel;

  /// Override label when uploads are complete.
  final String? successLabel;

  /// Override label when the component has errors.
  final String? errorLabel;

  /// Override label when uploads are disabled.
  final String? disabledLabel;

  /// Loading presentation for the dropzone container.
  final FileUploadLoadingOptions loading;

  /// Loading presentation for file items list.
  final FileUploadItemLoadingOptions itemLoading;

  /// Field storing `variant` for this form implementation.
  @override
  FileUploadVariant get variant => FileUploadVariant.dragDrop;
}

/// Options for compact tile-style picker (no drag-and-drop behavior).
class FileUploadTileOptions extends FileUploadOptions {
  const FileUploadTileOptions({
    this.actionLabel,
    this.icon,
    this.subtitle,
    this.hint,
    this.loading = const FileUploadLoadingOptions(),
    this.itemLoading = const FileUploadItemLoadingOptions(),
  });

  /// Label used by the tile action segment.
  final String? actionLabel;

  /// Optional icon if tile visuals include one in future updates.
  final Widget? icon;

  /// Optional subtitle shown in empty selection slot.
  final Widget? subtitle;

  /// Optional hint shown below the tile surface.
  final Widget? hint;

  /// Loading presentation for the tile container.
  final FileUploadLoadingOptions loading;

  /// Loading presentation for file items list.
  final FileUploadItemLoadingOptions itemLoading;

  /// Field storing `variant` for this form implementation.
  @override
  FileUploadVariant get variant => FileUploadVariant.tile;
}

/// Options for mobile-friendly trigger surfaces.
class FileUploadMobileOptions extends FileUploadOptions {
  const FileUploadMobileOptions({
    this.popover = false,
    this.popoverItems,
    this.icon,
    this.trigger = FileUploadCompactTrigger.icon,
    this.buttonLabel,
    this.loading = const FileUploadLoadingOptions(),
    this.itemLoading = const FileUploadItemLoadingOptions(),
  }) : assert(
         !popover || popoverItems != null,
         'popoverItems must be provided when popover is true.',
       );

  /// Shows a popover list of [popoverItems] when true.
  final bool popover;

  /// Menu actions available in popover mode.
  final List<FileUploadPickOption>? popoverItems;

  /// Trigger icon used for compact trigger layouts.
  final Widget? icon;

  /// Trigger type used for compact mode.
  final FileUploadCompactTrigger trigger;

  /// Label used when [trigger] is [FileUploadCompactTrigger.button].
  final String? buttonLabel;

  /// Loading presentation for compact trigger surface.
  final FileUploadLoadingOptions loading;

  /// Loading presentation for file items list.
  final FileUploadItemLoadingOptions itemLoading;

  /// Field storing `variant` for this form implementation.
  @override
  FileUploadVariant get variant => FileUploadVariant.mobile;
}

/// Represents one picker action in compact popover menus.
class FileUploadPickOption {
  const FileUploadPickOption({
    required this.id,
    required this.label,
    this.icon,
    this.allowMultiple,
    this.withData,
    this.allowedExtensions,
    this.allowedMimeTypes,
  });

  /// Stable action id for analytics or matching.
  final String id;

  /// User-facing label.
  final String label;

  /// Optional action icon.
  final Widget? icon;

  /// Overrides [FileUpload.allowMultiple] for this action.
  final bool? allowMultiple;

  /// Overrides [FileUpload.withData] for this action.
  final bool? withData;

  /// Overrides [FileUpload.allowedExtensions] for this action.
  final List<String>? allowedExtensions;

  /// Overrides [FileUpload.allowedMimeTypes] for this action.
  final List<String>? allowedMimeTypes;

  /// Generic file action.
  static const FileUploadPickOption pickFiles = FileUploadPickOption(
    id: 'pick_files',
    label: 'Pick files',
    icon: Icon(RadixIcons.file),
  );

  /// Images-only action.
  static const FileUploadPickOption pickImages = FileUploadPickOption(
    id: 'pick_images',
    label: 'Pick images',
    icon: Icon(RadixIcons.image),
    allowedMimeTypes: ['image/*'],
  );
}

/// Builder used to customize the drop target wrapper.
typedef FileUploadDropTargetBuilder =
    Widget Function({
      required Widget child,
      required bool enabled,
      required bool withData,
      required ValueChanged<bool> onDragActive,
      required ValueChanged<List<FileLike>> onDrop,
      VoidCallback? onTap,
    });

/// Wrap builder used in [FileUploadLoadingMode.wrap].
typedef FileUploadLoadingWrapperBuilder =
    Widget Function(BuildContext context, Widget child);

/// Configures how a surface behaves while loading.
class FileUploadLoadingOptions {
  const FileUploadLoadingOptions({
    this.isLoading = false,
    this.mode = FileUploadLoadingMode.replace,
    this.loadingWidget,
    this.wrapperBuilder,
    this.disableInteractions = true,
  });

  /// Enables loading behavior when true.
  final bool isLoading;

  /// Loading presentation mode.
  final FileUploadLoadingMode mode;

  /// Widget used for replace or wrap-overlay loading display.
  final Widget? loadingWidget;

  /// Builder used to wrap the surface in [FileUploadLoadingMode.wrap].
  final FileUploadLoadingWrapperBuilder? wrapperBuilder;

  /// Disables pointer interactions while loading.
  final bool disableInteractions;
}

/// Builder used in [FileUploadItemLoadingMode.custom].
typedef FileUploadItemLoadingBuilder =
    Widget Function(BuildContext context, FileUploadItem item);

/// Configures loading visuals for file list items.
class FileUploadItemLoadingOptions {
  const FileUploadItemLoadingOptions({
    this.mode = FileUploadItemLoadingMode.linear,
    this.showForStatuses = const {FileUploadItemStatus.uploading},
    this.customBuilder,
  });

  /// Indicator mode for item loading visuals.
  final FileUploadItemLoadingMode mode;

  /// Statuses for which the loading indicator should be rendered.
  final Set<FileUploadItemStatus> showForStatuses;

  /// Custom loading widget builder when [mode] is `custom`.
  final FileUploadItemLoadingBuilder? customBuilder;
}

/// Builder used to control tile text for selected files.
typedef FileUploadTileSelectionTextBuilder =
    String Function(List<FileLike> files);

/// Placement options for the optional helpful info text.
enum FileUploadHelpfulInfoPlacement { automatic, belowSurface, insideSurface }

/// Snapshot of acceptance constraints used by helpful info builders.
class FileUploadHelpfulInfoData {
  const FileUploadHelpfulInfoData({
    required this.allowMultiple,
    required this.maxFiles,
    required this.maxFileSizeBytes,
    required this.allowedExtensions,
    required this.allowedMimeTypes,
  });

  /// Field storing `allowMultiple` for this form implementation.
  final bool allowMultiple;

  /// Field storing `maxFiles` for this form implementation.
  final int? maxFiles;

  /// Field storing `maxFileSizeBytes` for this form implementation.
  final int? maxFileSizeBytes;

  /// Field storing `allowedExtensions` for this form implementation.
  final List<String>? allowedExtensions;

  /// Field storing `allowedMimeTypes` for this form implementation.
  final List<String>? allowedMimeTypes;
}

/// Builder used to render optional helpful info for constraints/limits.
typedef FileUploadHelpfulInfoBuilder =
    Widget Function(BuildContext context, FileUploadHelpfulInfoData info);

/// Customizable labels for status sections and badges.
class FileUploadStatusLabels {
  const FileUploadStatusLabels({
    this.uploading = 'Uploading',
    this.completed = 'Completed',
    this.waiting = 'Queued',
    this.failed = 'Failed',
  });

  /// Field storing `uploading` for this form implementation.
  final String uploading;

  /// Field storing `completed` for this form implementation.
  final String completed;

  /// Field storing `waiting` for this form implementation.
  final String waiting;

  /// Field storing `failed` for this form implementation.
  final String failed;

  /// Maps status enum values to user-facing labels.
  String resolve(FileUploadItemStatus status) {
    switch (status) {
      case FileUploadItemStatus.uploading:
        return uploading;
      case FileUploadItemStatus.success:
        return completed;
      case FileUploadItemStatus.error:
        return failed;
      case FileUploadItemStatus.idle:
        return waiting;
    }
  }
}
