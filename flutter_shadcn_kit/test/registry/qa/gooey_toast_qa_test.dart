// QA for `gooey_toast` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: `options.duration` being shadowed by the context
// helper, physical pill anchors, the missing `autoDismiss` passthrough, and
// `transition` targeting the wrong toast.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/gooey_toast/gooey_toast.dart';
import 'package:flutter_shadcn_kit/registry/components/gooey_toast/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_surface.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_placement.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  GooeyToastController controller, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  GooeyToastTheme? theme,
  Widget? child,
  double width = 400,
  double height = 400,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          height: height,
          child: GooeyToastLayer(
            controller: controller,
            theme: theme,
            child: child ?? const SizedBox.expand(),
          ),
        ),
      ),
    ),
  );
}

GooeyToastOptions _options({
  String title = 'Saved',
  Duration? duration,
  bool persist = false,
}) {
  return GooeyToastOptions(
    title: title,
    state: GooeyToastState.success,
    duration: duration,
    persistUntilDismissed: persist,
  );
}

Future<void> _clear(
  WidgetTester tester,
  GooeyToastController controller,
) async {
  for (final entry in controller.entries.toList()) {
    controller.remove(entry.id);
  }
  await tester.pump();
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in gooeyToastPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        final GooeyToastController controller = GooeyToastController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _frame(
            controller,
            data: ShadcnThemeData(colors: colors),
            child: Builder(builder: preview.builder),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('context helper prefers explicit, then options, then theme', (
    tester,
  ) async {
    final GooeyToastController controller = GooeyToastController();
    addTearDown(controller.dispose);
    late BuildContext host;
    await tester.pumpWidget(
      _frame(
        controller,
        child: Builder(
          builder: (BuildContext context) {
            host = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    // options.duration wins over the 6s theme default...
    final String viaOptions = showGooeyToast(
      host,
      _options(duration: const Duration(seconds: 2)),
    );
    expect(
      controller.entryOf(viaOptions)!.duration,
      const Duration(seconds: 2),
    );
    // ...and an explicit duration wins over options.duration.
    final String viaExplicit = showGooeyToast(
      host,
      _options(duration: const Duration(seconds: 2)),
      duration: const Duration(seconds: 9),
    );
    expect(
      controller.entryOf(viaExplicit)!.duration,
      const Duration(seconds: 9),
    );
    // Neither falls back to the theme default.
    final String viaTheme = showGooeyToast(host, _options());
    expect(
      controller.entryOf(viaTheme)!.duration,
      const Duration(milliseconds: 6000),
    );
    await _clear(tester, controller);
  });

  testWidgets('context helper passes autoDismiss through', (tester) async {
    final GooeyToastController controller = GooeyToastController();
    addTearDown(controller.dispose);
    late BuildContext host;
    await tester.pumpWidget(
      _frame(
        controller,
        child: Builder(
          builder: (BuildContext context) {
            host = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    final String id = showGooeyToast(host, _options(), autoDismiss: false);
    expect(controller.entryOf(id)!.autoDismiss, isFalse);
    final String kept = showGooeyToast(host, _options());
    expect(controller.entryOf(kept)!.autoDismiss, isTrue);
    await _clear(tester, controller);
  });

  testWidgets('position anchors are directional', (tester) async {
    expect(GooeyToastPosition.left.alignment, AlignmentDirectional.centerStart);
    expect(GooeyToastPosition.right.alignment, AlignmentDirectional.centerEnd);
    expect(GooeyToastPosition.center.alignment, Alignment.center);
  });

  testWidgets('left toast mirrors to the right edge in RTL', (tester) async {
    final GooeyToastController controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller, direction: TextDirection.rtl));
    controller.showGooeyToast(
      _options(title: 'Mirrored', duration: const Duration(minutes: 5)),
    );
    await tester.pump();
    // LTR `left` sits at x=16; in RTL it mirrors to the right edge (34, 16).
    expect(
      tester.getTopLeft(find.byType(GooeySurface).first),
      const Offset(34, 16),
    );
    expect(tester.takeException(), isNull);
    await _clear(tester, controller);
  });

  testWidgets('transition updates the newest toast, not the oldest', (
    tester,
  ) async {
    final GooeyToastController controller = GooeyToastController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(controller));
    controller.showGooeyToast(_options(title: 'First'));
    await tester.pump(const Duration(milliseconds: 5));
    final String newer = controller.showGooeyToast(_options(title: 'Second'));
    await tester.pump(const Duration(milliseconds: 5));
    // The queue orders newest-first, so `first` is the newest toast.
    final List<ToastEntry<GooeyToastOptions>> live = controller.entriesIn(
      const ToastSlot(ToastPlacement.topLeading),
    );
    expect(live, hasLength(2));
    expect(live.first.data.title, 'Second');
    expect(live.first.id, newer);

    final String updated = controller.showGooeyToast(
      _options(title: 'Third'),
      behavior: GooeyToastNewToastBehavior.transition,
    );
    await tester.pump();
    expect(updated, newer);
    expect(controller.entries, hasLength(2));
    expect(controller.entryOf(newer)!.data.title, 'Third');
    await _clear(tester, controller);
  });

  testWidgets('previews fit 375px with no overflow', (tester) async {
    for (final preview in gooeyToastPreviews) {
      final GooeyToastController controller = GooeyToastController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          controller,
          width: 375,
          child: Builder(builder: preview.builder),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: '${preview.name} 375px');
    }
  });
}
