// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../eye_dropper/eye_dropper.dart';

part '_impl/state/_eye_dropper_preview_state.dart';

/// EyeDropperPreview defines a reusable type for this registry module.
class EyeDropperPreview extends StatefulWidget {
  const EyeDropperPreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<EyeDropperPreview> createState() => _EyeDropperPreviewState();
}
