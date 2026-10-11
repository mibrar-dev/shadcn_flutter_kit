// Widget tests for the `collapsible` component.
//
// Covers the uncontrolled and controlled flows, the callback value, the four
// theme-precedence legs, icon defaults and keyboard activation. The
// regression tests pin the old bugs: the callback received the previous
// state, and an uncontrolled section with a callback never toggled.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/collapsible/collapsible.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CollapsibleTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<CollapsibleTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

bool _contentHidden(WidgetTester tester) {
  return tester
      .widget<Offstage>(
        find.ancestor(
          of: find.text('content', skipOffstage: false),
          matching: find.byType(Offstage),
        ),
      )
      .offstage;
}

void main() {
  testWidgets('uncontrolled section toggles its content', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(child: Text('content')),
          ],
        ),
      ),
    );

    expect(_contentHidden(tester), isTrue);
    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(_contentHidden(tester), isFalse);
    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(_contentHidden(tester), isTrue);
  });

  testWidgets('regression: the callback receives the new state', (
    tester,
  ) async {
    final List<bool> reported = <bool>[];
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          onExpansionChanged: reported.add,
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(child: Text('content')),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(reported, <bool>[true]);
    // The old code replaced setState with the callback, so the section never
    // opened; the new code toggles first and reports the new value.
    expect(_contentHidden(tester), isFalse);

    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(reported, <bool>[true, false]);
    expect(_contentHidden(tester), isTrue);
  });

  testWidgets('controlled section reports without changing itself', (
    tester,
  ) async {
    final List<bool> reported = <bool>[];
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          isExpanded: false,
          onExpansionChanged: reported.add,
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(child: Text('content')),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(reported, <bool>[true]);
    expect(_contentHidden(tester), isTrue);

    // The parent drives the state.
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          isExpanded: true,
          onExpansionChanged: reported.add,
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(child: Text('content')),
          ],
        ),
      ),
    );
    expect(_contentHidden(tester), isFalse);
  });

  testWidgets('all four theme legs override per field', (tester) async {
    Future<void> expectPadding(
      WidgetTester tester, {
      required double horizontal,
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      CollapsibleTheme? scoped,
      CollapsibleTheme? widgetTheme,
    }) async {
      await tester.pumpWidget(
        _frame(
          app: app,
          scoped: scoped,
          child: Collapsible(
            children: <Widget>[
              CollapsibleTrigger(
                theme: widgetTheme,
                child: const Text('title'),
              ),
            ],
          ),
        ),
      );
      final Padding padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(CollapsibleTrigger),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect((padding.padding as EdgeInsets).left, horizontal);
    }

    // Default: content density (16) times scaling (1).
    await expectPadding(tester, horizontal: 16);
    await expectPadding(
      tester,
      horizontal: 20,
      app: <ComponentThemeData>[const CollapsibleTheme(padding: 20)],
    );
    await expectPadding(
      tester,
      horizontal: 24,
      app: <ComponentThemeData>[const CollapsibleTheme(padding: 20)],
      scoped: const CollapsibleTheme(padding: 24),
    );
    await expectPadding(
      tester,
      horizontal: 28,
      app: <ComponentThemeData>[const CollapsibleTheme(padding: 20)],
      scoped: const CollapsibleTheme(padding: 24),
      widgetTheme: const CollapsibleTheme(padding: 28),
    );
  });

  testWidgets('icon defaults follow the expanded state', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(child: Text('content')),
          ],
        ),
      ),
    );

    Icon iconOf() => tester.widget<Icon>(
      find.descendant(
        of: find.byType(CollapsibleTrigger),
        matching: find.byType(Icon),
      ),
    );
    expect(iconOf().icon, LucideIcons.chevronsUpDown);

    await tester.tap(find.byType(Button));
    await tester.pump();
    expect(iconOf().icon, LucideIcons.chevronsDownUp);
  });

  testWidgets('dark palette colours the icon with mutedForeground', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: Collapsible(
          children: <Widget>[const CollapsibleTrigger(child: Text('title'))],
        ),
      ),
    );

    final IconTheme theme = tester.widget<IconTheme>(
      find
          .ancestor(of: find.byType(Icon), matching: find.byType(IconTheme))
          .first,
    );
    expect(theme.data.color, ShadcnColors.darkFallback.mutedForeground);
  });

  testWidgets('keyboard activation toggles the section', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(child: Text('content')),
          ],
        ),
      ),
    );

    final FocusNode node = Focus.of(tester.element(find.byType(Icon)));
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(_contentHidden(tester), isFalse);
  });

  testWidgets('content pane with collapsible false stays visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: Collapsible(
          children: <Widget>[
            const CollapsibleTrigger(child: Text('title')),
            const CollapsibleContent(
              collapsible: false,
              child: Text('content'),
            ),
          ],
        ),
      ),
    );
    expect(_contentHidden(tester), isFalse);
  });
}
