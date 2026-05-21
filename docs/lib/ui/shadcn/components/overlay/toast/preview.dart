// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../../control/button/button.dart';
import '../toast/toast.dart';

part '_impl/state/_toast_preview_state.dart';

/// ToastPreview defines a reusable type for this registry module.
class ToastPreview extends StatefulWidget {
  const ToastPreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ToastPreview> createState() => _ToastPreviewState();
}
