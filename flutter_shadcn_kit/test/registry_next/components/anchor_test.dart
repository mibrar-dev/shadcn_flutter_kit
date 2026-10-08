// Widget tests for the `anchor` component.
//
// Covers scope isolation (the same key in two sibling scopes), registration and
// unregistration on attach/detach, both subscription kinds and four regressions:
// the removed process-wide registry, the missing dispose contract, `isVisible`
// on a detached anchor and the singular `Matrix4`.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/anchor/anchor.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );
}

/// A row that registers [anchorKey] in its own scope and exposes its context.
class _AnchoredRow extends StatelessWidget {
  const _AnchoredRow({
    required this.label,
    required this.anchorKey,
    this.onContext,
  });

  final String label;
  final Object anchorKey;
  final void Function(BuildContext)? onContext;

  @override
  Widget build(BuildContext context) {
    return OverlayAnchorScope(
      child: Builder(
        builder: (BuildContext rowContext) {
          if (onContext != null) {
            onContext!(rowContext);
          }
          return OverlayAnchor(
            anchor: anchorKey,
            child: SizedBox(width: 120, height: 40, child: Text(label)),
          );
        },
      ),
    );
  }
}

void main() {
  group('registry', () {
    testWidgets('an anchor registers itself in its own scope', (tester) async {
      late BuildContext rowContext;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      final OverlayAnchorRegistry? registry = OverlayAnchorRegistry.maybeOf(
        rowContext,
      );
      expect(registry, isNotNull);
      expect(registry!.find('k'), isNotNull);
      expect(registry.find('k')!.renderBox, isA<RenderBox>());
    });

    testWidgets('regression: two sibling scopes reuse the same key', (
      tester,
    ) async {
      // The old process-wide registry made this impossible: one global entry.
      final List<BuildContext> contexts = <BuildContext>[];
      await tester.pumpWidget(
        _frame(
          Column(
            children: <Widget>[
              _AnchoredRow(
                label: 'a',
                anchorKey: 'same',
                onContext: (BuildContext c) => contexts.add(c),
              ),
              _AnchoredRow(
                label: 'b',
                anchorKey: 'same',
                onContext: (BuildContext c) => contexts.add(c),
              ),
            ],
          ),
        ),
      );
      final OverlayAnchorRegistry first = OverlayAnchorRegistry.maybeOf(
        contexts[0],
      )!;
      final OverlayAnchorRegistry second = OverlayAnchorRegistry.maybeOf(
        contexts[1],
      )!;
      expect(first, isNot(same(second)));
      expect(
        first.find('same')!.renderBox,
        isNot(second.find('same')!.renderBox),
      );
    });

    testWidgets('regression: there is no global registry any more', (
      tester,
    ) async {
      // `OverlayAnchorRegistry.global` was the old fallback; the type must not
      // expose a static registry entry point any more.
      late BuildContext outside;
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (BuildContext c) {
              outside = c;
              return const _AnchoredRow(label: 'row', anchorKey: 'k');
            },
          ),
        ),
      );
      // `global` used to answer here, so a `LinkedAnchor` bound to any scope
      // could reach an anchor in a different one.
      expect(OverlayAnchorRegistry.maybeOf(outside), isNull);
    });

    testWidgets('an anchor without a scope is a programming error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(const OverlayAnchor(anchor: 'k', child: Text('x'))),
      );
      expect(tester.takeException(), isA<AssertionError>());
    });

    testWidgets('detaching the anchor unregisters it', (tester) async {
      late BuildContext rowContext;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      final OverlayAnchorRegistry registry = OverlayAnchorRegistry.maybeOf(
        rowContext,
      )!;
      expect(registry.find('k'), isNotNull);
      await tester.pumpWidget(_frame(const Text('gone')));
      expect(registry.find('k'), isNull);
    });

    testWidgets('changing the key moves the registration', (tester) async {
      late BuildContext rowContext;
      Widget build(Object key) => _frame(
        _AnchoredRow(
          label: 'row',
          anchorKey: key,
          onContext: (BuildContext c) => rowContext = c,
        ),
      );
      await tester.pumpWidget(build('a'));
      final OverlayAnchorRegistry registry = OverlayAnchorRegistry.maybeOf(
        rowContext,
      )!;
      await tester.pumpWidget(build('b'));
      expect(registry.find('a'), isNull);
      expect(registry.find('b'), isNotNull);
    });
  });

  group('LinkedAnchor', () {
    testWidgets('resolves the anchor box through the scope', (tester) async {
      late BuildContext rowContext;
      late AnchorSubscription subscription;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      subscription = const LinkedAnchor('k').resolve(rowContext).subscribe();
      addTearDown(subscription.dispose);
      expect(subscription.isVisible, isTrue);
      expect(subscription.anchorSize, const Size(120, 40));
      expect(subscription.supportsCompositeTracking, isTrue);
      expect(subscription.currentAnchorBox, isNotNull);
    });

    testWidgets('regression: an unresolved LinkedAnchor asserts', (
      tester,
    ) async {
      expect(() => const LinkedAnchor('k').subscribe(), throwsAssertionError);
    });

    testWidgets('a subscription to a missing key is invisible', (tester) async {
      late BuildContext rowContext;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      final AnchorSubscription subscription = const LinkedAnchor(
        'other',
      ).resolve(rowContext).subscribe();
      addTearDown(subscription.dispose);
      expect(subscription.isVisible, isFalse);
      expect(subscription.anchorSize, isNull);
    });

    testWidgets('regression: isVisible is false once the anchor detaches', (
      tester,
    ) async {
      late BuildContext rowContext;
      late AnchorSubscription subscription;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      subscription = const LinkedAnchor('k').resolve(rowContext).subscribe();
      addTearDown(subscription.dispose);
      expect(subscription.isVisible, isTrue);
      await tester.pumpWidget(_frame(const Text('gone')));
      expect(subscription.isVisible, isFalse);
    });
  });

  group('ContextAnchor', () {
    testWidgets('tracks a context and stops when disposed', (tester) async {
      late BuildContext rowContext;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      const ContextAnchor anchor = ContextAnchor();
      // resolve() substitutes the consumer's context.
      final AnchorSubscription subscription = anchor
          .resolve(rowContext)
          .subscribe();
      expect(subscription.supportsCompositeTracking, isFalse);
      expect(subscription.isVisible, isTrue);
      expect(subscription.anchorSize, const Size(120, 40));

      int notifications = 0;
      subscription.addListener(() => notifications++);
      await tester.pump(const Duration(milliseconds: 32));
      expect(notifications, greaterThan(0));
      subscription.dispose();
      notifications = 0;
      await tester.pump(const Duration(milliseconds: 32));
      expect(notifications, 0);
    });

    testWidgets('an explicit context is kept by resolve', (tester) async {
      late BuildContext rowContext;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      final ContextAnchor explicit = ContextAnchor(rowContext);
      expect(identical(explicit.resolve(rowContext), explicit), isTrue);
      final AnchorSubscription subscription = explicit.subscribe();
      addTearDown(subscription.dispose);
      expect(subscription.isVisible, isTrue);
    });
  });

  group('transform', () {
    testWidgets('computeTransform maps anchor coordinates into the source', (
      tester,
    ) async {
      late BuildContext rowContext;
      late AnchorSubscription subscription;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      subscription = const LinkedAnchor('k').resolve(rowContext).subscribe();
      addTearDown(subscription.dispose);
      final RenderObject source = tester.renderObject<RenderBox>(
        find.text('row'),
      );
      final Matrix4 matrix = subscription.computeTransform(source);
      // The anchor and the source are the same box, so the map is the identity.
      expect(matrix.storage[0], closeTo(1, 1e-6));
      expect(matrix.storage[5], closeTo(1, 1e-6));
    });

    testWidgets('regression: a singular source yields the identity', (
      tester,
    ) async {
      late BuildContext rowContext;
      late AnchorSubscription subscription;
      await tester.pumpWidget(
        _frame(
          _AnchoredRow(
            label: 'row',
            anchorKey: 'k',
            onContext: (BuildContext c) => rowContext = c,
          ),
        ),
      );
      subscription = const LinkedAnchor('k').resolve(rowContext).subscribe();
      addTearDown(subscription.dispose);
      await tester.pumpWidget(
        _frame(const _ZeroScaleBox(child: Text('singular'))),
      );
      final RenderObject source = tester.renderObject(
        find.byType(_ZeroScaleBox),
      );
      final Matrix4 matrix = subscription.computeTransform(source);
      expect(tester.takeException(), isNull);
      expect(matrix.storage[0], 1);
      expect(matrix.storage[5], 1);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('builds under $name tokens', (tester) async {
        await tester.pumpWidget(
          _frame(
            const _AnchoredRow(label: 'row', anchorKey: 'k'),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('row'), findsOneWidget);
      });
    }
  });
}

/// Mounts a [_ZeroScaleSource] so it participates in the render tree.
class _ZeroScaleBox extends SingleChildRenderObjectWidget {
  const _ZeroScaleBox({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _ZeroScaleSource();

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderProxyBox renderObject,
  ) {}
}

/// A render object whose paint transform is singular, so it cannot be inverted.
class _ZeroScaleSource extends RenderProxyBox {
  _ZeroScaleSource()
    : super(
        RenderConstrainedBox(
          additionalConstraints: const BoxConstraints.tightFor(
            width: 10,
            height: 10,
          ),
        ),
      );

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    transform.multiply(Matrix4.diagonal3Values(0, 0, 0));
  }

  @override
  bool hitTestSelf(Offset position) => false;
}
