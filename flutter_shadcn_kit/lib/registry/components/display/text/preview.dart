// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../text/text.dart';

/// Core class used by the text component.
class TextPreview extends StatelessWidget {
  const TextPreview({super.key});

  /// Builds the widget tree for text.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Headline').large().semiBold(),

            const SizedBox(height: 8),

            Text('Supporting copy goes here.').muted().small(),
          ],
        ),
      ),
    );
  }
}
