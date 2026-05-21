// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../code_snippet/code_snippet.dart';

/// Core class used by the code snippet component.
class CodeSnippetPreview extends StatelessWidget {
  const CodeSnippetPreview({super.key});

  /// Builds the widget tree for code snippet.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CodeSnippet(code: Text('flutter pub get'))),
    );
  }
}
