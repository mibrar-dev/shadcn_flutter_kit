// Widget tests for the `async` component.
//
// Covers the synchronous path, the pending/data/error paths of a `Future`,
// `initialData` and a `future` swap. There is no theme leg to test: the
// component paints nothing, which the "renders under light and dark tokens"
// group pins by asserting the built subtree is colour-independent.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/async/async.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
}

String _text(WidgetTester tester) =>
    tester.widget<Text>(find.byType(Text)).data ?? '';

void main() {
  testWidgets('a synchronous value renders once as done', (tester) async {
    final List<ConnectionState> states = <ConnectionState>[];
    await tester.pumpWidget(
      _frame(
        FutureOrBuilder<String>(
          future: 'ready',
          builder: (context, snapshot) {
            states.add(snapshot.connectionState);
            return Text(snapshot.data ?? '');
          },
        ),
      ),
    );
    expect(states, <ConnectionState>[ConnectionState.done]);
    expect(_text(tester), 'ready');
  });

  testWidgets('a synchronous value ignores initialData', (tester) async {
    await tester.pumpWidget(
      _frame(
        FutureOrBuilder<String>(
          future: 'ready',
          initialData: 'stale',
          builder: (context, snapshot) => Text(snapshot.data ?? ''),
        ),
      ),
    );
    expect(_text(tester), 'ready');
  });

  testWidgets('a future reports waiting before it resolves', (tester) async {
    final Completer<String> completer = Completer<String>();
    final List<ConnectionState> states = <ConnectionState>[];
    await tester.pumpWidget(
      _frame(
        FutureOrBuilder<String>(
          future: completer.future,
          builder: (context, snapshot) {
            states.add(snapshot.connectionState);
            return Text(snapshot.data ?? 'pending');
          },
        ),
      ),
    );
    expect(states.last, ConnectionState.waiting);
    expect(_text(tester), 'pending');

    completer.complete('done');
    await tester.pump();
    await tester.pump();
    expect(states.last, ConnectionState.done);
    expect(_text(tester), 'done');
  });

  testWidgets('initialData is reported while a future is pending', (
    tester,
  ) async {
    final Completer<String> completer = Completer<String>();
    await tester.pumpWidget(
      _frame(
        FutureOrBuilder<String>(
          future: completer.future,
          initialData: 'cached',
          builder: (context, snapshot) => Text(snapshot.data ?? 'pending'),
        ),
      ),
    );
    expect(_text(tester), 'cached');
  });

  testWidgets('a failing future reports hasError', (tester) async {
    await tester.pumpWidget(
      _frame(
        FutureOrBuilder<String>(
          future: Future<String>.delayed(
            const Duration(milliseconds: 10),
            () => throw StateError('boom'),
          ),
          builder: (context, snapshot) =>
              Text(snapshot.hasError ? 'error' : 'pending'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump();
    expect(_text(tester), 'error');
  });

  testWidgets('swapping the future restarts the builder', (tester) async {
    Widget build(String value) => _frame(
      FutureOrBuilder<String>(
        future: value,
        builder: (context, snapshot) => Text(snapshot.data ?? ''),
      ),
    );
    await tester.pumpWidget(build('a'));
    expect(_text(tester), 'a');
    await tester.pumpWidget(build('b'));
    expect(_text(tester), 'b');
  });

  group('renders with tokens', () {
    for (final (String name, ShadcnThemeData data)
        in <(String, ShadcnThemeData)>[
          ('light', const ShadcnThemeData()),
          ('dark', const ShadcnThemeData(colors: ShadcnColors.darkFallback)),
        ]) {
      testWidgets('$name tokens build the component', (tester) async {
        await tester.pumpWidget(
          _frame(
            FutureOrBuilder<String>(
              future: 'value',
              builder: (context, snapshot) => Text(snapshot.data ?? ''),
            ),
            data: data,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(_text(tester), 'value');
      });
    }
  });
}
