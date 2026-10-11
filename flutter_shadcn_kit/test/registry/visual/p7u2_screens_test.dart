// P7-U2 screenshots: the user-reported spacing bugs and their fixes.
//
// Radio group item gap (the Free/Pro/Team rows touched before), the date and
// time picker dialogs (a 480px stretched frame before, now a card that hugs
// the calendar / the columns) and a composed form (label → control → helper
// gaps, radio and checkbox rows).
//
// Renders under `flutter test` like `pilot_screenshots_test.dart`: the fonts
// are the repo's own, `debugDisableShadows` is re-enabled for the capture, and
// each scene writes one PNG per brightness into
// `rearch/design/ours/screens/p7u2-*_<light|dark>.png`.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/checkbox/checkbox.dart';
import 'package:flutter_shadcn_kit/registry/components/date_picker/date_picker.dart';
import 'package:flutter_shadcn_kit/registry/components/form/form.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/radio_group/radio_group.dart';
import 'package:flutter_shadcn_kit/registry/components/time_picker/time_picker.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Device pixel ratio of every capture.
const double _dpr = 2.0;

/// Output folder `$KIT/rearch/design/ours/screens`, found by walking up to the
/// directory that contains REARCHITECTURE_PLAN.md.
Directory get _outDir {
  Directory dir = Directory.current;
  while (dir.path != dir.parent.path) {
    if (File('${dir.path}/REARCHITECTURE_PLAN.md').existsSync()) {
      return Directory('${dir.path}/rearch/design/ours/screens');
    }
    dir = dir.parent;
  }
  return Directory('${Directory.current.path}/rearch/design/ours/screens');
}

void main() {
  setUpAll(() async {
    await _loadFonts();
    _outDir.createSync(recursive: true);
  });

  setUp(() {
    // Same reason as the pilot harness: `flutter test` reports a touch
    // platform, which would suppress the keyboard focus ring.
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  group('radio group', () {
    _scene(
      name: 'p7u2-radio-group',
      size: const Size(760, 560),
      build: () => const _RadioGroupScene(),
    );
  });

  group('pickers', () {
    _scene(
      name: 'p7u2-date-picker-dialog',
      size: const Size(1440, 900),
      build: () => const _DatePickerScene(),
      interact: (WidgetTester tester) => _tap(tester, find.text('Pick a date')),
    );
    _scene(
      name: 'p7u2-time-picker-dialog',
      size: const Size(1440, 900),
      build: () => const _TimePickerScene(),
      interact: (WidgetTester tester) =>
          _tap(tester, find.text('Select a time')),
    );
  });

  group('form', () {
    _scene(
      name: 'p7u2-form',
      size: const Size(560, 620),
      build: () => const _FormScene(),
    );
  });
}

/// Registers the repo's Geist + Lucide fonts on the test engine.
Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> assets) async {
    final loader = FontLoader(family);
    for (final asset in assets) {
      final bytes = File('${Directory.current.path}/$asset').readAsBytesSync();
      loader.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  await load('GeistSans', const <String>['assets/fonts/Geist-Regular.otf']);
  await load('GeistMono', const <String>['assets/fonts/GeistMono-Regular.otf']);
  await load('LucideIcons', const <String>['assets/fonts/lucide.ttf']);
}

/// Shadcn default fallback colours with default tokens.
ShadcnThemeData _theme(Brightness brightness) => ShadcnThemeData(
  colors: brightness == Brightness.dark
      ? ShadcnColors.darkFallback
      : ShadcnColors.lightFallback,
);

/// Wraps [child] in the theme legs, directionality, text style and an
/// [Overlay], so a prompt has somewhere to push its route.
Widget _frame(ShadcnThemeData data, Size size, Widget child) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: const <ComponentThemeData>[],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(devicePixelRatio: _dpr),
          child: Builder(
            builder: (BuildContext context) {
              final theme = ShadcnTheme.of(context);
              return DefaultTextStyle(
                style: theme.typography.sans.copyWith(
                  color: theme.colors.foreground,
                  fontSize: 14,
                ),
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: ColoredBox(
                    color: data.colors.background,
                    // A navigator, so a picker prompt can push its route: the
                    // picker scenes tap their own trigger.
                    child: Navigator(
                      onGenerateRoute: (RouteSettings settings) =>
                          PageRouteBuilder<void>(
                            settings: settings,
                            pageBuilder: (_, _, _) => child,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

/// Registers one scene for both brightnesses.
///
/// [interact] runs after the first frame, like the pilot harness: the picker
/// scenes tap their own trigger to push the dialog route.
void _scene({
  required String name,
  required Size size,
  required Widget Function() build,
  Future<void> Function(WidgetTester tester)? interact,
}) {
  for (final brightness in const <Brightness>[
    Brightness.light,
    Brightness.dark,
  ]) {
    testWidgets('$name ${brightness.name}', (WidgetTester tester) async {
      await _capture(
        tester,
        scene: name,
        brightness: brightness,
        size: size,
        child: build(),
        interact: interact,
      );
    });
  }
}

/// Taps [target] with a mouse, so a hover/press state reads in the capture.
Future<void> _tap(WidgetTester tester, Finder target) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(target));
  await gesture.down(tester.getCenter(target));
  await gesture.up();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

/// Renders [child] at [size] and writes the PNG.
Future<void> _capture(
  WidgetTester tester, {
  required String scene,
  required Brightness brightness,
  required Size size,
  required Widget child,
  Future<void> Function(WidgetTester tester)? interact,
}) async {
  tester.view.devicePixelRatio = _dpr;
  tester.view.physicalSize = size * _dpr;
  addTearDown(tester.view.reset);

  final key = GlobalKey();
  // `flutter_test` strips box-shadow blurs; re-enable them for the capture so
  // `shadow-lg` on the dialog card reads.
  debugDisableShadows = false;
  await tester.pumpWidget(
    RepaintBoundary(key: key, child: _frame(_theme(brightness), size, child)),
  );
  await tester.pump();
  if (interact != null) {
    await interact(tester);
    await tester.pump();
  }
  // Settle finite animations (route, focus ring) without `pumpAndSettle`,
  // which the cursor blink of a focused field would hang.
  await tester.pump(const Duration(milliseconds: 320));

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: _dpr),
  );
  final ByteData? bytes = await tester.runAsync<ByteData?>(
    () => image!.toByteData(format: ui.ImageByteFormat.png),
  );
  final file = File(
    '${_outDir.path}/${scene}_'
    '${brightness == Brightness.dark ? 'dark' : 'light'}.png',
  );
  file.writeAsBytesSync(bytes!.buffer.asUint8List());
  debugDisableShadows = true;
}

/// Section label shared by the scenes.
Widget _heading(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Text(
    label,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  ),
);

/// Scene: the radio rows and the card items of one group, with the 12px item
/// gap (shadcn `grid gap-3`) the user reported missing.
class _RadioGroupScene extends StatelessWidget {
  const _RadioGroupScene();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _heading('Radio group'),
          const _RadioRows(),
          SizedBox(height: theme.spacing.xl),
          _heading('Card items'),
          const _RadioCards(),
        ],
      ),
    );
  }
}

class _RadioRows extends StatefulWidget {
  const _RadioRows();

  @override
  State<_RadioRows> createState() => _RadioRowsState();
}

class _RadioRowsState extends State<_RadioRows> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) => ShadcnRadioGroup<String>(
    value: _plan,
    onChanged: (String value) => setState(() => _plan = value),
    items: const <Widget>[
      RadioItem<String>(value: 'free', label: Text('Free')),
      RadioItem<String>(value: 'pro', label: Text('Pro')),
      RadioItem<String>(value: 'team', label: Text('Team')),
    ],
  );
}

class _RadioCards extends StatefulWidget {
  const _RadioCards();

  @override
  State<_RadioCards> createState() => _RadioCardsState();
}

class _RadioCardsState extends State<_RadioCards> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) => ShadcnRadioGroup<String>(
    value: _plan,
    onChanged: (String value) => setState(() => _plan = value),
    items: <Widget>[
      for (final String plan in <String>['free', 'pro'])
        RadioCard<String>(
          value: plan,
          child: Text(
            plan,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
    ],
  );
}

/// Scene: the date picker dialog, opened by tapping its trigger.
class _DatePickerScene extends StatelessWidget {
  const _DatePickerScene();

  @override
  Widget build(BuildContext context) =>
      Center(child: DatePicker(value: null, onChanged: (_) {}));
}

/// Scene: the time picker dialog, opened by tapping its trigger.
class _TimePickerScene extends StatelessWidget {
  const _TimePickerScene();

  @override
  Widget build(BuildContext context) => Center(
    child: TimePicker(value: null, onChanged: (_) {}, use24HourFormat: true),
  );
}

/// Scene: a composed form — label, control, helper text, a radio group and a
/// checkbox row, at the audited gaps.
class _FormScene extends StatelessWidget {
  const _FormScene();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: ShadcnForm(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ShadcnFormField<String>(
              key: const FormKey<String>('name'),
              label: const Text('Name'),
              hint: const Text('As it appears on the card'),
              child: const Input(placeholder: Text('Ada Lovelace')),
            ),
            SizedBox(height: theme.spacing.md),
            ShadcnFormField<String>(
              key: const FormKey<String>('plan'),
              label: const Text('Plan'),
              child: const _FormRadioGroup(),
            ),
            SizedBox(height: theme.spacing.md),
            ShadcnFormField<CheckboxValue>(
              key: const FormKey<CheckboxValue>('terms'),
              label: const SizedBox.shrink(),
              child: const Checkbox(
                value: CheckboxValue.checked,
                label: Text('Accept terms and conditions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormRadioGroup extends StatefulWidget {
  const _FormRadioGroup();

  @override
  State<_FormRadioGroup> createState() => _FormRadioGroupState();
}

class _FormRadioGroupState extends State<_FormRadioGroup> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) => ShadcnRadioGroup<String>(
    value: _plan,
    onChanged: (String value) => setState(() => _plan = value),
    items: const <Widget>[
      RadioItem<String>(value: 'free', label: Text('Free')),
      RadioItem<String>(value: 'pro', label: Text('Pro')),
      RadioItem<String>(value: 'team', label: Text('Team')),
    ],
  );
}
