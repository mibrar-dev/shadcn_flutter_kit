// Widget tests for the `sortable` component.
//
// Covers: edge detection and the accept callback, the ghost during drag, the
// source fallback, a drag handle, a failed drop and the candidate fallback.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/sortable/sortable.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a layer of two stacked 50px items ('A' above 'B').
Widget _frame({
  required List<String> accepted,
  Widget? ghost,
  Widget? fallback,
  Widget? candidateFallback,
  VoidCallback? onDropFailed,
  bool disableAnimations = false,
}) {
  Widget body = Directionality(
    textDirection: TextDirection.ltr,
    child: DefaultTextStyle(
      style: const TextStyle(fontSize: 14),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: SortableLayer(
            lock: true,
            child: SizedBox.expand(
              child: Column(
                children: <Widget>[
                  Sortable<String>(
                    data: const SortableData<String>('A'),
                    ghost: ghost,
                    fallback: fallback,
                    onDropFailed: onDropFailed,
                    onAcceptBottom: (SortableData<String> d) =>
                        accepted.add('A->${d.data}'),
                    child: const SizedBox(
                      width: 200,
                      height: 50,
                      child: Text('A'),
                    ),
                  ),
                  Sortable<String>(
                    data: const SortableData<String>('B'),
                    candidateFallback: candidateFallback,
                    onAcceptTop: (SortableData<String> d) =>
                        accepted.add('B->${d.data}'),
                    onAcceptBottom: (SortableData<String> d) =>
                        accepted.add('B->${d.data}'),
                    child: const SizedBox(
                      width: 200,
                      height: 50,
                      child: Text('B'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  if (disableAnimations) {
    body = MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: body,
    );
  }
  return body;
}

void main() {
  testWidgets('dropping on the bottom edge calls the accept callback', (
    tester,
  ) async {
    final List<String> accepted = <String>[];
    await tester.pumpWidget(_frame(accepted: accepted));

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('A')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(accepted, <String>['B->A']);
  });

  testWidgets('shows the ghost and the source fallback while dragging', (
    tester,
  ) async {
    final List<String> accepted = <String>[];
    await tester.pumpWidget(
      _frame(
        accepted: accepted,
        ghost: const Text('GHOST'),
        fallback: const Text('FALLBACK'),
      ),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('A')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();

    expect(find.text('GHOST'), findsOneWidget);
    expect(find.text('FALLBACK'), findsOneWidget);
    await gesture.up();
    await tester.pump();
    // The fallback clears immediately; the ghost settles over dropDuration.
    expect(find.text('FALLBACK'), findsNothing);
    expect(find.text('GHOST'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('GHOST'), findsNothing);
  });

  testWidgets('the ghost settles instead of snapping when animations run', (
    tester,
  ) async {
    final List<String> accepted = <String>[];
    await tester.pumpWidget(
      _frame(accepted: accepted, ghost: const Text('GHOST')),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('A')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    expect(find.text('GHOST'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('GHOST'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('GHOST'), findsNothing);
  });

  testWidgets('disableAnimations removes the ghost immediately', (
    tester,
  ) async {
    final List<String> accepted = <String>[];
    await tester.pumpWidget(
      _frame(
        accepted: accepted,
        ghost: const Text('GHOST'),
        disableAnimations: true,
      ),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('A')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    expect(find.text('GHOST'), findsNothing);
  });

  testWidgets('shows the candidate fallback on the hovered item', (
    tester,
  ) async {
    final List<String> accepted = <String>[];
    await tester.pumpWidget(
      _frame(accepted: accepted, candidateFallback: const Text('CANDIDATE')),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('A')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 60));
    await tester.pump();
    expect(find.text('CANDIDATE'), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(find.text('CANDIDATE'), findsNothing);
  });

  testWidgets('a drop with no target fails', (tester) async {
    final List<String> accepted = <String>[];
    bool failed = false;
    await tester.pumpWidget(
      _frame(accepted: accepted, onDropFailed: () => failed = true),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('A')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 400));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(accepted, isEmpty);
    expect(failed, isTrue);
  });

  testWidgets('a drag handle starts the drag', (tester) async {
    final List<String> accepted = <String>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: SortableLayer(
              lock: true,
              child: Column(
                children: <Widget>[
                  Sortable<String>(
                    data: const SortableData<String>('A'),
                    onAcceptBottom: (SortableData<String> d) =>
                        accepted.add('A->${d.data}'),
                    child: const Row(
                      children: <Widget>[
                        SortableDragHandle(child: Text('handle')),
                        Expanded(child: SizedBox(height: 50, child: Text('A'))),
                      ],
                    ),
                  ),
                  Sortable<String>(
                    data: const SortableData<String>('B'),
                    onAcceptTop: (SortableData<String> d) =>
                        accepted.add('B->${d.data}'),
                    child: const SizedBox(
                      width: 200,
                      height: 50,
                      child: Text('B'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('handle')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(0, 70));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(accepted, isNotEmpty);
  });
}
