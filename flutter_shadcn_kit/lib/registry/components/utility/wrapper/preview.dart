// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../wrapper/wrapper.dart';

/// WrapperPreview defines a reusable type for this registry module.
class WrapperPreview extends StatelessWidget {
  const WrapperPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrapper(
          wrap: true,
          builder: (context, child) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
          child: const Text('Wrapped content'),
        ),
      ),
    );
  }
}
