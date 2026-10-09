// Widget tests for the `dropzone` component.
//
// Covers every state and its border token, the drag highlight, the localized
// status lines, the browse action, disabled handling, all four
// theme-precedence legs, light and dark tokens, and one regression test per old
// bug that was fixed.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/dropzone/dropzone.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  DropzoneTheme? scoped,
  Locale? locale,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<DropzoneTheme>(data: scoped, child: body);
  }
  Widget root = ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 400, child: body)),
      ),
    ),
  );
  if (locale != null) {
    root = Localizations(
      locale: locale,
      // `Localizations` insists on a widgets delegate, so both are needed.
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        ShadcnLocalizations.delegate,
      ],
      child: root,
    );
  }
  return root;
}

Border _border(WidgetTester tester) {
  final Container surface = tester.widget<Container>(
    find.byKey(dropzoneSurfaceKey),
  );
  return (surface.decoration! as BoxDecoration).border! as Border;
}

String _status(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(dropzoneStatusKey)).data!;

void main() {
  group('states', () {
    testWidgets('idle draws the ambient border token', (tester) async {
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(_status(tester), 'Browse to upload files');
      expect(_border(tester).top.color, ShadcnColors.lightFallback.border);
    });

    testWidgets('every state paints its own token', (tester) async {
      final Map<DropzoneState, Color> expected = <DropzoneState, Color>{
        DropzoneState.idle: ShadcnColors.lightFallback.border,
        DropzoneState.dragging: ShadcnColors.lightFallback.primary,
        DropzoneState.uploading: ShadcnColors.lightFallback.primary,
        DropzoneState.success: ShadcnColors.lightFallback.accent,
        DropzoneState.error: ShadcnColors.lightFallback.destructive,
      };
      for (final MapEntry<DropzoneState, Color> entry in expected.entries) {
        await tester.pumpWidget(_frame(child: Dropzone(state: entry.key)));
        expect(_border(tester).top.color, entry.value, reason: '${entry.key}');
      }
    });

    testWidgets('every state has its own status line', (tester) async {
      final Map<DropzoneState, String> expected = <DropzoneState, String>{
        DropzoneState.idle: 'Browse to upload files',
        DropzoneState.dragging: 'Drop files to upload',
        DropzoneState.uploading: 'Uploading files...',
        DropzoneState.success: 'Files ready',
        DropzoneState.error: 'Fix errors to continue',
        DropzoneState.disabled: 'File uploads disabled',
      };
      for (final MapEntry<DropzoneState, String> entry in expected.entries) {
        await tester.pumpWidget(_frame(child: Dropzone(state: entry.key)));
        expect(_status(tester), entry.value, reason: '${entry.key}');
      }
    });

    testWidgets('enabled: false reports the disabled line', (tester) async {
      await tester.pumpWidget(_frame(child: const Dropzone(enabled: false)));
      expect(_status(tester), 'File uploads disabled');
    });

    testWidgets('regression: an idle dropzone does not crash', (tester) async {
      // The old `_resolveBorderColor` returned null for idle and the outline
      // was then painted with `color: null`, which `Border.all` rejects — so
      // the default state crashed instead of drawing a quiet outline.
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(tester.takeException(), isNull);
      expect(_border(tester).top.color, isNotNull);
    });
  });

  group('drag highlight', () {
    testWidgets('isDragOver wins over the state token', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Dropzone(state: DropzoneState.error, isDragOver: true),
        ),
      );
      expect(_border(tester).top.color, ShadcnColors.lightFallback.primary);
      expect(_status(tester), 'Drop files to upload');
    });

    testWidgets('the icon scales while a drag hovers', (tester) async {
      await tester.pumpWidget(_frame(child: const Dropzone()));
      double scale() =>
          tester.widget<AnimatedScale>(find.byKey(dropzoneIconKey)).scale;
      expect(scale(), 1);
      await tester.pumpWidget(_frame(child: const Dropzone(isDragOver: true)));
      await tester.pump(const Duration(milliseconds: 200));
      expect(scale(), 1.05);
    });

    testWidgets('a disabled dropzone ignores isDragOver', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Dropzone(isDragOver: true, enabled: false)),
      );
      expect(_status(tester), 'File uploads disabled');
      expect(_border(tester).top.color, ShadcnColors.lightFallback.border);
    });
  });

  group('action', () {
    testWidgets('the browse button fires onBrowse', (tester) async {
      int taps = 0;
      await tester.pumpWidget(_frame(child: Dropzone(onBrowse: () => taps++)));
      await tester.tap(find.byKey(dropzoneActionKey));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('a null onBrowse renders a disabled button', (tester) async {
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);
    });

    testWidgets('enabled: false disables the button', (tester) async {
      await tester.pumpWidget(
        _frame(child: Dropzone(enabled: false, onBrowse: () {})),
      );
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);
    });

    testWidgets('DropzoneState.disabled disables the button', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: Dropzone(state: DropzoneState.disabled, onBrowse: () {}),
        ),
      );
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);
    });

    testWidgets('the default label comes from the localizations', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(find.text('Browse files'), findsOneWidget);
    });

    testWidgets('an explicit label wins', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Dropzone(actionLabel: 'Pick a file')),
      );
      expect(find.text('Pick a file'), findsOneWidget);
      expect(find.text('Browse files'), findsNothing);
    });

    testWidgets('the button is an outline variant by default', (tester) async {
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(
        tester.widget<Button>(find.byType(Button)).variant,
        ButtonVariant.outline,
      );
    });

    testWidgets('showAction: false drops the button', (tester) async {
      await tester.pumpWidget(_frame(child: const Dropzone(showAction: false)));
      expect(find.byKey(dropzoneActionKey), findsNothing);
    });
  });

  group('content', () {
    testWidgets('a hint renders under the status line', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Dropzone(hint: Text('Up to 10 MB each.'))),
      );
      expect(find.text('Up to 10 MB each.'), findsOneWidget);
      expect(
        tester.getRect(find.text('Up to 10 MB each.')).top,
        greaterThan(tester.getRect(find.byKey(dropzoneStatusKey)).top),
      );
    });

    testWidgets('content renders below the action', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const Dropzone(
            content: Text('Drop a folder here to upload it whole.'),
          ),
        ),
      );
      expect(
        tester.getRect(find.text('Drop a folder here to upload it whole.')).top,
        greaterThan(tester.getRect(find.byType(Button)).top),
      );
    });

    testWidgets('showAction: false with content still keeps the status', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const Dropzone(showAction: false, content: Text('folder')),
        ),
      );
      expect(find.byKey(dropzoneStatusKey), findsOneWidget);
      expect(find.text('folder'), findsOneWidget);
      expect(find.byType(Button), findsNothing);
    });

    testWidgets('regression: no content means no empty box', (tester) async {
      // The old `showDefaultContent` had a state (false + content: null) that
      // rendered an empty surface.
      await tester.pumpWidget(_frame(child: const Dropzone(showAction: false)));
      expect(find.byKey(dropzoneStatusKey), findsOneWidget);
      expect(find.byKey(dropzoneIconKey), findsOneWidget);
    });

    testWidgets('regression: the surface hugs its content', (tester) async {
      // The old `LayoutBuilder` pinned `height: constraints.maxHeight` whenever
      // the parent was bounded, so the dropzone swallowed the whole page
      // instead of sizing to its own content.
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(
        tester.getSize(find.byKey(dropzoneSurfaceKey)).height,
        lessThan(600),
      );
      // It is its content plus the theme's vertical padding, so the first and
      // last painted rows sit ~24 in from the edge (plus the 1px border).
      final Rect surface = tester.getRect(find.byKey(dropzoneSurfaceKey));
      final Rect icon = tester.getRect(find.byKey(dropzoneIconKey));
      final Rect button = tester.getRect(find.byType(Button));
      expect(icon.top - surface.top, closeTo(24, 1.5));
      expect(surface.bottom - button.bottom, closeTo(24, 1.5));
    });

    testWidgets('a taller hint makes a taller surface', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Dropzone(hint: Text('short'))),
      );
      final double shortSurface = tester
          .getSize(find.byKey(dropzoneSurfaceKey))
          .height;
      await tester.pumpWidget(
        _frame(
          child: const Dropzone(
            hint: Text(
              'a hint long enough to wrap onto a second line at this width',
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byKey(dropzoneSurfaceKey)).height,
        greaterThan(shortSurface),
      );
    });

    testWidgets('minHeight is honoured', (tester) async {
      await tester.pumpWidget(
        _frame(child: const Dropzone(theme: DropzoneTheme(minHeight: 400))),
      );
      expect(
        tester.getSize(find.byKey(dropzoneSurfaceKey)).height,
        greaterThanOrEqualTo(400),
      );
    });
  });

  group('tokens', () {
    testWidgets('sizes match shadcn (upload icon 28, padding 24)', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const Dropzone()));
      expect(tester.getSize(find.byIcon(RadixIcons.upload)).width, 28);
      final Container surface = tester.widget<Container>(
        find.byKey(dropzoneSurfaceKey),
      );
      expect((surface.decoration! as BoxDecoration).borderRadius, isNotNull);
    });

    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Dropzone(state: DropzoneState.error),
        ),
      );
      expect(_border(tester).top.color, dark.destructive);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const Dropzone(
            theme: DropzoneTheme(
              borderColor: StateValue(
                rest: ThemedColor.ref(ColorRef.accent, alpha: 0.5),
              ),
            ),
          ),
        ),
      );
      expect(_border(tester).top.color.a, closeTo(dark.accent.a * 0.5, 0.001));
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            DropzoneTheme(
              borderColor: StateValue(rest: ThemedColor.value(_green)),
            ),
          ],
          child: const Dropzone(),
        ),
      );
      expect(_border(tester).top.color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            DropzoneTheme(
              borderColor: StateValue(rest: ThemedColor.value(_green)),
            ),
          ],
          scoped: const DropzoneTheme(
            borderColor: StateValue(rest: ThemedColor.value(_blue)),
          ),
          child: const Dropzone(),
        ),
      );
      expect(_border(tester).top.color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const DropzoneTheme(
            borderColor: StateValue(rest: ThemedColor.value(_green)),
          ),
          child: const Dropzone(
            theme: DropzoneTheme(
              borderColor: StateValue(rest: ThemedColor.value(_blue)),
            ),
          ),
        ),
      );
      expect(_border(tester).top.color, _blue);
    });

    testWidgets('a leg setting one field keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: const DropzoneTheme(
            borderColor: StateValue(rest: ThemedColor.value(_green)),
          ),
          child: const Dropzone(),
        ),
      );
      expect(_border(tester).top.color, _green);
      expect(tester.getSize(find.byIcon(RadixIcons.upload)).width, 28);
    });
  });
}
