// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

/// ImagePreview defines a reusable type for this registry module.
class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            /// Creates a `SizedBox` instance.
            SizedBox(
              width: 200,
              height: 200,
              child: Image.network(
                'https://via.placeholder.com/200',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),

            /// Creates a `Container` instance.
            Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: Image.network(
                'https://via.placeholder.com/100',
                fit: BoxFit.cover,
              ),
            ),

            /// Creates a `Container` instance.
            Container(
              width: 150,
              height: 150,
              color: Colors.grey[200],
              child: Image.network(
                'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
