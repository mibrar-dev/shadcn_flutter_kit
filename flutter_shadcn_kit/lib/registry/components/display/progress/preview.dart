// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../progress/progress.dart';
import '../../control/button/button.dart';

part '_progress_preview_state.dart';

/// Core class used by the progress component.
class ProgressPreview extends StatefulWidget {
  const ProgressPreview({super.key});

  /// Creates the State object used by this progress widget.
  @override
  State<ProgressPreview> createState() => _ProgressPreviewState();
}
