// Named examples for the `select` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each trigger carries its own bounded width because
// the trigger row measures an intrinsic width.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'select.dart';

/// A controlled fruit picker; the selection lives in this example's state.
class _FruitSelect extends StatefulWidget {
  const _FruitSelect();

  @override
  State<_FruitSelect> createState() => _FruitSelectState();
}

class _FruitSelectState extends State<_FruitSelect> {
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
    return SizedBox(
      width: 220,
      child: Select<String>(
        value: _fruit,
        onChanged: (String? value) => setState(() => _fruit = value),
        placeholder: const Text('Select a fruit'),
        itemBuilder: (BuildContext context, String value) => Text(value),
        items: <Widget>[
          for (final String fruit in _fruits)
            SelectItem<String>(value: fruit, child: Text(fruit)),
        ],
      ),
    );
  }
}

Widget _default(BuildContext context) => const _FruitSelect();

/// A picker grouping its rows under disabled header rows.
class _GroupedSelect extends StatefulWidget {
  const _GroupedSelect();

  @override
  State<_GroupedSelect> createState() => _GroupedSelectState();
}

class _GroupedSelectState extends State<_GroupedSelect> {
  String? _produce;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Select<String>(
        value: _produce,
        onChanged: (String? value) => setState(() => _produce = value),
        placeholder: const Text('Select produce'),
        itemBuilder: (BuildContext context, String value) => Text(value),
        items: const <Widget>[
          SelectItem<String>(
            value: '__fruits',
            enabled: false,
            child: Text('Fruits'),
          ),
          SelectItem<String>(value: 'Apple', child: Text('Apple')),
          SelectItem<String>(value: 'Banana', child: Text('Banana')),
          SelectItem<String>(
            value: '__vegetables',
            enabled: false,
            child: Text('Vegetables'),
          ),
          SelectItem<String>(value: 'Carrot', child: Text('Carrot')),
          SelectItem<String>(value: 'Lettuce', child: Text('Lettuce')),
        ],
      ),
    );
  }
}

Widget _withGroups(BuildContext context) => const _GroupedSelect();

/// A disabled picker showing its selected value.
Widget _disabled(BuildContext context) {
  return SizedBox(
    width: 220,
    child: Select<String>(
      value: 'Apple',
      onChanged: (String? value) {},
      enabled: false,
      placeholder: const Text('Select a fruit'),
      itemBuilder: (BuildContext context, String value) => Text(value),
      items: const <Widget>[
        SelectItem<String>(value: 'Apple', child: Text('Apple')),
        SelectItem<String>(value: 'Banana', child: Text('Banana')),
      ],
    ),
  );
}

/// Named docs examples for `select`; the first entry is the default.
const List<ComponentPreview> selectPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('With groups', _withGroups),
  ComponentPreview('Disabled', _disabled),
];
