// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Form, TextField;

import '../form/form.dart';
import '../text_field/text_field.dart';
import '../validated/validated.dart';

/// ValidatedPreview represents a form-related type in the registry.
class ValidatedPreview extends StatelessWidget {
  const ValidatedPreview({super.key});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: Validated<String>(
            validator: const NotEmptyValidator(),
            builder: (context, error, child) {
              final message = error is InvalidResult ? error.message : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child!,
                  if (message != null) ...[
                    const SizedBox(height: 6),
                    Text(message, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              );
            },
            child: const TextField(placeholder: Text('Name')),
          ),
        ),
      ),
    );
  }
}
