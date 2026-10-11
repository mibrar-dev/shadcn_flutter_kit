// QA for `text_animate` previews (P7-Q2).
//
// Pumps every `textAnimatePreviews` example under neutral/claude x light/dark,
// RTL and 375px, and runs each entrance past its full duration: every effect
// must resolve to the sample sentence without exceptions. Characters render
// as one RichText each, so the final text is asserted on the joined output.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/text_animate/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/text_animate/text_animate.dart';
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

String _plainText(WidgetTester tester) {
  final StringBuffer buf = StringBuffer();
  for (final Element e in find.byType(RichText).evaluate()) {
    buf.write((e.widget as RichText).text.toPlainText());
  }
  return buf.toString();
}

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in textAnimatePreviews) {
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

  testWidgets('every effect resolves to the sample sentence', (tester) async {
    for (final ComponentPreview preview in textAnimatePreviews) {
      await _pumpPreview(tester, preview);
      expect(find.byType(TextAnimate), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
      expect(_plainText(tester), contains('Ship a new build to production.'));
    }
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in textAnimatePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
