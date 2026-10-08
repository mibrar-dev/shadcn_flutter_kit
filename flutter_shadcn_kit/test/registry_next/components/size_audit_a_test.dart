// Size audit A: already-accepted components vs shadcn/ui new-york v4.
//
// Every expectation cites the shadcn class it mirrors. Where the component
// was fixed, the test pins the shadcn value; kit-specific controls assert
// their documented structure (padding inside the decoration, no
// ConstrainedBox/minHeight stacking outside padding).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/alert_dialog/alert_dialog.dart';
import 'package:flutter_shadcn_kit/registry_next/components/avatar/avatar.dart';
import 'package:flutter_shadcn_kit/registry_next/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry_next/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry_next/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry_next/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry_next/components/divider/divider.dart';
import 'package:flutter_shadcn_kit/registry_next/components/switch/switch.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({required Widget child}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: ComponentThemes(
      themes: const <ComponentThemeData>[],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('badge (px-2 py-0.5 text-xs, h=22 border-box)', () {
    testWidgets('static badge is 20px tall', (tester) async {
      // text-xs line-height 1rem (16) + py-0.5 (4) = 20. shadcn reports 22
      // border-box (16 + 4 + the 1px border); Flutter paints the border
      // inside via DecoratedBox, so the static badge measures 20 with or
      // without the outline border. (An *interactive* outline badge goes
      // through Clickable's Container, which reserves the border as
      // padding and measures 22; see the P4-M1 report.)
      await tester.pumpWidget(_frame(child: const Badge(child: Text('New'))));
      expect(tester.getSize(find.byType(Badge)).height, closeTo(21, 1));
      await tester.pumpWidget(
        _frame(
          child: const Badge(variant: BadgeVariant.outline, child: Text('New')),
        ),
      );
      expect(tester.getSize(find.byType(Badge)).height, closeTo(21, 1));
    });

    testWidgets('dot badge is size-2.5 (10px)', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Badge(showAsDot: true, child: SizedBox.shrink())),
      );
      expect(tester.getSize(find.byType(Badge)), const Size.square(10));
    });
  });

  group('checkbox (size-4 = 16)', () {
    testWidgets('the box is 16px and no padding stacks around it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const Checkbox(value: CheckboxValue.unchecked)),
      );
      expect(
        tester.getSize(find.byType(SizedBox).first),
        const Size.square(16),
      );
      // Outer is the 16 box plus the 1px border ring: `Container` reserves
      // the decoration border as padding, so a bordered box always measures
      // 2px more than shadcn border-box (16). The old all(2) padding made it
      // 22; only the border ring remains.
      expect(tester.getSize(find.byType(Checkbox)).width, 18);
    });
  });

  group('switch (h-[1.15rem] w-8, thumb size-4)', () {
    testWidgets('track is 32 x 18.4', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Switch(value: false, onChanged: null)),
      );
      expect(tester.getSize(find.byKey(kSwitchTrackKey)), const Size(32, 18.4));
    });

    testWidgets('thumb keeps its 16px height, centered', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Switch(value: false, onChanged: null)),
      );
      // Pinning top/bottom to 0 stretched the thumb to the track height.
      expect(
        tester.getSize(find.byKey(kSwitchThumbKey)),
        const Size.square(16),
      );
    });
  });

  group('avatar (size-8 = 32)', () {
    testWidgets('tile defaults to 32px', (tester) async {
      await tester.pumpWidget(_frame(child: const Avatar(initials: 'IB')));
      expect(tester.getSize(find.byType(Avatar)), const Size.square(32));
    });

    testWidgets('badge defaults to size-2.5 (10px)', (tester) async {
      await tester.pumpWidget(
        _frame(child: const AvatarBadge(child: SizedBox.shrink())),
      );
      expect(tester.getSize(find.byType(AvatarBadge)), const Size.square(10));
    });
  });

  group('card (py-6, header px-6 gap-2, content px-6, rounded-xl)', () {
    testWidgets('root pads 24 on every side', (tester) async {
      await tester.pumpWidget(_frame(child: const Card(child: Text('body'))));
      final Padding padding = tester.widget<Padding>(
        find
            .descendant(of: find.byType(Card), matching: find.byType(Padding))
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(24));
    });

    testWidgets('radius follows the xl token (rounded-xl)', (tester) async {
      await tester.pumpWidget(_frame(child: const Card(child: Text('body'))));
      final DecoratedBox box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(Card),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final BoxDecoration decoration = box.decoration as BoxDecoration;
      expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusXl);
    });

    testWidgets('title 16 semibold, description 14 muted', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardHeader(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CardTitle(child: Text('T')),
                      CardDescription(child: Text('D')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      TextStyle styleOf(String text) => tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text(text),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(styleOf('T').fontSize, 16);
      expect(styleOf('T').fontWeight, FontWeight.w600);
      expect(styleOf('D').fontSize, 14);
    });
  });

  group('alert dialog (sm:max-w-lg p-6, title text-lg, desc text-sm)', () {
    Future<void> open(WidgetTester tester) async {
      late BuildContext host;
      // Navigator host like the component tests: the dialog shell resolves
      // `DialogTheme` inside its own route subtree.
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Navigator(
              onGenerateRoute: (settings) => PageRouteBuilder<void>(
                settings: settings,
                pageBuilder: (context, _, _) {
                  host = context;
                  return const SizedBox(width: 10, height: 10);
                },
              ),
            ),
          ),
        ),
      );
      showAlertDialog<Object?>(
        context: host,
        title: const Text('Delete?'),
        description: const Text('Gone forever.'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
    }

    testWidgets('card caps at 512 with 24px content padding', (tester) async {
      await open(tester);
      final Iterable<ConstrainedBox> boxes = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      expect(
        boxes.any((b) => b.constraints.maxWidth == 512),
        isTrue,
        reason: 'sm:max-w-lg',
      );
      final Iterable<Padding> paddings = tester.widgetList<Padding>(
        find.byType(Padding),
      );
      expect(
        paddings.any((p) => p.padding == const EdgeInsets.all(24)),
        isTrue,
        reason: 'p-6',
      );
    });

    testWidgets('title 18 semibold, description 14', (tester) async {
      await open(tester);
      TextStyle styleOf(String text) => tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text(text),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(styleOf('Delete?').fontSize, 18);
      expect(styleOf('Gone forever.').fontSize, 14);
    });
  });

  group('chip (badge-like: px-2 py-0.5 text-xs)', () {
    testWidgets('static chip matches badge height', (tester) async {
      await tester.pumpWidget(_frame(child: const Chip(child: Text('New'))));
      expect(tester.getSize(find.byType(Chip)).height, closeTo(21, 1));
    });

    testWidgets('remove control is a 12px icon with no padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipButton(onPressed: () {}, child: const Text('x')),
        ),
      );
      final IconTheme theme = tester.widget<IconTheme>(
        find
            .descendant(
              of: find.byType(ChipButton),
              matching: find.byType(IconTheme),
            )
            .first,
      );
      expect(theme.data.size, 12);
      final Padding padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(ChipButton),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, EdgeInsets.zero);
    });
  });

  group('divider (h-px / w-px = 1)', () {
    testWidgets('horizontal rule is 1px tall', (tester) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const <Widget>[Divider()],
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Divider)).height, 1);
    });

    testWidgets('vertical rule is 1px wide', (tester) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 80,
                child: Row(
                  children: const <Widget>[Divider(axis: Axis.vertical)],
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Divider)).width, 1);
    });
  });
}
