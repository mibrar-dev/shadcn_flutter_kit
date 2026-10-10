// Named examples for the `item_picker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. The fixed
// width is inherent: the grid body needs a bounded box. Swatch colours come
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'item_picker.dart';

/// Grid body with a live selection.
class _GridExample extends StatefulWidget {
  const _GridExample();

  @override
  State<_GridExample> createState() => _GridExampleState();
}

class _GridExampleState extends State<_GridExample> {
  String? _value = 'B';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ItemPickerDialog<String>(
        items: const ItemList<String>(<String>['A', 'B', 'C', 'D']),
        builder: (BuildContext context, String value) =>
            ItemPickerOption<String>(
              value: value,
              child: Center(child: Text(value)),
            ),
        value: _value,
        onChanged: (String? next) => setState(() => _value = next),
      ),
    );
  }
}

Widget _grid(BuildContext context) => const _GridExample();

/// List body with a swatch per row and a live selection.
class _ListExample extends StatefulWidget {
  const _ListExample();

  @override
  State<_ListExample> createState() => _ListExampleState();
}

class _ListExampleState extends State<_ListExample> {
  String? _value = 'Coral';

  static const List<String> _items = <String>['Coral', 'Mint', 'Sky'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ItemPickerDialog<String>(
        items: const ItemList<String>(_items),
        layout: ItemPickerLayout.list,
        builder: (BuildContext context, String value) =>
            ItemPickerOption<String>(
              value: value,
              label: Text(value),
              child: _Swatch(value),
            ),
        value: _value,
        onChanged: (String? next) => setState(() => _value = next),
      ),
    );
  }
}

/// Theme-token swatch for the list example.
class _Swatch extends StatelessWidget {
  const _Swatch(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    final Color color = switch (name) {
      'Coral' => colors.chart1,
      'Mint' => colors.chart2,
      _ => colors.chart3,
    };
    return SizedBox(
      width: ShadcnTheme.of(context).spacing.xl,
      height: ShadcnTheme.of(context).spacing.xl,
      child: ColoredBox(color: color, child: const SizedBox()),
    );
  }
}

Widget _list(BuildContext context) => const _ListExample();

/// Named docs examples for `item_picker`; the first entry is the default.
const List<ComponentPreview> itemPickerPreviews = <ComponentPreview>[
  ComponentPreview('Grid', _grid),
  ComponentPreview('List', _list),
];
