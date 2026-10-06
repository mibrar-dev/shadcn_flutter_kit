import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

class _BoxTheme extends ComponentThemeData {
  const _BoxTheme({this.tag});
  final String? tag;
}

_BoxTheme? _capturedScoped;
_BoxTheme? _capturedApp;

Widget _probe(BuildContext context) {
  _capturedScoped = ComponentTheme.maybeOf<_BoxTheme>(context);
  _capturedApp = ComponentThemes.maybeOf<_BoxTheme>(context);
  return const SizedBox();
}

void main() {
  testWidgets('maybeOf is tree-only and never reads ComponentThemes', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ShadcnTheme(
        data: ShadcnThemeData(),
        child: ComponentThemes(
          themes: [_BoxTheme(tag: 'app')],
          child: Builder(builder: _probe),
        ),
      ),
    );
    // The app leg holds a value, but tree lookup stays null.
    expect(_capturedScoped, isNull);
    expect(_capturedApp?.tag, 'app');

    // With a tree ancestor, the ancestor (not the app value) is returned.
    await tester.pumpWidget(
      ShadcnTheme(
        key: UniqueKey(),
        data: const ShadcnThemeData(),
        child: const ComponentThemes(
          themes: [_BoxTheme(tag: 'app')],
          child: ComponentTheme<_BoxTheme>(
            data: _BoxTheme(tag: 'scoped'),
            child: Builder(builder: _probe),
          ),
        ),
      ),
    );
    expect(_capturedScoped?.tag, 'scoped');
    expect(_capturedApp?.tag, 'app');
  });
}
