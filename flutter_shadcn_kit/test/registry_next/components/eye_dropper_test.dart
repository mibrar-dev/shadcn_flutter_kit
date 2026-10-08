// Widget tests for the `eye_dropper` component.
//
// Covers session start/complete, hover previews, Escape cancelling (a new
// behaviour), history storage, the four theme-precedence legs, dark tokens and
// the old-bug regressions: the unclamped picked-colour index, the zero
// preview scale, the touch tap that never completed and the background colour
// missing from `shouldRepaint`.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/eye_dropper/eye_dropper.dart';
import 'package:flutter_shadcn_kit/registry_next/components/history/history.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

class _MemoryStorage extends ChangeNotifier implements ColorHistoryStorage {
  final List<Color> _colors = <Color>[];

  @override
  void addHistory(Color color) {
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

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  EyeDropperTheme? scopedTheme,
}) {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<EyeDropperTheme>(data: scopedTheme, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

/// Builds a 40x40 solid green layer and exposes its scope.
Widget _layer({
  required void Function(EyeDropperLayerScope scope) onScope,
  bool? showPreview,
  Size? previewSize,
  double? previewScale,
  EyeDropperTheme? theme,
}) {
  return EyeDropperLayer(
    showPreview: showPreview,
    previewSize: previewSize,
    previewScale: previewScale,
    theme: theme,
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

Future<Color?> _awaitPick(WidgetTester tester, Future<Color?> pick) async {
  return await tester.runAsync<Color?>(() => pick);
}

CustomPainter _previewPainter(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(
        find.descendant(
          of: find.byType(EyeDropperLayer),
          matching: find.byType(CustomPaint),
        ),
      )
      .last
      .painter!;
}

/// Packed ARGB of a paint colour (the engine round-trips `Paint.color`).
int _argb(Color? color) => color!.toARGB32();

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;

  group('picking', () {
    testWidgets('tap returns the sampled pixel and fills the history', (
      tester,
    ) async {
      final _MemoryStorage storage = _MemoryStorage();
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(_frame(child: _layer(onScope: (s) => scope = s)));
      final Future<Color?> pick = await _startSession(tester, scope, storage);
      // No hover first: a touch tap must complete the session (old bug).
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      expect(await _awaitPick(tester, pick), _green);
      expect(storage.recentColors, <Color>[_green]);
    });

    testWidgets('concurrent sessions share one capture and all complete', (
      tester,
    ) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(_frame(child: _layer(onScope: (s) => scope = s)));
      final Future<Color?> first = await _startSession(tester, scope);
      late Future<Color?> second;
      await tester.runAsync(() async {
        second = scope.promptPickColor();
      });
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      expect(await _awaitPick(tester, first), _green);
      expect(await _awaitPick(tester, second), _green);
    });

    testWidgets('a null preview before hover does not crash', (tester) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(_frame(child: _layer(onScope: (s) => scope = s)));
      final Future<Color?> pick = await _startSession(tester, scope);
      await tester.tapAt(const Offset(0.5, 0.5));
      await tester.pump();
      expect(await _awaitPick(tester, pick), _green);
    });
  });

  group('preview', () {
    testWidgets('hover shows the hex label and the magnified grid', (
      tester,
    ) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      expect(find.textContaining('#'), findsOneWidget);
      expect(_previewPainter(tester), isNotNull);
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    });

    testWidgets('preview colours come from the tokens', (tester) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      final _Recorder recorder = _Recorder();
      _previewPainter(tester).paint(recorder, const Size(40, 40));
      expect(_argb(recorder.firstRectColor), _argb(light.background));
      expect(_argb(recorder.ovalColor), _argb(light.border));
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    });

    testWidgets('showPreview false keeps the session silent', (tester) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(child: _layer(onScope: (s) => scope = s, showPreview: false)),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      expect(find.textContaining('#'), findsNothing);
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      expect(await _awaitPick(tester, pick), _green);
    });

    testWidgets('regression: previewScale 0 does not divide by zero', (
      tester,
    ) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(child: _layer(onScope: (s) => scope = s, previewScale: 0)),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('#'), findsOneWidget);
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    });
  });

  group('cancel', () {
    testWidgets('Escape completes the session with null', (tester) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(_frame(child: _layer(onScope: (s) => scope = s)));
      final Future<Color?> pick = await _startSession(tester, scope);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(await _awaitPick(tester, pick), isNull);
      expect(find.textContaining('#'), findsNothing);
    });

    testWidgets('a cancelled session can be restarted', (tester) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(_frame(child: _layer(onScope: (s) => scope = s)));
      final Future<Color?> first = await _startSession(tester, scope);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(await _awaitPick(tester, first), isNull);
      final Future<Color?> second = await _startSession(tester, scope);
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      expect(await _awaitPick(tester, second), _green);
    });
  });

  group('theme precedence', () {
    Future<void> hoverPreview(WidgetTester tester) async {
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
    }

    Future<void> finishPick(WidgetTester tester, Future<Color?> pick) async {
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    }

    Future<void> expectBorder(
      WidgetTester tester, {
      EyeDropperTheme? app,
      EyeDropperTheme? scoped,
      EyeDropperTheme? widget,
      required Color expected,
    }) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          app: app == null
              ? const <ComponentThemeData>[]
              : <ComponentThemeData>[app],
          scopedTheme: scoped,
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
            theme: widget,
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      await hoverPreview(tester);
      final _Recorder recorder = _Recorder();
      _previewPainter(tester).paint(recorder, const Size(40, 40));
      expect(_argb(recorder.ovalColor), _argb(expected));
      await finishPick(tester, pick);
    }

    testWidgets('defaults use the border token', (tester) async {
      await expectBorder(tester, expected: light.border);
    });

    testWidgets('app leg overrides the defaults', (tester) async {
      await expectBorder(
        tester,
        app: const EyeDropperTheme(borderColor: ThemedColor.value(_green)),
        expected: _green,
      );
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await expectBorder(
        tester,
        app: const EyeDropperTheme(borderColor: ThemedColor.value(_green)),
        scoped: const EyeDropperTheme(borderColor: ThemedColor.value(_blue)),
        expected: _blue,
      );
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await expectBorder(
        tester,
        scoped: const EyeDropperTheme(borderColor: ThemedColor.value(_green)),
        widget: const EyeDropperTheme(borderColor: ThemedColor.value(_blue)),
        expected: _blue,
      );
    });

    testWidgets('a leg setting only the scale keeps the token colour', (
      tester,
    ) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          scopedTheme: const EyeDropperTheme(previewScale: 4),
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      await hoverPreview(tester);
      final _Recorder recorder = _Recorder();
      _previewPainter(tester).paint(recorder, const Size(40, 40));
      expect(_argb(recorder.ovalColor), _argb(light.border));
      await finishPick(tester, pick);
    });
  });

  group('tokens and regressions', () {
    testWidgets('dark palette drives the preview', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      final _Recorder recorder = _Recorder();
      _previewPainter(tester).paint(recorder, const Size(40, 40));
      expect(_argb(recorder.firstRectColor), _argb(dark.background));
      expect(_argb(recorder.ovalColor), _argb(dark.border));
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
            theme: const EyeDropperTheme(
              borderColor: ThemedColor.ref(ColorRef.border, alpha: 0.5),
            ),
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      final _Recorder recorder = _Recorder();
      _previewPainter(tester).paint(recorder, const Size(40, 40));
      expect(
        recorder.ovalColor!.a,
        closeTo(ShadcnColors.darkFallback.border.a * 0.5, 0.01),
      );
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    });

    testWidgets('regression: shouldRepaint sees a background-only change', (
      tester,
    ) async {
      late EyeDropperLayerScope scope;
      await tester.pumpWidget(
        _frame(
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
          ),
        ),
      );
      final Future<Color?> pick = await _startSession(tester, scope);
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump();
      final CustomPainter before = _previewPainter(tester);
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: _layer(
            onScope: (s) => scope = s,
            previewSize: const Size(40, 40),
          ),
        ),
      );
      await tester.pump();
      final CustomPainter after = _previewPainter(tester);
      expect(after.shouldRepaint(before), isTrue);
      await tester.tapAt(const Offset(20, 20));
      await tester.pump();
      await _awaitPick(tester, pick);
    });

    test('regression: ScreenSample clamps out-of-range lookups', () {
      const ScreenSample sample = ScreenSample(
        <Color>[_green, _blue, _blue, _green],
        Size(2, 2),
        _green,
      );
      expect(sample[const Offset(-4, -4)], _green);
      expect(sample[const Offset(99, 99)], _green);
      expect(sample[const Offset(1.5, 0.5)], _blue);
    });

    test('defaults table matches the old preview defaults', () {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      expect(eyeDropperDefaults.previewSize, const Size(100, 100));
      expect(eyeDropperDefaults.previewScale, 8);
      expect(eyeDropperDefaults.showPreview, isTrue);
      expect(eyeDropperDefaults.borderColor?.resolve(colors), colors.border);
      expect(
        eyeDropperDefaults.backgroundColor?.resolve(colors),
        colors.background,
      );
    });
  });
}

/// Canvas that records the first rect fill and the first oval stroke colour.
class _Recorder implements Canvas {
  Color? firstRectColor;
  Color? ovalColor;

  @override
  void noSuchMethod(Invocation invocation) {
    if (invocation.memberName == const Symbol('drawRect')) {
      final Paint paint = invocation.positionalArguments[1] as Paint;
      if (firstRectColor == null && paint.style == PaintingStyle.fill) {
        firstRectColor = paint.color;
      }
    } else if (invocation.memberName == const Symbol('drawOval')) {
      final Paint paint = invocation.positionalArguments[1] as Paint;
      ovalColor ??= paint.color;
    }
  }
}
