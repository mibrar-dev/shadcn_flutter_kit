// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Switch;

import '../switch/switch.dart';

part '_impl/state/_switch_preview_state.dart';

/// SwitchPreview represents a form-related type in the registry.
class SwitchPreview extends StatefulWidget {
  const SwitchPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<SwitchPreview> createState() => _SwitchPreviewState();
}
