// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../tab_container/tab_container.dart';
import '../tab_pane/tab_pane.dart';
part '_impl/state/_tab_pane_preview_state.dart';

/// TabPanePreview defines a reusable type for this registry module.
class TabPanePreview extends StatefulWidget {
  const TabPanePreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<TabPanePreview> createState() => _TabPanePreviewState();
}
