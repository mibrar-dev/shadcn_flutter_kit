// Gallery preview for the `code_snippet` component: plain, with actions,
// long lines and a dark subtree. Widgets-only; the docs app embeds
// [CodeSnippetPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'code_snippet.dart';

/// Renders the code snippet gallery.
class CodeSnippetPreview extends StatelessWidget {
  /// Creates the preview.
  const CodeSnippetPreview({super.key});

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
                'Plain',
                const CodeSnippet(code: Text('const greeting = "hello";')),
              ),
              const Gap(24),
              _section(
                'With actions',
                CodeSnippet(
                  actions: <Widget>[
                    _Action(label: 'Copy'),
                    _Action(label: 'Run'),
                  ],
                  code: const Text('flutter run -d chrome'),
                ),
              ),
              const Gap(24),
              _section(
                'Long lines scroll',
                const CodeSnippet(
                  constraints: BoxConstraints(maxWidth: 320),
                  code: Text(
                    'void main() { runApp(const MyApp(home: Scaffold(body: Center(child: Text("wide"))))); }',
                  ),
                ),
              ),
              const Gap(24),
              _section(
                'Dark',
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: const CodeSnippet(code: Text('dark = true;')),
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

/// Small pill button for the actions preview.
class _Action extends StatelessWidget {
  /// Creates an action pill.
  const _Action({required this.label});

  /// Button label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ambient.colors.secondary,
        borderRadius: ambient.borderRadiusMd,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: ambient.colors.secondaryForeground,
        ),
      ),
    );
  }
}
