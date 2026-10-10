// Named examples for the `border_loading` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'border_loading.dart';

/// A labelled card carrying the loading border.
Widget _borderLoadingCard(BuildContext context, String label, Widget child) {
  final theme = ShadcnTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      Gap(theme.spacing.sm),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
      ),
    ],
  );
}

/// The default rotating sweep.
Widget _borderLoadingSweep(BuildContext context) {
  return Center(
    child: _borderLoadingCard(
      context,
      'sweep',
      const BorderLoading(child: SizedBox(width: 120, height: 48)),
    ),
  );
}

/// Determinate progress around the outline.
Widget _borderLoadingProgress(BuildContext context) {
  return Center(
    child: _borderLoadingCard(
      context,
      'progress',
      const BorderLoading(
        progress: 0.6,
        child: SizedBox(width: 120, height: 48),
      ),
    ),
  );
}

/// A static outline, no animation.
Widget _borderLoadingOutline(BuildContext context) {
  return Center(
    child: _borderLoadingCard(
      context,
      'static',
      const BorderLoading(
        mode: BorderLoadingMode.staticBorder,
        child: SizedBox(width: 120, height: 48),
      ),
    ),
  );
}

/// Named docs examples for `border_loading`; the first entry is the default.
const List<ComponentPreview> borderLoadingPreviews = <ComponentPreview>[
  ComponentPreview('Sweep', _borderLoadingSweep),
  ComponentPreview('Progress', _borderLoadingProgress),
  ComponentPreview('Outline', _borderLoadingOutline),
];
