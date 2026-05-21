// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../hsl/hsl_color_slider.dart';

part '_impl/state/_hsl_preview_state.dart';

/// HslPreview represents a form-related type in the registry.
class HslPreview extends StatefulWidget {
  const HslPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<HslPreview> createState() => _HslPreviewState();
}
