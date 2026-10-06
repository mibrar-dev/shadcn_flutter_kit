// Regression tests for `Hidden` relayout: the old shared fork never called
// `markNeedsLayout()` from `updateRenderObject`, so toggling `hidden` did not
// collapse the widget until an unrelated relayout happened. The port follows
// the component fork (the ownership winner), which marks layout.
//

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/hidden.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(data: const ShadcnThemeData(), child: child),
  );
}

void main() {
  testWidgets('toggling Hidden contracts mid-animation and expands again', (
    tester,
  ) async {
    Widget build(bool hidden) => _wrap(
      Center(
        child: Hidden(
          hidden: hidden,
          duration: const Duration(milliseconds: 50),
          child: const SizedBox(width: 100, height: 20),
        ),
      ),
    );

    await tester.pumpWidget(build(false));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 100, reason: 'expanded');

    await tester.pumpWidget(build(true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 25));
    expect(
      tester.getSize(find.byType(Hidden)).width,
      lessThan(100),
      reason: 'mid',
    );

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 0, reason: 'collapsed');

    await tester.pumpWidget(build(false));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getSize(find.byType(Hidden)).width, 100, reason: 'expanded');
  });
}
