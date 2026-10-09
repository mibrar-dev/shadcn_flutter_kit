// Gallery preview for the spell check suggestions toolbar: the three-row
// replacement toolbar a spell-checked field shows for the misspelled word
// under the cursor. The component is normally built by an editable text
// field's toolbar builder, so the preview anchors it explicitly.

import 'package:flutter/widgets.dart';

import 'spell_check_suggestions_toolbar.dart';

/// Gallery preview of [SpellCheckSuggestionsToolbar].
class SpellCheckSuggestionsToolbarPreview extends StatelessWidget {
  /// Creates the preview.
  const SpellCheckSuggestionsToolbarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Spell check replacements for the misspelled word under '
            'the cursor:',
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 280,
            height: 140,
            child: SpellCheckSuggestionsToolbar(
              anchors: const TextSelectionToolbarAnchors(
                primaryAnchor: Offset(12, 12),
              ),
              buttonItems: const <ContextMenuButtonItem>[
                ContextMenuButtonItem(label: 'receipt', onPressed: _noop),
                ContextMenuButtonItem(label: 'receipts', onPressed: _noop),
                ContextMenuButtonItem(label: 'deceit', onPressed: null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _noop() {}
}
