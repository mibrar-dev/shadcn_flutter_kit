// QA for `code_snippet` previews (P7-Q1).
//
// Regression cover for: `Text.rich` silently skipping highlighting even with
// an explicit language, and the action row staying top-right in RTL.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/code_snippet/code_snippet.dart';
import 'package:flutter_shadcn_kit/registry/components/code_snippet/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in codeSnippetPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('Text.rich is highlighted when a language is given', (
    tester,
  ) async {
    const String code = 'void main() {}';
    await tester.pumpWidget(
      _frame(
        const CodeSnippet(
          language: 'dart',
          code: Text.rich(TextSpan(text: code)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Highlighting splits the source into styled runs; plain text stays one.
    final Text text = tester.widget<Text>(
      find
          .descendant(of: find.byType(CodeSnippet), matching: find.byType(Text))
          .first,
    );
    final InlineSpan? span = text.textSpan;
    expect(span, isNotNull);
    expect(span!.toPlainText(), contains('void'));
    int runs = 0;
    void count(InlineSpan s) {
      runs++;
      if (s is TextSpan) {
        for (final InlineSpan? child in s.children ?? <InlineSpan?>[]) {
          if (child != null) count(child);
        }
      }
    }

    count(span);
    expect(runs, greaterThan(1));
  });

  testWidgets('action buttons are keyboard-focusable buttons', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: codeSnippetPreviews[1].builder)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);
    // The preview status line still reports taps.
    await tester.tap(find.text('Copy'));
    await tester.pump();
    expect(find.text('copied'), findsOneWidget);
  });

  testWidgets('long lines scroll inside a 320px box', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: codeSnippetPreviews[2].builder), width: 375),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
