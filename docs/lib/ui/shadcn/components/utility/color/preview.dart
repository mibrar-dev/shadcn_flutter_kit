// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../color/color.dart';

/// ColorPreview defines a reusable type for this registry module.
class ColorPreview extends StatelessWidget {
  const ColorPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final derivative = ColorDerivative.fromColor(Colors.blue);
    final adjusted = derivative.changeToHSV(
      /// Creates a `HSVColor.fromAHSV` instance.
      const HSVColor.fromAHSV(1, 210, 0.6, 0.8),
    );
    final hex = colorToHex(adjusted.toColor(), true);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Creates a `Container` instance.
            Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                color: adjusted.toColor(),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
            ),

            /// Creates a `SizedBox` instance.
            const SizedBox(height: 12),

            /// Creates a `Text` instance.
            Text(hex),
          ],
        ),
      ),
    );
  }
}
