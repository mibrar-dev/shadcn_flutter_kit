// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../scrollview/scrollview.dart';

/// ScrollviewPreview defines a reusable type for this registry module.
class ScrollviewPreview extends StatelessWidget {
  const ScrollviewPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 300,
          child: ScrollViewInterceptor(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  20,
                  (index) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Item ${index + 1}'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
