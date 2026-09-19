// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import 'overlay_configuration.dart';

/// OverlayConfigurationPreview defines a reusable type for this registry module.
class OverlayConfigurationPreview extends StatelessWidget {
  const OverlayConfigurationPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          showOverlay(
            context,
            const PopoverConfiguration(alignment: Alignment.topCenter),
            builder: (context) =>
                const Text('Presented via PopoverConfiguration'),
            adaptive: false,
          );
        },
        child: const Text('Show popover'),
      ),
    );
  }
}
