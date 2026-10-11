import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text/list.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text/text.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text/text_extension.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry/theme/tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/typography.dart';
import 'package:flutter_test/flutter_test.dart';

/// A distinctive theme, so an assertion can tell "resolved from the theme"
/// apart from "fell back to a Flutter default".
const _colors = ShadcnColors(
  brightness: Brightness.light,
  background: Color(0xFFFFFFFF),
  foreground: Color(0xFF010101),
  card: Color(0xFFFFFFFF),
  cardForeground: Color(0xFF020202),
  popover: Color(0xFFFFFFFF),
  popoverForeground: Color(0xFF030303),
  primary: Color(0xFF111111),
  primaryForeground: Color(0xFF0A0A0A),
  secondary: Color(0xFF222222),
  secondaryForeground: Color(0xFF0B0B0B),
  muted: Color(0xFFEEEEEE),
  mutedForeground: Color(0xFF0C0C0C),
  accent: Color(0xFF333333),
  accentForeground: Color(0xFF0D0D0D),
  destructive: Color(0xFF444444),
  destructiveForeground: Color(0xFFFFFFFF),
  border: Color(0xFF050505),
  input: Color(0xFF060606),
  ring: Color(0xFF070707),
  chart1: Color(0xFF080808),
  chart2: Color(0xFF090909),
  chart3: Color(0xFF0F0F0F),
  chart4: Color(0xFF121212),
  chart5: Color(0xFF131313),
  sidebar: Color(0xFF141414),
  sidebarForeground: Color(0xFF0E0E0E),
  sidebarPrimary: Color(0xFF151515),
  sidebarPrimaryForeground: Color(0xFF0F0F0F),
  sidebarAccent: Color(0xFF161616),
  sidebarAccentForeground: Color(0xFF101010),
  sidebarBorder: Color(0xFF171717),
  sidebarRing: Color(0xFF181818),
);

const _typography = Typography.geist();

const _theme = ShadcnThemeData(
  colors: _colors,
  tokens: ShadcnTokens(radius: 0.5),
  typography: _typography,
);

const _probeColor = Color(0xFFAB00CD);

/// Pumps [child] under [_theme] plus the minimum a [Text] needs to lay out.
Future<void> pumpInTheme(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: _theme,
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    ),
  );
}

/// Pumps a modifier directly under the test theme.
Future<void> pumpModifier(WidgetTester tester, Widget modifier) =>
    pumpInTheme(tester, modifier);

/// The innermost [DefaultTextStyle] the modifier chain installed. Chained
/// modifiers each install one, and the last is the one that applies to the text.
DefaultTextStyle defaultStyleOf(WidgetTester tester) =>
    tester.widget<DefaultTextStyle>(find.byType(DefaultTextStyle).last);

/// The resolved text style of the installed [DefaultTextStyle].
TextStyle styleOf(WidgetTester tester) => defaultStyleOf(tester).style;

void main() {
  group('WrappedText resolves its builders against ShadcnTheme', () {
    testWidgets('typography lookups return the theme ramp values', (
      tester,
    ) async {
      await pumpModifier(tester, const Text('x').large);
      expect(styleOf(tester), _typography.large);

      await pumpModifier(tester, const Text('x').h3);
      expect(styleOf(tester), _typography.h3);

      await pumpModifier(tester, const Text('x').mono);
      expect(styleOf(tester), _typography.mono);

      await pumpModifier(tester, const Text('x').x2Large);
      expect(styleOf(tester), _typography.x2Large);

      await pumpModifier(tester, const Text('x').thin);
      expect(styleOf(tester), _typography.thin);
    });

    testWidgets('chained modifiers merge, later calls winning', (tester) async {
      await pumpModifier(tester, const Text('x').bold.italic);
      expect(styleOf(tester), _typography.bold.merge(_typography.italic));

      await pumpModifier(tester, const Text('x').h2);
      expect(styleOf(tester), _typography.h2);

      await pumpModifier(tester, const Text('x').lead);
      expect(
        styleOf(tester),
        _typography.lead.merge(TextStyle(color: _colors.mutedForeground)),
      );
    });

    testWidgets('colour modifiers read the theme colour tokens', (
      tester,
    ) async {
      await pumpModifier(tester, const Text('x').muted);
      expect(styleOf(tester).color, _colors.mutedForeground);

      await pumpModifier(tester, const Text('x').foreground);
      expect(styleOf(tester).color, _colors.foreground);

      await pumpModifier(tester, const Text('x').primaryForeground);
      expect(styleOf(tester).color, _colors.primaryForeground);

      await pumpModifier(tester, const Text('x').secondaryForeground);
      expect(styleOf(tester).color, _colors.secondaryForeground);

      await pumpModifier(tester, const Text('x').textMuted);
      expect(
        styleOf(tester).color,
        _colors.mutedForeground,
        reason: 'textMuted is textMuted style plus the muted colour',
      );

      await pumpModifier(tester, const Text('x').underline);
      expect(styleOf(tester).decoration, TextDecoration.underline);
    });

    testWidgets('call() fills the gaps the modifier style leaves', (
      tester,
    ) async {
      await pumpModifier(
        tester,
        const Text('x').large.call(color: _probeColor, fontSize: 42),
      );
      // `large` already sets the size, so the argument's 42 does not apply;
      // the colour is absent from the modifier, so it comes through.
      expect(
        styleOf(tester),
        _typography.large.merge(const TextStyle(color: _probeColor)),
      );
    });

    testWidgets('call() alone sets every property it is given', (tester) async {
      await pumpModifier(
        tester,
        WrappedText(
          child: const Text('x'),
        ).call(color: _probeColor, fontSize: 42),
      );
      expect(
        styleOf(tester),
        const TextStyle(color: _probeColor, fontSize: 42),
      );
    });

    testWidgets('call() with no arguments leaves the style alone', (
      tester,
    ) async {
      await pumpModifier(tester, const Text('x').large.call());
      expect(styleOf(tester), _typography.large);
    });

    testWidgets('copyWithStyle lets the argument win', (tester) async {
      final modifier = WrappedText(
        style: (context, theme) => const TextStyle(fontSize: 30),
        child: const Text('x'),
      );
      // The style already on the modifier wins where both are defined.
      await pumpModifier(
        tester,
        modifier.copyWithStyle(
          (context, theme) => const TextStyle(fontSize: 12),
        ),
      );
      expect(styleOf(tester), const TextStyle(fontSize: 30));
    });

    testWidgets('copyWithStyle fills the gaps from the argument', (
      tester,
    ) async {
      final modifier = WrappedText(
        style: (context, theme) => const TextStyle(fontSize: 30),
        child: const Text('x'),
      );
      await pumpModifier(
        tester,
        modifier.copyWithStyle(
          (context, theme) => const TextStyle(fontSize: 12, height: 2),
        ),
      );
      expect(styleOf(tester), const TextStyle(fontSize: 30, height: 2));
    });

    testWidgets('copyWith replaces only the builders given', (tester) async {
      final modifier = WrappedText(
        style: (context, theme) => const TextStyle(fontSize: 30),
        maxLines: (context, theme) => 3,
        child: const Text('x'),
      );
      await pumpModifier(
        tester,
        modifier.copyWith(
          style: () =>
              (context, theme) => const TextStyle(fontSize: 11),
        ),
      );
      expect(styleOf(tester), const TextStyle(fontSize: 11));
      expect(defaultStyleOf(tester).maxLines, 3);
    });
  });

  group('layout modifiers', () {
    testWidgets('singleLine turns off wrapping and allows one line', (
      tester,
    ) async {
      await pumpModifier(tester, const Text('x').singleLine);
      expect(defaultStyleOf(tester).softWrap, isFalse);
      expect(defaultStyleOf(tester).maxLines, 1);
    });

    testWidgets('ellipsis sets the overflow', (tester) async {
      await pumpModifier(tester, const Text('x').ellipsis);
      expect(defaultStyleOf(tester).overflow, TextOverflow.ellipsis);
    });

    testWidgets('alignment modifiers set textAlign', (tester) async {
      await pumpModifier(tester, const Text('x').textCenter);
      expect(defaultStyleOf(tester).textAlign, TextAlign.center);

      await pumpModifier(tester, const Text('x').textRight);
      expect(defaultStyleOf(tester).textAlign, TextAlign.right);

      await pumpModifier(tester, const Text('x').textJustify);
      expect(defaultStyleOf(tester).textAlign, TextAlign.justify);
    });

    testWidgets('h2 wraps the child in a bottom-bordered box', (tester) async {
      await pumpModifier(tester, const Text('x').h2);
      final border =
          tester.widget<Container>(find.byType(Container)).decoration!
              as BoxDecoration;
      expect((border.border as Border).bottom.color, _colors.border);
      expect(styleOf(tester), _typography.h2);
    });

    testWidgets('inlineCode wraps the child in a muted rounded chip', (
      tester,
    ) async {
      await pumpModifier(tester, const Text('x').inlineCode);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, _colors.muted);
      expect(decoration.borderRadius, BorderRadius.circular(4));
      expect(styleOf(tester), _typography.inlineCode);
    });

    testWidgets('p adds a top margin that firstP does not', (tester) async {
      await pumpModifier(tester, const Text('x').p);
      expect(
        tester.widget<Padding>(find.byType(Padding)).padding,
        const EdgeInsets.only(top: 24),
      );

      await pumpModifier(tester, const Text('x').firstP);
      expect(find.byType(Padding), findsNothing);
      expect(styleOf(tester), _typography.p);
    });
  });

  group('then()', () {
    testWidgets('appends a span to a Text', (tester) async {
      await pumpInTheme(
        tester,
        Text('Total: ').then(const TextSpan(text: '42')),
      );

      final span =
          tester.widget<RichText>(find.byType(RichText)).text as TextSpan;
      expect(span.children!.map((child) => (child as TextSpan).text), [
        'Total: ',
        '42',
      ]);
    });

    testWidgets('appends to a RichText', (tester) async {
      await pumpInTheme(
        tester,
        RichText(
          text: const TextSpan(text: 'Total: '),
        ).then(const TextSpan(text: '42')),
      );

      final span =
          tester.widget<RichText>(find.byType(RichText)).text as TextSpan;
      expect(span.children!.map((child) => (child as TextSpan).text), [
        'Total: ',
        '42',
      ]);
    });

    testWidgets('chains, keeping every appended span', (tester) async {
      await pumpInTheme(
        tester,
        Text(
          'a',
        ).then(const TextSpan(text: 'b')).then(const TextSpan(text: 'c')),
      );

      final span =
          tester.widget<RichText>(find.byType(RichText)).text as TextSpan;
      expect(span.children!.map((child) => (child as TextSpan).text), [
        'a',
        'b',
        'c',
      ]);
    });

    testWidgets('keeps the Text style when the text carries no span', (
      tester,
    ) async {
      await pumpInTheme(
        tester,
        Text(
          'styled',
          style: const TextStyle(fontSize: 21),
        ).then(const TextSpan(text: '!')),
      );

      final span =
          tester.widget<RichText>(find.byType(RichText)).text as TextSpan;
      expect(span.style?.fontSize, 21);
    });

    test('rejects widgets that hold no text', () {
      expect(
        () => const SizedBox.shrink().then(const TextSpan(text: 'x')),
        throwsArgumentError,
      );
    });
  });

  group('unordered list', () {
    testWidgets('li draws one bullet per item and indents the subtree', (
      tester,
    ) async {
      await pumpInTheme(
        tester,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('one').li, Text('two').li],
        ),
      );

      final bullets = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .where((paint) => paint.painter != null)
          .toList();
      expect(bullets, hasLength(2));
      expect(bullets.first.size, const Size(4.5, 4.5));
      expect(find.byType(IntrinsicWidth), findsNWidgets(2));
    });

    testWidgets('li provides the next nesting depth to its own child', (
      tester,
    ) async {
      var outside = -1;
      var inside = -1;

      await pumpInTheme(
        tester,
        Builder(
          builder: (context) {
            outside = Data.maybeOf<UnorderedListData>(context)?.depth ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    inside =
                        Data.maybeOf<UnorderedListData>(context)?.depth ?? 0;
                    return const Text('item');
                  },
                ).li,
              ],
            );
          },
        ),
      );

      expect(outside, 0);
      expect(inside, 1, reason: 'li wraps its child in depth + 1');
      final bullets = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .where((paint) => paint.painter != null)
          .toList();
      expect(bullets, hasLength(1));
    });

    testWidgets('getBullet sizes the paint from the request', (tester) async {
      late CustomPaint bullet;
      await pumpInTheme(
        tester,
        Builder(
          builder: (context) =>
              Center(child: bullet = getBullet(context, 1, 9) as CustomPaint),
        ),
      );

      expect(bullet.size, const Size(9, 9));
      expect(bullet.painter, isNotNull);
    });
  });
}
