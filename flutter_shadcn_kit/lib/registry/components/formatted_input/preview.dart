// Named examples for the `formatted_input` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. State lives in
// the example's own widget. The fixed width is inherent: the segment row sizes
// from its parts, so the example hands it a bounded box.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/form_core/form_core.dart';
import 'formatted_input.dart';

/// A `(555) 123-4567` phone field in controlled mode.
class _PhoneExample extends StatefulWidget {
  const _PhoneExample();

  @override
  State<_PhoneExample> createState() => _PhoneExampleState();
}

class _PhoneExampleState extends State<_PhoneExample> {
  static const SegmentedValue _initial = SegmentedValue(<SegmentPart>[
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('555')),
    SegmentPart.separator(' ('),
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('123')),
    SegmentPart.separator(') '),
    SegmentPart.editable(length: 4, width: 36, placeholder: Text('4567')),
  ]);

  SegmentedValue _value = _initial;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: FormattedInput(
        leading: const Icon(LucideIcons.phone, size: 16),
        value: _value,
        onChanged: (SegmentedValue value) => setState(() => _value = value),
      ),
    );
  }
}

Widget _phone(BuildContext context) => const _PhoneExample();

/// A date field reporting a validation error while incomplete.
Widget _date(BuildContext context) {
  return SizedBox(
    width: 300,
    child: FormattedInput(
      initialValue: const SegmentedValue(<SegmentPart>[
        SegmentPart.editable(length: 2, width: 28, placeholder: Text('MM')),
        SegmentPart.separator('/'),
        SegmentPart.editable(length: 2, width: 28, placeholder: Text('DD')),
        SegmentPart.separator('/'),
        SegmentPart.editable(length: 4, width: 36, placeholder: Text('YYYY')),
      ]),
      validator: _validateDate,
      autovalidateMode: FormValidationMode.changed,
    ),
  );
}

String? _validateDate(String? text) {
  final String value = text ?? '';
  if (value.length == 8) {
    return null;
  }
  return 'Enter a full date (MM/DD/YYYY).';
}

/// A 16-digit card field.
Widget _card(BuildContext context) {
  return const SizedBox(
    width: 300,
    child: FormattedInput(
      initialValue: SegmentedValue(<SegmentPart>[
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('1234')),
        SegmentPart.separator(' '),
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('5678')),
        SegmentPart.separator(' '),
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('9012')),
        SegmentPart.separator(' '),
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('3456')),
      ]),
    ),
  );
}

/// Named docs examples for `formatted_input`; the first entry is the default.
const List<ComponentPreview> formattedInputPreviews = <ComponentPreview>[
  ComponentPreview('Phone', _phone),
  ComponentPreview('Date', _date),
  ComponentPreview('Card', _card),
];
