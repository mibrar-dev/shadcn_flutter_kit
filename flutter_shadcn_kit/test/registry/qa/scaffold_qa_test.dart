// QA for `scaffold` previews (P7-Q2).
//
// Pumps every `scaffoldPreviews` example under neutral/claude x light/dark,
// RTL and 375px. The component is display-only; this file pins that header,
// footer, body and the loading bar all render.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/scaffold/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/scaffold/scaffold.dart';
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
    for (final ComponentPreview preview in scaffoldPreviews) {
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

  testWidgets('Default shell shows header, body and footer', (tester) async {
    await _pumpPreview(tester, scaffoldPreviews[0]);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('My Application'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Main content area'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('All systems go'), findsOneWidget);
  });

  testWidgets('Loading shell shows the header and fetching body', (
    tester,
  ) async {
    await _pumpPreview(tester, scaffoldPreviews[1]);
    expect(find.text('Syncing'), findsOneWidget);
    expect(find.text('Fetching...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in scaffoldPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
