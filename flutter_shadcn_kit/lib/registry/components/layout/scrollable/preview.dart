// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../outlined_container/outlined_container.dart';
import 'scrollable.dart';

/// ScrollablePreview defines a reusable type for this registry module.
class ScrollablePreview extends m.StatelessWidget {
  const ScrollablePreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: OutlinedContainer(
          width: 360,
          height: 280,
          child: m.Padding(
            padding: const m.EdgeInsets.all(12),
            child: FadedScrollableViewport(
              child: ScrollableClient(
                builder: (context, offset, viewportSize, child) {
                  return m.ClipRect(
                    child: m.Transform.translate(
                      offset: m.Offset(-offset.dx, -offset.dy),
                      child: child,
                    ),
                  );
                },
                child: m.SizedBox(
                  width: 900,
                  height: 500,
                  child: m.Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(48, (index) {
                      return m.Container(
                        width: 96,
                        height: 72,
                        alignment: m.Alignment.center,
                        decoration: m.BoxDecoration(
                          color: m.Colors.blue[(index % 8 + 1) * 100],
                          borderRadius: m.BorderRadius.circular(8),
                        ),
                        child: m.Text('Tile ${index + 1}'),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
