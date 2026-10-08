// Size audit C: table + markdown spacing vs shadcn/ui new-york v4.
//
// Split from `size_audit_b_test.dart` (400-line limit). Same conventions as
// `size_audit_a_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/markdown/markdown.dart';
import 'package:flutter_shadcn_kit/registry_next/components/table/table.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('table (head h-10 px-2, cell p-2)', () {
    Widget table() {
      return ShadcnTable(
        rows: const <ShadcnTableRow>[
          ShadcnTableHeader(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Name')),
              ShadcnTableCell(child: Text('Role')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Avery')),
              ShadcnTableCell(child: Text('Designer')),
            ],
          ),
        ],
      );
    }

    testWidgets('header row is 40px tall with 8px side padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 400, height: 300, child: table()),
            ),
          ),
        ),
      );
      final ConstrainedBox box = tester.widget<ConstrainedBox>(
        find
            .ancestor(
              of: find.text('Name'),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(box.constraints.minHeight, 40);
      final Padding padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Name'), matching: find.byType(Padding))
            .first,
      );
      expect(padding.padding.resolve(TextDirection.ltr).horizontal, 16);
    });

    testWidgets('body cells pad 8 on every side (p-2)', (tester) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 400, height: 300, child: table()),
            ),
          ),
        ),
      );
      final Iterable<Padding> paddings = tester.widgetList<Padding>(
        find.ancestor(of: find.text('Avery'), matching: find.byType(Padding)),
      );
      expect(paddings.any((p) => p.padding == const EdgeInsets.all(8)), isTrue);
    });

    testWidgets('header text is medium foreground (v4 TableHead)', (
      tester,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 400, height: 300, child: table()),
            ),
          ),
        ),
      );
      final DefaultTextStyle text = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Name'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expect(text.style.fontWeight, FontWeight.w500);
      expect(text.style.color, const ShadcnThemeData().colors.foreground);
    });
  });

  group('markdown (paragraph/code spacing)', () {
    // Same host as the component tests: image preview behavior resolves a
    // Navigator, and prose needs a bounded width.
    Widget mdFrame({required Widget child}) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Navigator(
            onGenerateRoute: (_) => PageRouteBuilder<void>(
              pageBuilder: (_, _, _) => SizedBox(width: 400, child: child),
            ),
          ),
        ),
      );
    }

    testWidgets('paragraph blocks gap by blockSpacing (6)', (tester) async {
      // A blank source line renders its own 8px block, so two paragraphs
      // separated by one blank line sit 6 (blockSpacing) + 8 (blank) = 14
      // apart. shadcn typography uses mt-6 (24); the kit compacts both
      // legs (see the P4-M1 report).
      await tester.pumpWidget(
        mdFrame(child: const Markdown(data: 'Para one.\n\nPara two.')),
      );
      await tester.pump();
      final Rect first = tester.getRect(
        find.text('Para one.', findRichText: true),
      );
      final Rect second = tester.getRect(
        find.text('Para two.', findRichText: true),
      );
      expect(second.top - first.bottom, closeTo(14, 0.01));
      final Iterable<Padding> paddings = tester.widgetList<Padding>(
        find.byType(Padding),
      );
      expect(
        paddings.any(
          (p) =>
              p.padding is EdgeInsets && (p.padding as EdgeInsets).bottom == 6,
        ),
        isTrue,
        reason: 'blockSpacing bottom padding',
      );
    });

    testWidgets('fenced code pads 12 with 6px vertical margins', (
      tester,
    ) async {
      // shadcn docs `pre` uses p-4 (16); the kit compacts to 12. Pinned
      // here so the primitives batch can align it deliberately.
      await tester.pumpWidget(
        mdFrame(child: const Markdown(data: '```dart\ncode\n```')),
      );
      await tester.pump();
      final Finder codeText = find.byWidgetPredicate(
        (w) =>
            w is RichText &&
            w.text.toPlainText().contains('code') &&
            w.text.toPlainText().trim().length < 10,
        description: 'code block text',
      );
      expect(codeText, findsOneWidget);
      final Iterable<Container> boxes = tester.widgetList<Container>(
        find.ancestor(of: codeText, matching: find.byType(Container)),
      );
      final Container code = boxes.firstWhere(
        (c) => c.padding == const EdgeInsets.all(12),
      );
      expect(code.margin, const EdgeInsets.symmetric(vertical: 6));
    });

    testWidgets('inline code paints the mono code background', (tester) async {
      // shadcn inline code is `px-[0.3rem] py-[0.2rem]` on muted; the kit
      // paints mono + background with no padding (TextSpan cannot pad).
      // Pinned so the primitives batch can promote it to a WidgetSpan.
      await tester.pumpWidget(
        mdFrame(child: const Markdown(data: 'Use `code` here.')),
      );
      await tester.pump();
      final RichText text = tester.widget<RichText>(
        find.byType(RichText).first,
      );
      bool found = false;
      void visit(InlineSpan span) {
        if (span is TextSpan) {
          if (span.text == 'code' && span.style?.backgroundColor != null) {
            found = true;
          }
          span.children?.forEach(visit);
        }
      }

      visit(text.text);
      expect(found, isTrue);
    });
  });
}
