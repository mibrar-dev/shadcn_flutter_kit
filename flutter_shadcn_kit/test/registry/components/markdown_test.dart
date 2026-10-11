// Widget tests for the `markdown` component.
//
// Covers block rendering (light + dark), inline emphasis, link/image/
// heading taps with the preview overlay, the four theme-precedence legs,
// `blockBuilder`/`onDocumentReady`, and regressions for the old bugs:
// hardcoded link blue, `GeistMono`, the throwing `%` slug, the static
// failed-image cache and every Material import.

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/markdown.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fails every HTTP request immediately so network-image tests never touch
/// the sandbox network (hermetic; the fallback path still runs through
/// Image.network's errorBuilder).
class _FailingHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      Future.error(const SocketException('hermetic test'));
}

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  MarkdownTheme? scoped,
}) {
  Widget body = SizedBox(width: 400, child: child);
  if (scoped != null) {
    body = ComponentTheme<MarkdownTheme>(data: scoped, child: body);
  }
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(
      data: data,
      child: ComponentThemes(
        themes: app,
        child: Navigator(
          onGenerateRoute: (_) =>
              PageRouteBuilder<void>(pageBuilder: (_, _, _) => body),
        ),
      ),
    ),
  );
}

/// First link span in the tree, if any.
TextSpan? _linkSpan(WidgetTester tester) {
  for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
    final found = _search(rich.text);
    if (found != null) return found;
  }
  return null;
}

TextSpan? _search(InlineSpan span) {
  if (span is TextSpan) {
    if (span.recognizer != null) return span;
    for (final child in span.children ?? const <InlineSpan>[]) {
      final found = _search(child);
      if (found != null) return found;
    }
  }
  return null;
}

/// All text spans in every [RichText].
Iterable<TextSpan> _allSpans(WidgetTester tester) sync* {
  for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
    yield* _flatten(rich.text);
  }
}

Iterable<TextSpan> _flatten(InlineSpan span) sync* {
  if (span is TextSpan) {
    yield span;
    for (final child in span.children ?? const <InlineSpan>[]) {
      yield* _flatten(child);
    }
  }
}

void main() {
  group('blocks', () {
    testWidgets('paragraph renders its text', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: 'Hello *world*')),
      );
      expect(find.textContaining('Hello', findRichText: true), findsWidgets);
      expect(find.textContaining('world', findRichText: true), findsWidgets);
    });

    testWidgets('empty data renders nothing', (tester) async {
      await tester.pumpWidget(_frame(child: const Markdown(data: '   ')));
      expect(find.byType(RichText), findsNothing);
    });

    testWidgets('headings scale and expose header semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _frame(child: const Markdown(data: '# Title\n\n###### Tiny')),
      );
      final h1 = tester
          .widgetList<RichText>(find.byType(RichText))
          .map((rich) => rich.text)
          .whereType<TextSpan>()
          .firstWhere((span) => span.style?.fontSize == 28);
      expect(h1.children?.isNotEmpty, isTrue);
      expect(
        tester
            .getSemantics(find.text('Title', findRichText: true))
            .flagsCollection
            .isHeader,
        isTrue,
      );
      expect(find.text('Tiny', findRichText: true), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('lists, tasks, quote, code, table and rule render', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data:
                '- a\n1. b\n- [x] c\n> quoted\n```dart\ncode\n```\n| A | B |\n| - | - |\n| 1 | 2 |\n\n---',
            imageBuilder: (context, url, alt) => const SizedBox(),
          ),
        ),
      );
      expect(find.text('• ', findRichText: true), findsWidgets);
      expect(find.text('1. ', findRichText: true), findsWidgets);
      expect(find.byType(Table), findsOneWidget);
      expect(find.text('code', findRichText: true), findsOneWidget);
      expect(find.text('quoted', findRichText: true), findsOneWidget);
      expect(find.text('dart', findRichText: true), findsOneWidget);
    });

    testWidgets('imageBuilder replaces image loading', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '![alt](https://example.com/x.png)',
            imageBuilder: (context, url, alt) => Text('img:$alt'),
          ),
        ),
      );
      expect(find.text('img:alt'), findsOneWidget);
    });

    testWidgets('failed network image falls back to alt text', (tester) async {
      await HttpOverrides.runZoned(() async {
        await tester.pumpWidget(
          _frame(
            child: const Markdown(data: '![oops](https://example.com/x.png)'),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('oops', findRichText: true), findsWidgets);
      }, createHttpClient: (_) => _FailingHttpClient());
    });
  });

  group('inline emphasis', () {
    testWidgets('bold, italic, code and strike resolve', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: '**b** *i* `c` ~~s~~')),
      );
      final spans = _allSpans(tester).toList();
      expect(
        spans.any(
          (span) =>
              span.text == 'b' && span.style?.fontWeight == FontWeight.w700,
        ),
        isTrue,
      );
      expect(
        spans.any(
          (span) =>
              span.text == 'i' && span.style?.fontStyle == FontStyle.italic,
        ),
        isTrue,
      );
      expect(
        spans.any(
          (span) =>
              span.text == 's' &&
              span.style?.decoration == TextDecoration.lineThrough,
        ),
        isTrue,
      );
    });

    testWidgets('code uses ambient mono, never hardcoded GeistMono', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: 'Use `print` here')),
      );
      final code = _allSpans(tester).firstWhere((span) => span.text == 'print');
      expect(code.style?.fontFamily, isNot('GeistMono'));
    });
  });

  group('links', () {
    testWidgets('tap fires link callbacks with classification', (tester) async {
      String? tapped;
      MarkdownLinkTapDetails? details;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '[docs](https://example.com)',
            onTapLink: (text, url) => tapped = '$text|$url',
            onTapLinkDetails: (value) => details = value,
          ),
        ),
      );
      await tester.tap(find.text('docs', findRichText: true));
      await tester.pump();
      expect(tapped, 'docs|https://example.com');
      expect(details?.kind, MarkdownLinkKind.external);
    });

    testWidgets('anchor links report anchor kind without crashing', (
      tester,
    ) async {
      MarkdownLinkTapDetails? details;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '# Target\n\n[go](#target)',
            onTapLinkDetails: (value) => details = value,
          ),
        ),
      );
      await tester.tap(find.text('go', findRichText: true));
      await tester.pump();
      expect(details?.kind, MarkdownLinkKind.anchor);
    });

    testWidgets('link color follows the primary token, light and dark', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: '[x](https://e.com)')),
      );
      expect(
        _linkSpan(tester)?.style?.color,
        ShadcnColors.lightFallback.primary,
      );
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: const Markdown(data: '[x](https://e.com)'),
        ),
      );
      expect(
        _linkSpan(tester)?.style?.color,
        ShadcnColors.darkFallback.primary,
      );
    });
  });

  group('theme precedence', () {
    const data = '[x](https://e.com)';
    testWidgets('defaults use the primary token', (tester) async {
      await tester.pumpWidget(_frame(child: const Markdown(data: data)));
      expect(
        _linkSpan(tester)?.style?.color,
        ShadcnColors.lightFallback.primary,
      );
    });

    testWidgets('app leg beats defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            MarkdownTheme(linkColor: ThemedColor.ref(ColorRef.accent)),
          ],
          child: const Markdown(data: data),
        ),
      );
      expect(
        _linkSpan(tester)?.style?.color,
        ShadcnColors.lightFallback.accent,
      );
    });

    testWidgets('scoped leg beats app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            MarkdownTheme(linkColor: ThemedColor.ref(ColorRef.accent)),
          ],
          scoped: const MarkdownTheme(
            linkColor: ThemedColor.ref(ColorRef.destructive),
          ),
          child: const Markdown(data: data),
        ),
      );
      expect(
        _linkSpan(tester)?.style?.color,
        ShadcnColors.lightFallback.destructive,
      );
    });

    testWidgets('widget leg beats scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const MarkdownTheme(
            linkColor: ThemedColor.ref(ColorRef.destructive),
          ),
          child: const Markdown(
            data: data,
            theme: MarkdownTheme(linkColor: ThemedColor.ref(ColorRef.ring)),
          ),
        ),
      );
      expect(_linkSpan(tester)?.style?.color, ShadcnColors.lightFallback.ring);
    });

    testWidgets('legs merge per field across theme and body style', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            MarkdownTheme(linkColor: ThemedColor.ref(ColorRef.accent)),
          ],
          scoped: const MarkdownTheme(style: TextStyle(fontSize: 20)),
          child: const Markdown(data: 'plain [x](https://e.com)'),
        ),
      );
      expect(
        _linkSpan(tester)?.style?.color,
        ShadcnColors.lightFallback.accent,
      );
      final body = _allSpans(
        tester,
      ).firstWhere((span) => span.text == 'plain ');
      expect(body.style?.fontSize, 20);
    });
  });

  group('callbacks and overrides', () {
    testWidgets('heading tap reports slug and level', (tester) async {
      MarkdownHeadingTapDetails? tapped;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '# Hello World',
            onTapHeading: (value) => tapped = value,
          ),
        ),
      );
      await tester.tap(find.text('Hello World', findRichText: true));
      expect(tapped?.anchor, 'hello-world');
      expect(tapped?.level, 1);
    });

    testWidgets('percent headings never throw (decode fallback)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '# 100% sure\n\n[go](#100-sure)',
            onTapHeading: (_) {},
          ),
        ),
      );
      expect(find.text('100% sure', findRichText: true), findsOneWidget);
      await tester.tap(find.text('go', findRichText: true));
      await tester.pump();
    });

    testWidgets('blockBuilder overrides a block', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '# Hi',
            blockBuilder: (context, details) =>
                details.kind == MarkdownBlockKind.heading
                ? const Text('custom')
                : null,
          ),
        ),
      );
      expect(find.text('custom'), findsOneWidget);
      expect(find.text('Hi', findRichText: true), findsNothing);
    });

    testWidgets('onDocumentReady reports counts', (tester) async {
      MarkdownDocumentMetrics? metrics;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '# H\n\ntext\n\n| A |\n| - |\n| 1 |\n',
            onDocumentReady: (value) => metrics = value,
            imageBuilder: (context, url, alt) => const SizedBox(),
          ),
        ),
      );
      await tester.pump();
      expect(metrics?.headingCount, 1);
      expect(metrics?.tableCount, 1);
      expect(metrics?.blockCount, greaterThan(0));
    });

    testWidgets('image tap opens the preview and close dismisses it', (
      tester,
    ) async {
      var imaged = false;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '![alt](https://example.com/x.png)',
            onTapImage: (_) => imaged = true,
            imageBuilder: (context, url, alt) => Text('pic:$alt'),
          ),
        ),
      );
      await tester.tap(find.text('pic:alt'));
      await tester.pumpAndSettle();
      expect(imaged, isTrue);
      expect(find.text('alt'), findsWidgets);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('alt'), findsNothing);
    });
  });

  group('selection and layout', () {
    testWidgets('selectable wraps in a region with shadcn controls', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const Markdown(data: 'select me')));
      expect(find.byType(SelectableRegion), findsOneWidget);
    });

    testWidgets('selectable false skips the region', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: 'plain', selectable: false)),
      );
      expect(find.byType(SelectableRegion), findsNothing);
    });

    testWidgets('unshrinkwrapped lays out a scrolling list', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: 'a\n\nb', shrinkWrap: false)),
      );
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('copyWith replaces data', (tester) async {
      const first = Markdown(data: 'one');
      final second = first.copyWith(data: 'two');
      expect(second.data, 'two');
      expect(second.selectable, first.selectable);
    });
  });

  group('restored scope (QA round 2)', () {
    testWidgets('R1 network image has loading and error slots', (tester) async {
      await HttpOverrides.runZoned(() async {
        await tester.pumpWidget(
          _frame(
            child: const Markdown(data: '![alt](https://example.com/x.png)'),
          ),
        );
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.loadingBuilder, isNotNull);
        expect(image.errorBuilder, isNotNull);
        await tester.pumpAndSettle();
        expect(find.text('alt', findRichText: true), findsWidgets);
      }, createHttpClient: (_) => _FailingHttpClient());
    });

    testWidgets('R2 reference links resolve and fire taps', (tester) async {
      String? tapped;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '[go][there]\n\n[there]: https://e.com',
            onTapLink: (text, url) => tapped = '$text|$url',
          ),
        ),
      );
      expect(find.text('go', findRichText: true), findsOneWidget);
      await tester.tap(find.text('go', findRichText: true));
      await tester.pump();
      expect(tapped, 'go|https://e.com');
    });

    testWidgets('R3 footnote markers link to the trailing section', (
      tester,
    ) async {
      MarkdownLinkTapDetails? details;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '[^a]\n\n[^a]: The footnote.',
            onTapLinkDetails: (value) => details = value,
          ),
        ),
      );
      expect(
        find.textContaining('The footnote.', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('1', findRichText: true), findsOneWidget);
      await tester.tap(find.text('1', findRichText: true));
      await tester.pump();
      expect(details?.kind, MarkdownLinkKind.anchor);
      expect(details?.url, '#fn-a');
    });

    testWidgets('R4 quotes nest without a depth limit', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Markdown(data: '> a\n>> b\n>>> deep')),
      );
      expect(find.textContaining('deep', findRichText: true), findsWidgets);
    });

    testWidgets('R5 details disclosure expands on trigger tap', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Markdown(
            data:
                '<details>\n<summary>More</summary>\nHidden body.\n</details>',
          ),
        ),
      );
      expect(find.text('More'), findsOneWidget);
      expect(find.text('Hidden body.', findRichText: true), findsNothing);
      await tester.tap(find.byIcon(LucideIcons.chevronsUpDown));
      await tester.pump();
      expect(find.text('Hidden body.', findRichText: true), findsOneWidget);
    });

    testWidgets('R6 task lists report checked without toggling', (
      tester,
    ) async {
      MarkdownTapElementDetails? tapped;
      await tester.pumpWidget(
        _frame(
          child: Markdown(
            data: '- [x] done\n- [ ] open',
            onTapElement: (value) => tapped = value,
          ),
        ),
      );
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
      await tester.tap(find.byIcon(LucideIcons.check));
      await tester.pump();
      expect(tapped?.kind, MarkdownTapElementKind.listItem);
      expect(tapped?.checked, isTrue);
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
    });
  });
}
