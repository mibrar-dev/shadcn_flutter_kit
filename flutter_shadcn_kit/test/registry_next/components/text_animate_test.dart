// Widget tests for the `text_animate` component.
//
// Covers rendering (light + dark), every animation style, typewriter pacing
// (character and word units), append vs restart revisions, `onSettled`, the
// cursor, reduced motion, `smoothLayout`, semantics, the four
// theme-precedence legs (through `resolveTextAnimateParts`), and the
// streaming markdown tail. Regression tests cover the old bugs: the ignored
// app theme leg, the silently dropped `withTextStreaming` cursor, word-split
// whitespace loss, and the divergent markdown-tail effects.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/markdown/markdown.dart';
import 'package:flutter_shadcn_kit/registry_next/components/text_animate/text_animate.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const TextAnimateTypewriter _off = TextAnimateTypewriter(enabled: false);
const TextAnimateTypewriter _slow = TextAnimateTypewriter(charsPerSecond: 2);
const TextAnimateTypewriter _cps10 = TextAnimateTypewriter(charsPerSecond: 10);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextAnimateTheme? scoped,
  bool reducedMotion = false,
}) {
  Widget body = SizedBox(width: 400, child: child);
  if (scoped != null) {
    body = ComponentTheme<TextAnimateTheme>(data: scoped, child: body);
  }
  if (reducedMotion) {
    body = MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: body,
    );
  }
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(
      data: data,
      child: ComponentThemes(themes: app, child: body),
    ),
  );
}

/// Rendered units in document order: literal span text plus the character
/// widgets inside `WidgetSpan`s (their plain text is just the
/// object-replacement character, so text finders cannot see them).
///
/// Each span's child widget is walked directly, so multi-`Text` spans
/// (scramble glyphs, blur layers) resolve in place.
String _rendered(WidgetTester tester) {
  final buffer = StringBuffer();
  void writeWidget(Widget widget) {
    if (widget is Text) {
      final data = widget.data;
      if (data != null) buffer.write(data);
    } else if (widget is Baseline) {
      final child = widget.child;
      if (child != null) writeWidget(child);
    } else if (widget is Opacity) {
      final child = widget.child;
      if (child != null) writeWidget(child);
    } else if (widget is Stack) {
      for (final child in widget.children) {
        writeWidget(child);
      }
    } else if (widget is Transform) {
      final child = widget.child;
      if (child != null) writeWidget(child);
    } else if (widget is ImageFiltered) {
      final child = widget.child;
      if (child != null) writeWidget(child);
    }
  }

  void writeSpan(InlineSpan span) {
    if (span is WidgetSpan) {
      writeWidget(span.child);
    } else if (span is TextSpan) {
      final text = span.text;
      if (text != null) buffer.write(text);
      final children = span.children;
      if (children != null) {
        for (final child in children) {
          writeSpan(child);
        }
      }
    }
  }

  writeSpan(_rootRichText(tester).text);
  return buffer.toString();
}

/// Root `RichText` of the animated text (inner character widgets build
/// their own `RichText`s, so `find.byType` alone matches many).
RichText _rootRichText(WidgetTester tester) {
  return tester
      .widgetList<RichText>(
        find.descendant(
          of: find.byType(TextAnimate),
          matching: find.byType(RichText),
        ),
      )
      .first;
}

void main() {
  group('rendering', () {
    testWidgets('settles to the full text, light and dark', (tester) async {
      await tester.pumpWidget(_frame(child: const TextAnimate(text: 'Hi')));
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'Hi');
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: const TextAnimate(text: 'Hi'),
        ),
      );
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'Hi');
    });

    testWidgets('widget style color flows to the spans', (tester) async {
      const red = Color(0xFFFF0000);
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'Hi',
            style: TextStyle(color: red),
            typewriter: _off,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final root = _rootRichText(tester).text;
      expect((root.style!).color, red);
    });

    testWidgets('text alignment applies', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'Hi',
            textAlign: TextAlign.center,
            typewriter: _off,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_rootRichText(tester).textAlign, TextAlign.center);
    });

    testWidgets('every style settles with onSettled firing once', (
      tester,
    ) async {
      const effects = <TextAnimateEffect>[
        TextAnimateEffect.none(),
        TextAnimateEffect.fade(),
        TextAnimateEffect.slide(),
        TextAnimateEffect.blur(),
        TextAnimateEffect.scramble(),
        TextAnimateEffect.combined(<TextAnimateEffect>[
          TextAnimateEffect.fade(),
          TextAnimateEffect.slide(),
        ]),
      ];
      for (final effect in effects) {
        final settled = <String>[];
        await tester.pumpWidget(
          _frame(
            child: TextAnimate(
              text: 'ab',
              typewriter: _off,
              effect: effect,
              onSettled: settled.add,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(_rendered(tester), 'ab', reason: '$effect');
        expect(settled, <String>['ab'], reason: '$effect');
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('scramble frames are deterministic', (tester) async {
      Future<String> run() async {
        await tester.pumpWidget(
          _frame(
            child: const TextAnimate(
              text: 'ab',
              typewriter: _off,
              effect: TextAnimateEffect.scramble(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        final plain = _rendered(tester);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(_rendered(tester), 'ab');
        return plain;
      }

      final first = await run();
      await tester.pumpWidget(const SizedBox());
      final second = await run();
      expect(second, first);
      expect(first.length, greaterThan(2));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('blur filters leave the tree once settled', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'Hi',
            typewriter: _off,
            effect: TextAnimateEffect.blur(
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ImageFiltered), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.byType(ImageFiltered), findsNothing);
      expect(_rendered(tester), 'Hi');
    });
  });

  group('typewriter', () {
    testWidgets('reveals paced units', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'abcdef', typewriter: _cps10),
        ),
      );
      await tester.pump();
      expect(_rendered(tester), 'a');
      await tester.pump(const Duration(milliseconds: 100));
      expect(_rendered(tester), 'ab');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'abcdef');
    });

    testWidgets('word units keep whitespace and join exactly', (tester) async {
      const value = '  hi  there ';
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: value,
            animateByWord: true,
            typewriter: _off,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_rendered(tester), value);
    });

    testWidgets('append animates only the tail', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'Hello', typewriter: _slow),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'Hello world', typewriter: _slow),
        ),
      );
      await tester.pump();
      expect(_rendered(tester), 'Hello ');
      await tester.pump(const Duration(milliseconds: 600));
      expect(_rendered(tester), 'Hello w');
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'Hello world');
    });

    testWidgets('non-append edit restarts from scratch', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'Hello', typewriter: _slow),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'Jello', typewriter: _slow),
        ),
      );
      await tester.pump();
      expect(_rendered(tester), 'J');
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'Jello');
    });

    testWidgets('onSettled fires once per revision', (tester) async {
      final settled = <String>[];
      Widget frame(String text) => _frame(
        child: TextAnimate(
          text: text,
          typewriter: _off,
          effect: const TextAnimateEffect.none(),
          onSettled: settled.add,
        ),
      );
      await tester.pumpWidget(frame('ab'));
      await tester.pump();
      await tester.pump();
      expect(settled, <String>['ab']);
      await tester.pumpWidget(frame('ab'));
      await tester.pump();
      expect(settled, <String>['ab']);
      await tester.pumpWidget(frame('abc'));
      await tester.pumpAndSettle();
      expect(settled, <String>['ab', 'abc']);
    });
  });
  group('cursor', () {
    testWidgets('solid cursor persists after settling', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'ab',
            typewriter: _off,
            cursor: TextAnimateCursor.solid(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'ab|');
    });

    testWidgets('blinking cursor follows its phase', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'ab',
            typewriter: _off,
            cursor: TextAnimateCursor.blink(),
          ),
        ),
      );
      await tester.pump();
      expect(_rendered(tester), 'ab|');
      await tester.pump(const Duration(milliseconds: 400));
      expect(_rendered(tester), 'ab');
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('settled cursor hides unless kept', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'ab',
            typewriter: _off,
            cursor: TextAnimateCursor.blink(showWhenSettled: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_rendered(tester), 'ab');
    });
  });

  group('layout and motion', () {
    testWidgets('smoothLayout animates height, opt-out does not', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'ab', typewriter: _off),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedSize), findsOneWidget);
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(
            text: 'ab',
            typewriter: _off,
            smoothLayout: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedSize), findsNothing);
    });

    testWidgets('reduced motion renders settled with no animation', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          reducedMotion: true,
          child: const TextAnimate(
            text: 'abcdef',
            typewriter: TextAnimateTypewriter(charsPerSecond: 1),
            effect: TextAnimateEffect.blur(duration: Duration(seconds: 5)),
            cursor: TextAnimateCursor.blink(),
          ),
        ),
      );
      await tester.pump();
      expect(_rendered(tester), contains('abcdef'));
      expect(find.byType(AnimatedSize), findsNothing);
      expect(find.byType(ImageFiltered), findsNothing);
      expect(_rendered(tester), contains('|'));
      await tester.pump(const Duration(seconds: 6));
      expect(_rendered(tester), contains('abcdef'));
      await tester.pumpAndSettle();
    });

    testWidgets('semantics carry one live label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(
          child: const TextAnimate(text: 'hello', typewriter: _off),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.byType(TextAnimate)),
        matchesSemantics(label: 'hello'),
      );
      handle.dispose();
    });
  });

  group('theme precedence', () {
    Future<
      ({
        TextStyle base,
        TextAnimateTypewriter typewriter,
        TextAnimateEffect effect,
        TextAnimateCursor cursor,
      })
    >
    pumpStyle(
      WidgetTester tester, {
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      TextAnimateTheme? scoped,
      TextAnimateTheme? widgetTheme,
      TextStyle? style,
    }) async {
      late TextStyle base;
      late TextAnimateTypewriter typewriter;
      late TextAnimateEffect effect;
      late TextAnimateCursor cursor;
      Widget body = Builder(
        builder: (context) {
          final parts = resolveTextAnimateParts(
            context,
            widgetTheme: widgetTheme,
            style: style,
          );
          base = parts.base;
          typewriter = parts.typewriter;
          effect = parts.effect;
          cursor = parts.cursor;
          return const SizedBox();
        },
      );
      if (scoped != null) {
        body = ComponentTheme<TextAnimateTheme>(data: scoped, child: body);
      }
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: app,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 14),
                child: body,
              ),
            ),
          ),
        ),
      );
      return (
        base: base,
        typewriter: typewriter,
        effect: effect,
        cursor: cursor,
      );
    }

    testWidgets('defaults inherit the ambient style and pacing', (
      tester,
    ) async {
      final parts = await pumpStyle(tester);
      expect(parts.base.fontSize, 14);
      expect(parts.typewriter.charsPerSecond, 48);
    });

    testWidgets('app leg beats defaults (old code ignored it)', (tester) async {
      final parts = await pumpStyle(
        tester,
        app: const <ComponentThemeData>[
          TextAnimateTheme(
            style: TextStyle(fontSize: 16),
            typewriter: TextAnimateTypewriter(charsPerSecond: 1),
          ),
        ],
      );
      expect(parts.base.fontSize, 16);
      expect(parts.typewriter.charsPerSecond, 1);
    });

    testWidgets('scoped leg beats app leg', (tester) async {
      final parts = await pumpStyle(
        tester,
        app: const <ComponentThemeData>[
          TextAnimateTheme(style: TextStyle(fontSize: 16)),
        ],
        scoped: const TextAnimateTheme(style: TextStyle(fontSize: 18)),
      );
      expect(parts.base.fontSize, 18);
    });

    testWidgets('widget legs beat scoped legs per field', (tester) async {
      late TextAnimateEffect effect;
      late TextAnimateCursor cursor;
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[
              TextAnimateTheme(effect: TextAnimateEffect.fade()),
            ],
            child: ComponentTheme<TextAnimateTheme>(
              data: const TextAnimateTheme(effect: TextAnimateEffect.slide()),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (context) {
                    final parts = resolveTextAnimateParts(
                      context,
                      widgetTheme: const TextAnimateTheme(
                        effect: TextAnimateEffect.blur(),
                      ),
                    );
                    effect = parts.effect;
                    cursor = parts.cursor;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(effect.kind, TextAnimateEffectKind.blur);
      expect(cursor.character, '');
    });

    testWidgets('cursor character resolves through the legs in trees', (
      tester,
    ) async {
      Future<void> pumpCursor({
        List<ComponentThemeData> app = const <ComponentThemeData>[],
        TextAnimateTheme? scoped,
        TextAnimateCursor? cursor,
      }) async {
        await tester.pumpWidget(
          _frame(
            app: app,
            scoped: scoped,
            child: TextAnimate(text: 'ab', typewriter: _off, cursor: cursor),
          ),
        );
        await tester.pumpAndSettle();
      }

      await pumpCursor(
        app: const <ComponentThemeData>[
          TextAnimateTheme(cursor: TextAnimateCursor.solid(character: '>')),
        ],
      );
      expect(_rendered(tester), 'ab>');
      await pumpCursor(
        app: const <ComponentThemeData>[
          TextAnimateTheme(cursor: TextAnimateCursor.solid(character: '>')),
        ],
        scoped: const TextAnimateTheme(
          cursor: TextAnimateCursor.solid(character: '<'),
        ),
      );
      expect(_rendered(tester), 'ab<');
      await pumpCursor(
        scoped: const TextAnimateTheme(
          cursor: TextAnimateCursor.solid(character: '<'),
        ),
        cursor: const TextAnimateCursor.solid(character: '#'),
      );
      expect(_rendered(tester), 'ab#');
    });
  });

  group('streaming markdown', () {
    // `selectable: false` below: selection needs an `Overlay` ancestor and
    // this harness pumps updated documents (a `Navigator` page would cache
    // the first one). Selection itself is covered by the `markdown` tests;
    // one selectable smoke test with a real `Overlay` follows.
    testWidgets('selectable source keeps working', (tester) async {
      Widget frame() {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: ShadcnTheme(
            data: const ShadcnThemeData(),
            child: ComponentThemes(
              themes: const <ComponentThemeData>[],
              child: Overlay(
                initialEntries: <OverlayEntry>[
                  OverlayEntry(
                    builder: (_) => SizedBox(
                      width: 400,
                      child: Markdown(data: 'Hi').withTextStreaming(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(frame());
      await tester.pumpAndSettle();
      expect(find.byType(SelectableRegion), findsOneWidget);
      expect(find.text('Hi', findRichText: true), findsOneWidget);
    });

    testWidgets('settles a plain document', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(selectable: false, data: 'Hello').withTextStreaming(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hello', findRichText: true), findsWidgets);
    });

    testWidgets('append keeps emphasis and emphasis resolves', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(selectable: false, data: 'Hello').withTextStreaming(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            selectable: false,
            data: 'Hello *world*',
          ).withTextStreaming(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('world', findRichText: true), findsOneWidget);
      final spans = tester
          .widgetList<RichText>(find.byType(RichText))
          .expand((rich) => _flatten(rich.text));
      expect(
        spans.any(
          (span) =>
              span.text == 'world' && span.style?.fontStyle == FontStyle.italic,
        ),
        isTrue,
      );
    });

    testWidgets('stable lines commit while the fence tail animates', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            selectable: false,
            data: 'a\n```dart\ncode',
          ).withTextStreaming(),
        ),
      );
      await tester.pumpAndSettle();
      final datas = tester
          .widgetList<Markdown>(find.byType(Markdown))
          .map((m) => m.data)
          .toSet();
      expect(datas, <String>{'a\n', '```dart\ncode'});
    });

    testWidgets('tail effect leaves the tree once settled', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(selectable: false, data: 'a\n```dart\ncode')
              .withTextStreaming(
                effect: const TextAnimateEffect.blur(
                  duration: Duration(milliseconds: 500),
                ),
              ),
        ),
      );
      await tester.pump();
      expect(find.byType(ImageFiltered), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.byType(ImageFiltered), findsNothing);
    });

    testWidgets('committed link taps keep their callbacks', (tester) async {
      String? tapped;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            selectable: false,
            data: '[go](https://example.com)',
            onTapLink: (text, url) => tapped = '$text|$url',
          ).withTextStreaming(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('go', findRichText: true));
      await tester.pump();
      expect(tapped, 'go|https://example.com');
    });

    testWidgets('reduced motion shows the whole document at once', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          reducedMotion: true,
          child: Markdown(selectable: false, data: 'a\n```dart\ncode')
              .withTextStreaming(
                typewriter: const TextAnimateTypewriter(charsPerSecond: 1),
              ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('code', findRichText: true), findsOneWidget);
      expect(find.byType(ImageFiltered), findsNothing);
    });
  });
}

Iterable<TextSpan> _flatten(InlineSpan span) sync* {
  if (span is TextSpan) {
    yield span;
    for (final child in span.children ?? const <InlineSpan>[]) {
      yield* _flatten(child);
    }
  }
}
