// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../formatted_input/formatted_input.dart';

/// FormattedInputPreview renders form UI and wires input behavior.
class FormattedInputPreview extends StatelessWidget {
  const FormattedInputPreview({super.key});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FormattedInput(
          onChanged: (value) {
            final parts = <String>[];
            for (FormattedValuePart part in value.values) {
              parts.add(part.value ?? '');
            }
            if (kDebugMode) {
              print(parts.join('/'));
            }
          },
          initialValue: FormattedValue([
            const InputPart.editable(
              length: 2,
              width: 40,
              placeholder: Text('MM'),
            ).withValue('01'),
            const InputPart.static('/'),
            const InputPart.editable(
              length: 2,
              width: 40,
              placeholder: Text('DD'),
            ).withValue('02'),
            const InputPart.static('/'),
            const InputPart.editable(
              length: 4,
              width: 60,
              placeholder: Text('YYYY'),
            ).withValue('2021'),
          ]),
        ),
      ),
    );
  }
}
