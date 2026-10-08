// Gallery preview for the `multiple_choice` component.
//
// Shows both scopes with a tiny local choice item; real item styling belongs
// to the app (or a chip-style component), the scope only carries selection.

import 'package:flutter/widgets.dart';

import '../../primitives/clickable.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/theme.dart';
import 'multiple_choice.dart';

/// Demo of single and multi selection.
class MultipleChoicePreview extends StatefulWidget {
  /// Creates the preview.
  const MultipleChoicePreview({super.key});

  @override
  State<MultipleChoicePreview> createState() => _MultipleChoicePreviewState();
}

class _MultipleChoicePreviewState extends State<MultipleChoicePreview> {
  String? _single = 'A';
  Set<String> _many = <String>{'B'};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('MultipleChoice').small.muted,
          MultipleChoice<String>(
            value: _single,
            onChanged: (value) => setState(() => _single = value),
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                for (final String value in const <String>['A', 'B', 'C'])
                  _PreviewItem(value: value, label: 'Option $value'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('MultipleAnswer').small.muted,
          MultipleAnswer<String>(
            value: _many,
            onChanged: (values) =>
                setState(() => _many = (values ?? const <String>{}).toSet()),
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                for (final String value in const <String>['A', 'B', 'C'])
                  _PreviewItem(value: value, label: 'Option $value'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewItem extends StatelessWidget {
  const _PreviewItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool selected =
        Choice.getValue<String>(context)?.contains(value) ?? false;
    return Clickable(
      onPressed: () => Choice.choose<String>(context, value),
      decoration: WidgetStatePropertyAll<Decoration>(
        BoxDecoration(
          color: selected ? theme.colors.accent : theme.colors.background,
          border: Border.all(color: theme.colors.border),
          borderRadius: theme.borderRadiusSm,
        ),
      ),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(label),
    );
  }
}
