// Widget and unit tests for the `icon` component.
//
// Covers: every surviving icon modifier, the muted-colour precedence fix,
// the icon container tokens and the four theme legs. The component has no
// interaction states of its own (it only wraps other widgets).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/icon/icon.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

/// Captures the effective [IconThemeData] below the modifier that wraps it.
class _IconThemeProbe extends StatelessWidget {
  const _IconThemeProbe();

  @override
  Widget build(BuildContext context) {
    final data = IconTheme.of(context);
    return SizedBox(
      width: data.size,
      height: data.size,
      child: ColoredBox(color: data.color ?? const Color(0x00000000)),
    );
  }
}

IconThemeData _effectiveIconTheme(WidgetTester tester) {
  final box = tester.widget<ColoredBox>(
    find
        .descendant(
          of: find.byType(_IconThemeProbe),
          matching: find.byType(ColoredBox),
        )
        .first,
  );
  final sized = tester.widget<SizedBox>(
    find
        .descendant(
          of: find.byType(_IconThemeProbe),
          matching: find.byType(SizedBox),
        )
        .first,
  );
  return IconThemeData(size: sized.width, color: box.color);
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('size modifiers read the ambient icon scale', (tester) async {
    Future<void> pump(Widget Function(Widget probe) modify) async {
      await tester.pumpWidget(_frame(child: modify(const _IconThemeProbe())));
    }

    await pump((probe) => probe.iconX3Small());
    expect(_effectiveIconTheme(tester).size, 8);
    await pump((probe) => probe.iconXSmall());
    expect(_effectiveIconTheme(tester).size, 12);
    await pump((probe) => probe.iconSmall());
    expect(_effectiveIconTheme(tester).size, 16);
    await pump((probe) => probe.iconMedium());
    expect(_effectiveIconTheme(tester).size, 20);
    await pump((probe) => probe.iconLarge());
    expect(_effectiveIconTheme(tester).size, 24);
  });

  testWidgets('iconMutedForeground applies the token', (tester) async {
    await tester.pumpWidget(
      _frame(child: const _IconThemeProbe().iconMutedForeground()),
    );
    expect(_effectiveIconTheme(tester).color, colors.mutedForeground);
  });

  testWidgets('muted colour wins over an ambient icon colour (regression)', (
    tester,
  ) async {
    // The old helper merged the resolved data under the ambient one, so an
    // ancestor IconTheme colour silently swallowed the muted colour.
    await tester.pumpWidget(
      _frame(
        child: IconTheme(
          data: const IconThemeData(color: _green),
          child: const _IconThemeProbe().iconMutedForeground(),
        ),
      ),
    );
    expect(_effectiveIconTheme(tester).color, colors.mutedForeground);
  });

  testWidgets('modifiers chain (size and colour)', (tester) async {
    await tester.pumpWidget(
      _frame(child: const _IconThemeProbe().iconSmall().iconMutedForeground()),
    );
    final data = _effectiveIconTheme(tester);
    expect(data.size, 16);
    expect(data.color, colors.mutedForeground);
  });

  testWidgets('dark tokens drive the muted colour', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(data: dark, child: const _IconThemeProbe().iconMutedForeground()),
    );
    expect(_effectiveIconTheme(tester).color, dark.colors.mutedForeground);
  });

  testWidgets('icon container uses the primary surface tokens', (tester) async {
    await tester.pumpWidget(
      _frame(child: const IconContainer(icon: SizedBox(width: 16, height: 16))),
    );
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(IconContainer),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, colors.primary);
    expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusMd);
    final iconTheme = tester
        .widgetList<IconTheme>(
          find.descendant(
            of: find.byType(IconContainer),
            matching: find.byType(IconTheme),
          ),
        )
        .last;
    expect(iconTheme.data.color, colors.primaryForeground);
  });

  testWidgets('container theme precedence: app < scoped < widget', (
    tester,
  ) async {
    const red = IconContainerTheme(backgroundColor: ThemedColor.value(_red));
    const green = IconContainerTheme(
      backgroundColor: ThemedColor.value(_green),
    );
    const blue = IconContainerTheme(backgroundColor: ThemedColor.value(_blue));

    Color surface() {
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(IconContainer),
              matching: find.byType(Container),
            )
            .first,
      );
      return (container.decoration! as BoxDecoration).color!;
    }

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const IconContainer(icon: SizedBox()),
      ),
    );
    expect(surface(), _red);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<IconContainerTheme>(
          data: green,
          child: IconContainer(icon: SizedBox()),
        ),
      ),
    );
    expect(surface(), _green);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<IconContainerTheme>(
          data: green,
          child: IconContainer(icon: SizedBox(), theme: blue),
        ),
      ),
    );
    expect(surface(), _blue);
  });

  testWidgets('container partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          IconContainerTheme(backgroundColor: ThemedColor.value(_red)),
        ],
        child: const ComponentTheme<IconContainerTheme>(
          data: IconContainerTheme(iconColor: ThemedColor.value(_green)),
          child: IconContainer(
            icon: SizedBox(),
            theme: IconContainerTheme(padding: EdgeInsets.all(4)),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(IconContainer),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((container.decoration! as BoxDecoration).color, _red);
    expect(container.padding, const EdgeInsets.all(4));
    final iconTheme = tester
        .widgetList<IconTheme>(
          find.descendant(
            of: find.byType(IconContainer),
            matching: find.byType(IconTheme),
          ),
        )
        .last;
    expect(iconTheme.data.color, _green);
  });

  testWidgets('container widget arguments beat the theme', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          IconContainerTheme(backgroundColor: ThemedColor.value(_red)),
        ],
        child: const IconContainer(icon: SizedBox(), backgroundColor: _blue),
      ),
    );
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(IconContainer),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((container.decoration! as BoxDecoration).color, _blue);
  });
}
