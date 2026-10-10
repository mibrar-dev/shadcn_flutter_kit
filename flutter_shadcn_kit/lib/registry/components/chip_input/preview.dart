// Gallery preview for the `chip_input` component: removable, read-only,
// controlled, validated and suggested token fields, in light and dark.
// Widgets-only; the docs app embeds [ChipInputPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'chip_input.dart';

/// Renders the chip-input gallery.
class ChipInputPreview extends StatefulWidget {
  /// Creates the preview.
  const ChipInputPreview({super.key});

  @override
  State<ChipInputPreview> createState() => _ChipInputPreviewState();
}

class _ChipInputPreviewState extends State<ChipInputPreview> {
  List<String> _chips = <String>['flutter'];
  int _submits = 0;

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
                _section(context, 'Controlled', _controlled(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Uncontrolled', _uncontrolled(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Read-only tokens', _readOnly()),
                Gap(theme.spacing.xl),
                _section(context, 'Suggestions', _suggestions()),
                Gap(theme.spacing.xl),
                _section(context, 'Validation', _validated()),
                Gap(theme.spacing.xl),
                _section(context, 'Disabled', _disabled()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ChipInput<String>(
          hintText: 'Add a tag and press Enter',
          chips: _chips,
          onChipsChanged: (List<String> chips) =>
              setState(() => _chips = chips),
          onChipSubmit: (String text) => text.trim().toLowerCase(),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        Text('value: ${_chips.join(', ')}'),
      ],
    );
  }

  Widget _uncontrolled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ChipInput<String>(
          hintText: 'Uncontrolled: the field owns its chips',
          initialChips: const <String>['dart', 'flutter'],
          onChipSubmit: _reject,
          onChipsChanged: (_) => setState(() => _submits++),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        Text('changes reported: $_submits'),
      ],
    );
  }

  Widget _readOnly() {
    return const ChipInput<String>(
      hintText: 'Tokens without a remove button',
      initialChips: <String>['flutter', 'shadcn'],
      theme: ChipInputTheme(removable: false),
      onChipSubmit: _reject,
    );
  }

  Widget _suggestions() {
    return ChipInput<String>(
      hintText: 'Type to filter the fruits',
      onChipSubmit: _reject,
      suggestions: (String query) => _fruits
          .where((String fruit) => fruit.startsWith(query.toLowerCase()))
          .take(5),
    );
  }

  Widget _validated() {
    return ChipInput<String>(
      hintText: 'Needs at least two chips',
      initialChips: const <String>['flutter'],
      validator: (List<String> chips) =>
          chips.length < 2 ? 'Pick at least two chips.' : null,
      onChipSubmit: _reject,
    );
  }

  Widget _disabled() {
    return const ChipInput<String>(
      enabled: false,
      initialChips: <String>['disabled'],
      onChipSubmit: _reject,
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ChipInput<String>(
            hintText: 'dark field',
            initialChips: const <String>['dark'],
            onChipSubmit: _reject,
          ),
        ),
      ),
    );
  }

  /// Suggestions for the suggestion example.
  static const List<String> _fruits = <String>[
    'apple',
    'apricot',
    'avocado',
    'banana',
    'blueberry',
    'cherry',
  ];

  /// Rejects the word at the caret; used where the typed word is irrelevant.
  static String? _reject(String text) => null;

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
