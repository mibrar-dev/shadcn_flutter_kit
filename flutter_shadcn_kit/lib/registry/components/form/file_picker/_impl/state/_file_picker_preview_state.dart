// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _FilePickerPreviewState stores and manages mutable widget state.
class _FilePickerPreviewState extends State<FilePickerPreview> {
  /// Controller used to coordinate `_controller` behavior.
  late final FileUploadController _controller;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller = FileUploadController(
      allowMultiple: true,
      maxFiles: 5,
      maxFileSizeBytes: 10 * 1024 * 1024,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
    );
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<double> _simulateUpload(FileLike file) async* {
    const steps = 16;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      yield i / steps;
    }
  }

  /// Performs `_seedFiles` logic for this form component.
  List<FileLike> _seedFiles() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      FileLike(
        id: 'seed-$now-a',
        name: 'Roadmap.pdf',
        size: 280000,
        extension: 'pdf',
        mimeType: 'application/pdf',
      ),
      FileLike(
        id: 'seed-$now-b',
        name: 'Hero.jpg',
        size: 840000,
        extension: 'jpg',
        mimeType: 'image/jpeg',
      ),
    ];
  }

  Future<List<FileLike>> _simulatePick(FileUploadPickRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final files = _seedFiles();
    final selected = request.allowMultiple ? files : [files.first];
    return selected.where((file) {
      final extension = file.resolvedExtension;
      final mimeType = file.mimeType?.toLowerCase();
      final extensionAllowed =
          request.allowedExtensions == null ||
              request.allowedExtensions!.isEmpty
          ? true
          : request.allowedExtensions!
                .map((ext) => ext.toLowerCase().replaceFirst('.', ''))
                .contains(extension);
      final mimeAllowed =
          request.allowedMimeTypes == null || request.allowedMimeTypes!.isEmpty
          ? true
          : request.allowedMimeTypes!.any((allowed) {
              final normalized = allowed.toLowerCase();
              if (normalized.endsWith('/*')) {
                final prefix = normalized.substring(0, normalized.length - 1);
                return mimeType?.startsWith(prefix) ?? false;
              }
              return mimeType == normalized;
            });
      return extensionAllowed && mimeAllowed;
    }).toList();
  }

  /// Performs `_buildControllerBar` logic for this form component.
  Widget _buildControllerBar(ThemeData theme, double scaling) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final count = _controller.items.length;
        final hasItems = count > 0;
        return Wrap(
          spacing: theme.density.baseGap * scaling * 1.5,
          runSpacing: 8 * scaling,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Controller: $count file${count == 1 ? '' : 's'}'),
            PrimaryButton(
              onPressed: hasItems ? _controller.clear : null,
              child: const Text('Clear'),
            ),
            SecondaryButton(
              onPressed: () => _controller.addFiles(_seedFiles()),
              child: const Text('Seed demo files'),
            ),
          ],
        );
      },
    );
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    return Scaffold(
      headers: const [AppBar(title: Text('File Upload / Dropzone'))],
      child: Padding(
        padding: EdgeInsets.all(
          theme.density.baseContainerPadding * scaling * 1.5,
        ),
        child: FileIconProvider.builder(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildControllerBar(theme, scaling),
                SizedBox(height: theme.density.baseContentPadding * scaling),
                FileUpload(
                  controller: _controller,
                  pickFiles: _simulatePick,
                  title: const Text('Upload files'),
                  showHelpfulInfo: true,
                  allowMultiple: true,
                  maxConcurrentUploads: 1,
                  uploadFn: _simulateUpload,
                  options: FileUploadDragDropOptions(
                    loading: FileUploadLoadingOptions(
                      disableInteractions: true,
                      isLoading: true,
                      mode: FileUploadLoadingMode.wrap,
                      wrapperBuilder: (context, child) {
                        return BorderLoading(
                          child: child,
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    itemLoading: const FileUploadItemLoadingOptions(
                      mode: FileUploadItemLoadingMode.linear,
                    ),
                    hint: Text(
                      'Drag files here or click the dropzone to pick. Supports PDFs, images.',
                    ),
                    idleLabel: 'Drag files here or click to pick files.',
                  ),
                  onError: (error) {
                    // Errors are announced inline; hook for analytics if needed.
                  },
                ),
                SizedBox(height: theme.density.baseContainerPadding * scaling),
                FileUpload(
                  pickFiles: _simulatePick,
                  title: const Text('Tile picker (no drag-and-drop)'),
                  allowMultiple: true,
                  uploadFn: _simulateUpload,
                  options: FileUploadTileOptions(
                    actionLabel: 'Add files',
                    subtitle: Text(
                      'No File Chosen. Use a button-only file selection UI.',
                    ),
                    hint: Text('Good for touch-first layouts.'),
                    itemLoading: FileUploadItemLoadingOptions(
                      mode: FileUploadItemLoadingMode.custom,
                      customBuilder: (context, item) {
                        if (item.status != FileUploadItemStatus.uploading) {
                          return const SizedBox.shrink();
                        }
                        return const Text('Uploading...');
                      },
                    ),
                  ),
                ),
                SizedBox(height: theme.density.baseContainerPadding * scaling),
                FileUpload(
                  pickFiles: _simulatePick,
                  allowMultiple: true,
                  uploadFn: _simulateUpload,
                  options: const FileUploadMobileOptions(
                    popover: true,
                    popoverItems: [
                      FileUploadPickOption.pickFiles,
                      FileUploadPickOption.pickImages,
                    ],
                  ),
                ),
                SizedBox(height: theme.density.baseContainerPadding * scaling),
                FileUpload(
                  pickFiles: _simulatePick,
                  allowMultiple: true,
                  uploadFn: _simulateUpload,
                  options: const FileUploadMobileOptions(
                    trigger: FileUploadCompactTrigger.button,
                    buttonLabel: 'Add files',
                  ),
                ),
                SizedBox(height: theme.density.baseContainerPadding * scaling),
                FileUploadItemsView(
                  items: _controller.items,
                  layout: FileUploadItemsLayout.list,
                  maxHeight: 260 * scaling,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
