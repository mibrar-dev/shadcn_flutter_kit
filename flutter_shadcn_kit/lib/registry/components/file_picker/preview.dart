// Gallery preview for the `file_picker` component: every variant, the list
// with its transfer states, disabled and dark.
// Widgets-only; the docs app embeds [FilePickerPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'file_picker.dart';

/// Fake platform picker used by the gallery (and the tests' pattern).
Future<List<FileValue>> fakePick(FileUploadPickRequest request) async {
  return <FileValue>[
    const FileValue(
      id: 'pick-pdf',
      name: 'report.pdf',
      size: 482000,
      mimeType: 'application/pdf',
    ),
    if (request.allowMultiple)
      const FileValue(
        id: 'pick-png',
        name: 'photo.png',
        size: 1200000,
        mimeType: 'image/png',
      ),
  ];
}

FileUploadController _controller({bool busy = false, bool failed = false}) {
  return FileUploadController(
    initialItems: <FileItem>[
      const FileItem(
        file: FileValue(id: 'queued', name: 'notes.txt', size: 1200),
      ),
      FileItem(
        file: const FileValue(
          id: 'uploading',
          name: 'design.pdf',
          size: 842000,
        ),
        status: busy ? FileStatus.uploading : FileStatus.success,
        progress: busy ? 0.45 : 1,
      ),
      FileItem(
        file: const FileValue(
          id: 'settled',
          name: 'archive.zip',
          size: 5400000,
        ),
        status: failed ? FileStatus.error : FileStatus.success,
        progress: failed ? null : 1,
      ),
    ],
  );
}

/// Renders the file picker gallery.
class FilePickerPreview extends StatelessWidget {
  /// Creates the preview.
  const FilePickerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  context,
                  'Dropzone',
                  FileUpload(pick: fakePick, onError: (_) {}),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Uploading list',
                  FileUpload(
                    pick: fakePick,
                    controller: _controller(busy: true),
                    upload: (_) => const Stream<double>.empty(),
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Failed row',
                  FileUpload(
                    pick: fakePick,
                    controller: _controller(failed: true),
                    upload: (_) => const Stream<double>.empty(),
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Tile',
                  FileUpload(
                    variant: FileUploadVariant.tile,
                    pick: fakePick,
                    controller: _controller(),
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Mobile',
                  FileUpload(variant: FileUploadVariant.mobile, pick: fakePick),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Disabled',
                  FileUpload(pick: fakePick, enabled: false),
                ),
                Gap(theme.spacing.lg),
                _section(context, 'Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: FileUpload(
          variant: FileUploadVariant.tile,
          pick: fakePick,
          controller: _controller(busy: true),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
