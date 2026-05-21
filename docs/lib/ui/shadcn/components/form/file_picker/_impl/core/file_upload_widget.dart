// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// Internal surface discriminator for [FileUpload] rendering.
enum _FileUploadSurface { dragDrop, tile, mobile }

/// UI-only file upload component with pluggable picking/upload integrations.
class FileUpload extends _FileUpload {
  /// Creates a [FileUpload] widget.
  ///
  /// The `options` parameter selects the surface variant while core behavior
  /// (validation, upload, callbacks, file list rendering) remains shared.
  FileUpload({
    super.key,
    super.title,
    super.subtitle,
    super.hint,
    super.enabled = true,
    super.allowMultiple = true,
    super.withData = true,
    super.maxFiles,
    super.maxFileSizeBytes,
    super.allowedExtensions,
    super.allowedMimeTypes,
    super.files,
    super.controller,
    super.onFilesSelected,
    super.onFilesChanged,
    super.onUploadStart,
    super.onProgress,
    super.onComplete,
    super.onError,
    super.uploadFn,
    super.pickFiles,
    super.itemBuilder,
    super.showFileList = true,
    super.groupListByStatus = true,
    super.itemsLayout = FileUploadItemsLayout.list,
    super.itemsGridColumns = 2,
    super.itemsMaxHeight,
    super.maxConcurrentUploads = 1,
    super.backgroundColor,
    super.borderRadius,
    super.padding,
    super.minHeight,
    super.statusLabels = const FileUploadStatusLabels(),
    super.tileEmptySelectionLabel = 'No file chosen',
    super.tileSelectionTextBuilder,
    super.showHelpfulInfo = false,
    super.helpfulInfoPlacement = FileUploadHelpfulInfoPlacement.automatic,
    super.helpfulInfoBuilder,
    FileUploadOptions options = const FileUploadDragDropOptions(),
  }) : assert(
         maxConcurrentUploads > 0,
         'maxConcurrentUploads must be greater than 0.',
       ),
       assert(
         options is! FileUploadMobileOptions ||
             !options.popover ||
             (options.popoverItems?.isNotEmpty ?? false),
         'popoverItems must be provided and non-empty when mobile popover is enabled.',
       ),
       super._internal(
         surface: _surfaceFromOptions(options),
         loading: _loadingFromOptions(options),
         itemLoading: _itemLoadingFromOptions(options),
         icon: _iconFromOptions(options),
         surfaceSubtitle: _surfaceSubtitleFromOptions(options),
         surfaceHint: _surfaceHintFromOptions(options),
         actionLabel: _actionLabelFromOptions(options),
         enableDragDrop: _enableDragDropFromOptions(options),
         enableDropzoneClick: _enableDropzoneClickFromOptions(options),
         dragDropIdleLabel: _dragDropIdleLabelFromOptions(options),
         dragDropClickToPickLabel: _dragDropClickToPickLabelFromOptions(
           options,
         ),
         dragDropDraggingLabel: _dragDropDraggingLabelFromOptions(options),
         dragDropUploadingLabel: _dragDropUploadingLabelFromOptions(options),
         dragDropSuccessLabel: _dragDropSuccessLabelFromOptions(options),
         dragDropErrorLabel: _dragDropErrorLabelFromOptions(options),
         dragDropDisabledLabel: _dragDropDisabledLabelFromOptions(options),
         dropTargetBuilder: _dropTargetBuilderFromOptions(options),
         mobileMode: _mobileModeFromOptions(options),
         compactIcon: _compactIconFromOptions(options),
         compactTrigger: _compactTriggerFromOptions(options),
         compactButtonLabel: _compactButtonLabelFromOptions(options),
         compactOptions: _compactOptionsFromOptions(options),
       );

  /// Performs `_surfaceFromOptions` logic for this form component.
  static _FileUploadSurface _surfaceFromOptions(FileUploadOptions options) {
    return switch (options.variant) {
      FileUploadVariant.dragDrop => _FileUploadSurface.dragDrop,
      FileUploadVariant.tile => _FileUploadSurface.tile,
      FileUploadVariant.mobile => _FileUploadSurface.mobile,
    };
  }

  /// Performs `_enableDragDropFromOptions` logic for this form component.
  static bool _enableDragDropFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.enableDragDrop;
    }
    return false;
  }

  /// Performs `_enableDropzoneClickFromOptions` logic for this form component.
  static bool _enableDropzoneClickFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.enableDropzoneClick;
    }
    return false;
  }

  static FileUploadDropTargetBuilder? _dropTargetBuilderFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadDragDropOptions) {
      return options.dropTargetBuilder;
    }
    return null;
  }

  /// Performs `_actionLabelFromOptions` logic for this form component.
  static String? _actionLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadTileOptions) {
      return options.actionLabel;
    }
    return null;
  }

  /// Performs `_surfaceSubtitleFromOptions` logic for this form component.
  static Widget? _surfaceSubtitleFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.subtitle;
    }
    if (options is FileUploadTileOptions) {
      return options.subtitle;
    }
    return null;
  }

  /// Performs `_surfaceHintFromOptions` logic for this form component.
  static Widget? _surfaceHintFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.hint;
    }
    if (options is FileUploadTileOptions) {
      return options.hint;
    }
    return null;
  }

  /// Performs `_iconFromOptions` logic for this form component.
  static Widget? _iconFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.icon;
    }
    if (options is FileUploadTileOptions) {
      return options.icon;
    }
    return null;
  }

  static FileUploadLoadingOptions _loadingFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadDragDropOptions) {
      return options.loading;
    }
    if (options is FileUploadTileOptions) {
      return options.loading;
    }
    if (options is FileUploadMobileOptions) {
      return options.loading;
    }
    return const FileUploadLoadingOptions();
  }

  static FileUploadItemLoadingOptions _itemLoadingFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadDragDropOptions) {
      return options.itemLoading;
    }
    if (options is FileUploadTileOptions) {
      return options.itemLoading;
    }
    if (options is FileUploadMobileOptions) {
      return options.itemLoading;
    }
    return const FileUploadItemLoadingOptions();
  }

  /// Performs `_compactIconFromOptions` logic for this form component.
  static Widget? _compactIconFromOptions(FileUploadOptions options) {
    if (options is FileUploadMobileOptions) {
      return options.icon;
    }
    return null;
  }

  static _FileUploadMobileMode _mobileModeFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadMobileOptions && options.popover) {
      return _FileUploadMobileMode.popover;
    }
    return _FileUploadMobileMode.button;
  }

  static FileUploadCompactTrigger _compactTriggerFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadMobileOptions) {
      return options.trigger;
    }
    return FileUploadCompactTrigger.icon;
  }

  /// Performs `_compactButtonLabelFromOptions` logic for this form component.
  static String? _compactButtonLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadMobileOptions) {
      return options.buttonLabel;
    }
    return null;
  }

  static List<FileUploadPickOption>? _compactOptionsFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadMobileOptions) {
      return options.popoverItems;
    }
    return null;
  }

  /// Performs `_dragDropIdleLabelFromOptions` logic for this form component.
  static String? _dragDropIdleLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.idleLabel;
    }
    return null;
  }

  static String? _dragDropClickToPickLabelFromOptions(
    FileUploadOptions options,
  ) {
    if (options is FileUploadDragDropOptions) {
      return options.clickToPickLabel;
    }
    return null;
  }

  /// Performs `_dragDropDraggingLabelFromOptions` logic for this form component.
  static String? _dragDropDraggingLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.draggingLabel;
    }
    return null;
  }

  /// Performs `_dragDropUploadingLabelFromOptions` logic for this form component.
  static String? _dragDropUploadingLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.uploadingLabel;
    }
    return null;
  }

  /// Performs `_dragDropSuccessLabelFromOptions` logic for this form component.
  static String? _dragDropSuccessLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.successLabel;
    }
    return null;
  }

  /// Performs `_dragDropErrorLabelFromOptions` logic for this form component.
  static String? _dragDropErrorLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.errorLabel;
    }
    return null;
  }

  /// Performs `_dragDropDisabledLabelFromOptions` logic for this form component.
  static String? _dragDropDisabledLabelFromOptions(FileUploadOptions options) {
    if (options is FileUploadDragDropOptions) {
      return options.disabledLabel;
    }
    return null;
  }
}

/// Internal shared widget used by [FileUpload] after option mapping.
class _FileUpload extends StatefulWidget {
  /// Constructs `_FileUpload` using the `_internal` named constructor.
  const _FileUpload._internal({
    super.key,
    required this.surface,
    this.loading = const FileUploadLoadingOptions(),
    this.itemLoading = const FileUploadItemLoadingOptions(),
    this.title,
    this.subtitle,
    this.hint,
    this.surfaceSubtitle,
    this.surfaceHint,
    this.icon,
    this.enableDragDrop = false,
    this.enableDropzoneClick = false,
    this.dragDropIdleLabel,
    this.dragDropClickToPickLabel,
    this.dragDropDraggingLabel,
    this.dragDropUploadingLabel,
    this.dragDropSuccessLabel,
    this.dragDropErrorLabel,
    this.dragDropDisabledLabel,
    this.actionLabel,
    this.enabled = true,
    this.allowMultiple = true,
    this.withData = true,
    this.maxFiles,
    this.maxFileSizeBytes,
    this.allowedExtensions,
    this.allowedMimeTypes,
    this.files,
    this.controller,
    this.onFilesSelected,
    this.onFilesChanged,
    this.onUploadStart,
    this.onProgress,
    this.onComplete,
    this.onError,
    this.uploadFn,
    this.pickFiles,
    this.dropTargetBuilder,
    this.itemBuilder,
    this.showFileList = true,
    this.groupListByStatus = true,
    this.itemsLayout = FileUploadItemsLayout.list,
    this.itemsGridColumns = 2,
    this.itemsMaxHeight,
    this.maxConcurrentUploads = 1,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.statusLabels = const FileUploadStatusLabels(),
    this.tileEmptySelectionLabel = 'No file chosen',
    this.tileSelectionTextBuilder,
    this.showHelpfulInfo = false,
    this.helpfulInfoPlacement = FileUploadHelpfulInfoPlacement.automatic,
    this.helpfulInfoBuilder,
    this.mobileMode = _FileUploadMobileMode.button,
    this.compactIcon,
    this.compactTrigger = FileUploadCompactTrigger.icon,
    this.compactButtonLabel,
    this.compactOptions,
  });

  /// Field storing `surface` for this form implementation.
  final _FileUploadSurface surface;

  /// Field storing `loading` for this form implementation.
  final FileUploadLoadingOptions loading;

  /// Field storing `itemLoading` for this form implementation.
  final FileUploadItemLoadingOptions itemLoading;

  /// Field storing `title` for this form implementation.
  final Widget? title;

  /// Field storing `subtitle` for this form implementation.
  final Widget? subtitle;

  /// Field storing `hint` for this form implementation.
  final Widget? hint;

  /// Field storing `surfaceSubtitle` for this form implementation.
  final Widget? surfaceSubtitle;

  /// Field storing `surfaceHint` for this form implementation.
  final Widget? surfaceHint;

  /// Field storing `icon` for this form implementation.
  final Widget? icon;

  /// Field storing `actionLabel` for this form implementation.
  final String? actionLabel;

  /// Field storing `enableDragDrop` for this form implementation.
  final bool enableDragDrop;

  /// Field storing `enableDropzoneClick` for this form implementation.
  final bool enableDropzoneClick;

  /// Field storing `dragDropIdleLabel` for this form implementation.
  final String? dragDropIdleLabel;

  /// Field storing `dragDropClickToPickLabel` for this form implementation.
  final String? dragDropClickToPickLabel;

  /// Field storing `dragDropDraggingLabel` for this form implementation.
  final String? dragDropDraggingLabel;

  /// Field storing `dragDropUploadingLabel` for this form implementation.
  final String? dragDropUploadingLabel;

  /// Field storing `dragDropSuccessLabel` for this form implementation.
  final String? dragDropSuccessLabel;

  /// Field storing `dragDropErrorLabel` for this form implementation.
  final String? dragDropErrorLabel;

  /// Field storing `dragDropDisabledLabel` for this form implementation.
  final String? dragDropDisabledLabel;

  /// Field storing `enabled` for this form implementation.
  final bool enabled;

  /// Field storing `allowMultiple` for this form implementation.
  final bool allowMultiple;

  /// Field storing `withData` for this form implementation.
  final bool withData;

  /// Field storing `maxFiles` for this form implementation.
  final int? maxFiles;

  /// Field storing `maxFileSizeBytes` for this form implementation.
  final int? maxFileSizeBytes;

  /// Field storing `allowedExtensions` for this form implementation.
  final List<String>? allowedExtensions;

  /// Field storing `allowedMimeTypes` for this form implementation.
  final List<String>? allowedMimeTypes;

  /// Field storing `files` for this form implementation.
  final List<FileLike>? files;

  /// Controller used to coordinate `controller` behavior.
  final FileUploadController? controller;

  /// Callback invoked for `onFilesSelected` events.
  final ValueChanged<List<FileLike>>? onFilesSelected;

  /// Callback invoked for `onFilesChanged` events.
  final ValueChanged<List<FileLike>>? onFilesChanged;

  /// Callback invoked for `onUploadStart` events.
  final VoidCallback? onUploadStart;
  final void Function(FileLike file, double progress)? onProgress;

  /// Callback invoked for `onComplete` events.
  final ValueChanged<List<FileLike>>? onComplete;

  /// Callback invoked for `onError` events.
  final ValueChanged<FileUploadError>? onError;

  /// Field storing `uploadFn` for this form implementation.
  final UploadFn? uploadFn;

  /// Field storing `pickFiles` for this form implementation.
  final FileUploadPickFiles? pickFiles;

  /// Field storing `dropTargetBuilder` for this form implementation.
  final FileUploadDropTargetBuilder? dropTargetBuilder;

  final Widget Function(BuildContext context, FileUploadItem item)? itemBuilder;

  /// Field storing `showFileList` for this form implementation.
  final bool showFileList;

  /// Field storing `groupListByStatus` for this form implementation.
  final bool groupListByStatus;

  /// Field storing `itemsLayout` for this form implementation.
  final FileUploadItemsLayout itemsLayout;

  /// Field storing `itemsGridColumns` for this form implementation.
  final int itemsGridColumns;

  /// Field storing `itemsMaxHeight` for this form implementation.
  final double? itemsMaxHeight;

  /// Field storing `maxConcurrentUploads` for this form implementation.
  final int maxConcurrentUploads;

  /// Field storing `backgroundColor` for this form implementation.
  final Color? backgroundColor;

  /// Field storing `borderRadius` for this form implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Field storing `padding` for this form implementation.
  final EdgeInsetsGeometry? padding;

  /// Field storing `minHeight` for this form implementation.
  final double? minHeight;

  /// Field storing `statusLabels` for this form implementation.
  final FileUploadStatusLabels statusLabels;

  /// Field storing `tileEmptySelectionLabel` for this form implementation.
  final String tileEmptySelectionLabel;

  /// Field storing `tileSelectionTextBuilder` for this form implementation.
  final FileUploadTileSelectionTextBuilder? tileSelectionTextBuilder;

  /// Field storing `showHelpfulInfo` for this form implementation.
  final bool showHelpfulInfo;

  /// Field storing `helpfulInfoPlacement` for this form implementation.
  final FileUploadHelpfulInfoPlacement helpfulInfoPlacement;

  /// Field storing `helpfulInfoBuilder` for this form implementation.
  final FileUploadHelpfulInfoBuilder? helpfulInfoBuilder;

  /// Field storing `mobileMode` for this form implementation.
  final _FileUploadMobileMode mobileMode;

  /// Field storing `compactIcon` for this form implementation.
  final Widget? compactIcon;

  /// Field storing `compactTrigger` for this form implementation.
  final FileUploadCompactTrigger compactTrigger;

  /// Field storing `compactButtonLabel` for this form implementation.
  final String? compactButtonLabel;

  /// Field storing `compactOptions` for this form implementation.
  final List<FileUploadPickOption>? compactOptions;

  /// Creates the `State` object for this widget.
  @override
  State<_FileUpload> createState() => _FileUploadState();
}
