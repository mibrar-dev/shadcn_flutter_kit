// Gallery preview for the `dropzone` component: every state, the drag
// highlight, disabled, custom content and dark.
// Widgets-only; the docs app embeds [DropzonePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'dropzone.dart';

/// Renders the dropzone gallery.
class DropzonePreview extends StatelessWidget {
  /// Creates the preview.
  const DropzonePreview({super.key});

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
                  'Idle',
                  Dropzone(onBrowse: () {}, hint: Text('Up to 10 MB each.')),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Drag over',
                  Dropzone(
                    isDragOver: true,
                    hint: Text('Release to upload.'),
                    onBrowse: () {},
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Uploading',
                  Dropzone(state: DropzoneState.uploading),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Success',
                  Dropzone(state: DropzoneState.success),
                ),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Error',
                  Dropzone(state: DropzoneState.error),
                ),
                Gap(theme.spacing.lg),
                _section(context, 'Disabled', Dropzone(enabled: false)),
                Gap(theme.spacing.lg),
                _section(context, 'No action', Dropzone(showAction: false)),
                Gap(theme.spacing.lg),
                _section(
                  context,
                  'Extra content',
                  Dropzone(
                    showAction: false,
                    content: Text('Drop a folder here to upload it whole.'),
                  ),
                ),
                Gap(theme.spacing.lg),
                _section(context, 'Focused', Dropzone(focused: true)),
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
        child: const Dropzone(state: DropzoneState.error),
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
