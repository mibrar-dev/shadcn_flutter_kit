// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../../patch.dart';
import '../core/patch_preview.dart';

/// PatchPreviewState defines a reusable type for this registry module.
class PatchPreviewState extends State<PatchPreview> {
  /// Stores `_clicks` state/configuration for this implementation.
  int _clicks = 0;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClickDetector(
          onClick: (details) {
            /// Creates a `setState` instance.
            setState(() {
              _clicks = details.clickCount;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Clicks: $_clicks'),
          ),
        ),
      ),
    );
  }
}
