// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import 'backdrop_transform.dart';

/// BackdropTransformPreview defines a reusable type for this registry module.
class BackdropTransformPreview extends StatelessWidget {
  const BackdropTransformPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    const transform = ScaleBackdropTransform();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        transform.wrapBackdrop(context, const Text('Scaled backdrop'), 0.5),
        const Text('scaleAt(1.0) = 0.95 for the default transform'),
      ],
    );
  }
}
