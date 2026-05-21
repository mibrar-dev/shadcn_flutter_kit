// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// Compact/mobile picker interactions and header rendering.
extension _FileUploadStateCompact on _FileUploadState {
  /// Triggers default pick action.
  Future<void> _pickFiles() async {
    await _pickFilesForOption(null);
  }

  /// Triggers pick action using a specific compact option override.
  Future<void> _pickFilesForOption(FileUploadPickOption? option) async {
    if (!widget.enabled || widget.pickFiles == null) {
      return;
    }

    try {
      final request = FileUploadPickRequest(
        allowMultiple: option?.allowMultiple ?? widget.allowMultiple,
        withData: option?.withData ?? widget.withData,
        allowedExtensions:
            option?.allowedExtensions ?? widget.allowedExtensions,
        allowedMimeTypes: option?.allowedMimeTypes ?? widget.allowedMimeTypes,
      );
      final files = await widget.pickFiles!.call(request);
      if (!mounted || files.isEmpty) return;
      _handleNewFiles(files);
    } catch (_) {
      final error = FileUploadError(
        code: FileUploadErrorCode.uploadFailed,
        message: 'File picking failed.',
      );
      _setErrors([..._errors, error]);
    }
  }

  /// Returns available compact pick options based on current mode.
  List<FileUploadPickOption> _resolveCompactOptions() {
    if (widget.compactOptions != null && widget.compactOptions!.isNotEmpty) {
      return widget.compactOptions!;
    }
    if (widget.mobileMode == _FileUploadMobileMode.popover) {
      return const [];
    }
    return const [FileUploadPickOption.pickFiles];
  }

  /// Opens popover picker with configured compact options.
  Future<void> _openCompactPickerOptions() async {
    final options = _resolveCompactOptions();
    if (options.isEmpty) return;
    final theme = Theme.of(context);
    final scaling = theme.scaling;

    await _compactPickerPopoverController.show<void>(
      context: context,
      alignment: AlignmentDirectional.topEnd,
      anchorAlignment: AlignmentDirectional.bottomEnd,
      offset: Offset(0, theme.density.baseGap * scaling),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 180 * scaling,
            maxWidth: 280 * scaling,
          ),
          child: OutlinedContainer(
            child: Padding(
              padding: EdgeInsets.all(theme.density.baseGap * scaling),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final option in options)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: theme.density.baseGap * scaling * 0.25,
                      ),
                      child: Button.ghost(
                        onPressed: () async {
                          _compactPickerPopoverController.closeLater();
                          await _pickFilesForOption(option);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (option.icon != null) ...[
                              option.icon!,
                              DensityGap(0.5),
                            ],
                            Flexible(
                              child: Text(
                                option.label,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds compact trigger used by mobile mode.
  Widget _buildCompactPickerTrigger() {
    final options = _resolveCompactOptions();
    final firstOption = options.isNotEmpty ? options.first : null;
    final onPressed = !widget.enabled || widget.pickFiles == null
        ? null
        : widget.mobileMode == _FileUploadMobileMode.popover
        ? _openCompactPickerOptions
        : () => _pickFilesForOption(firstOption);
    final icon = widget.compactIcon ?? const Icon(RadixIcons.upload);

    if (widget.compactTrigger == FileUploadCompactTrigger.button) {
      return OutlineButton(
        onPressed: onPressed,
        leading: icon,
        size: ButtonSize.small,
        child: Text(widget.compactButtonLabel ?? 'Pick files'),
      );
    }

    return IconButton.outline(
      onPressed: onPressed,
      density: ButtonDensity.icon,
      size: ButtonSize.small,
      icon: icon,
    );
  }

  /// Renders the title block above non-mobile surfaces.
  Widget _buildTitleBlock(ThemeData theme) {
    if (widget.title == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: theme.typography.large.merge(theme.typography.semiBold),
          child: widget.title!,
        ),
        DensityGap(gapLg),
      ],
    );
  }
}
