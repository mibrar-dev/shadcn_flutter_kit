// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../subfocus/subfocus.dart';

/// SubfocusPreview defines a reusable type for this registry module.
class SubfocusPreview extends StatelessWidget {
  const SubfocusPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SubFocusScope(
          autofocus: true,
          builder: (context, scope) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SubFocus(
                    builder: (context, state) {
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: state.isFocused
                              ? Colors.blue.shade600
                              : Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Focusable ${index + 1}',
                          style: TextStyle(
                            color: state.isFocused
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
