// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../item_picker/item_picker.dart';

part '_impl/state/_item_picker_preview_state.dart';

/// ItemPickerPreview represents a form-related type in the registry.
class ItemPickerPreview extends StatefulWidget {
  const ItemPickerPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<ItemPickerPreview> createState() => _ItemPickerPreviewState();
}
