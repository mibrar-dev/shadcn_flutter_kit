// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide TextField;

import '../autocomplete/autocomplete.dart' as shadcn;
import '../text_field/text_field.dart';

part '_impl/state/_autocomplete_preview_state.dart';

/// AutocompletePreview represents a form-related type in the registry.
class AutocompletePreview extends StatefulWidget {
  const AutocompletePreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<AutocompletePreview> createState() => _AutocompletePreviewState();
}
