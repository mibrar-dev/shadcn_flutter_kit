// Widget tests for the `refresh_trigger` component.
//
// Covers the default pill per stage, the programmatic refresh lifecycle,
// custom indicators, pull gating on null `onRefresh` and the four
// theme-precedence legs. Regression tests cover the retired pieces: no
// Material progress/arrow widgets, no fake refresh cycle without a callback
// and no division by zero for a zero arming extent.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/refresh_trigger/refresh_trigger.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  RefreshTriggerTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<RefreshTriggerTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

RefreshTriggerStage _stageOf(TriggerStage stage, [double extent = 0.5]) {
  return RefreshTriggerStage(
    stage,
    AlwaysStoppedAnimation<double>(extent),
    Axis.vertical,
    false,
  );
}

Widget _scrollable({Future<void> Function()? onRefresh, Key? key}) {
  return RefreshTrigger(
    key: key,
    onRefresh: onRefresh,
    completeDuration: const Duration(milliseconds: 1),
    child: ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) =>
          SizedBox(height: 40, child: Text('row $index')),
    ),
  );
}

void main() {
  group('default indicator', () {
    testWidgets('shows the localized label per stage', (tester) async {
      final Map<TriggerStage, String> labels = <TriggerStage, String>{
        TriggerStage.idle: 'Pull to refresh',
        TriggerStage.pulling: 'Pull to refresh',
        TriggerStage.refreshing: 'Refreshing...',
        TriggerStage.completed: 'Refresh complete',
      };
      for (final MapEntry<TriggerStage, String> entry in labels.entries) {
        await tester.pumpWidget(
          _frame(child: DefaultRefreshIndicator(stage: _stageOf(entry.key))),
        );
        // Finish the stage switch transition; single pumps leave both
        // children mounted. (No settle: the refresh spinner repeats.)
        await tester.pump(const Duration(milliseconds: 200));
        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('release label past the arming extent', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: DefaultRefreshIndicator(
            stage: _stageOf(TriggerStage.pulling, 1.2),
          ),
        ),
      );
      expect(find.text('Release to refresh'), findsOneWidget);
    });

    testWidgets('indicator paints on a card surface', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: DefaultRefreshIndicator(stage: _stageOf(TriggerStage.idle)),
        ),
      );
      expect(find.byType(Card), findsOneWidget);
    });
  });

  group('refresh lifecycle', () {
    testWidgets('programmatic refresh runs the callback', (tester) async {
      bool called = false;
      final GlobalKey<RefreshTriggerState> key = GlobalKey<RefreshTriggerState>(
        debugLabel: 'trigger',
      );
      await tester.pumpWidget(
        _frame(
          child: RefreshTrigger(
            key: key,
            onRefresh: () async {
              called = true;
            },
            completeDuration: const Duration(milliseconds: 1),
            child: ListView(children: const <Widget>[Text('row')]),
          ),
        ),
      );
      expect(key.currentState!.stage, TriggerStage.idle);
      final Future<void> pending = key.currentState!.refresh();
      await tester.pump();
      await pending;
      expect(called, isTrue);
      expect(key.currentState!.stage, TriggerStage.completed);
      // Fire the completion timer, then let the extent animation finish.
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 300));
      expect(key.currentState!.stage, TriggerStage.idle);
    });

    testWidgets('concurrent refresh calls serialize', (tester) async {
      int active = 0;
      int peak = 0;
      final GlobalKey<RefreshTriggerState> key = GlobalKey<RefreshTriggerState>(
        debugLabel: 'trigger',
      );
      await tester.pumpWidget(
        _frame(
          child: RefreshTrigger(
            key: key,
            onRefresh: () async {
              active++;
              peak = active > peak ? active : peak;
              await Future<void>.delayed(const Duration(milliseconds: 5));
              active--;
            },
            completeDuration: const Duration(milliseconds: 1),
            child: ListView(children: const <Widget>[Text('row')]),
          ),
        ),
      );
      final Future<void> first = key.currentState!.refresh();
      final Future<void> second = key.currentState!.refresh();
      // Advance the fake clock past the 5ms refresh delays, then join.
      await tester.pump(const Duration(milliseconds: 10));
      await Future.wait(<Future<void>>[first, second]);
      expect(peak, 1);
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('null onRefresh disables programmatic refresh work', (
      tester,
    ) async {
      final GlobalKey<RefreshTriggerState> key = GlobalKey<RefreshTriggerState>(
        debugLabel: 'trigger',
      );
      await tester.pumpWidget(_frame(child: _scrollable(key: key)));
      await key.currentState!.refresh();
      expect(key.currentState!.stage, TriggerStage.completed);
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 300));
      expect(key.currentState!.stage, TriggerStage.idle);
    });
  });

  group('pull gating', () {
    testWidgets('pulling without onRefresh never leaves idle', (tester) async {
      await tester.pumpWidget(_frame(child: _scrollable()));
      final RefreshTriggerState state = tester.state<RefreshTriggerState>(
        find.byType(RefreshTrigger),
      );
      expect(state.stage, TriggerStage.idle);
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(state.stage, TriggerStage.idle);
    });
  });

  group('custom indicator', () {
    testWidgets('indicatorBuilder replaces the default pill', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: RefreshTrigger(
            onRefresh: () async {},
            indicatorBuilder: (context, stage) => const Text('custom pill'),
            child: ListView(children: const <Widget>[Text('row')]),
          ),
        ),
      );
      expect(find.text('custom pill'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      RefreshTriggerTheme resolve(
        BuildContext context,
        RefreshTriggerTheme? widget,
      ) {
        return resolveComponentStyle<RefreshTriggerTheme, RefreshTriggerTheme>(
          context,
          widget: widget,
          select: (t) => t,
          defaults: refreshTriggerDefaults,
        );
      }

      RefreshTriggerTheme? seen;
      Future<void> pump({
        RefreshTriggerTheme? widget,
        RefreshTriggerTheme? scoped,
        List<ComponentThemeData> app = const <ComponentThemeData>[],
      }) async {
        await tester.pumpWidget(
          _frame(
            app: app,
            scoped: scoped,
            child: Builder(
              builder: (context) {
                seen = resolve(context, widget);
                return const SizedBox();
              },
            ),
          ),
        );
      }

      await pump();
      expect(seen!.minExtent, refreshTriggerDefaults.minExtent);
      expect(seen!.minExtent, 75);
      await pump(
        app: const <ComponentThemeData>[RefreshTriggerTheme(minExtent: 60)],
      );
      expect(seen!.minExtent, 60);
      await pump(
        scoped: const RefreshTriggerTheme(minExtent: 50),
        app: const <ComponentThemeData>[RefreshTriggerTheme(minExtent: 60)],
      );
      expect(seen!.minExtent, 50);
      await pump(
        widget: const RefreshTriggerTheme(minExtent: 40),
        scoped: const RefreshTriggerTheme(minExtent: 50),
        app: const <ComponentThemeData>[RefreshTriggerTheme(minExtent: 60)],
      );
      expect(seen!.minExtent, 40);
    });

    testWidgets('zero arming extent does not divide by zero', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: RefreshTrigger(
            minExtent: 0,
            onRefresh: () async {},
            child: ListView(children: const <Widget>[Text('row')]),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('regressions', () {
    testWidgets('no Material progress widget in the indicator', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: DefaultRefreshIndicator(
            stage: _stageOf(TriggerStage.refreshing),
          ),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.runtimeType.toString() == 'CircularProgressIndicator',
        ),
        findsNothing,
      );
    });
  });
}
