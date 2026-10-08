// Gallery preview of the select: a controlled 220px picker with five
// options, and a searchable one backed by an async builder.

import 'package:flutter/widgets.dart';

import 'select.dart';

/// Gallery preview of [Select].
class SelectPreview extends StatefulWidget {
  /// Creates the preview.
  const SelectPreview({super.key});

  @override
  State<SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<SelectPreview> {
  String? _fruit;

  static const List<String> _fruits = <String>[
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
        width: 220,
        child: Select<String>(
          value: _fruit,
          onChanged: (value) => setState(() => _fruit = value),
          placeholder: const Text('Select a fruit'),
          itemBuilder: (context, value) => Text(value),
          items: <Widget>[
            for (final String fruit in _fruits)
              SelectItem<String>(value: fruit, child: Text(fruit)),
          ],
        ),
      ),
    );
  }
}
