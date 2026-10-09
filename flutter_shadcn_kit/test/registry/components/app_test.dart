// Widget tests for the `app` component.
//
// Covers the shell wiring (theme, ComponentThemes, overlay manager,
// localizations, ShadcnUI) and the old-bug regression: `ThemeMode.system`
// never resolved the dark theme because the old app read MediaQuery above
// WidgetsApp.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/app/app.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

class _ProbeTheme extends ComponentThemeData {
  const _ProbeTheme(this.value);

  final int value;
}

/// Everything the shell installs, captured at the home context.
class _Seen {
  ShadcnThemeData? theme;
  bool hasOverlayManager = false;
  bool hasProbe = false;
  bool hasShadcnLocalizations = false;
  TextStyle defaultTextStyle = const TextStyle();
  Color? iconColor;
}

Widget _home(_Seen seen) {
  return Builder(
    builder: (BuildContext context) {
      seen
        ..theme = ShadcnTheme.of(context)
        ..hasOverlayManager = Data.maybeOf<OverlayManager>(context) != null
        ..hasProbe = ComponentThemes.maybeOf<_ProbeTheme>(context)?.value == 42
        ..hasShadcnLocalizations =
            Localizations.of<ShadcnLocalizations>(
              context,
              ShadcnLocalizations,
            ) !=
            null
        ..defaultTextStyle = DefaultTextStyle.of(context).style
        ..iconColor = IconTheme.of(context).color;
      return const SizedBox(width: 10, height: 10);
    },
  );
}

Future<_Seen> _pumpApp(
  WidgetTester tester, {
  ShadcnApp Function(_Seen seen)? buildApp,
}) async {
  final _Seen seen = _Seen();
  await tester.pumpWidget(
    buildApp?.call(seen) ??
        ShadcnApp(
          componentThemes: const <ComponentThemeData>[_ProbeTheme(42)],
          home: _home(seen),
        ),
  );
  return seen;
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  testWidgets('installs theme, component themes, overlay and l10n', (
    tester,
  ) async {
    final _Seen seen = await _pumpApp(tester);
    expect(seen.theme!.colors, light);
    expect(seen.hasProbe, isTrue);
    expect(seen.hasOverlayManager, isTrue);
    expect(seen.hasShadcnLocalizations, isTrue);
  });

  testWidgets('installs the shadcn delegate and resolves translated locales', (
    tester,
  ) async {
    late Locale resolved;
    await tester.pumpWidget(
      ShadcnApp(
        locale: const Locale('de'),
        home: Builder(
          builder: (BuildContext context) {
            resolved = Localizations.localeOf(context);
            return const SizedBox(width: 1, height: 1);
          },
        ),
      ),
    );
    expect(resolved.languageCode, 'de');
    expect(
      Localizations.of<ShadcnLocalizations>(
        tester.element(find.byType(SizedBox)),
        ShadcnLocalizations,
      )?.locale.languageCode,
      'de',
    );
  });

  testWidgets('regression: en_US resolves to en without a delegate warning', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = <Locale>[
      const Locale('en', 'US'),
    ];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    late Locale resolved;
    await tester.pumpWidget(
      ShadcnApp(
        home: Builder(
          builder: (BuildContext context) {
            resolved = Localizations.localeOf(context);
            return const SizedBox(width: 1, height: 1);
          },
        ),
      ),
    );
    expect(resolved, const Locale('en'));
    expect(tester.takeException(), isNull);
    expect(
      Localizations.of<ShadcnLocalizations>(
        tester.element(find.byType(SizedBox)),
        ShadcnLocalizations,
      )?.locale,
      const Locale('en'),
    );
  });

  testWidgets('ShadcnUI provides the default text and icon style', (
    tester,
  ) async {
    final _Seen seen = await _pumpApp(tester);
    expect(seen.defaultTextStyle.color, light.foreground);
    expect(
      seen.defaultTextStyle.fontSize,
      seen.theme!.typography.sans.fontSize,
    );
    expect(seen.iconColor, light.foreground);
  });

  testWidgets('themeMode.dark uses darkTheme', (tester) async {
    final _Seen seen = await _pumpApp(
      tester,
      buildApp: (_Seen seen) => ShadcnApp(
        theme: const ShadcnThemeData(),
        darkTheme: const ShadcnThemeData(colors: dark),
        themeMode: ThemeMode.dark,
        home: _home(seen),
      ),
    );
    expect(seen.theme!.colors, dark);
  });

  testWidgets('regression: system brightness resolves the dark theme', (
    tester,
  ) async {
    // The old shell resolved at the root, above WidgetsApp's MediaQuery, so
    // `platformBrightness` was always null and the dark theme never applied.
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final _Seen seen = await _pumpApp(
      tester,
      buildApp: (_Seen seen) => ShadcnApp(
        theme: const ShadcnThemeData(),
        darkTheme: const ShadcnThemeData(colors: dark),
        home: _home(seen),
      ),
    );
    expect(seen.theme!.colors, dark);
  });

  testWidgets('scaling is applied on top of the theme', (tester) async {
    final _Seen seen = await _pumpApp(
      tester,
      buildApp: (_Seen seen) =>
          ShadcnApp(scaling: const AdaptiveScaling(2), home: _home(seen)),
    );
    expect(seen.theme!.scaling, 2);
  });

  testWidgets('builder wraps the navigator child', (tester) async {
    final _Seen seen = _Seen();
    await tester.pumpWidget(
      ShadcnApp(
        builder: (BuildContext context, Widget? child) =>
            ColoredBox(color: const Color(0xFF123456), child: child!),
        home: _home(seen),
      ),
    );
    expect(seen.theme, isNotNull);
    expect(
      find.ancestor(
        of: find.byType(SizedBox),
        matching: find.byType(ColoredBox),
      ),
      findsWidgets,
    );
  });

  testWidgets('routes render through the default page route builder', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        initialRoute: '/second',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) =>
              const SizedBox(key: ValueKey<String>('first')),
          '/second': (BuildContext context) =>
              const SizedBox(key: ValueKey<String>('second')),
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('second')), findsOneWidget);
  });

  testWidgets('ShadcnUI is usable on its own', (tester) async {
    late TextStyle style;
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(colors: dark),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ShadcnUI(
            child: Builder(
              builder: (BuildContext context) {
                style = DefaultTextStyle.of(context).style;
                return const SizedBox(width: 1, height: 1);
              },
            ),
          ),
        ),
      ),
    );
    expect(style.color, dark.foreground);
  });
}
