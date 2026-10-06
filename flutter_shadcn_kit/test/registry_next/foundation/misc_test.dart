import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/constants.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/platform.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/style_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('styleValue picks widget, then theme, then default', () {
    expect(styleValue(widgetValue: 1, themeValue: 2, defaultValue: 3), 1);
    expect(styleValue(themeValue: 2, defaultValue: 3), 2);
    expect(styleValue(defaultValue: 3), 3);
  });

  test('isMobile covers the mobile platforms', () {
    expect(isMobile(TargetPlatform.android), isTrue);
    expect(isMobile(TargetPlatform.iOS), isTrue);
    expect(isMobile(TargetPlatform.fuchsia), isTrue);
    expect(isMobile(TargetPlatform.macOS), isFalse);
    expect(isMobile(TargetPlatform.linux), isFalse);
    expect(isMobile(TargetPlatform.windows), isFalse);
  });

  test('degToRad converts degrees', () {
    expect(degToRad(0), 0);
    expect(degToRad(180), closeTo(3.141592653589793, 1e-12));
    expect(kDefaultDuration, const Duration(milliseconds: 150));
  });

  testWidgets('Data.boundary hides ancestor values from its subtree', (
    tester,
  ) async {
    int? value;
    await tester.pumpWidget(
      Data<int>.inherit(
        data: 5,
        child: Data<int>.boundary(
          child: Builder(
            builder: (context) {
              value = Data.maybeOf<int>(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(value, isNull);
  });

  testWidgets('Data.data and dataType expose the provided value', (
    tester,
  ) async {
    const data = Data<int>.inherit(data: 8);
    expect(data.dataType, int);
    expect(data.data, 8);
  });
}
