// D5 responsive audit (spec §2.9): exact breakpoints 640 / 768 / 1024 / 1280
// (+ 375) for the header, docs shell, article and footer, plus a
// route × width smoke pass that fails on any layout exception.

import 'package:docs/generated/docs_data.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/widgets/component_link_grid.dart';
import 'package:docs/widgets/docs_footer.dart';
import 'package:docs/widgets/docs_header.dart';
import 'package:docs/widgets/docs_sidebar.dart';
import 'package:docs/widgets/docs_toc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

const ValueKey<String> _searchKey = ValueKey<String>('docs-search-trigger');

Finder _inHeader(Finder matching) =>
    find.descendant(of: find.byType(DocsHeader), matching: matching);

void main() {
  testWidgets('header metrics at 1280 / 1024 / 768 / 640 / 375', (
    WidgetTester tester,
  ) async {
    Future<void> check(
      double width, {
      required double height,
      required bool nav,
      required bool menu,
      required bool search,
      double? searchWidth,
      String? searchLabel,
      required bool cta,
    }) async {
      await pumpDocsApp(tester, width: width, height: 900);
      expect(tester.takeException(), isNull, reason: 'layout @$width');
      expect(
        tester.getSize(find.byType(DocsHeader)).height,
        height,
        reason: 'header height @$width',
      );
      expect(
        _inHeader(find.text('Home')),
        nav ? findsOneWidget : findsNothing,
        reason: 'nav links @$width',
      );
      expect(
        _inHeader(find.text('Menu')),
        menu ? findsOneWidget : findsNothing,
        reason: 'hamburger @$width',
      );
      if (search) {
        expect(
          tester.getSize(find.byKey(_searchKey)).width,
          searchWidth,
          reason: 'search width @$width',
        );
        expect(find.text(searchLabel!), findsOneWidget, reason: '@$width');
      } else {
        expect(find.byKey(_searchKey), findsNothing, reason: 'search @$width');
      }
      expect(
        _inHeader(find.text('Get Started')),
        cta ? findsOneWidget : findsNothing,
        reason: 'CTA @$width',
      );
    }

    await check(
      1280,
      height: 64,
      nav: true,
      menu: false,
      search: true,
      searchWidth: 256,
      searchLabel: 'Search documentation…',
      cta: true,
    );
    await check(
      1024,
      height: 64,
      nav: true,
      menu: false,
      search: true,
      searchWidth: 160,
      searchLabel: 'Search…',
      cta: true,
    );
    await check(
      768,
      height: 56,
      nav: false,
      menu: true,
      search: true,
      searchWidth: 192,
      searchLabel: 'Search…',
      cta: true,
    );
    await check(
      640,
      height: 56,
      nav: false,
      menu: true,
      search: false,
      cta: false,
    );
    await check(
      375,
      height: 56,
      nav: false,
      menu: true,
      search: false,
      cta: false,
    );
  });

  testWidgets('docs article box at 1280 / 1024 / 768 / 640 / 375', (
    WidgetTester tester,
  ) async {
    Future<void> check(
      double width, {
      required bool sidebar,
      required bool toc,
      required double left,
      required double top,
    }) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        width: width,
        height: 900,
      );
      await goTo(tester, delegate, '/docs/installation');
      expect(
        find.byType(DocsSidebar),
        sidebar ? findsOneWidget : findsNothing,
        reason: 'sidebar @$width',
      );
      expect(
        find.byType(DocsToc),
        toc ? findsOneWidget : findsNothing,
        reason: 'TOC @$width',
      );
      final Offset title = tester.getTopLeft(find.text('Getting started'));
      expect(title.dx, left, reason: 'article left @$width');
      expect(title.dy, top, reason: 'article top @$width');
    }

    // 640 px max article, centred in the remaining column; py 32 / px 0 at
    // `lg+` (title box 64+16+32 = 112), py 24 / px 16 below `md` with
    // `--top-spacing: 0` (title box 56+0+24 = 80) (spec §2.9).
    await check(1280, sidebar: true, toc: true, left: 320, top: 112);
    await check(1024, sidebar: true, toc: false, left: 336, top: 112);
    await check(768, sidebar: false, toc: false, left: 64, top: 80);
    await check(640, sidebar: false, toc: false, left: 24, top: 80);
    await check(375, sidebar: false, toc: false, left: 24, top: 80);
  });

  testWidgets('footer heights: 96 at xl, 56 below; hidden on /docs', (
    WidgetTester tester,
  ) async {
    await pumpDocsApp(tester, width: 1280, height: 900);
    expect(tester.getSize(find.byType(DocsFooter)).height, 96);

    await pumpDocsApp(tester, width: 1024, height: 900);
    expect(tester.getSize(find.byType(DocsFooter)).height, 56);

    final DocsRouterDelegate delegate = await pumpDocsApp(
      tester,
      width: 1280,
      height: 900,
    );
    await goTo(tester, delegate, '/docs');
    expect(find.byType(DocsFooter), findsNothing);
  });

  testWidgets('components index grid: 2 columns below md, 3 at md+', (
    WidgetTester tester,
  ) async {
    // The index renders one grid per category (P6-B3); measure the first.
    int columns() => tester
        .widgetList(
          find.descendant(
            of: find.byType(ComponentLinkGrid).first,
            matching: find.byType(Expanded),
          ),
        )
        .length;

    final DocsRouterDelegate wide = await pumpDocsApp(
      tester,
      width: 1280,
      height: 900,
    );
    await goTo(tester, wide, '/docs/components');
    expect(
      find.byType(ComponentLinkGrid),
      findsNWidgets(kComponentCategoryGroups.length),
    );
    expect(columns(), 3);

    final DocsRouterDelegate narrow = await pumpDocsApp(
      tester,
      width: 640,
      height: 900,
    );
    await goTo(tester, narrow, '/docs/components');
    expect(columns(), 2);
  });

  testWidgets('every route lays out at 375 / 640 / 768 / 1024 / 1280', (
    WidgetTester tester,
  ) async {
    const List<String> routes = <String>[
      '/',
      '/docs',
      '/docs/installation',
      '/docs/theming',
      '/docs/dark-mode',
      '/docs/cli',
      '/docs/components',
      '/docs/components/button',
      '/themes',
      '/blocks',
      '/blocks/dashboard',
      '/blocks/dashboard-01',
      '/not-found',
    ];
    for (final double width in <double>[375, 640, 768, 1024, 1280]) {
      for (final String route in routes) {
        // Fresh tree per route: re-pumping the same app across the whole
        // matrix would reuse the delegate's 50-deep route stack, which is
        // not what this audit measures.
        await tester.pumpWidget(const SizedBox.shrink());
        final DocsRouterDelegate delegate = await pumpDocsApp(
          tester,
          width: width,
          height: 900,
        );
        await goTo(tester, delegate, route);
        expect(
          tester.takeException(),
          isNull,
          reason: 'layout exception on $route @ $width',
        );
      }
    }
  });
}
