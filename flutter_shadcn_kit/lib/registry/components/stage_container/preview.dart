// Named examples for the `stage_container` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'stage_container.dart';

/// The content the stage wraps; prints the resolved outer padding.
class _StageContent extends StatelessWidget {
  const _StageContent();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return StageContainer(
      builder: (BuildContext context, EdgeInsets padding) {
        return Container(
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colors.muted,
            border: Border.all(color: theme.colors.border),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: theme.colors.card,
            child: Text(
              'padding: ${padding.left.toStringAsFixed(0)} / '
              '${padding.right.toStringAsFixed(0)}',
              style: TextStyle(color: theme.colors.mutedForeground),
            ),
          ),
        );
      },
    );
  }
}

/// The stage at the available width.
Widget _default(BuildContext context) {
  return const _StageContent();
}

/// The stage inside a narrow column.
Widget _narrow(BuildContext context) {
  return const Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[SizedBox(width: 320, child: _StageContent())],
  );
}

/// Named docs examples for `stage_container`; the first entry is the default.
const List<ComponentPreview> stageContainerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Narrow', _narrow),
];
