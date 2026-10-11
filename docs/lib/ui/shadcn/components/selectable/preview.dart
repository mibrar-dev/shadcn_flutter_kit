// Named examples for the `selectable` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. The old gallery pinned its own theme at the root;
// these examples read the ambient one instead.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'selectable.dart';

/// Plain selectable text.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: SelectableText(
      'Select this text to see the custom selection styling.',
    ),
  );
}

/// A wrapping paragraph showing selection across lines.
Widget _longText(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: SelectableText(
      'Flutter widgets are built from smaller pieces until the whole screen '
      'reads as one surface. Drag across this paragraph to select words, '
      'lines, or the entire block with the custom caret and highlight.',
    ),
  );
}

/// Named docs examples for `selectable`; the first entry is the default.
const List<ComponentPreview> selectablePreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Long text', _longText),
];
