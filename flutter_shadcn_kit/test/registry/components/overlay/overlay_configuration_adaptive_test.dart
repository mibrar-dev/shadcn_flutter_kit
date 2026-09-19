import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies the adaptive overlay conversion actually reshapes presentation.
///
/// Upstream parity: a [PopoverConfiguration] converts into a bottom
/// [DrawerConfiguration] on mobile platforms via [adaptiveConversion]
/// (consumed by `showOverlay`/`OverlayController.show` when `adaptive` is
/// true), and stays a popover on desktop.
void main() {
  Future<OverlayConfiguration> convertedOn(
    WidgetTester tester,
    TargetPlatform platform,
  ) async {
    late OverlayConfiguration result;
    await tester.pumpWidget(
      ShadcnApp(
        home: Builder(
          builder: (context) {
            debugDefaultTargetPlatformOverride = platform;
            result = const PopoverConfiguration(
              alignment: Alignment.topCenter,
            ).adaptiveConversion(context);
            debugDefaultTargetPlatformOverride = null;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('popover stays a popover on desktop', (tester) async {
    final config = await convertedOn(tester, TargetPlatform.macOS);
    expect(config, isA<PopoverConfiguration>());
  });

  testWidgets('popover converts to a bottom drawer on mobile', (
    tester,
  ) async {
    final config = await convertedOn(tester, TargetPlatform.iOS);
    expect(config, isA<DrawerConfiguration>());
    expect(
      (config as DrawerConfiguration).position,
      OverlayPosition.bottom,
    );
  });

  testWidgets('nonAdaptive never converts, even on mobile', (tester) async {
    late OverlayConfiguration result;
    await tester.pumpWidget(
      ShadcnApp(
        home: Builder(
          builder: (context) {
            debugDefaultTargetPlatformOverride = TargetPlatform.android;
            result = const PopoverConfiguration(
              alignment: Alignment.topCenter,
            ).nonAdaptive.adaptiveConversion(context);
            debugDefaultTargetPlatformOverride = null;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(result, isA<PopoverConfiguration>());
    expect(result, isNot(isA<DrawerConfiguration>()));
  });
}
