// The `file_picker` component: [FileUpload] — a file selection surface
// (dropzone, tile or compact trigger) with validation, an upload queue and the
// `FileUploadRow` list from `primitives/file_value`.
//
// Ported from `components/form/file_picker/**` + `components/form/file_input`.
// Platform picking and drag intake are caller-supplied callbacks; the engine,
// row, items view and row theme live in `primitives/file_value`.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/radix_icons.dart';
import '../../primitives/clickable.dart';
import '../../primitives/file_value/file_upload_controller.dart';
import '../../primitives/file_value/file_upload_items_view.dart';
import '../../primitives/file_value/file_upload_row.dart';
import '../../primitives/file_value/file_value.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../dropzone/dropzone.dart';
import '../progress/progress.dart';
import 'file_picker_style.dart';

export 'file_picker_style.dart';
export '../../primitives/file_value/file_upload_controller.dart'
    show FileUploadController, FileUploadFn, FileUploadMessage;
export '../../primitives/file_value/file_upload_items_view.dart'
    show FileUploadItemBuilder, FileUploadItemsLayout, FileUploadItemsView;
export '../../primitives/file_value/file_upload_row.dart'
    show FileUploadIconBuilder, FileUploadRow, defaultFileIcon;
export '../../primitives/file_value/file_upload_row_theme.dart'
    show FileUploadRowTheme, fileUploadRowDefaults;
export '../../primitives/file_value/file_format.dart' show FileStatusLabels;
export '../../primitives/file_value/file_value.dart'
    show
        FileConstraints,
        FileError,
        FileErrorCode,
        FileItem,
        FileStatus,
        FileValue;

const ValueKey<String> fileUploadTileKey = ValueKey<String>(
  'shadcn.fileUpload.tile',
);

class FileUploadPickRequest {
  /// Creates a pick request.
  const FileUploadPickRequest({
    required this.allowMultiple,
    this.allowedExtensions,
    this.allowedMimeTypes,
  });
  final bool allowMultiple;
  final List<String>? allowedExtensions;
  final List<String>? allowedMimeTypes;
}

/// Opens the platform picker; the caller owns the platform code.
typedef FileUploadPick =
    Future<List<FileValue>> Function(FileUploadPickRequest request);

typedef FileUploadDropTargetBuilder =
    Widget Function({
      required Widget child,
      required bool enabled,
      required ValueChanged<bool> onDragActive,
      required ValueChanged<List<FileValue>> onDrop,
      VoidCallback? onTap,
    });

class FileUpload extends StatefulWidget {
  const FileUpload({
    super.key,
    this.variant = FileUploadVariant.dragDrop,
    this.controller,
    this.constraints = const FileConstraints(),
    this.pick,
    this.upload,
    this.dropTargetBuilder,
    this.onFilesChanged,
    this.onComplete,
    this.onError,
    this.layout = FileUploadItemsLayout.list,
    this.gridColumns = 2,
    this.groupKey,
    this.groupHeaderBuilder,
    this.iconBuilder,
    this.itemsMaxHeight,
    this.maxConcurrentUploads = 1,
    this.enabled = true,
    this.theme,
  });
  final FileUploadVariant variant;
  final FileUploadController? controller;
  final FileConstraints constraints;
  final FileUploadPick? pick;
  final FileUploadFn? upload;

  /// Platform drag intake wrapper; null leaves the dropzone click-only.
  final FileUploadDropTargetBuilder? dropTargetBuilder;
  final ValueChanged<List<FileValue>>? onFilesChanged;
  final ValueChanged<List<FileValue>>? onComplete;
  final ValueChanged<FileError>? onError;
  final FileUploadItemsLayout layout;
  final int gridColumns;

  /// Groups rows under a header per returned key; null keeps one list.
  final String Function(FileItem item)? groupKey;

  /// Builds a group header; null renders the key as muted text.
  final Widget Function(BuildContext context, String key)? groupHeaderBuilder;

  /// Per-row thumbnail builder; null renders the extension icon.
  final FileUploadIconBuilder? iconBuilder;
  final double? itemsMaxHeight;
  final int maxConcurrentUploads;
  final bool enabled;
  final FileUploadTheme? theme;

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  FileUploadController? _owned;
  bool _dragActive = false;
  bool _focused = false;

  FileUploadController get _controller => widget.controller ?? _owned!;

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  DropzoneState get _dropzoneState {
    if (!widget.enabled) return DropzoneState.disabled;
    if (_dragActive) return DropzoneState.dragging;
    final FileUploadController controller = _controller;
    if (controller.isUploading) return DropzoneState.uploading;
    if (controller.errors.isNotEmpty) return DropzoneState.error;
    final List<FileItem> items = controller.items;
    final bool allDone =
        items.isNotEmpty &&
        items.every((FileItem item) => item.status == FileStatus.success);
    return allDone ? DropzoneState.success : DropzoneState.idle;
  }

  Future<void> _pick() async {
    final FileUploadPick? pick = widget.pick;
    if (!widget.enabled || pick == null) {
      return;
    }
    try {
      final List<FileValue> files = await pick(
        FileUploadPickRequest(
          allowMultiple: widget.constraints.allowMultiple,
          allowedExtensions: widget.constraints.allowedExtensions,
          allowedMimeTypes: widget.constraints.allowedMimeTypes,
        ),
      );
      if (mounted && files.isNotEmpty) {
        _addFiles(files);
      }
    } catch (_) {
      if (!mounted) return;
      final FileError failure = FileError(
        code: FileErrorCode.uploadFailed,
        message: ShadcnLocalizations.of(context).fileUploadPickFailed,
      );
      _controller.reportError(failure);
      widget.onError?.call(failure);
    }
  }

  void _addFiles(List<FileValue> files) {
    if (!widget.enabled) {
      return;
    }
    final added = _controller.addFiles(
      files,
      overrideConstraints: widget.constraints,
    );
    for (final FileError error in _controller.errors) {
      widget.onError?.call(error);
    }
    if (added.isEmpty) {
      return;
    }
    widget.onFilesChanged?.call(_files());
    final FileUploadFn? upload = widget.upload;
    if (upload == null) {
      return;
    }
    _controller.startUploads(
      upload,
      files: added,
      maxConcurrent: widget.maxConcurrentUploads,
      onComplete: widget.onComplete,
      onError: widget.onError,
    );
  }

  void _removeItem(FileItem item) {
    _controller.removeFile(item.file);
    widget.onFilesChanged?.call(_files());
  }

  List<FileValue> _files() => _controller.items
      .map((FileItem item) => item.file)
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      _owned ??= FileUploadController(
        message: (FileErrorCode code, FileValue? file) {
          final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
          return switch (code) {
            FileErrorCode.tooMany => l10n.fileUploadTooMany,
            FileErrorCode.tooLarge => l10n.fileUploadTooLarge,
            FileErrorCode.invalidType => l10n.fileUploadInvalidType,
            FileErrorCode.uploadFailed =>
              file == null
                  ? l10n.fileUploadUploadFailed
                  : l10n.fileUploadUploadFailedFor(file.name),
          };
        },
      );
    }
    return ListenableBuilder(
      listenable: _controller,
      builder: (BuildContext context, Widget? child) => _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final FileUploadTheme style =
        resolveComponentStyle<FileUploadTheme, FileUploadTheme>(
          context,
          widget: widget.theme,
          select: (FileUploadTheme t) => t,
          defaults: fileUploadDefaults,
        );
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double gap = (style.gap ?? 12) * ambient.scaling;
    final List<FileItem> items = _controller.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _surface(context, style, ShadcnLocalizations.of(context)),
        if (_controller.errors.isNotEmpty) ...<Widget>[
          Gap(gap),
          for (final FileError error in _controller.errors)
            Text(
              error.message,
              style: ambient.typography.xSmall.copyWith(
                color: ambient.colors.destructive,
              ),
            ),
        ],
        if (items.isNotEmpty) ...<Widget>[
          Gap(gap),
          FileUploadItemsView(
            items: items,
            layout: widget.layout,
            columns: widget.gridColumns,
            groupKey: widget.groupKey,
            groupHeaderBuilder: widget.groupHeaderBuilder,
            iconBuilder: widget.iconBuilder,
            maxHeight: widget.itemsMaxHeight,
            onRemove: _removeItem,
            onRetry: widget.upload == null
                ? null
                : (FileItem item) => _controller.retry(item.file),
            progressBuilder: (FileItem item) =>
                item.status == FileStatus.uploading && item.progress != null
                ? Progress(value: item.progress)
                : null,
          ),
        ],
      ],
    );
  }

  Widget _surface(
    BuildContext context,
    FileUploadTheme style,
    ShadcnLocalizations l10n,
  ) {
    final Widget surface = switch (widget.variant) {
      FileUploadVariant.dragDrop => _dropSurface(),
      FileUploadVariant.tile => _tileSurface(context, style, l10n),
      FileUploadVariant.mobile => Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.md,
        onPressed: widget.enabled && widget.pick != null ? _pick : null,
        leading: Icon(
          RadixIcons.upload,
          size: 16 * ShadcnTheme.of(context).scaling,
        ),
        child: Text(l10n.fileUploadChoose),
      ),
    };
    if (widget.dropTargetBuilder == null) {
      return surface;
    }
    return widget.dropTargetBuilder!(
      child: surface,
      enabled: widget.enabled,
      onDragActive: (bool value) => setState(() => _dragActive = value),
      onDrop: _addFiles,
      onTap: widget.pick == null ? null : _pick,
    );
  }

  Widget _dropSurface() {
    final bool canPick = widget.enabled && widget.pick != null;
    return FocusableActionDetector(
      enabled: canPick,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) => _pick(),
        ),
      },
      onShowFocusHighlight: (bool value) => setState(() => _focused = value),
      child: Dropzone(
        state: _dropzoneState,
        isDragOver: _dragActive,
        enabled: widget.enabled,
        focused: _focused,
        onBrowse: canPick ? _pick : null,
        showAction: canPick,
      ),
    );
  }

  Widget _tileSurface(
    BuildContext context,
    FileUploadTheme style,
    ShadcnLocalizations l10n,
  ) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final List<FileItem> items = _controller.items;
    final String label = items.isEmpty
        ? l10n.fileUploadNoFile
        : items.first.file.name;
    final Color? border = style.borderColor?.resolve(ambient.colors);
    final TextStyle name = ambient.typography.small.copyWith(
      fontWeight: FontWeight.w500,
      color: ambient.colors.foreground,
    );
    final TextStyle meta = ambient.typography.xSmall.copyWith(
      color: ambient.colors.mutedForeground,
    );
    return Clickable(
      enabled: widget.enabled && widget.pick != null,
      onPressed: _pick,
      child: Container(
        key: fileUploadTileKey,
        constraints: BoxConstraints(
          minHeight: (style.minHeight ?? 48) * ambient.scaling,
        ),
        decoration: BoxDecoration(
          color: style.background?.resolve(ambient.colors),
          borderRadius: style.borderRadius ?? ambient.borderRadiusMd,
          border: border == null
              ? null
              : Border.all(color: border, width: style.borderWidth ?? 1),
        ),
        padding: resolveEdgeInsets(
          style.padding ?? fileUploadDefaults.padding!,
          ambient.density.baseContentPadding * ambient.scaling,
        ),
        child: Row(
          children: <Widget>[
            Text(l10n.fileUploadChoose, style: name),
            Gap(12 * ambient.scaling),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: meta,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
