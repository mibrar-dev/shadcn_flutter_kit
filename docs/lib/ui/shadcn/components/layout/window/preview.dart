// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../window/window.dart';

/// WindowPreview defines a reusable type for this registry module.
class WindowPreview extends StatelessWidget {
  const WindowPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final window = Window(
      title: const Text('Notes'),
      bounds: const Rect.fromLTWH(60, 40, 320, 220),
      content: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Drag or resize this window.'),
      ),
    );
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          height: 400,
          child: WindowNavigator(
            initialWindows: [window],
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey.shade100),
            ),
          ),
        ),
      ),
    );
  }
}
