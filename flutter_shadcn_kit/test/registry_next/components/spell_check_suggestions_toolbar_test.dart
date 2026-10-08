// Widget tests for the `spell_check_suggestions_toolbar` component: row
// rendering, activation, disabled rows, empty state, the 3-item cap,
// anchoring, theme tokens and real sizes (row 32).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry_next/components/spell_check_suggestions_toolbar/spell_check_suggestions_toolbar.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (context) =>
                Align(alignment: Alignment.topLeft, child: child),
          ),
        ],
      ),
    ),
  );
}

Widget _toolbar({
  List<ContextMenuButtonItem>? items,
  Offset anchor = const Offset(12, 12),
}) {
  return SizedBox(
    width: 280,
    height: 160,
    child: SpellCheckSuggestionsToolbar(
      anchors: TextSelectionToolbarAnchors(primaryAnchor: anchor),
      buttonItems:
          items ??
          const <ContextMenuButtonItem>[
            ContextMenuButtonItem(label: 'receipt', onPressed: _noop),
            ContextMenuButtonItem(label: 'receipts', onPressed: _noop),
            ContextMenuButtonItem(label: 'deceit', onPressed: null),
          ],
    ),
  );
}

void _noop() {}

void main() {
  testWidgets('renders the suggestions on a popup surface', (tester) async {
    const ShadcnThemeData theme = ShadcnThemeData();
    await tester.pumpWidget(_frame(_toolbar()));
    await tester.pump();
    expect(find.text('receipt'), findsOneWidget);
    expect(find.text('receipts'), findsOneWidget);
    expect(find.text('deceit'), findsOneWidget);
    final Container surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(MenuPopup),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((surface.decoration! as BoxDecoration).color, theme.colors.popover);
  });

  testWidgets('rows are 32 high (shadcn h-8)', (tester) async {
    await tester.pumpWidget(_frame(_toolbar()));
    await tester.pump();
    expect(tester.getSize(find.byType(RovingRow).first).height, 32);
  });

  testWidgets('the toolbar anchors at the primary anchor offset', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_toolbar(anchor: const Offset(40, 30))));
    await tester.pump();
    final Offset topLeft = tester.getTopLeft(find.byType(MenuPopup));
    // primaryAnchor + (8, -8).
    expect(topLeft.dx, 48);
    expect(topLeft.dy, 22);
  });

  testWidgets('a suggestion press runs its callback', (tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      _frame(
        _toolbar(
          items: <ContextMenuButtonItem>[
            ContextMenuButtonItem(
              label: 'receipt',
              onPressed: () => pressed = true,
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('receipt'));
    await tester.pump();
    expect(pressed, isTrue);
  });

  testWidgets('a suggestion without a callback is dimmed and inert', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_toolbar()));
    await tester.pump();
    final Opacity opacity = tester.widget<Opacity>(
      find.ancestor(of: find.text('deceit'), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 0.5);
    await tester.tap(find.text('deceit'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('an empty toolbar renders nothing', (tester) async {
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 280,
          height: 160,
          child: SpellCheckSuggestionsToolbar(
            anchors: const TextSelectionToolbarAnchors(
              primaryAnchor: Offset(12, 12),
            ),
            buttonItems: const <ContextMenuButtonItem>[],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MenuPopup), findsNothing);
  });

  testWidgets('more than three suggestions are rejected', (tester) async {
    expect(
      () => SpellCheckSuggestionsToolbar(
        anchors: const TextSelectionToolbarAnchors(
          primaryAnchor: Offset(12, 12),
        ),
        buttonItems: const <ContextMenuButtonItem>[
          ContextMenuButtonItem(label: 'a', onPressed: _noop),
          ContextMenuButtonItem(label: 'b', onPressed: _noop),
          ContextMenuButtonItem(label: 'c', onPressed: _noop),
          ContextMenuButtonItem(label: 'd', onPressed: _noop),
        ],
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  testWidgets('a scoped MenuPopupTheme overrides the toolbar surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        ComponentTheme<MenuPopupTheme>(
          data: const MenuPopupTheme(
            background: ThemedColor.value(Color(0xFF00FF00)),
          ),
          child: _toolbar(),
        ),
      ),
    );
    await tester.pump();
    final Container surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(MenuPopup),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (surface.decoration! as BoxDecoration).color,
      const Color(0xFF00FF00),
    );
  });

  testWidgets('a placeholder item shows the localized no-suggestions row', (
    tester,
  ) async {
    expect(
      ShadcnLocalizations.english.spellCheckNoSuggestions,
      'No suggestions',
    );
    await tester.pumpWidget(
      _frame(
        _toolbar(
          items: const <ContextMenuButtonItem>[
            ContextMenuButtonItem(onPressed: null),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(find.text('No suggestions'), findsOneWidget);
    final Opacity opacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.text('No suggestions'),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0.5);
    await tester.tap(find.text('No suggestions'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark tokens drive the toolbar surface', (tester) async {
    const ShadcnThemeData theme = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(_frame(_toolbar(), data: theme));
    await tester.pump();
    final Container surface = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(MenuPopup),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((surface.decoration! as BoxDecoration).color, theme.colors.popover);
  });
}
