// QA for `dropzone` (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the dead `focused` prop (the `focusRingColor` /
// `focusRingSpread` theme rows were never read and no ring was painted), the
// unscaled `gap`, the unscaled `statusStyle`/`hintStyle` font sizes, and the
// README-vs-code mismatch on the disabled border.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/dropzone/dropzone.dart';
import 'package:flutter_shadcn_kit/registry/components/dropzone/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null
            ? SizedBox(width: 400, child: child)
            : SizedBox(width: width, child: child),
      ),
    ),
  );
}

TextStyle _statusStyle(WidgetTester tester) {
  return tester
      .widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.byKey(dropzoneStatusKey),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      )
      .style;
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in dropzonePreviews) {
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
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('focused paints the ring token with the theme spread', (
    tester,
  ) async {
    Finder outlineOfSurface() => find.ancestor(
      of: find.byKey(dropzoneSurfaceKey),
      matching: find.byType(FocusOutline),
    );
    await tester.pumpWidget(_frame(const Dropzone(focused: true)));
    final FocusOutline outline = tester.widget<FocusOutline>(
      outlineOfSurface(),
    );
    expect(outline.focused, isTrue);
    final Border border = outline.border!;
    expect(border.top.color, ShadcnColors.lightFallback.ring);
    expect(border.top.width, 2);

    await tester.pumpWidget(_frame(const Dropzone()));
    expect(tester.widget<FocusOutline>(outlineOfSurface()).focused, isFalse);
  });

  testWidgets('the surface exposes button semantics', (tester) async {
    await tester.pumpWidget(_frame(const Dropzone()));
    final Semantics semantics = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.byKey(dropzoneSurfaceKey),
            matching: find.byType(Semantics),
          )
          .first,
    );
    expect(semantics.properties.button, isTrue);
    expect(semantics.properties.enabled, isTrue);
  });

  testWidgets('Enter on the focused surface triggers the browse action', (
    tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(_frame(Dropzone(onBrowse: () => taps++)));
    // Focus the surface through its descendant status text, per the QA rule.
    final Element status = tester.element(
      find.descendant(
        of: find.byKey(dropzoneSurfaceKey),
        matching: find.byKey(dropzoneStatusKey),
      ),
    );
    Focus.of(status).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(taps, 2);
  });

  testWidgets('status and hint font sizes scale with the theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Dropzone(hint: Text('hint')),
        data: const ShadcnThemeData(scaling: 2),
      ),
    );
    expect(_statusStyle(tester).fontSize, 28);
    final TextStyle hintStyle = tester
        .widget<DefaultTextStyle>(
          find
              .ancestor(
                of: find.text('hint'),
                matching: find.byType(DefaultTextStyle),
              )
              .first,
        )
        .style;
    expect(hintStyle.fontSize, 24);
  });

  testWidgets('a disabled surface keeps the border token at 60% opacity', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(Dropzone(enabled: false, onBrowse: () {})));
    final Container surface = tester.widget<Container>(
      find.byKey(dropzoneSurfaceKey),
    );
    final Border border =
        (surface.decoration! as BoxDecoration).border! as Border;
    expect(border.top.color, ShadcnColors.lightFallback.border);
    final AnimatedOpacity opacity = tester.widget<AnimatedOpacity>(
      find
          .ancestor(
            of: find.byKey(dropzoneStatusKey),
            matching: find.byType(AnimatedOpacity),
          )
          .first,
    );
    expect(opacity.opacity, 0.6);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: dropzonePreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: dropzonePreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });
}
