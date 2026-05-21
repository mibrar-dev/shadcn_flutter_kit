// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/icons/radix_icons.dart';
import '../../../shared/primitives/outlined_container.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/geometry_extensions.dart';
import '../../control/button/button.dart';

/// Visual states for a dropzone surface.
enum DropzoneState { idle, dragging, uploading, success, error, disabled }

/// A stylized dropzone surface for file uploads.
class FileDropzone extends StatelessWidget {
  /// Constructs `FileDropzone` with the provided parameters.
  const FileDropzone({
    super.key,
    this.hotDropEnabled = false,
    this.hotDropping = false,
    this.enabled = true,
    this.state = DropzoneState.idle,
    this.isFocused = false,
    this.hint,
    this.icon,
    this.actionLabel,
    this.onPressed,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.content,
    this.showDefaultContent = true,
  });

  /// Whether drag-and-drop should be emphasized in the copy.
  final bool hotDropEnabled;

  /// Whether the dropzone is actively receiving a drop.
  final bool hotDropping;

  /// Whether the dropzone is enabled.
  final bool enabled;

  /// Current upload state.
  final DropzoneState state;

  /// Whether the dropzone is focused for keyboard interaction.
  final bool isFocused;

  /// Optional helper text displayed under the primary label.
  final Widget? hint;

  /// Optional icon widget shown above the label.
  final Widget? icon;

  /// Button label text for the browse action.
  final String? actionLabel;

  /// Called when the browse action is pressed.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional border radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Optional padding override.
  final EdgeInsetsGeometry? padding;

  /// Optional minimum height for the dropzone.
  final double? minHeight;

  /// Optional custom content rendered inside the dropzone container.
  final Widget? content;

  /// Whether to keep the default dropzone content alongside [content].
  final bool showDefaultContent;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final isEmphasized = hotDropping || state == DropzoneState.dragging;
    final borderColor = _resolveBorderColor(theme);
    final effectivePadding =
        padding ??
        EdgeInsets.all(theme.density.baseContainerPadding * scaling * 1.5);
    final dropzoneIcon =
        icon ??
        Icon(
          RadixIcons.upload,
          size: 28 * scaling,
          color: enabled
              ? theme.colorScheme.mutedForeground
              : theme.colorScheme.mutedForeground.withOpacity(0.5),
        );
    final label = actionLabel ?? 'Browse files';
    final statusLabel = _resolveStatusLabel();
    final focusRing = isFocused
        ? [
            BoxShadow(
              color: theme.colorScheme.ring.withOpacity(0.45),
              blurRadius: 0,
              spreadRadius: 2 * scaling,
            ),
          ]
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : null;
        return SizedBox(
          width: double.infinity,
          height: height,
          child: OutlinedContainer(
            borderRadius: borderRadius,
            borderWidth: 1,
            borderColor: borderColor,
            boxShadow: focusRing,
            backgroundColor: backgroundColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight ?? 0),
              child: Padding(
                padding: effectivePadding,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showDefaultContent) ...[
                        AnimatedScale(
                          scale: isEmphasized ? 1.05 : 1,
                          duration: kDefaultDuration,
                          curve: Curves.easeOut,
                          child: dropzoneIcon,
                        ),
                        DensityGap(gapMd),
                        AnimatedOpacity(
                          opacity: enabled ? 1 : 0.6,
                          duration: kDefaultDuration,
                          child: DefaultTextStyle.merge(
                            style: theme.typography.small.copyWith(
                              color: enabled
                                  ? theme.colorScheme.mutedForeground
                                  : theme.colorScheme.mutedForeground
                                        .withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                            child: Text(statusLabel),
                          ),
                        ),
                        if (hint != null) DensityGap(gapSm),
                        if (hint != null)
                          AnimatedOpacity(
                            opacity: enabled ? 1 : 0.6,
                            duration: kDefaultDuration,
                            child: DefaultTextStyle.merge(
                              style: theme.typography.xSmall.copyWith(
                                color: theme.colorScheme.mutedForeground,
                              ),
                              textAlign: TextAlign.center,
                              child: hint!,
                            ),
                          ),
                        DensityGap(gapLg),
                        OutlineButton(
                          onPressed: enabled ? onPressed : null,
                          child: Text(label),
                        ),
                      ],
                      if (!showDefaultContent && content != null) content!,
                      if (showDefaultContent && content != null) ...[
                        DensityGap(gapLg),
                        content!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Performs `_resolveBorderColor` logic for this form component.
  Color? _resolveBorderColor(ThemeData theme) {
    if (!enabled) return null;
    if (hotDropping) return theme.colorScheme.primary;
    switch (state) {
      case DropzoneState.dragging:
        return theme.colorScheme.primary;
      case DropzoneState.uploading:
        return theme.colorScheme.primary;
      case DropzoneState.success:
        return theme.colorScheme.accent;
      case DropzoneState.error:
        return theme.colorScheme.destructive;
      case DropzoneState.disabled:
        return null;
      case DropzoneState.idle:
        return null;
    }
  }

  /// Performs `_resolveStatusLabel` logic for this form component.
  String _resolveStatusLabel() {
    if (!enabled) return 'File uploads disabled';
    if (hotDropping || state == DropzoneState.dragging) {
      return 'Drop files to upload';
    }
    switch (state) {
      case DropzoneState.dragging:
        return 'Drop files to upload';
      case DropzoneState.uploading:
        return 'Uploading files...';
      case DropzoneState.success:
        return 'Files ready';
      case DropzoneState.error:
        return 'Fix errors to continue';
      case DropzoneState.disabled:
        return 'File uploads disabled';
      case DropzoneState.idle:
        return hotDropEnabled
            ? 'Drag files here or click browse to upload.'
            : 'Browse to upload files';
    }
  }
}
