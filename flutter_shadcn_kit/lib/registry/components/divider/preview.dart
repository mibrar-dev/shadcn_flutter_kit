// Named examples for the `divider` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'divider.dart';

/// A plain horizontal rule.
Widget _dividerDefault(BuildContext context) => const Divider();

/// The labelled form, with the three label alignments.
Widget _dividerLabelled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Divider(label: Text('or continue with')),
      Gap(spacing.sm),
      const Divider(
        labelAlignment: DividerLabelAlignment.start,
        label: Text('start'),
      ),
      Gap(spacing.sm),
      const Divider(
        labelAlignment: DividerLabelAlignment.end,
        label: Text('end'),
      ),
    ],
  );
}

/// Vertical rule between two lines of text.
Widget _dividerVertical(BuildContext context) {
  return SizedBox(
    height: 72,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        Text('left'),
        Divider(axis: Axis.vertical),
        Text('right'),
      ],
    ),
  );
}

/// Named docs examples for `divider`; the first entry is the default.
const List<ComponentPreview> dividerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _dividerDefault),
  ComponentPreview('Labelled', _dividerLabelled),
  ComponentPreview('Vertical', _dividerVertical),
];
