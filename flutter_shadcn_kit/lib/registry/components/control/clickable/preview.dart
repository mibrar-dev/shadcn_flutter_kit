// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../clickable/clickable.dart';

/// ClickablePreview defines a reusable type for this registry module.
class ClickablePreview extends StatelessWidget {
  const ClickablePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Clickable(
          onPressed: () {},
          decoration: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(8),
              );
            }
            if (states.contains(WidgetState.hovered)) {
              return BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(8),
              );
            }
            return BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            );
          }),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text('Clickable', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
