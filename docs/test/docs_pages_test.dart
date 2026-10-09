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
    // Tapping a link opens its (placeholder) page.
    await tester.tap(
      find.descendant(
        of: find.byType(ComponentLinkGrid),
        matching: find.text('Accordion'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('accordion'), findsOneWidget);
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

  testWidgets('copy button flips to check for exactly 2000 ms', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        theme: buildDocsTheme('modern-minimal', Brightness.light),
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
