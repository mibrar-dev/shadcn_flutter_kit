// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../overlay/overlay.dart';

/// OverlayPreview defines a reusable type for this registry module.
class OverlayPreview extends StatelessWidget {
  const OverlayPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return OverlayManagerLayer(
      popoverHandler: OverlayHandler.popover,
      tooltipHandler: OverlayHandler.popover,
      menuHandler: OverlayHandler.popover,
      child: const Scaffold(
        body: Center(child: Text('Overlay manager layer ready')),
      ),
    );
  }
}
