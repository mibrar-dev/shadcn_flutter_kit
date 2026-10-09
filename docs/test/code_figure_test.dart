// Code-block highlighting tests: the docs code figure colours a Dart sample
// with the theme's `syntax` token group (light + dark), an unknown language
// stays plain, and the copy button still copies the plain text.

import 'package:docs/ui/shadcn/theme/color_tokens.dart';
import 'package:docs/ui/shadcn/theme/syntax_colors.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/code_figure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Collects every [TextSpan] reachable from [span], depth-first. Walking the
/// tree instead of reading `.children` keeps the test independent of whether
/// `RichText.text` is statically typed as `TextSpan` or `InlineSpan` on this
/// SDK (both appear across Flutter releases).
List<TextSpan> collectSpans(InlineSpan span) {
  final List<TextSpan> out = <TextSpan>[];
  void walk(InlineSpan node) {
    if (node is TextSpan) {
      out.add(node);
      node.children?.forEach(walk);
    }
  }

  walk(span);
  return out;
}

void main() {
  const String dartSample = 'final x = 42; // answer';

  Future<void> pumpFigure(
    WidgetTester tester, {
    required String language,
    required Brightness brightness,
  }) async {
    final ShadcnColors colors = brightness == Brightness.dark
        ? ShadcnColors.darkFallback
        : ShadcnColors.lightFallback;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'monospace'),
        home: Scaffold(
          body: ShadcnTheme(
            data: ShadcnThemeData(colors: colors),
            child: DocsCodeFigure(code: dartSample, language: language),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('dart sample renders coloured spans', (tester) async {
    await pumpFigure(tester, language: 'dart', brightness: Brightness.light);
    final RichText rich = tester.widget<RichText>(find.byType(RichText).last);
    final List<TextSpan> spans = collectSpans(rich.text);
    // Tokens get their kind colour; gaps keep the plain colour.
    final TextSpan keywordSpan = spans.firstWhere(
      (TextSpan s) => s.text == 'final',
    );
    final TextSpan numberSpan = spans.firstWhere(
      (TextSpan s) => s.text == '42',
    );
    final TextSpan commentSpan = spans.firstWhere(
      (TextSpan s) => s.text == '// answer',
    );
    expect(keywordSpan.style?.color, SyntaxColors.light.keyword);
    expect(numberSpan.style?.color, SyntaxColors.light.number);
    expect(commentSpan.style?.color, SyntaxColors.light.comment);
    // Gaps keep the figure's ink colour (the base style), not a syntax colour.
    expect(
      spans.firstWhere((TextSpan s) => s.text == ' x ').style?.color,
      const Color(0xFF262626),
    );
    // Spans concatenate back to the plain text (the root span has null text).
    expect(
      spans
          .where((TextSpan s) => s.text != null)
          .map((TextSpan s) => s.text)
          .join(),
      dartSample,
    );
  });

  testWidgets('dark brightness resolves the dark palette', (tester) async {
    await pumpFigure(tester, language: 'dart', brightness: Brightness.dark);
    final RichText rich = tester.widget<RichText>(find.byType(RichText).last);
    final List<TextSpan> spans = collectSpans(rich.text);
    expect(
      spans.firstWhere((TextSpan s) => s.text == 'final').style?.color,
      SyntaxColors.dark.keyword,
    );
    expect(
      spans.firstWhere((TextSpan s) => s.text == '42').style?.color,
      SyntaxColors.dark.number,
    );
  });

  testWidgets('unknown language stays plain', (tester) async {
    await pumpFigure(
      tester,
      language: 'brainfuck',
      brightness: Brightness.light,
    );
    final RichText rich = tester.widget<RichText>(find.byType(RichText).last);
    expect(collectSpans(rich.text), hasLength(1)); // one plain span, no tokens
    expect(rich.text.toPlainText(), dartSample);
  });

  testWidgets('no language stays plain', (tester) async {
    await pumpFigure(tester, language: '', brightness: Brightness.light);
    final RichText rich = tester.widget<RichText>(find.byType(RichText).last);
    expect(collectSpans(rich.text), hasLength(1));
    expect(rich.text.toPlainText(), dartSample);
  });
}
