// P7-U1 acceptance: overlay anchoring, popup width rules, highlight without
// rings, select single-line options, command input/list metrics.
//
// Every test reads real rects, sizes and colours: light + dark, neutral +
// claude presets, compact/default/comfortable densities, 800/1440/375
// viewports, LTR + RTL. See `rearch/briefs/fixes/P7-U1-overlays.md`.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/autocomplete/autocomplete.dart';
import 'package:flutter_shadcn_kit/registry/components/command/command.dart';
import 'package:flutter_shadcn_kit/registry/components/divider/divider.dart';
import 'package:flutter_shadcn_kit/registry/components/dropdown_menu/dropdown_menu.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/components/menubar/menubar.dart';
import 'package:flutter_shadcn_kit/registry/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry/primitives/select_popup.dart';
import 'package:flutter_shadcn_kit/registry/primitives/subfocus_list_item.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../themes/generated_theme.dart';
import '../theme_audit/theme_audit_helpers.dart';

/// Pumps [child] in an overlay at the top-left of the test viewport.
Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
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

/// Sizes the test viewport; callers reset with [addTearDown].
void _setViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

/// Moves a mouse pointer onto [finder]; hover highlights only report under
/// the traditional focus strategy.
Future<TestGesture> _hover(WidgetTester tester, Finder finder) async {
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(
    () => FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.automatic,
  );
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(finder));
  await tester.pump();
  return gesture;
}

/// Advances past overlay transitions (the follow ticker never settles).
Future<void> _settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

/// A menubar whose File menu holds three short rows.
Menubar _bar() {
  return Menubar(
    children: <Widget>[
      MenuButton(
        subMenu: <Widget>[
          MenuButton(onPressed: _noop, child: const Text('New release')),
          MenuButton(onPressed: _noop, child: const Text('Open')),
          MenuButton(onPressed: _noop, child: const Text('Export CSV')),
        ],
        child: const Text('File'),
      ),
      MenuButton(
        subMenu: <Widget>[
          MenuButton(onPressed: _noop, child: const Text('Undo')),
          MenuButton(onPressed: _noop, child: const Text('Redo')),
        ],
        child: const Text('Edit'),
      ),
    ],
  );
}

void _noop(BuildContext context) {}

BoxDecoration _rowDecoration(WidgetTester tester, Finder row) {
  final AnimatedContainer container = tester.widget<AnimatedContainer>(
    find.descendant(of: row, matching: find.byType(AnimatedContainer)).first,
  );
  return container.decoration! as BoxDecoration;
}

/// A single-trigger menubar pinned to the bar's end edge.
class _BarAtEdge extends StatelessWidget {
  const _BarAtEdge();

  @override
  Widget build(BuildContext context) {
    return Menubar(
      children: <Widget>[
        MenuButton(
          subMenu: <Widget>[
            MenuButton(onPressed: _noop, child: const Text('New release')),
            MenuButton(onPressed: _noop, child: const Text('Open')),
          ],
          child: const Text('File'),
        ),
      ],
    );
  }
}

void main() {
  group('menu anchoring', () {
    testWidgets('menubar submenu opens below the trigger start edge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          Padding(
            padding: const EdgeInsets.only(left: 100, top: 50),
            child: _bar(),
          ),
        ),
      );
      await tester.pump();
      final Finder fileRow = find.ancestor(
        of: find.text('File'),
        matching: find.byType(RovingRow),
      );
      final Offset rowTopLeft = tester.getTopLeft(fileRow);
      final Size rowSize = tester.getSize(fileRow);
      await tester.tap(find.text('File'));
      await _settleOverlay(tester);
      expect(find.text('New release'), findsOneWidget);
      final Offset popupTopLeft = tester.getTopLeft(
        find.byType(MenuPopup).first,
      );
      // menubar alignOffset -4, sideOffset 8 (away from the edges, so the
      // viewport margin does not shift the popup).
      expect(popupTopLeft.dx, moreOrLessEquals(rowTopLeft.dx - 4, epsilon: 1));
      expect(
        popupTopLeft.dy,
        moreOrLessEquals(rowTopLeft.dy + rowSize.height + 8, epsilon: 1),
      );
    });

    testWidgets('menu popup hugs short content instead of stretching', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_bar()));
      await tester.pump();
      await tester.tap(find.text('Edit'));
      await _settleOverlay(tester);
      expect(find.text('Undo'), findsOneWidget);
      final Size popup = tester.getSize(find.byType(MenuPopup).first);
      expect(popup.width, greaterThanOrEqualTo(128));
      expect(popup.width, lessThan(288));
    });

    testWidgets('near the right edge the popup shifts to stay on screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (context) => const Align(
                    alignment: Alignment.topRight,
                    child: _BarAtEdge(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('File'));
      await _settleOverlay(tester);
      expect(find.text('New release'), findsOneWidget);
      final Rect popup = tester.getRect(find.byType(MenuPopup).first);
      expect(popup.right, lessThanOrEqualTo(800));
      expect(popup.left, greaterThanOrEqualTo(0));
    });

    testWidgets('375px viewport keeps the popup on screen', (tester) async {
      _setViewport(tester, const Size(375, 667));
      await tester.pumpWidget(_frame(_bar()));
      await tester.pump();
      await tester.tap(find.text('Edit'));
      await _settleOverlay(tester);
      expect(find.text('Undo'), findsOneWidget);
      final Rect popup = tester.getRect(find.byType(MenuPopup).first);
      expect(popup.left, greaterThanOrEqualTo(0));
      expect(popup.right, lessThanOrEqualTo(375));
      expect(popup.width, greaterThanOrEqualTo(128));
    });

    testWidgets('RTL opens below the trigger end edge', (tester) async {
      await tester.pumpWidget(
        _frame(
          Padding(
            padding: const EdgeInsets.only(left: 100, top: 50),
            child: _bar(),
          ),
          direction: TextDirection.rtl,
        ),
      );
      await tester.pump();
      final Finder fileRow = find.ancestor(
        of: find.text('File'),
        matching: find.byType(RovingRow),
      );
      final Offset rowTopLeft = tester.getTopLeft(fileRow);
      final Size rowSize = tester.getSize(fileRow);
      await tester.tap(find.text('File'));
      await _settleOverlay(tester);
      expect(find.text('New release'), findsOneWidget);
      final Rect popup = tester.getRect(find.byType(MenuPopup).first);
      // Mirrored alignOffset (+4): popup end edge sits 4px past the trigger.
      expect(
        popup.right,
        moreOrLessEquals(rowTopLeft.dx + rowSize.width + 4, epsilon: 1),
      );
      expect(
        popup.top,
        moreOrLessEquals(rowTopLeft.dy + rowSize.height + 8, epsilon: 1),
      );
    });

    testWidgets('dropdown popup aligns to the trigger start edge', (
      tester,
    ) async {
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          Padding(
            padding: const EdgeInsets.only(left: 100, top: 50),
            child: Builder(
              builder: (context) {
                host = context;
                return const SizedBox(width: 120, height: 36);
              },
            ),
          ),
        ),
      );
      await tester.pump();
      final Future<void> opened = showShadcnDropdown<void>(
        context: host,
        children: <Widget>[
          MenuButton(onPressed: _noop, child: const Text('Profile')),
        ],
      ).then((_) {});
      await _settleOverlay(tester);
      expect(find.text('Profile'), findsOneWidget);
      final Offset hostTopLeft = tester.getTopLeft(find.byType(SizedBox).first);
      final Offset popupTopLeft = tester.getTopLeft(
        find.byType(MenuPopup).first,
      );
      expect(popupTopLeft.dx, moreOrLessEquals(hostTopLeft.dx, epsilon: 1));
      expect(
        popupTopLeft.dy,
        moreOrLessEquals(hostTopLeft.dy + 36 + 4, epsilon: 1),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await opened;
    });
  });

  group('menu highlight and surface', () {
    testWidgets('hovered row paints accent, no border, no focus ring', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              MenuGroup(
                children: <MenuItem>[
                  MenuButton(onPressed: _noop, child: const Text('Cut')),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      final TestGesture gesture = await _hover(tester, find.text('Cut'));
      final ShadcnColors colors = const ShadcnThemeData().colors;
      final BoxDecoration decoration = _rowDecoration(
        tester,
        find.byType(RovingRow).first,
      );
      expect(decoration.color, colors.accent);
      expect(decoration.border, isNull);
      // `Clickable` always builds its `FocusOutline` shell: rows must keep
      // it unfocused so no ring ever paints over the accent fill.
      final List<FocusOutline> outlines = tester
          .widgetList<FocusOutline>(
            find.descendant(
              of: find.byType(RovingRow),
              matching: find.byType(FocusOutline),
            ),
          )
          .toList();
      expect(outlines, isNotEmpty);
      expect(outlines.every((outline) => !outline.focused), isTrue);
      await gesture.moveTo(const Offset(5000, 5000));
      await tester.pump();
    });

    testWidgets('highlight without ring across presets and brightness', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final TestGesture gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      for (final String preset in <String>['neutral', 'claude']) {
        for (final Brightness brightness in Brightness.values) {
          final GeneratedTheme theme = loadPreset(preset);
          final view = theme.view(brightness);
          await tester.pumpWidget(
            _frame(
              MenuPopup(
                children: <Widget>[
                  MenuGroup(
                    children: <MenuItem>[
                      MenuButton(onPressed: _noop, child: const Text('Cut')),
                    ],
                  ),
                ],
              ),
              data: ShadcnThemeData(
                colors: view.colors,
                tokens: view.tokens,
                fonts: view.fonts,
              ),
            ),
          );
          await tester.pump();
          await gesture.moveTo(tester.getCenter(find.text('Cut')));
          await tester.pump();
          final BoxDecoration decoration = _rowDecoration(
            tester,
            find.byType(RovingRow).first,
          );
          expect(
            decoration.color,
            view.colors.accent,
            reason: '$preset $brightness accent fill',
          );
          expect(decoration.border, isNull, reason: '$preset $brightness');
          final List<FocusOutline> outlines = tester
              .widgetList<FocusOutline>(
                find.descendant(
                  of: find.byType(RovingRow),
                  matching: find.byType(FocusOutline),
                ),
              )
              .toList();
          expect(outlines, isNotEmpty, reason: '$preset $brightness');
          expect(
            outlines.every((outline) => !outline.focused),
            isTrue,
            reason: '$preset $brightness',
          );
          await gesture.moveTo(const Offset(5000, 5000));
          await tester.pump();
        }
      }
    });

    testWidgets('popup surface paints popover tokens with shadow', (
      tester,
    ) async {
      const ShadcnThemeData theme = ShadcnThemeData();
      await tester.pumpWidget(
        _frame(const MenuPopup(children: <Widget>[Text('x')])),
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
      final BoxDecoration decoration = surface.decoration! as BoxDecoration;
      expect(decoration.color, theme.colors.popover);
      expect(decoration.border!.top.color, theme.colors.border);
      expect(decoration.border!.top.width, 1);
      expect(decoration.borderRadius, theme.borderRadiusMd);
      expect(decoration.boxShadow, theme.tokens.shadows.shadowMd);
      expect(surface.padding, const EdgeInsets.all(4));
    });
  });

  group('select popup width', () {
    Select<String> select({
      double triggerWidth = 220,
      List<Widget>? items,
      String? value,
    }) {
      return Select<String>(
        value: value,
        onChanged: (_) {},
        placeholder: const Text('Pick'),
        itemBuilder: (context, value) => Text(value),
        items:
            items ??
            <Widget>[
              const SelectItem<String>(value: 'Apple', child: Text('Apple')),
              const SelectItem<String>(value: 'Banana', child: Text('Banana')),
            ],
      );
    }

    Future<void> openSelect(WidgetTester tester) async {
      await tester.tap(find.text('Pick'));
      await _settleOverlay(tester);
      expect(find.text('Apple'), findsOneWidget);
    }

    testWidgets('short options keep the trigger width', (tester) async {
      await tester.pumpWidget(_frame(SizedBox(width: 220, child: select())));
      await tester.pump();
      await openSelect(tester);
      expect(
        tester.getSize(find.byType(MenuPopup).first).width,
        moreOrLessEquals(220, epsilon: 1),
      );
    });

    testWidgets('a long option grows the popup past the trigger', (
      tester,
    ) async {
      const String long =
          'A very long option label that surely exceeds two hundred pixels';
      await tester.pumpWidget(
        _frame(
          SizedBox(
            width: 220,
            child: select(
              items: const <Widget>[
                SelectItem<String>(value: 'Apple', child: Text('Apple')),
                SelectItem<String>(value: 'long', child: Text(long)),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Pick'));
      await _settleOverlay(tester);
      expect(find.text(long), findsOneWidget);
      final double width = tester.getSize(find.byType(MenuPopup).first).width;
      expect(width, greaterThan(220));
      expect(width, lessThanOrEqualTo(800));
    });

    testWidgets('narrow triggers clamp to the 128 minimum', (tester) async {
      await tester.pumpWidget(_frame(SizedBox(width: 100, child: select())));
      await tester.pump();
      await openSelect(tester);
      final double width = tester.getSize(find.byType(MenuPopup).first).width;
      expect(width, greaterThanOrEqualTo(128));
      expect(width, lessThan(200));
    });

    testWidgets('options are single-line with ellipsis', (tester) async {
      await tester.pumpWidget(_frame(SizedBox(width: 220, child: select())));
      await tester.pump();
      await openSelect(tester);
      final Finder optionTexts = find.descendant(
        of: find.byType(SelectItem<String>),
        matching: find.byType(Text),
      );
      expect(optionTexts, findsNWidgets(2));
      for (final Text text in tester.widgetList<Text>(optionTexts)) {
        expect(text.maxLines, 1);
        expect(text.overflow, TextOverflow.ellipsis);
        expect(text.softWrap, isFalse);
      }
    });

    testWidgets('the check gutter is reserved on every option', (tester) async {
      await tester.pumpWidget(_frame(SizedBox(width: 220, child: select())));
      await tester.pump();
      await openSelect(tester);
      // One 16px gutter per option row, even with nothing selected.
      expect(
        find.descendant(
          of: find.byType(SelectRow),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox && widget.width == 16 && widget.height == 16,
          ),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('selecting shows the check indicator', (tester) async {
      String? value = 'Apple';
      await tester.pumpWidget(
        _frame(
          SizedBox(
            width: 220,
            child: StatefulBuilder(
              builder: (context, setState) => Select<String>(
                value: value,
                onChanged: (next) => setState(() => value = next),
                placeholder: const Text('Pick'),
                itemBuilder: (context, value) => Text(value),
                items: const <Widget>[
                  SelectItem<String>(value: 'Apple', child: Text('Apple')),
                  SelectItem<String>(value: 'Banana', child: Text('Banana')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Apple').first);
      await _settleOverlay(tester);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
    });
  });

  group('autocomplete popup width', () {
    Input field(List<String> Function(String query) suggestions) {
      return Input(
        features: <InputFeature>[AutoCompleteFeature(suggestions: suggestions)],
      );
    }

    Future<void> typeQuery(WidgetTester tester, String text) async {
      await tester.enterText(find.byType(EditableText), text);
      tester
          .widget<EditableText>(find.byType(EditableText))
          .controller
          .selection = TextSelection.collapsed(
        offset: text.length,
      );
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('short suggestions keep the field width', (tester) async {
      await tester.pumpWidget(
        _frame(
          SizedBox(
            width: 220,
            child: field(
              (query) => query.isEmpty
                  ? const <String>[]
                  : <String>['apple', 'apricot'],
            ),
          ),
        ),
      );
      await tester.pump();
      await typeQuery(tester, 'a');
      expect(find.text('apple'), findsOneWidget);
      expect(
        tester.getSize(find.byType(MenuPopupSurface).first).width,
        moreOrLessEquals(220, epsilon: 1),
      );
    });

    testWidgets('a long suggestion grows past the field', (tester) async {
      const String long =
          'A very long suggestion that surely exceeds two hundred pixels';
      await tester.pumpWidget(
        _frame(
          SizedBox(
            width: 220,
            child: field(
              (query) => query.isEmpty ? const <String>[] : <String>[long],
            ),
          ),
        ),
      );
      await tester.pump();
      await typeQuery(tester, 'a');
      expect(find.text(long), findsOneWidget);
      final double width = tester
          .getSize(find.byType(MenuPopupSurface).first)
          .width;
      expect(width, greaterThan(220));
      expect(width, lessThanOrEqualTo(800));
    });

    testWidgets('suggestion rows are single-line', (tester) async {
      await tester.pumpWidget(
        _frame(
          SizedBox(
            width: 220,
            child: field(
              (query) => query.isEmpty
                  ? const <String>[]
                  : <String>['apple', 'apricot'],
            ),
          ),
        ),
      );
      await tester.pump();
      await typeQuery(tester, 'a');
      final Finder rows = find.descendant(
        of: find.byType(MenuPopupSurface),
        matching: find.byType(Text),
      );
      expect(rows, findsNWidgets(2));
      for (final Text text in tester.widgetList<Text>(rows)) {
        expect(text.maxLines, 1);
        expect(text.overflow, TextOverflow.ellipsis);
        expect(text.softWrap, isFalse);
      }
    });
  });

  group('command metrics', () {
    Command palette({int count = 3}) {
      return Command(
        debounceDuration: Duration.zero,
        builder: (context, query) async* {
          yield <Widget>[
            for (int i = 0; i < count; i++)
              SubFocusListItem(title: Text('Item $i'), onTap: () {}),
          ];
        },
      );
    }

    testWidgets('input row is h-9 with a 16px half-opacity icon', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(SizedBox(width: 320, child: palette())));
      await tester.pump();
      await tester.pump();
      expect(tester.getSize(find.byType(Input)).height, 36);
      final Icon icon = tester.widget<Icon>(find.byIcon(LucideIcons.search));
      expect(icon.size, 16);
      final Opacity opacity = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.byIcon(LucideIcons.search),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 0.5);
    });

    testWidgets('no dividers or rings inside the palette', (tester) async {
      await tester.pumpWidget(_frame(SizedBox(width: 320, child: palette())));
      await tester.pump();
      await tester.pump();
      expect(find.byType(Divider), findsNothing);
      final List<FocusOutline> outlines = tester
          .widgetList<FocusOutline>(
            find.descendant(
              of: find.byType(SubFocusListItem),
              matching: find.byType(FocusOutline),
            ),
          )
          .toList();
      expect(outlines, isNotEmpty);
      expect(outlines.every((outline) => !outline.focused), isTrue);
    });

    testWidgets('list has p-1 and caps at 300 with scroll', (tester) async {
      await tester.pumpWidget(
        _frame(SizedBox(width: 320, child: palette(count: 20))),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Item 0'), findsOneWidget);
      expect(
        tester.widget<ListView>(find.byType(ListView)).padding,
        const EdgeInsets.all(4),
      );
      expect(tester.getSize(find.byType(ListView)).height, 300);
      // Taller than the cap, so the list scrolls instead of overflowing.
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
        findsOneWidget,
      );
    });

    testWidgets('surface paints popover tokens with shadow-lg', (tester) async {
      const ShadcnThemeData theme = ShadcnThemeData();
      await tester.pumpWidget(_frame(SizedBox(width: 320, child: palette())));
      await tester.pump();
      await tester.pump();
      final DecoratedBox surface = tester.widget<DecoratedBox>(
        find
            .ancestor(
              of: find.byType(Input),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final BoxDecoration decoration = surface.decoration as BoxDecoration;
      expect(decoration.color, theme.colors.popover);
      expect(decoration.border!.top.color, theme.colors.border);
      expect(decoration.borderRadius, theme.borderRadiusLg);
      expect(decoration.boxShadow, theme.tokens.shadows.shadowLg);
    });

    test('dialog width matches max-w-lg and rows match px-2 py-1.5', () {
      expect(commandDefaults.maxWidth, 512);
      expect(
        const SubFocusListItem(title: Text('x')).padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      );
    });
  });

  group('density scale', () {
    final Map<String, Density> densities = <String, Density>{
      'compact': Density.compactDensity,
      'default': Density.defaultDensity,
      'comfortable': Density.spaciousDensity,
    };
    for (final MapEntry<String, Density> entry in densities.entries) {
      testWidgets('rows stay h-8 and input stays h-9 (${entry.key})', (
        tester,
      ) async {
        await tester.pumpWidget(
          _frame(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MenuGroup(
                  children: <MenuItem>[
                    MenuButton(onPressed: _noop, child: const Text('Cut')),
                  ],
                ),
                SizedBox(
                  width: 320,
                  child: Command(
                    debounceDuration: Duration.zero,
                    builder: (context, query) async* {
                      yield <Widget>[
                        SubFocusListItem(title: const Text('Go'), onTap: () {}),
                      ];
                    },
                  ),
                ),
              ],
            ),
            data: ShadcnThemeData(density: entry.value),
          ),
        );
        await tester.pump();
        await tester.pump();
        expect(tester.getSize(find.byType(RovingRow).first).height, 32);
        expect(tester.getSize(find.byType(Input)).height, 36);
      });
    }
  });
}
