// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../object_input/object_input.dart';

part '_impl/state/_object_input_preview_state.dart';

/// ObjectInputPreview renders form UI and wires input behavior.
class ObjectInputPreview extends StatefulWidget {
  const ObjectInputPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<ObjectInputPreview> createState() => _ObjectInputPreviewState();
}
