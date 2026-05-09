// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../state/patch_preview_state.dart';

/// PatchPreview defines a reusable type for this registry module.
class PatchPreview extends StatefulWidget {
  const PatchPreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<PatchPreview> createState() => PatchPreviewState();
}
