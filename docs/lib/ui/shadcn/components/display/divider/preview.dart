// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Divider;
import '../divider/divider.dart';

/// Core class used by the divider component.
class DividerPreview extends StatelessWidget {
  const DividerPreview({super.key});

  /// Builds the widget tree for divider.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Item 1'),

              const Divider(),

              const Text('Item 2'),

              const Divider(),

              const Text('Item 3'),
            ],
          ),
        ),
      ),
    );
  }
}
