// QA for `eye_dropper` (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: joined history storages getting a double
// `addHistory` (the early-return path chained `.then(addHistory)` while the
// shared epilogue already covered the joined storage).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/eye_dropper/eye_dropper.dart';
import 'package:flutter_shadcn_kit/registry/components/eye_dropper/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/history/history.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

class _CountingStorage extends ChangeNotifier implements ColorHistoryStorage {
  final List<Color> _colors = <Color>[];
  int adds = 0;

  @override
  void addHistory(Color color) {
    adds++;
    _colors.insert(0, color);
    notifyListeners();
  }

  @override
  void setHistory(List<Color> colors) {
    _colors
      ..clear()
      ..addAll(colors);
    notifyListeners();
  }

  @override
  void clear() {
    _colors.clear();
    notifyListeners();
  }

  @override
  int get capacity => 10;

  @override
  List<Color> get recentColors => List<Color>.unmodifiable(_colors);
}

Widget _layer({required void Function(EyeDropperLayerScope scope) onScope}) {
  return EyeDropperLayer(
    child: Builder(
      builder: (BuildContext context) {
        onScope(EyeDropperLayerScope.find(context));
        return const SizedBox(
          width: 40,
          height: 40,
          child: ColoredBox(color: _green),
        );
      },
    ),
  );
}

Future<Future<Color?>> _startSession(
  WidgetTester tester,
  EyeDropperLayerScope scope, [
  ColorHistoryStorage? storage,
]) async {
  late Future<Color?> pick;
  await tester.runAsync(() async {
    pick = scope.promptPickColor(storage);
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });
  await tester.pump();
  return pick;
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in eyeDropperPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('two joined storages each get exactly one addHistory', (
    tester,
  ) async {
    final _CountingStorage first = _CountingStorage();
    final _CountingStorage second = _CountingStorage();
    late EyeDropperLayerScope scope;
    await tester.pumpWidget(_frame(_layer(onScope: (s) => scope = s)));
    final Future<Color?> pickA = await _startSession(tester, scope, first);
    late Future<Color?> pickB;
    await tester.runAsync(() async {
      pickB = scope.promptPickColor(second);
    });
    await tester.tapAt(tester.getCenter(find.byType(EyeDropperLayer)));
    await tester.pump();
    final Color? colorA = await tester.runAsync<Color?>(() => pickA);
    final Color? colorB = await tester.runAsync<Color?>(() => pickB);
    expect(colorA, _green);
    expect(colorB, _green);
    expect(first.adds, 1);
    expect(second.adds, 1);
    expect(first.recentColors, <Color>[_green]);
    expect(second.recentColors, <Color>[_green]);
  });

  testWidgets('a single storage still gets exactly one addHistory', (
    tester,
  ) async {
    final _CountingStorage storage = _CountingStorage();
    late EyeDropperLayerScope scope;
    await tester.pumpWidget(_frame(_layer(onScope: (s) => scope = s)));
    final Future<Color?> pick = await _startSession(tester, scope, storage);
    await tester.tapAt(tester.getCenter(find.byType(EyeDropperLayer)));
    await tester.pump();
    expect(await tester.runAsync<Color?>(() => pick), _green);
    expect(storage.adds, 1);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: eyeDropperPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    await tester.pumpWidget(
      _frame(
        Builder(builder: eyeDropperPreviews[0].builder),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
