// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

import '../scaffold/scaffold.dart';

/// ScaffoldPreview defines a reusable type for this registry module.
class ScaffoldPreview extends StatelessWidget {
  const ScaffoldPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      loadingProgress: 0.45,
      headers: [
        /// Creates a `Container` instance.
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blueGrey.shade50,
          child: const Text('Header'),
        ),
      ],
      footers: [
        /// Creates a `Container` instance.
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blueGrey.shade50,
          child: const Text('Footer'),
        ),
      ],
      child: const Center(child: Text('Body content')),
    );
  }
}
