import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal component slice using the same shape components will use:
/// nullable [StateValue] fields merged per state with receiver-wins.
class _BoxStyle implements Mergeable<_BoxStyle> {
  const _BoxStyle({this.color});
  final StateValue<ThemedColor>? color;

  @override
  _BoxStyle merge(_BoxStyle? fallback) {
    if (fallback == null) return this;
    return _BoxStyle(color: color?.merge(fallback.color) ?? fallback.color);
  }
}

class _BoxTheme extends ComponentThemeData {
  const _BoxTheme({this.box});
  final _BoxStyle? box;
}

const _red = Color(0xFFFF0000);
const _green = Color(0xFF00FF00);
const _blue = Color(0xFF0000FF);
const _yellow = Color(0xFFFFFF00);

const _defaults = _BoxStyle(color: StateValue(rest: ThemedColor.value(_red)));

_BoxStyle _resolve(BuildContext context, {_BoxStyle? widget}) {
  return resolveComponentStyle<_BoxTheme, _BoxStyle>(
    context,
    widget: widget,
    select: (t) => t.box,
    defaults: _defaults,
  );
}

/// Wraps [child] in the ambient theme plus the app-leg widget carrying
/// [app] overrides (fresh key per pump so the probe always rebuilds).
Widget _frame({_BoxTheme? app, required Widget child}) {
  return ShadcnTheme(
    key: UniqueKey(),
    data: const ShadcnThemeData(),
    child: ComponentThemes(
      themes: app == null
          ? const <ComponentThemeData>[]
          : <ComponentThemeData>[app],
      child: child,
    ),
  );
}

void main() {
  testWidgets('every leg overrides the one below it', (tester) async {
    _BoxStyle? seen;
    Widget probe({_BoxStyle? widget}) => Builder(
      builder: (context) {
        seen = _resolve(context, widget: widget);
        return const SizedBox();
      },
    );

    // Defaults only.
    await tester.pumpWidget(_frame(child: probe()));
    expect(seen!.color!.resolve({})!.resolve(ShadcnColors.lightFallback), _red);

    // App leg overrides defaults.
    await tester.pumpWidget(
      _frame(
        app: const _BoxTheme(
          box: _BoxStyle(color: StateValue(rest: ThemedColor.value(_green))),
        ),
        child: probe(),
      ),
    );
    expect(
      seen!.color!.resolve({})!.resolve(ShadcnColors.lightFallback),
      _green,
    );

    // Scoped (tree) leg overrides app.
    await tester.pumpWidget(
      _frame(
        app: const _BoxTheme(
          box: _BoxStyle(color: StateValue(rest: ThemedColor.value(_green))),
        ),
        child: ComponentTheme<_BoxTheme>(
          data: const _BoxTheme(
            box: _BoxStyle(color: StateValue(rest: ThemedColor.value(_blue))),
          ),
          child: probe(),
        ),
      ),
    );
    expect(
      seen!.color!.resolve({})!.resolve(ShadcnColors.lightFallback),
      _blue,
    );

    // Widget leg overrides scoped.
    await tester.pumpWidget(
      _frame(
        app: const _BoxTheme(
          box: _BoxStyle(color: StateValue(rest: ThemedColor.value(_green))),
        ),
        child: ComponentTheme<_BoxTheme>(
          data: const _BoxTheme(
            box: _BoxStyle(color: StateValue(rest: ThemedColor.value(_blue))),
          ),
          child: probe(
            widget: const _BoxStyle(
              color: StateValue(rest: ThemedColor.value(_yellow)),
            ),
          ),
        ),
      ),
    );
    expect(
      seen!.color!.resolve({})!.resolve(ShadcnColors.lightFallback),
      _yellow,
    );
  });

  testWidgets('widget hovered does not wipe ancestor rest', (tester) async {
    _BoxStyle? seen;
    await tester.pumpWidget(
      _frame(
        app: const _BoxTheme(
          box: _BoxStyle(color: StateValue(rest: ThemedColor.value(_green))),
        ),
        child: Builder(
          builder: (context) {
            seen = _resolve(
              context,
              widget: const _BoxStyle(
                color: StateValue(hovered: ThemedColor.value(_yellow)),
              ),
            );
            return const SizedBox();
          },
        ),
      ),
    );
    final colors = ShadcnColors.lightFallback;
    expect(seen!.color!.resolve({})!.resolve(colors), _green);
    expect(
      seen!.color!.resolve({WidgetState.hovered})!.resolve(colors),
      _yellow,
    );
  });
}
