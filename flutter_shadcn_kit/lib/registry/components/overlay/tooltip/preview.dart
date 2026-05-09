// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Tooltip;

import '../tooltip/tooltip.dart';

/// TooltipPreview defines a reusable type for this registry module.
class TooltipPreview extends StatelessWidget {
  const TooltipPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Tooltip(
          tooltip: (context) =>
              /// Creates a `TooltipContainer` instance.
              const TooltipContainer(child: Text('Helpful context')),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Hover me'),
          ),
        ),
      ),
    );
  }
}
