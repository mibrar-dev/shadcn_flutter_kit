import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/captured_wrapper.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data_messenger.dart';
import 'package:flutter_test/flutter_test.dart';

class _SilentData with DistinctData {
  const _SilentData(this.tag);

  final int tag;

  @override
  bool shouldNotify(covariant DistinctData oldData) => false;
}

void main() {
  group('Data inherit / of / maybeOf', () {
    testWidgets('reads the nearest value and null when absent', (tester) async {
      int? ofValue;
      int? innerValue;
      String? missing;
      await tester.pumpWidget(
        Data<int>.inherit(
          data: 1,
          child: Data<int>.inherit(
            data: 2,
            child: Builder(
              builder: (context) {
                ofValue = Data.of<int>(context);
                innerValue = Data.maybeOf<int>(context);
                missing = Data.maybeOf<String>(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(ofValue, 2);
      expect(innerValue, 2);
      expect(missing, isNull);
    });

    testWidgets('maybeOf rebuilds when the value changes', (tester) async {
      var builds = 0;
      final child = Builder(
        builder: (context) {
          builds++;
          Data.maybeOf<int>(context);
          return const SizedBox();
        },
      );
      await tester.pumpWidget(Data<int>.inherit(data: 1, child: child));
      expect(builds, 1);
      await tester.pumpWidget(Data<int>.inherit(data: 2, child: child));
      expect(builds, 2);
      await tester.pumpWidget(Data<int>.inherit(data: 2, child: child));
      expect(builds, 2);
    });

    testWidgets('DistinctData can suppress rebuilds', (tester) async {
      var builds = 0;
      final child = Builder(
        builder: (context) {
          builds++;
          Data.maybeOf<_SilentData>(context);
          return const SizedBox();
        },
      );
      await tester.pumpWidget(
        Data<_SilentData>.inherit(data: const _SilentData(1), child: child),
      );
      expect(builds, 1);
      await tester.pumpWidget(
        Data<_SilentData>.inherit(data: const _SilentData(2), child: child),
      );
      expect(builds, 1);
    });
  });

  group('Data find / maybeFind', () {
    testWidgets('finds the nearest data without listening', (tester) async {
      int? found;
      String? absent;
      await tester.pumpWidget(
        Data<int>.inherit(
          data: 1,
          child: Data<int>.inherit(
            data: 2,
            child: Builder(
              builder: (context) {
                found = Data.find<int>(context);
                absent = Data.maybeFind<String>(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(found, 2);
      expect(absent, isNull);
    });

    testWidgets('maybeFindRoot returns the outermost value', (tester) async {
      int? root;
      await tester.pumpWidget(
        Data<int>.inherit(
          data: 1,
          child: Data<int>.inherit(
            data: 2,
            child: Builder(
              builder: (context) {
                root = Data.maybeFindRoot<int>(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(root, 1);
    });
  });

  group('Data capture', () {
    testWidgets('re-injects captured data into another subtree', (
      tester,
    ) async {
      late BuildContext sourceContext;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Data<String>.inherit(
            data: 'captured',
            child: Builder(
              builder: (context) {
                sourceContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final captured = Data.capture(from: sourceContext, to: null);
      String? injected;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CapturedWrapper(
            data: captured,
            child: Builder(
              builder: (context) {
                injected = Data.maybeOf<String>(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(injected, 'captured');
    });

    testWidgets('capture stops at the given ancestor', (tester) async {
      late BuildContext sourceContext;
      late BuildContext stopContext;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Data<String>.inherit(
            data: 'outer',
            child: Builder(
              builder: (outerContext) {
                stopContext = outerContext;
                return Data<int>.inherit(
                  data: 7,
                  child: Builder(
                    builder: (context) {
                      sourceContext = context;
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      final captured = Data.capture(from: sourceContext, to: stopContext);
      String? outer;
      int? inner;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CapturedWrapper(
            data: captured,
            child: Builder(
              builder: (context) {
                outer = Data.maybeOf<String>(context);
                inner = Data.maybeOf<int>(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(inner, 7);
      expect(outer, isNull);
    });
  });

  group('Data messenger', () {
    testWidgets('maybeFindMessenger looks up forwarded data', (tester) async {
      late BuildContext queryContext;
      await tester.pumpWidget(
        DataMessenger<String>(
          child: Builder(
            builder: (context) {
              queryContext = context;
              return ForwardableData<String>(
                data: 'forwarded',
                child: const SizedBox(),
              );
            },
          ),
        ),
      );
      expect(Data.maybeFindMessenger<String>(queryContext), 'forwarded');
      expect(Data.maybeFindMessenger<int>(queryContext), isNull);
    });

    testWidgets('root messenger serves every data type', (tester) async {
      late BuildContext queryContext;
      Widget tree({required bool withData}) {
        return DataMessengerRoot(
          child: Builder(
            builder: (context) {
              queryContext = context;
              if (!withData) {
                return const SizedBox();
              }
              return ForwardableData<int>(data: 42, child: const SizedBox());
            },
          ),
        );
      }

      await tester.pumpWidget(tree(withData: true));
      expect(Data.maybeFindMessenger<int>(queryContext), 42);
      await tester.pumpWidget(tree(withData: false));
      expect(Data.maybeFindMessenger<int>(queryContext), isNull);
    });
  });
}
