// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide AlertDialog;
import '../../overlay/alert_dialog/alert_dialog.dart';
import '../../control/button/button.dart';
import '../../layout/card/card.dart';
import '../../utility/color/color.dart';
import '../../../shared/theme/theme.dart';
import '../color_picker/color_picker.dart';
import '../../overlay/popover/popover.dart';

part '_impl/state/_color_picker_preview_state.dart';

/// ColorPickerPreview represents a form-related type in the registry.
class ColorPickerPreview extends StatefulWidget {
  const ColorPickerPreview({super.key});

  /// Creates the `State` object for this widget.
  @override
  State<ColorPickerPreview> createState() => _ColorPickerPreviewState();
}
