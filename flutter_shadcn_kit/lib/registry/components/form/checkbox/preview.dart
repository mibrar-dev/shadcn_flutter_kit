// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Checkbox;

import '../checkbox/checkbox.dart';

part '_impl/state/_checkbox_preview_state.dart';

/// CheckboxPreview represents a form-related type in the registry.
class CheckboxPreview extends StatefulWidget {
  const CheckboxPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<CheckboxPreview> createState() => _CheckboxPreviewState();
}
