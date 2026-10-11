// P6-P3 §2: the checkbox label row never paints a full-width bar.
//
// The 16px box alone carries fill/border; the label sits beside it
// uncoloured; the row hugs its content under loose AND stretch constraints.
// Covers light/dark × checked/unchecked/disabled, the theme gap, and the
// sibling check for Switch / RadioItem with labels (Toggle fills its button
// by design).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry/components/radio_group/radio_group.dart';
import 'package:flutter_shadcn_kit/registry/components/switch/switch.dart'
    show Switch, kSwitchTrackKey;
import 'package:flutter_shadcn_kit/registry/primitives/selectable_radio/selectable_radio.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

Widget _loose(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );
}

/// Stretch harness: a 400px column that forces tight cross-axis widths,
// like login-01's `Column(crossAxisAlignment: stretch)`.
Widget _stretch(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[child],
          ),
        ),
      ),
    ),
  );
}

BoxDecoration _box(WidgetTester tester) =>
    tester.widget<DecoratedBox>(find.byKey(kCheckboxBoxKey)).decoration
        as BoxDecoration;

void _expectLabelBesideBox(
  WidgetTester tester, {
  required String label,
  required double gap,
}) {
  final Rect box = tester.getRect(find.byKey(kCheckboxBoxKey));
  expect(box.width, moreOrLessEquals(checkboxDefaultSize, epsilon: 0.5));
  expect(box.height, moreOrLessEquals(checkboxDefaultSize, epsilon: 0.5));
  final Rect text = tester.getRect(find.text(label));
  // Label sits right of the box, never inside the fill.
  expect(text.left, greaterThan(box.right));
  expect(
    text.left - box.right,
    moreOrLessEquals(gap, epsilon: 1.5),
    reason: 'theme gap between box and label (box $box label $text)',
  );
  expect(text.top, greaterThanOrEqualTo(box.top - text.height));
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  group('checkbox label layout (loose)', () {
    for (final (String name, ShadcnColors palette) in <(String, ShadcnColors)>[
      ('light', light),
      ('dark', dark),
    ]) {
      testWidgets('$name checked hugs with primary box', (tester) async {
        await tester.pumpWidget(
          _loose(
            Checkbox(
              value: CheckboxValue.checked,
              onChanged: (_) {},
              label: const Text('Remember me'),
            ),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_box(tester).color, palette.primary);
        _expectLabelBesideBox(
          tester,
          label: 'Remember me',
          gap: checkboxDefaultGap,
        );
        // Row hugs: far narrower than any stretch parent.
        final Size row = tester.getSize(find.byType(Row));
        expect(row.width, lessThan(250));
      });

      testWidgets('$name unchecked has input border, no fill', (tester) async {
        await tester.pumpWidget(
          _loose(
            Checkbox(
              value: CheckboxValue.unchecked,
              onChanged: (_) {},
              label: const Text('Remember me'),
            ),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_box(tester).color, _alpha(palette.input, 0));
        expect(_box(tester).border, Border.all(color: palette.input, width: 1));
        _expectLabelBesideBox(
          tester,
          label: 'Remember me',
          gap: checkboxDefaultGap,
        );
      });
    }

    testWidgets('disabled keeps rest colours at 50% opacity', (tester) async {
      await tester.pumpWidget(
        _loose(
          const Checkbox(
            value: CheckboxValue.checked,
            label: Text('Remember me'),
          ),
        ),
      );
      expect(_box(tester).color, light.primary);
      final double opacity = tester
          .widget<Opacity>(
            find.descendant(
              of: find.byType(Checkbox),
              matching: find.byType(Opacity),
            ),
          )
          .opacity;
      expect(opacity, 0.5);
      _expectLabelBesideBox(
        tester,
        label: 'Remember me',
        gap: checkboxDefaultGap,
      );
    });

    testWidgets('label text is uncoloured foreground', (tester) async {
      await tester.pumpWidget(
        _loose(
          Checkbox(
            value: CheckboxValue.checked,
            onChanged: (_) {},
            label: const Text('Remember me'),
          ),
        ),
      );
      final Element element = find.text('Remember me').evaluate().single;
      expect(DefaultTextStyle.of(element).style.color, light.foreground);
    });
  });

  group('checkbox label layout (stretch)', () {
    for (final (String name, ShadcnColors palette) in <(String, ShadcnColors)>[
      ('light', light),
      ('dark', dark),
    ]) {
      testWidgets('$name checked never stretches the fill', (tester) async {
        await tester.pumpWidget(
          _stretch(
            Checkbox(
              value: CheckboxValue.checked,
              onChanged: (_) {},
              label: const Text('Remember me'),
            ),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        // The box stays 16px: no full-width grey bar.
        expect(_box(tester).color, palette.primary);
        _expectLabelBesideBox(
          tester,
          label: 'Remember me',
          gap: checkboxDefaultGap,
        );
        for (final Element element in find.byType(DecoratedBox).evaluate()) {
          final Decoration decoration =
              (element.widget as DecoratedBox).decoration;
          if (decoration is! BoxDecoration) {
            continue;
          }
          if (decoration.color != palette.primary) {
            continue;
          }
          final Size size = (element.renderObject! as RenderBox).size;
          expect(
            size.width,
            moreOrLessEquals(checkboxDefaultSize, epsilon: 0.5),
            reason: 'no stretched primary bar in $name',
          );
        }
      });

      testWidgets('$name unchecked never stretches the fill', (tester) async {
        await tester.pumpWidget(
          _stretch(
            Checkbox(
              value: CheckboxValue.unchecked,
              onChanged: (_) {},
              label: const Text('Remember me'),
            ),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_box(tester).color, _alpha(palette.input, 0));
        _expectLabelBesideBox(
          tester,
          label: 'Remember me',
          gap: checkboxDefaultGap,
        );
      });
    }
  });

  group('siblings with labels', () {
    testWidgets('switch track keeps its size under stretch', (tester) async {
      await tester.pumpWidget(
        _stretch(
          Switch(value: true, onChanged: (_) {}, label: const Text('Wi-Fi')),
        ),
      );
      final Size track = tester.getSize(find.byKey(kSwitchTrackKey));
      expect(track.width, moreOrLessEquals(32, epsilon: 0.5));
      expect(track.width, lessThan(100));
    });

    testWidgets('radio indicator keeps its size under stretch', (tester) async {
      final ShadcnRadioGroupController<String> controller =
          ShadcnRadioGroupController<String>('a');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _stretch(
          ShadcnRadioGroup<String>(
            controller: controller,
            items: const <Widget>[
              RadioItem<String>(value: 'a', label: Text('Option A')),
              RadioItem<String>(value: 'b', label: Text('Option B')),
            ],
          ),
        ),
      );
      final Size indicator = tester.getSize(
        find.byKey(kRadioIndicatorKey).first,
      );
      expect(indicator.width, moreOrLessEquals(16, epsilon: 0.5));
      expect(indicator.width, lessThan(100));
      expect(find.text('Option A'), findsOneWidget);
    });
  });
}
