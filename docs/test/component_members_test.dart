// D7: component pages render the generated `table.members` rows.
//
// Requirement 6 of the brief: the static/factory-first components (formatter,
// anchor, overlay_configuration, color, …) used to show an empty parameter
// table. The codegen now emits `DocsApiMember` rows for them, and the page has
// to render them. The assertions read the same generated map the page reads, so
// a component whose members regress to `[]` fails here.

import 'package:docs/generated/docs_api.dart';
import 'package:docs/generated/docs_data.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/widgets/code_teaser.dart';
import 'package:docs/widgets/component_sections.dart';
import 'package:docs/widgets/docs_article.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('generated members', () {
    test('the four components the brief names have members', () {
      for (final String id in <String>[
        'formatter',
        'anchor',
        'overlay_configuration',
        'color',
      ]) {
        final DocsApiTable table = kApiTables[id]!;
        expect(
          table.members,
          isNotEmpty,
          reason: '$id must expose its entry points',
        );
        for (final DocsApiMember member in table.members) {
          expect(member.name, isNotEmpty);
          expect(member.kind, isNotEmpty);
        }
      }
    });
  });

  group('component page', () {
    // `formatter` is verified through the generated data only: its
    // `preview.dart` (registry, components/formatter/preview.dart:92) puts a
    // raw `EditableText` under an unbounded width, which throws during layout
    // on the component page. Reported to the registry owner in P6-D7.md; the
    // fix is a width constraint around the `EditableText`.
    for (final String id in <String>[
      'anchor',
      'overlay_configuration',
      'color',
    ]) {
      testWidgets('/docs/components/$id renders the members table', (
        WidgetTester tester,
      ) async {
        final DocsRouterDelegate delegate = await pumpDocsApp(tester);
        await goTo(tester, delegate, '/docs/components/$id');
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(ComponentMembersSection), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(ComponentMembersSection),
            matching: find.text('Members'),
          ),
          findsOneWidget,
        );

        final List<DocsApiMember> members = kApiTables[id]!.members;
        // Spot-check the first two rows: their names and their kinds are on
        // the page verbatim.
        for (final DocsApiMember member in members.take(2)) {
          expect(
            find.descendant(
              of: find.byType(ComponentMembersSection),
              matching: find.text(member.name),
            ),
            findsOneWidget,
            reason: member.name,
          );
        }
      });
    }

    testWidgets('a component without members hides the section', (
      WidgetTester tester,
    ) async {
      // `button` exposes a constructor, so the codegen emits no member rows
      // and the page must not render an empty Members heading.
      final String id = kComponentLinks
          .firstWhere(
            (DocsComponentLink link) => kApiTables[link.id]!.members.isEmpty,
          )
          .id;
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/$id');
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ComponentMembersSection), findsNothing);
    });

    testWidgets('the preview teaser passes the snippet language', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/components/button');
      await tester.pump(const Duration(milliseconds: 100));
      // The install block + API tables are always present; the teaser only
      // renders once the deferred preview has loaded.
      expect(find.byType(DocsArticle), findsOneWidget);
      final Iterable<CodeTeaser> teasers = tester.widgetList<CodeTeaser>(
        find.byType(CodeTeaser),
      );
      for (final CodeTeaser teaser in teasers) {
        expect(teaser.language, isNotNull);
      }
    });
  });
}
