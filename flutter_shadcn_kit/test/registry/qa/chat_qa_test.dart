// QA for `chat` previews (P7-Q1).
//
// Regression cover for: reaction chips ignoring keyboard/focus (raw
// GestureDetector → Clickable), the borderless tail nub, the dead
// `avatarAlignment` widget leg, and unscaled reaction metrics.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/chat/chat.dart';
import 'package:flutter_shadcn_kit/registry/components/chat/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
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
    for (final preview in chatPreviews) {
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

  testWidgets('reaction chip activates by tap and by keyboard', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _frame(
        ChatReactionContainer(onTap: () => taps++, child: const Text('x')),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(ChatReactionContainer));
    expect(taps, 1);
    final Element element = tester.element(find.text('x'));
    Focus.of(element).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 2);
  });

  testWidgets('reaction chip without onTap builds no Clickable', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const ChatReactionContainer(child: Text('x'))),
    );
    await tester.pump();
    expect(find.byType(Clickable), findsNothing);
  });

  testWidgets('widget avatarAlignment reaches the avatars', (tester) async {
    await tester.pumpWidget(
      _frame(
        const ChatGroup(
          avatarAlignment: AlignmentDirectional.bottomCenter,
          avatarPrefix: Text('A'),
          children: <Widget>[ChatBubble(child: Text('hi'))],
        ),
      ),
    );
    await tester.pump();
    final Align align = tester.widget<Align>(
      find
          .descendant(of: find.byType(ChatGroup), matching: find.byType(Align))
          .first,
    );
    expect(align.alignment, AlignmentDirectional.bottomCenter);
  });

  testWidgets('grouped preview fits 375px', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: chatPreviews[3].builder), width: 375),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
