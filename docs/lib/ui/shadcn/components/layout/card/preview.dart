// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Card, TextField;

import '../../control/button/button.dart';
import '../card/card.dart';
import '../../display/text/text.dart';
import '../../form/text_field/text_field.dart';

/// CardPreview defines a reusable type for this registry module.
class CardPreview extends StatelessWidget {
  const CardPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          child: Card(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Creates a `Text` instance.
                const Text('Create project').semiBold(),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 6),

                /// Creates a `Text` instance.
                const Text(
                  'Deploy your new project in one-click.',
                ).muted().small(),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 20),

                /// Creates a `Text` instance.
                const Text('Name').semiBold().small(),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 6),

                /// Creates a `TextField` instance.
                const TextField(placeholder: Text('Project name')),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 16),

                /// Creates a `Text` instance.
                const Text('Description').semiBold().small(),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 6),

                /// Creates a `TextField` instance.
                const TextField(placeholder: Text('What is this for?')),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 24),

                /// Creates a `Row` instance.
                Row(
                  children: [
                    /// Creates a `Spacer` instance.
                    const Spacer(),

                    /// Creates a `OutlineButton` instance.
                    OutlineButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),

                    /// Creates a `SizedBox` instance.
                    const SizedBox(width: 8),

                    /// Creates a `PrimaryButton` instance.
                    PrimaryButton(
                      onPressed: () {},
                      child: const Text('Deploy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
