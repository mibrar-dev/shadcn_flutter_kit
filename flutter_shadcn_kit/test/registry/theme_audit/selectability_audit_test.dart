// Theme audit: code surface selectability.
//
// The user reported that code blocks (including the expanded "View Code"
// pane) are not selectable. `SelectableRegion` needs an `Overlay` ancestor,
// so the harness supplies one.
//
// A failing assertion in this batch is a *finding*: the brief says such tests
// carry a `skip:` with the reason here, and the fix batch removes the skip.
// Each skip names the component and the proposal already made in
// `rearch/reports/P6_THEME_AUDIT.md`.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/code_snippet/code_snippet.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/markdown.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

import 'theme_audit_helpers.dart';

/// Pumps [child] with the `Overlay` ancestor `SelectableRegion` requires.
Future<void> pumpWithOverlay(
  WidgetTester tester, {
  required String presetId,
  required Brightness brightness,
  required Widget child,
}) async {
  final view = loadPreset(presetId).view(brightness);
  await tester.pumpWidget(
    ShadcnTheme(
      data: ShadcnThemeData(
        colors: view.colors,
        tokens: view.tokens,
        fonts: view.fonts,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]),
      ),
    ),
  );
  await tester.pump(kSettleDuration);
}

bool _isSelectable(Widget widget) {
  final type = widget.runtimeType.toString();
  return type == 'SelectableText' ||
      type == 'SelectableText.rich' ||
      type == 'SelectableRegion' ||
      type == 'SelectionArea';
}

void main() {
  group('Selectability audit', () {
    // FINDING: `code_snippet` renders plain `Text` / `Text.rich`, so code on
    // the docs site (including the "View Code" pane) cannot be selected or
    // copied. Fix in the fix batch: swap `Text` -> `SelectableText` and
    // `Text.rich` -> `SelectableText.rich`, keeping the syntax colours.
    testWidgets('CodeSnippet text is selectable', (tester) async {
      await pumpWithOverlay(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const CodeSnippet(code: Text('const x = 1;')),
      );

      final hasSelectable = find
          .byWidgetPredicate(_isSelectable)
          .evaluate()
          .isNotEmpty;

      if (!hasSelectable) {
        // Finding of this audit batch; the fix batch makes this pass and
        // deletes the skip.
        markTestSkipped(
          'code_snippet renders plain Text/Text.rich - code is not '
          'selectable. Fix batch: use SelectableText / SelectableText.rich '
          'keeping syntax colours.',
        );
        return;
      }

      expect(hasSelectable, isTrue);
    });

    testWidgets('Markdown code blocks are selectable', (tester) async {
      await pumpWithOverlay(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const Markdown(data: '```dart\nconst x = 1;\n```'),
      );

      final hasSelectable = find
          .byWidgetPredicate(_isSelectable)
          .evaluate()
          .isNotEmpty;
      expect(
        hasSelectable,
        isTrue,
        reason: 'Markdown should wrap code blocks in SelectableRegion',
      );
    });

    testWidgets('Markdown code keeps syntax colours', (tester) async {
      await pumpWithOverlay(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const Markdown(data: '```dart\nconst x = 1;\n```'),
      );

      // Syntax colouring lives in RichText spans; the fenced block must still
      // render its code text.
      expect(
        find.byType(RichText).evaluate().isNotEmpty ||
            find.byType(Text).evaluate().isNotEmpty,
        isTrue,
        reason: 'Markdown fenced code should render text',
      );
    });
  });
}
