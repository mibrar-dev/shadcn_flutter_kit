// Gallery preview for the `autocomplete` component: the three replacement
// modes, a custom row builder and the dark palette.
// Widgets-only; the docs app embeds [AutoCompletePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/input_features/input_features.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../input/input.dart';
import 'autocomplete.dart';

const List<String> _fruits = <String>[
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Cherry',
  'Grape',
  'Kiwi',
  'Lemon',
  'Mango',
  'Orange',
  'Peach',
  'Pear',
  'Pineapple',
  'Strawberry',
  'Watermelon',
];

Iterable<String> _filter(String query) {
  final String needle = query.toLowerCase();
  if (needle.isEmpty) {
    return const <String>[];
  }
  return _fruits.where((fruit) => fruit.toLowerCase().contains(needle));
}

/// Renders the autocomplete gallery.
class AutoCompletePreview extends StatefulWidget {
  /// Creates the preview.
  const AutoCompletePreview({super.key});

  @override
  State<AutoCompletePreview> createState() => _AutoCompletePreviewState();
}

class _AutoCompletePreviewState extends State<AutoCompletePreview> {
  String _lastSelected = '';

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  context,
                  'Modes',
                  SizedBox(
                    width: 280,
                    child: Column(
                      children: <Widget>[
                        for (final AutoCompleteMode mode
                            in AutoCompleteMode.values)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _field(hint: mode.name, mode: mode),
                          ),
                      ],
                    ),
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(context, 'Completer + custom row', _custom()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark()),
                Gap(theme.spacing.md),
                Text(
                  'Last selected: ${_lastSelected.isEmpty ? '-' : _lastSelected}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String hint,
    AutoCompleteMode? mode,
    AutoCompleteCompleter? completer,
    Widget Function(BuildContext context, String suggestion, bool selected)?
    itemBuilder,
  }) {
    return Input(
      hintText: 'Type a fruit... ($hint)',
      features: <InputFeature>[
        AutoCompleteFeature(
          suggestions: _filter,
          mode: mode,
          completer: completer ?? (String suggestion) => suggestion,
          itemBuilder: itemBuilder,
          onSuggestionSelected: (String value) =>
              setState(() => _lastSelected = value),
        ),
      ],
    );
  }

  Widget _custom() {
    return SizedBox(
      width: 280,
      child: _field(
        hint: 'custom',
        completer: (String suggestion) => '$suggestion ',
        itemBuilder: (context, suggestion, selected) => Text(
          suggestion,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: SizedBox(
          width: 280,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Input(
              hintText: 'dark',
              features: <InputFeature>[
                AutoCompleteFeature(suggestions: _filter),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
