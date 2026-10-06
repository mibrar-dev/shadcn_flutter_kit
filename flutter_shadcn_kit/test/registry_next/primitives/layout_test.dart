import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/basic_layout.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/hidden.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/label.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/layout.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(data: const ShadcnThemeData(), child: child),
  );
}

void main() {
  testWidgets('Basic lays out leading/title/subtitle/trailing', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: Basic(
            leading: const SizedBox(width: 10, height: 10, child: Text('L')),
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
            trailing: const Text('T'),
          ),
        ),
      ),
    );

    expect(find.text('L'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);

    final leadingLeft = tester.getTopLeft(find.text('L')).dx;
    final titleLeft = tester.getTopLeft(find.text('Title')).dx;
    final trailingLeft = tester.getTopLeft(find.text('T')).dx;
    expect(titleLeft, greaterThan(leadingLeft));
    expect(trailingLeft, greaterThan(titleLeft));
  });

  testWidgets('BasicTheme.contentSpacing overrides the default gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        ComponentTheme<BasicTheme>(
          data: const BasicTheme(contentSpacing: 40),
          child: Center(
            child: Basic(
              leading: const SizedBox(width: 10, height: 10, child: Text('L')),
              title: const Text('Title'),
            ),
          ),
        ),
      ),
    );

    final gap = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 40,
    );
    expect(gap, findsWidgets);
  });

  testWidgets('BasicLayout applies constraints and skips text styling', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: BasicLayout(
            constraints: const BoxConstraints(maxWidth: 120),
            leading: const SizedBox(width: 10, height: 10),
            title: const Text('Constrained'),
            content: const Text('Body'),
          ),
        ),
      ),
    );

    expect(find.text('Constrained'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(
      tester.getSize(find.byType(BasicLayout)).width,
      lessThanOrEqualTo(120),
    );
  });

  testWidgets('Label lays out leading, child and trailing', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: Label(
            leading: const Text('L'),
            trailing: const Text('T'),
            child: const Text('Center'),
          ),
        ),
      ),
    );

    expect(find.text('L'), findsOneWidget);
    expect(find.text('Center'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('L')).dx,
      lessThan(tester.getTopLeft(find.text('Center')).dx),
    );
    expect(
      tester.getTopLeft(find.text('T')).dx,
      greaterThan(tester.getTopLeft(find.text('Center')).dx),
    );
  });

  testWidgets('Hidden collapses the main axis when hidden', (tester) async {
    Widget build({required bool hidden, bool keepMainAxisSize = false}) {
      return _wrap(
        Center(
          child: Hidden(
            hidden: hidden,
            duration: const Duration(milliseconds: 50),
            keepMainAxisSize: keepMainAxisSize,
            child: const SizedBox(
              key: ValueKey('child'),
              width: 100,
              height: 20,
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(build(hidden: false));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 100);

    await tester.pumpWidget(build(hidden: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 0);

    await tester.pumpWidget(build(hidden: true, keepMainAxisSize: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 100);
  });

  testWidgets('HiddenTheme supplies the collapse direction', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ComponentTheme<HiddenTheme>(
          data: const HiddenTheme(direction: Axis.vertical),
          child: Center(
            child: Hidden(
              hidden: true,
              duration: const Duration(milliseconds: 50),
              child: const SizedBox(width: 100, height: 20),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 0);
    expect(tester.getSize(find.byType(Hidden)).height, 0);
  });
}
