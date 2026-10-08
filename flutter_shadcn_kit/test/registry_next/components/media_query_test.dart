// Widget tests for the `media_query` component.
//
// Covers both bounds, the inclusive edges, the collapsed alternate, all four
// theme legs and the two regressions from the old module: the app/defaults
// legs did not exist, and `MediaQueryVisibilityTheme.copyWith` dropped the
// density/spacing/shadow fields.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/media_query/media_query.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  double width = 500,
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  MediaQueryVisibilityTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<MediaQueryVisibilityTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Align(alignment: Alignment.topLeft, child: body),
        ),
      ),
    ),
  );
}

Widget _switch({
  double? minWidth,
  double? maxWidth,
  MediaQueryVisibilityTheme? theme,
}) => MediaQueryVisibility(
  minWidth: minWidth,
  maxWidth: maxWidth,
  theme: theme,
  alternateChild: const Text('alternate'),
  child: const Text('child'),
);

void main() {
  group('bounds', () {
    testWidgets('shows the child when the width is inside the range', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(_switch(minWidth: 400, maxWidth: 800)));
      expect(find.text('child'), findsOneWidget);
      expect(find.text('alternate'), findsNothing);
    });

    testWidgets('shows the alternate below minWidth', (tester) async {
      await tester.pumpWidget(_frame(_switch(minWidth: 600), width: 500));
      expect(find.text('alternate'), findsOneWidget);
    });

    testWidgets('shows the alternate above maxWidth', (tester) async {
      await tester.pumpWidget(_frame(_switch(maxWidth: 400), width: 500));
      expect(find.text('alternate'), findsOneWidget);
    });

    testWidgets('both bounds are inclusive', (tester) async {
      await tester.pumpWidget(
        _frame(_switch(minWidth: 500, maxWidth: 500), width: 500),
      );
      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('no bounds always shows the child', (tester) async {
      await tester.pumpWidget(_frame(_switch(), width: 99999));
      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('a missing alternate collapses the box', (tester) async {
      await tester.pumpWidget(
        _frame(
          const MediaQueryVisibility(minWidth: 600, child: Text('child')),
          width: 500,
        ),
      );
      expect(find.text('child'), findsNothing);
      expect(tester.getSize(find.byType(MediaQueryVisibility)), Size.zero);
    });
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _switch(theme: const MediaQueryVisibilityTheme(minWidth: 100)),
          scoped: const MediaQueryVisibilityTheme(minWidth: 900),
        ),
      );
      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _switch(),
          app: const <ComponentThemeData>[
            MediaQueryVisibilityTheme(minWidth: 900),
          ],
          scoped: const MediaQueryVisibilityTheme(minWidth: 100),
        ),
      );
      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('the app leg wins over the (empty) defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          _switch(),
          app: const <ComponentThemeData>[
            MediaQueryVisibilityTheme(minWidth: 900),
          ],
        ),
      );
      expect(find.text('alternate'), findsOneWidget);
    });

    testWidgets('a leg that sets only minWidth keeps the lower maxWidth', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          _switch(),
          width: 700,
          app: const <ComponentThemeData>[
            MediaQueryVisibilityTheme(maxWidth: 600),
          ],
          scoped: const MediaQueryVisibilityTheme(minWidth: 100),
        ),
      );
      // 700 is above the app leg's maxWidth and above the scoped minWidth.
      expect(find.text('alternate'), findsOneWidget);
    });
  });

  group('regressions', () {
    testWidgets('regression: bounds merge per field across legs', (
      tester,
    ) async {
      // The old widget resolved one theme leg only, so an app-wide maxWidth
      // could not combine with a per-widget minWidth.
      Widget build(double width) => _frame(
        _switch(minWidth: 400),
        width: width,
        app: const <ComponentThemeData>[
          MediaQueryVisibilityTheme(maxWidth: 450),
        ],
      );
      await tester.pumpWidget(build(420));
      expect(find.text('child'), findsOneWidget);
      await tester.pumpWidget(build(500));
      expect(find.text('alternate'), findsOneWidget);
    });

    testWidgets('regression: copyWith keeps the ComponentThemeData slots', (
      tester,
    ) async {
      const MediaQueryVisibilityTheme base = MediaQueryVisibilityTheme(
        minWidth: 100,
        maxWidth: 900,
      );
      final MediaQueryVisibilityTheme copy = base.copyWith(minWidth: () => 200);
      expect(copy.minWidth, 200);
      expect(copy.maxWidth, 900);
      expect(copy.themeDensity, base.themeDensity);
      expect(copy.themeSpacing, base.themeSpacing);
      expect(copy.themeShadows, base.themeShadows);
    });

    testWidgets('regression: merge keeps the fallback maxWidth', (
      tester,
    ) async {
      final MediaQueryVisibilityTheme merged = const MediaQueryVisibilityTheme(
        minWidth: 200,
      ).merge(const MediaQueryVisibilityTheme(minWidth: 100, maxWidth: 900));
      expect(merged.minWidth, 200);
      expect(merged.maxWidth, 900);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens build the component', (tester) async {
        await tester.pumpWidget(
          ShadcnTheme(
            data: ShadcnThemeData(colors: colors),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: const MediaQueryData(size: Size(500, 800)),
                child: _switch(minWidth: 600),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('alternate'), findsOneWidget);
      });
    }
  });
}
