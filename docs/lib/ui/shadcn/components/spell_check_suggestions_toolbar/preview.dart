// Named examples for the `spell_check_suggestions_toolbar` component (P6-F3
// preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'spell_check_suggestions_toolbar.dart';

void _noop() {}

/// Anchored toolbar with three replacement rows, one disabled.
Widget _default(BuildContext context) {
  return SizedBox(
    width: 280,
    height: 140,
    child: SpellCheckSuggestionsToolbar(
      anchors: TextSelectionToolbarAnchors(primaryAnchor: Offset(12, 12)),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(label: 'receipt', onPressed: _noop),
        ContextMenuButtonItem(label: 'receipts', onPressed: _noop),
        ContextMenuButtonItem(label: 'deceit', onPressed: null),
      ],
    ),
  );
}

/// The placeholder row shown when the service has no suggestion.
Widget _noSuggestions(BuildContext context) {
  return SizedBox(
    width: 280,
    height: 80,
    child: SpellCheckSuggestionsToolbar(
      anchors: TextSelectionToolbarAnchors(primaryAnchor: Offset(12, 12)),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(onPressed: null),
      ],
    ),
  );
}

/// Named docs examples for `spell_check_suggestions_toolbar`; the first entry
/// is the default.
const List<ComponentPreview> spellCheckSuggestionsToolbarPreviews =
    <ComponentPreview>[
      ComponentPreview('Default', _default),
      ComponentPreview('No suggestions', _noSuggestions),
    ];
