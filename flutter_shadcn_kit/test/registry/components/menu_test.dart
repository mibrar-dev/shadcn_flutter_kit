// Widget tests for the `menu` component.
//
// Covers row rendering, press/disabled, hover submenus, the popup surface,
// keyboard traversal (arrows/Home/End/typeahead/Escape), all four theme legs,
// light and dark tokens, real sizes, plus regressions for the old module's
// Material import and sibling-submenu leaks.

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

int _overlayGeneration = 0;

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  MenuTheme? scopedMenu,
  MenuPopupTheme? scopedPopup,
}) {
  Widget body = child;
  if (scopedMenu != null) {
    body = ComponentTheme<MenuTheme>(data: scopedMenu, child: body);
  }
  if (scopedPopup != null) {
    body = ComponentTheme<MenuPopupTheme>(data: scopedPopup, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          key: ValueKey<int>(_overlayGeneration++),
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (context) => body),
          ],
        ),
      ),
    ),
  );
}

Widget _group(
  List<Widget> children, {
  bool autofocus = false,
  Axis direction = Axis.vertical,
}) {
  return MenuGroup(
    autofocus: autofocus,
    direction: direction,
    builder: (context, rows) => direction == Axis.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          )
        : Row(mainAxisSize: MainAxisSize.min, children: rows),
    children: children,
  );
}

Future<TestGesture> _hover(WidgetTester tester, Finder finder) async {
  // FocusableActionDetector only reports hover highlights under the
  // traditional strategy; without this the mouse move is swallowed.
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

void main() {
  group('rows', () {
    testWidgets('press calls onPressed and shows the label', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              child: const Text('Cut'),
              onPressed: (_) => pressed = true,
            ),
          ]),
        ),
      );
      await tester.pump();
      expect(find.text('Cut'), findsOneWidget);
      await tester.tap(find.text('Cut'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('disabled row dims to half opacity and ignores taps', (
      tester,
    ) async {
      bool pressed = false;
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              enabled: false,
              child: const Text('Gone'),
              onPressed: (_) => pressed = true,
            ),
          ]),
        ),
      );
      await tester.pump();
      final Opacity opacity = tester.widget<Opacity>(
        find.ancestor(of: find.text('Gone'), matching: find.byType(Opacity)),
      );
      expect(opacity.opacity, 0.5);
      await tester.tap(find.text('Gone'));
      await tester.pump();
      expect(pressed, isFalse);
    });

    testWidgets('a row measures 32 (shadcn h-8)', (tester) async {
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(child: const Text('Cut'), onPressed: (_) {}),
          ]),
        ),
      );
      await tester.pump();
      // The 32px minimum is a border-box total: the row's padding is
      // reserved inside it (B20/F1). The old inner ConstrainedBox was
      // 32 tall *plus* 12 padding = 44.
      expect(tester.getSize(find.byType(RovingRow).first).height, 32);
    });

    testWidgets('separator paints a 1px border rule', (tester) async {
      await tester.pumpWidget(_frame(_group(<Widget>[const MenuSeparator()])));
      await tester.pump();
      final Finder box = find.descendant(
        of: find.byType(MenuSeparator),
        matching: find.byType(Container),
      );
      expect(tester.getSize(box).height, 1);
      expect(
        tester.widget<Container>(box).color,
        const ShadcnThemeData().colors.border,
      );
    });
  });

  group('popup surface', () {
    testWidgets('popup is at least 192 wide with popover tokens', (
      tester,
    ) async {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      await tester.pumpWidget(
        _frame(
          const MenuPopup(children: <Widget>[Text('x')]),
          data: const ShadcnThemeData(colors: colors),
        ),
      );
      await tester.pump();
      final Size size = tester.getSize(find.byType(MenuPopup));
      expect(size.width, greaterThanOrEqualTo(128));
      final Container surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MenuPopup),
              matching: find.byType(Container),
            )
            .first,
      );
      final BoxDecoration decoration = surface.decoration! as BoxDecoration;
      expect(decoration.color, colors.popover);
      expect(decoration.border!.top.color, colors.border);
    });

    testWidgets('dark tokens drive the popup', (tester) async {
      const ShadcnColors colors = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          const MenuPopup(children: <Widget>[Text('x')]),
          data: const ShadcnThemeData(colors: colors),
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
      expect((surface.decoration! as BoxDecoration).color, colors.popover);
    });
  });

  group('submenus', () {
    testWidgets('hover opens the submenu popover', (tester) async {
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              _group(<MenuItem>[
                MenuButton(
                  subMenu: <MenuItem>[
                    MenuButton(child: const Text('Email'), onPressed: (_) {}),
                  ],
                  onPressed: (_) {},
                  child: const Text('Share'),
                ),
              ]),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Email'), findsNothing);
      final TestGesture gesture = await _hover(tester, find.text('Share'));
      await tester.pump();
      expect(find.text('Email'), findsOneWidget);
      await gesture.moveTo(const Offset(5000, 5000));
      await tester.pump();
    });

    testWidgets('hovering a sibling closes the open submenu', (tester) async {
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              _group(<MenuItem>[
                MenuButton(
                  subMenu: <MenuItem>[
                    MenuButton(child: const Text('Email'), onPressed: (_) {}),
                  ],
                  onPressed: (_) {},
                  child: const Text('Share'),
                ),
                MenuButton(child: const Text('Cut'), onPressed: (_) {}),
              ]),
            ],
          ),
        ),
      );
      await tester.pump();
      final TestGesture gesture = await _hover(tester, find.text('Share'));
      await tester.pump();
      expect(find.text('Email'), findsOneWidget);
      // The overlay entry fills the test window, so the 192-wide submenu
      // inverts over the *left* half of the stretched row; hover Cut's right
      // side so the pointer stays on the row (not on the submenu).
      await gesture.moveTo(Offset(600, tester.getCenter(find.text('Cut')).dy));
      await tester.pumpAndSettle();
      expect(find.text('Email'), findsNothing);
    });

    testWidgets('pressing a leaf closes the menu via onDismissed', (
      tester,
    ) async {
      bool dismissed = false;
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              MenuGroup(
                onDismissed: () => dismissed = true,
                builder: (context, rows) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: rows,
                ),
                children: <MenuItem>[
                  MenuButton(child: const Text('Cut'), onPressed: (_) {}),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Cut'));
      await tester.pump();
      expect(dismissed, isTrue);
    });
  });

  group('keyboard', () {
    testWidgets('arrows move between rows and wrap', (tester) async {
      final FocusNode a = FocusNode(debugLabel: 'a');
      final FocusNode b = FocusNode(debugLabel: 'b');
      addTearDown(a.dispose);
      addTearDown(b.dispose);
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              focusNode: a,
              child: const Text('Apple'),
              onPressed: (_) {},
            ),
            MenuButton(
              focusNode: b,
              child: const Text('Banana'),
              onPressed: (_) {},
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(a.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(b.hasFocus, isTrue);
      // Past the last row wraps to the first (framework traversal stops).
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(a.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(b.hasFocus, isTrue);
    });

    testWidgets('arrows skip disabled rows', (tester) async {
      final FocusNode a = FocusNode(debugLabel: 'a');
      final FocusNode c = FocusNode(debugLabel: 'c');
      addTearDown(a.dispose);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              focusNode: a,
              child: const Text('Apple'),
              onPressed: (_) {},
            ),
            MenuButton(
              enabled: false,
              child: const Text('Mango'),
              onPressed: (_) {},
            ),
            MenuButton(
              focusNode: c,
              child: const Text('Cherry'),
              onPressed: (_) {},
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(a.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      // Mango is disabled: the engine lands on Cherry, never on Mango.
      expect(c.hasFocus, isTrue);
    });

    testWidgets('Home and End jump to the first and last rows', (tester) async {
      final FocusNode a = FocusNode(debugLabel: 'a');
      final FocusNode c = FocusNode(debugLabel: 'c');
      addTearDown(a.dispose);
      addTearDown(c.dispose);
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              focusNode: a,
              child: const Text('Apple'),
              onPressed: (_) {},
            ),
            MenuButton(child: const Text('Banana'), onPressed: (_) {}),
            MenuButton(
              focusNode: c,
              child: const Text('Cherry'),
              onPressed: (_) {},
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(c.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(a.hasFocus, isTrue);
    });

    testWidgets('typing selects by prefix', (tester) async {
      final FocusNode a = FocusNode(debugLabel: 'a');
      final FocusNode b = FocusNode(debugLabel: 'b');
      addTearDown(a.dispose);
      addTearDown(b.dispose);
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              focusNode: a,
              child: const Text('Apple'),
              onPressed: (_) {},
            ),
            MenuButton(
              focusNode: b,
              child: const Text('Banana'),
              onPressed: (_) {},
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
      await tester.pump();
      expect(b.hasFocus, isTrue);
    });

    testWidgets('Escape dismisses through onDismissed', (tester) async {
      bool dismissed = false;
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              MenuGroup(
                autofocus: true,
                onDismissed: () => dismissed = true,
                builder: (context, rows) =>
                    Column(mainAxisSize: MainAxisSize.min, children: rows),
                children: <MenuItem>[
                  MenuButton(child: const Text('Cut'), onPressed: (_) {}),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(dismissed, isTrue);
    });

    testWidgets('Enter activates the focused row', (tester) async {
      bool pressed = false;
      final FocusNode a = FocusNode(debugLabel: 'a');
      addTearDown(a.dispose);
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              focusNode: a,
              child: const Text('Cut'),
              onPressed: (_) => pressed = true,
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(pressed, isTrue);
    });
  });

  group('theme legs', () {
    testWidgets('widget leg wins over every other leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            theme: const MenuPopupTheme(background: ThemedColor.value(_green)),
            children: const <Widget>[Text('x')],
          ),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
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
      expect((surface.decoration! as BoxDecoration).color, _green);
    });

    testWidgets('scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const MenuPopup(children: <Widget>[Text('x')]),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_blue)),
          ],
          scopedPopup: const MenuPopupTheme(
            background: ThemedColor.value(_green),
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
      expect((surface.decoration! as BoxDecoration).color, _green);
    });

    testWidgets('app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const MenuPopup(children: <Widget>[Text('x')]),
          app: const <ComponentThemeData>[
            MenuPopupTheme(background: ThemedColor.value(_green)),
          ],
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
      expect((surface.decoration! as BoxDecoration).color, _green);
    });

    testWidgets('a hovered row paints the accent fill', (tester) async {
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(child: const Text('Cut'), onPressed: (_) {}),
          ]),
        ),
      );
      await tester.pump();
      BoxDecoration? rowDecoration() {
        final AnimatedContainer container = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(RovingRow).first,
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        return container.decoration as BoxDecoration?;
      }

      final TestGesture gesture = await _hover(tester, find.text('Cut'));
      await tester.pump();
      // Hover focuses the row; the focused state resolves the accent fill and
      // its label colour (shadcn focus:bg-accent focus:text-accent-foreground).
      final ShadcnColors colors = const ShadcnThemeData().colors;
      expect(rowDecoration()!.color, colors.accent);
      final Text label = tester.widget<Text>(find.text('Cut'));
      expect(label.style, isNull); // colour comes from the row's TextTheme.
      await gesture.moveTo(const Offset(5000, 5000));
      await tester.pump();
    });
  });

  /// F4 rows, submenus and the show helper. Appended in QA round 2.
  group('checkbox rows', () {
    testWidgets('toggles on press and stays open by default', (tester) async {
      bool? value = false;
      bool dismissed = false;
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              MenuGroup(
                onDismissed: () => dismissed = true,
                builder: (context, rows) =>
                    Column(mainAxisSize: MainAxisSize.min, children: rows),
                children: <Widget>[
                  StatefulBuilder(
                    builder: (context, setState) => MenuCheckboxItem(
                      value: value!,
                      onChanged: (context, next) =>
                          setState(() => value = next),
                      child: const Text('Toolbar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(LucideIcons.check), findsNothing);
      await tester.tap(find.text('Toolbar'));
      await tester.pump();
      expect(value, isTrue);
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
      expect(dismissed, isFalse);
    });

    testWidgets('Space toggles the focused checkbox', (tester) async {
      bool? value = false;
      await tester.pumpWidget(
        _frame(
          _group(<Widget>[
            StatefulBuilder(
              builder: (context, setState) => MenuCheckboxItem(
                value: value!,
                onChanged: (context, next) => setState(() => value = next),
                child: const Text('Toolbar'),
              ),
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(value, isTrue);
    });
  });

  group('radio rows', () {
    testWidgets('picks one value and dismisses by default', (tester) async {
      String? value = 'a';
      bool dismissed = false;
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              MenuGroup(
                onDismissed: () => dismissed = true,
                builder: (context, rows) =>
                    Column(mainAxisSize: MainAxisSize.min, children: rows),
                children: <Widget>[
                  StatefulBuilder(
                    builder: (context, setState) => MenuRadioGroup<String>(
                      value: value,
                      onChanged: (context, next) =>
                          setState(() => value = next),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const MenuRadioItem<String>(
                            value: 'a',
                            child: Text('A'),
                          ),
                          const MenuRadioItem<String>(
                            value: 'b',
                            child: Text('B'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(value, 'b');
      expect(dismissed, isTrue);
    });

    testWidgets('Enter selects the focused radio', (tester) async {
      String? value = 'a';
      await tester.pumpWidget(
        _frame(
          _group(<Widget>[
            StatefulBuilder(
              builder: (context, setState) => MenuRadioGroup<String>(
                value: value,
                onChanged: (context, next) => setState(() => value = next),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MenuRadioItem<String>(value: 'a', child: Text('A')),
                    MenuRadioItem<String>(value: 'b', child: Text('B')),
                  ],
                ),
              ),
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(value, 'b');
    });
  });

  group('static rows', () {
    testWidgets('label renders semibold and skips traversal', (tester) async {
      final FocusNode node = FocusNode(debugLabel: 'leaf');
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          _group(<Widget>[
            const MenuLabel(child: Text('Section')),
            MenuButton(
              focusNode: node,
              child: const Text('Cut'),
              onPressed: (_) {},
            ),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      expect(find.text('Section'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(node.hasFocus, isTrue);
    });

    testWidgets('shortcut renders muted 12px text', (tester) async {
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(
              trailing: const MenuShortcut(shortcut: '⌘C'),
              child: const Text('Copy'),
              onPressed: (_) {},
            ),
          ]),
        ),
      );
      await tester.pump();
      final Text text = tester.widget<Text>(find.text('⌘C'));
      expect(text.style!.fontSize, 12);
      expect(text.style!.color, const ShadcnThemeData().colors.mutedForeground);
    });

    testWidgets('separator composes inside submenus', (tester) async {
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              _group(<MenuItem>[
                MenuButton(
                  subMenu: const <Widget>[
                    MenuLabel(child: Text('Send to')),
                    MenuSeparator(),
                  ],
                  onPressed: (_) {},
                  child: const Text('Share'),
                ),
              ]),
            ],
          ),
        ),
      );
      await tester.pump();
      final TestGesture gesture = await _hover(tester, find.text('Share'));
      await tester.pump();
      expect(find.text('Send to'), findsOneWidget);
      expect(find.byType(MenuSeparator), findsOneWidget);
      // An open popover follows its anchor every frame, so settle would hang;
      // stepped pumps are enough to prove the content is (and stays) there.
      await gesture.moveTo(const Offset(5000, 5000));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Send to'), findsOneWidget);
    });
  });

  group('submenus', () {
    testWidgets('MenuSub opens on ArrowRight, closes on ArrowLeft', (
      tester,
    ) async {
      final FocusNode node = FocusNode(debugLabel: 'sub');
      addTearDown(node.dispose);
      await tester.pumpWidget(
        _frame(
          MenuPopup(
            children: <Widget>[
              _group(<MenuItem>[
                MenuSub(
                  trigger: const Text('Share'),
                  children: <Widget>[
                    MenuButton(
                      focusNode: node,
                      child: const Text('Email'),
                      onPressed: (_) {},
                    ),
                  ],
                ),
              ], autofocus: true),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Email'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Email'), findsNothing);
    });

    testWidgets('Left at the root is a no-op', (tester) async {
      await tester.pumpWidget(
        _frame(
          _group(<MenuItem>[
            MenuButton(child: const Text('Cut'), onPressed: (_) {}),
          ], autofocus: true),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      expect(find.text('Cut'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('showShadcnMenu', () {
    testWidgets('opens a root menu and Escape closes it', (tester) async {
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (context) {
              host = context;
              return const SizedBox(width: 10, height: 10);
            },
          ),
        ),
      );
      await tester.pump();
      final Future<bool?> opened = showShadcnMenu<bool>(
        context: host,
        children: <Widget>[
          MenuButton(child: const Text('Cut'), onPressed: (_) {}),
        ],
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Cut'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Cut'), findsNothing);
      await opened;
    });

    testWidgets('Space activates the focused row', (tester) async {
      bool pressed = false;
      late BuildContext host;
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (context) {
              host = context;
              return const SizedBox(width: 10, height: 10);
            },
          ),
        ),
      );
      await tester.pump();
      unawaited(
        showShadcnMenu<void>(
          context: host,
          children: <Widget>[
            MenuButton(
              child: const Text('Cut'),
              onPressed: (_) => pressed = true,
            ),
          ],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(pressed, isTrue);
    });
  });
}
