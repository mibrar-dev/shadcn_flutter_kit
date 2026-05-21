// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../select/select.dart';
import 'select.dart';

part '_impl/state/_select_preview_state.dart';

/// SelectPreview represents a form-related type in the registry.
class SelectPreview extends StatefulWidget {
  const SelectPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<SelectPreview> createState() => _SelectPreviewState();
}
