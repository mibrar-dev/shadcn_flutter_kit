// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../menu/menu.dart';

part '_impl/state/_menu_preview_state.dart';

/// MenuPreview defines a reusable type for this registry module.
class MenuPreview extends StatefulWidget {
  const MenuPreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<MenuPreview> createState() => _MenuPreviewState();
}
