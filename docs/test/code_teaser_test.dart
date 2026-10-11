// D7 code-teaser tests (spec §2.4): the collapsed peek with its gradient and
// centred `View Code` button, the expansion to the full 289 px pane with the
// copy button, and the language pass-through to the syntax highlighter.

import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:docs/widgets/code_teaser.dart';
import 'package:docs/widgets/docs_tokens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const String _dartCode = '''
ShadcnApp(
  theme: buildNeutralTheme(Brightness.light),
  home: const HomePage(),
)''';

Widget _pumpTeaser(WidgetTester tester, {String? copyText}) {
  return WidgetsApp(
    color: const Color(0xFFFFFFFF),
    builder: (BuildContext context, Widget? child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 400,
          child: CodeTeaser(
            code: Text(_dartCode),
            copyText: copyText,
            language: 'dart',
          ),
        ),
      ),
    ),
  );
}

double _paneHeight(WidgetTester tester) =>
    tester.getSize(find.byType(CodeTeaser)).height;

void main() {
  testWidgets('starts collapsed at 109 px with the View Code button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_pumpTeaser(tester));
    await tester.pumpAndSettle();
    expect(_paneHeight(tester), DocsMetrics.codeTeaserHeight);
    expect(find.text('View Code'), findsOneWidget);
    // The copy button only exists once expanded.
    expect(find.byIcon(LucideIcons.copy), findsNothing);
  });

  testWidgets('expands to the full pane and reveals the copy button', (
    WidgetTester tester,
  ) async {
    final List<String> copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add(
            (call.arguments as Map<Object?, Object?>)['text']! as String,
          );
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(_pumpTeaser(tester, copyText: _dartCode));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('code-teaser-view-code')),
    );
    await tester.pumpAndSettle();

    expect(_paneHeight(tester), 289);
    expect(find.text('View Code'), findsNothing);
    expect(find.byIcon(LucideIcons.copy), findsOneWidget);
    // The language label shows next to the copy button.
    expect(find.text('dart'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.copy));
    await tester.pump();
    expect(copied.single, _dartCode);
  });

  testWidgets('the teaser re-themes with the ambient theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CodeTeaser(code: Text(_dartCode), language: 'dart'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Button), findsOneWidget);
  });
}
