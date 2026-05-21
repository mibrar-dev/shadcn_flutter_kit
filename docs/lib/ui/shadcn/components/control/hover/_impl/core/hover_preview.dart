// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../state/hover_preview_state.dart';

/// HoverPreview defines a reusable type for this registry module.
class HoverPreview extends StatefulWidget {
  const HoverPreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<HoverPreview> createState() => HoverPreviewState();
}
