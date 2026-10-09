// Gallery preview of the multi-select: a controlled picker whose trigger
// wraps removable chips and whose popup toggles checkbox rows while staying
// open.

import 'package:flutter/widgets.dart';

import 'multi_select.dart';

/// Gallery preview of [MultiSelect].
class MultiSelectPreview extends StatefulWidget {
  /// Creates the preview.
  const MultiSelectPreview({super.key});

  @override
  State<MultiSelectPreview> createState() => _MultiSelectPreviewState();
}

class _MultiSelectPreviewState extends State<MultiSelectPreview> {
  Iterable<String>? _fruits = <String>['Apple'];

  static const List<String> _options = <String>[
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grape',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        child: MultiSelect<String>(
          value: _fruits,
          onChanged: (value) => setState(() => _fruits = value),
          placeholder: const Text('Select fruits'),
          itemBuilder: (context, value) =>
              MultiSelectChip<String>(value: value, child: Text(value)),
          items: <Widget>[
            for (final String fruit in _options)
              MultiSelectItem<String>(value: fruit, child: Text(fruit)),
          ],
        ),
      ),
    );
  }
}
