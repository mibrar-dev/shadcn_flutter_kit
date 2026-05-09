import 'package:docs/pages/docs/components/gooey_toast/gooey_toast_example_1.dart';
import 'package:docs/shadcn_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('docs gooey toast surface inverts against active theme brightness', () {
    expect(
      resolveGooeyToastDocsSurface(Brightness.light).computeLuminance(),
      lessThan(0.5),
    );
    expect(
      resolveGooeyToastDocsSurface(Brightness.dark).computeLuminance(),
      greaterThan(0.5),
    );
  });
}
