// D4 getting started + CLI reference tests: both pages render their content
// from generated data (steps, code figures, CLI commands, flags tables).

import 'package:docs/routing/docs_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('getting started', () {
    testWidgets('renders steps with code figures', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/installation');
      expect(find.text('Getting started'), findsWidgets);
      // Step counters.
      expect(find.text('Create a Flutter project'), findsOneWidget);
      expect(find.text('Install the layer core'), findsOneWidget);
      expect(find.text('Add components'), findsOneWidget);
      expect(find.text('Choose a preset'), findsOneWidget);
      // Code figures.
      expect(find.text('flutter create my_app'), findsOneWidget);
      expect(find.text('flutter_shadcn init'), findsOneWidget);
      expect(find.textContaining('flutter_shadcn add button'), findsWidgets);
    });
  });

  group('cli reference', () {
    testWidgets('renders all command sections with flags tables', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/cli');
      expect(find.text('CLI reference'), findsWidgets);
      // First command section heading.
      expect(find.text('flutter_shadcn'), findsWidgets);
      // Flags table for add command.
      expect(find.text('flutter_shadcn add'), findsWidgets);
      expect(find.textContaining('--dry-run'), findsWidgets);
      expect(find.text('--json'), findsWidgets);
      expect(find.textContaining('--all'), findsWidgets);
    });

    testWidgets('renders theme apply command', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/cli');
      expect(find.text('flutter_shadcn theme apply'), findsWidgets);
      expect(find.textContaining('--refresh'), findsWidgets);
    });
  });
}
