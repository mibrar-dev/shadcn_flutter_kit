// Home showcase tests (P6-H1): the landing wall holds 30+ composed cards,
// relayouts its columns with the viewport, never overflows at 375 / 768 /
// 1440 in light and dark, follows the theme, and every overlay trigger
// opens its real registry overlay.

import 'package:docs/ui/shadcn/primitives/masonry_layout.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/collage.dart';
import 'package:docs/widgets/collage_cards.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

/// Number of showcase cards the wall must at least hold (brief: >= 30).
const int _kMinimumCards = 30;

void main() {
  testWidgets('landing wall holds 30+ composed cards', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    expect(find.byType(DocsCollage), findsOneWidget);
    final int cards = find.byType(CollageCard).evaluate().length;
    expect(cards, greaterThanOrEqualTo(_kMinimumCards));
    // Spot-check every coverage family the brief requires.
    for (final String title in <String>[
      'Payout Threshold', // forms
      'Share document', // overlays (dialog trigger)
      'Danger zone', // overlays (alert trigger)
      'Account panel', // overlays (drawer/sheet triggers)
      'Menu bar', // overlays (anchored popovers)
      'Quick actions', // overlays (opened menu)
      'Command palette', // overlays (palette trigger)
      'Recent Transactions', // data display
      'Team Members', // data display
      'Frequently asked questions', // data display
      'Browse', // navigation
      'Release checklist', // navigation
      'Workspace', // navigation
      'Notices', // feedback
      'Storage', // feedback (quota bars)
      'Rate this release', // feedback
      'Release date', // date/time
      'Reporting Period', // date/time
      'Standup time', // date/time
      'Contribution History', // charts-like stats
      'Net Revenue', // charts-like stats
      'Power Usage', // charts-like stats
      'Support', // chat
      'Notifications', // settings
      'Preferences', // settings
      'Welcome back', // auth
      'Create Account', // auth
      'Verify your phone', // auth
      'Contributors', // people
      'Release timeline', // plan
    ]) {
      expect(find.text(title), findsWidgets, reason: 'missing card $title');
    }
  });

  testWidgets('wall relayouts 4 / 3 / 2 columns with the viewport', (
    tester,
  ) async {
    Future<int?> columnsAt(double width) async {
      await pumpDocsApp(tester, width: width, height: 900);
      final List<MasonryLayout> walls = tester
          .widgetList<MasonryLayout>(find.byType(MasonryLayout))
          .toList();
      expect(walls, hasLength(1));
      return walls.single.crossAxisCount;
    }

    expect(await columnsAt(1440), 4);
    expect(await columnsAt(1100), 3);
    expect(await columnsAt(800), 2);
  });

  testWidgets('no overflow at 375 / 768 / 1440, light and dark', (
    tester,
  ) async {
    for (final Brightness brightness in <Brightness>[
      Brightness.light,
      Brightness.dark,
    ]) {
      for (final double width in <double>[375, 768, 1440]) {
        await pumpDocsApp(
          tester,
          width: width,
          height: 900,
          platformBrightness: brightness,
        );
        docsState.setBrightness(brightness);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'home overflow at $width ($brightness)',
        );
        expect(
          find.byType(CollageCard),
          findsWidgets,
          reason: 'the wall re-themes live at $width ($brightness)',
        );
      }
    }
  });

  testWidgets('wall follows the live theme (light vs dark)', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    Color background() => ShadcnTheme.of(
      tester.element(find.byType(DocsCollage).first),
    ).colors.background;
    docsState.setBrightness(Brightness.light);
    await tester.pumpAndSettle();
    final Color light = background();
    docsState.setBrightness(Brightness.dark);
    await tester.pumpAndSettle();
    expect(background(), isNot(light));
  });

  testWidgets('dialog trigger opens a real dialog', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    expect(find.text('Share this document'), findsNothing);
    await tester.ensureVisible(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Share this document'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Share this document'), findsNothing);
  });

  testWidgets('danger zone opens a real alert dialog', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    await tester.ensureVisible(find.text('Delete project'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete project'));
    await tester.pumpAndSettle();
    expect(find.text('Delete this project?'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Delete this project?'), findsNothing);
  });

  testWidgets('panel buttons open the drawer and the sheet', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    await tester.ensureVisible(find.text('Open drawer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    expect(find.text('Close panel'), findsOneWidget);
    await tester.tap(find.text('Close panel'));
    await tester.pumpAndSettle();
    expect(find.text('Close panel'), findsNothing);

    await tester.ensureVisible(find.text('Open sheet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    expect(find.text('Close panel'), findsOneWidget);
    await tester.tap(find.text('Close panel'));
    await tester.pumpAndSettle();
    expect(find.text('Close panel'), findsNothing);
  });

  testWidgets('command trigger opens a real palette', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    await tester.ensureVisible(find.text('Commands…'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Commands…'));
    await tester.pumpAndSettle();
    expect(find.text('Go to Dashboard'), findsOneWidget);
    expect(find.text('Create release'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Go to Dashboard'), findsNothing);
  });

  testWidgets('opened menu surface and menubar render inline', (tester) async {
    await pumpDocsApp(tester, width: 1400);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.text('File'), findsOneWidget);
    expect(find.text('⌘Q'), findsOneWidget);
  });
}
