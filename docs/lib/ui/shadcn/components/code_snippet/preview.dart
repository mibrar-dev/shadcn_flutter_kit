// Named examples for the `code_snippet` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'code_snippet.dart';

/// A small pill button for the snippet actions row.
class _CodeSnippetAction extends StatelessWidget {
  const _CodeSnippetAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // A real Button (keyboard, hover, focus ring, semantics) instead of a
    // hand-rolled GestureDetector pill, matching the README snippet.
    return Button(
      size: ButtonSize.sm,
      variant: ButtonVariant.ghost,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// A plain snippet.
Widget _codeSnippetDefault(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: CodeSnippet(code: Text('const greeting = "hello";')),
  );
}

/// A snippet with an actions row.
class _CodeSnippetWithActions extends StatefulWidget {
  const _CodeSnippetWithActions();

  @override
  State<_CodeSnippetWithActions> createState() =>
      _CodeSnippetWithActionsState();
}

class _CodeSnippetWithActionsState extends State<_CodeSnippetWithActions> {
  String _status = 'idle';

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CodeSnippet(
          actions: <Widget>[
            _CodeSnippetAction(
              label: 'Copy',
              onPressed: () => setState(() => _status = 'copied'),
            ),
            _CodeSnippetAction(
              label: 'Run',
              onPressed: () => setState(() => _status = 'running'),
            ),
          ],
          code: const Text('flutter run -d chrome'),
        ),
        Gap(spacing.sm),
        Text(
          _status,
          style: TextStyle(
            fontSize: 12,
            color: ShadcnTheme.of(context).colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// A long line that scrolls inside its bounded box.
Widget _codeSnippetLongLines(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: SizedBox(
      width: 320,
      child: CodeSnippet(
        code: Text(
          'void main() { runApp(const MyApp(home: Center(child: Text("wide")))); }',
        ),
      ),
    ),
  );
}

Widget _codeSnippetWithActions(BuildContext context) =>
    const _CodeSnippetWithActions();

/// Named docs examples for `code_snippet`; the first entry is the default.
const List<ComponentPreview> codeSnippetPreviews = <ComponentPreview>[
  ComponentPreview('Default', _codeSnippetDefault),
  ComponentPreview('With actions', _codeSnippetWithActions),
  ComponentPreview('Long lines', _codeSnippetLongLines),
];
