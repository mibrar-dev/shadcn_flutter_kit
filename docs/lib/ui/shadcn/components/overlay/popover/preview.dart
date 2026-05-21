// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../popover/popover.dart';
import '../../control/button/button.dart';

/// PopoverPreview defines a reusable type for this registry module.
class PopoverPreview extends StatelessWidget {
  const PopoverPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(
          onPressed: () {
            /// Creates a `showPopover` instance.
            showPopover(
              context: context,
              alignment: Alignment.topCenter,
              offset: const Offset(0, 8),
              builder: (context) {
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        /// Creates a `Text` instance.
                        Text(
                          'Popover title',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        /// Creates a `SizedBox` instance.
                        SizedBox(height: 8),

                        /// Creates a `Text` instance.
                        Text('Use popovers for contextual helper content.'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Open Popover'),
        ),
      ),
    );
  }
}
