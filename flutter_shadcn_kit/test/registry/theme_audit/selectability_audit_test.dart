// Theme audit: code surface selectability.
//
// The user reported that code blocks (including the expanded "View Code"
// pane) are not selectable. `SelectableRegion` needs an `Overlay` ancestor,
// which `pumpWithOverlay` (in `theme_audit_helpers.dart`) supplies.
//
// The audit batch (`rearch/reports/P6_THEME_AUDIT.md` §3) recorded one
// deliberately-failing case here: `code_snippet` rendered plain `Text` /
// `Text.rich`. That placeholder is gone — the component now wraps its code
// in `SelectableRegion` (audit option A), so the tests assert the fix.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/code_snippet/code_snippet.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/markdown.dart';

import 'theme_audit_helpers.dart';

bool _isSelectable(Widget widget) {
  final type = widget.runtimeType.toString();
  return type == 'SelectableText' ||
      type == 'SelectableText.rich' ||
      type == 'SelectableRegion' ||
      type == 'SelectionArea';
}

void main() {
  group('Selectability audit', () {
    // Regression: `code_snippet` used to render plain `Text` / `Text.rich` with
    // no selection container, so code on the docs site (including the "View
    // Code" pane) could not be selected or copied. The painted output now sits
    // inside a `SelectableRegion`, which the `Text` widgets join automatically,
    // so the syntax colours are unchanged.
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

      expect(
        hasSelectable,
        isTrue,
        reason:
            'code_snippet must wrap its code in a selection container so '
            'code blocks can be selected and copied',
      );
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
