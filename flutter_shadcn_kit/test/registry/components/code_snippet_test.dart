// Widget tests for the `code_snippet` component.
//
// Covers rendering, actions, constraints, the four theme-precedence legs
// and dark tokens. Regression tests cover the retired pieces: the widget
// is stateless (no stale state across rebuilds) and the actions row uses
// the foundation gap.
//
// `_frame` supplies an `Overlay`: the code text renders inside a
// `SelectableRegion` (so it can be selected and copied), and a region
// asserts on that ancestor.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/code_snippet/code_snippet.dart';
import 'package:flutter_shadcn_kit/registry/foundation/gap.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CodeSnippetTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<CodeSnippetTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverlayHost(builder: (_) => Center(child: body)),
      ),
    ),
  );
}

/// Hosts [builder] in a stable overlay entry, so the entry keeps tracking the
/// latest child across pumps (`Overlay`'s `initialEntries` only applies once,
/// which would freeze the subtree on the first pump).
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  // `Builder` re-reads `widget.builder` per build, so the entry tracks the
  // latest child instead of the one captured on the first pump.
  late final OverlayEntry _entry = OverlayEntry(
    builder: (BuildContext context) => Builder(builder: widget.builder),
  );

  @override
  Widget build(BuildContext context) =>
      Overlay(initialEntries: <OverlayEntry>[_entry]);
}

void main() {
  group('rendering', () {
    testWidgets('shows the code content', (tester) async {
      await tester.pumpWidget(
        _frame(child: const CodeSnippet(code: Text('hello()'))),
      );
      expect(find.text('hello()'), findsOneWidget);
    });

    testWidgets('actions render in the corner row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const CodeSnippet(
            actions: <Widget>[Text('Copy'), Text('Run')],
            code: Text('cmd'),
          ),
        ),
      );
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Run'), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('no actions row without actions', (tester) async {
      await tester.pumpWidget(
        _frame(child: const CodeSnippet(code: Text('cmd'))),
      );
      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('card surface uses the card token', (tester) async {
      await tester.pumpWidget(
        _frame(child: const CodeSnippet(code: Text('cmd'))),
      );
      final Container box = tester.widget<Container>(
        find.byType(Container).first,
      );
      final BoxDecoration decoration = box.decoration! as BoxDecoration;
      expect(decoration.color, ShadcnColors.lightFallback.card);
      expect(decoration.border!.top.color, ShadcnColors.lightFallback.border);
    });

    testWidgets('default padding leaves room on the right', (tester) async {
      await tester.pumpWidget(
        _frame(child: const CodeSnippet(code: Text('cmd'))),
      );
      final Iterable<SingleChildScrollView> scrollers = tester
          .widgetList<SingleChildScrollView>(
            find.byType(SingleChildScrollView),
          );
      final EdgeInsets padding = (scrollers.last.padding! as EdgeInsets)
          .resolve(TextDirection.ltr);
      expect(padding.left, 16);
      expect(padding.right, 56);
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      CodeSnippetTheme resolve(BuildContext context, CodeSnippetTheme? widget) {
        return resolveComponentStyle<CodeSnippetTheme, CodeSnippetTheme>(
          context,
          widget: widget,
          select: (t) => t,
          defaults: codeSnippetDefaults,
        );
      }

      CodeSnippetTheme? seen;
      Future<void> pump({
        CodeSnippetTheme? widget,
        CodeSnippetTheme? scoped,
        List<ComponentThemeData> app = const <ComponentThemeData>[],
      }) async {
        await tester.pumpWidget(
          _frame(
            app: app,
            scoped: scoped,
            child: Builder(
              builder: (context) {
                seen = resolve(context, widget);
                return const SizedBox();
              },
            ),
          ),
        );
      }

      await pump();
      expect(seen!.borderWidth, 1);
      await pump(
        app: const <ComponentThemeData>[CodeSnippetTheme(borderWidth: 2)],
      );
      expect(seen!.borderWidth, 2);
      await pump(
        scoped: const CodeSnippetTheme(borderWidth: 3),
        app: const <ComponentThemeData>[CodeSnippetTheme(borderWidth: 2)],
      );
      expect(seen!.borderWidth, 3);
      await pump(
        widget: const CodeSnippetTheme(borderWidth: 4),
        scoped: const CodeSnippetTheme(borderWidth: 3),
        app: const <ComponentThemeData>[CodeSnippetTheme(borderWidth: 2)],
      );
      expect(seen!.borderWidth, 4);
    });

    testWidgets('dark tokens restyle the surface', (tester) async {
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: const CodeSnippet(code: Text('cmd')),
        ),
      );
      final Container box = tester.widget<Container>(
        find.byType(Container).first,
      );
      final BoxDecoration decoration = box.decoration! as BoxDecoration;
      expect(decoration.color, ShadcnColors.darkFallback.card);
    });
  });

  group('regressions', () {
    testWidgets('rebuilds do not keep stale state', (tester) async {
      await tester.pumpWidget(
        _frame(child: const CodeSnippet(code: Text('one'))),
      );
      expect(find.text('one'), findsOneWidget);
      await tester.pumpWidget(
        _frame(child: const CodeSnippet(code: Text('two'))),
      );
      expect(find.text('two'), findsOneWidget);
      expect(find.text('one'), findsNothing);
    });

    testWidgets('actions are spaced with the foundation gap', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const CodeSnippet(
            actions: <Widget>[Text('A'), Text('B')],
            code: Text('cmd'),
          ),
        ),
      );
      expect(find.byType(Gap), findsOneWidget);
    });
  });
}
