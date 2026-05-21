// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../keyboard_shortcut/keyboard_shortcut.dart';

/// Core class used by the keyboard shortcut component.
class KeyboardShortcutPreview extends StatelessWidget {
  const KeyboardShortcutPreview({super.key});

  /// Builds the widget tree for keyboard shortcut.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: KeyboardDisplay.fromActivator(
          activator: const SingleActivator(
            LogicalKeyboardKey.keyS,
            control: true,
          ),
        ),
      ),
    );
  }
}
