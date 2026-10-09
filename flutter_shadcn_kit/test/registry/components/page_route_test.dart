// Widget tests for the `page_route` component.
//
// Covers push/pop, the transition widget at t = 0 / t = 1, the declarative
// `ShadcnPage`, the renamed duration constant and two regressions: the old
// `canTransitionTo` suppressed the exit transition when a non-page route was
// pushed on top, and `debugLabel` printed `PageRoute(null)`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/page_route/page_route.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
}

Widget _navigator({required Widget home}) {
  return _host(
    Navigator(
      onGenerateRoute: (settings) =>
          ShadcnPageRoute<void>(settings: settings, builder: (context) => home),
    ),
  );
}

Widget _recordingNavigator(List<ShadcnPageRoute<void>> routes) {
  return _host(
    Navigator(
      onGenerateRoute: (settings) {
        final ShadcnPageRoute<void> route = ShadcnPageRoute<void>(
          settings: settings,
          builder: (context) => const Text('home'),
        );
        routes.add(route);
        return route;
      },
    ),
  );
}

void main() {
  group('ShadcnPageRoute', () {
    testWidgets('push and pop a page', (tester) async {
      final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        _host(
          Navigator(
            key: navigator,
            onGenerateRoute: (settings) => ShadcnPageRoute<void>(
              settings: settings,
              builder: (context) => const Text('page one'),
            ),
          ),
        ),
      );
      expect(find.text('page one'), findsOneWidget);

      navigator.currentState!.push(
        ShadcnPageRoute<void>(builder: (context) => const Text('page two')),
      );
      await tester.pump();
      await tester.pump(kShadcnPageTransitionDuration);
      expect(find.text('page two'), findsOneWidget);

      navigator.currentState!.pop();
      await tester.pump();
      await tester.pump(kShadcnPageTransitionDuration);
      expect(find.text('page one'), findsOneWidget);
    });

    testWidgets('default transition duration is 300ms', (tester) async {
      final List<ShadcnPageRoute<void>> routes = <ShadcnPageRoute<void>>[];
      await tester.pumpWidget(_recordingNavigator(routes));
      expect(routes.single.transitionDuration, kShadcnPageTransitionDuration);
      expect(kShadcnPageTransitionDuration, const Duration(milliseconds: 300));
    });

    testWidgets('opaque and maintainState default to true', (tester) async {
      final List<ShadcnPageRoute<void>> routes = <ShadcnPageRoute<void>>[];
      await tester.pumpWidget(_recordingNavigator(routes));
      final ShadcnPageRoute<void> route = routes.single;
      expect(route.opaque, isTrue);
      expect(route.maintainState, isTrue);
      expect(route.barrierColor, isNull);
    });

    testWidgets('regression: an unnamed route does not print (null)', (
      tester,
    ) async {
      final List<ShadcnPageRoute<void>> routes = <ShadcnPageRoute<void>>[];
      await tester.pumpWidget(_recordingNavigator(routes));
      expect(routes.single.debugLabel, isNot(contains('null')));
    });

    testWidgets('regression: a named route reports its name', (tester) async {
      final ShadcnPageRoute<void> named = ShadcnPageRoute<void>(
        settings: const RouteSettings(name: 'detail'),
        builder: (context) => const Text('x'),
      );
      expect(named.debugLabel, contains('detail'));
    });

    testWidgets('regression: any next route may transition in', (tester) async {
      // The old `canTransitionTo` answered `nextRoute is ShadcnPageRoute`, so
      // pushing a dialog/drawer over a page skipped the page's exit transition.
      final ShadcnPageRoute<void> page = ShadcnPageRoute<void>(
        builder: (context) => const Text('page'),
      );
      final ShadcnPageRoute<void> other = ShadcnPageRoute<void>(
        builder: (context) => const Text('other'),
      );
      expect(page.canTransitionTo(other), isTrue);
    });
  });

  group('ShadcnPageTransition', () {
    testWidgets('at t = 1 the page sits at its final position', (tester) async {
      await tester.pumpWidget(
        _host(
          const ShadcnPageTransition(
            animation: AlwaysStoppedAnimation<double>(1),
            child: Text('page'),
          ),
        ),
      );
      expect(find.byType(FadeTransition), findsOneWidget);
      final SlideTransition slide = tester.widget<SlideTransition>(
        find.byType(SlideTransition),
      );
      expect(slide.position.value, Offset.zero);
    });

    testWidgets('at t = 0 the slide starts 2% low', (tester) async {
      await tester.pumpWidget(
        _host(
          const ShadcnPageTransition(
            animation: AlwaysStoppedAnimation<double>(0),
            child: Text('page'),
          ),
        ),
      );
      final SlideTransition slide = tester.widget<SlideTransition>(
        find.byType(SlideTransition),
      );
      expect(slide.position.value, const Offset(0, 0.02));
    });
  });

  group('ShadcnPage', () {
    testWidgets('creates a ShadcnPageRoute carrying its own duration', (
      tester,
    ) async {
      const ShadcnPage<String> page = ShadcnPage<String>(
        key: ValueKey<String>('k'),
        child: Text('body'),
        transitionDuration: Duration(milliseconds: 42),
      );
      late Route<String> route;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) {
              route = page.createRoute(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(route, isA<ShadcnPageRoute<String>>());
      expect(
        (route as ShadcnPageRoute<String>).transitionDuration,
        const Duration(milliseconds: 42),
      );
    });

    testWidgets('renders declarative pages through the Navigator', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Navigator(
            pages: const <Page<void>>[
              ShadcnPage<void>(child: Text('first')),
              ShadcnPage<void>(
                key: ValueKey<String>('b'),
                child: Text('second'),
              ),
            ],
            onDidRemovePage: (Page<void> page) {},
          ),
        ),
      );
      await tester.pump();
      await tester.pump(kShadcnPageTransitionDuration);
      expect(find.text('second'), findsOneWidget);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('builds under $name tokens', (tester) async {
        await tester.pumpWidget(
          ShadcnTheme(
            data: ShadcnThemeData(colors: colors),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: _navigator(home: const Text('home')),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('home'), findsOneWidget);
      });
    }
  });
}
