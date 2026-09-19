// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import 'anchor.dart';

/// AnchorPreview defines a reusable type for this registry module.
class AnchorPreview extends StatelessWidget {
  const AnchorPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return const OverlayAnchorScope(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OverlayAnchor(
            anchor: 'preview-anchor',
            child: Text('Anchored widget'),
          ),
          Text('Linked overlays resolve via LinkedAnchor(preview-anchor).'),
        ],
      ),
    );
  }
}
