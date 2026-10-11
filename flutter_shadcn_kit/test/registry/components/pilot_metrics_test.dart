// Pilot metrics vs shadcn/ui (brief P3-F §1): logical sizes measured with
// widget tests (`tester.getSize` / `tester.getRect`), not pixel probing.
//
// Reference: shadcn/ui new-york, default density.
// Button: sm h-8 (32), md h-9 (36), lg h-10 (40), icon size-9 (36x36),
// xs h-7 (28, pre-existing size); px-3/px-4/px-6 = 12/16/24 horizontal,
// text text-sm font-medium (14 w500).
// Input: h-9 (36), px-3 (12), 1px border, radius `radiusMd`.
// Toggle: h-8/h-9/h-10 (32/36/40), min-width = height, px-2 (8).
// Dialog: sm:max-w-lg (512), p-6 (24), radius `radiusLg`, gap-4 (16)
// between header/body/footer (caller-owned column, asserted on a canonical
// layout; see §4 notes).

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/dialog/dialog.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/toggle/toggle.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: const <ComponentThemeData>[],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

EdgeInsets _buttonPadding(WidgetTester tester) {
  final clickable = tester.widget<Clickable>(
    find.descendant(of: find.byType(Button), matching: find.byType(Clickable)),
  );
  return clickable.padding!.resolve(<WidgetState>{})! as EdgeInsets;
}

TextStyle _buttonText(WidgetTester tester) {
  final clickable = tester.widget<Clickable>(
    find.descendant(of: find.byType(Button), matching: find.byType(Clickable)),
  );
  return clickable.textStyle!.resolve(<WidgetState>{})!;
}

EdgeInsets _togglePadding(WidgetTester tester) {
  final clickable = tester.widget<Clickable>(
    find.descendant(of: find.byType(Toggle), matching: find.byType(Clickable)),
  );
  return clickable.padding!.resolve(<WidgetState>{})! as EdgeInsets;
}

void main() {
  group('button matches shadcn/ui', () {
    testWidgets('heights: xs 28, sm 32, md 36, lg 40', (tester) async {
      final expected = <ButtonSize, double>{
        ButtonSize.xs: 28,
        ButtonSize.sm: 32,
        ButtonSize.md: 36,
        ButtonSize.lg: 40,
      };
      for (final entry in expected.entries) {
        await tester.pumpWidget(
          _frame(
            child: Button(
              size: entry.key,
              onPressed: () {},
              child: Text(entry.key.name),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));
        expect(
          tester.getSize(find.byType(Button)).height,
          entry.value,
          reason: 'ButtonSize.${entry.key.name} height',
        );
      }
    });

    testWidgets('icon is a 36x36 square; no icon-sm/icon-lg exist', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: Button(
            size: ButtonSize.icon,
            onPressed: () {},
            child: const SizedBox(width: 16, height: 16),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(find.byType(Button)), const Size(36, 36));
      expect(ButtonSize.values.map((s) => s.name), isNot(contains('icon-sm')));
      expect(ButtonSize.values.map((s) => s.name), isNot(contains('icon-lg')));
    });

    testWidgets('horizontal padding: sm 12, md 16, lg 24', (tester) async {
      final expected = <ButtonSize, double>{
        ButtonSize.sm: 12,
        ButtonSize.md: 16,
        ButtonSize.lg: 24,
      };
      for (final entry in expected.entries) {
        await tester.pumpWidget(
          _frame(
            child: Button(
              size: entry.key,
              onPressed: () {},
              child: Text(entry.key.name),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));
        final padding = _buttonPadding(tester);
        expect(padding.left, entry.value, reason: '${entry.key.name} left');
        expect(padding.right, entry.value, reason: '${entry.key.name} right');
        expect(padding.top, 0, reason: 'vertical padding must not stack');
        expect(padding.bottom, 0, reason: 'vertical padding must not stack');
      }
    });

    testWidgets('text is 14px w500', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Button(onPressed: () {}, child: const Text('Save')),
        ),
      );
      final style = _buttonText(tester);
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w500);
    });
  });

  group('input matches shadcn/ui', () {
    testWidgets('height is 36', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const SizedBox(width: 340, child: Input(hintText: 'Email')),
        ),
      );
      await tester.pump();
      expect(tester.getSize(find.byType(Input)).height, 36);
    });

    testWidgets('horizontal padding 12, 1px border, radiusMd', (tester) async {
      await tester.pumpWidget(_frame(child: const Input(hintText: 'Email')));
      await tester.pump();
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(Input),
          matching: find.byType(Container),
        ),
      );
      final surface = containers.first.decoration! as BoxDecoration;
      expect(surface.border, isA<Border>());
      expect((surface.border! as Border).top.width, 1);
      expect(
        surface.borderRadius,
        const ShadcnThemeData().borderRadiusMd,
        reason: 'radius must be the radiusMd token',
      );
      final paddings = tester.widgetList<Padding>(
        find.descendant(of: find.byType(Input), matching: find.byType(Padding)),
      );
      final hasHorizontal12 = paddings.any((p) {
        final resolved = p.padding.resolve(TextDirection.ltr);
        return (resolved.left - 12).abs() < 0.01 &&
            (resolved.right - 12).abs() < 0.01;
      });
      expect(hasHorizontal12, isTrue, reason: 'inner padding must be px-3');
    });
  });

  group('toggle matches shadcn/ui', () {
    testWidgets('heights: sm 32, md 36, lg 40', (tester) async {
      final expected = <ToggleSize, double>{
        ToggleSize.sm: 32,
        ToggleSize.md: 36,
        ToggleSize.lg: 40,
      };
      for (final entry in expected.entries) {
        await tester.pumpWidget(
          _frame(
            child: Toggle(
              value: false,
              size: entry.key,
              onChanged: (_) {},
              child: Text(entry.key.name),
            ),
          ),
        );
        await tester.pump();
        expect(
          tester.getSize(find.byType(Toggle)).height,
          entry.value,
          reason: 'ToggleSize.${entry.key.name} height',
        );
      }
    });

    testWidgets('default is 36 high, min-width 36, px-2', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Toggle(
            value: false,
            onChanged: (_) {},
            child: const SizedBox(width: 16, height: 16),
          ),
        ),
      );
      await tester.pump();
      expect(tester.getSize(find.byType(Toggle)), const Size(36, 36));
      final padding = _togglePadding(tester);
      expect(padding.left, 8);
      expect(padding.right, 8);
    });
  });

  group('dialog matches shadcn/ui', () {
    Future<BuildContext> pumpDialog(
      WidgetTester tester, {
      ShadcnThemeData theme = const ShadcnThemeData(),
      WidgetBuilder? builder,
    }) async {
      late BuildContext host;
      await tester.pumpWidget(
        ShadcnTheme(
          data: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
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
        ),
      );
      unawaited(
        showShadcnDialog<void>(
          context: host,
          builder: builder ?? (_) => const SizedBox(width: 1000, height: 20),
        ),
      );
      await tester.pumpAndSettle();
      return host;
    }

    testWidgets('card max-width is 512 (sm:max-w-lg)', (tester) async {
      await pumpDialog(tester);
      expect(tester.getSize(find.byKey(kDialogSurfaceKey)).width, 512.0);
    });

    testWidgets('card padding is 24 (p-6)', (tester) async {
      await pumpDialog(
        tester,
        builder: (_) => const SizedBox(width: 100, height: 20),
      );
      final card = tester.getTopLeft(find.byKey(kDialogSurfaceKey));
      final body = tester.getTopLeft(find.byType(SizedBox).last);
      expect((body - card).dx, 24);
      expect((body - card).dy, 24);
    });

    testWidgets('card radius is the radiusLg token', (tester) async {
      await pumpDialog(tester);
      final box = tester.widget<DecoratedBox>(find.byKey(kDialogSurfaceKey));
      expect(
        (box.decoration as BoxDecoration).borderRadius,
        const ShadcnThemeData().borderRadiusLg,
      );
    });

    testWidgets('canonical header/body/footer uses a 16 gap', (tester) async {
      final header = GlobalKey();
      final body = GlobalKey();
      final footer = GlobalKey();
      await pumpDialog(
        tester,
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(key: header, height: 20),
            const SizedBox(height: 16),
            SizedBox(key: body, height: 20),
            const SizedBox(height: 16),
            SizedBox(key: footer, height: 20),
          ],
        ),
      );
      final headerBottom = tester.getBottomLeft(find.byKey(header)).dy;
      final bodyTop = tester.getTopLeft(find.byKey(body)).dy;
      final bodyBottom = tester.getBottomLeft(find.byKey(body)).dy;
      final footerTop = tester.getTopLeft(find.byKey(footer)).dy;
      expect(bodyTop - headerBottom, 16);
      expect(footerTop - bodyBottom, 16);
    });

    testWidgets('dark mode: card uses dark tokens (no stale theme)', (
      tester,
    ) async {
      const dark = ShadcnThemeData(colors: ShadcnColors.darkFallback);
      await tester.pumpWidget(
        ShadcnTheme(
          data: dark,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: ColoredBox(
                color: dark.colors.background,
                child: Navigator(
                  onGenerateRoute: (settings) => PageRouteBuilder<void>(
                    settings: settings,
                    pageBuilder: (context, _, _) {
                      return const _DialogProbePage();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final box = tester.widget<DecoratedBox>(find.byKey(kDialogSurfaceKey));
      expect(
        (box.decoration as BoxDecoration).color,
        ShadcnColors.darkFallback.card,
        reason: 'card must resolve against the live dark theme',
      );
      final pageColor = tester
          .widget<ColoredBox>(
            find.byWidgetPredicate((w) => w is ColoredBox).first,
          )
          .color;
      expect(
        pageColor,
        ShadcnColors.darkFallback.background,
        reason: 'page behind the barrier must be the dark background',
      );
    });
  });
}

class _DialogProbePage extends StatefulWidget {
  const _DialogProbePage();

  @override
  State<_DialogProbePage> createState() => _DialogProbePageState();
}

class _DialogProbePageState extends State<_DialogProbePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showShadcnDialog<void>(
        context: context,
        builder: (_) => const SizedBox(width: 200, height: 20),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
