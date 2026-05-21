// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../async/async.dart';

/// AsyncPreview defines a reusable type for this registry module.
class AsyncPreview extends StatelessWidget {
  const AsyncPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureOrBuilder<String>(
          future: Future<String>.delayed(
            /// Creates a `Duration` instance.
            const Duration(milliseconds: 800),
            () => 'Loaded value',
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
