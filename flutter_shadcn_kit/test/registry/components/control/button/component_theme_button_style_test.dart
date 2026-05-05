import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_shadcn_kit/registry/components/control/button/_impl/styles/abstract_button_style.dart';
import 'package:flutter_shadcn_kit/registry/components/control/button/_impl/styles/component_theme_button_style.dart';
import 'package:flutter_shadcn_kit/registry/components/control/button/_impl/utils/button_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menu button style resolves token-backed global padding', (
    tester,
  ) async {
    late BuildContext context;
    const fallbackPadding = EdgeInsets.all(99);
    const style = ComponentThemeButtonStyle<MenuButtonTheme>(
      fallback: _FallbackButtonStyle(paddingValue: fallbackPadding),
    );

    await tester.pumpWidget(
      ShadcnApp(
        home: Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final resolvedPadding = style.padding(context, <WidgetState>{});
    final expectedPadding = buttonMenuPadding(context, <WidgetState>{});

    expect(resolvedPadding, expectedPadding);
    expect(resolvedPadding, isNot(fallbackPadding));
  });
}

class _FallbackButtonStyle implements AbstractButtonStyle {
  const _FallbackButtonStyle({required this.paddingValue});

  final EdgeInsetsGeometry paddingValue;

  @override
  ButtonStateProperty<Decoration> get decoration =>
      (_, __) => const BoxDecoration();

  @override
  ButtonStateProperty<IconThemeData> get iconTheme =>
      (_, __) => const IconThemeData();

  @override
  ButtonStateProperty<EdgeInsetsGeometry> get margin =>
      (_, __) => EdgeInsets.zero;

  @override
  ButtonStateProperty<MouseCursor> get mouseCursor =>
      (_, __) => SystemMouseCursors.basic;

  @override
  ButtonStateProperty<EdgeInsetsGeometry> get padding =>
      (_, __) => paddingValue;

  @override
  ButtonStateProperty<TextStyle> get textStyle =>
      (_, __) => const TextStyle();
}
