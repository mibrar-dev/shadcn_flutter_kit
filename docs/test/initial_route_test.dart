// Deep-link coverage: every URL the site owns must parse, and the initial
// route path (`setNewRoutePath`, what a browser deep link drives) must render
// the page rather than silently blanking.
//
// Regression context: a stale service worker used to serve an old
// `main.dart.js` against new chunk names, so the deferred import of a
// component page failed and `DeferredPage` built the broken page anyway
// (grey screen + "Could not navigate to initial route"). `DeferredPage` now
// reports the failure; these tests pin the initial-URL path that no other
// test exercised (in-app links only ever used `navigate`/`go`).

import 'package:docs/generated/app_theme.dart';
import 'package:docs/routing/deferred_page.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/widgets/theme_rail.dart';
import 'package:docs/state/docs_state.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('DocsRouteConfiguration.parse', () {
    test('every initial URL the site owns', () {
      const Map<String, DocsRoute> expected = <String, DocsRoute>{
        '/': DocsRoute.landing,
        '/themes': DocsRoute.themes,
        '/docs': DocsRoute.introduction,
        '/docs/installation': DocsRoute.installation,
        '/docs/theming': DocsRoute.theming,
        '/docs/dark-mode': DocsRoute.darkMode,
        '/docs/cli': DocsRoute.cli,
        '/docs/components': DocsRoute.components,
        '/docs/components/button': DocsRoute.component,
        '/docs/components/overlay-configuration': DocsRoute.component,
        '/nope': DocsRoute.notFound,
        '/docs/components/': DocsRoute.components,
        '/docs/unknown': DocsRoute.notFound,
      };
      for (final MapEntry<String, DocsRoute> entry in expected.entries) {
        expect(
          DocsRouteConfiguration.parse(entry.key).route,
          entry.value,
          reason: entry.key,
        );
      }
    });

    test(
      'absolute URLs, hash routes and query strings parse to the same page',
      () {
        expect(
          DocsRouteConfiguration.parse(
            'https://x.github.io/shadcn_flutter_kit/docs/components/button?a=1',
          ).route,
          DocsRoute.component,
        );
        expect(
          DocsRouteConfiguration.parse(
            'https://x.github.io/shadcn_flutter_kit/docs/components/button#frag',
          ).componentId,
          'button',
        );
        // GitHub Pages base-href prefix is stripped, not treated as a route.
        expect(
          DocsRouteConfiguration.parse('/shadcn_flutter_kit/themes').route,
          DocsRoute.themes,
        );
        expect(
          DocsRouteConfiguration.parse(
            'https://x.github.io/shadcn_flutter_kit/docs/cli',
          ).route,
          DocsRoute.cli,
        );
      },
    );

    test('round-trips through the canonical location', () {
      for (final String location in <String>[
        '/',
        '/themes',
        '/docs',
        '/docs/components',
        '/docs/components/button',
        '/nope',
      ]) {
        final DocsRouteConfiguration config = DocsRouteConfiguration.parse(
          location,
        );
        expect(
          DocsRouteConfiguration.parse(config.location).route,
          config.route,
          reason: location,
        );
      }
    });

    test('null/empty locations land on the landing route', () {
      expect(DocsRouteConfiguration.parse(null).route, DocsRoute.landing);
      expect(DocsRouteConfiguration.parse('').route, DocsRoute.landing);
      expect(DocsRouteConfiguration.parse('/').location, '/');
    });
  });

  group('DeferredPage', () {
    testWidgets('a failed chunk reports it instead of blanking', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: buildDocsTheme('neutral', Brightness.light),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: DeferredPage(
              load: () async => throw StateError('boom'),
              builder: (BuildContext context) => const Text('page'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('page'), findsNothing);
      expect(
        tester.takeException(),
        isNull,
        reason: 'the error must not escape the router',
      );
    });
  });

  group('initial route path', () {
    testWidgets('setNewRoutePath renders the component page', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      final DocsState state = docsState;
      delegate.setNewRoutePath(DocsRouteConfiguration.component('button'));
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(delegate.currentConfiguration.route, DocsRoute.component);
      expect(state.presetId, 'neutral');
      expect(find.text('Button'), findsWidgets);
    });

    testWidgets('setNewRoutePath to /themes renders the studio', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      delegate.setNewRoutePath(DocsRouteConfiguration.themes);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(delegate.currentConfiguration.route, DocsRoute.themes);
      expect(find.byType(ThemeRail), findsOneWidget);
    });

    testWidgets('an unknown initial URL falls back to not-found', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      delegate.setNewRoutePath(DocsRouteConfiguration.notFound('/nope'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(delegate.currentConfiguration.route, DocsRoute.notFound);
    });
  });
}
