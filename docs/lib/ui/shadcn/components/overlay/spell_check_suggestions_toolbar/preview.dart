// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import 'spell_check_suggestions_toolbar.dart';

/// SpellCheckSuggestionsToolbarPreview defines a reusable type for this registry module.
class SpellCheckSuggestionsToolbarPreview extends StatelessWidget {
  const SpellCheckSuggestionsToolbarPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rendered directly with sample anchors and suggestions, as the
        // toolbar appears above a misspelled word in an editable field.
        SpellCheckSuggestionsToolbar(
          anchors: const TextSelectionToolbarAnchors(
            primaryAnchor: Offset(120, 48),
          ),
          buttonItems: [
            ContextMenuButtonItem(
              onPressed: () {},
              label: 'example',
            ),
            ContextMenuButtonItem(
              onPressed: () {},
              label: 'samples',
            ),
          ],
        ),
        const Text(
          'Wire via SpellCheckConfiguration on an EditableText to get live suggestions.',
        ),
      ],
    );
  }
}
