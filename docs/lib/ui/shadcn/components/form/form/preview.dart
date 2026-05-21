// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Form, FormField, TextField;

import '../../control/button/button.dart';
import '../form/form.dart';
import '../text_field/text_field.dart';

/// FormPreview represents a form-related type in the registry.
class FormPreview extends StatelessWidget {
  const FormPreview({super.key});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: Form(
            onSubmit: (context, values) {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormTableLayout(
                  rows: [
                    FormField<String>(
                      key: const FormKey(#name),
                      label: const Text('Name'),
                      child: const TextField(placeholder: Text('Jane Doe')),
                    ),
                    FormField<String>(
                      key: const FormKey(#email),
                      label: const Text('Email'),
                      child: const TextField(
                        placeholder: Text('jane@example.com'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  onPressed: () => context.submitForm(),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
