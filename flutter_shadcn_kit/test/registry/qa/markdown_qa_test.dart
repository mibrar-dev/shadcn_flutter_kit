// QA for `markdown` previews (P7-Q2).
//
// Pumps every `markdownPreviews` example under neutral/claude x light/dark,
// RTL and 375px, and pins that headings, emphasis, lists, quotes, the local
// image placeholder and the streaming cursor all render.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/markdown.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../themes/generated_theme.dart';

final Map<String, GeneratedTheme> _presets = <String, GeneratedTheme>{};

ShadcnThemeData _theme(String preset, Brightness brightness) {
  final GeneratedTheme theme = _presets.putIfAbsent(
    preset,
    () => loadGeneratedTheme('lib/registry/themes/$preset.json'),
  );
  final view = theme.view(brightness);
  return ShadcnThemeData(
    colors: view.colors,
    tokens: view.tokens,
    fonts: view.fonts,
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  String preset = 'neutral',
  Brightness brightness = Brightness.light,
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: _theme(preset, brightness),
      child: Directionality(
        textDirection: direction,
        child: Overlay.wrap(
          child: Center(
            child: SizedBox(
              width: width,
              child: Builder(builder: preview.builder),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in markdownPreviews) {
      for (final String preset in const <String>['neutral', 'claude']) {
        for (final Brightness brightness in Brightness.values) {
          await _pumpPreview(
            tester,
            preview,
            preset: preset,
            brightness: brightness,
          );
        }
      }
    }
  });

  testWidgets('Default preview renders blocks and the image fallback', (
    tester,
  ) async {
    await _pumpPreview(tester, markdownPreviews[0]);
    expect(find.byType(Markdown), findsOneWidget);
    // Blocks render through RichText, so match with findRichText.
    expect(
      find.textContaining('Release notes', findRichText: true),
      findsWidgets,
    );
    expect(
      find.textContaining('faster cold start', findRichText: true),
      findsWidgets,
    );
    expect(
      find.textContaining('Quoted from the changelog', findRichText: true),
      findsWidgets,
    );
    // Image renders through imageBuilder: the alt-text placeholder (a Text)
    // plus the title caption (RichText); no network image is touched.
    expect(find.text('build graph'), findsOneWidget);
    expect(
      find.textContaining('Build graph', findRichText: true),
      findsWidgets,
    );
  });

  testWidgets('Streaming tail shows the stable prefix plus cursor', (
    tester,
  ) async {
    await _pumpPreview(tester, markdownPreviews[1]);
    expect(find.text('▍'), findsOneWidget);
    expect(
      find.textContaining('Drafting the release notes', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in markdownPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
