// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// SpellCheckSuggestionsToolbarPreview defines a reusable type for this registry module.
class SpellCheckSuggestionsToolbarPreview extends StatelessWidget {
  const SpellCheckSuggestionsToolbarPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    // NOTE: SpellCheckSuggestionsToolbar renders MenuButtons, which assert
    // a MenuGroupData ancestor, so it can only be previewed inside an
    // editable-text context menu. This placeholder describes the wiring
    // instead of rendering the toolbar outside its required context.
    return const Text(
      'Attach SpellCheckConfiguration to an EditableText; the toolbar '
      'appears in its context menu with replacement suggestions.',
    );
  }
}
