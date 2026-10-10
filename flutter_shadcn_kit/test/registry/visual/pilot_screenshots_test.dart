// Visual screenshot harness for the Phase 3 pilot components (brief P3-V).
//
// Runs under `flutter test`: each scene is rendered at device pixel ratio 2
// inside `ShadcnTheme` + `ComponentThemes`, captured through a
// `RepaintBoundary` and written as a real PNG to
// `rearch/screenshots/pilot/<scene>_<light|dark>.png`.
//
// Fonts: the repo's Geist sans/mono (`assets/fonts/Geist-Regular.otf`,
// `GeistMono-Regular.otf`, family names GeistSans/GeistMono the default
// `Typography.geist()` expects) plus the Lucide icon font are registered with
// `FontLoader`, so text and icons render as glyphs instead of the fallback.
//
// Read-only with respect to component code: it observes and captures only.
//
// Light/dark scenes use the shadcn default fallback colours; the `preset_*`
// scenes reuse the same widgets with the `violet-bloom` preset tokens/fonts.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/button/preview.dart'
    show buttonPreviews;
import 'package:flutter_shadcn_kit/registry/components/dialog/dialog.dart';
import 'package:flutter_shadcn_kit/registry/components/dialog/dialog_style.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/input/preview.dart'
    show inputPreviews;
import 'package:flutter_shadcn_kit/registry/components/toggle/preview.dart'
    show togglePreviews;
import 'package:flutter_shadcn_kit/registry/components/toggle/toggle.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/gap.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/primitives/input_features/adornment_features.dart';
import 'package:flutter_shadcn_kit/registry/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry/primitives/input_features/numeric_features.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry/theme/tokens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../themes/generated_theme.dart';
import '../themes/schema_check.dart';

/// Device pixel ratio of every capture.
const double _dpr = 2.0;

/// Preset used for the non-default `preset_*` scenes.
const String _presetId = 'violet-bloom';

/// Hover target key inside [_ButtonScene].
const ValueKey<String> _hoverKey = ValueKey<String>('pilot.button.hover');

/// Output folder `$KIT/rearch/screenshots/pilot`, found by walking up to the
/// directory that contains REARCHITECTURE_PLAN.md.
Directory get _outDir {
  var dir = Directory.current;
  while (dir.path != dir.parent.path) {
    if (File('${dir.path}/REARCHITECTURE_PLAN.md').existsSync()) {
      break;
    }
    dir = dir.parent;
  }
  return Directory('${dir.path}/rearch/screenshots/pilot');
}

void main() {
  setUpAll(() async {
    await _loadFonts();
    _outDir.createSync(recursive: true);
  });

  setUp(() {
    // `flutter test` reports `defaultTargetPlatform == android` with no mouse
    // connected, so `FocusManager.highlightMode` starts out `touch` and
    // `FocusableActionDetector` caches `_canShowHighlight = false` — the
    // keyboard focus ring then never renders, even though the node *is*
    // focused. Mouse pointers never flip that mode (only key events do), so
    // force the desktop behaviour the screenshots are meant to document.
    // This has to run per test: `flutter_test` installs a brand new
    // `FocusManager()` after every test, which resets the strategy.
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  group('button', () {
    _scene(
      name: 'button',
      size: const Size(760, 460),
      build: () => const _ButtonScene(),
      interact: _hoverButton,
    );
    _scene(
      name: 'button_group',
      size: const Size(460, 340),
      build: () => const _ButtonGroupScene(),
    );
    _scene(
      name: 'toggle',
      size: const Size(560, 200),
      build: () => const _ToggleScene(),
    );
  });

  group('input', () {
    _scene(
      name: 'input',
      size: const Size(480, 760),
      build: () => const _InputScene(),
    );
    // Kept as its own scene: the menu needs the field focused, which would
    // hide the keyboard-focus example in the scene above.
    _scene(
      name: 'input_context_menu',
      size: const Size(460, 320),
      build: () => const _InputContextMenuScene(),
      interact: _openContextMenu,
    );
    // Legacy name for the same capture: `input_menu_*.png` predate the
    // `input_context_menu` rename and would otherwise go stale again.
    _scene(
      name: 'input_menu',
      size: const Size(460, 320),
      build: () => const _InputContextMenuScene(),
      interact: _openContextMenu,
    );
  });

  group('dialog', () {
    _scene(
      name: 'dialog',
      size: const Size(400, 300),
      build: () => const _DialogScene(),
    );
  });

  group('preset (violet-bloom)', () {
    _scene(
      name: 'preset_button',
      size: const Size(760, 460),
      preset: true,
      build: () => const _ButtonScene(),
    );
    _scene(
      name: 'preset_input',
      size: const Size(480, 760),
      preset: true,
      build: () => const _InputScene(),
    );
    _scene(
      name: 'preset_dialog',
      size: const Size(400, 300),
      preset: true,
      build: () => const _DialogScene(),
    );
  });

  // The components' own `preview.dart` named examples (brief: "use each
  // component's preview.dart where it already covers a scene"). Each scene is
  // the default example of the component's P6-F3 preview contract.
  group('preview examples', () {
    _scene(
      name: 'preview_button',
      size: const Size(900, 1000),
      build: () => _PreviewScene(buttonPreviews.first),
    );
    _scene(
      name: 'preview_input',
      size: const Size(900, 1000),
      build: () => _PreviewScene(inputPreviews.first),
    );
    _scene(
      name: 'preview_toggle',
      size: const Size(900, 640),
      build: () => _PreviewScene(togglePreviews.first),
    );
  });
}

// ---------------------------------------------------------------------------
// Fonts.
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Theme selection.
// ---------------------------------------------------------------------------

/// shadcn default fallback colours with default tokens.
ShadcnThemeData _baseTheme(Brightness brightness) => ShadcnThemeData(
  colors: brightness == Brightness.dark
      ? ShadcnColors.darkFallback
      : ShadcnColors.lightFallback,
);

/// The [_presetId] preset, generated from its JSON like the CLI would.
ShadcnThemeData _presetTheme(Brightness brightness) {
  final generated = loadGeneratedTheme('$themesDir/$_presetId.json');
  return ShadcnThemeData(
    colors: brightness == Brightness.dark
        ? generated.darkColors
        : generated.lightColors,
    tokens: brightness == Brightness.dark
        ? generated.darkTokens
        : generated.lightTokens,
    fonts: generated.fonts ?? ShadcnFonts.empty,
  );
}

// ---------------------------------------------------------------------------
// Frame + capture.
// ---------------------------------------------------------------------------

/// Builds one named docs example of a component's preview contract.
class _PreviewScene extends StatelessWidget {
  const _PreviewScene(this.preview);

  final ComponentPreview preview;

  @override
  Widget build(BuildContext context) => Builder(builder: preview.builder);
}

/// Wraps [child] in the theme legs, directionality, text style and an
/// [Overlay] (the input context menu needs one).
Widget _frame(ShadcnThemeData data, Size size, Widget child) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: const <ComponentThemeData>[
        ButtonTheme(),
        ToggleTheme(),
        InputTheme(),
        DialogTheme(),
      ],
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
                child: ShadcnLayer(
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: ColoredBox(
                      color: data.colors.background,
                      child: Overlay(
                        initialEntries: <OverlayEntry>[
                          OverlayEntry(builder: (_) => child),
                        ],
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
void _scene({
  required String name,
  required Size size,
  required Widget Function() build,
  bool preset = false,
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
        preset: preset,
        child: build(),
        interact: interact,
      );
    });
  }
}

/// Renders [child] at [size] and writes the PNG.
Future<void> _capture(
  WidgetTester tester, {
  required String scene,
  required Brightness brightness,
  required Size size,
  required bool preset,
  required Widget child,
  Future<void> Function(WidgetTester tester)? interact,
}) async {
  tester.view.devicePixelRatio = _dpr;
  tester.view.physicalSize = size * _dpr;
  addTearDown(tester.view.reset);

  final key = GlobalKey();
  final data = preset ? _presetTheme(brightness) : _baseTheme(brightness);
  // `AutomatedTestWidgetsFlutterBinding` forces debugDisableShadows = true
  // (flutter_test binding.dart: `disableShadows => true`), which strips the
  // blur from every BoxShadow: only the spread-inset rect survives, hidden
  // behind its own card, so `shadow-lg` would be invisible in the PNGs.
  // Enable shadows for the capture, then restore the value before the
  // framework's invariant check runs at the end of the test body.
  debugDisableShadows = false;
  await tester.pumpWidget(
    RepaintBoundary(key: key, child: _frame(data, size, child)),
  );
  await tester.pump();

  if (interact != null) {
    await interact(tester);
    await tester.pump();
  }
  // Settle finite animations (focus ring, dialog route) without
  // `pumpAndSettle`, which the focused-field cursor blink would hang.
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

/// Mouse-hovers the keyed button so its hover state is captured.
Future<void> _hoverButton(WidgetTester tester) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(find.byKey(_hoverKey)));
  await tester.pump();
}

/// Opens the selection context menu of the last input in the scene.
Future<void> _openContextMenu(WidgetTester tester) async {
  final editable = find.byType(EditableText).last;
  tester.state<EditableTextState>(editable).toggleToolbar();
  await tester.pump(const Duration(milliseconds: 120));
}

// ---------------------------------------------------------------------------
// Scene widgets.
// ---------------------------------------------------------------------------

/// Section label shared by the scenes.
Widget _heading(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Text(
    label,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  ),
);

/// Every button variant and size plus disabled / focused / hovered states.
class _ButtonScene extends StatelessWidget {
  const _ButtonScene();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _heading('Variants'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              for (final variant in ButtonVariant.values)
                Button(
                  variant: variant,
                  onPressed: () {},
                  child: Text(variant.name),
                ),
            ],
          ),
          const Gap(20),
          _heading('Sizes (primary)'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (final size in ButtonSize.values)
                Button(
                  size: size,
                  onPressed: () {},
                  child: size == ButtonSize.icon
                      ? const Icon(LucideIcons.settings, size: 16)
                      : Text(size.name),
                ),
            ],
          ),
          const Gap(20),
          _heading('Leading / trailing / disabled'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              Button(
                leading: const Icon(LucideIcons.plus, size: 16),
                onPressed: () {},
                child: const Text('Add item'),
              ),
              Button(
                variant: ButtonVariant.outline,
                trailing: const Icon(LucideIcons.chevronRight, size: 16),
                onPressed: () {},
                child: const Text('Next'),
              ),
              const Button(
                variant: ButtonVariant.outline,
                child: Text('Disabled outline'),
              ),
              const Button(
                variant: ButtonVariant.ghost,
                child: Text('Disabled ghost'),
              ),
            ],
          ),
          const Gap(20),
          _heading('Keyboard focus ring + mouse hover'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              Button(
                autofocus: true,
                variant: ButtonVariant.outline,
                onPressed: () {},
                child: const Text('Focused (keyboard)'),
              ),
              Button(
                key: _hoverKey,
                onPressed: () {},
                child: const Text('Hovered (mouse)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Connected groups: horizontal and vertical.
class _ButtonGroupScene extends StatelessWidget {
  const _ButtonGroupScene();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _heading('Horizontal (outline, joined)'),
          ButtonGroup(
            children: <Widget>[
              Button(
                variant: ButtonVariant.outline,
                onPressed: () {},
                child: const Text('Left'),
              ),
              Button(
                variant: ButtonVariant.outline,
                onPressed: () {},
                child: const Text('Middle'),
              ),
              Button(
                variant: ButtonVariant.outline,
                onPressed: () {},
                child: const Text('Right'),
              ),
            ],
          ),
          const Gap(24),
          _heading('Vertical (secondary, joined)'),
          ButtonGroup.vertical(
            children: <Widget>[
              Button(
                variant: ButtonVariant.secondary,
                onPressed: () {},
                child: const Text('Top'),
              ),
              Button(
                variant: ButtonVariant.secondary,
                onPressed: () {},
                child: const Text('Middle'),
              ),
              Button(
                variant: ButtonVariant.secondary,
                onPressed: () {},
                child: const Text('Bottom'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Toggle off / on / disabled plus an icon toggle.
class _ToggleScene extends StatelessWidget {
  const _ToggleScene();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _heading('Off / on / disabled'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Toggle(value: false, onChanged: (_) {}, child: const Text('Off')),
              Toggle(value: true, onChanged: (_) {}, child: const Text('On')),
              const Toggle(value: true, child: Text('On (disabled)')),
              const Toggle(value: false, child: Text('Off (disabled)')),
              Toggle(
                value: true,
                onChanged: (_) {},
                child: const Icon(LucideIcons.star, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Labelled input row.
Widget _field(String label, Widget input) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _heading(label),
      SizedBox(width: 340, child: input),
    ],
  ),
);

/// Error validator for the error-state field.
String? _emailError(String? value) =>
    (value ?? '').contains('@') ? null : 'Enter a valid email address.';

/// Input states and the built-in features, one field each.
class _InputScene extends StatefulWidget {
  const _InputScene();

  @override
  State<_InputScene> createState() => _InputSceneState();
}

class _InputSceneState extends State<_InputScene> {
  final TextEditingController _filled = TextEditingController(
    text: 'shadcn@example.com',
  );
  final TextEditingController _features = TextEditingController(
    text: 'Clear me',
  );
  final FocusNode _focusNode = FocusNode(debugLabel: 'pilot.input.focused');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _filled.dispose();
    _features.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _field('Empty with placeholder', const Input(hintText: 'Email')),
          _field('Filled', Input(controller: _filled)),
          _field(
            'Focused (keyboard ring)',
            Input(focusNode: _focusNode, initialValue: 'Focused value'),
          ),
          _field(
            'Disabled',
            const Input(enabled: false, initialValue: 'Disabled value'),
          ),
          _field(
            'Error state',
            Input(
              initialValue: 'not-an-email',
              autovalidateMode: FormValidationMode.initial,
              validator: _emailError,
            ),
          ),
          _field(
            'Clear feature',
            Input(
              controller: _features,
              features: const <InputFeature>[InputClearFeature()],
            ),
          ),
          _field(
            'Password feature',
            const Input(
              obscureText: true,
              initialValue: 'supersecret',
              features: <InputFeature>[InputPasswordToggleFeature()],
            ),
          ),
          _field(
            'Spinner feature',
            const Input(
              keyboardType: TextInputType.number,
              initialValue: '3',
              features: <InputFeature>[InputSpinnerFeature(min: 0, max: 10)],
            ),
          ),
        ],
      ),
    );
  }
}

/// A selected input with its context menu open.
class _InputContextMenuScene extends StatefulWidget {
  const _InputContextMenuScene();

  @override
  State<_InputContextMenuScene> createState() => _InputContextMenuSceneState();
}

class _InputContextMenuSceneState extends State<_InputContextMenuScene> {
  final TextEditingController _controller = TextEditingController(
    text: 'Select this text',
  );
  final FocusNode _focusNode = FocusNode(debugLabel: 'pilot.input.menu');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _focusNode.requestFocus();
      _controller.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 11,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 150, 24, 24),
      child: _field(
        'Context menu over a selection',
        Input(controller: _controller, focusNode: _focusNode),
      ),
    );
  }
}

/// An open dialog on a 400x300 surface; the barrier covers the page below.
class _DialogScene extends StatelessWidget {
  const _DialogScene();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (_, _, _) => const _DialogPage(),
      ),
    );
  }
}

class _DialogPage extends StatefulWidget {
  const _DialogPage();

  @override
  State<_DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<_DialogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showShadcnDialog<void>(
        context: context,
        builder: (_) => const _DialogCard(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Paint the page in the ambient background explicitly: a transparent
    // page would let the capture rely on the ancestor `ColoredBox`, hiding a
    // stale-theme regression where the route subtree falls back to light.
    final background = ShadcnTheme.of(context).colors.background;
    return ColoredBox(color: background, child: const SizedBox.expand());
  }
}

/// Dialog content: title, body copy and two caller-supplied buttons.
class _DialogCard extends StatelessWidget {
  const _DialogCard();

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Delete this project?',
          style: TextStyle(
            color: colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(16),
        Text(
          'This action cannot be undone. It permanently removes the project '
          'and all of its contents.',
          style: TextStyle(color: colors.mutedForeground, fontSize: 14),
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Cancel'),
            ),
            const Gap(8),
            Button(
              variant: ButtonVariant.destructive,
              onPressed: () {},
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}
