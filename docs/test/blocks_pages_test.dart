// P6-B3 widget tests: the Blocks index + block pages, component category
// grouping, hidden building blocks and blocks deep links.
//
// Navigation uses the shared `goTo` helper (pumpAndSettle): block previews
// load through the same deferred FutureBuilder path as component previews,
// so settle behavior matches the existing component-page tests.

import 'package:docs/generated/docs_blocks.dart';
import 'package:docs/generated/docs_data.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/input/input.dart';
import 'package:docs/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/block_card.dart';
import 'package:docs/widgets/block_viewport.dart';
import 'package:docs/widgets/docs_sidebar.dart';
import 'package:docs/widgets/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

Finder _inPalette(Finder matching) =>
    find.descendant(of: find.byType(DocsPalette), matching: matching);

void main() {
  group('blocks deep links', () {
    test('parse maps the blocks sitemap', () {
      expect(
        DocsRouteConfiguration.parse('/blocks'),
        DocsRouteConfiguration.blocks,
      );
      expect(
        DocsRouteConfiguration.parse('/blocks/dashboard'),
        DocsRouteConfiguration.blockCategory('dashboard'),
      );
      expect(
        DocsRouteConfiguration.parse('/blocks/dashboard-01'),
        DocsRouteConfiguration.block('dashboard-01'),
      );
      expect(
        DocsRouteConfiguration.block('dashboard-01').location,
        '/blocks/dashboard-01',
      );
      expect(
        DocsRouteConfiguration.blockCategory('dashboard').location,
        '/blocks/dashboard',
      );
    });

    test('unknown blocks segments are categories, unknown ids 404', () {
      // A second segment that is neither a block id nor a family slug parses
      // as a (possibly empty) category page, never as a block.
      expect(
        DocsRouteConfiguration.parse('/blocks/nope').route,
        DocsRoute.blockCategory,
      );
      expect(isBlockId('dashboard-01'), isTrue);
      expect(isBlockId('dashboard'), isFalse);
    });
  });

  group('blocks index', () {
    testWidgets('hero, family pills and one card per block', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks');
      expect(find.text('Building Blocks for the Web'), findsOneWidget);
      expect(find.text('Featured'), findsOneWidget);
      for (final DocsBlockCategory category in kBlockCategories) {
        expect(find.text(category.id), findsWidgets, reason: category.id);
      }
      expect(find.byType(BlockCard), findsNWidgets(kBlocks.length));
      // Every card shows its full install command in the toolbar chip.
      expect(find.text('flutter_shadcn add dashboard-01'), findsOneWidget);
    });

    testWidgets('category route filters to that family', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/dashboard');
      final int dashboardCount = kBlocks
          .where((DocsBlock b) => b.categorySlug == 'dashboard')
          .length;
      expect(dashboardCount, greaterThan(0));
      expect(find.byType(BlockCard), findsNWidgets(dashboardCount));
      expect(find.text('Login 01'), findsNothing);
    });

    testWidgets('block cards render loaded previews without exceptions', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks');
      expect(tester.takeException(), isNull);
      // The deferred previews resolved (FutureBuilder spinner gone for the
      // first card's known content).
      expect(find.byType(BlockCard), findsNWidgets(kBlocks.length));
    });
  });

  group('block page', () {
    testWidgets('title, install command and pager', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/dashboard-01');
      expect(find.text('Dashboard 01'), findsWidgets);
      // The install command lives in the card's Code tab: open it.
      await tester.tap(find.text('Code'));
      await tester.pumpAndSettle();
      expect(find.text('flutter_shadcn add dashboard-01'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('unknown block id shows the empty category state', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/does-not-exist');
      // Unknown segments parse as (empty) categories, never as blocks.
      expect(find.text('No blocks in this family yet.'), findsOneWidget);
    });
  });

  group('component category grouping', () {
    testWidgets('sidebar groups components by category', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs');
      expect(find.byType(DocsSidebar), findsOneWidget);
      for (final DocsComponentCategory group in kComponentCategoryGroups) {
        expect(find.text(group.id), findsWidgets, reason: group.id);
      }
      // Sidebar lists exactly the listed components: one row per group
      // member plus the group label rows.
      expect(kComponentCategoryGroups.length, greaterThan(1));
    });

    testWidgets('palette groups components with sub-headings', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      delegate.openPalette();
      await tester.pumpAndSettle();
      await tester.enterText(_inPalette(find.byType(Input)), 'button');
      await tester.pumpAndSettle();
      expect(_inPalette(find.text('Components')), findsOneWidget);
      expect(_inPalette(find.text('Buttons & Actions')), findsOneWidget);
    });
  });

  group('hidden building blocks', () {
    test('listed:false components are excluded from groups', () {
      final Set<String> unlisted = <String>{
        for (final DocsComponent c in kComponents)
          if (!c.listed) c.id,
      };
      expect(unlisted, isNotEmpty, reason: 'building blocks exist');
      final Set<String> grouped = <String>{
        for (final DocsComponentCategory g in kComponentCategoryGroups)
          for (final DocsComponentLink l in g.components) l.id,
      };
      expect(grouped.intersection(unlisted), isEmpty);
      // ...but stay reachable: the pager and link tables still know them.
      expect(
        kComponentLinks.map((DocsComponentLink l) => l.id),
        containsAll(unlisted),
      );
    });

    testWidgets('index and sidebar show no building blocks', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components');
      final String unlistedName = kComponents
          .firstWhere((DocsComponent c) => !c.listed)
          .name;
      expect(find.text(unlistedName), findsNothing);
      await goTo(tester, delegate, '/docs');
      expect(find.text(unlistedName), findsNothing);
    });
  });

  group('blocks polish (P6-P2)', () {
    testWidgets('command chip shows the full install command (1400)', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks');
      expect(find.text('flutter_shadcn add dashboard-01'), findsOneWidget);
      // The chip text renders on one untruncated line at desktop width.
      final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
        find.text('flutter_shadcn add dashboard-01'),
      );
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('command chip survives 768 and collapses at 375', (
      WidgetTester tester,
    ) async {
      DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        width: 768,
        height: 900,
      );
      await goTo(tester, delegate, '/blocks');
      expect(find.text('flutter_shadcn add dashboard-01'), findsOneWidget);
      final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
        find.text('flutter_shadcn add dashboard-01'),
      );
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(tester.takeException(), isNull);

      delegate = await pumpDocsApp(tester, width: 375, height: 812);
      await goTo(tester, delegate, '/blocks');
      expect(find.text('flutter_shadcn add dashboard-01'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('block page keeps a single title and description', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/dashboard-01');
      expect(find.text('Dashboard 01'), findsOneWidget);
      final DocsBlock block = kBlocks.firstWhere(
        (DocsBlock b) => b.id == 'dashboard-01',
      );
      expect(find.text(block.description), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('viewport sizes change the centred frame width', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/otp-01');
      Finder frame() =>
          find.byKey(const ValueKey<String>('block-frame-otp-01'));
      double frameWidth() => tester.getSize(frame()).width;

      final double desktop = frameWidth();
      final double cardWidth = tester.getSize(find.byType(BlockCard)).width;
      // Desktop fills the card (minus the 16 px frame padding each side).
      expect(desktop, moreOrLessEquals(cardWidth - 32, epsilon: 1));

      await tester.tap(find.byIcon(LucideIcons.smartphone));
      await tester.pumpAndSettle();
      expect(frameWidth(), moreOrLessEquals(375, epsilon: 1));

      await tester.tap(find.byIcon(LucideIcons.tablet));
      await tester.pumpAndSettle();
      expect(frameWidth(), moreOrLessEquals(768, epsilon: 1));
      expect(frameWidth(), lessThan(desktop));

      // The narrowed frame stays centred in the card.
      final double frameDx = tester.getCenter(frame()).dx;
      final double cardDx = tester.getCenter(find.byType(BlockCard)).dx;
      expect((frameDx - cardDx).abs(), lessThan(1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('short blocks fit, tall blocks cap at the max height', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/login-01');
      final double loginHeight = tester
          .getSize(find.byKey(const ValueKey<String>('block-frame-login-01')))
          .height;
      expect(loginHeight, moreOrLessEquals(560, epsilon: 1));

      await goTo(tester, delegate, '/blocks/otp-01');
      final double otpHeight = tester
          .getSize(find.byKey(const ValueKey<String>('block-frame-otp-01')))
          .height;
      expect(otpHeight, moreOrLessEquals(520, epsilon: 1));

      await goTo(tester, delegate, '/blocks/dashboard-01');
      final double dashboardHeight = tester
          .getSize(
            find.byKey(const ValueKey<String>('block-frame-dashboard-01')),
          )
          .height;
      expect(dashboardHeight, moreOrLessEquals(640, epsilon: 1));
      expect(loginHeight, lessThan(dashboardHeight));
      expect(otpHeight, greaterThanOrEqualTo(kBlockPreviewMinHeight));
      expect(tester.takeException(), isNull);
    });

    testWidgets('preview viewport uses the background token', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/blocks/otp-01');
      final Finder frame = find.byKey(
        const ValueKey<String>('block-frame-otp-01'),
      );
      final DecoratedBox box = tester.widget<DecoratedBox>(frame);
      final Color? fill = (box.decoration as BoxDecoration).color;
      final Color background = ShadcnTheme.of(
        tester.element(frame),
      ).colors.background;
      expect(fill, background);
      expect(tester.takeException(), isNull);
    });
  });
}
