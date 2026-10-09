// Gallery preview for the `item_picker` component: trigger, grid and list
// bodies, options and a dark subtree. Widgets-only; the docs app embeds
// [ItemPickerPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'item_picker.dart';

/// Renders the item picker gallery.
class ItemPickerPreview extends StatelessWidget {
  /// Creates the preview.
  const ItemPickerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 13),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _section(
                'Trigger',
                ItemPicker<String>(
                  items: const ItemList(<String>['Alpha', 'Beta', 'Gamma']),
                  placeholder: const Text('Pick item'),
                  builder: (context, value) => Text(value),
                  onChanged: (_) {},
                ),
              ),
              const Gap(24),
              _section(
                'Grid body',
                ItemPickerDialog<String>(
                  items: const ItemList(<String>['A', 'B', 'C', 'D']),
                  builder: (context, value) => ItemPickerOption<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  ),
                  value: 'B',
                  onChanged: (_) {},
                ),
              ),
              const Gap(24),
              _section(
                'List body',
                ItemPickerDialog<String>(
                  items: const ItemList(<String>['Red', 'Green']),
                  layout: ItemPickerLayout.list,
                  builder: (context, value) => ItemPickerOption<String>(
                    value: value,
                    label: Text(value),
                    child: _ColorSwatch(value),
                  ),
                  onChanged: (_) {},
                ),
              ),
              const Gap(24),
              _section(
                'Dark',
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: ItemPickerDialog<String>(
                    items: const ItemList(<String>['One', 'Two']),
                    builder: (context, value) => ItemPickerOption<String>(
                      value: value,
                      child: Center(child: Text(value)),
                    ),
                    value: 'One',
                    onChanged: (_) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}

/// Color tile for the list preview.
class _ColorSwatch extends StatelessWidget {
  /// Creates a swatch.
  const _ColorSwatch(this.name);

  /// Item name selecting the color.
  final String name;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (name) {
      'Red' => const Color(0xFFDC2626),
      'Green' => const Color(0xFF16A34A),
      _ => const Color(0xFF6B7280),
    };
    return SizedBox(
      width: 24,
      height: 24,
      child: ColoredBox(color: color, child: const SizedBox()),
    );
  }
}
