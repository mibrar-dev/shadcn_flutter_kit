// Headless render audit of every component preview (P6-D9a).
//
// Pumps each registry `preview.dart` (through the same deferred loader the
// docs component page uses) inside the *real* `PreviewStage`, with the light
// and the dark token set, and records for every (component, mode) pair:
//   * whether the build laid out at all (`ok`, `THREW`, `OVERFLOW`,
//     `ZERO-SIZE`) — `OVERFLOW` means the preview paints but is clipped by
//     the stage, `THREW` means it cannot be laid out,
//   * the preview's own painted size,
//   * how many `RenderBox`es painted below the stage,
//   * the culprit widget + file:line of every framework error raised.
//
// The full report is written to `build/audit/preview_render_audit.txt`
// (gitignored). The audit is skipped by default — it is a diagnostic, and it
// deliberately observes broken previews. Run it with:
//   AUDIT_RENDER=1 flutter test test/audit/preview_render_audit_test.dart
//
// While previews are broken this run exits non-zero (an async error escapes
// from a failed NetworkImage fetch in the `image` preview, which
// `FlutterError.onError` cannot catch). The signal is the `BASELINE
// threw=… overflow=… zero=…` line plus the report file, both of which the
// P6-D9a audit extracted.

import 'dart:io';

import 'package:docs/generated/docs_data.dart';
import 'package:docs/generated/docs_previews.dart';
import 'package:docs/previews/component_previews.dart';
import 'package:docs/ui/shadcn/components/app/app.dart';
import 'package:docs/widgets/preview_stage.dart';
import 'package:docs/ui/shadcn/theme/color_tokens.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stage width handed to every preview: the docs article width at 1440. The
/// height is deliberately left to `PreviewStage` (min 288, grows with the
/// preview), matching the docs page instead of inventing a fixed box.
const double _stageWidth = 1000;

/// Framework errors captured while a preview is pumped.
final List<String> _capturedErrors = <String>[];
final List<String> _capturedCulprits = <String>[];

void _auditErrorHandler(FlutterErrorDetails details) {
  _capturedErrors.add(details.exceptionAsString().split('\n').first);
  final String full = details.toString();
  final RegExp widget = RegExp(
    r'The relevant error-causing widget was:\s*\n?\s*([A-Za-z]+)',
  );
  final RegExp where = RegExp(r'([A-Za-z0-9_./-]+\.dart):(\d+):\d+');
  final RegExpMatch? fileMatch = where.firstMatch(full);
  _capturedCulprits.add(
    '${widget.firstMatch(full)?.group(1) ?? 'unknown'}@'
    '${fileMatch?.group(1) ?? '?'}:${fileMatch?.group(2) ?? '?'}',
  );
}

/// Set `AUDIT_RENDER=1` to run this diagnostic. It is skipped by default
/// because the audit *expects* broken previews: every framework error they
/// raise would otherwise fail the suite (and some of them escape as async
/// errors, e.g. the failed `NetworkImage` fetches in the `image` preview).
///
///   AUDIT_RENDER=1 flutter test test/audit/preview_render_audit_test.dart
//
// While previews are broken this run exits non-zero (an async error escapes
// from a failed NetworkImage fetch in the `image` preview, which
// `FlutterError.onError` cannot catch). The signal is the `BASELINE
// threw=… overflow=… zero=…` line plus the report file, both of which the
// P6-D9a audit extracted.
void main() {
  testWidgets('every component preview renders in light and dark', (
    WidgetTester tester,
  ) async {
    // The audit *expects* broken previews, so the framework errors they raise
    // must not fail the test: they are captured here, written to the report
    // and asserted against a pinned baseline. `flutter test` would otherwise
    // report "Multiple exceptions were detected ... at least one was
    // unexpected".
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = _auditErrorHandler;

    final List<String> rows = <String>[];
    final StringBuffer out = StringBuffer('=== PREVIEW RENDER AUDIT ===\n');
    // P6-F4: only listed components (named examples) are audited; building
    // blocks keep maintainer galleries outside the docs chrome.
    final List<String> ids = <String>[
      for (final DocsComponent c in kComponents)
        if ((kComponentPreviews[c.id] ?? const <String>[]).isNotEmpty) c.id,
    ]..sort();
    // The deferred preview chunks resolve on the real event loop; the
    // FakeAsync zone of `testWidgets` can never complete them.
    final Map<String, Widget> previews = <String, Widget>{};
    await tester.runAsync(() async {
      for (final String id in ids) {
        previews[id] = await loadComponentPreview(id);
      }
    });

    for (final String id in ids) {
      final _Result lightResult = await _pump(
        tester,
        previews[id]!,
        Brightness.light,
        label: '$id/light',
      );
      final _Result darkResult = await _pump(
        tester,
        previews[id]!,
        Brightness.dark,
        label: '$id/dark',
      );
      final String row =
          'ROW $id|light=${lightResult.status}|dark=${darkResult.status}'
          '|sizeL=${lightResult.size}|sizeD=${darkResult.size}'
          '|boxes=${lightResult.boxes}/${darkResult.boxes}'
          '|errors=${[...lightResult.errors, ...darkResult.errors].join(' ; ')}';
      out.writeln(row);
      rows.add(row);
    }

    final File file = File('build/audit/preview_render_audit.txt')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(out.toString());
    debugPrint(
      'wrote ${file.path} (${ids.length} components, '
      '${rows.where((String r) => !r.contains('|light=ok|dark=ok')).length}'
      ' components with findings); see '
      'rearch/reports/P6_COMPONENT_AUDIT.md section 2.3-2.6 for the '
      'per-component root causes.',
    );

    // P6-F4 baseline: the bounded stage plus one-example-at-a-time previews
    // reach 0/0/0 for every listed component in light + dark. Anything above
    // zero is a regression.
    const int baselineThrew = 0;
    const int baselineOverflow = 0;
    const int baselineZeroSize = 0;
    final int threw = rows
        .where(
          (String r) => r.contains('|light=THREW') || r.contains('|dark=THREW'),
        )
        .length;
    final int overflow = rows
        .where(
          (String r) =>
              r.contains('|light=OVERFLOW') || r.contains('|dark=OVERFLOW'),
        )
        .length;
    final int zero = rows
        .where(
          (String r) =>
              r.contains('|light=ZERO-SIZE') || r.contains('|dark=ZERO-SIZE'),
        )
        .length;
    FlutterError.onError = previous;
    debugPrint(
      'BASELINE threw=$threw overflow=$overflow zero=$zero '
      '(pinned: threw=$baselineThrew overflow=$baselineOverflow '
      'zero=$baselineZeroSize)',
    );
    expect(threw, baselineThrew, reason: 'THREW baseline changed');
    expect(overflow, baselineOverflow, reason: 'OVERFLOW baseline changed');
    expect(zero, baselineZeroSize, reason: 'ZERO-SIZE baseline changed');
  }, skip: Platform.environment['AUDIT_RENDER'] != '1');
}

class _Result {
  _Result(this.status, this.size, this.boxes, this.errors);

  /// `ok`, `THREW` (layout assertion / exception: the subtree cannot be laid
  /// out at all), `OVERFLOW` (paints but overflows its stage, so the docs card
  /// clips it) or `ZERO-SIZE`.
  final String status;

  /// Painted size of the preview subtree, `-` when it threw.
  final String size;

  /// Number of painted `RenderBox`es below the stage.
  final int boxes;

  /// Errors caught while pumping.
  final List<String> errors;
}

Future<_Result> _pump(
  WidgetTester tester,
  Widget preview,
  Brightness brightness, {
  required String label,
}) async {
  final int before = _capturedErrors.length;
  final GlobalKey key = GlobalKey(debugLabel: label);
  final ShadcnThemeData data = ShadcnThemeData(
    colors: brightness == Brightness.dark
        ? ShadcnColors.darkFallback
        : ShadcnColors.lightFallback,
  );
  // `ShadcnApp` (not a bare `ShadcnTheme`) so popup-based previews find the
  // Navigator/Overlay they get under the real docs shell, and the preview is
  // hosted in the *real* `PreviewStage`, whose constraints are exactly the
  // ones a docs page gives (unbounded height inside a horizontal scroller) —
  // that is what `pinned_sheet` trips over in the browser.
  await tester.pumpWidget(
    ShadcnApp(
      title: 'P6-D9a render audit',
      theme: data,
      darkTheme: data,
      themeMode: brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            key: key,
            width: _stageWidth,
            child: PreviewStage(child: preview),
          ),
        ),
      ),
    ),
  );
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 32));
  }
  final List<String> caught = _capturedErrors.sublist(before);
  final List<String> culprits = _capturedCulprits.sublist(before);
  final RenderBox? box = _safeBox(tester, preview);
  final int boxes = box == null ? 0 : _countBoxes(tester, key);
  final String size = box == null || !box.hasSize
      ? '-'
      : '${box.size.width.toStringAsFixed(0)}x${box.size.height.toStringAsFixed(0)}';

  if (caught.isEmpty) {
    if (box == null || !box.hasSize || box.size.isEmpty) {
      return _Result('ZERO-SIZE', size, boxes, caught);
    }
    return _Result('ok', size, boxes, caught);
  }
  final bool overflow = caught.every((String e) => e.contains('overflowed by'));
  final String status = overflow ? 'OVERFLOW' : 'THREW';
  // Recorded for the report only; the test asserts on the baselines below.
  return _Result(status, size, boxes, <String>[...caught, ...culprits]);
}

RenderBox? _safeBox(WidgetTester tester, Widget preview) {
  try {
    return tester.renderObject<RenderBox>(find.byWidget(preview));
  } catch (_) {
    return null;
  }
}

int _countBoxes(WidgetTester tester, GlobalKey key) {
  int count = 0;
  final List<Element> all = _collectElements(tester.element(find.byKey(key)));
  for (final Element element in all) {
    final RenderObject? ro = element.renderObject;
    if (ro is RenderBox && ro.hasSize && !ro.size.isEmpty) {
      count++;
    }
  }
  return count;
}

List<Element> _collectElements(Element root) {
  final List<Element> out = <Element>[];
  void visit(Element e) {
    out.add(e);
    e.visitChildren(visit);
  }

  visit(root);
  return out;
}
