import 'package:docs/generated/app_theme.dart';
import 'package:docs/generated/docs_data.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/app/app.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/components/switch/switch.dart';
import 'package:docs/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:docs/widgets/collage.dart';
import 'package:docs/widgets/component_link_grid.dart';
import 'package:docs/widgets/copy_button.dart';
import 'package:docs/widgets/docs_footer.dart';
import 'package:docs/widgets/docs_sidebar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  testWidgets('landing renders the badge, H1, CTAs and the live collage', (
    WidgetTester tester,
  ) async {
    await pumpDocsApp(tester);
    expect(
      find.text('${kStats.components} components ready to install'),
      findsOneWidget,
    );
    expect(find.text('A Flutter component kit you own'), findsOneWidget);
    expect(find.text('View Components'), findsOneWidget);
    expect(find.text('Get Started'), findsWidgets);
    expect(find.byType(Switch), findsWidgets);
    // Desktop: the collage is live (tickers enabled).
    expect(
      TickerMode.valuesOf(tester.element(find.byType(Switch).first)).enabled,
      isTrue,
    );
  });

  testWidgets('<768 landing uses the static, ticker-off collage fallback', (
    WidgetTester tester,
  ) async {
    await pumpDocsApp(tester, width: 375, height: 812);
    expect(find.byType(StaticCollage), findsOneWidget);
    final Finder inner = find
        .descendant(
          of: find.byType(StaticCollage),
          matching: find.byType(Button),
        )
        .first;
    expect(TickerMode.valuesOf(tester.element(inner)).enabled, isFalse);
  });

  testWidgets('header: nav items and the 256/160/192 search widths', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester, width: 1440);
    expect(delegate.currentConfiguration, DocsRouteConfiguration.landing);
    expect(find.text('Search documentation…'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Themes'), findsOneWidget);

    tester.view.physicalSize = const Size(1100, 900);
    await tester.pumpAndSettle();
    expect(find.text('Search…'), findsOneWidget);
    expect(find.text('Search documentation…'), findsNothing);

    tester.view.physicalSize = const Size(800, 900);
    await tester.pumpAndSettle();
    expect(find.text('Search…'), findsOneWidget);

    tester.view.physicalSize = const Size(700, 900);
    await tester.pumpAndSettle();
    expect(find.text('Search…'), findsNothing);
    expect(find.text('Menu'), findsOneWidget);
  });

  testWidgets('landing footer shows on `/` only', (WidgetTester tester) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    expect(find.byType(DocsFooter), findsOneWidget);
    await goTo(tester, delegate, '/docs');
    expect(find.byType(DocsFooter), findsNothing);
  });

  testWidgets('components index renders the generated alphabetical grid', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    await goTo(tester, delegate, '/docs/components');
    expect(find.text('Components'), findsWidgets);
    expect(find.text('All Components'), findsWidgets); // heading + TOC link
    final ComponentLinkGrid grid = tester.widget<ComponentLinkGrid>(
      find.byType(ComponentLinkGrid),
    );
    expect(grid.links.length, kComponentLinks.length);
    expect(grid.links.first.name, 'Accordion');
    // Link navigation itself is covered by `palette_test.dart` (Enter on the
    // Components page entry); this test stays on the D3-owned index page so it
    // does not depend on D4's component-page layout.
  });

  testWidgets('docs shell renders sidebar, article and TOC at xl', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    await goTo(tester, delegate, '/docs');
    expect(find.byType(DocsSidebar), findsOneWidget);
    expect(find.text('Sections'), findsOneWidget);
    expect(find.text('On This Page'), findsOneWidget);
    // Heading + TOC link.
    expect(find.text('Source you own'), findsNWidgets(2));
    // Bottom pager to Installation + sidebar item.
    expect(find.text('Installation'), findsWidgets);
  });

  testWidgets(
    'docs shell hides the TOC below 1280 and the sidebar below 1024',
    (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        width: 1100,
      );
      await goTo(tester, delegate, '/docs');
      expect(find.text('On This Page'), findsNothing);
      expect(find.byType(DocsSidebar), findsOneWidget);

      tester.view.physicalSize = const Size(900, 900);
      await tester.pumpAndSettle();
      expect(find.byType(DocsSidebar), findsNothing);
      expect(find.text('On This Page'), findsNothing);
    },
  );

  testWidgets('mobile nav popper opens under the header and closes on Escape', (
    WidgetTester tester,
  ) async {
    final DocsRouterDelegate delegate = await pumpDocsApp(
      tester,
      width: 700,
      height: 900,
    );
    expect(find.text('Menu'), findsOneWidget);
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    // Groups: Menu (site nav) and Sections (docs pages).
    expect(find.text('Sections'), findsOneWidget);
    expect(find.text('Installation'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Sections'), findsNothing);
    expect(delegate.currentConfiguration, DocsRouteConfiguration.landing);
  });

  testWidgets('resolved typography: h1 semibold, body regular, nav medium', (
    WidgetTester tester,
  ) async {
    await pumpDocsApp(tester);
    TextStyle styleOf(Finder finder) {
      final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
        finder,
      );
      return paragraph.text.style!;
    }

    // The family comes from the active preset's `fonts.sans` (the neutral base
    // declares `Geist, sans-serif`); D7 wires `Typography.applyFonts`, which no
    // registry widget used to call (see P6-D7.md, registry gap 1).
    final TextStyle h1 = styleOf(find.text('A Flutter component kit you own'));
    expect(h1.fontWeight, FontWeight.w600, reason: 'h1 is semibold');
    expect(h1.fontFamily, 'Geist', reason: "neutral preset's fonts.sans");
    expect(h1.fontFamilyFallback, <String>['sans-serif']);
    expect(h1.fontSize, 48);

    final TextStyle body = styleOf(
      find.textContaining('Widgets-only, accessible'),
    );
    expect(body.fontWeight, FontWeight.w400, reason: 'body copy is regular');
    expect(body.fontFamily, 'Geist');

    final TextStyle nav = styleOf(find.text('Home'));
    expect(nav.fontWeight, FontWeight.w500, reason: 'nav links are medium');
    expect(nav.fontSize, 14);

    final TextStyle muted = styleOf(
      find.textContaining('components ready to install'),
    );
    expect(muted.fontWeight, FontWeight.w500, reason: 'badge 12/500');
    expect(muted.fontSize, 12);
  });

  testWidgets('copy button flips to check for exactly 2000 ms', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        theme: buildDocsTheme('vercel', Brightness.light),
        home: Center(
          child: CopyButton(text: 'flutter_shadcn add button', showLabel: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(LucideIcons.copy), findsOneWidget);
    await tester.tap(find.text('Copy'));
    await tester.pump();
    expect(find.byIcon(LucideIcons.check), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1999));
    expect(find.byIcon(LucideIcons.check), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.byIcon(LucideIcons.copy), findsOneWidget);
  });
}
