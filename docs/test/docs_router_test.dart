import 'package:docs/routing/docs_router.dart';
import 'package:docs/state/docs_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocsRouteConfiguration.parse', () {
    test('maps the sitemap', () {
      expect(DocsRouteConfiguration.parse('/'), DocsRouteConfiguration.landing);
      expect(DocsRouteConfiguration.parse(''), DocsRouteConfiguration.landing);
      expect(
        DocsRouteConfiguration.parse('/docs'),
        DocsRouteConfiguration.introduction,
      );
      expect(
        DocsRouteConfiguration.parse('/docs/installation'),
        DocsRouteConfiguration.installation,
      );
      expect(
        DocsRouteConfiguration.parse('/docs/cli'),
        DocsRouteConfiguration.cli,
      );
      expect(
        DocsRouteConfiguration.parse('/docs/components'),
        DocsRouteConfiguration.components,
      );
      expect(
        DocsRouteConfiguration.parse('/docs/components/button'),
        DocsRouteConfiguration.component('button'),
      );
      expect(
        DocsRouteConfiguration.parse('/themes'),
        DocsRouteConfiguration.themes,
      );
    });

    test('ignores trailing slashes, query and fragment', () {
      expect(
        DocsRouteConfiguration.parse('/docs/?tab=x'),
        DocsRouteConfiguration.introduction,
      );
      expect(
        DocsRouteConfiguration.parse('/docs/components/button#api'),
        DocsRouteConfiguration.component('button'),
      );
    });

    test('keeps unknown locations for the not-found page', () {
      final DocsRouteConfiguration config = DocsRouteConfiguration.parse(
        '/nope/deep',
      );
      expect(config.route, DocsRoute.notFound);
      expect(config.location, '/nope/deep');
    });

    test('locations round-trip', () {
      expect(DocsRouteConfiguration.landing.location, '/');
      expect(DocsRouteConfiguration.introduction.location, '/docs');
      expect(DocsRouteConfiguration.components.location, '/docs/components');
      expect(
        DocsRouteConfiguration.component('dialog').location,
        '/docs/components/dialog',
      );
      expect(DocsRouteConfiguration.themes.location, '/themes');
    });
  });

  group('DocsRouteInformationParser', () {
    test('parses and restores route information', () async {
      const DocsRouteInformationParser parser = DocsRouteInformationParser();
      final DocsRouteConfiguration config = await parser.parseRouteInformation(
        RouteInformation(uri: Uri.parse('/docs/components/dialog')),
      );
      expect(config, DocsRouteConfiguration.component('dialog'));
      final RouteInformation? restored = parser.restoreRouteInformation(config);
      expect(restored?.uri.path, '/docs/components/dialog');
    });
  });

  group('DocsRouterDelegate', () {
    testWidgets('deep links replace the stack', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await _pumpRouter(tester);
      addTearDown(delegate.dispose);

      expect(find.text('shadcn_flutter_kit'), findsOneWidget);
      await delegate.setNewRoutePath(
        DocsRouteConfiguration.component('button'),
      );
      await tester.pumpAndSettle();

      expect(find.text('button'), findsOneWidget);
      expect(find.text('shadcn_flutter_kit'), findsNothing);
      expect(
        delegate.currentConfiguration,
        DocsRouteConfiguration.component('button'),
      );
    });

    testWidgets('navigate pushes a page and popRoute unwinds it', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await _pumpRouter(tester);
      addTearDown(delegate.dispose);

      delegate.navigate(
        tester.element(find.byType(Navigator)),
        DocsRouteConfiguration.components,
      );
      await tester.pumpAndSettle();
      expect(find.text('Components'), findsOneWidget);
      expect(delegate.currentConfiguration, DocsRouteConfiguration.components);

      await delegate.popRoute();
      await tester.pumpAndSettle();
      expect(find.text('shadcn_flutter_kit'), findsOneWidget);
      expect(delegate.currentConfiguration, DocsRouteConfiguration.landing);
    });

    testWidgets('palette opens, toggles closed and restores focus', (
      WidgetTester tester,
    ) async {
      final FocusNode trigger = FocusNode(debugLabel: 'trigger');
      addTearDown(trigger.dispose);
      final DocsRouterDelegate delegate = await _pumpRouter(
        tester,
        trigger: trigger,
      );
      addTearDown(delegate.dispose);

      trigger.requestFocus();
      await tester.pumpAndSettle();
      expect(trigger.hasPrimaryFocus, isTrue, reason: 'trigger holds focus');

      delegate.openPalette();
      await tester.pumpAndSettle();
      expect(find.text('palette'), findsOneWidget);
      expect(trigger.hasPrimaryFocus, isFalse, reason: 'palette took focus');

      delegate.openPalette(); // ⌘K toggles.
      await tester.pumpAndSettle();
      expect(find.text('palette'), findsNothing);
      expect(
        trigger.hasPrimaryFocus,
        isTrue,
        reason: 'focus restored on close',
      );
    });
  });
}

Future<DocsRouterDelegate> _pumpRouter(
  WidgetTester tester, {
  FocusNode? trigger,
}) async {
  final DocsRouterDelegate delegate = DocsRouterDelegate(
    state: DocsState(storage: const DocsStorage()),
    pageBuilder: (BuildContext context, DocsRouteConfiguration config) =>
        Text(config.title, textDirection: TextDirection.ltr),
    paletteBuilder: (BuildContext context, VoidCallback close) => Focus(
      autofocus: true,
      child: const Text('palette', textDirection: TextDirection.ltr),
    ),
    shellBuilder: (BuildContext context, Widget navigator) => Directionality(
      textDirection: TextDirection.ltr,
      child: Focus(
        focusNode: trigger,
        autofocus: trigger != null,
        child: navigator,
      ),
    ),
  );
  await tester.pumpWidget(
    Router<DocsRouteConfiguration>(
      routerDelegate: delegate,
      routeInformationParser: const DocsRouteInformationParser(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    ),
  );
  await tester.pumpAndSettle();
  return delegate;
}
