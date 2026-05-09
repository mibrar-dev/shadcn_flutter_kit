// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// File intake, upload queueing, and status lifecycle methods.
extension _FileUploadStateUploads on _FileUploadState {
  /// Validates and inserts new files, then starts uploads when configured.
  void _handleNewFiles(List<FileLike> files) {
    final effectiveMaxFiles = widget.allowMultiple
        ? widget.maxFiles
        : (widget.maxFiles ?? 1);

    if (widget.controller != null) {
      final beforeIds = widget.controller!.items
          .map((item) => item.file.id)
          .toSet();
      widget.controller!.addFiles(files);
      _syncControllerState();
      if (widget.uploadFn != null) {
        final addedFiles = widget.controller!.items
            .where((item) => !beforeIds.contains(item.file.id))
            .map((item) => item.file)
            .toList();
        _startUploads(addedFiles);
      }
      return;
    }

    final validation = validateFiles(
      incoming: files,
      existing: _effectiveItems.map((item) => item.file).toList(),
      maxFiles: effectiveMaxFiles,
      maxFileSizeBytes: widget.maxFileSizeBytes,
      allowedExtensions: widget.allowedExtensions,
      allowedMimeTypes: widget.allowedMimeTypes,
    );

    if (validation.errors.isNotEmpty) {
      _setErrors(validation.errors);
    } else {
      _setErrors(const []);
    }

    if (validation.validFiles.isEmpty) {
      return;
    }

    _completedOnce = false;
    widget.onFilesSelected?.call(validation.validFiles);

    if (widget.files == null) {
      /// Performs `_setState` logic for this form component.
      _setState(() {
        _items.addAll(validation.validFiles.map(FileUploadItem.fromFile));
      });
      widget.onFilesChanged?.call(_items.map((item) => item.file).toList());
    }

    if (widget.uploadFn != null) {
      _startUploads(validation.validFiles);
    }
  }

  /// Adds selected files to queue and starts queue pump.
  void _startUploads(List<FileLike> files) {
    if (widget.uploadFn == null || files.isEmpty) {
      return;
    }
    widget.onUploadStart?.call();
    _completedOnce = false;

    for (final file in files) {
      final item = _effectiveItems.where((entry) => entry.file.id == file.id);
      if (item.isEmpty) continue;
      if (item.first.status == FileUploadItemStatus.success) continue;
      final alreadyQueued = _uploadQueue.any((entry) => entry.id == file.id);
      final alreadyUploading = _uploadSubscriptions.containsKey(file.id);
      if (alreadyQueued || alreadyUploading) continue;
      _updateItemStatus(
        file,
        status: FileUploadItemStatus.idle,
        progress: null,
      );
      _uploadQueue.addLast(file);
    }

    _pumpUploadQueue();
  }

  /// Starts uploads up to [widget.maxConcurrentUploads].
  void _pumpUploadQueue() {
    final maxConcurrent = widget.maxConcurrentUploads < 1
        ? 1
        : widget.maxConcurrentUploads;
    while (_activeUploads < maxConcurrent && _uploadQueue.isNotEmpty) {
      final file = _uploadQueue.removeFirst();
      _startSingleUpload(file);
    }
  }

  /// Starts one upload stream and binds progress/completion handlers.
  void _startSingleUpload(FileLike file) {
    if (widget.uploadFn == null) return;
    _activeUploads += 1;
    _uploadSubscriptions[file.id]?.cancel();
    _updateItemStatus(
      file,
      status: FileUploadItemStatus.uploading,
      progress: 0,
    );

    final stream = widget.uploadFn!.call(file);
    _uploadSubscriptions[file.id] = stream.listen(
      (progress) {
        if (!mounted) return;
        final clamped = progress.clamp(0, 1).toDouble();
        _updateItemStatus(
          file,
          status: FileUploadItemStatus.uploading,
          progress: clamped,
        );
        widget.onProgress?.call(file, clamped);
      },
      onError: (_) {
        if (!mounted) return;
        final uploadError = FileUploadError(
          code: FileUploadErrorCode.uploadFailed,
          message: 'Upload failed for ${file.name}.',
        );
        _setErrors([..._errors, uploadError]);
        _updateItemStatus(
          file,
          status: FileUploadItemStatus.error,
          progress: null,
        );
        _completeUpload(file.id);
      },
      onDone: () {
        if (!mounted) return;
        _updateItemStatus(
          file,
          status: FileUploadItemStatus.success,
          progress: 1,
        );
        _completeUpload(file.id);
      },
    );
  }

  /// Finalizes one upload slot and checks terminal completion state.
  void _completeUpload(String fileId) {
    final sub = _uploadSubscriptions.remove(fileId);
    sub?.cancel();
    if (_activeUploads > 0) {
      _activeUploads -= 1;
    }
    _pumpUploadQueue();
    _checkUploadCompletion();
  }

  /// Cancels queued or active upload for one file.
  void _cancelUploadForFile(String fileId) {
    _uploadQueue.removeWhere((entry) => entry.id == fileId);
    final sub = _uploadSubscriptions.remove(fileId);
    if (sub != null) {
      sub.cancel();
      if (_activeUploads > 0) {
        _activeUploads -= 1;
      }
      _pumpUploadQueue();
    }
  }

  /// Clears upload queue bookkeeping.
  void _clearUploadQueue() {
    _uploadQueue.clear();
    _activeUploads = 0;
  }

  /// Updates one item's upload state in local or controller mode.
  void _updateItemStatus(
    FileLike file, {
    required FileUploadItemStatus status,
    double? progress,
  }) {
    if (widget.controller != null) {
      widget.controller!.updateItem(file, status, progress);
      _syncControllerState();
      return;
    }
    if (widget.files != null) return;

    final index = _items.indexWhere((item) => item.file.id == file.id);
    if (index == -1) return;

    /// Performs `_setState` logic for this form component.
    _setState(() {
      _items[index] = _items[index].copyWith(
        status: status,
        progress: progress,
      );
    });
  }

  /// Emits onComplete only after all uploads and queue entries are finished.
  void _checkUploadCompletion() {
    if (!mounted) return;
    if (_uploadQueue.isNotEmpty || _activeUploads > 0) {
      return;
    }

    final items = _effectiveItems;
    if (items.any((item) => item.status == FileUploadItemStatus.uploading)) {
      return;
    }

    if (items.isEmpty) {
      _completedOnce = false;

      /// Performs `_setState` logic for this form component.
      _setState(() {});
      return;
    }

    _completedOnce = true;
    if (_errors.isEmpty) {
      widget.onComplete?.call(items.map((item) => item.file).toList());
    }

    /// Performs `_setState` logic for this form component.
    _setState(() {});
  }

  /// Removes one item and cancels active upload if needed.
  void _removeItem(FileUploadItem item) {
    _cancelUploadForFile(item.file.id);
    if (widget.controller != null) {
      widget.controller!.removeFile(item.file);
      _syncControllerState();
      return;
    }
    if (widget.files != null) return;

    /// Performs `_setState` logic for this form component.
    _setState(() {
      _items.removeWhere((entry) => entry.file.id == item.file.id);
      if (_items.isEmpty) {
        _completedOnce = false;
      }
    });

    widget.onFilesChanged?.call(_items.map((entry) => entry.file).toList());
  }

  /// Handles drop action from drag-drop wrapper.
  void _handleDrop(List<FileLike> files) {
    if (!widget.enabled) return;
    _handleNewFiles(files);
  }

  /// Toggles drag active visuals with a short debounce on drag-leave.
  void _setDragActive(bool value) {
    if (value) {
      _dragDebounce?.cancel();
      if (_dragActive) return;

      /// Performs `_setState` logic for this form component.
      _setState(() => _dragActive = true);
      return;
    }

    _dragDebounce?.cancel();
    _dragDebounce = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;

      /// Performs `_setState` logic for this form component.
      _setState(() => _dragActive = false);
    });
  }
}
