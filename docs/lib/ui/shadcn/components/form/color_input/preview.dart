// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../../utility/color/color.dart';
import '../form_field/form_field.dart';
import '../color_input/color_input.dart';
import '../../../shared/theme/theme.dart';

part '_impl/state/_color_input_preview_state.dart';

/// ColorInputPreview renders form UI and wires input behavior.
class ColorInputPreview extends StatefulWidget {
  const ColorInputPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<ColorInputPreview> createState() => _ColorInputPreviewState();
}
