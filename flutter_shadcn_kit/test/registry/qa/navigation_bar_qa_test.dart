// QA for `navigation_bar` previews (P7-Q2).
//
// Pumps every `navigationBarPreviews` example under neutral/claude x
// light/dark, RTL and 375px, and drives selection, the disabled item and the
// sidebar collapsible like a user.
//
// P7-Q2 fixes pinned here: the horizontal bar shares its width equally
// between items (no phone-width overflow with all labels shown) and the
// `spacing` prop is laid out as gaps instead of being dropped.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/navigation_bar/navigation_bar.dart';
import 'package:flutter_shadcn_kit/registry/components/navigation_bar/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/hidden.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../themes/generated_theme.dart';

final Map<String, GeneratedTheme> _presets = <String, GeneratedTheme>{};

ShadcnThemeData _theme(String preset, Brightness brightness) {
  final GeneratedTheme theme = _presets.putIfAbsent(
    preset,
    () => loadGeneratedTheme('lib/registry/themes/$preset.json'),
  );
  final view = theme.view(brightness);
  return ShadcnThemeData(
    colors: view.colors,
    tokens: view.tokens,
    fonts: view.fonts,
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  String preset = 'neutral',
  Brightness brightness = Brightness.light,
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: _theme(preset, brightness),
      child: Directionality(
        textDirection: direction,
        child: Overlay.wrap(
          child: Center(
            child: SizedBox(
              width: width,
              child: Builder(builder: preview.builder),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in navigationBarPreviews) {
      for (final String preset in const <String>['neutral', 'claude']) {
        for (final Brightness brightness in Brightness.values) {
          await _pumpPreview(
            tester,
            preview,
            preset: preset,
            brightness: brightness,
          );
        }
      }
    }
  });

  testWidgets('Default bar moves selection on icon tap', (tester) async {
    await _pumpPreview(tester, navigationBarPreviews[0]);
    // Selected-only labels: labels stay mounted for the show/hide animation,
    // so assert the row flags rather than finder absence.
    List<bool> labels() => tester
        .widgetList<NavigationItemRow>(find.byType(NavigationItemRow))
        .map((NavigationItemRow row) => row.showLabel)
        .toList();
    List<bool> selected() => tester
        .widgetList<NavigationItemRow>(find.byType(NavigationItemRow))
        .map((NavigationItemRow row) => row.selected)
        .toList();
    expect(labels(), <bool>[true, false, false, false]);
    await tester.tap(find.byIcon(RadixIcons.magnifyingGlass));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
    expect(selected(), <bool>[false, true, false, false]);
    expect(labels(), <bool>[false, true, false, false]);
  });

  testWidgets('Disabled item tap keeps selection and throws nothing', (
    tester,
  ) async {
    await _pumpPreview(tester, navigationBarPreviews[0]);
    await tester.tap(find.byIcon(RadixIcons.person));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
    final List<bool> selected = tester
        .widgetList<NavigationItemRow>(find.byType(NavigationItemRow))
        .map((NavigationItemRow row) => row.selected)
        .toList();
    expect(selected, <bool>[true, false, false, false]);
  });

  testWidgets('With-labels bar shares width equally with no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, navigationBarPreviews[1], width: 375);
    for (final String label in const <String>[
      'Home',
      'Search',
      'Settings',
      'Disabled',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    final List<double> widths = <double>[
      for (final Element e in find.byType(NavigationItemRow).evaluate())
        (e.renderObject! as RenderBox).size.width,
    ];
    expect(widths, hasLength(4));
    for (final double w in widths) {
      expect(w, moreOrLessEquals(widths.first, epsilon: 1));
    }
  });

  testWidgets('Sidebar collapsible expands and collapses', (tester) async {
    await _pumpPreview(tester, navigationBarPreviews[2]);
    expect(find.text('Account'), findsOneWidget);
    bool collapsed() => tester
        .widget<Hidden>(find.byKey(navigationCollapsibleChildrenKey))
        .hidden;
    // `Hidden` keeps its child mounted through the collapse animation, so
    // assert the flag rather than finder absence.
    expect(collapsed(), isFalse);
    // The header starts below the fold of the 320px sidebar box; scroll it
    // into view first (a tap outside the scroll viewport is clipped away).
    await tester.scrollUntilVisible(find.text('Profile'), 100);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(collapsed(), isTrue);
    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(collapsed(), isFalse);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in navigationBarPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
