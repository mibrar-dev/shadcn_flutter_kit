part of '../../file_picker.dart';

/// Surface rendering methods for drag-drop and tile layouts.
extension _FileUploadStateSurfaces on _FileUploadState {
  /// Applies configured loading behavior to a surface widget.
  Widget _buildLoadingAwareSurface(ThemeData theme, Widget surface) {
    final loading = widget.loading;
    if (!loading.isLoading) {
      return surface;
    }

    Widget resolved;
    switch (loading.mode) {
      case FileUploadLoadingMode.hide:
        resolved = const SizedBox.shrink();
      case FileUploadLoadingMode.replace:
        resolved = loading.loadingWidget ?? _buildDefaultLoadingWidget(theme);
      case FileUploadLoadingMode.wrap:
        if (loading.wrapperBuilder != null) {
          resolved = loading.wrapperBuilder!(context, surface);
        } else if (loading.loadingWidget != null) {
          resolved = Stack(
            alignment: Alignment.center,
            children: [surface, loading.loadingWidget!],
          );
        } else {
          resolved = surface;
        }
    }

    if (!loading.disableInteractions ||
        loading.mode == FileUploadLoadingMode.hide) {
      return resolved;
    }
    return IgnorePointer(child: resolved);
  }

  /// Default loading replacement widget when mode is replace and no widget is provided.
  Widget _buildDefaultLoadingWidget(ThemeData theme) {
    final scaling = theme.scaling;
    final minHeight =
        widget.minHeight ??
        switch (widget.surface) {
          _FileUploadSurface.dragDrop => 220 * scaling,
          _FileUploadSurface.tile => 48 * scaling,
          _FileUploadSurface.mobile => 32 * scaling,
        };
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Center(
        child: DefaultTextStyle.merge(
          style: theme.typography.small.copyWith(
            color: theme.colorScheme.mutedForeground,
          ),
          child: const Text('Loading...'),
        ),
      ),
    );
  }

  /// Builds drag-drop content; shows single item preview in single-file mode.
  Widget _buildDragDropContent(ThemeData theme, double scaling) {
    final singleItemContent =
        (!widget.allowMultiple && _effectiveItems.isNotEmpty)
        ? FileUploadItemsView(
            items: [_effectiveItems.first],
            layout: FileUploadItemsLayout.list,
            showContainer: false,
            statusLabels: widget.statusLabels,
            itemLoading: widget.itemLoading,
            itemBuilder: widget.itemBuilder,
          )
        : null;

    if (singleItemContent != null) {
      return singleItemContent;
    }

    final icon =
        widget.icon ??
        Icon(
          RadixIcons.upload,
          size: 28 * scaling,
          color: widget.enabled
              ? theme.colorScheme.mutedForeground
              : theme.colorScheme.mutedForeground.withOpacity(0.5),
        );
    final surfaceSubtitle = widget.surfaceSubtitle ?? widget.subtitle;
    final surfaceHint = widget.surfaceHint ?? widget.hint;
    final helpfulInfo = _buildHelpfulInfo(theme, insideSurface: true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        DensityGap(gapMd),
        DefaultTextStyle.merge(
          style: theme.typography.small.copyWith(
            color: widget.enabled
                ? theme.colorScheme.mutedForeground
                : theme.colorScheme.mutedForeground.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
          child: Text(_dragDropLabel()),
        ),
        if (surfaceSubtitle != null) ...[
          DensityGap(gapSm),
          DefaultTextStyle.merge(
            style: theme.typography.xSmall.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
            child: surfaceSubtitle,
          ),
        ],
        if (surfaceHint != null) ...[
          DensityGap(gapSm),
          DefaultTextStyle.merge(
            style: theme.typography.xSmall.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
            child: surfaceHint,
          ),
        ],
        if (helpfulInfo != null) ...[DensityGap(gapSm), helpfulInfo],
      ],
    );
  }

  /// Returns contextual drag-drop helper text from current state.
  String _dragDropLabel() {
    if (!widget.enabled) {
      return widget.dragDropDisabledLabel ?? 'File uploads disabled';
    }
    if (_dragActive || _state == FileUploadState.dragging) {
      return widget.dragDropDraggingLabel ?? 'Drop files to upload';
    }
    switch (_state) {
      case FileUploadState.uploading:
        return widget.dragDropUploadingLabel ?? 'Uploading files...';
      case FileUploadState.success:
        return widget.dragDropSuccessLabel ?? 'Files ready';
      case FileUploadState.error:
        return widget.dragDropErrorLabel ?? 'Fix errors to continue';
      case FileUploadState.idle:
      case FileUploadState.disabled:
      case FileUploadState.dragging:
        return widget.enableDragDrop && _dropAdapter.supportsDragDrop
            ? (widget.dragDropIdleLabel ??
                  'Drag files here or click to pick files.')
            : (widget.dragDropClickToPickLabel ?? 'Click to pick files.');
    }
  }

  /// Builds full drag-drop surface and exposes optional custom drop handlers.
  Widget _buildDragDropSurface(
    ThemeData theme,
    FileUploadDropzoneTheme? dropzoneTheme,
  ) {
    final scaling = theme.scaling;
    final isEnabled = widget.enabled;
    final canDrop = widget.enableDragDrop && _dropAdapter.supportsDragDrop;
    final dropzoneMinHeight =
        widget.minHeight ?? dropzoneTheme?.minHeight ?? 220 * scaling;

    final dropzone = FileDropzone(
      hotDropEnabled: canDrop,
      hotDropping: _dragActive,
      enabled: isEnabled,
      state: _mapDropzoneState(_state),
      isFocused: _focused,
      showDefaultContent: false,
      content: _buildDragDropContent(theme, scaling),
      backgroundColor: widget.backgroundColor ?? dropzoneTheme?.backgroundColor,
      borderRadius: widget.borderRadius ?? dropzoneTheme?.borderRadius,
      padding: widget.padding ?? dropzoneTheme?.padding,
      minHeight: dropzoneMinHeight,
    );

    final onTap =
        widget.enableDropzoneClick && widget.enabled && widget.pickFiles != null
        ? _pickFiles
        : null;

    if (widget.dropTargetBuilder != null) {
      return widget.dropTargetBuilder!(
        child: dropzone,
        enabled: isEnabled && canDrop,
        withData: widget.withData,
        onDragActive: _setDragActive,
        onDrop: _handleDrop,
        onTap: onTap,
      );
    }

    return _dropAdapter.buildDropTarget(
      enabled: isEnabled && canDrop,
      withData: widget.withData,
      onDragActive: _setDragActive,
      onDrop: _handleDrop,
      onTap: onTap,
      child: dropzone,
    );
  }

  /// Builds compact tile-style file picker surface.
  Widget _buildTileSurface(
    ThemeData theme,
    FileUploadDropzoneTheme? dropzoneTheme,
  ) {
    final scaling = theme.scaling;
    final minHeight = widget.minHeight ?? 48 * scaling;
    final canPick = widget.enabled && widget.pickFiles != null;
    final backgroundColor =
        widget.backgroundColor ??
        dropzoneTheme?.backgroundColor ??
        theme.colorScheme.background;

    final buttonLabel = widget.actionLabel ?? 'Choose File';
    final selectedLabel = _tileSelectionLabel();
    final surfaceSubtitle = widget.surfaceSubtitle ?? widget.subtitle;
    final hasSelection = _effectiveItems.isNotEmpty;
    final textColor = widget.enabled
        ? theme.colorScheme.foreground
        : theme.colorScheme.mutedForeground.withOpacity(0.7);
    final fileNameColor = hasSelection
        ? textColor
        : theme.colorScheme.mutedForeground.withOpacity(
            widget.enabled ? 1 : 0.7,
          );

    return OutlinedContainer(
      borderWidth: 1,
      borderRadius: widget.borderRadius,
      backgroundColor: backgroundColor,
      boxShadow: _focused
          ? [
              BoxShadow(
                color: theme.colorScheme.ring.withOpacity(0.45),
                blurRadius: 0,
                spreadRadius: 2 * scaling,
              ),
            ]
          : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: GestureDetector(
          onTap: canPick ? _pickFiles : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding:
                widget.padding ??
                EdgeInsets.symmetric(
                  horizontal: theme.density.baseContainerPadding * scaling,
                  vertical: theme.density.baseGap * scaling,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            theme.density.baseContainerPadding * scaling,
                        vertical: theme.density.baseGap * scaling,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.muted.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(6 * scaling),
                      ),
                      child: DefaultTextStyle.merge(
                        style: theme.typography.small
                            .merge(theme.typography.semiBold)
                            .copyWith(color: textColor),
                        child: Text(buttonLabel),
                      ),
                    ),
                    DensityGap(0.75),
                    Expanded(
                      child: hasSelection
                          ? DefaultTextStyle.merge(
                              style: theme.typography.small.copyWith(
                                color: fileNameColor,
                              ),
                              child: Text(
                                selectedLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : surfaceSubtitle != null
                          ? DefaultTextStyle.merge(
                              style: theme.typography.small.copyWith(
                                color: fileNameColor,
                              ),
                              child: surfaceSubtitle,
                            )
                          : DefaultTextStyle.merge(
                              style: theme.typography.small.copyWith(
                                color: fileNameColor,
                              ),
                              child: Text(
                                selectedLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Resolves tile value text based on selected files.
  String _tileSelectionLabel() {
    final files = _effectiveItems
        .map((item) => item.file)
        .toList(growable: false);
    if (widget.tileSelectionTextBuilder != null) {
      final custom = widget.tileSelectionTextBuilder!.call(files);
      if (custom.trim().isNotEmpty) {
        return custom;
      }
    }
    if (files.isEmpty) {
      return widget.tileEmptySelectionLabel;
    }
    if (files.length == 1) {
      return files.first.name;
    }
    final firstName = files.first.name;
    final remaining = files.length - 1;
    return '$firstName +$remaining more';
  }

  /// Builds optional helpful info text from picker constraints.
  Widget? _buildHelpfulInfo(ThemeData theme, {required bool insideSurface}) {
    if (!widget.showHelpfulInfo) {
      return null;
    }

    final placement = _resolveHelpfulInfoPlacement();
    if (insideSurface &&
        placement != FileUploadHelpfulInfoPlacement.insideSurface) {
      return null;
    }
    if (!insideSurface &&
        placement != FileUploadHelpfulInfoPlacement.belowSurface) {
      return null;
    }

    final infoData = FileUploadHelpfulInfoData(
      allowMultiple: widget.allowMultiple,
      maxFiles: widget.maxFiles,
      maxFileSizeBytes: widget.maxFileSizeBytes,
      allowedExtensions: widget.allowedExtensions,
      allowedMimeTypes: widget.allowedMimeTypes,
    );

    if (widget.helpfulInfoBuilder != null) {
      return widget.helpfulInfoBuilder!(context, infoData);
    }

    final text = _defaultHelpfulInfoText(infoData);
    if (text == null) {
      return null;
    }

    final color = widget.enabled
        ? theme.colorScheme.mutedForeground
        : theme.colorScheme.mutedForeground.withOpacity(0.7);

    return DefaultTextStyle.merge(
      style: theme.typography.xSmall.copyWith(color: color),
      textAlign: insideSurface ? TextAlign.center : TextAlign.start,
      child: Text(text),
    );
  }

  /// Chooses automatic placement per surface.
  FileUploadHelpfulInfoPlacement _resolveHelpfulInfoPlacement() {
    if (widget.helpfulInfoPlacement !=
        FileUploadHelpfulInfoPlacement.automatic) {
      return widget.helpfulInfoPlacement;
    }
    return widget.surface == _FileUploadSurface.dragDrop
        ? FileUploadHelpfulInfoPlacement.insideSurface
        : FileUploadHelpfulInfoPlacement.belowSurface;
  }

  /// Generates default text from configured acceptance constraints.
  String? _defaultHelpfulInfoText(FileUploadHelpfulInfoData info) {
    final parts = <String>[];
    final accepted = _formatAcceptedFileTypes(info);
    if (accepted != null) {
      parts.add('Accepted: $accepted');
    }
    if (info.maxFileSizeBytes != null && info.maxFileSizeBytes! > 0) {
      parts.add('Max size: ${_formatFileSize(info.maxFileSizeBytes!)}');
    }
    return parts.isEmpty ? null : parts.join(' • ');
  }

  /// Formats extension or mime constraints for UI display.
  String? _formatAcceptedFileTypes(FileUploadHelpfulInfoData info) {
    final extensions = info.allowedExtensions;
    if (extensions != null && extensions.isNotEmpty) {
      final normalized = extensions
          .map((ext) => ext.trim())
          .where((ext) => ext.isNotEmpty)
          .map((ext) => ext.replaceFirst(RegExp(r'^\.'), '').toUpperCase())
          .toList(growable: false);
      if (normalized.isNotEmpty) {
        return normalized.join(', ');
      }
    }

    final mimeTypes = info.allowedMimeTypes;
    if (mimeTypes != null && mimeTypes.isNotEmpty) {
      final normalized = mimeTypes
          .map((type) => type.trim())
          .where((type) => type.isNotEmpty)
          .toList(growable: false);
      if (normalized.isNotEmpty) {
        return normalized.join(', ');
      }
    }

    return null;
  }
}
