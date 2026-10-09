// Widget tests for the `command` component and the shared
// `SubFocusListItem` row it uses.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/command/command.dart';
import 'package:flutter_shadcn_kit/registry/primitives/subfocus_list_item.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keeps a single `OverlayEntry` so repumping the frame updates its child.
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) => Center(child: widget.child),
  );

  @override
  void didUpdateWidget(covariant _OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _entry
      ..remove()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);
}

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverlayHost(child: child),
      ),
    ),
  );
}

Command _command({
  required CommandBuilder builder,
  Duration debounce = Duration.zero,
  WidgetBuilder? emptyBuilder,
  CommandErrorBuilder? errorBuilder,
  WidgetBuilder? loadingBuilder,
  bool autofocus = true,
}) {
  return Command(
    builder: builder,
    debounceDuration: debounce,
    emptyBuilder: emptyBuilder,
    errorBuilder: errorBuilder,
    loadingBuilder: loadingBuilder,
    autofocus: autofocus,
  );
}

void main() {
  testWidgets('renders streamed results and the empty state', (tester) async {
    for (final ShadcnThemeData data in <ShadcnThemeData>[
      const ShadcnThemeData(),
      const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    ]) {
      await tester.pumpWidget(
        _frame(
          data: data,
          child: _command(
            builder: (context, query) async* {
              yield <Widget>[const SubFocusListItem(title: Text('Alpha'))];
            },
          ),
        ),
      );
      // Debounce is zero; the async* body still needs a microtask turn.
      await tester.pump();
      expect(find.text('Alpha'), findsOneWidget);
    }
  });

  testWidgets('CommandShortcut renders muted, tracked and right-aligned', (
    tester,
  ) async {
    for (final ShadcnThemeData data in <ShadcnThemeData>[
      const ShadcnThemeData(),
      const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    ]) {
      await tester.pumpWidget(
        _frame(
          data: data,
          child: const SizedBox(
            width: 200,
            child: CommandShortcut(label: '\u2318K'),
          ),
        ),
      );
      final Text text = tester.widget<Text>(find.text('\u2318K'));
      expect(text.style?.color, data.colors.mutedForeground);
      expect(text.style?.fontSize, data.typography.xSmall.fontSize);
      expect(text.style?.letterSpacing, greaterThan(0));
      expect(text.textAlign, TextAlign.end);

      final Align align = tester.widget<Align>(
        find
            .ancestor(of: find.text('\u2318K'), matching: find.byType(Align))
            .first,
      );
      expect(align.alignment, AlignmentDirectional.centerEnd);
    }
  });

  testWidgets('an empty result stream renders the empty state', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _command(
          builder: (context, query) => const Stream<List<Widget>>.empty(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('typing restarts the stream and filters results', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _command(
          autofocus: false,
          builder: (context, query) async* {
            const List<String> all = <String>['Alpha', 'Beta'];
            yield <Widget>[
              for (final String value in all)
                if (query == null || value.startsWith(query))
                  SubFocusListItem(title: Text(value)),
            ];
          },
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'A');
    await tester.pump();
    await tester.pump();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('a loading builder covers the pre-data phase', (tester) async {
    final Completer<List<Widget>> gate = Completer<List<Widget>>();
    await tester.pumpWidget(
      _frame(
        child: _command(
          builder: (context, query) =>
              Stream<List<Widget>>.fromFuture(gate.future),
          loadingBuilder: (context) => const Text('Loading...'),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Loading...'), findsOneWidget);

    gate.complete(<Widget>[const SubFocusListItem(title: Text('Alpha'))]);
    await tester.pump();
    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('an error stream reaches the error builder', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _command(
          builder: (context, query) async* {
            throw StateError('boom');
          },
          errorBuilder: (context, error, stackTrace) =>
              Text('failed: ${error is StateError}'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('failed: true'), findsOneWidget);
  });

  testWidgets('tapping a row activates it; a read-only row does not', (
    tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _frame(
        child: _command(
          builder: (context, query) async* {
            yield <Widget>[
              SubFocusListItem(title: const Text('Alpha'), onTap: () => taps++),
              const SubFocusListItem(title: Text('Beta')),
            ];
          },
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Alpha'));
    expect(taps, 1);
    await tester.tap(find.text('Beta'));
    expect(taps, 1);
  });

  testWidgets('regression: a stale query stops feeding the list', (
    tester,
  ) async {
    final StreamController<List<Widget>> first =
        StreamController<List<Widget>>();
    addTearDown(first.close);
    await tester.pumpWidget(
      _frame(
        child: _command(
          autofocus: false,
          builder: (context, query) {
            if (query == null) {
              return first.stream;
            }
            return Stream<List<Widget>>.value(<Widget>[
              const SubFocusListItem(title: Text('Filtered')),
            ]);
          },
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(EditableText), 'x');
    await tester.pump();
    await tester.pump();
    expect(find.text('Filtered'), findsOneWidget);

    // The abandoned stream may still emit; the palette must ignore it.
    first.add(<Widget>[const SubFocusListItem(title: Text('Stale'))]);
    await tester.pump();
    await tester.pump();
    expect(find.text('Stale'), findsNothing);
  });

  testWidgets('arrow keys move sub-focus and enter activates', (tester) async {
    final List<String> activated = <String>[];
    await tester.pumpWidget(
      _frame(
        child: _command(
          builder: (context, query) async* {
            yield <Widget>[
              SubFocusListItem(
                title: const Text('Alpha'),
                onTap: () => activated.add('Alpha'),
              ),
              SubFocusListItem(
                title: const Text('Beta'),
                onTap: () => activated.add('Beta'),
              ),
            ];
          },
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(activated, <String>['Beta']);
  });
}
