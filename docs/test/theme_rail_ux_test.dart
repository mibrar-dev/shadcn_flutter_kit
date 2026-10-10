// P6-T2 Theme Studio rail UX tests: the alpha-only scroll fade, bounded
// scrolling dropdowns with the selected row in view, radius/spacing/shadow
// presets, live apply during interaction, and Escape keeping the value.

import 'dart:ui';

import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/menu/menu.dart';
import 'package:docs/ui/shadcn/components/slider/slider.dart';
import 'package:docs/ui/shadcn/primitives/fade_scroll.dart';
import 'package:docs/widgets/rail_picker_scales.dart';
import 'package:docs/widgets/theme_rail.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

Future<DocsRouterDelegate> _themes(
  WidgetTester tester, {
  Brightness platformBrightness = Brightness.dark,
}) async {
  final DocsRouterDelegate delegate = await pumpDocsApp(
    tester,
    platformBrightness: platformBrightness,
  );
  await goTo(tester, delegate, '/themes');
  return delegate;
}

Future<void> _openRow(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey<String>(key)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  expect(find.byType(MenuPopup), findsOneWidget);
}

Future<void> _closeWithEscape(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  expect(find.byType(MenuPopup), findsNothing);
}

Finder _inPopup(Finder finder) =>
    find.descendant(of: find.byType(MenuPopup), matching: finder);

/// Advances frames without settling: open popovers run a follow ticker, so
/// `pumpAndSettle` never completes while one is open (pre-existing).
Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump();
}

void main() {
  group('rail scroll fade', () {
    for (final Brightness mode in <Brightness>[
      Brightness.light,
      Brightness.dark,
    ]) {
      testWidgets('the fade is an alpha mask in $mode mode', (tester) async {
        await _themes(tester, platformBrightness: mode);
        final FadeScroll fade = tester.widget<FadeScroll>(
          find.descendant(
            of: find.byType(ThemeRail),
            matching: find.byType(FadeScroll),
          ),
        );
        expect(fade.controller.hasClients, isTrue);
        final ShaderMask mask = tester.widget<ShaderMask>(
          find.descendant(
            of: find.byType(ThemeRail),
            matching: find.byType(ShaderMask),
          ),
        );
        // dstIn reads only alpha: the fade dissolves into the real surface
        // instead of painting a black block over the first row in dark mode.
        expect(mask.blendMode, BlendMode.dstIn);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('rail dropdowns', () {
    testWidgets('the preset popup caps its height and reveals the current', (
      tester,
    ) async {
      await _themes(tester);
      await _openRow(tester, 'rail-row-preset');
      final Size size = tester.getSize(find.byType(MenuPopup));
      expect(size.height, lessThanOrEqualTo(362));
      expect(_inPopup(find.byType(SingleChildScrollView)), findsWidgets);
      // The current preset starts scrolled into view.
      await _pumpFrames(tester);
      final Rect popup = tester.getRect(find.byType(MenuPopup));
      final Rect current = tester.getRect(
        _inPopup(find.text(docsState.presetId)),
      );
      expect(current.top, greaterThanOrEqualTo(popup.top - 1));
      expect(current.bottom, lessThanOrEqualTo(popup.bottom + 1));
      expect(tester.takeException(), isNull);
      await _closeWithEscape(tester);
    });

    testWidgets('a bottom-row popup stays on screen', (tester) async {
      await _themes(tester);
      await _openRow(tester, 'rail-row-shadow');
      final Rect popup = tester.getRect(find.byType(MenuPopup));
      expect(popup.left, greaterThanOrEqualTo(0));
      expect(popup.top, greaterThanOrEqualTo(0));
      expect(popup.right, lessThanOrEqualTo(1400));
      expect(popup.bottom, lessThanOrEqualTo(900));
      expect(tester.takeException(), isNull);
      await _closeWithEscape(tester);
    });

    testWidgets('opening every row records no framework errors', (
      tester,
    ) async {
      await _themes(tester);
      final List<String> errors = <String>[];
      final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        errors.add(details.exception.toString());
        previous?.call(details);
      };
      addTearDown(() => FlutterError.onError = previous);
      for (final String key in <String>[
        'rail-row-preset',
        'rail-row-base',
        'rail-row-accent',
        'rail-row-chart',
        'rail-row-heading',
        'rail-row-body',
        'rail-row-radius',
        'rail-row-spacing',
        'rail-row-shadow',
        'rail-row-syntax',
      ]) {
        await tester.tap(find.byKey(ValueKey<String>(key)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        expect(find.byType(MenuPopup), findsOneWidget, reason: key);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        expect(find.byType(MenuPopup), findsNothing, reason: key);
      }
      expect(errors, isEmpty);
      while (tester.takeException() != null) {}
    });
  });

  group('radius presets', () {
    testWidgets('the six presets are offered and apply on tap', (tester) async {
      await _themes(tester);
      await _openRow(tester, 'rail-row-radius');
      for (final (String label, _) in kRadiusPresets) {
        expect(_inPopup(find.text(label)), findsOneWidget);
      }
      await tester.tap(_inPopup(find.text('Large')));
      await _pumpFrames(tester);
      expect(docsState.themeModel.radiusPx, 12);
      // The popup stays open for fine-tuning; Done only closes.
      expect(find.byType(MenuPopup), findsOneWidget);
      await tester.tap(_inPopup(find.text('Done')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(MenuPopup), findsNothing);
      expect(docsState.themeModel.radiusPx, 12);
    });
  });

  group('live apply', () {
    testWidgets('dragging the radius slider re-themes before Done', (
      tester,
    ) async {
      await _themes(tester);
      final double before = docsState.themeModel.radiusPx;
      await _openRow(tester, 'rail-row-radius');
      await tester.drag(_inPopup(find.byType(Slider)), const Offset(60, 0));
      await _pumpFrames(tester);
      // Applied while dragging: no Done press yet, popup still open.
      expect(find.byType(MenuPopup), findsOneWidget);
      expect((docsState.themeModel.radiusPx - before).abs(), greaterThan(0.5));
      await tester.tap(_inPopup(find.text('Done')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(MenuPopup), findsNothing);
    });

    testWidgets('Escape keeps the dragged value', (tester) async {
      await _themes(tester);
      await _openRow(tester, 'rail-row-radius');
      await tester.drag(_inPopup(find.byType(Slider)), const Offset(60, 0));
      await _pumpFrames(tester);
      final double dragged = docsState.themeModel.radiusPx;
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(MenuPopup), findsNothing);
      expect(docsState.themeModel.radiusPx, dragged);
    });

    testWidgets('hovering a preset re-themes without picking', (tester) async {
      await _themes(tester);
      // Widget tests start in touch highlight mode (no mouse connected),
      // which suppresses hover highlights; desktop browsers with a mouse
      // start in traditional mode, so force it here.
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      final String before = docsState.presetId;
      await _openRow(tester, 'rail-row-preset');
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      // The list opens scrolled to the current preset; reveal the first
      // option before hovering it.
      final Finder firstOption = _inPopup(find.text('Amber Minimal'));
      Scrollable.ensureVisible(tester.element(firstOption));
      await _pumpFrames(tester);
      await mouse.moveTo(tester.getCenter(firstOption));
      await _pumpFrames(tester);
      expect(docsState.presetId, 'amber-minimal');
      expect(docsState.presetId, isNot(before));
      await _closeWithEscape(tester);
      // Escape keeps the hovered value; Reset restores the default.
      expect(docsState.presetId, 'amber-minimal');
    });

    testWidgets('spacing and shadow presets apply on tap', (tester) async {
      await _themes(tester);
      await _openRow(tester, 'rail-row-spacing');
      await tester.tap(_inPopup(find.text('Comfortable')));
      await _pumpFrames(tester);
      expect(docsState.themeModel.document.spacing, 0.3);
      await tester.tap(_inPopup(find.text('Done')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      await _openRow(tester, 'rail-row-shadow');
      await tester.tap(_inPopup(find.text('None')));
      await _pumpFrames(tester);
      expect(
        docsState.themeModel.document.shadowOf(docsState.brightness).opacity,
        0,
      );
      await tester.tap(_inPopup(find.text('Done')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(MenuPopup), findsNothing);
    });
  });
}
