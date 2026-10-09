// The file row widget and its theme, shared by the file components.
//
// Ported from `form/file_picker/_impl/core/file_item.dart` (`FileItem`) and
// `_impl/core/file_input/file_input.dart` (the icon mapping). The widget is
// called `FileUploadRow` because `FileItem` is the value type. It lives in the
// `file_value` primitive (P4-B22, Q7) so the `file_picker` component fits its
// three-file folder; `progress` is a slot so a layer-2 file never imports a
// component. The theme slice is in `file_upload_row_theme.dart`.
//
// Fixed (not ported): the old row's `LinearProgressIndicator` was a Material
// widget; the caller passes the `progress` component instead.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/radix_icons.dart';
import '../../theme/theme.dart';
import '../clickable.dart';
import '../localizations/localizations.dart';
import 'file_format.dart';
import 'file_upload_row_theme.dart';
import 'file_value.dart';

/// Builds the row thumbnail for a file extension.
typedef FileUploadIconBuilder = Widget Function(String extension);

/// The default row thumbnail: a Radix glyph per extension.
Widget defaultFileIcon(String extension) {
  final IconData icon = switch (extension.toLowerCase()) {
    'png' ||
    'jpg' ||
    'jpeg' ||
    'gif' ||
    'webp' ||
    'bmp' ||
    'svg' ||
    'heic' => RadixIcons.image,
    'pdf' || 'doc' || 'docx' || 'txt' || 'md' || 'rtf' => RadixIcons.reader,
    'xls' || 'xlsx' || 'csv' => RadixIcons.table,
    'ppt' || 'pptx' => RadixIcons.reader,
    'zip' || 'rar' || '7z' || 'tar' || 'gz' => RadixIcons.archive,
    'mp4' || 'mov' || 'avi' || 'mkv' => RadixIcons.video,
    'mp3' || 'wav' || 'ogg' || 'flac' => RadixIcons.speakerLoud,
    _ => RadixIcons.file,
  };
  return Icon(icon);
}

class FileUploadRow extends StatelessWidget {
  /// Creates a file row.
  const FileUploadRow({
    super.key,
    required this.item,
    this.theme,
    this.progress,
    this.statusLabels,
    this.onRemove,
    this.onRetry,
    this.onPreview,
    this.onDownload,
    this.thumbnail,
    this.iconBuilder,
  });

  /// The row's file and transfer state.
  final FileItem item;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final FileUploadRowTheme? theme;

  /// Progress indicator shown under the row; null hides it.
  final Widget? progress;

  /// Status wording; null resolves the localized defaults.
  final FileStatusLabels? statusLabels;

  /// Removes the file.
  final VoidCallback? onRemove;

  /// Retries a failed upload.
  final VoidCallback? onRetry;

  /// Previews the file.
  final VoidCallback? onPreview;

  /// Downloads the file.
  final VoidCallback? onDownload;

  /// Thumbnail override; null renders the image bytes or the file icon.
  final Widget? thumbnail;

  /// Thumbnail builder for the default icon; null renders [defaultFileIcon].
  final FileUploadIconBuilder? iconBuilder;

  @override
  Widget build(BuildContext context) {
    final FileUploadRowTheme style =
        resolveComponentStyle<FileUploadRowTheme, FileUploadRowTheme>(
          context,
          widget: theme,
          select: (FileUploadRowTheme t) => t,
          defaults: fileUploadRowDefaults,
        );
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    final double scaling = ambient.scaling;
    final FileStatusLabels labels =
        statusLabels ??
        FileStatusLabels(
          queued: l10n.fileUploadStatusQueued,
          uploading: l10n.fileUploadStatusUploading,
          completed: l10n.fileUploadStatusCompleted,
          failed: l10n.fileUploadStatusFailed,
        );
    final Color statusColor = switch (item.status) {
      FileStatus.success =>
        (style.successColor ?? fileUploadRowDefaults.successColor!).resolve(
          ambient.colors,
        ),
      FileStatus.error =>
        (style.errorColor ?? fileUploadRowDefaults.errorColor!).resolve(
          ambient.colors,
        ),
      FileStatus.queued || FileStatus.uploading =>
        (style.mutedColor ?? fileUploadRowDefaults.mutedColor!).resolve(
          ambient.colors,
        ),
    };
    final Color? border = style.borderColor?.resolve(ambient.colors);
    final String type = item.file.resolvedExtension.isEmpty
        ? l10n.fileUploadUnknownType
        : item.file.resolvedExtension.toUpperCase();
    final String meta =
        '$type · ${formatFileSize(item.file.size)} · '
        '${labels.resolve(item.status)}';
    final VoidCallback? onPreview = this.onPreview;
    final VoidCallback? onDownload = this.onDownload;
    final VoidCallback? onRetry = this.onRetry;
    final VoidCallback? onRemove = this.onRemove;
    final List<Widget> actions = <Widget>[
      if (onPreview != null)
        _action(context, RadixIcons.eyeOpen, l10n.fileUploadPreview, onPreview),
      if (onDownload != null)
        _action(
          context,
          RadixIcons.download,
          l10n.fileUploadDownload,
          onDownload,
        ),
      if (onRetry != null && item.status == FileStatus.error)
        _action(context, RadixIcons.update, l10n.fileUploadRetry, onRetry),
      if (onRemove != null)
        _action(context, RadixIcons.cross1, l10n.fileUploadRemove, onRemove),
    ];
    return Container(
      decoration: BoxDecoration(
        color: style.background?.resolve(ambient.colors),
        borderRadius: style.borderRadius ?? fileUploadRowDefaults.borderRadius,
        border: border == null ? null : Border.all(color: border, width: 1),
      ),
      padding: EdgeInsets.all((style.padding ?? 12) * scaling),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              thumbnail ?? _thumbnail(context, ambient, style, scaling),
              Gap((style.gap ?? 12) * scaling),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      item.file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (style.labelStyle ??
                                  fileUploadRowDefaults.labelStyle!)
                              .copyWith(color: ambient.colors.foreground),
                    ),
                    Gap(2 * scaling),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (style.metaStyle ?? fileUploadRowDefaults.metaStyle!)
                              .copyWith(color: statusColor),
                    ),
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...<Widget>[
                Gap(4 * scaling),
                Row(mainAxisSize: MainAxisSize.min, children: actions),
              ],
            ],
          ),
          if (progress != null) ...<Widget>[Gap(8 * scaling), progress!],
        ],
      ),
    );
  }

  /// One icon action: focusable, keyboard-activatable, labelled.
  Widget _action(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final double scaling = ShadcnTheme.of(context).scaling;
    return Clickable(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(6 * scaling),
        child: Icon(icon, semanticLabel: label, size: 16 * scaling),
      ),
    );
  }

  Widget _thumbnail(
    BuildContext context,
    ShadcnThemeData ambient,
    FileUploadRowTheme style,
    double scaling,
  ) {
    final double size = (style.thumbnailSize ?? 40) * scaling;
    final bytes = item.file.bytes;
    if (bytes != null && item.file.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6 * scaling),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            (style.thumbnailBackground ??
                    fileUploadRowDefaults.thumbnailBackground!)
                .resolve(ambient.colors),
        borderRadius: BorderRadius.circular(6 * scaling),
      ),
      alignment: Alignment.center,
      child: IconTheme(
        data: IconThemeData(
          color: (style.iconColor ?? fileUploadRowDefaults.iconColor!).resolve(
            ambient.colors,
          ),
          size: (style.iconSize ?? 20) * scaling,
        ),
        child:
            iconBuilder?.call(item.file.resolvedExtension) ??
            defaultFileIcon(item.file.resolvedExtension),
      ),
    );
  }
}
