// Shared helpers for theme-dependence audit tests.
//
// These utilities load preset themes and provide a standard harness for
// rendering components under different presets and asserting theme token usage.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

import '../../registry/themes/generated_theme.dart';

/// Presets used in the audit: neutral (baseline), claude (user-reported issue),
/// and tangerine (saturated).
const String kNeutralPreset = 'neutral';
const String kClaudePreset = 'claude';
const String kTangerinePreset = 'tangerine';

/// Loads a preset theme for the given [presetId] and [brightness].
GeneratedTheme loadPreset(String presetId) {
  final path = 'lib/registry/themes/$presetId.json';
  return loadGeneratedTheme(path);
}

/// `Clickable` wraps its container in an `AnimatedContainer`
/// (`kDefaultDuration` = 150ms), so a theme swap animates the colour instead
/// of snapping. Any colour assertion has to settle that transition first,
/// otherwise it reads the mid-animation value.
const Duration kSettleDuration = Duration(milliseconds: 150);

/// Pumps a widget under the given [preset] and [brightness], then advances
/// the clock past the 150ms `Clickable` transition.
Future<void> pumpUnderPreset(
  WidgetTester tester, {
  required String presetId,
  required Brightness brightness,
  required Widget child,
}) async {
  final theme = loadPreset(presetId);
  final view = theme.view(brightness);
  await tester.pumpWidget(
    ShadcnTheme(
      data: ShadcnThemeData(
        colors: view.colors,
        tokens: view.tokens,
        fonts: view.fonts,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
  await tester.pump(kSettleDuration);
}

/// Reads the resolved [ShadcnThemeData] from the widget tree.
ShadcnThemeData resolvedTheme(WidgetTester tester) {
  return ShadcnTheme.of(tester.element(find.byType(Directionality).first));
}

/// Asserts that a [Color] matches the expected token from the theme.
void expectColor(Color actual, Color expected, String reason) {
  expect(
    actual,
    expected,
    reason:
        '$reason: expected ${expected.toARGB32().toRadixString(16)}, '
        'got ${actual.toARGB32().toRadixString(16)}',
  );
}

/// Asserts that a [TextStyle] color matches the expected token.
void expectStyleColor(TextStyle style, Color expected, String reason) {
  expect(
    style.color,
    expected,
    reason:
        '$reason: expected ${expected.toARGB32().toRadixString(16)}, '
        'got ${style.color?.toARGB32().toRadixString(16)}',
  );
}

/// Finds a [Container] with a specific [Color] decoration.
Color? findContainerColor(WidgetTester tester, Color color) {
  final containers = tester.widgetList<Container>(find.byType(Container));
  for (final container in containers) {
    final decoration = container.decoration;
    if (decoration is BoxDecoration && decoration.color == color) {
      return decoration.color;
    }
  }
  return null;
}

/// Every color painted by any [BoxDecoration] in the tree, plus every color
/// carried by a [TextStyle] (including spans). Used for whole-tree
/// theme-token scans.
Set<Color> allRenderedColors(WidgetTester tester) {
  final colors = <Color>{};

  void addDecoration(Decoration? decoration) {
    if (decoration is! BoxDecoration) return;
    if (decoration.color != null) colors.add(decoration.color!);
    final border = decoration.border;
    if (border is Border) {
      for (final side in [
        border.top,
        border.bottom,
        border.left,
        border.right,
      ]) {
        if (side.width > 0 || side.color.a > 0) colors.add(side.color);
      }
    }
  }

  for (final container in tester.widgetList<Container>(
    find.byType(Container),
  )) {
    addDecoration(container.decoration);
  }
  for (final box in tester.widgetList<DecoratedBox>(
    find.byType(DecoratedBox),
  )) {
    addDecoration(box.decoration);
  }

  void addTextStyle(TextStyle? style) {
    if (style?.color != null) colors.add(style!.color!);
  }

  void addSpan(InlineSpan? span) {
    if (span == null) return;
    if (span is TextSpan) {
      addTextStyle(span.style);
      for (final child in span.children ?? const <InlineSpan>[]) {
        addSpan(child);
      }
    }
  }

  for (final text in tester.widgetList<Text>(find.byType(Text))) {
    addTextStyle(text.style);
    addSpan(text.textSpan);
  }
  for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
    addSpan(rich.text);
  }
  for (final style in tester.widgetList<DefaultTextStyle>(
    find.byType(DefaultTextStyle),
  )) {
    addTextStyle(style.style);
  }
  return colors;
}

/// Whether any decoration in the tree paints [color].
bool hasDecorationColor(WidgetTester tester, Color color) =>
    allRenderedColors(tester).contains(color);

/// Finds a [DecoratedBox] with a specific [Color].
Color? findDecoratedBoxColor(WidgetTester tester, Color color) {
  final boxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
  for (final box in boxes) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color == color) {
      return decoration.color;
    }
  }
  return null;
}

/// Finds all [Text] widgets and returns their styles.
List<TextStyle> findAllTextStyles(WidgetTester tester) {
  return tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.style ?? const TextStyle())
      .toList();
}

/// Asserts that no [Text] widget uses a color outside the allowed set.
void assertNoHardcodedColors(
  WidgetTester tester,
  Set<Color> allowed,
  String componentName,
) {
  final styles = findAllTextStyles(tester);
  for (final style in styles) {
    final color = style.color;
    if (color != null && !allowed.contains(color)) {
      fail(
        '$componentName uses hardcoded color '
        '${color.toARGB32().toRadixString(16)}',
      );
    }
  }
}
