// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// Stateful engine for [FileUpload].
///
/// This class owns the state lifecycle while specialized behaviors are split
/// into extension files to keep each unit focused and maintainable.
class _FileUploadState extends State<_FileUpload> {
  final FileDropAdapter _dropAdapter = createFileDropAdapter();
  final PopoverController _compactPickerPopoverController = PopoverController();

  /// Field storing `_items` for this form implementation.
  final List<FileUploadItem> _items = [];

  /// Field storing `_errors` for this form implementation.
  final List<FileUploadError> _errors = [];

  /// Field storing `_uploadSubscriptions` for this form implementation.
  final Map<String, StreamSubscription<double>> _uploadSubscriptions = {};
  final ListQueue<FileLike> _uploadQueue = ListQueue<FileLike>();

  /// Field storing `_dragActive` for this form implementation.
  bool _dragActive = false;

  /// Focus node/reference used by `_focused` interactions.
  bool _focused = false;

  /// Field storing `_completedOnce` for this form implementation.
  bool _completedOnce = false;

  /// Controller used to coordinate `_controllerListenerAttached` behavior.
  bool _controllerListenerAttached = false;

  /// Field storing `_activeUploads` for this form implementation.
  int _activeUploads = 0;

  /// Field storing `_dragDebounce` for this form implementation.
  Timer? _dragDebounce;

  /// Safe state mutation entrypoint for extension methods.
  void _setState(VoidCallback update) {
    if (!mounted) return;
    setState(update);
  }

  /// Uses controller-provided items when external controller mode is active.
  List<FileUploadItem> get _effectiveItems {
    if (widget.controller != null) {
      return widget.controller!.items;
    }
    if (widget.files == null) return _items;
    return widget.files!.map(FileUploadItem.fromFile).toList();
  }

  bool get _isUploading => _effectiveItems.any(
    (item) => item.status == FileUploadItemStatus.uploading,
  );

  /// Resolves dropzone visual state from current interactions.
  FileUploadState get _state {
    if (!widget.enabled) return FileUploadState.disabled;
    if (_dragActive) return FileUploadState.dragging;
    if (_isUploading) return FileUploadState.uploading;
    if (_errors.isNotEmpty) return FileUploadState.error;
    if (_completedOnce && _effectiveItems.isNotEmpty) {
      return FileUploadState.success;
    }
    return FileUploadState.idle;
  }

  /// Replaces current error list and triggers error callback notifications.
  void _setErrors(List<FileUploadError> errors) {
    /// Triggers a rebuild after mutating local state.
    setState(() {
      if (errors.isNotEmpty) {
        _completedOnce = false;
      }
      _errors
        ..clear()
        ..addAll(errors);
    });
    for (final error in errors) {
      widget.onError?.call(error);
    }
  }

  /// Attaches to [FileUploadController] exactly once.
  void _syncControllerState() {
    if (!mounted || _controllerListenerAttached) {
      return;
    }
    widget.controller?.addListener(_onControllerChanged);
    _controllerListenerAttached = true;
    _onControllerChanged();
  }

  /// Pulls controller state into local presentation state.
  void _onControllerChanged() {
    if (!mounted) return;

    /// Triggers a rebuild after mutating local state.
    setState(() {
      _errors
        ..clear()
        ..addAll(widget.controller?.errors ?? const []);
      if (widget.controller != null && !widget.controller!.hasItems) {
        _completedOnce = false;
      }
    });
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant _FileUpload oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      if (_controllerListenerAttached) {
        oldWidget.controller?.removeListener(_onControllerChanged);
        _controllerListenerAttached = false;
      }
      _syncControllerState();
    }

    if (widget.files != oldWidget.files && widget.files != null) {
      _errors.clear();
      _completedOnce = widget.files!.isNotEmpty ? _completedOnce : false;
    }
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _dragDebounce?.cancel();
    _compactPickerPopoverController.dispose();
    _clearUploadQueue();

    if (_controllerListenerAttached) {
      widget.controller?.removeListener(_onControllerChanged);
      _controllerListenerAttached = false;
    }

    for (final sub in _uploadSubscriptions.values) {
      sub.cancel();
    }
    _uploadSubscriptions.clear();

    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final dropzoneTheme = ComponentTheme.maybeOf<FileUploadDropzoneTheme>(
      context,
    );
    final isEnabled = widget.enabled;

    if (widget.surface == _FileUploadSurface.mobile) {
      final compactSurface = _buildLoadingAwareSurface(
        theme,
        _buildCompactPickerTrigger(),
      );
      return FocusableActionDetector(
        enabled: isEnabled && !widget.loading.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _pickFiles(),
          ),
        },
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        child: compactSurface,
      );
    }

    final baseSurface = widget.surface == _FileUploadSurface.dragDrop
        ? _buildDragDropSurface(theme, dropzoneTheme)
        : _buildTileSurface(theme, dropzoneTheme);
    final surface = _buildLoadingAwareSurface(theme, baseSurface);

    final shortcutMap = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
    };
    final actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (_) => _pickFiles(),
      ),
    };

    final hasItems = widget.showFileList && _effectiveItems.isNotEmpty;
    final itemsMaxHeight = widget.itemsMaxHeight ?? 260 * scaling;
    final listItems = widget.allowMultiple
        ? _effectiveItems
        : [_effectiveItems.first];
    final surfaceHint = widget.surfaceHint ?? widget.hint;
    final showTileHint =
        widget.surface == _FileUploadSurface.tile && surfaceHint != null;
    final belowHelpfulInfo = _buildHelpfulInfo(theme, insideSurface: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleBlock(theme),
        FocusableActionDetector(
          enabled: isEnabled && !widget.loading.isLoading,
          shortcuts: shortcutMap,
          actions: actionMap,
          onShowFocusHighlight: (value) => setState(() => _focused = value),
          child: surface,
        ),
        if (showTileHint) DensityGap(gapSm),
        if (showTileHint)
          DefaultTextStyle.merge(
            style: theme.typography.small.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
            child: surfaceHint,
          ),
        if (belowHelpfulInfo != null) DensityGap(gapSm),
        if (belowHelpfulInfo != null) belowHelpfulInfo,
        if (_errors.isNotEmpty) DensityGap(gapMd),
        if (_errors.isNotEmpty)
          Semantics(
            liveRegion: true,
            container: true,
            label: _errors.map((error) => error.message).join(', '),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final error in _errors)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: theme.density.baseGap * scaling * 0.75,
                    ),
                    child: DefaultTextStyle.merge(
                      style: theme.typography.xSmall.copyWith(
                        color: theme.colorScheme.destructive,
                      ),
                      child: Text(error.message),
                    ),
                  ),
              ],
            ),
          ),
        if (hasItems) DensityGap(gapLg),
        if (hasItems)
          FileUploadItemsView(
            items: listItems,
            layout: widget.allowMultiple
                ? widget.itemsLayout
                : FileUploadItemsLayout.list,
            groupByStatus: widget.groupListByStatus,
            statusLabels: widget.statusLabels,
            itemLoading: widget.itemLoading,
            columns: widget.itemsGridColumns,
            maxHeight: itemsMaxHeight,
            itemBuilder: (context, item) =>
                widget.itemBuilder?.call(context, item) ??
                FileItem(
                  item: item,
                  statusLabels: widget.statusLabels,
                  itemLoading: widget.itemLoading,
                  onRemove: widget.files == null
                      ? () => _removeItem(item)
                      : null,
                ),
          ),
      ],
    );
  }
}
