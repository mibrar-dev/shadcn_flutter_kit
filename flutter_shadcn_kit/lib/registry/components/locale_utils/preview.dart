// Gallery preview for the `locale_utils` component.
//
// The component is a pure formatter, so the preview renders sample outputs for
// each built-in unit table instead of interactive states.

import 'package:flutter/widgets.dart';

import '../../primitives/text/text_extension.dart';
import '../../theme/theme.dart';
import 'locale_utils.dart';

/// Sample byte counts shown by the preview.
const List<int> localeUtilsPreviewSizes = <int>[
  0,
  512,
  1024,
  1536,
  10 * 1024 * 1024,
  1024 * 1024 * 1024,
];

/// Shows the formatters for the built-in unit tables.
class LocaleUtilsPreview extends StatelessWidget {
  /// Creates the preview.
  const LocaleUtilsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('fileBytes').small.muted,
          for (final int size in localeUtilsPreviewSizes)
            Text('${SizeUnitLocale.fileBytes.format(size)}  ($size)'),
          const SizedBox(height: 12),
          const Text('binaryBytes').small.muted,
          for (final int size in localeUtilsPreviewSizes)
            Text('${SizeUnitLocale.binaryBytes.format(size)}  ($size)'),
        ],
      ),
    );
  }
}
