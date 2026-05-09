// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../basic/basic.dart';

/// BasicPreview defines a reusable type for this registry module.
class BasicPreview extends StatelessWidget {
  const BasicPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Basic(
          leading: const Icon(Icons.person),
          title: const Text('John Doe'),
          subtitle: const Text('john@example.com'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
