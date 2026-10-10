// Named examples for the `progress` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'progress.dart';

/// Determinate values at a few fill levels and heights.
Widget _progressDeterminate(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  final bar = <Widget>[
    const Progress(value: 0.25, semanticsLabel: 'Quarter'),
    Gap(spacing.lg),
    const Progress(value: 0.6, semanticsLabel: 'Sixty percent'),
    Gap(spacing.lg),
    const Progress(
      value: 0.85,
      showSparks: true,
      semanticsLabel: 'Eighty five percent',
    ),
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ...bar,
      Gap(spacing.lg),
      SizedBox(
        width: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Progress(value: 0.4, height: 4),
            Gap(spacing.lg),
            const Progress(value: 0.5, height: 14),
          ],
        ),
      ),
    ],
  );
}

/// Indeterminate mode.
Widget _progressIndeterminate(BuildContext context) {
  return const Progress(semanticsLabel: 'Loading');
}

/// Named docs examples for `progress`; the first entry is the default.
const List<ComponentPreview> progressPreviews = <ComponentPreview>[
  ComponentPreview('Determinate', _progressDeterminate),
  ComponentPreview('Indeterminate', _progressIndeterminate),
];
