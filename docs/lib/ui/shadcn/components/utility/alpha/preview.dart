// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../alpha/alpha.dart';

/// AlphaPreview defines a reusable type for this registry module.
class AlphaPreview extends StatelessWidget {
  const AlphaPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 220,
          height: 48,
          child: CustomPaint(
            painter: AlphaPainter(),
            child: Container(
              alignment: Alignment.center,
              child: const Text('Alpha grid'),
            ),
          ),
        ),
      ),
    );
  }
}
