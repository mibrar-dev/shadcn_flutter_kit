// Named examples for the `chip_input` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'chip_input.dart';

/// Rejects the word at the caret; used where the typed word is irrelevant.
String? _chipInputReject(String text) => null;

/// Suggestions for the suggestion example.
const List<String> _chipInputFruits = <String>[
  'apple',
  'apricot',
  'avocado',
  'banana',
  'blueberry',
  'cherry',
];

/// The controlled field: the example owns the chip list.
class _ChipInputControlledChips extends StatefulWidget {
  const _ChipInputControlledChips();

  @override
  State<_ChipInputControlledChips> createState() =>
      _ChipInputControlledChipsState();
}

class _ChipInputControlledChipsState extends State<_ChipInputControlledChips> {
  List<String> _chips = <String>['flutter'];

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ChipInput<String>(
          hintText: 'Add a tag and press Enter',
          chips: _chips,
          onChipsChanged: (List<String> chips) =>
              setState(() => _chips = chips),
          onChipSubmit: (String text) => text.trim().toLowerCase(),
        ),
        Gap(spacing.sm),
        Text('value: ${_chips.join(', ')}'),
      ],
    );
  }
}

/// The suggestion list filtering as you type.
class _ChipInputSuggestedChips extends StatelessWidget {
  const _ChipInputSuggestedChips();

  @override
  Widget build(BuildContext context) {
    return ChipInput<String>(
      hintText: 'Type to filter the fruits',
      onChipSubmit: _chipInputReject,
      suggestions: (String query) => _chipInputFruits
          .where((String fruit) => fruit.startsWith(query.toLowerCase()))
          .take(5),
    );
  }
}

/// Read-only tokens: no remove button.
class _ChipInputReadOnlyChips extends StatelessWidget {
  const _ChipInputReadOnlyChips();

  @override
  Widget build(BuildContext context) {
    return const ChipInput<String>(
      hintText: 'Tokens without a remove button',
      initialChips: <String>['flutter', 'shadcn'],
      theme: ChipInputTheme(removable: false),
      onChipSubmit: _chipInputReject,
    );
  }
}

/// The validated field, below the minimum.
class _ChipInputValidatedChips extends StatelessWidget {
  const _ChipInputValidatedChips();

  @override
  Widget build(BuildContext context) {
    return ChipInput<String>(
      hintText: 'Needs at least two chips',
      initialChips: const <String>['flutter'],
      validator: (List<String> chips) =>
          chips.length < 2 ? 'Pick at least two chips.' : null,
      onChipSubmit: _chipInputReject,
    );
  }
}

/// The disabled field.
class _ChipInputDisabledChips extends StatelessWidget {
  const _ChipInputDisabledChips();

  @override
  Widget build(BuildContext context) {
    return const ChipInput<String>(
      enabled: false,
      initialChips: <String>['disabled'],
      onChipSubmit: _chipInputReject,
    );
  }
}

Widget _chipInputDefault(BuildContext context) =>
    const _ChipInputControlledChips();

Widget _chipInputSuggestions(BuildContext context) =>
    const _ChipInputSuggestedChips();

Widget _chipInputReadOnly(BuildContext context) =>
    const _ChipInputReadOnlyChips();

Widget _chipInputValidated(BuildContext context) =>
    const _ChipInputValidatedChips();

Widget _chipInputDisabled(BuildContext context) =>
    const _ChipInputDisabledChips();

/// Named docs examples for `chip_input`; the first entry is the default.
const List<ComponentPreview> chipInputPreviews = <ComponentPreview>[
  ComponentPreview('Default', _chipInputDefault),
  ComponentPreview('With suggestions', _chipInputSuggestions),
  ComponentPreview('Read-only', _chipInputReadOnly),
  ComponentPreview('Validated', _chipInputValidated),
  ComponentPreview('Disabled', _chipInputDisabled),
];
