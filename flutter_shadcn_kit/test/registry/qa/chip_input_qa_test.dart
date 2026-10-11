// QA for `chip_input` previews (P7-Q1): contract, typing, clipboard.
//
// The alleged missing cut support was refuted by execution: the
// type-registered `CopySelectionTextIntent` action also intercepts `cut`
// (collapseSelection) and deletes tokens through `replaceSelectionWith` —
// covered below. The shared token-span gap is now directional (RTL).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/chip_input/chip_input.dart';
import 'package:flutter_shadcn_kit/registry/components/chip_input/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text_editing/token_editing.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

String _clipboard = '';

Widget _frame(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  // EditableText needs an Overlay ancestor once it takes focus; the Overlay
  // itself needs Directionality above it.
  final Widget entry = Center(
    child: SizedBox(
      width: 480,
      child: DefaultTextEditingShortcuts(child: child),
    ),
  );
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[OverlayEntry(builder: (_) => entry)],
      ),
    ),
  );
}

void _mockClipboard(WidgetTester tester) {
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        _clipboard = (call.arguments as Map)['text'] as String? ?? '';
      }
      if (call.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': _clipboard};
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
}

TokenEditingController<String> _ctrl(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText)).controller
        as TokenEditingController<String>;

Future<void> _modifiedKey(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pump();
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in chipInputPreviews) {
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

  testWidgets('typing a word and Enter submits a chip', (tester) async {
    await tester.pumpWidget(
      _frame(
        ChipInput<String>(
          initialChips: const <String>[],
          onChipSubmit: (String t) => t.trim().toLowerCase(),
          onChipsChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.enterText(find.byType(EditableText), 'Flutter');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(_ctrl(tester).tokens, <String>['flutter']);
  });

  testWidgets('cut removes selected tokens and copies readable text', (
    tester,
  ) async {
    _mockClipboard(tester);
    await tester.pumpWidget(
      _frame(
        ChipInput<String>(
          initialChips: const <String>['flutter', 'shadcn'],
          onChipSubmit: (String t) => t,
        ),
      ),
    );
    await tester.tap(find.byType(EditableText));
    final TokenEditingController<String> controller = _ctrl(tester);
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
    await tester.pump();
    await _modifiedKey(tester, LogicalKeyboardKey.keyX);
    expect(controller.tokens, isEmpty);
    expect(_clipboard, 'flutter, shadcn');
  });
}
