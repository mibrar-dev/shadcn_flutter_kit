import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/subfocus.dart';
import 'package:flutter_shadcn_kit/registry/primitives/subfocus_item.dart';
import 'package:flutter_shadcn_kit/registry/primitives/subfocus_scope.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(data: const ShadcnThemeData(), child: child),
  );
}

void main() {
  testWidgets('FocusOutline animates a ring in and out', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: FocusOutline(
            focused: true,
            borderRadius: BorderRadius.circular(4),
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      ),
    );

    Container ring() => tester.widget<Container>(
      find.descendant(
        of: find.byType(FocusOutline),
        matching: find.byType(Container),
      ),
    );

    await tester.pump(const Duration(milliseconds: 250));
    final border = ((ring().decoration! as BoxDecoration).border as Border);
    expect(border.top.width, greaterThan(0));

    await tester.pumpWidget(
      _wrap(
        Center(
          child: FocusOutline(
            focused: false,
            borderRadius: BorderRadius.circular(4),
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 250));
    final faded = ((ring().decoration! as BoxDecoration).border as Border);
    expect(faded.top.width, 0);
  });

  testWidgets('FocusOutlineTheme.align controls the ring offset', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        ComponentTheme<FocusOutlineTheme>(
          data: const FocusOutlineTheme(align: 6),
          child: Center(
            child: FocusOutline(
              focused: true,
              child: const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 250));

    final positioned = tester.widget<Positioned>(
      find.descendant(
        of: find.byType(FocusOutline),
        matching: find.byType(Positioned),
      ),
    );
    expect(positioned.top, -6);
    expect(positioned.left, -6);
  });

  testWidgets('SubFocusScope moves focus between attached items', (
    tester,
  ) async {
    final scope = <SubFocusScopeState>[];
    final items = <int, SubFocusState>{};
    await tester.pumpWidget(
      _wrap(
        Center(
          child: SubFocusScope(
            builder: (context, state) {
              scope.add(state);
              return Actions(
                actions: <Type, Action<Intent>>{
                  _PingIntent: CallbackAction<_PingIntent>(
                    onInvoke: (intent) => 42,
                  ),
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 3; i++)
                      SubFocus(
                        key: ValueKey<int>(i),
                        builder: (context, item) {
                          items[i] = item;
                          return SizedBox(
                            width: 100,
                            height: 30,
                            child: Text('$i'),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    final state = scope.last;
    expect(items.length, 3);

    expect(state.requestFocus(items[1]!), isTrue);
    await tester.pump();
    expect(items[1]!.isFocused, isTrue);
    expect(items[0]!.isFocused, isFalse);

    expect(state.nextFocus(TraversalDirection.down), isTrue);
    await tester.pump();
    expect(items[2]!.isFocused, isTrue);

    expect(state.nextFocus(TraversalDirection.up), isTrue);
    await tester.pump();
    expect(items[1]!.isFocused, isTrue);

    expect(state.invokeActionOnFocused(const _PingIntent()), 42);
  });

  testWidgets('SubFocus honours enabled and tracks focusCount', (tester) async {
    final scope = <SubFocusScopeState>[];
    final items = <int, SubFocusState>{};
    await tester.pumpWidget(
      _wrap(
        Center(
          child: SubFocusScope(
            builder: (context, state) {
              scope.add(state);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 2; i++)
                    SubFocus(
                      enabled: i == 0,
                      builder: (context, item) {
                        items[i] = item;
                        return const SizedBox(width: 60, height: 20);
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(scope.last.requestFocus(items[0]!), isTrue);
    await tester.pump();
    expect(items[0]!.focusCount, 1);
    expect(items[0]!.isFocused, isTrue);

    // A disabled item can neither focus itself nor be made current by the
    // scope: both calls return false and the current item does not change.
    expect(items[1]!.requestFocus(), isFalse);
    await tester.pump();
    expect(items[1]!.isFocused, isFalse);
    expect(items[1]!.focusCount, 0);
    expect(items[0]!.isFocused, isTrue);

    expect(scope.last.requestFocus(items[1]!), isFalse);
    await tester.pump();
    expect(items[1]!.focusCount, 0);
    expect(items[0]!.isFocused, isTrue);
  });
}

class _PingIntent extends Intent {
  const _PingIntent();
}
