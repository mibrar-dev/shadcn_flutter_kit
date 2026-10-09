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
                  'Idle',
                  Dropzone(onBrowse: () {}, hint: Text('Up to 10 MB each.')),
                ),
                const Gap(16),
                _section(
                  'Drag over',
                  Dropzone(
                    isDragOver: true,
                    hint: Text('Release to upload.'),
                    onBrowse: () {},
                  ),
                ),
                const Gap(16),
                _section('Uploading', Dropzone(state: DropzoneState.uploading)),
                const Gap(16),
                _section('Success', Dropzone(state: DropzoneState.success)),
                const Gap(16),
                _section('Error', Dropzone(state: DropzoneState.error)),
                const Gap(16),
                _section('Disabled', Dropzone(enabled: false)),
                const Gap(16),
                _section('No action', Dropzone(showAction: false)),
                const Gap(16),
                _section(
                  'Extra content',
                  Dropzone(
                    showAction: false,
                    content: Text('Drop a folder here to upload it whole.'),
                  ),
                ),
                const Gap(16),
                _section('Focused', Dropzone(focused: true)),
                const Gap(16),
                _section('Dark', _dark()),
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

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
