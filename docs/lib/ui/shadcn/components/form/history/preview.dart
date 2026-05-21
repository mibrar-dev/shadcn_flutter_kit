// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../history/history.dart';

/// HistoryPreview represents a form-related type in the registry.
class HistoryPreview extends StatelessWidget {
  const HistoryPreview({super.key});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RecentColorsScope(
          initialRecentColors: const [Color(0xFF2196F3), Color(0xFF9C27B0)],
          child: Builder(
            builder: (context) {
              return ColorHistoryGrid(
                storage: ColorHistoryStorage.of(context),
                onColorPicked: (color) {},
              );
            },
          ),
        ),
      ),
    );
  }
}
