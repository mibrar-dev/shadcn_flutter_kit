// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import 'overlay_configuration.dart';

/// OverlayConfigurationPreview defines a reusable type for this registry module.
class OverlayConfigurationPreview extends StatelessWidget {
  const OverlayConfigurationPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('showOverlay(context, PopoverConfiguration(...))'),
        Text('OverlayController().show(context, TooltipConfiguration(...))'),
      ],
    );
  }
}
