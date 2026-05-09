// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../text_area/text_area.dart';

/// TextAreaPreview represents a form-related type in the registry.
class TextAreaPreview extends StatelessWidget {
  const TextAreaPreview({super.key});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                // Basic text area with expandable height
                TextArea(
                  initialValue: 'Hello, World!',
                  expandableHeight: true,
                  initialHeight: 150,
                ),
                // With placeholder
                TextArea(
                  placeholder: Text('Type your message here...'),
                  expandableHeight: true,
                  initialHeight: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
