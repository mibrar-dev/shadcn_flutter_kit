// Named examples for the `triple_dots` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'triple_dots.dart';

/// Counts, sizes and strokes in one row.
Widget _tripleDotsDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.xxl,
    runSpacing: spacing.md,
    alignment: WrapAlignment.center,
    children: const <Widget>[
      TripleDots(),
      TripleDots(count: 4, spacing: 4),
      TripleDots(size: 6),
    ],
  );
}

/// The dots stacked vertically.
Widget _tripleDotsVertical(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: TripleDots(direction: Axis.vertical),
  );
}

/// A scoped theme leg: coloured, smaller dots.
Widget _tripleDotsThemed(BuildContext context) {
  return ComponentTheme<TripleDotsTheme>(
    data: const TripleDotsTheme(
      color: ThemedColor.ref(ColorRef.primary),
      size: 5,
    ),
    child: const TripleDots(),
  );
}

/// Named docs examples for `triple_dots`; the first entry is the default.
const List<ComponentPreview> tripleDotsPreviews = <ComponentPreview>[
  ComponentPreview('Default', _tripleDotsDefault),
  ComponentPreview('Vertical', _tripleDotsVertical),
  ComponentPreview('Themed dots', _tripleDotsThemed),
];
