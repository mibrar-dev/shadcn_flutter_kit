// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../scrollable_client/scrollable_client.dart';

/// ScrollableClientPreview defines a reusable type for this registry module.
class ScrollableClientPreview extends StatelessWidget {
  const ScrollableClientPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 260,
          height: 200,
          child: ScrollableClient(
            builder: (context, offset, viewportSize, child) {
              return ClipRect(
                child: Transform.translate(
                  offset: Offset(-offset.dx, -offset.dy),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: 600,
              height: 400,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(24, (index) {
                  return Container(
                    width: 80,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[(index % 8 + 1) * 100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Tile ${index + 1}'),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
