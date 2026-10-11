// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/components/<id>/preview.dart
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// One display-code entry per ComponentPreview element: the imports
// for the component plus the example builder and the private
// helpers it uses (read with package:analyzer, see
// tool/src/example_sources.dart). `kExampleSources` drives the
// per-example Code tabs (first entry of each list is the default).

/// One named example plus its display code.
class DocsExampleSource {
  /// Creates the source.
  const DocsExampleSource({
    required this.name,
    this.description,
    required this.builder,
    required this.code,
  });

  /// Label shown on the card (`Default`, `With groups`).
  final String name;

  /// Optional one-line explanation under the card heading.
  final String? description;

  /// Builder expression (`_buttonDefault`).
  final String builder;

  /// Display code: imports plus the example body, verbatim.
  final String code;
}

/// Example sources keyed by component id, in declaration order.
const Map<String, List<DocsExampleSource>>
kExampleSources = <String, List<DocsExampleSource>>{
  'border_loading': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Sweep',
      builder: '_borderLoadingSweep',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/border_loading/border_loading.dart';

/// A labelled card carrying the loading border.
Widget _borderLoadingCard(BuildContext context, String label, Widget child) {
  final theme = ShadcnTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      Gap(theme.spacing.sm),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
      ),
    ],
  );
}

/// The default rotating sweep.
Widget _borderLoadingSweep(BuildContext context) {
  return Center(
    child: _borderLoadingCard(
      context,
      'sweep',
      const BorderLoading(child: SizedBox(width: 120, height: 48)),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Progress',
      builder: '_borderLoadingProgress',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/border_loading/border_loading.dart';

/// A labelled card carrying the loading border.
Widget _borderLoadingCard(BuildContext context, String label, Widget child) {
  final theme = ShadcnTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      Gap(theme.spacing.sm),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
      ),
    ],
  );
}

/// Determinate progress around the outline.
Widget _borderLoadingProgress(BuildContext context) {
  return Center(
    child: _borderLoadingCard(
      context,
      'progress',
      const BorderLoading(
        mode: BorderLoadingMode.progress,
        progress: 0.6,
        child: SizedBox(width: 120, height: 48),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Outline',
      builder: '_borderLoadingOutline',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/border_loading/border_loading.dart';

/// A labelled card carrying the loading border.
Widget _borderLoadingCard(BuildContext context, String label, Widget child) {
  final theme = ShadcnTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      Gap(theme.spacing.sm),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
      ),
    ],
  );
}

/// A static outline, no animation.
Widget _borderLoadingOutline(BuildContext context) {
  return Center(
    child: _borderLoadingCard(
      context,
      'static',
      const BorderLoading(
        mode: BorderLoadingMode.staticBorder,
        child: SizedBox(width: 120, height: 48),
      ),
    ),
  );
}
''',
    ),
  ],
  'dot_indicator': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_dotIndicatorDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';

/// Horizontal dots the example taps through.
class _DotIndicatorHorizontalDots extends StatefulWidget {
  const _DotIndicatorHorizontalDots();

  @override
  State<_DotIndicatorHorizontalDots> createState() =>
      _DotIndicatorHorizontalDotsState();
}

class _DotIndicatorHorizontalDotsState
    extends State<_DotIndicatorHorizontalDots> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DotIndicator(
          index: _index,
          length: 5,
          onChanged: (int value) => setState(() => _index = value),
        ),
        Gap(theme.spacing.md),
        Text(
          'index $_index',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
        Gap(theme.spacing.md),
        DotIndicator(index: 1, length: 5),
        Gap(theme.spacing.sm),
        Text(
          'read-only (no click cursor, no tap target)',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
      ],
    );
  }
}

Widget _dotIndicatorDefault(BuildContext context) =>
    const _DotIndicatorHorizontalDots();
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_dotIndicatorVertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';

/// Vertical dots beside the horizontal ones.
class _DotIndicatorVerticalDots extends StatefulWidget {
  const _DotIndicatorVerticalDots();

  @override
  State<_DotIndicatorVerticalDots> createState() =>
      _DotIndicatorVerticalDotsState();
}

class _DotIndicatorVerticalDotsState extends State<_DotIndicatorVerticalDots> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DotIndicator(
          index: _index,
          length: 3,
          direction: Axis.vertical,
          onChanged: (int value) => setState(() => _index = value),
        ),
        Gap(theme.spacing.xl),
        DotIndicator(
          index: 1,
          length: 3,
          direction: Axis.vertical,
          onChanged: (int value) => setState(() => _index = value),
        ),
      ],
    );
  }
}

Widget _dotIndicatorVertical(BuildContext context) =>
    const _DotIndicatorVerticalDots();
''',
    ),
    DocsExampleSource(
      name: 'Themed dots',
      builder: '_dotIndicatorThemed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';

/// A scoped theme leg: bigger accent dots.
Widget _dotIndicatorThemed(BuildContext context) {
  return ComponentTheme<DotIndicatorTheme>(
    data: const DotIndicatorTheme(
      active: DotStyle(
        background: StateValue(rest: ThemedColor.ref(ColorRef.accent)),
        size: 18,
      ),
      spacing: 14,
    ),
    child: DotIndicator(index: 1, length: 5, onChanged: (int value) {}),
  );
}
''',
    ),
  ],
  'text_animate': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/text_animate/text_animate.dart';

const String _sample = 'Ship a new build to production.';

/// Opacity-only entrance.
Widget _default(BuildContext context) {
  return const TextAnimate(text: _sample, effect: TextAnimateEffect.fade());
}
''',
    ),
    DocsExampleSource(
      name: 'Slide',
      builder: '_slide',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/text_animate/text_animate.dart';

const String _sample = 'Ship a new build to production.';

/// Vertical slide entrance.
Widget _slide(BuildContext context) {
  return const TextAnimate(text: _sample, effect: TextAnimateEffect.slide());
}
''',
    ),
    DocsExampleSource(
      name: 'Blur',
      builder: '_blur',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/text_animate/text_animate.dart';

const String _sample = 'Ship a new build to production.';

/// Blur-to-sharp entrance.
Widget _blur(BuildContext context) {
  return const TextAnimate(text: _sample, effect: TextAnimateEffect.blur());
}
''',
    ),
    DocsExampleSource(
      name: 'Scramble',
      builder: '_scramble',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/text_animate/text_animate.dart';

const String _sample = 'Ship a new build to production.';

/// Scramble-then-resolve entrance.
Widget _scramble(BuildContext context) {
  return const TextAnimate(text: _sample, effect: TextAnimateEffect.scramble());
}
''',
    ),
    DocsExampleSource(
      name: 'Words',
      builder: '_words',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/text_animate/text_animate.dart';

const String _sample = 'Ship a new build to production.';

/// Word-by-word slide with a blinking cursor.
Widget _words(BuildContext context) {
  return const TextAnimate(
    text: _sample,
    animateByWord: true,
    effect: TextAnimateEffect.slide(),
    cursor: TextAnimateCursor.blink(),
  );
}
''',
    ),
  ],
  'button': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_buttonDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: Alignment.center,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonDefault(BuildContext context) =>
    _buttonExample(context, ButtonVariant.primary, 'Button');
''',
    ),
    DocsExampleSource(
      name: 'Secondary',
      builder: '_buttonSecondary',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: Alignment.center,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonSecondary(BuildContext context) =>
    _buttonExample(context, ButtonVariant.secondary, 'Secondary');
''',
    ),
    DocsExampleSource(
      name: 'Outline',
      builder: '_buttonOutline',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: Alignment.center,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonOutline(BuildContext context) =>
    _buttonExample(context, ButtonVariant.outline, 'Outline');
''',
    ),
    DocsExampleSource(
      name: 'Ghost',
      builder: '_buttonGhost',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: Alignment.center,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonGhost(BuildContext context) =>
    _buttonExample(context, ButtonVariant.ghost, 'Ghost');
''',
    ),
    DocsExampleSource(
      name: 'Link',
      builder: '_buttonLink',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: Alignment.center,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonLink(BuildContext context) =>
    _buttonExample(context, ButtonVariant.link, 'Link');
''',
    ),
    DocsExampleSource(
      name: 'Destructive',
      builder: '_buttonDestructive',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: Alignment.center,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonDestructive(BuildContext context) =>
    _buttonExample(context, ButtonVariant.destructive, 'Delete');
''',
    ),
    DocsExampleSource(
      name: 'Icon',
      builder: '_buttonIcon',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

/// Icon-only button (shadcn `size="icon"`).
Widget _buttonIcon(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Button(
      size: ButtonSize.icon,
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Icon(LucideIcons.settings, size: 16),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With icon',
      builder: '_buttonWithIcon',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

/// Leading and trailing icon buttons.
Widget _buttonWithIcon(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.sm,
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
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Sizes',
      builder: '_buttonSizes',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

/// The size scale in one row (shadcn shows the sizes together).
Widget _buttonSizes(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.sm,
    runSpacing: spacing.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      for (final size in ButtonSize.values)
        if (size != ButtonSize.icon)
          Button(size: size, onPressed: () {}, child: Text(size.name)),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Loading',
      builder: '_buttonLoading',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

/// A pending button: disabled with a loader glyph, the shadcn pattern.
Widget _buttonLoading(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Button(
      enabled: false,
      leading: const Icon(LucideIcons.loaderCircle, size: 16),
      child: const Text('Loading...'),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_buttonDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';

/// A disabled button.
Widget _buttonDisabled(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Button(enabled: false, child: const Text('Disabled')),
  );
}
''',
    ),
  ],
  'toggle': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_toggleDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/toggle/toggle.dart';

/// Controlled toggle: the example owns the value.
class _ToggleControlledToggle extends StatefulWidget {
  const _ToggleControlledToggle();

  @override
  State<_ToggleControlledToggle> createState() =>
      _ToggleControlledToggleState();
}

class _ToggleControlledToggleState extends State<_ToggleControlledToggle> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Toggle(
        value: _value,
        onChanged: (bool value) => setState(() => _value = value),
        child: Text(_value ? 'On' : 'Off'),
      ),
    );
  }
}

Widget _toggleDefault(BuildContext context) => const _ToggleControlledToggle();
''',
    ),
    DocsExampleSource(
      name: 'Group',
      builder: '_toggleGroup',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/toggle/toggle.dart';

/// A toggle group: one control per member, `gap-3` between the members.
class _ToggleGroup extends StatefulWidget {
  const _ToggleGroup();

  @override
  State<_ToggleGroup> createState() => _ToggleGroupState();
}

class _ToggleGroupState extends State<_ToggleGroup> {
  final Set<String> _active = <String>{'bold'};

  static const List<(String, IconData)> _members = <(String, IconData)>[
    ('bold', LucideIcons.bold),
    ('italic', LucideIcons.italic),
    ('underline', LucideIcons.underline),
  ];

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: spacing.md,
      children: <Widget>[
        for (final (String name, IconData icon) in _members)
          Toggle(
            value: _active.contains(name),
            onChanged: (bool value) => setState(() {
              if (value) {
                _active.add(name);
              } else {
                _active.remove(name);
              }
            }),
            child: Icon(icon, size: 16),
          ),
      ],
    );
  }
}

Widget _toggleGroup(BuildContext context) => const _ToggleGroup();
''',
    ),
    DocsExampleSource(
      name: 'Controller',
      builder: '_toggleController',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/toggle/toggle.dart';

/// Controller-driven toggles: the [ToggleController] is created inside this
/// state, so two examples can never attach one controller twice.
class _ToggleControllerToggle extends StatefulWidget {
  const _ToggleControllerToggle();

  @override
  State<_ToggleControllerToggle> createState() =>
      _ToggleControllerToggleState();
}

class _ToggleControllerToggleState extends State<_ToggleControllerToggle> {
  final ToggleController _toggleController = ToggleController();

  @override
  void dispose() {
    _toggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Toggle(controller: _toggleController, child: const Text('Controller')),
        Gap(spacing.md),
        Toggle(
          controller: _toggleController,
          child: const Icon(LucideIcons.bell, size: 16),
        ),
      ],
    );
  }
}

Widget _toggleController(BuildContext context) =>
    const _ToggleControllerToggle();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_toggleDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/toggle/toggle.dart';

/// Disabled toggles in both states.
Widget _toggleDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Toggle(value: true, child: Text('On')),
      Gap(spacing.md),
      const Toggle(value: false, onChanged: null, child: Text('Off')),
    ],
  );
}
''',
    ),
  ],
  'color_picker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_colorPickerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_picker/color_picker.dart';

/// The colour every example starts from.
const Color _colorPickerInitial = Color(0xFF2563EB);

/// Recent colours the history button replays.
const List<Color> _colorPickerRecent = <Color>[
  Color(0xFF2563EB),
  Color(0xFF22C55E),
  Color(0xFFE11D48),
];

/// One picker; owns the value it edits.
class _ColorPickerPicker extends StatefulWidget {
  const _ColorPickerPicker({
    this.showAlpha = false,
    this.showHistoryButton = false,
    this.initialMode = ColorPickerMode.rgb,
  });

  final bool showAlpha;
  final bool showHistoryButton;
  final ColorPickerMode initialMode;

  @override
  State<_ColorPickerPicker> createState() => _ColorPickerPickerState();
}

class _ColorPickerPickerState extends State<_ColorPickerPicker> {
  ColorDerivative _value = ColorDerivative.fromColor(_colorPickerInitial);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 280,
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: _colorPickerRecent,
            child: ColorPicker(
              value: _value,
              showAlpha: widget.showAlpha,
              showHistoryButton: widget.showHistoryButton,
              initialMode: widget.initialMode,
              onChanging: (ColorDerivative value) =>
                  setState(() => _value = value),
              onChanged: (ColorDerivative value) =>
                  setState(() => _value = value),
            ),
          ),
        ),
      ),
    );
  }
}

/// The default vertical picker in RGB mode.
Widget _colorPickerDefault(BuildContext context) => const _ColorPickerPicker();
''',
    ),
    DocsExampleSource(
      name: 'With alpha',
      builder: '_colorPickerAlpha',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_picker/color_picker.dart';

/// The colour every example starts from.
const Color _colorPickerInitial = Color(0xFF2563EB);

/// Recent colours the history button replays.
const List<Color> _colorPickerRecent = <Color>[
  Color(0xFF2563EB),
  Color(0xFF22C55E),
  Color(0xFFE11D48),
];

/// One picker; owns the value it edits.
class _ColorPickerPicker extends StatefulWidget {
  const _ColorPickerPicker({
    this.showAlpha = false,
    this.showHistoryButton = false,
    this.initialMode = ColorPickerMode.rgb,
  });

  final bool showAlpha;
  final bool showHistoryButton;
  final ColorPickerMode initialMode;

  @override
  State<_ColorPickerPicker> createState() => _ColorPickerPickerState();
}

class _ColorPickerPickerState extends State<_ColorPickerPicker> {
  ColorDerivative _value = ColorDerivative.fromColor(_colorPickerInitial);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 280,
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: _colorPickerRecent,
            child: ColorPicker(
              value: _value,
              showAlpha: widget.showAlpha,
              showHistoryButton: widget.showHistoryButton,
              initialMode: widget.initialMode,
              onChanging: (ColorDerivative value) =>
                  setState(() => _value = value),
              onChanged: (ColorDerivative value) =>
                  setState(() => _value = value),
            ),
          ),
        ),
      ),
    );
  }
}

/// The picker with the alpha row shown.
Widget _colorPickerAlpha(BuildContext context) =>
    const _ColorPickerPicker(showAlpha: true);
''',
    ),
    DocsExampleSource(
      name: 'HSL',
      builder: '_colorPickerHsl',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_picker/color_picker.dart';

/// The colour every example starts from.
const Color _colorPickerInitial = Color(0xFF2563EB);

/// Recent colours the history button replays.
const List<Color> _colorPickerRecent = <Color>[
  Color(0xFF2563EB),
  Color(0xFF22C55E),
  Color(0xFFE11D48),
];

/// One picker; owns the value it edits.
class _ColorPickerPicker extends StatefulWidget {
  const _ColorPickerPicker({
    this.showAlpha = false,
    this.showHistoryButton = false,
    this.initialMode = ColorPickerMode.rgb,
  });

  final bool showAlpha;
  final bool showHistoryButton;
  final ColorPickerMode initialMode;

  @override
  State<_ColorPickerPicker> createState() => _ColorPickerPickerState();
}

class _ColorPickerPickerState extends State<_ColorPickerPicker> {
  ColorDerivative _value = ColorDerivative.fromColor(_colorPickerInitial);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 280,
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: _colorPickerRecent,
            child: ColorPicker(
              value: _value,
              showAlpha: widget.showAlpha,
              showHistoryButton: widget.showHistoryButton,
              initialMode: widget.initialMode,
              onChanging: (ColorDerivative value) =>
                  setState(() => _value = value),
              onChanged: (ColorDerivative value) =>
                  setState(() => _value = value),
            ),
          ),
        ),
      ),
    );
  }
}

/// HSL mode with the recent-colour history.
Widget _colorPickerHsl(BuildContext context) => const _ColorPickerPicker(
  initialMode: ColorPickerMode.hsl,
  showHistoryButton: true,
);
''',
    ),
    DocsExampleSource(
      name: 'HSV',
      builder: '_colorPickerHsv',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_picker/color_picker.dart';

/// The colour every example starts from.
const Color _colorPickerInitial = Color(0xFF2563EB);

/// Recent colours the history button replays.
const List<Color> _colorPickerRecent = <Color>[
  Color(0xFF2563EB),
  Color(0xFF22C55E),
  Color(0xFFE11D48),
];

/// One picker; owns the value it edits.
class _ColorPickerPicker extends StatefulWidget {
  const _ColorPickerPicker({
    this.showAlpha = false,
    this.showHistoryButton = false,
    this.initialMode = ColorPickerMode.rgb,
  });

  final bool showAlpha;
  final bool showHistoryButton;
  final ColorPickerMode initialMode;

  @override
  State<_ColorPickerPicker> createState() => _ColorPickerPickerState();
}

class _ColorPickerPickerState extends State<_ColorPickerPicker> {
  ColorDerivative _value = ColorDerivative.fromColor(_colorPickerInitial);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 280,
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: _colorPickerRecent,
            child: ColorPicker(
              value: _value,
              showAlpha: widget.showAlpha,
              showHistoryButton: widget.showHistoryButton,
              initialMode: widget.initialMode,
              onChanging: (ColorDerivative value) =>
                  setState(() => _value = value),
              onChanged: (ColorDerivative value) =>
                  setState(() => _value = value),
            ),
          ),
        ),
      ),
    );
  }
}

/// HSV mode.
Widget _colorPickerHsv(BuildContext context) =>
    const _ColorPickerPicker(initialMode: ColorPickerMode.hsv);
''',
    ),
    DocsExampleSource(
      name: 'HEX',
      builder: '_colorPickerHex',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_picker/color_picker.dart';

/// The colour every example starts from.
const Color _colorPickerInitial = Color(0xFF2563EB);

/// Recent colours the history button replays.
const List<Color> _colorPickerRecent = <Color>[
  Color(0xFF2563EB),
  Color(0xFF22C55E),
  Color(0xFFE11D48),
];

/// One picker; owns the value it edits.
class _ColorPickerPicker extends StatefulWidget {
  const _ColorPickerPicker({
    this.showAlpha = false,
    this.showHistoryButton = false,
    this.initialMode = ColorPickerMode.rgb,
  });

  final bool showAlpha;
  final bool showHistoryButton;
  final ColorPickerMode initialMode;

  @override
  State<_ColorPickerPicker> createState() => _ColorPickerPickerState();
}

class _ColorPickerPickerState extends State<_ColorPickerPicker> {
  ColorDerivative _value = ColorDerivative.fromColor(_colorPickerInitial);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 280,
        child: EyeDropperLayer(
          child: RecentColorsScope(
            initialRecentColors: _colorPickerRecent,
            child: ColorPicker(
              value: _value,
              showAlpha: widget.showAlpha,
              showHistoryButton: widget.showHistoryButton,
              initialMode: widget.initialMode,
              onChanging: (ColorDerivative value) =>
                  setState(() => _value = value),
              onChanged: (ColorDerivative value) =>
                  setState(() => _value = value),
            ),
          ),
        ),
      ),
    );
  }
}

/// HEX mode.
Widget _colorPickerHex(BuildContext context) =>
    const _ColorPickerPicker(initialMode: ColorPickerMode.hex);
''',
    ),
  ],
  'avatar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Image',
      builder: '_avatarImage',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/avatar/avatar.dart';

/// A 48x48 PNG decoded from memory: the preview never hits the network, so it
/// renders identically offline and inside a widget test.
const String _avatarPhotoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAWElEQVR42u3OoRGAMBBFwdPURBHoFIaj'
    'KTS9hBL+ROTUzjz/ts7xxZ73js1x5eqIFRAQEBAQ0CKoczarYkBAQEBAQKugzhkQEBAQENAWUOMMCAgIC'
    'AhoQz/vbpR28UARAAAAAABJRU5ErkJggg==';

/// Local photo provider shared by the avatar examples.
final ImageProvider _avatarPhoto = MemoryImage(
  base64Decode(_avatarPhotoBase64),
);

/// A photo avatar, with the initials fallback next to it.
Widget _avatarImage(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Avatar(initials: 'IB', image: _avatarPhoto, size: 56),
      Gap(spacing.md),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Avatar(initials: 'AC', image: _avatarPhoto),
          Gap(spacing.sm),
          Avatar(initials: 'MK', image: _avatarPhoto, size: 40),
        ],
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Initials',
      builder: '_avatarInitials',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/avatar/avatar.dart';

/// Initials-only avatars at three sizes.
Widget _avatarInitials(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Avatar(initials: 'IB'),
      Gap(spacing.md),
      const Avatar(initials: 'AC', size: 40),
      Gap(spacing.md),
      const Avatar(initials: 'MK', size: 56),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Badge',
      builder: '_avatarBadge',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/avatar/avatar.dart';

/// An avatar carrying a status badge.
Widget _avatarBadge(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Avatar(
        initials: 'AC',
        badge: AvatarBadge(child: Icon(LucideIcons.check, size: 8)),
      ),
      Gap(spacing.md),
      const Avatar(
        initials: 'AC',
        badge: AvatarBadge(),
        badgeAlignment: AlignmentDirectional.topEnd,
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Group',
      builder: '_avatarGroup',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/avatar/avatar.dart';

/// A stack of avatars.
Widget _avatarGroup(BuildContext context) {
  return const AvatarGroup(
    children: <Widget>[
      Avatar(initials: 'IB'),
      Avatar(initials: 'AC'),
      Avatar(initials: 'MK'),
      Avatar(initials: '+4'),
    ],
  );
}
''',
    ),
  ],
  'badge': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_badgeDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/badge/badge.dart';

Widget _badgeExample(BuildContext context, BadgeVariant variant, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Badge(variant: variant, child: Text(label)),
      Gap(ShadcnTheme.of(context).spacing.md),
      Badge(
        variant: variant,
        leading: const Icon(LucideIcons.star, size: 12),
        child: Text('$label with icon'),
      ),
    ],
  );
}

Widget _badgeDefault(BuildContext context) =>
    _badgeExample(context, BadgeVariant.primary, 'Default');
''',
    ),
    DocsExampleSource(
      name: 'Secondary',
      builder: '_badgeSecondary',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/badge/badge.dart';

Widget _badgeExample(BuildContext context, BadgeVariant variant, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Badge(variant: variant, child: Text(label)),
      Gap(ShadcnTheme.of(context).spacing.md),
      Badge(
        variant: variant,
        leading: const Icon(LucideIcons.star, size: 12),
        child: Text('$label with icon'),
      ),
    ],
  );
}

Widget _badgeSecondary(BuildContext context) =>
    _badgeExample(context, BadgeVariant.secondary, 'Secondary');
''',
    ),
    DocsExampleSource(
      name: 'Outline',
      builder: '_badgeOutline',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/badge/badge.dart';

Widget _badgeExample(BuildContext context, BadgeVariant variant, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Badge(variant: variant, child: Text(label)),
      Gap(ShadcnTheme.of(context).spacing.md),
      Badge(
        variant: variant,
        leading: const Icon(LucideIcons.star, size: 12),
        child: Text('$label with icon'),
      ),
    ],
  );
}

Widget _badgeOutline(BuildContext context) =>
    _badgeExample(context, BadgeVariant.outline, 'Outline');
''',
    ),
    DocsExampleSource(
      name: 'Destructive',
      builder: '_badgeDestructive',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/badge/badge.dart';

Widget _badgeExample(BuildContext context, BadgeVariant variant, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Badge(variant: variant, child: Text(label)),
      Gap(ShadcnTheme.of(context).spacing.md),
      Badge(
        variant: variant,
        leading: const Icon(LucideIcons.star, size: 12),
        child: Text('$label with icon'),
      ),
    ],
  );
}

Widget _badgeDestructive(BuildContext context) =>
    _badgeExample(context, BadgeVariant.destructive, 'Destructive');
''',
    ),
  ],
  'carousel': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Slide',
      builder: '_carouselSlide',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/constants.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';
import 'package:<your_app>/ui/shadcn/components/carousel/carousel.dart';

/// Pages the carousel slides through.
const List<String> _carouselPages = <String>['One', 'Two', 'Three', 'Four'];

/// One palette-derived page surface.
Widget _carouselPage(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusMd,
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// The carousel with the dot row driven by its controller.
class _CarouselCarousel extends StatefulWidget {
  const _CarouselCarousel({this.fade = false});

  final bool fade;

  @override
  State<_CarouselCarousel> createState() => _CarouselCarouselState();
}

class _CarouselCarouselState extends State<_CarouselCarousel> {
  final CarouselController _controller = CarouselController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 320,
          height: 96,
          child: Carousel(
            itemCount: _carouselPages.length,
            controller: _controller,
            transition: widget.fade ? CarouselTransition.fading : null,
            onIndexChanged: (int index) => setState(() => _index = index),
            itemBuilder: (context, index) =>
                _carouselPage(context, _carouselPages[index]),
          ),
        ),
        Gap(spacing.md),
        DotIndicator(
          index: _index,
          length: _carouselPages.length,
          onChanged: (int page) =>
              _controller.animateTo(page.toDouble(), kDefaultDuration),
        ),
      ],
    );
  }
}

/// Sliding transition.
Widget _carouselSlide(BuildContext context) => const _CarouselCarousel();
''',
    ),
    DocsExampleSource(
      name: 'Fade',
      builder: '_carouselFade',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/constants.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';
import 'package:<your_app>/ui/shadcn/components/carousel/carousel.dart';

/// Pages the carousel slides through.
const List<String> _carouselPages = <String>['One', 'Two', 'Three', 'Four'];

/// One palette-derived page surface.
Widget _carouselPage(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusMd,
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// The carousel with the dot row driven by its controller.
class _CarouselCarousel extends StatefulWidget {
  const _CarouselCarousel({this.fade = false});

  final bool fade;

  @override
  State<_CarouselCarousel> createState() => _CarouselCarouselState();
}

class _CarouselCarouselState extends State<_CarouselCarousel> {
  final CarouselController _controller = CarouselController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 320,
          height: 96,
          child: Carousel(
            itemCount: _carouselPages.length,
            controller: _controller,
            transition: widget.fade ? CarouselTransition.fading : null,
            onIndexChanged: (int index) => setState(() => _index = index),
            itemBuilder: (context, index) =>
                _carouselPage(context, _carouselPages[index]),
          ),
        ),
        Gap(spacing.md),
        DotIndicator(
          index: _index,
          length: _carouselPages.length,
          onChanged: (int page) =>
              _controller.animateTo(page.toDouble(), kDefaultDuration),
        ),
      ],
    );
  }
}

/// Fading transition.
Widget _carouselFade(BuildContext context) =>
    const _CarouselCarousel(fade: true);
''',
    ),
    DocsExampleSource(
      name: 'Autoplay',
      builder: '_carouselAutoplay',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/constants.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';
import 'package:<your_app>/ui/shadcn/components/carousel/carousel.dart';

/// Pages the carousel slides through.
const List<String> _carouselPages = <String>['One', 'Two', 'Three', 'Four'];

/// One palette-derived page surface.
Widget _carouselPage(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusMd,
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// An autoplaying carousel that advances on its own.
class _CarouselAutoplay extends StatelessWidget {
  const _CarouselAutoplay();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 96,
      child: Carousel(
        itemCount: _carouselPages.length,
        autoplayInterval: const Duration(seconds: 2),
        itemBuilder: (context, index) =>
            _carouselPage(context, _carouselPages[index]),
      ),
    );
  }
}

Widget _carouselAutoplay(BuildContext context) => const _CarouselAutoplay();
''',
    ),
  ],
  'chat': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_chatDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chat/chat.dart';

/// A round initials avatar drawn with theme tokens.
class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.muted,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The conversation column, bounded so the stage never overflows.
class _ChatConversation extends StatelessWidget {
  const _ChatConversation();

  static const Widget _start = _ChatAvatar('JO');
  static const Widget _end = _ChatAvatar('AI');

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatGroup(
              avatarSuffix: _end,
              children: const <Widget>[
                ChatBubble(child: Text('Did you remember the meeting time?')),
                ChatBubble(child: Text('Please reply ASAP.')),
              ],
            ),
            Gap(spacing.lg),
            ChatGroup(
              avatarPrefix: _start,
              children: const <Widget>[
                ChatBubble(child: Text('Around 6 or 7?')),
                ChatBubble(child: Text('New phone who dis?')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _chatDefault(BuildContext context) => const _ChatConversation();
''',
    ),
    DocsExampleSource(
      name: 'Incoming',
      builder: '_chatIncoming',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chat/chat.dart';

/// A round initials avatar drawn with theme tokens.
class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.muted,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The conversation column, bounded so the stage never overflows.
class _ChatConversation extends StatelessWidget {
  const _ChatConversation();

  static const Widget _start = _ChatAvatar('JO');
  static const Widget _end = _ChatAvatar('AI');

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatGroup(
              avatarSuffix: _end,
              children: const <Widget>[
                ChatBubble(child: Text('Did you remember the meeting time?')),
                ChatBubble(child: Text('Please reply ASAP.')),
              ],
            ),
            Gap(spacing.lg),
            ChatGroup(
              avatarPrefix: _start,
              children: const <Widget>[
                ChatBubble(child: Text('Around 6 or 7?')),
                ChatBubble(child: Text('New phone who dis?')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Incoming bubbles only.
Widget _chatIncoming(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          ChatGroup(
            avatarPrefix: _ChatConversation._start,
            children: <Widget>[
              ChatBubble(child: Text('Is the build green yet?')),
            ],
          ),
        ],
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Outgoing',
      builder: '_chatOutgoing',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chat/chat.dart';

/// A round initials avatar drawn with theme tokens.
class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.muted,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The conversation column, bounded so the stage never overflows.
class _ChatConversation extends StatelessWidget {
  const _ChatConversation();

  static const Widget _start = _ChatAvatar('JO');
  static const Widget _end = _ChatAvatar('AI');

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatGroup(
              avatarSuffix: _end,
              children: const <Widget>[
                ChatBubble(child: Text('Did you remember the meeting time?')),
                ChatBubble(child: Text('Please reply ASAP.')),
              ],
            ),
            Gap(spacing.lg),
            ChatGroup(
              avatarPrefix: _start,
              children: const <Widget>[
                ChatBubble(child: Text('Around 6 or 7?')),
                ChatBubble(child: Text('New phone who dis?')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Outgoing bubbles only.
Widget _chatOutgoing(BuildContext context) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          ChatGroup(
            avatarSuffix: _ChatConversation._end,
            children: <Widget>[
              ChatBubble(child: Text('Deploying now - two minutes.')),
            ],
          ),
        ],
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Grouped',
      builder: '_chatGrouped',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chat/chat.dart';

/// A round initials avatar drawn with theme tokens.
class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.muted,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The conversation column, bounded so the stage never overflows.
class _ChatConversation extends StatelessWidget {
  const _ChatConversation();

  static const Widget _start = _ChatAvatar('JO');
  static const Widget _end = _ChatAvatar('AI');

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatGroup(
              avatarSuffix: _end,
              children: const <Widget>[
                ChatBubble(child: Text('Did you remember the meeting time?')),
                ChatBubble(child: Text('Please reply ASAP.')),
              ],
            ),
            Gap(spacing.lg),
            ChatGroup(
              avatarPrefix: _start,
              children: const <Widget>[
                ChatBubble(child: Text('Around 6 or 7?')),
                ChatBubble(child: Text('New phone who dis?')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A grouped run with a tailed shape.
Widget _chatGrouped(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ChatGroup(
            avatarPrefix: _ChatConversation._start,
            children: <Widget>[
              ChatBubble(child: Text('First message')),
              ChatBubble(child: Text('Second message')),
              ChatBubble(child: Text('Third message')),
            ],
          ),
          Gap(0),
          ChatReaction(
            chips: <Widget>[
              ChatReactionContainer(
                onTap: () {},
                selected: true,
                child: const Text('\u{1F44D} 3'),
              ),
              const ChatReactionContainer(child: Text('\u{1F389} 1')),
            ],
            child: const ChatBubble(child: Text('Nice work!')),
          ),
          Gap(spacing.lg),
          ComponentTheme<ChatTheme>(
            data: const ChatTheme(
              widthFactor: 0.8,
              background: ThemedColor.ref(ColorRef.accent),
              foreground: ThemedColor.ref(ColorRef.accentForeground),
            ),
            child: const ChatGroup(
              children: <Widget>[
                ChatBubble(child: Text('Accented group bubble.')),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
''',
    ),
  ],
  'chip': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Static',
      builder: '_chipStatic',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip/chip.dart';

/// Static chips with and without slot icons.
Widget _chipStatic(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.sm,
    runSpacing: spacing.sm,
    children: const <Widget>[
      Chip(child: Text('static')),
      Chip(leading: Icon(LucideIcons.star, size: 12), child: Text('leading')),
      Chip(
        trailing: Icon(LucideIcons.chevronRight, size: 12),
        child: Text('trailing'),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Pressable',
      builder: '_chipPressable',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip/chip.dart';

/// Pressable chip counting its presses.
class _ChipPressableChip extends StatefulWidget {
  const _ChipPressableChip();

  @override
  State<_ChipPressableChip> createState() => _ChipPressableChipState();
}

class _ChipPressableChipState extends State<_ChipPressableChip> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Chip(
          onPressed: () => setState(() => _presses++),
          child: const Text('pressable'),
        ),
        Text('pressed $_presses'),
      ],
    );
  }
}

Widget _chipPressable(BuildContext context) => const _ChipPressableChip();
''',
    ),
    DocsExampleSource(
      name: 'Removable',
      builder: '_chipRemovable',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip/chip.dart';

/// Chips that remove themselves from the example's own list.
class _ChipRemovableChips extends StatefulWidget {
  const _ChipRemovableChips();

  @override
  State<_ChipRemovableChips> createState() => _ChipRemovableChipsState();
}

class _ChipRemovableChipsState extends State<_ChipRemovableChips> {
  final List<String> _tags = <String>['flutter', 'shadcn', 'widgets'];

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: <Widget>[
        for (final tag in _tags)
          Chip(
            trailing: ChipButton(
              onPressed: () => setState(() => _tags.remove(tag)),
              child: const Icon(LucideIcons.x, size: 12),
            ),
            child: Text(tag),
          ),
        if (_tags.isEmpty) const Chip(child: Text('all removed')),
      ],
    );
  }
}

Widget _chipRemovable(BuildContext context) => const _ChipRemovableChips();
''',
    ),
  ],
  'country_flag': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_countryFlagDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/country_flag/country_flag.dart';

/// A row of flags looked up from different keys.
Widget _countryFlagDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      CountryFlag.fromCountryCode('US'),
      CountryFlag.fromCountryCode('JP'),
      CountryFlag.fromCountryCode('DE'),
      CountryFlag.fromCountryCode('BR'),
      CountryFlag.fromCountryCode('XX'),
      CountryFlag.fromCurrencyCode('JPY'),
      CountryFlag.fromPhonePrefix('+49'),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Sizes',
      builder: '_countryFlagSizes',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/country_flag/country_flag.dart';

/// The size scale and the rounded shape.
Widget _countryFlagSizes(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      CountryFlag.fromCountryCode('FR'),
      CountryFlag.fromCountryCode('FR', width: 36, height: 27),
      CountryFlag.fromCountryCode('IT', width: 48, height: 36),
      CountryFlag.fromCountryCode(
        'ES',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ],
  );
}
''',
    ),
  ],
  'divider': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_dividerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/divider/divider.dart';

/// A plain horizontal rule.
Widget _dividerDefault(BuildContext context) => const Divider();
''',
    ),
    DocsExampleSource(
      name: 'Labelled',
      builder: '_dividerLabelled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/divider/divider.dart';

/// The labelled form, with the three label alignments.
Widget _dividerLabelled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Divider(label: Text('or continue with')),
      Gap(spacing.sm),
      const Divider(
        labelAlignment: DividerLabelAlignment.start,
        label: Text('start'),
      ),
      Gap(spacing.sm),
      const Divider(
        labelAlignment: DividerLabelAlignment.end,
        label: Text('end'),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_dividerVertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/divider/divider.dart';

/// Vertical rule between two lines of text.
Widget _dividerVertical(BuildContext context) {
  return SizedBox(
    height: 72,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        Text('left'),
        Divider(axis: Axis.vertical),
        Text('right'),
      ],
    ),
  );
}
''',
    ),
  ],
  'empty_state': <DocsExampleSource>[
    DocsExampleSource(
      name: 'No results',
      builder: '_emptyStateNoResults',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/empty_state/empty_state.dart';

/// The full-page empty state, both actions.
Widget _emptyStateNoResults(BuildContext context) {
  return const EmptyState(
    variant: EmptyStateVariant.noResults,
    primaryAction: EmptyStateAction(label: 'Clear filters'),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Empty',
      builder: '_emptyStateEmpty',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/empty_state/empty_state.dart';

/// the full-page empty variant.
Widget _emptyStateEmpty(BuildContext context) {
  return const EmptyState(
    variant: EmptyStateVariant.empty,
    primaryAction: EmptyStateAction(label: 'Create project'),
    secondaryAction: EmptyStateAction(label: 'Import'),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Error fallback',
      builder: '_emptyStateError',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/empty_state/empty_state.dart';

/// the error-fallback variant with a footer link.
Widget _emptyStateError(BuildContext context) {
  return const EmptyState(
    variant: EmptyStateVariant.errorFallback,
    primaryAction: EmptyStateAction(label: 'Try again'),
    footerAction: EmptyStateAction(
      label: 'Report this',
      variant: ButtonVariant.link,
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Compact',
      builder: '_emptyStateCompact',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/empty_state/empty_state.dart';

/// the compact scale, with and without the icon container.
Widget _emptyStateCompact(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const EmptyState(
        size: EmptyStateSize.compact,
        variant: EmptyStateVariant.empty,
        title: Text('Nothing here yet'),
        primaryAction: EmptyStateAction(label: 'Create'),
      ),
      Gap(spacing.xl),
      const EmptyState(
        size: EmptyStateSize.compact,
        variant: EmptyStateVariant.noResults,
        showIconContainer: false,
        title: Text('No matches'),
        description: Text('Try a different term.'),
      ),
    ],
  );
}
''',
    ),
  ],
  'feature_carousel': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_featureCarouselDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/feature_carousel/feature_carousel.dart';

/// The full carousel with its default chrome, scrollable when the cards are
/// taller than the stage.
class _FeatureCarouselDefaultFeatureCarousel extends StatefulWidget {
  const _FeatureCarouselDefaultFeatureCarousel();

  @override
  State<_FeatureCarouselDefaultFeatureCarousel> createState() =>
      _FeatureCarouselDefaultFeatureCarouselState();
}

class _FeatureCarouselDefaultFeatureCarouselState
    extends State<_FeatureCarouselDefaultFeatureCarousel> {
  late final FeatureCarouselController _controller = FeatureCarouselController(
    autoPlay: false,
    primaryActionLabel: 'Get started',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 420,
        child: FeatureCarousel(
          controller: _controller,
          items: const <FeatureCarouselItem>[
            FeatureCarouselItem(
              title: 'Fast',
              description: 'Ship a build in seconds.',
              icon: LucideIcons.zap,
            ),
            FeatureCarouselItem(
              title: 'Safe',
              description: 'Every deploy is immutable.',
              icon: LucideIcons.shield,
            ),
            FeatureCarouselItem(
              title: 'Insightful',
              description: 'Metrics for every release.',
              icon: LucideIcons.chartLine,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _featureCarouselDefault(BuildContext context) =>
    const _FeatureCarouselDefaultFeatureCarousel();
''',
    ),
    DocsExampleSource(
      name: 'Themed',
      builder: '_featureCarouselThemed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/feature_carousel/feature_carousel.dart';

/// A carousel whose theme leg re-colours the accent and card fill.
Widget _featureCarouselThemed(BuildContext context) {
  return SingleChildScrollView(
    child: SizedBox(
      width: 420,
      child: ComponentTheme<FeatureCarouselTheme>(
        data: const FeatureCarouselTheme(
          accentColor: ThemedColor.ref(ColorRef.chart2),
          cardFill: ThemedColor.ref(ColorRef.popover),
          radius: 20,
        ),
        child: const FeatureCarousel(
          items: <FeatureCarouselItem>[
            FeatureCarouselItem(title: 'Themed', icon: LucideIcons.sparkles),
            FeatureCarouselItem(title: 'Accent', icon: LucideIcons.star),
          ],
        ),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Cards only',
      builder: '_featureCarouselCardsOnly',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/feature_carousel/feature_carousel.dart';

/// The cards without the CTA and the navigation arrows.
Widget _featureCarouselCardsOnly(BuildContext context) {
  return SingleChildScrollView(
    child: SizedBox(width: 420, child: _FeatureCarouselCardsOnlyCarousel()),
  );
}

class _FeatureCarouselCardsOnlyCarousel extends StatefulWidget {
  const _FeatureCarouselCardsOnlyCarousel();

  @override
  State<_FeatureCarouselCardsOnlyCarousel> createState() =>
      _FeatureCarouselCardsOnlyCarouselState();
}

class _FeatureCarouselCardsOnlyCarouselState
    extends State<_FeatureCarouselCardsOnlyCarousel> {
  late final FeatureCarouselController _controller = FeatureCarouselController(
    autoPlay: false,
    showCta: false,
    showNavArrows: false,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureCarousel(
      controller: _controller,
      items: const <FeatureCarouselItem>[
        FeatureCarouselItem(title: 'Cards only', icon: LucideIcons.image),
        FeatureCarouselItem(title: 'No chrome', icon: LucideIcons.circle),
      ],
    );
  }
}
''',
    ),
    DocsExampleSource(
      name: 'Labelled',
      builder: '_featureCarouselLabelled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/feature_carousel/feature_carousel.dart';

/// A single slide, so the CTA sits under one card.
Widget _featureCarouselLabelled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          width: 420,
          child: FeatureCarousel(
            items: <FeatureCarouselItem>[
              FeatureCarouselItem(
                title: 'Analytics',
                description: 'Every release measured.',
                icon: LucideIcons.chartLine,
              ),
            ],
          ),
        ),
        Gap(spacing.md),
        Text(
          'A single slide, so the CTA sits under one card.',
          style: TextStyle(
            fontSize: 12,
            color: ShadcnTheme.of(context).colors.mutedForeground,
          ),
        ),
      ],
    ),
  );
}
''',
    ),
  ],
  'file_diff_viewer': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Unified',
      builder: '_unified',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/file_diff_viewer/file_diff_viewer.dart';

/// A two-hunk patch; the second hunk starts collapsed.
const FileDiff _patch = FileDiff(
  path: 'lib/src/widget.dart',
  hunks: <FileDiffHunk>[
    FileDiffHunk(
      header: '@@ -10,7 +10,8 @@',
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'Widget build(BuildContext context) {',
          oldLineNumber: 10,
          newLineNumber: 10,
        ),
        FileDiffLine(
          type: FileDiffLineType.deletion,
          content: '  return Text(label);',
          oldLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.addition,
          content: '  return Text(label, maxLines: 1);',
          newLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.context,
          content: '}',
          oldLineNumber: 12,
          newLineNumber: 12,
        ),
      ],
    ),
    FileDiffHunk(
      header: '@@ -40,6 +41,9 @@',
      collapsed: true,
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'void unusedHelper() {}',
          oldLineNumber: 40,
          newLineNumber: 41,
        ),
      ],
    ),
  ],
);

/// Compact single-column patch (the shadcn default).
Widget _unified(BuildContext context) {
  return const FileDiffViewer(maxHeight: 260, files: <FileDiff>[_patch]);
}
''',
    ),
    DocsExampleSource(
      name: 'Split',
      builder: '_split',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/file_diff_viewer/file_diff_viewer.dart';

/// A two-hunk patch; the second hunk starts collapsed.
const FileDiff _patch = FileDiff(
  path: 'lib/src/widget.dart',
  hunks: <FileDiffHunk>[
    FileDiffHunk(
      header: '@@ -10,7 +10,8 @@',
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'Widget build(BuildContext context) {',
          oldLineNumber: 10,
          newLineNumber: 10,
        ),
        FileDiffLine(
          type: FileDiffLineType.deletion,
          content: '  return Text(label);',
          oldLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.addition,
          content: '  return Text(label, maxLines: 1);',
          newLineNumber: 11,
        ),
        FileDiffLine(
          type: FileDiffLineType.context,
          content: '}',
          oldLineNumber: 12,
          newLineNumber: 12,
        ),
      ],
    ),
    FileDiffHunk(
      header: '@@ -40,6 +41,9 @@',
      collapsed: true,
      lines: <FileDiffLine>[
        FileDiffLine(
          type: FileDiffLineType.context,
          content: 'void unusedHelper() {}',
          oldLineNumber: 40,
          newLineNumber: 41,
        ),
      ],
    ),
  ],
);

/// Old and new sides beside each other.
Widget _split(BuildContext context) {
  return const FileDiffViewer(
    layout: FileDiffLayout.split,
    showCopyAction: false,
    files: <FileDiff>[_patch],
  );
}
''',
    ),
  ],
  'keyboard_shortcut': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_keyboardShortcutDefault',
      code: r'''import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut.dart';

/// A chord rendered from an activator.
Widget _keyboardShortcutDefault(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: KeyboardShortcut.fromActivator(
      activator: SingleActivator(LogicalKeyboardKey.keyK, meta: true),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Multiple keys',
      builder: '_keyboardShortcutMultipleKeys',
      code: r'''import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut.dart';

/// A chord from explicit keys, in display order.
Widget _keyboardShortcutMultipleKeys(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyP,
        ],
      ),
      Gap(spacing.md),
      const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.arrowUp,
          LogicalKeyboardKey.arrowDown,
        ],
      ),
      Gap(spacing.md),
      const KeyboardShortcut(
        keys: <LogicalKeyboardKey>[
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyF,
        ],
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Scoped labels',
      builder: '_keyboardShortcutScoped',
      code: r'''import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut.dart';

/// A chord under a custom display scope, plus one bare cap.
Widget _keyboardShortcutScoped(BuildContext context) {
  return const KeyboardShortcutDisplayScope(
    builder: _keyboardShortcutLabel,
    child: KeyboardShortcut(
      keys: <LogicalKeyboardKey>[
        LogicalKeyboardKey.alt,
        LogicalKeyboardKey.keyF,
      ],
    ),
  );
}

Widget _keyboardShortcutLabel(BuildContext context, LogicalKeyboardKey key) =>
    Text(key.keyLabel.toUpperCase());
''',
    ),
  ],
  'number_ticker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_numberTickerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/number_ticker/number_ticker.dart';

/// A rolling ticker whose value the example changes on tap.
class _NumberTickerTicker extends StatefulWidget {
  const _NumberTickerTicker();

  @override
  State<_NumberTickerTicker> createState() => _NumberTickerTickerState();
}

class _NumberTickerTickerState extends State<_NumberTickerTicker> {
  double _value = 1234;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _value.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: theme.colors.foreground,
          ),
        ),
        Gap(theme.spacing.md),
        NumberTicker(
          number: _value,
          formatter: (num value) => value.toStringAsFixed(0),
        ),
        Gap(theme.spacing.lg),
        Wrap(
          spacing: theme.spacing.sm,
          runSpacing: theme.spacing.sm,
          children: <Widget>[
            for (final double next in const <double>[0, 1234, 987654])
              GestureDetector(
                onTap: () => setState(() => _value = next),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${next.toInt()}',
                    style: TextStyle(color: theme.colors.foreground),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

Widget _numberTickerDefault(BuildContext context) =>
    const _NumberTickerTicker();
''',
    ),
    DocsExampleSource(
      name: 'Flip clock',
      builder: '_numberTickerFlip',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/number_ticker/number_ticker.dart';

/// The flip-clock form of the same value.
class _NumberTickerFlipClock extends StatefulWidget {
  const _NumberTickerFlipClock();

  @override
  State<_NumberTickerFlipClock> createState() => _NumberTickerFlipClockState();
}

class _NumberTickerFlipClockState extends State<_NumberTickerFlipClock> {
  double _value = 1234;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFlipper(
          charset: FlipperCharset.numbers,
          text: _value.toInt().toString(),
        ),
        Gap(theme.spacing.md),
        Wrap(
          spacing: theme.spacing.sm,
          children: <Widget>[
            for (final double next in const <double>[7, 1234, 987654])
              GestureDetector(
                onTap: () => setState(() => _value = next),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${next.toInt()}',
                    style: TextStyle(color: theme.colors.foreground),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

Widget _numberTickerFlip(BuildContext context) =>
    const _NumberTickerFlipClock();
''',
    ),
  ],
  'pinned_sheet': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/pinned_sheet/pinned_sheet.dart';

/// Compact sheet content in theme tokens.
class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Sheet content',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Gap(theme.spacing.sm),
          Text(
            'Drag the sheet to move between stages.',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// A sheet resting at its middle stage; the controller is this example's own.
class _DefaultSheet extends StatefulWidget {
  const _DefaultSheet();

  @override
  State<_DefaultSheet> createState() => _DefaultSheetState();
}

class _DefaultSheetState extends State<_DefaultSheet> {
  final SheetController _controller = SheetController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 280,
      child: PinnedSheet(
        controller: _controller,
        initialStage: const SheetStage.fraction(0.4),
        stages: const <SheetStage>[
          SheetStage.closed(),
          SheetStage.fraction(0.4),
          SheetStage.expanded(),
        ],
        child: const _SheetBody(),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultSheet();
''',
    ),
    DocsExampleSource(
      name: 'Snapping',
      builder: '_snapping',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/pinned_sheet/pinned_sheet.dart';

/// Compact sheet content in theme tokens.
class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Sheet content',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Gap(theme.spacing.sm),
          Text(
            'Drag the sheet to move between stages.',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// A sheet snapped between stages with buttons; the controller is local.
class _SnappingSheet extends StatefulWidget {
  const _SnappingSheet();

  @override
  State<_SnappingSheet> createState() => _SnappingSheetState();
}

class _SnappingSheetState extends State<_SnappingSheet> {
  final SheetController _controller = SheetController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 320,
          height: 240,
          child: PinnedSheet(
            controller: _controller,
            initialStage: const SheetStage.fraction(0.4),
            stages: const <SheetStage>[
              SheetStage.closed(),
              SheetStage.fraction(0.4),
              SheetStage.expanded(),
            ],
            child: const _SheetBody(),
          ),
        ),
        Gap(theme.spacing.sm),
        Wrap(
          spacing: theme.spacing.sm,
          children: <Widget>[
            _SnapButton(label: 'Close', onTap: () => _controller.close()),
            _SnapButton(
              label: 'Half',
              onTap: () =>
                  _controller.animateTo(const SheetStage.fraction(0.4)),
            ),
            _SnapButton(label: 'Open', onTap: () => _controller.open()),
          ],
        ),
      ],
    );
  }
}

/// A small stage button in theme tokens.
class _SnapButton extends StatelessWidget {
  const _SnapButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.secondary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(label),
      ),
    );
  }
}

Widget _snapping(BuildContext context) => const _SnappingSheet();
''',
    ),
  ],
  'table': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/table/table.dart';

/// A data grid with a header, a selected row and a footer.
Widget _default(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 460),
    child: ShadcnTable(
      columnWidths: const <int, TableSize>{
        0: FlexTableSize(flex: 2),
        1: FlexTableSize(),
        2: FixedTableSize(90),
      },
      rows: <ShadcnTableRow>[
        const ShadcnTableHeader(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Name')),
            ShadcnTableCell(child: Text('Role')),
            ShadcnTableCell(child: Text('Status')),
          ],
        ),
        const ShadcnTableRow(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Avery')),
            ShadcnTableCell(child: Text('Designer')),
            ShadcnTableCell(child: Text('Active')),
          ],
        ),
        const ShadcnTableRow(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Jordan')),
            ShadcnTableCell(child: Text('Engineer')),
            ShadcnTableCell(child: Text('Active')),
          ],
        ),
        const ShadcnTableRow(
          selected: true,
          cells: <ShadcnTableCell>[
            ShadcnTableCell(child: Text('Casey')),
            ShadcnTableCell(child: Text('PM')),
            ShadcnTableCell(child: Text('Away')),
          ],
        ),
        ShadcnTableFooter(
          cells: <ShadcnTableCell>[
            ShadcnTableCell(columnSpan: 2, child: const Text('3 people')),
            const ShadcnTableCell(child: Text('—')),
          ],
        ),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Resizable',
      builder: '_resizable',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/table/table.dart';

/// A resizable table; owns its resize and scroll controllers. The fixed box
/// is inherent: the table scrolls internally.
class _ResizableTable extends StatefulWidget {
  const _ResizableTable();

  @override
  State<_ResizableTable> createState() => _ResizableTableState();
}

class _ResizableTableState extends State<_ResizableTable> {
  final ResizableTableController _controller = ResizableTableController(
    defaultColumnWidth: 120,
    defaultRowHeight: 40,
  );
  final ScrollController _vertical = ScrollController();
  final ScrollController _horizontal = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _vertical.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 170,
      child: ShadcnTable(
        resizeController: _controller,
        verticalController: _vertical,
        horizontalController: _horizontal,
        rows: const <ShadcnTableRow>[
          ShadcnTableHeader(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Drag a divider')),
              ShadcnTableCell(child: Text('Column')),
              ShadcnTableCell(child: Text('Row')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('One')),
              ShadcnTableCell(child: Text('Two')),
              ShadcnTableCell(child: Text('Three')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Four')),
              ShadcnTableCell(child: Text('Five')),
              ShadcnTableCell(child: Text('Six')),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _resizable(BuildContext context) => const _ResizableTable();
''',
    ),
  ],
  'timeline': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/timeline/timeline.dart';

/// Three entries with times, titles and content.
Widget _default(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: const Timeline(
      data: <TimelineData>[
        TimelineData(
          time: Text('09:00'),
          title: Text('Kickoff'),
          content: Text('Project kickoff meeting.'),
        ),
        TimelineData(
          time: Text('11:00'),
          title: Text('Design review'),
          content: Text('Review the first concept batch.'),
        ),
        TimelineData(
          time: Text('14:30'),
          title: Text('Delivery'),
          content: Text('Share the final assets.'),
        ),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Compact',
      builder: '_compact',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/timeline/timeline.dart';

/// Smaller dots and a narrower time column through a scoped theme.
Widget _compact(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: const ComponentTheme<TimelineTheme>(
      data: TimelineTheme(
        dotSize: 8,
        connectorThickness: 1,
        rowGap: 8,
        color: ThemedColor.ref(ColorRef.accent),
      ),
      child: Timeline(
        timeConstraints: BoxConstraints(minWidth: 72, maxWidth: 72),
        data: <TimelineData>[
          TimelineData(time: Text('Mon'), title: Text('Compact')),
          TimelineData(time: Text('Tue'), title: Text('scoped leg')),
        ],
      ),
    ),
  );
}
''',
    ),
  ],
  'tracker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tracker/tracker.dart';

/// All four levels.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: Tracker(
      data: <TrackerData>[
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Degraded'), level: TrackerLevel.warning),
        TrackerData(tooltip: Text('Down'), level: TrackerLevel.critical),
        TrackerData(tooltip: Text('No data'), level: TrackerLevel.unknown),
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Custom size',
      builder: '_customSize',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tracker/tracker.dart';

/// Taller segments with a wider gap through the widget leg.
Widget _customSize(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: Tracker(
      theme: TrackerTheme(itemHeight: 24, gap: 4, radius: 4),
      data: <TrackerData>[
        TrackerData(tooltip: Text('One'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Two'), level: TrackerLevel.critical),
        TrackerData(tooltip: Text('Three'), level: TrackerLevel.warning),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Themed',
      builder: '_themed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tracker/tracker.dart';

/// Fine segments tinted with the primary token through a scoped theme.
Widget _themed(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: ComponentTheme<TrackerTheme>(
      data: TrackerTheme(
        fine: ThemedColor.ref(ColorRef.primary),
        itemHeight: 16,
      ),
      child: Tracker(
        data: <TrackerData>[
          TrackerData(tooltip: Text('One'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Two'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Three'), level: TrackerLevel.fine),
        ],
      ),
    ),
  );
}
''',
    ),
  ],
  'tree': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/icon/icon.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/tree/tree.dart';

List<TreeNode<String>> _nodes() => <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[
      TreeItem<String>(data: 'report.pdf', selected: true),
      TreeItem<String>(data: 'notes.md'),
      TreeItem<String>(
        data: 'archive',
        children: <TreeNode<String>>[TreeItem<String>(data: '2024.zip')],
      ),
    ],
  ),
  TreeItem<String>(data: 'Pictures'),
];

Widget _tree({TreeBranchLine? branchLine, List<TreeNode<String>>? nodes}) {
  return SizedBox(
    width: 320,
    child: Tree<String>(
      nodes: nodes ?? _nodes(),
      branchLine: branchLine,
      shrinkWrap: true,
      builder: (BuildContext context, TreeItem<String> item) => TreeRow(
        leading: Icon(
          item.leaf ? LucideIcons.file : LucideIcons.folder,
        ).iconSmall(),
        trailing: const Icon(LucideIcons.ellipsis).iconSmall(),
        child: Text(item.data),
      ),
    ),
  );
}

/// Default path guides with an expanded, selected subtree.
Widget _default(BuildContext context) => _tree();
''',
    ),
    DocsExampleSource(
      name: 'Line guides',
      builder: '_lines',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/icon/icon.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/tree/tree.dart';

List<TreeNode<String>> _nodes() => <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[
      TreeItem<String>(data: 'report.pdf', selected: true),
      TreeItem<String>(data: 'notes.md'),
      TreeItem<String>(
        data: 'archive',
        children: <TreeNode<String>>[TreeItem<String>(data: '2024.zip')],
      ),
    ],
  ),
  TreeItem<String>(data: 'Pictures'),
];

Widget _tree({TreeBranchLine? branchLine, List<TreeNode<String>>? nodes}) {
  return SizedBox(
    width: 320,
    child: Tree<String>(
      nodes: nodes ?? _nodes(),
      branchLine: branchLine,
      shrinkWrap: true,
      builder: (BuildContext context, TreeItem<String> item) => TreeRow(
        leading: Icon(
          item.leaf ? LucideIcons.file : LucideIcons.folder,
        ).iconSmall(),
        trailing: const Icon(LucideIcons.ellipsis).iconSmall(),
        child: Text(item.data),
      ),
    ),
  );
}

/// Plain vertical line guides.
Widget _lines(BuildContext context) {
  return _tree(branchLine: TreeBranchLine.line);
}
''',
    ),
    DocsExampleSource(
      name: 'No guides',
      builder: '_none',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/icon/icon.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/tree/tree.dart';

List<TreeNode<String>> _nodes() => <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[
      TreeItem<String>(data: 'report.pdf', selected: true),
      TreeItem<String>(data: 'notes.md'),
      TreeItem<String>(
        data: 'archive',
        children: <TreeNode<String>>[TreeItem<String>(data: '2024.zip')],
      ),
    ],
  ),
  TreeItem<String>(data: 'Pictures'),
];

Widget _tree({TreeBranchLine? branchLine, List<TreeNode<String>>? nodes}) {
  return SizedBox(
    width: 320,
    child: Tree<String>(
      nodes: nodes ?? _nodes(),
      branchLine: branchLine,
      shrinkWrap: true,
      builder: (BuildContext context, TreeItem<String> item) => TreeRow(
        leading: Icon(
          item.leaf ? LucideIcons.file : LucideIcons.folder,
        ).iconSmall(),
        trailing: const Icon(LucideIcons.ellipsis).iconSmall(),
        child: Text(item.data),
      ),
    ),
  );
}

/// No guides.
Widget _none(BuildContext context) {
  return _tree(branchLine: TreeBranchLine.none);
}
''',
    ),
    DocsExampleSource(
      name: 'Collapsed',
      builder: '_collapsed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/icon/icon.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/tree/tree.dart';

List<TreeNode<String>> _nodes() => <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[
      TreeItem<String>(data: 'report.pdf', selected: true),
      TreeItem<String>(data: 'notes.md'),
      TreeItem<String>(
        data: 'archive',
        children: <TreeNode<String>>[TreeItem<String>(data: '2024.zip')],
      ),
    ],
  ),
  TreeItem<String>(data: 'Pictures'),
];

Widget _tree({TreeBranchLine? branchLine, List<TreeNode<String>>? nodes}) {
  return SizedBox(
    width: 320,
    child: Tree<String>(
      nodes: nodes ?? _nodes(),
      branchLine: branchLine,
      shrinkWrap: true,
      builder: (BuildContext context, TreeItem<String> item) => TreeRow(
        leading: Icon(
          item.leaf ? LucideIcons.file : LucideIcons.folder,
        ).iconSmall(),
        trailing: const Icon(LucideIcons.ellipsis).iconSmall(),
        child: Text(item.data),
      ),
    ),
  );
}

/// Everything collapsed.
Widget _collapsed(BuildContext context) {
  return _tree(
    nodes: <TreeNode<String>>[
      TreeItem<String>(
        data: 'Documents',
        children: <TreeNode<String>>[TreeItem<String>(data: 'report.pdf')],
      ),
      TreeItem<String>(data: 'Pictures'),
    ],
  );
}
''',
    ),
  ],
  'calendar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Single',
      builder: '_calendarSingle',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/date_math.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';

/// The month the examples show.
final DateTime _calendarToday = DateTime(2024, 3, 14);

/// One interactive calendar in [selectionMode], with a month header:
/// `Calendar` owns no navigation, so the caller drives the view.
class _CalendarCalendarPanel extends StatefulWidget {
  const _CalendarCalendarPanel({required this.selectionMode});

  final CalendarSelectionMode selectionMode;

  @override
  State<_CalendarCalendarPanel> createState() => _CalendarCalendarPanelState();
}

class _CalendarCalendarPanelState extends State<_CalendarCalendarPanel> {
  CalendarView _view = CalendarView(2024, 3);
  CalendarValue? _value;

  /// A 24x24 stepper, the tap target the shadcn calendar header uses.
  Widget _calendarStep(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: ShadcnTheme.of(context).colors.border),
          borderRadius: ShadcnTheme.of(context).borderRadiusSm,
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _calendarStep('<', () => setState(() => _view = _view.previous)),
            SizedBox(width: spacing.sm),
            Text('${_view.year}-${_view.month}'),
            SizedBox(width: spacing.sm),
            _calendarStep('>', () => setState(() => _view = _view.next)),
          ],
        ),
        Gap(spacing.sm),
        Calendar(
          view: _view,
          now: _calendarToday,
          value: _value,
          selectionMode: widget.selectionMode,
          onChanged: (CalendarValue? value) => setState(() => _value = value),
        ),
      ],
    );
  }
}

Widget _calendarSingle(BuildContext context) =>
    const _CalendarCalendarPanel(selectionMode: CalendarSelectionMode.single);
''',
    ),
    DocsExampleSource(
      name: 'Range',
      builder: '_calendarRange',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/date_math.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';

/// The month the examples show.
final DateTime _calendarToday = DateTime(2024, 3, 14);

/// One interactive calendar in [selectionMode], with a month header:
/// `Calendar` owns no navigation, so the caller drives the view.
class _CalendarCalendarPanel extends StatefulWidget {
  const _CalendarCalendarPanel({required this.selectionMode});

  final CalendarSelectionMode selectionMode;

  @override
  State<_CalendarCalendarPanel> createState() => _CalendarCalendarPanelState();
}

class _CalendarCalendarPanelState extends State<_CalendarCalendarPanel> {
  CalendarView _view = CalendarView(2024, 3);
  CalendarValue? _value;

  /// A 24x24 stepper, the tap target the shadcn calendar header uses.
  Widget _calendarStep(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: ShadcnTheme.of(context).colors.border),
          borderRadius: ShadcnTheme.of(context).borderRadiusSm,
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _calendarStep('<', () => setState(() => _view = _view.previous)),
            SizedBox(width: spacing.sm),
            Text('${_view.year}-${_view.month}'),
            SizedBox(width: spacing.sm),
            _calendarStep('>', () => setState(() => _view = _view.next)),
          ],
        ),
        Gap(spacing.sm),
        Calendar(
          view: _view,
          now: _calendarToday,
          value: _value,
          selectionMode: widget.selectionMode,
          onChanged: (CalendarValue? value) => setState(() => _value = value),
        ),
      ],
    );
  }
}

Widget _calendarRange(BuildContext context) =>
    const _CalendarCalendarPanel(selectionMode: CalendarSelectionMode.range);
''',
    ),
    DocsExampleSource(
      name: 'Multi',
      builder: '_calendarMulti',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/date_math.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';

/// The month the examples show.
final DateTime _calendarToday = DateTime(2024, 3, 14);

/// One interactive calendar in [selectionMode], with a month header:
/// `Calendar` owns no navigation, so the caller drives the view.
class _CalendarCalendarPanel extends StatefulWidget {
  const _CalendarCalendarPanel({required this.selectionMode});

  final CalendarSelectionMode selectionMode;

  @override
  State<_CalendarCalendarPanel> createState() => _CalendarCalendarPanelState();
}

class _CalendarCalendarPanelState extends State<_CalendarCalendarPanel> {
  CalendarView _view = CalendarView(2024, 3);
  CalendarValue? _value;

  /// A 24x24 stepper, the tap target the shadcn calendar header uses.
  Widget _calendarStep(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: ShadcnTheme.of(context).colors.border),
          borderRadius: ShadcnTheme.of(context).borderRadiusSm,
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _calendarStep('<', () => setState(() => _view = _view.previous)),
            SizedBox(width: spacing.sm),
            Text('${_view.year}-${_view.month}'),
            SizedBox(width: spacing.sm),
            _calendarStep('>', () => setState(() => _view = _view.next)),
          ],
        ),
        Gap(spacing.sm),
        Calendar(
          view: _view,
          now: _calendarToday,
          value: _value,
          selectionMode: widget.selectionMode,
          onChanged: (CalendarValue? value) => setState(() => _value = value),
        ),
      ],
    );
  }
}

Widget _calendarMulti(BuildContext context) =>
    const _CalendarCalendarPanel(selectionMode: CalendarSelectionMode.multi);
''',
    ),
    DocsExampleSource(
      name: 'Month grid',
      builder: '_calendarMonthGrid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/date_math.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';

/// The month the examples show.
final DateTime _calendarToday = DateTime(2024, 3, 14);

/// The default month view, March 2024.
final CalendarView _calendarMarch = CalendarView(2024, 3);

/// A month grid that also serves as the month picker.
Widget _calendarMonthGrid(BuildContext context) {
  return Calendar(
    view: _calendarMarch,
    viewType: CalendarViewType.month,
    now: _calendarToday,
    selectionMode: CalendarSelectionMode.single,
    onChanged: (CalendarValue? value) {},
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Year grid',
      builder: '_calendarYearGrid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/date_math.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';

/// The month the examples show.
final DateTime _calendarToday = DateTime(2024, 3, 14);

/// The default month view, March 2024.
final CalendarView _calendarMarch = CalendarView(2024, 3);

/// A year grid.
Widget _calendarYearGrid(BuildContext context) {
  return Calendar(
    view: _calendarMarch,
    viewType: CalendarViewType.year,
    now: _calendarToday,
    selectionMode: CalendarSelectionMode.single,
    onChanged: (CalendarValue? value) {},
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Read-only',
      builder: '_calendarReadOnly',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/date_math.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';

/// The month the examples show.
final DateTime _calendarToday = DateTime(2024, 3, 14);

/// The default month view, March 2024.
final CalendarView _calendarMarch = CalendarView(2024, 3);

/// Read-only: Sundays are disabled and the value does not change.
Widget _calendarReadOnly(BuildContext context) {
  return Calendar(
    view: _calendarMarch,
    now: _calendarToday,
    value: SingleCalendarValue(_calendarToday),
    stateBuilder: (DateTime date) => date.weekday == DateTime.sunday
        ? DateState.disabled
        : DateState.enabled,
  );
}
''',
    ),
  ],
  'date_picker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Single',
      builder: '_datePickerSingle',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';
import 'package:<your_app>/ui/shadcn/components/date_picker/date_picker.dart';

/// A label above a trigger.
class _DatePickerLabel extends StatelessWidget {
  const _DatePickerLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
    );
  }
}

/// The moment the examples show.
final DateTime _datePickerToday = DateTime(2024, 3, 14);

/// The single-date picker, empty and pre-filled.
Widget _datePickerSingle(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _DatePickerLabel('Empty trigger'),
      Gap(spacing.sm),
      DatePicker(value: null, onChanged: (DateTime? value) {}),
      Gap(spacing.lg),
      const _DatePickerLabel('Filled trigger'),
      Gap(spacing.sm),
      DatePicker(value: _datePickerToday, onChanged: (DateTime? value) {}),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Range',
      builder: '_datePickerRange',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';
import 'package:<your_app>/ui/shadcn/components/date_picker/date_picker.dart';

/// A label above a trigger.
class _DatePickerLabel extends StatelessWidget {
  const _DatePickerLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
    );
  }
}

/// The moment the examples show.
final DateTime _datePickerToday = DateTime(2024, 3, 14);

/// The range picker, empty and pre-filled.
Widget _datePickerRange(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _DatePickerLabel('Empty range trigger'),
      Gap(spacing.sm),
      DateRangePicker(value: null, onChanged: (DateTimeRange? value) {}),
      Gap(spacing.lg),
      const _DatePickerLabel('Filled range trigger'),
      Gap(spacing.sm),
      DateRangePicker(
        value: DateTimeRange(
          _datePickerToday,
          _datePickerToday.add(const Duration(days: 6)),
        ),
        onChanged: (DateTimeRange? value) {},
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Dialog',
      builder: '_datePickerDialog',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';
import 'package:<your_app>/ui/shadcn/components/date_picker/date_picker.dart';

/// The dialog prompt with a title.
Widget _datePickerDialog(BuildContext context) {
  return const DatePicker(
    value: null,
    mode: PromptMode.dialog,
    dialogTitle: Text('Pick a date'),
    onChanged: null,
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_datePickerDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';
import 'package:<your_app>/ui/shadcn/components/date_picker/date_picker.dart';

/// The disabled trigger.
Widget _datePickerDisabled(BuildContext context) {
  return const DatePicker(value: null, enabled: false, onChanged: null);
}
''',
    ),
    DocsExampleSource(
      name: 'Inline',
      builder: '_datePickerInline',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';
import 'package:<your_app>/ui/shadcn/components/date_picker/date_picker.dart';

/// The inline calendar sheet, without a popover.
Widget _datePickerInline(BuildContext context) {
  return const SizedBox(
    width: 280,
    child: DatePickerDialog(selectionMode: CalendarSelectionMode.single),
  );
}
''',
    ),
  ],
  'time_picker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Clock',
      builder: '_clock',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/components/time_picker/time_picker.dart';

/// Clock trigger; owns its value.
class _ClockTrigger extends StatefulWidget {
  const _ClockTrigger();

  @override
  State<_ClockTrigger> createState() => _ClockTriggerState();
}

class _ClockTriggerState extends State<_ClockTrigger> {
  TimeOfDay? _value = const TimeOfDay(hour: 14, minute: 30);

  @override
  Widget build(BuildContext context) {
    return TimePicker(
      value: _value,
      onChanged: (TimeOfDay? value) => setState(() => _value = value),
      use24HourFormat: true,
    );
  }
}

Widget _clock(BuildContext context) => const _ClockTrigger();
''',
    ),
    DocsExampleSource(
      name: 'Duration',
      builder: '_duration',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/components/time_picker/time_picker.dart';

/// Duration trigger; owns its value.
class _DurationTrigger extends StatefulWidget {
  const _DurationTrigger();

  @override
  State<_DurationTrigger> createState() => _DurationTriggerState();
}

class _DurationTriggerState extends State<_DurationTrigger> {
  Duration? _value = const Duration(hours: 1, minutes: 30);

  @override
  Widget build(BuildContext context) {
    return DurationPicker(
      value: _value,
      onChanged: (Duration? value) => setState(() => _value = value),
    );
  }
}

Widget _duration(BuildContext context) => const _DurationTrigger();
''',
    ),
    DocsExampleSource(
      name: 'Clock dialog',
      builder: '_clockDialog',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/components/time_picker/time_picker.dart';

/// The inline clock sheet.
Widget _clockDialog(BuildContext context) {
  return const TimePickerDialog(use24HourFormat: true);
}
''',
    ),
    DocsExampleSource(
      name: 'Duration dialog',
      builder: '_durationDialog',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/components/time_picker/time_picker.dart';

/// The inline duration sheet.
Widget _durationDialog(BuildContext context) {
  return const DurationPickerDialog();
}
''',
    ),
  ],
  'alert': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_alertDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/alert/alert.dart';

/// One alert, stretched to the stage width.
Widget _alert(
  BuildContext context,
  AlertVariant variant,
  String title,
  String content,
) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 512),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Alert(
          variant: variant,
          leading: const Icon(LucideIcons.info, size: 16),
          title: Text(title),
          content: Text(content),
        ),
      ],
    ),
  );
}

/// Default variant.
Widget _alertDefault(BuildContext context) => _alert(
  context,
  AlertVariant.base,
  'Heads up',
  'You can install components from the CLI.',
);
''',
    ),
    DocsExampleSource(
      name: 'Destructive',
      builder: '_alertDestructive',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/alert/alert.dart';

/// One alert, stretched to the stage width.
Widget _alert(
  BuildContext context,
  AlertVariant variant,
  String title,
  String content,
) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 512),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Alert(
          variant: variant,
          leading: const Icon(LucideIcons.info, size: 16),
          title: Text(title),
          content: Text(content),
        ),
      ],
    ),
  );
}

/// Destructive variant.
Widget _alertDestructive(BuildContext context) => _alert(
  context,
  AlertVariant.destructive,
  'Session expired',
  'Please log in again to continue.',
);
''',
    ),
    DocsExampleSource(
      name: 'Compact',
      builder: '_alertCompact',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/alert/alert.dart';

/// A compact alert with a trailing action and no leading icon.
Widget _alertCompact(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 512),
    child: Alert(
      title: Text('Notification'),
      content: Text('You have a new message.'),
      trailing: Text('Now'),
    ),
  );
}
''',
    ),
  ],
  'progress': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Determinate',
      builder: '_progressDeterminate',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/progress/progress.dart';

/// Determinate values at a few fill levels and heights.
Widget _progressDeterminate(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  final bar = <Widget>[
    const Progress(value: 0.25, semanticsLabel: 'Quarter'),
    Gap(spacing.lg),
    const Progress(value: 0.6, semanticsLabel: 'Sixty percent'),
    Gap(spacing.lg),
    const Progress(
      value: 0.85,
      showSparks: true,
      semanticsLabel: 'Eighty five percent',
    ),
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ...bar,
      Gap(spacing.lg),
      SizedBox(
        width: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Progress(value: 0.4, height: 4),
            Gap(spacing.lg),
            const Progress(value: 0.5, height: 14),
          ],
        ),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Indeterminate',
      builder: '_progressIndeterminate',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/progress/progress.dart';

/// Indeterminate mode.
Widget _progressIndeterminate(BuildContext context) {
  return const Progress(semanticsLabel: 'Loading');
}
''',
    ),
  ],
  'skeleton': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_skeletonDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/skeleton/skeleton.dart';

/// Tap target that flips the loading state of the example.
class _SkeletonSkeletonToggle extends StatelessWidget {
  const _SkeletonSkeletonToggle({
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          loading ? 'loading - tap to load' : 'loaded - tap to load',
          style: TextStyle(color: colors.foreground),
        ),
      ),
    );
  }
}

/// A text block that swaps between the shimmer and its loaded content.
class _SkeletonSkeletonBlock extends StatefulWidget {
  const _SkeletonSkeletonBlock();

  @override
  State<_SkeletonSkeletonBlock> createState() => _SkeletonSkeletonBlockState();
}

class _SkeletonSkeletonBlockState extends State<_SkeletonSkeletonBlock> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SkeletonSkeletonToggle(
          loading: _loading,
          onPressed: () => setState(() => _loading = !_loading),
        ),
        Gap(theme.spacing.lg),
        Skeleton(
          enabled: _loading,
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Card title',
                  style: TextStyle(color: theme.colors.foreground),
                ),
                Gap(theme.spacing.sm),
                Text(
                  'Body copy that keeps its box while loading.',
                  style: TextStyle(color: theme.colors.mutedForeground),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _skeletonDefault(BuildContext context) => const _SkeletonSkeletonBlock();
''',
    ),
    DocsExampleSource(
      name: 'Card',
      builder: '_skeletonCard',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/skeleton/skeleton.dart';

/// A circular skeleton next to two bars.
class _SkeletonSkeletonCard extends StatelessWidget {
  const _SkeletonSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Skeleton(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: SizedBox(width: 80, height: 80),
        ),
        Gap(theme.spacing.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 180,
              child: Skeleton(
                child: Text(
                  'Title',
                  style: TextStyle(color: theme.colors.foreground),
                ),
              ),
            ),
            Gap(theme.spacing.sm),
            SizedBox(
              width: 140,
              child: Skeleton(
                child: Text(
                  'Supporting copy',
                  style: TextStyle(color: theme.colors.mutedForeground),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _skeletonCard(BuildContext context) => const _SkeletonSkeletonCard();
''',
    ),
  ],
  'spinner': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_spinnerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/spinner/spinner.dart';

/// The size scale and a couple of stroke widths in one row.
Widget _spinnerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.xl,
    runSpacing: spacing.xl,
    alignment: WrapAlignment.center,
    children: const <Widget>[
      Spinner(),
      Spinner(size: 16),
      Spinner(size: 32),
      Spinner(size: 48),
      Spinner(strokeWidth: 2),
      Spinner(strokeWidth: 6),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Small',
      builder: '_spinnerSmall',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/spinner/spinner.dart';

/// A small spinner inside a text row.
Widget _spinnerSmall(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Spinner(size: 14, strokeWidth: 2),
      Gap(spacing.sm),
      Text(
        'Loading...',
        style: TextStyle(
          fontSize: 13,
          color: ShadcnTheme.of(context).colors.mutedForeground,
        ),
      ),
    ],
  );
}
''',
    ),
  ],
  'toast': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/toast/toast.dart';

/// A persistent toast shown on mount, plus buttons for every placement.
class _DefaultToast extends StatefulWidget {
  const _DefaultToast();

  @override
  State<_DefaultToast> createState() => _DefaultToastState();
}

class _DefaultToastState extends State<_DefaultToast> {
  final ToastController _controller = ToastController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.topCenter,
          autoDismiss: false,
          builder: (BuildContext context) =>
              const Text('Saved to your workspace.'),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: ToastLayer(
        controller: _controller,
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: <Widget>[
            for (final ToastPlacement placement in ToastPlacement.values)
              Button(
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                onPressed: () => _controller.showToast(
                  placement: placement,
                  builder: (BuildContext context) =>
                      Text('Toast at ${placement.name}.'),
                ),
                child: Text(placement.name),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultToast();
''',
    ),
    DocsExampleSource(
      name: 'Destructive',
      builder: '_destructive',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/toast/toast.dart';

/// A persistent destructive toast tinted with the destructive token.
class _DestructiveToast extends StatefulWidget {
  const _DestructiveToast();

  @override
  State<_DestructiveToast> createState() => _DestructiveToastState();
}

class _DestructiveToastState extends State<_DestructiveToast> {
  final ToastController _controller = ToastController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.bottomCenter,
          autoDismiss: false,
          builder: (BuildContext context) =>
              const Text('Could not save the file.'),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: ToastLayer(
        controller: _controller,
        theme: const ToastTheme(
          background: ThemedColor.ref(ColorRef.destructive),
          foreground: ThemedColor.ref(ColorRef.destructiveForeground),
        ),
        child: Button(
          variant: ButtonVariant.destructive,
          size: ButtonSize.sm,
          onPressed: () => _controller.showToast(
            placement: ToastPlacement.bottomCenter,
            autoDismiss: false,
            builder: (BuildContext context) =>
                const Text('Could not save the file.'),
          ),
          child: const Text('Show destructive toast'),
        ),
      ),
    );
  }
}

Widget _destructive(BuildContext context) => const _DestructiveToast();
''',
    ),
    DocsExampleSource(
      name: 'With action',
      builder: '_withAction',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/toast/toast.dart';

/// A persistent toast with an inline action button.
class _ActionToast extends StatefulWidget {
  const _ActionToast();

  @override
  State<_ActionToast> createState() => _ActionToastState();
}

class _ActionToastState extends State<_ActionToast> {
  final ToastController _controller = ToastController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.bottomTrailing,
          autoDismiss: false,
          builder: _toastBody,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _toastBody(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.md,
      runSpacing: spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        const Text('Deployment started.'),
        Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.sm,
          onPressed: () {},
          child: const Text('View'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: ToastLayer(
        controller: _controller,
        child: Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.sm,
          onPressed: () => _controller.showToast(
            placement: ToastPlacement.bottomTrailing,
            autoDismiss: false,
            builder: _toastBody,
          ),
          child: const Text('Show toast with action'),
        ),
      ),
    );
  }
}

Widget _withAction(BuildContext context) => const _ActionToast();
''',
    ),
  ],
  'autocomplete': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_autocompleteDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';
import 'package:<your_app>/ui/shadcn/components/autocomplete/autocomplete.dart';

const List<String> _autocompleteFruits = <String>[
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Cherry',
  'Grape',
  'Kiwi',
  'Lemon',
  'Mango',
  'Orange',
  'Peach',
  'Pear',
  'Pineapple',
  'Strawberry',
  'Watermelon',
];

Iterable<String> _autocompleteFilter(String query) {
  final String needle = query.toLowerCase();
  if (needle.isEmpty) {
    return const <String>[];
  }
  return _autocompleteFruits.where(
    (fruit) => fruit.toLowerCase().contains(needle),
  );
}

/// One completion field, plus the example's own selection echo.
class _AutocompleteAutoCompleteField extends StatefulWidget {
  const _AutocompleteAutoCompleteField({
    required this.hint,
    this.mode,
    this.completer,
    this.itemBuilder,
  });

  final String hint;
  final AutoCompleteMode? mode;
  final AutoCompleteCompleter? completer;
  final Widget Function(BuildContext context, String suggestion, bool selected)?
  itemBuilder;

  @override
  State<_AutocompleteAutoCompleteField> createState() =>
      _AutocompleteAutoCompleteFieldState();
}

class _AutocompleteAutoCompleteFieldState
    extends State<_AutocompleteAutoCompleteField> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            hintText: 'Type a fruit... (${widget.hint})',
            features: <InputFeature>[
              AutoCompleteFeature(
                suggestions: _autocompleteFilter,
                mode: widget.mode,
                completer: widget.completer ?? (String s) => s,
                itemBuilder: widget.itemBuilder,
                onSuggestionSelected: (String value) =>
                    setState(() => _selected = value),
              ),
            ],
          ),
          Gap(theme.spacing.md),
          Text(
            'Last selected: ${_selected.isEmpty ? '-' : _selected}',
            style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// The default replacement mode.
Widget _autocompleteDefault(BuildContext context) =>
    const _AutocompleteAutoCompleteField(hint: 'replaceWord');
''',
    ),
    DocsExampleSource(
      name: 'Append',
      builder: '_autocompleteAppend',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';
import 'package:<your_app>/ui/shadcn/components/autocomplete/autocomplete.dart';

const List<String> _autocompleteFruits = <String>[
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Cherry',
  'Grape',
  'Kiwi',
  'Lemon',
  'Mango',
  'Orange',
  'Peach',
  'Pear',
  'Pineapple',
  'Strawberry',
  'Watermelon',
];

Iterable<String> _autocompleteFilter(String query) {
  final String needle = query.toLowerCase();
  if (needle.isEmpty) {
    return const <String>[];
  }
  return _autocompleteFruits.where(
    (fruit) => fruit.toLowerCase().contains(needle),
  );
}

/// One completion field, plus the example's own selection echo.
class _AutocompleteAutoCompleteField extends StatefulWidget {
  const _AutocompleteAutoCompleteField({
    required this.hint,
    this.mode,
    this.completer,
    this.itemBuilder,
  });

  final String hint;
  final AutoCompleteMode? mode;
  final AutoCompleteCompleter? completer;
  final Widget Function(BuildContext context, String suggestion, bool selected)?
  itemBuilder;

  @override
  State<_AutocompleteAutoCompleteField> createState() =>
      _AutocompleteAutoCompleteFieldState();
}

class _AutocompleteAutoCompleteFieldState
    extends State<_AutocompleteAutoCompleteField> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            hintText: 'Type a fruit... (${widget.hint})',
            features: <InputFeature>[
              AutoCompleteFeature(
                suggestions: _autocompleteFilter,
                mode: widget.mode,
                completer: widget.completer ?? (String s) => s,
                itemBuilder: widget.itemBuilder,
                onSuggestionSelected: (String value) =>
                    setState(() => _selected = value),
              ),
            ],
          ),
          Gap(theme.spacing.md),
          Text(
            'Last selected: ${_selected.isEmpty ? '-' : _selected}',
            style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// Append mode: the suggestion is inserted at the caret.
Widget _autocompleteAppend(BuildContext context) =>
    const _AutocompleteAutoCompleteField(
      hint: 'append',
      mode: AutoCompleteMode.append,
    );
''',
    ),
    DocsExampleSource(
      name: 'Replace all',
      builder: '_autocompleteReplaceAll',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';
import 'package:<your_app>/ui/shadcn/components/autocomplete/autocomplete.dart';

const List<String> _autocompleteFruits = <String>[
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Cherry',
  'Grape',
  'Kiwi',
  'Lemon',
  'Mango',
  'Orange',
  'Peach',
  'Pear',
  'Pineapple',
  'Strawberry',
  'Watermelon',
];

Iterable<String> _autocompleteFilter(String query) {
  final String needle = query.toLowerCase();
  if (needle.isEmpty) {
    return const <String>[];
  }
  return _autocompleteFruits.where(
    (fruit) => fruit.toLowerCase().contains(needle),
  );
}

/// One completion field, plus the example's own selection echo.
class _AutocompleteAutoCompleteField extends StatefulWidget {
  const _AutocompleteAutoCompleteField({
    required this.hint,
    this.mode,
    this.completer,
    this.itemBuilder,
  });

  final String hint;
  final AutoCompleteMode? mode;
  final AutoCompleteCompleter? completer;
  final Widget Function(BuildContext context, String suggestion, bool selected)?
  itemBuilder;

  @override
  State<_AutocompleteAutoCompleteField> createState() =>
      _AutocompleteAutoCompleteFieldState();
}

class _AutocompleteAutoCompleteFieldState
    extends State<_AutocompleteAutoCompleteField> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            hintText: 'Type a fruit... (${widget.hint})',
            features: <InputFeature>[
              AutoCompleteFeature(
                suggestions: _autocompleteFilter,
                mode: widget.mode,
                completer: widget.completer ?? (String s) => s,
                itemBuilder: widget.itemBuilder,
                onSuggestionSelected: (String value) =>
                    setState(() => _selected = value),
              ),
            ],
          ),
          Gap(theme.spacing.md),
          Text(
            'Last selected: ${_selected.isEmpty ? '-' : _selected}',
            style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// Replace-all mode: the whole field is replaced.
Widget _autocompleteReplaceAll(BuildContext context) =>
    const _AutocompleteAutoCompleteField(
      hint: 'replaceAll',
      mode: AutoCompleteMode.replaceAll,
    );
''',
    ),
    DocsExampleSource(
      name: 'Custom row',
      builder: '_autocompleteCustomRow',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';
import 'package:<your_app>/ui/shadcn/components/autocomplete/autocomplete.dart';

const List<String> _autocompleteFruits = <String>[
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Cherry',
  'Grape',
  'Kiwi',
  'Lemon',
  'Mango',
  'Orange',
  'Peach',
  'Pear',
  'Pineapple',
  'Strawberry',
  'Watermelon',
];

Iterable<String> _autocompleteFilter(String query) {
  final String needle = query.toLowerCase();
  if (needle.isEmpty) {
    return const <String>[];
  }
  return _autocompleteFruits.where(
    (fruit) => fruit.toLowerCase().contains(needle),
  );
}

/// One completion field, plus the example's own selection echo.
class _AutocompleteAutoCompleteField extends StatefulWidget {
  const _AutocompleteAutoCompleteField({
    required this.hint,
    this.mode,
    this.completer,
    this.itemBuilder,
  });

  final String hint;
  final AutoCompleteMode? mode;
  final AutoCompleteCompleter? completer;
  final Widget Function(BuildContext context, String suggestion, bool selected)?
  itemBuilder;

  @override
  State<_AutocompleteAutoCompleteField> createState() =>
      _AutocompleteAutoCompleteFieldState();
}

class _AutocompleteAutoCompleteFieldState
    extends State<_AutocompleteAutoCompleteField> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            hintText: 'Type a fruit... (${widget.hint})',
            features: <InputFeature>[
              AutoCompleteFeature(
                suggestions: _autocompleteFilter,
                mode: widget.mode,
                completer: widget.completer ?? (String s) => s,
                itemBuilder: widget.itemBuilder,
                onSuggestionSelected: (String value) =>
                    setState(() => _selected = value),
              ),
            ],
          ),
          Gap(theme.spacing.md),
          Text(
            'Last selected: ${_selected.isEmpty ? '-' : _selected}',
            style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// A custom completer plus a custom row builder.
Widget _autocompleteCustomRow(BuildContext context) =>
    const _AutocompleteAutoCompleteField(
      hint: 'custom',
      completer: _autocompletePad,
      itemBuilder: _autocompleteBoldWhenSelected,
    );

String _autocompletePad(String suggestion) => '$suggestion ';

Widget _autocompleteBoldWhenSelected(
  BuildContext context,
  String suggestion,
  bool selected,
) => Text(
  suggestion,
  style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
);
''',
    ),
  ],
  'checkbox': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_checkboxDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/checkbox/checkbox.dart';

/// One labelled checkbox row; the component owns the label gap (shadcn
/// `gap-2`) and makes the whole row clickable.
Widget _checkboxRow(BuildContext context, Checkbox checkbox, String label) {
  return Checkbox(
    value: checkbox.value,
    controller: checkbox.controller,
    onChanged: checkbox.onChanged,
    tristate: checkbox.tristate,
    enabled: checkbox.enabled,
    size: checkbox.size,
    gap: checkbox.gap,
    padding: checkbox.padding,
    theme: checkbox.theme,
    focusNode: checkbox.focusNode,
    label: Text(label),
  );
}

/// Unchecked, the default.
Widget _checkboxDefault(BuildContext context) =>
    _checkboxRow(context, const Checkbox(), 'Accept terms');
''',
    ),
    DocsExampleSource(
      name: 'Checked',
      builder: '_checkboxChecked',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/checkbox/checkbox.dart';

/// One labelled checkbox row; the component owns the label gap (shadcn
/// `gap-2`) and makes the whole row clickable.
Widget _checkboxRow(BuildContext context, Checkbox checkbox, String label) {
  return Checkbox(
    value: checkbox.value,
    controller: checkbox.controller,
    onChanged: checkbox.onChanged,
    tristate: checkbox.tristate,
    enabled: checkbox.enabled,
    size: checkbox.size,
    gap: checkbox.gap,
    padding: checkbox.padding,
    theme: checkbox.theme,
    focusNode: checkbox.focusNode,
    label: Text(label),
  );
}

/// Checked.
Widget _checkboxChecked(BuildContext context) => _checkboxRow(
  context,
  const Checkbox(value: CheckboxValue.checked),
  'Notify me',
);
''',
    ),
    DocsExampleSource(
      name: 'Indeterminate',
      builder: '_checkboxIndeterminate',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/checkbox/checkbox.dart';

/// One labelled checkbox row; the component owns the label gap (shadcn
/// `gap-2`) and makes the whole row clickable.
Widget _checkboxRow(BuildContext context, Checkbox checkbox, String label) {
  return Checkbox(
    value: checkbox.value,
    controller: checkbox.controller,
    onChanged: checkbox.onChanged,
    tristate: checkbox.tristate,
    enabled: checkbox.enabled,
    size: checkbox.size,
    gap: checkbox.gap,
    padding: checkbox.padding,
    theme: checkbox.theme,
    focusNode: checkbox.focusNode,
    label: Text(label),
  );
}

/// Tri-state: the unchecked -> indeterminate -> checked cycle.
class _CheckboxTristateCheckbox extends StatefulWidget {
  const _CheckboxTristateCheckbox();

  @override
  State<_CheckboxTristateCheckbox> createState() =>
      _CheckboxTristateCheckboxState();
}

class _CheckboxTristateCheckboxState extends State<_CheckboxTristateCheckbox> {
  CheckboxValue _value = CheckboxValue.unchecked;

  @override
  Widget build(BuildContext context) {
    return _checkboxRow(
      context,
      Checkbox(
        tristate: true,
        value: _value,
        onChanged: (CheckboxValue value) => setState(() => _value = value),
      ),
      _value.name,
    );
  }
}

Widget _checkboxIndeterminate(BuildContext context) =>
    const _CheckboxTristateCheckbox();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_checkboxDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/checkbox/checkbox.dart';

/// One labelled checkbox row; the component owns the label gap (shadcn
/// `gap-2`) and makes the whole row clickable.
Widget _checkboxRow(BuildContext context, Checkbox checkbox, String label) {
  return Checkbox(
    value: checkbox.value,
    controller: checkbox.controller,
    onChanged: checkbox.onChanged,
    tristate: checkbox.tristate,
    enabled: checkbox.enabled,
    size: checkbox.size,
    gap: checkbox.gap,
    padding: checkbox.padding,
    theme: checkbox.theme,
    focusNode: checkbox.focusNode,
    label: Text(label),
  );
}

/// Disabled in both states.
Widget _checkboxDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: spacing.md,
    children: <Widget>[
      _checkboxRow(
        context,
        const Checkbox(value: CheckboxValue.checked),
        'On (disabled)',
      ),
      _checkboxRow(
        context,
        const Checkbox(value: CheckboxValue.unchecked),
        'Off',
      ),
    ],
  );
}
''',
    ),
  ],
  'chip_input': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_chipInputDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip_input/chip_input.dart';

/// The controlled field: the example owns the chip list.
class _ChipInputControlledChips extends StatefulWidget {
  const _ChipInputControlledChips();

  @override
  State<_ChipInputControlledChips> createState() =>
      _ChipInputControlledChipsState();
}

class _ChipInputControlledChipsState extends State<_ChipInputControlledChips> {
  List<String> _chips = <String>['flutter'];

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ChipInput<String>(
          hintText: 'Add a tag and press Enter',
          chips: _chips,
          onChipsChanged: (List<String> chips) =>
              setState(() => _chips = chips),
          onChipSubmit: (String text) => text.trim().toLowerCase(),
        ),
        Gap(spacing.sm),
        Text('value: ${_chips.join(', ')}'),
      ],
    );
  }
}

Widget _chipInputDefault(BuildContext context) =>
    const _ChipInputControlledChips();
''',
    ),
    DocsExampleSource(
      name: 'With suggestions',
      builder: '_chipInputSuggestions',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip_input/chip_input.dart';

/// Rejects the word at the caret; used where the typed word is irrelevant.
String? _chipInputReject(String text) => null;

/// Suggestions for the suggestion example.
const List<String> _chipInputFruits = <String>[
  'apple',
  'apricot',
  'avocado',
  'banana',
  'blueberry',
  'cherry',
];

/// The suggestion list filtering as you type.
class _ChipInputSuggestedChips extends StatelessWidget {
  const _ChipInputSuggestedChips();

  @override
  Widget build(BuildContext context) {
    return ChipInput<String>(
      hintText: 'Type to filter the fruits',
      onChipSubmit: _chipInputReject,
      suggestions: (String query) => _chipInputFruits
          .where((String fruit) => fruit.startsWith(query.toLowerCase()))
          .take(5),
    );
  }
}

Widget _chipInputSuggestions(BuildContext context) =>
    const _ChipInputSuggestedChips();
''',
    ),
    DocsExampleSource(
      name: 'Read-only',
      builder: '_chipInputReadOnly',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip_input/chip_input.dart';

/// Rejects the word at the caret; used where the typed word is irrelevant.
String? _chipInputReject(String text) => null;

/// Read-only tokens: no remove button.
class _ChipInputReadOnlyChips extends StatelessWidget {
  const _ChipInputReadOnlyChips();

  @override
  Widget build(BuildContext context) {
    return const ChipInput<String>(
      hintText: 'Tokens without a remove button',
      initialChips: <String>['flutter', 'shadcn'],
      theme: ChipInputTheme(removable: false),
      onChipSubmit: _chipInputReject,
    );
  }
}

Widget _chipInputReadOnly(BuildContext context) =>
    const _ChipInputReadOnlyChips();
''',
    ),
    DocsExampleSource(
      name: 'Validated',
      builder: '_chipInputValidated',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip_input/chip_input.dart';

/// Rejects the word at the caret; used where the typed word is irrelevant.
String? _chipInputReject(String text) => null;

/// The validated field, below the minimum.
class _ChipInputValidatedChips extends StatelessWidget {
  const _ChipInputValidatedChips();

  @override
  Widget build(BuildContext context) {
    return ChipInput<String>(
      hintText: 'Needs at least two chips',
      initialChips: const <String>['flutter'],
      validator: (List<String> chips) =>
          chips.length < 2 ? 'Pick at least two chips.' : null,
      onChipSubmit: _chipInputReject,
    );
  }
}

Widget _chipInputValidated(BuildContext context) =>
    const _ChipInputValidatedChips();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_chipInputDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/chip_input/chip_input.dart';

/// Rejects the word at the caret; used where the typed word is irrelevant.
String? _chipInputReject(String text) => null;

/// The disabled field.
class _ChipInputDisabledChips extends StatelessWidget {
  const _ChipInputDisabledChips();

  @override
  Widget build(BuildContext context) {
    return const ChipInput<String>(
      enabled: false,
      initialChips: <String>['disabled'],
      onChipSubmit: _chipInputReject,
    );
  }
}

Widget _chipInputDisabled(BuildContext context) =>
    const _ChipInputDisabledChips();
''',
    ),
  ],
  'dropzone': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_dropzoneDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/dropzone/dropzone.dart';

/// The idle zone, with the browse action.
Widget _dropzoneDefault(BuildContext context) {
  return const Dropzone(
    hint: Text('Up to 10 MB each.'),
    onBrowse: _dropzoneBrowse,
  );
}

void _dropzoneBrowse() {}
''',
    ),
    DocsExampleSource(
      name: 'Drag over',
      builder: '_dropzoneDragOver',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/dropzone/dropzone.dart';

void _dropzoneBrowse() {}

/// The zone while a drag hovers over it.
Widget _dropzoneDragOver(BuildContext context) {
  return const Dropzone(
    isDragOver: true,
    hint: Text('Release to upload.'),
    onBrowse: _dropzoneBrowse,
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Uploading',
      builder: '_dropzoneUploading',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/dropzone/dropzone.dart';

/// The uploading state, then a success one.
Widget _dropzoneUploading(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: const <Widget>[
      Dropzone(state: DropzoneState.uploading),
      SizedBox(height: 24),
      Dropzone(state: DropzoneState.success),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Error',
      builder: '_dropzoneError',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/dropzone/dropzone.dart';

/// The error state plus the disabled one.
Widget _dropzoneError(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: const <Widget>[
      Dropzone(state: DropzoneState.error),
      SizedBox(height: 24),
      Dropzone(enabled: false),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Custom content',
      builder: '_dropzoneCustom',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/dropzone/dropzone.dart';

/// The zone with a custom hint instead of the default content.
Widget _dropzoneCustom(BuildContext context) {
  return const Dropzone(
    showAction: false,
    content: Text('Drop a folder here to upload it whole.'),
  );
}
''',
    ),
  ],
  'file_picker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Dropzone',
      builder: '_dropzone',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/file_picker/file_picker.dart';

/// Fake platform picker used by the examples.
Future<List<FileValue>> _fakePick(FileUploadPickRequest request) async {
  return <FileValue>[
    const FileValue(
      id: 'pick-pdf',
      name: 'report.pdf',
      size: 482000,
      mimeType: 'application/pdf',
    ),
    if (request.allowMultiple)
      const FileValue(
        id: 'pick-png',
        name: 'photo.png',
        size: 1200000,
        mimeType: 'image/png',
      ),
  ];
}

/// Items caught mid-upload, showing the transfer states.
List<FileItem> _uploadingItems() {
  return <FileItem>[
    const FileItem(
      file: FileValue(id: 'queued', name: 'notes.txt', size: 1200),
    ),
    FileItem(
      file: const FileValue(id: 'uploading', name: 'design.pdf', size: 842000),
      status: FileStatus.uploading,
      progress: 0.45,
    ),
  ];
}

/// Drag-and-drop surface with a live transfer list.
class _DropzoneExample extends StatefulWidget {
  const _DropzoneExample();

  @override
  State<_DropzoneExample> createState() => _DropzoneExampleState();
}

class _DropzoneExampleState extends State<_DropzoneExample> {
  late final FileUploadController _controller = FileUploadController(
    initialItems: _uploadingItems(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: FileUpload(
        pick: _fakePick,
        controller: _controller,
        upload: (_) => const Stream<double>.empty(),
      ),
    );
  }
}

Widget _dropzone(BuildContext context) => const _DropzoneExample();
''',
    ),
    DocsExampleSource(
      name: 'Tile',
      builder: '_tile',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/file_picker/file_picker.dart';

/// Fake platform picker used by the examples.
Future<List<FileValue>> _fakePick(FileUploadPickRequest request) async {
  return <FileValue>[
    const FileValue(
      id: 'pick-pdf',
      name: 'report.pdf',
      size: 482000,
      mimeType: 'application/pdf',
    ),
    if (request.allowMultiple)
      const FileValue(
        id: 'pick-png',
        name: 'photo.png',
        size: 1200000,
        mimeType: 'image/png',
      ),
  ];
}

/// Settled items for the compact surfaces.
List<FileItem> _settledItems() {
  return <FileItem>[
    const FileItem(
      file: FileValue(id: 'queued', name: 'notes.txt', size: 1200),
    ),
    FileItem(
      file: const FileValue(id: 'settled', name: 'archive.zip', size: 5400000),
      status: FileStatus.success,
      progress: 1,
    ),
  ];
}

/// One-line picker tile (label + chosen file name).
class _TileExample extends StatefulWidget {
  const _TileExample();

  @override
  State<_TileExample> createState() => _TileExampleState();
}

class _TileExampleState extends State<_TileExample> {
  late final FileUploadController _controller = FileUploadController(
    initialItems: _settledItems(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: FileUpload(
        variant: FileUploadVariant.tile,
        pick: _fakePick,
        controller: _controller,
      ),
    );
  }
}

Widget _tile(BuildContext context) => const _TileExample();
''',
    ),
    DocsExampleSource(
      name: 'Trigger',
      builder: '_trigger',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/file_picker/file_picker.dart';

/// Fake platform picker used by the examples.
Future<List<FileValue>> _fakePick(FileUploadPickRequest request) async {
  return <FileValue>[
    const FileValue(
      id: 'pick-pdf',
      name: 'report.pdf',
      size: 482000,
      mimeType: 'application/pdf',
    ),
    if (request.allowMultiple)
      const FileValue(
        id: 'pick-png',
        name: 'photo.png',
        size: 1200000,
        mimeType: 'image/png',
      ),
  ];
}

/// Compact trigger for small layouts.
Widget _trigger(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: FileUpload(variant: FileUploadVariant.mobile, pick: _fakePick),
  );
}
''',
    ),
  ],
  'form': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';
import 'package:<your_app>/ui/shadcn/components/form/form.dart';

/// A submit flow: one field, a submit button and the result line.
class _DefaultForm extends StatefulWidget {
  const _DefaultForm();

  @override
  State<_DefaultForm> createState() => _DefaultFormState();
}

class _DefaultFormState extends State<_DefaultForm> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');
  String _result = 'Not submitted';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 320,
      child: ShadcnForm(
        controller: _controller,
        onSubmit: (values) =>
            setState(() => _result = 'Submitted ${values.length} value(s)'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ShadcnFormField<String>(
              key: _emailKey,
              label: const Text('Email'),
              hint: const Text('We never share it.'),
              validator: const NotEmptyValidator() & const EmailValidator(),
              child: const Input(),
            ),
            Gap(theme.spacing.lg),
            Button(
              onPressed: () => _controller.submit(context),
              child: const Text('Submit'),
            ),
            Gap(theme.spacing.sm),
            Text(_result),
          ],
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultForm();
''',
    ),
    DocsExampleSource(
      name: 'Validating',
      builder: '_validating',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';
import 'package:<your_app>/ui/shadcn/components/form/form.dart';

/// A field validating on every change, so the error shows immediately.
class _ValidatingForm extends StatefulWidget {
  const _ValidatingForm();

  @override
  State<_ValidatingForm> createState() => _ValidatingFormState();
}

class _ValidatingFormState extends State<_ValidatingForm> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ShadcnForm(
        controller: _controller,
        child: ShadcnFormField<String>(
          key: _emailKey,
          label: const Text('Email'),
          validator: const NotEmptyValidator() & const EmailValidator(),
          showErrors: const <FormValidationMode>{FormValidationMode.changed},
          child: const Input(),
        ),
      ),
    );
  }
}

Widget _validating(BuildContext context) => const _ValidatingForm();
''',
    ),
  ],
  'formatted_input': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Phone',
      builder: '_phone',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/form_core.dart';
import 'package:<your_app>/ui/shadcn/components/formatted_input/formatted_input.dart';

/// A `(555) 123-4567` phone field in controlled mode.
class _PhoneExample extends StatefulWidget {
  const _PhoneExample();

  @override
  State<_PhoneExample> createState() => _PhoneExampleState();
}

class _PhoneExampleState extends State<_PhoneExample> {
  static const SegmentedValue _initial = SegmentedValue(<SegmentPart>[
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('555')),
    SegmentPart.separator(' ('),
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('123')),
    SegmentPart.separator(') '),
    SegmentPart.editable(length: 4, width: 36, placeholder: Text('4567')),
  ]);

  SegmentedValue _value = _initial;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: FormattedInput(
        leading: const Icon(LucideIcons.phone, size: 16),
        value: _value,
        onChanged: (SegmentedValue value) => setState(() => _value = value),
      ),
    );
  }
}

Widget _phone(BuildContext context) => const _PhoneExample();
''',
    ),
    DocsExampleSource(
      name: 'Date',
      builder: '_date',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/form_core.dart';
import 'package:<your_app>/ui/shadcn/components/formatted_input/formatted_input.dart';

/// A date field reporting a validation error while incomplete.
Widget _date(BuildContext context) {
  return SizedBox(
    width: 300,
    child: FormattedInput(
      initialValue: const SegmentedValue(<SegmentPart>[
        SegmentPart.editable(length: 2, width: 28, placeholder: Text('MM')),
        SegmentPart.separator('/'),
        SegmentPart.editable(length: 2, width: 28, placeholder: Text('DD')),
        SegmentPart.separator('/'),
        SegmentPart.editable(length: 4, width: 36, placeholder: Text('YYYY')),
      ]),
      validator: _validateDate,
      autovalidateMode: FormValidationMode.changed,
    ),
  );
}

String? _validateDate(String? text) {
  final String value = text ?? '';
  if (value.length == 8) {
    return null;
  }
  return 'Enter a full date (MM/DD/YYYY).';
}
''',
    ),
    DocsExampleSource(
      name: 'Card',
      builder: '_card',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/form_core.dart';
import 'package:<your_app>/ui/shadcn/components/formatted_input/formatted_input.dart';

/// A 16-digit card field.
Widget _card(BuildContext context) {
  return const SizedBox(
    width: 300,
    child: FormattedInput(
      initialValue: SegmentedValue(<SegmentPart>[
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('1234')),
        SegmentPart.separator(' '),
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('5678')),
        SegmentPart.separator(' '),
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('9012')),
        SegmentPart.separator(' '),
        SegmentPart.editable(length: 4, width: 40, placeholder: Text('3456')),
      ]),
    ),
  );
}
''',
    ),
  ],
  'input': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_inputDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/adornment_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/numeric_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';

/// A small section label above a field.
class _InputSection extends StatelessWidget {
  const _InputSection(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.xs),
      child: Text(
        label,
        style: theme.typography.small.copyWith(
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The default email field.
//
// P7-D1b: capped at 400 px so the stage centres it instead of stretching it
// full-bleed.
Widget _inputDefault(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        _InputSection('Email'),
        Input(hintText: 'Email'),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With icon',
      builder: '_inputWithIconExample',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/adornment_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/numeric_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';

/// A field with a leading icon and the clear/copy features.
class _InputWithIcon extends StatefulWidget {
  const _InputWithIcon();

  @override
  State<_InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<_InputWithIcon> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            controller: _controller,
            hintText: 'Type to enable clear/copy',
            features: <InputFeature>[
              InputLeadingFeature(const Icon(LucideIcons.search, size: 16)),
              InputClearFeature(),
              InputCopyFeature(),
              const InputPasteFeature(),
            ],
          ),
          Gap(spacing.lg),
          const Input(
            obscureText: true,
            hintText: 'Password',
            features: <InputFeature>[InputPasswordToggleFeature()],
          ),
          Gap(spacing.lg),
          const Input(
            keyboardType: TextInputType.number,
            hintText: 'Quantity',
            features: <InputFeature>[InputSpinnerFeature(min: 0, max: 10)],
          ),
        ],
      ),
    );
  }
}

Widget _inputWithIconExample(BuildContext context) => const _InputWithIcon();
''',
    ),
    DocsExampleSource(
      name: 'Invalid',
      builder: '_inputInvalid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/adornment_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/numeric_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';

/// A small section label above a field.
class _InputSection extends StatelessWidget {
  const _InputSection(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.xs),
      child: Text(
        label,
        style: theme.typography.small.copyWith(
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// An invalid field.
Widget _inputInvalid(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        _InputSection('Invalid'),
        Input(
          hintText: 'Invalid while non-empty',
          validator: _inputNotAllowed,
          features: <InputFeature>[InputRevalidateFeature()],
        ),
        _InputSection('Above / below and hint'),
        Input(
          hintText: 'With helper rows',
          features: <InputFeature>[
            InputAboveBelowFeature.above(Text('Label')),
            InputAboveBelowFeature.below(Text('Helper text')),
            InputHintFeature(popupBuilder: _inputHintPopup),
          ],
        ),
      ],
    ),
  );
}

String? _inputNotAllowed(String? value) =>
    (value ?? '').isEmpty ? null : 'This value is not allowed.';

Widget _inputHintPopup(BuildContext context) => const Text('Extra information');
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_inputDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/adornment_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/input_features.dart';
import 'package:<your_app>/ui/shadcn/primitives/input_features/numeric_features.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input/input.dart';

/// A small section label above a field.
class _InputSection extends StatelessWidget {
  const _InputSection(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.xs),
      child: Text(
        label,
        style: theme.typography.small.copyWith(
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// A disabled field beside a read-only one.
Widget _inputDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _InputSection('Disabled'),
        const Input(hintText: 'Disabled', enabled: false),
        Gap(spacing.lg),
        const _InputSection('Read-only'),
        const Input(
          hintText: 'Read-only',
          readOnly: true,
          initialValue: 'Read-only value',
        ),
      ],
    ),
  );
}
''',
    ),
  ],
  'input_otp': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_inputOtpDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input_otp/input_otp.dart';

/// The six-slot code field.
class _InputOtpOtp extends StatefulWidget {
  const _InputOtpOtp({
    this.length = 6,
    this.separatorEvery,
    this.obscureText = false,
  });

  final int length;
  final int? separatorEvery;
  final bool obscureText;

  @override
  State<_InputOtpOtp> createState() => _InputOtpOtpState();
}

class _InputOtpOtpState extends State<_InputOtpOtp> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputOtp(
          length: widget.length,
          separatorEvery: widget.separatorEvery,
          obscureText: widget.obscureText,
          onChanged: (String code) => setState(() => _code = code),
        ),
        Gap(theme.spacing.md),
        Text(
          'code: "$_code"',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
      ],
    );
  }
}

/// The default field.
Widget _inputOtpDefault(BuildContext context) => const _InputOtpOtp();
''',
    ),
    DocsExampleSource(
      name: 'Separated',
      builder: '_inputOtpSeparated',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input_otp/input_otp.dart';

/// The six-slot code field.
class _InputOtpOtp extends StatefulWidget {
  const _InputOtpOtp({
    this.length = 6,
    this.separatorEvery,
    this.obscureText = false,
  });

  final int length;
  final int? separatorEvery;
  final bool obscureText;

  @override
  State<_InputOtpOtp> createState() => _InputOtpOtpState();
}

class _InputOtpOtpState extends State<_InputOtpOtp> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputOtp(
          length: widget.length,
          separatorEvery: widget.separatorEvery,
          obscureText: widget.obscureText,
          onChanged: (String code) => setState(() => _code = code),
        ),
        Gap(theme.spacing.md),
        Text(
          'code: "$_code"',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
      ],
    );
  }
}

/// A grouped field: a separator every three slots.
Widget _inputOtpSeparated(BuildContext context) =>
    const _InputOtpOtp(separatorEvery: 3);
''',
    ),
    DocsExampleSource(
      name: 'Obscured',
      builder: '_inputOtpObscured',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input_otp/input_otp.dart';

/// The six-slot code field.
class _InputOtpOtp extends StatefulWidget {
  const _InputOtpOtp({
    this.length = 6,
    this.separatorEvery,
    this.obscureText = false,
  });

  final int length;
  final int? separatorEvery;
  final bool obscureText;

  @override
  State<_InputOtpOtp> createState() => _InputOtpOtpState();
}

class _InputOtpOtpState extends State<_InputOtpOtp> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputOtp(
          length: widget.length,
          separatorEvery: widget.separatorEvery,
          obscureText: widget.obscureText,
          onChanged: (String code) => setState(() => _code = code),
        ),
        Gap(theme.spacing.md),
        Text(
          'code: "$_code"',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
      ],
    );
  }
}

/// An obscured field (each character paints as a dot).
Widget _inputOtpObscured(BuildContext context) =>
    const _InputOtpOtp(obscureText: true);
''',
    ),
    DocsExampleSource(
      name: 'Four slots',
      builder: '_inputOtpFourSlots',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/input_otp/input_otp.dart';

/// The six-slot code field.
class _InputOtpOtp extends StatefulWidget {
  const _InputOtpOtp({
    this.length = 6,
    this.separatorEvery,
    this.obscureText = false,
  });

  final int length;
  final int? separatorEvery;
  final bool obscureText;

  @override
  State<_InputOtpOtp> createState() => _InputOtpOtpState();
}

class _InputOtpOtpState extends State<_InputOtpOtp> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputOtp(
          length: widget.length,
          separatorEvery: widget.separatorEvery,
          obscureText: widget.obscureText,
          onChanged: (String code) => setState(() => _code = code),
        ),
        Gap(theme.spacing.md),
        Text(
          'code: "$_code"',
          style: TextStyle(fontSize: 12, color: theme.colors.mutedForeground),
        ),
      ],
    );
  }
}

/// The shorter four-slot field.
Widget _inputOtpFourSlots(BuildContext context) =>
    const _InputOtpOtp(length: 4);
''',
    ),
  ],
  'item_picker': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Grid',
      builder: '_grid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/item_picker/item_picker.dart';

/// Grid body with a live selection.
class _GridExample extends StatefulWidget {
  const _GridExample();

  @override
  State<_GridExample> createState() => _GridExampleState();
}

class _GridExampleState extends State<_GridExample> {
  String? _value = 'B';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ItemPickerDialog<String>(
        items: const ItemList<String>(<String>['A', 'B', 'C', 'D']),
        builder: (BuildContext context, String value) =>
            ItemPickerOption<String>(
              value: value,
              child: Center(child: Text(value)),
            ),
        value: _value,
        onChanged: (String? next) => setState(() => _value = next),
      ),
    );
  }
}

Widget _grid(BuildContext context) => const _GridExample();
''',
    ),
    DocsExampleSource(
      name: 'List',
      builder: '_list',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/item_picker/item_picker.dart';

/// List body with a swatch per row and a live selection.
class _ListExample extends StatefulWidget {
  const _ListExample();

  @override
  State<_ListExample> createState() => _ListExampleState();
}

class _ListExampleState extends State<_ListExample> {
  String? _value = 'Coral';

  static const List<String> _items = <String>['Coral', 'Mint', 'Sky'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ItemPickerDialog<String>(
        items: const ItemList<String>(_items),
        layout: ItemPickerLayout.list,
        builder: (BuildContext context, String value) =>
            ItemPickerOption<String>(
              value: value,
              label: Text(value),
              child: _Swatch(value),
            ),
        value: _value,
        onChanged: (String? next) => setState(() => _value = next),
      ),
    );
  }
}

/// Theme-token swatch for the list example.
class _Swatch extends StatelessWidget {
  const _Swatch(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    final Color color = switch (name) {
      'Coral' => colors.chart1,
      'Mint' => colors.chart2,
      _ => colors.chart3,
    };
    return SizedBox(
      width: ShadcnTheme.of(context).spacing.xl,
      height: ShadcnTheme.of(context).spacing.xl,
      child: ColoredBox(color: color, child: const SizedBox()),
    );
  }
}

Widget _list(BuildContext context) => const _ListExample();
''',
    ),
  ],
  'multi_select': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/multi_select/multi_select.dart';

const List<String> _options = <String>[
  'Apple',
  'Banana',
  'Cherry',
  'Date',
  'Grape',
];

/// A controlled picker with one fruit selected.
class _DefaultExample extends StatefulWidget {
  const _DefaultExample();

  @override
  State<_DefaultExample> createState() => _DefaultExampleState();
}

class _DefaultExampleState extends State<_DefaultExample> {
  Iterable<String>? _fruits = <String>['Apple'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: MultiSelect<String>(
        value: _fruits,
        onChanged: (Iterable<String>? value) => setState(() => _fruits = value),
        placeholder: const Text('Select fruits'),
        itemBuilder: (BuildContext context, String value) =>
            MultiSelectChip<String>(value: value, child: Text(value)),
        items: <Widget>[
          for (final String fruit in _options)
            MultiSelectItem<String>(value: fruit, child: Text(fruit)),
        ],
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultExample();
''',
    ),
    DocsExampleSource(
      name: 'With badges',
      builder: '_withBadges',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/multi_select/multi_select.dart';

const List<String> _options = <String>[
  'Apple',
  'Banana',
  'Cherry',
  'Date',
  'Grape',
];

/// A controlled picker whose trigger wraps three removable chips.
class _BadgesExample extends StatefulWidget {
  const _BadgesExample();

  @override
  State<_BadgesExample> createState() => _BadgesExampleState();
}

class _BadgesExampleState extends State<_BadgesExample> {
  Iterable<String>? _fruits = <String>['Apple', 'Cherry', 'Grape'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: MultiSelect<String>(
        value: _fruits,
        onChanged: (Iterable<String>? value) => setState(() => _fruits = value),
        placeholder: const Text('Select fruits'),
        itemBuilder: (BuildContext context, String value) =>
            MultiSelectChip<String>(value: value, child: Text(value)),
        items: <Widget>[
          for (final String fruit in _options)
            MultiSelectItem<String>(value: fruit, child: Text(fruit)),
        ],
      ),
    );
  }
}

Widget _withBadges(BuildContext context) => const _BadgesExample();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_disabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/multi_select/multi_select.dart';

const List<String> _options = <String>[
  'Apple',
  'Banana',
  'Cherry',
  'Date',
  'Grape',
];

/// A disabled picker.
class _DisabledExample extends StatefulWidget {
  const _DisabledExample();

  @override
  State<_DisabledExample> createState() => _DisabledExampleState();
}

class _DisabledExampleState extends State<_DisabledExample> {
  Iterable<String>? _fruits = <String>['Apple'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: MultiSelect<String>(
        value: _fruits,
        onChanged: (Iterable<String>? value) => setState(() => _fruits = value),
        enabled: false,
        placeholder: const Text('Select fruits'),
        itemBuilder: (BuildContext context, String value) =>
            MultiSelectChip<String>(value: value, child: Text(value)),
        items: <Widget>[
          for (final String fruit in _options)
            MultiSelectItem<String>(value: fruit, child: Text(fruit)),
        ],
      ),
    );
  }
}

Widget _disabled(BuildContext context) => const _DisabledExample();
''',
    ),
  ],
  'object_input': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Date',
      builder: '_date',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/object_input/object_input.dart';

/// A date field; the value lives in this example's state.
class _DateDemo extends StatefulWidget {
  const _DateDemo();

  @override
  State<_DateDemo> createState() => _DateDemoState();
}

class _DateDemoState extends State<_DateDemo> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: DateInput(
        value: _date,
        // Dialog: the example may not provide an OverlayManager.
        mode: PromptMode.dialog,
        onChanged: (DateTime? next) => setState(() => _date = next),
      ),
    );
  }
}

Widget _date(BuildContext context) => const _DateDemo();
''',
    ),
    DocsExampleSource(
      name: 'Time',
      builder: '_time',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/object_input/object_input.dart';

/// A time field; the value lives in this example's state.
class _TimeDemo extends StatefulWidget {
  const _TimeDemo();

  @override
  State<_TimeDemo> createState() => _TimeDemoState();
}

class _TimeDemoState extends State<_TimeDemo> {
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TimeInput(
        value: _time,
        onChanged: (TimeOfDay? next) => setState(() => _time = next),
      ),
    );
  }
}

Widget _time(BuildContext context) => const _TimeDemo();
''',
    ),
    DocsExampleSource(
      name: 'Duration',
      builder: '_duration',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/time_of_day.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/object_input/object_input.dart';

/// A duration field; the value lives in this example's state.
class _DurationDemo extends StatefulWidget {
  const _DurationDemo();

  @override
  State<_DurationDemo> createState() => _DurationDemoState();
}

class _DurationDemoState extends State<_DurationDemo> {
  Duration? _duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: DurationInput(
        value: _duration,
        onChanged: (Duration? next) => setState(() => _duration = next),
      ),
    );
  }
}

Widget _duration(BuildContext context) => const _DurationDemo();
''',
    ),
  ],
  'phone_input': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/countries.dart';
import 'package:<your_app>/ui/shadcn/components/form/form.dart';
import 'package:<your_app>/ui/shadcn/components/phone_input/phone_input.dart';

/// Widths that fit both the 720-wide stage and a 375-wide phone. The country
/// selector needs 136 logical pixels for its flag, dial code and chevron.
const PhoneInputTheme _compact = PhoneInputTheme(
  selectWidth: 136,
  maxWidth: 160,
);

/// A phone field with a default country and value.
class _DefaultPhone extends StatefulWidget {
  const _DefaultPhone();

  @override
  State<_DefaultPhone> createState() => _DefaultPhoneState();
}

class _DefaultPhoneState extends State<_DefaultPhone> {
  PhoneNumber? _value = const PhoneNumber(
    Country(dialCode: '+62', code: 'ID'),
    '812345678',
  );

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
      initialValue: _value,
      onChanged: (PhoneNumber? value) => setState(() => _value = value),
      theme: _compact,
    );
  }
}

Widget _default(BuildContext context) => const _DefaultPhone();
''',
    ),
    DocsExampleSource(
      name: 'Custom countries',
      builder: '_customCountries',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/countries.dart';
import 'package:<your_app>/ui/shadcn/components/form/form.dart';
import 'package:<your_app>/ui/shadcn/components/phone_input/phone_input.dart';

/// Widths that fit both the 720-wide stage and a 375-wide phone. The country
/// selector needs 136 logical pixels for its flag, dial code and chevron.
const PhoneInputTheme _compact = PhoneInputTheme(
  selectWidth: 136,
  maxWidth: 160,
);

/// A phone field offering a custom country list.
class _CustomCountriesPhone extends StatefulWidget {
  const _CustomCountriesPhone();

  @override
  State<_CustomCountriesPhone> createState() => _CustomCountriesPhoneState();
}

class _CustomCountriesPhoneState extends State<_CustomCountriesPhone> {
  PhoneNumber? _value;

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
      initialCountry: const Country(dialCode: '+44', code: 'GB'),
      initialValue: _value,
      countries: const <CountryInfo>[
        CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
        CountryInfo('IE', '+353', 'EUR', 'Ireland'),
        CountryInfo('FR', '+33', 'EUR', 'France'),
      ],
      onChanged: (PhoneNumber? value) => setState(() => _value = value),
      theme: _compact,
    );
  }
}

Widget _customCountries(BuildContext context) => const _CustomCountriesPhone();
''',
    ),
    DocsExampleSource(
      name: 'Invalid',
      builder: '_invalid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/countries.dart';
import 'package:<your_app>/ui/shadcn/components/form/form.dart';
import 'package:<your_app>/ui/shadcn/components/phone_input/phone_input.dart';

/// Widths that fit both the 720-wide stage and a 375-wide phone. The country
/// selector needs 136 logical pixels for its flag, dial code and chevron.
const PhoneInputTheme _compact = PhoneInputTheme(
  selectWidth: 136,
  maxWidth: 160,
);

/// A phone field showing the validator error for a short number.
class _InvalidPhone extends StatefulWidget {
  const _InvalidPhone();

  @override
  State<_InvalidPhone> createState() => _InvalidPhoneState();
}

class _InvalidPhoneState extends State<_InvalidPhone> {
  PhoneNumber? _value = const PhoneNumber(
    Country(dialCode: '+1', code: 'US'),
    '1',
  );

  @override
  Widget build(BuildContext context) {
    return ShadcnForm(
      child: ShadcnFormField<PhoneNumber>(
        key: const FormKey<PhoneNumber>('preview-phone-invalid'),
        label: const Text('Phone'),
        validator: const PhoneNumberValidator(),
        child: PhoneInput(
          initialValue: _value,
          onChanged: (PhoneNumber? value) => setState(() => _value = value),
          theme: _compact,
        ),
      ),
    );
  }
}

Widget _invalid(BuildContext context) => const _InvalidPhone();
''',
    ),
  ],
  'radio_group': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/radio_group/radio_group.dart';

/// A vertical group of row items; the selection lives in this example.
class _RowsDemo extends StatefulWidget {
  const _RowsDemo();

  @override
  State<_RowsDemo> createState() => _RowsDemoState();
}

class _RowsDemoState extends State<_RowsDemo> {
  String _plan = 'free';

  @override
  Widget build(BuildContext context) {
    return ShadcnRadioGroup<String>(
      value: _plan,
      onChanged: (String value) => setState(() => _plan = value),
      items: const <Widget>[
        RadioItem<String>(value: 'free', label: Text('Free')),
        RadioItem<String>(value: 'pro', label: Text('Pro')),
        RadioItem<String>(value: 'team', label: Text('Team')),
      ],
    );
  }
}

Widget _default(BuildContext context) => const _RowsDemo();
''',
    ),
    DocsExampleSource(
      name: 'Card items',
      builder: '_cardItems',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/radio_group/radio_group.dart';

/// A group of card items; the selection lives in this example.
class _CardsDemo extends StatefulWidget {
  const _CardsDemo();

  @override
  State<_CardsDemo> createState() => _CardsDemoState();
}

class _CardsDemoState extends State<_CardsDemo> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) {
    return ShadcnRadioGroup<String>(
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
}

Widget _cardItems(BuildContext context) => const _CardsDemo();
''',
    ),
  ],
  'select': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/select/select.dart';

/// A controlled fruit picker; the selection lives in this example's state.
class _FruitSelect extends StatefulWidget {
  const _FruitSelect();

  @override
  State<_FruitSelect> createState() => _FruitSelectState();
}

class _FruitSelectState extends State<_FruitSelect> {
  String? _fruit;

  static const List<String> _fruits = <String>[
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grape',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Select<String>(
        value: _fruit,
        onChanged: (String? value) => setState(() => _fruit = value),
        placeholder: const Text('Select a fruit'),
        itemBuilder: (BuildContext context, String value) => Text(value),
        items: <Widget>[
          for (final String fruit in _fruits)
            SelectItem<String>(value: fruit, child: Text(fruit)),
        ],
      ),
    );
  }
}

Widget _default(BuildContext context) => const _FruitSelect();
''',
    ),
    DocsExampleSource(
      name: 'With groups',
      builder: '_withGroups',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/select/select.dart';

/// A picker grouping its rows under disabled header rows.
class _GroupedSelect extends StatefulWidget {
  const _GroupedSelect();

  @override
  State<_GroupedSelect> createState() => _GroupedSelectState();
}

class _GroupedSelectState extends State<_GroupedSelect> {
  String? _produce;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Select<String>(
        value: _produce,
        onChanged: (String? value) => setState(() => _produce = value),
        placeholder: const Text('Select produce'),
        itemBuilder: (BuildContext context, String value) => Text(value),
        items: const <Widget>[
          SelectItem<String>(
            value: '__fruits',
            enabled: false,
            child: Text('Fruits'),
          ),
          SelectItem<String>(value: 'Apple', child: Text('Apple')),
          SelectItem<String>(value: 'Banana', child: Text('Banana')),
          SelectItem<String>(
            value: '__vegetables',
            enabled: false,
            child: Text('Vegetables'),
          ),
          SelectItem<String>(value: 'Carrot', child: Text('Carrot')),
          SelectItem<String>(value: 'Lettuce', child: Text('Lettuce')),
        ],
      ),
    );
  }
}

Widget _withGroups(BuildContext context) => const _GroupedSelect();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_disabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/select/select.dart';

/// A disabled picker showing its selected value.
Widget _disabled(BuildContext context) {
  return SizedBox(
    width: 220,
    child: Select<String>(
      value: 'Apple',
      onChanged: (String? value) {},
      enabled: false,
      placeholder: const Text('Select a fruit'),
      itemBuilder: (BuildContext context, String value) => Text(value),
      items: const <Widget>[
        SelectItem<String>(value: 'Apple', child: Text('Apple')),
        SelectItem<String>(value: 'Banana', child: Text('Banana')),
      ],
    ),
  );
}
''',
    ),
  ],
  'slider': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/slider_value.dart';
import 'package:<your_app>/ui/shadcn/components/slider/slider.dart';

/// A single-value slider; the value lives in this example's state.
class _SingleSlider extends StatefulWidget {
  const _SingleSlider();

  @override
  State<_SingleSlider> createState() => _SingleSliderState();
}

class _SingleSliderState extends State<_SingleSlider> {
  double _value = 0.4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Slider(
        value: _value,
        onChanged: (double value) => setState(() => _value = value),
        semanticLabel: 'Single',
      ),
    );
  }
}

Widget _default(BuildContext context) => const _SingleSlider();
''',
    ),
    DocsExampleSource(
      name: 'Range',
      builder: '_range',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/slider_value.dart';
import 'package:<your_app>/ui/shadcn/components/slider/slider.dart';

/// A ranged slider; the range lives in this example's state.
class _RangeSlider extends StatefulWidget {
  const _RangeSlider();

  @override
  State<_RangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<_RangeSlider> {
  SliderValue _range = const SliderValue.ranged(0.2, 0.7);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Slider.range(
        value: _range,
        onRangeChanged: (SliderValue value) => setState(() => _range = value),
        semanticLabel: 'Range',
      ),
    );
  }
}

Widget _range(BuildContext context) => const _RangeSlider();
''',
    ),
    DocsExampleSource(
      name: 'Steps',
      builder: '_steps',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/slider_value.dart';
import 'package:<your_app>/ui/shadcn/components/slider/slider.dart';

/// A stepped slider with dot marks; the value lives in this example's state.
class _StepsSlider extends StatefulWidget {
  const _StepsSlider();

  @override
  State<_StepsSlider> createState() => _StepsSliderState();
}

class _StepsSliderState extends State<_StepsSlider> {
  double _value = 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Slider(
        value: _value,
        min: 0,
        max: 4,
        snap: const SliderSnap.steps(4),
        variant: SliderVariant.dots,
        onChanged: (double value) => setState(() => _value = value),
        semanticLabel: 'Steps',
      ),
    );
  }
}

Widget _steps(BuildContext context) => const _StepsSlider();
''',
    ),
  ],
  'star_rating': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/star_rating/star_rating.dart';

/// Interactive rating with half-star steps; owns its value.
class _InteractiveRating extends StatefulWidget {
  const _InteractiveRating();

  @override
  State<_InteractiveRating> createState() => _InteractiveRatingState();
}

class _InteractiveRatingState extends State<_InteractiveRating> {
  double _value = 3.5;

  @override
  Widget build(BuildContext context) {
    return StarRating(
      value: _value,
      onChanged: (double value) => setState(() => _value = value),
    );
  }
}

Widget _default(BuildContext context) => const _InteractiveRating();
''',
    ),
    DocsExampleSource(
      name: 'Read-only',
      builder: '_readOnly',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/star_rating/star_rating.dart';

/// A non-interactive rating.
Widget _readOnly(BuildContext context) {
  return const StarRating(value: 4);
}
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_vertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/star_rating/star_rating.dart';

void _ignore(double value) {}

/// A vertical rating.
Widget _vertical(BuildContext context) {
  return const StarRating(
    value: 3,
    direction: Axis.vertical,
    onChanged: _ignore,
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_disabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/star_rating/star_rating.dart';

/// A disabled rating.
Widget _disabled(BuildContext context) {
  return const StarRating(value: 3, enabled: false);
}
''',
    ),
  ],
  'switch': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/switch/switch.dart';

/// Controlled switch; owns its value.
class _ControlledSwitch extends StatefulWidget {
  const _ControlledSwitch();

  @override
  State<_ControlledSwitch> createState() => _ControlledSwitchState();
}

class _ControlledSwitchState extends State<_ControlledSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (bool value) => setState(() => _value = value),
      label: const Text('Airplane mode'),
    );
  }
}

Widget _default(BuildContext context) => const _ControlledSwitch();
''',
    ),
    DocsExampleSource(
      name: 'Rows',
      builder: '_switchRows',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/switch/switch.dart';

Widget _switchRows(BuildContext context) => const _SwitchRows();

/// A stack of switch rows: the group gap (shadcn `gap-3`) between them, the
/// same one the radio group and a checkbox list use.
class _SwitchRows extends StatefulWidget {
  const _SwitchRows();

  @override
  State<_SwitchRows> createState() => _SwitchRowsState();
}

class _SwitchRowsState extends State<_SwitchRows> {
  bool _notifications = true;
  bool _sounds = false;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing.md,
      children: <Widget>[
        Switch(
          value: _notifications,
          onChanged: (bool value) => setState(() => _notifications = value),
          label: const Text('Notifications'),
        ),
        Switch(
          value: _sounds,
          onChanged: (bool value) => setState(() => _sounds = value),
          label: const Text('Sounds'),
        ),
      ],
    );
  }
}
''',
    ),
    DocsExampleSource(
      name: 'Controller',
      builder: '_controller',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/switch/switch.dart';

/// Controller-driven switch; the controller owns the value.
class _ControllerSwitch extends StatefulWidget {
  const _ControllerSwitch();

  @override
  State<_ControllerSwitch> createState() => _ControllerSwitchState();
}

class _ControllerSwitchState extends State<_ControllerSwitch> {
  final SwitchController _controller = SwitchController(true);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Switch(
          controller: _controller,
          label: const Text('Driven by a controller'),
        ),
        Text('value: ${_controller.value}'),
      ],
    );
  }
}

Widget _controller(BuildContext context) => const _ControllerSwitch();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_disabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/switch/switch.dart';

/// On and off switches with no callback, so both are disabled.
Widget _disabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.xl,
    runSpacing: spacing.md,
    children: const <Widget>[
      Switch(value: true, label: Text('on')),
      Switch(value: false, label: Text('off')),
    ],
  );
}
''',
    ),
  ],
  'text_area': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/text_area/text_area.dart';

/// The default three-line field.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: TextArea(initialValue: 'Hello, World!'),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Placeholder',
      builder: '_placeholder',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/text_area/text_area.dart';

/// A taller field with placeholder text.
Widget _placeholder(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: TextArea(
      placeholder: Text('Type your message here...'),
      minLines: 4,
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Resizable',
      builder: '_resizable',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/text_area/text_area.dart';

/// A field that grows with its content.
Widget _resizable(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: TextArea(
      hintText: 'No cap: paste a long paragraph',
      minLines: 2,
      maxLines: 8,
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Invalid',
      builder: '_invalid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/text_area/text_area.dart';

/// A validating field; owns the typed value it echoes.
class _InvalidArea extends StatefulWidget {
  const _InvalidArea();

  @override
  State<_InvalidArea> createState() => _InvalidAreaState();
}

class _InvalidAreaState extends State<_InvalidArea> {
  String _code = 'abc';

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextArea(
            initialValue: 'abc',
            minLines: 2,
            validator: (String? value) =>
                (value ?? '').length < 8 ? 'At least 8 characters' : null,
            onChanged: (String value) => setState(() => _code = value),
          ),
          SizedBox(height: spacing.sm),
          Text(
            'typed: ${_code.isEmpty ? '(empty)' : _code}',
            style: TextStyle(
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _invalid(BuildContext context) => const _InvalidArea();
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_disabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/text_area/text_area.dart';

/// A disabled field.
Widget _disabled(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: TextArea(initialValue: 'Disabled', enabled: false),
  );
}
''',
    ),
  ],
  'accordion': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_accordionDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/accordion/accordion.dart';

/// The three classic questions, collapsed.
Widget _accordionDefault(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 420),
    child: Accordion(
      items: <Widget>[
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it accessible?')),
          content: Text(
            'Yes. It follows the WAI-ARIA disclosure pattern and responds '
            'to Enter and Space.',
          ),
        ),
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it styled?')),
          content: Text(
            'Yes. Defaults come from the global tokens and every part is '
            'overridable through AccordionTheme.',
          ),
        ),
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it animated?')),
          content: Text('Yes. Items animate with the theme duration.'),
        ),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Expanded',
      builder: '_accordionExpanded',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/accordion/accordion.dart';

/// The second item is opened on the first frame.
Widget _accordionExpanded(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 420),
    child: Accordion(
      items: <Widget>[
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it accessible?')),
          content: Text(
            'Yes. It follows the WAI-ARIA disclosure pattern and responds '
            'to Enter and Space.',
          ),
        ),
        AccordionItem(
          expanded: true,
          trigger: AccordionTrigger(child: Text('Is it styled?')),
          content: Text(
            'Yes. Defaults come from the global tokens and every part is '
            'overridable through AccordionTheme.',
          ),
        ),
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it animated?')),
          content: Text('Yes. Items animate with the theme duration.'),
        ),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Multiple',
      builder: '_accordionMultiple',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/accordion/accordion.dart';

/// Two accordions stacked, so more than one can be open at a time.
Widget _accordionMultiple(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _AccordionTwoItemAccordion(),
      ),
      Gap(spacing.lg),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _AccordionTwoItemAccordion(),
      ),
    ],
  );
}

class _AccordionTwoItemAccordion extends StatelessWidget {
  const _AccordionTwoItemAccordion();

  @override
  Widget build(BuildContext context) {
    return const Accordion(
      items: <Widget>[
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Shipping')),
          content: Text('Dispatched within two working days.'),
        ),
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Returns')),
          content: Text('Free returns within 30 days.'),
        ),
      ],
    );
  }
}
''',
    ),
  ],
  'card': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_cardDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/card/card.dart';

/// The full shadcn slot composition.
//
// P7-D1b: capped at 320 px (not fixed) so narrow phones shrink it instead of
// overflowing; the stage centres it.
Widget _cardDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 320),
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardTitle(child: Text('Deployments')),
                CardDescription(child: Text('Ship a new build to production.')),
              ],
            ),
          ),
          Gap(spacing.lg),
          const CardContent(
            child: Text(
              'Every deploy is immutable; roll back from the history tab.',
            ),
          ),
          Gap(spacing.lg),
          CardFooter(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Button(
                  size: ButtonSize.sm,
                  variant: ButtonVariant.ghost,
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                Gap(spacing.sm),
                Button(
                  size: ButtonSize.sm,
                  onPressed: () {},
                  child: const Text('Deploy'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With media',
      builder: '_cardWithMedia',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/card/card.dart';

/// A card whose header carries a clipped media band.
Widget _cardWithMedia(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 320),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 96,
            child: ColoredBox(
              color: theme.colors.muted,
              child: Center(
                child: Icon(
                  LucideIcons.image,
                  size: 24,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          ),
          const CardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CardTitle(child: Text('Cover art')),
                CardDescription(
                  child: Text('Generated from the preset palette.'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With footer',
      builder: '_cardWithFooter',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/card/card.dart';

/// A bare surface with only the footer slot filled.
Widget _cardWithFooter(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 320),
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CardTitle(child: Text('Billing')),
          Gap(theme.spacing.xs),
          Text(
            'Bare card, default padding',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
          Gap(theme.spacing.lg),
          CardFooter(
            padding: EdgeInsetsDensity.pxAll(0),
            child: Button(
              size: ButtonSize.sm,
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Manage plan'),
            ),
          ),
        ],
      ),
    ),
  );
}
''',
    ),
  ],
  'card_image': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Vertical',
      builder: '_cardImageVertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/card_image/card_image.dart';

/// A palette-derived thumbnail, so the demo follows the selected theme.
Widget _cardImageThumb(BuildContext context, double height) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    height: height,
    child: ColoredBox(
      color: theme.colors.muted,
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 28,
          color: theme.colors.mutedForeground,
        ),
      ),
    ),
  );
}

/// Vertical composition: media above the text block.
Widget _cardImageVertical(BuildContext context) {
  return SizedBox(
    width: 220,
    child: CardImage(
      image: _cardImageThumb(context, 120),
      title: const Text('Sunset'),
      subtitle: const Text('18:42 - Lisbon'),
      onPressed: () {},
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Horizontal',
      builder: '_cardImageHorizontal',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/card_image/card_image.dart';

/// A palette-derived thumbnail, so the demo follows the selected theme.
Widget _cardImageThumb(BuildContext context, double height) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    height: height,
    child: ColoredBox(
      color: theme.colors.muted,
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 28,
          color: theme.colors.mutedForeground,
        ),
      ),
    ),
  );
}

/// Horizontal composition: media beside the text block.
Widget _cardImageHorizontal(BuildContext context) {
  return SizedBox(
    width: 320,
    child: CardImage(
      theme: const CardImageTheme(direction: Axis.horizontal, gap: 12),
      image: SizedBox(width: 96, child: _cardImageThumb(context, 120)),
      title: const Text('Track'),
      subtitle: const Text('3:21 - Ambient'),
      onPressed: () {},
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_cardImageDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/card_image/card_image.dart';

/// A palette-derived thumbnail, so the demo follows the selected theme.
Widget _cardImageThumb(BuildContext context, double height) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    height: height,
    child: ColoredBox(
      color: theme.colors.muted,
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 28,
          color: theme.colors.mutedForeground,
        ),
      ),
    ),
  );
}

/// The disabled card (no `onPressed`).
Widget _cardImageDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        width: 220,
        child: CardImage(
          image: _cardImageThumb(context, 120),
          title: const Text('Disabled'),
          subtitle: const Text('onPressed is null'),
        ),
      ),
      Gap(spacing.lg),
      SizedBox(
        width: 220,
        child: CardImage(
          image: _cardImageThumb(context, 120),
          title: const Text('Compact'),
          subtitle: const Text('denser padding'),
          onPressed: () {},
        ),
      ),
    ],
  );
}
''',
    ),
  ],
  'collapsible': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_collapsibleDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/collapsible/collapsible.dart';

/// One muted row of the branch list.
Widget _collapsibleRow(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusLg,
    ),
    child: Padding(padding: EdgeInsetsDensity.pxAll(12), child: Text(label)),
  );
}

/// Uncontrolled: the section keeps its own state.
class _CollapsibleUncontrolled extends StatelessWidget {
  const _CollapsibleUncontrolled();

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Collapsible(
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Recent activity')),
          Gap(spacing.sm),
          _collapsibleRow(context, '@mibrar-dev/shadcn_flutter_kit'),
          CollapsibleContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Gap(spacing.sm),
                _collapsibleRow(context, '@flutter/flutter'),
                Gap(spacing.sm),
                _collapsibleRow(context, '@dart-lang/sdk'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _collapsibleDefault(BuildContext context) =>
    const _CollapsibleUncontrolled();
''',
    ),
    DocsExampleSource(
      name: 'Controlled',
      builder: '_collapsibleControlledExample',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/collapsible/collapsible.dart';

/// One muted row of the branch list.
Widget _collapsibleRow(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusLg,
    ),
    child: Padding(padding: EdgeInsetsDensity.pxAll(12), child: Text(label)),
  );
}

/// Controlled: the example owns the expansion state.
class _CollapsibleControlled extends StatefulWidget {
  const _CollapsibleControlled();

  @override
  State<_CollapsibleControlled> createState() => _CollapsibleControlledState();
}

class _CollapsibleControlledState extends State<_CollapsibleControlled> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Collapsible(
        isExpanded: _expanded,
        onExpansionChanged: (bool value) => setState(() => _expanded = value),
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Controlled section')),
          Gap(spacing.sm),
          CollapsibleContent(
            child: _collapsibleRow(context, 'Toggled by the parent'),
          ),
          Gap(spacing.sm),
          Text(_expanded ? 'open' : 'closed'),
        ],
      ),
    );
  }
}

Widget _collapsibleControlledExample(BuildContext context) =>
    const _CollapsibleControlled();
''',
    ),
  ],
  'filter_bar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/filter_bar/filter_bar.dart';

const List<FilterSortOption> _sortOptions = <FilterSortOption>[
  FilterSortOption(id: 'newest', label: 'Newest'),
  FilterSortOption(id: 'oldest', label: 'Oldest'),
];

/// Inline bar with sort options and a result count.
class _DefaultFilterBar extends StatefulWidget {
  const _DefaultFilterBar();

  @override
  State<_DefaultFilterBar> createState() => _DefaultFilterBarState();
}

class _DefaultFilterBarState extends State<_DefaultFilterBar> {
  FilterState _state = const FilterState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: FilterBar(
        state: _state,
        onStateChanged: (FilterState next) => setState(() => _state = next),
        sortOptions: _sortOptions,
        resultsCount: 42,
        presentation: FilterBarPresentation.inline,
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultFilterBar();
''',
    ),
    DocsExampleSource(
      name: 'With chips',
      builder: '_withChips',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/filter_bar/filter_bar.dart';

const List<FilterSortOption> _sortOptions = <FilterSortOption>[
  FilterSortOption(id: 'newest', label: 'Newest'),
  FilterSortOption(id: 'oldest', label: 'Oldest'),
];

/// Inline bar with an active filter chip.
class _ChipsFilterBar extends StatefulWidget {
  const _ChipsFilterBar();

  @override
  State<_ChipsFilterBar> createState() => _ChipsFilterBarState();
}

class _ChipsFilterBarState extends State<_ChipsFilterBar> {
  FilterState _state = const FilterState(
    sortId: 'newest',
    chips: <FilterChipData>[FilterChipData(key: 'tag:vip', label: 'Tag: VIP')],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: FilterBar(
        state: _state,
        onStateChanged: (FilterState next) => setState(() => _state = next),
        sortOptions: _sortOptions,
        resultsCount: 3,
        presentation: FilterBarPresentation.inline,
      ),
    );
  }
}

Widget _withChips(BuildContext context) => const _ChipsFilterBar();
''',
    ),
  ],
  'overflow_marquee': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Horizontal',
      builder: '_horizontal',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/overflow_marquee/overflow_marquee.dart';

/// Long enough to overflow a narrow container and keep scrolling.
const String _line =
    'The quick brown fox jumps over the lazy dog — long enough to overflow '
    'a narrow container and keep scrolling.';

/// A horizontal ticker in a bordered band.
Widget _horizontal(BuildContext context) {
  final ShadcnColors colors = ShadcnTheme.of(context).colors;
  return SizedBox(
    width: 320,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.sm),
        child: const OverflowMarquee(
          duration: Duration(seconds: 6),
          child: Text(_line),
        ),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_vertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/overflow_marquee/overflow_marquee.dart';

/// Long enough to overflow a narrow container and keep scrolling.
const String _line =
    'The quick brown fox jumps over the lazy dog — long enough to overflow '
    'a narrow container and keep scrolling.';

/// A vertical ticker in a short viewport.
Widget _vertical(BuildContext context) {
  return const SizedBox(
    width: 200,
    height: 120,
    child: OverflowMarquee(
      direction: Axis.vertical,
      duration: Duration(seconds: 3),
      child: SizedBox(height: 160, child: Text(_line)),
    ),
  );
}
''',
    ),
  ],
  'resizable': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Absolute',
      builder: '_absolute',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/resizable/resizable.dart';

/// A muted pane label in theme tokens.
class _Pane extends StatelessWidget {
  const _Pane(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: theme.colors.muted,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: theme.colors.mutedForeground),
      ),
    );
  }
}

/// Panes sized in absolute pixels.
Widget _absolute(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 140,
    child: ResizablePanelGroup(
      children: <Widget>[
        ResizablePanel(defaultSize: 120, child: _Pane('Sidebar')),
        ResizableHandle(withHandle: true),
        ResizablePanel(defaultSize: 200, child: _Pane('Main')),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Flexible',
      builder: '_flexible',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/resizable/resizable.dart';

/// A muted pane label in theme tokens.
class _Pane extends StatelessWidget {
  const _Pane(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: theme.colors.muted,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: theme.colors.mutedForeground),
      ),
    );
  }
}

/// Panes sharing space by flex.
Widget _flexible(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 140,
    child: ResizablePanelGroup(
      children: <Widget>[
        ResizablePanel(flex: 2, child: _Pane('Main')),
        ResizableHandle(withHandle: true),
        ResizablePanel(flex: 1, child: _Pane('Inspector')),
      ],
    ),
  );
}
''',
    ),
  ],
  'scaffold': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/scaffold/scaffold.dart';

/// A shell with a header bar, a footer bar and body content.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 280,
    child: Scaffold(
      headers: <Widget>[
        AppBar(
          leading: <Widget>[Icon(LucideIcons.chevronLeft, size: 16)],
          title: Text('My Application'),
          subtitle: Text('Dashboard'),
          trailing: <Widget>[Icon(LucideIcons.ellipsis, size: 16)],
        ),
      ],
      footers: <Widget>[
        AppBar(title: Text('Status'), subtitle: Text('All systems go')),
      ],
      child: Center(child: Text('Main content area')),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With loading',
      builder: '_withLoading',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/components/scaffold/scaffold.dart';

/// A shell showing the loading bar over fetching content.
Widget _withLoading(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 200,
    child: Scaffold(
      headers: <Widget>[AppBar(title: Text('Syncing'))],
      loadingProgress: 0.4,
      showLoadingSparks: true,
      child: Center(child: Text('Fetching...')),
    ),
  );
}
''',
    ),
  ],
  'scrollbar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/scrollbar/scrollbar.dart';

/// A scrollable list; the controller lives in the example's own state.
class _ScrollbarDemo extends StatefulWidget {
  const _ScrollbarDemo({this.thumbVisibility, this.trackVisibility});

  final bool? thumbVisibility;
  final bool? trackVisibility;

  @override
  State<_ScrollbarDemo> createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<_ScrollbarDemo> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: widget.thumbVisibility,
        trackVisibility: widget.trackVisibility,
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Item ${index + 1}'),
          ),
        ),
      ),
    );
  }
}

/// The default auto-hiding thumb.
Widget _default(BuildContext context) => const _ScrollbarDemo();
''',
    ),
    DocsExampleSource(
      name: 'Always visible',
      builder: '_alwaysVisible',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/scrollbar/scrollbar.dart';

/// A scrollable list; the controller lives in the example's own state.
class _ScrollbarDemo extends StatefulWidget {
  const _ScrollbarDemo({this.thumbVisibility, this.trackVisibility});

  final bool? thumbVisibility;
  final bool? trackVisibility;

  @override
  State<_ScrollbarDemo> createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<_ScrollbarDemo> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: widget.thumbVisibility,
        trackVisibility: widget.trackVisibility,
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Item ${index + 1}'),
          ),
        ),
      ),
    );
  }
}

/// A permanently visible thumb over a track.
Widget _alwaysVisible(BuildContext context) =>
    const _ScrollbarDemo(thumbVisibility: true, trackVisibility: true);
''',
    ),
    DocsExampleSource(
      name: 'Themed',
      builder: '_themed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/scrollbar/scrollbar.dart';

/// A scrollable list; the controller lives in the example's own state.
class _ScrollbarDemo extends StatefulWidget {
  const _ScrollbarDemo({this.thumbVisibility, this.trackVisibility});

  final bool? thumbVisibility;
  final bool? trackVisibility;

  @override
  State<_ScrollbarDemo> createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<_ScrollbarDemo> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: widget.thumbVisibility,
        trackVisibility: widget.trackVisibility,
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Item ${index + 1}'),
          ),
        ),
      ),
    );
  }
}

/// A thumb tinted from the theme tokens.
Widget _themed(BuildContext context) {
  return const ComponentTheme<ScrollbarTheme>(
    data: ScrollbarTheme(
      color: ThemedColor.ref(ColorRef.primary),
      thickness: 10,
    ),
    child: _ScrollbarDemo(thumbVisibility: true),
  );
}
''',
    ),
  ],
  'sortable': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/sortable/sortable.dart';

/// One draggable row in theme tokens.
class _Row extends StatelessWidget {
  const _Row({required this.item, this.candidate = false});

  final String item;
  final bool candidate;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: candidate ? theme.colors.accent : theme.colors.card,
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.borderRadiusMd,
      ),
      child: Row(
        children: <Widget>[
          SortableDragHandle(
            child: Icon(
              LucideIcons.gripVertical,
              size: 14,
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.md),
          Expanded(child: Text(item)),
        ],
      ),
    );
  }
}

/// A reorderable vertical list.
class _ListDemo extends StatefulWidget {
  const _ListDemo();

  @override
  State<_ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<_ListDemo> {
  final List<String> _items = <String>['Alpha', 'Beta', 'Gamma', 'Delta'];

  void _move(String dragged, String target, bool above) {
    setState(() {
      _items.remove(dragged);
      final int index = _items.indexOf(target);
      _items.insert(above ? index : index + 1, dragged);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SortableLayer(
        lock: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final String item in _items)
              Sortable<String>(
                key: ValueKey<String>(item),
                data: SortableData<String>(item),
                onAcceptTop: (SortableData<String> data) =>
                    _move(data.data, item, true),
                onAcceptBottom: (SortableData<String> data) =>
                    _move(data.data, item, false),
                candidateFallback: _Row(item: item, candidate: true),
                fallback: Opacity(opacity: 0.3, child: _Row(item: item)),
                child: _Row(item: item),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _ListDemo();
''',
    ),
    DocsExampleSource(
      name: 'Grid',
      builder: '_grid',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/sortable/sortable.dart';

/// One draggable tile in theme tokens.
class _Tile extends StatelessWidget {
  const _Tile({required this.item, this.candidate = false});

  final String item;
  final bool candidate;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: candidate ? theme.colors.accent : theme.colors.card,
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.borderRadiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SortableDragHandle(
            child: Icon(
              LucideIcons.gripVertical,
              size: 14,
              color: theme.colors.mutedForeground,
            ),
          ),
          Gap(theme.spacing.sm),
          Expanded(child: Text(item)),
        ],
      ),
    );
  }
}

/// The same items as a wrapping grid of tiles.
class _GridDemo extends StatefulWidget {
  const _GridDemo();

  @override
  State<_GridDemo> createState() => _GridDemoState();
}

class _GridDemoState extends State<_GridDemo> {
  final List<String> _items = <String>[
    'Alpha',
    'Beta',
    'Gamma',
    'Delta',
    'Epsilon',
    'Zeta',
  ];

  void _move(String dragged, String target, bool above) {
    setState(() {
      _items.remove(dragged);
      final int index = _items.indexOf(target);
      _items.insert(above ? index : index + 1, dragged);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return SizedBox(
      width: 340,
      child: SortableLayer(
        lock: true,
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: <Widget>[
            for (final String item in _items)
              Sortable<String>(
                key: ValueKey<String>(item),
                data: SortableData<String>(item),
                onAcceptTop: (SortableData<String> data) =>
                    _move(data.data, item, true),
                onAcceptBottom: (SortableData<String> data) =>
                    _move(data.data, item, false),
                candidateFallback: _Tile(item: item, candidate: true),
                fallback: Opacity(opacity: 0.3, child: _Tile(item: item)),
                child: _Tile(item: item),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _grid(BuildContext context) => const _GridDemo();
''',
    ),
  ],
  'steps': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/components/steps/steps.dart';

/// The default vertical flow.
Widget _default(BuildContext context) {
  return const Steps(
    children: <Widget>[
      StepItem(
        title: Text('Account'),
        content: <Widget>[Text('Sign up with your email address.')],
      ),
      StepItem(
        title: Text('Verify'),
        content: <Widget>[Text('Check your inbox for a code.')],
      ),
      StepItem(
        title: Text('Profile'),
        content: <Widget>[Text('Add your personal information.')],
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Custom indicators',
      builder: '_custom',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/components/steps/steps.dart';

/// Larger indicators tinted with the primary token.
Widget _custom(BuildContext context) {
  return const Steps(
    theme: StepsTheme(
      indicatorSize: 32,
      indicatorColor: ThemedColor.ref(ColorRef.primary),
      indicatorForeground: ThemedColor.ref(ColorRef.primaryForeground),
      connectorColor: ThemedColor.ref(ColorRef.primary, alpha: 0.4),
    ),
    children: <Widget>[
      StepItem(title: Text('Cart'), content: <Widget>[Text('Review items.')]),
      StepItem(title: Text('Pay'), content: <Widget>[Text('Choose a method.')]),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Single step',
      builder: '_single',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/components/steps/steps.dart';

/// A single step.
Widget _single(BuildContext context) {
  return const Steps(
    children: <Widget>[
      StepItem(title: Text('Done'), content: <Widget>[Text('Nothing else.')]),
    ],
  );
}
''',
    ),
  ],
  'command': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_commandDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/subfocus_list_item.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/command/command.dart';

/// Fruit list the palette filters over.
const List<String> _commandValues = <String>[
  'Calendar',
  'Search Emoji',
  'Launch',
  'Profile',
  'Mail',
  'Settings',
];

/// The palette itself, sized to the stage.
class _CommandPalette extends StatelessWidget {
  const _CommandPalette({this.buildGroups = false});

  final bool buildGroups;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: SizedBox(
        width: 320,
        height: 300,
        child: Command(
          debounceDuration: Duration.zero,
          builder: (context, query) async* {
            final List<Widget> items = <Widget>[];
            if (!buildGroups) {
              for (final String value in _commandValues) {
                if (query == null ||
                    value.toLowerCase().contains(query.toLowerCase())) {
                  items.add(SubFocusListItem(title: Text(value), onTap: () {}));
                }
              }
            } else {
              for (final String group in const <String>[
                'Suggestions',
                'Settings',
              ]) {
                items.add(
                  // shadcn group heading: `px-2 py-1.5 text-xs font-medium`
                  // in the muted colour.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      group,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ShadcnTheme.of(context).colors.mutedForeground,
                      ),
                    ),
                  ),
                );
                for (final String value in _commandValues) {
                  if (query == null ||
                      value.toLowerCase().contains(query.toLowerCase())) {
                    items.add(
                      SubFocusListItem(title: Text(value), onTap: () {}),
                    );
                  }
                }
                items.add(SizedBox(height: spacing.sm));
              }
            }
            yield items;
          },
        ),
      ),
    );
  }
}

/// The default palette.
Widget _commandDefault(BuildContext context) => const _CommandPalette();
''',
    ),
    DocsExampleSource(
      name: 'With groups',
      builder: '_commandWithGroups',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/subfocus_list_item.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/command/command.dart';

/// Fruit list the palette filters over.
const List<String> _commandValues = <String>[
  'Calendar',
  'Search Emoji',
  'Launch',
  'Profile',
  'Mail',
  'Settings',
];

/// The palette itself, sized to the stage.
class _CommandPalette extends StatelessWidget {
  const _CommandPalette({this.buildGroups = false});

  final bool buildGroups;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Center(
      child: SizedBox(
        width: 320,
        height: 300,
        child: Command(
          debounceDuration: Duration.zero,
          builder: (context, query) async* {
            final List<Widget> items = <Widget>[];
            if (!buildGroups) {
              for (final String value in _commandValues) {
                if (query == null ||
                    value.toLowerCase().contains(query.toLowerCase())) {
                  items.add(SubFocusListItem(title: Text(value), onTap: () {}));
                }
              }
            } else {
              for (final String group in const <String>[
                'Suggestions',
                'Settings',
              ]) {
                items.add(
                  // shadcn group heading: `px-2 py-1.5 text-xs font-medium`
                  // in the muted colour.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      group,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ShadcnTheme.of(context).colors.mutedForeground,
                      ),
                    ),
                  ),
                );
                for (final String value in _commandValues) {
                  if (query == null ||
                      value.toLowerCase().contains(query.toLowerCase())) {
                    items.add(
                      SubFocusListItem(title: Text(value), onTap: () {}),
                    );
                  }
                }
                items.add(SizedBox(height: spacing.sm));
              }
            }
            yield items;
          },
        ),
      ),
    );
  }
}

/// The palette with grouped results.
Widget _commandWithGroups(BuildContext context) =>
    const _CommandPalette(buildGroups: true);
''',
    ),
  ],
  'context_menu': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_contextMenuDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/context_menu/context_menu.dart';

/// The right-click surface.
class _ContextMenuSurface extends StatelessWidget {
  const _ContextMenuSurface({this.withSubmenu = false});

  final bool withSubmenu;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Center(
      child: ContextMenu(
        items: <Widget>[
          MenuButton(child: const Text('Back'), onPressed: (_) {}),
          MenuButton(child: const Text('Reload'), onPressed: (_) {}),
          MenuButton(
            trailing: const MenuShortcut(shortcut: '⌘C'),
            child: const Text('Copy link'),
            onPressed: (_) {},
          ),
          const MenuSeparator(),
          MenuButton(
            trailing: const Icon(LucideIcons.chevronRight, size: 14),
            enabled: withSubmenu,
            child: const Text('More tools'),
            onPressed: (_) {},
          ),
          MenuButton(
            enabled: false,
            child: const Text('Inspect'),
            onPressed: (_) {},
          ),
        ],
        child: Container(
          width: 220,
          padding: EdgeInsetsDensity.pxAll(32),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.border),
            borderRadius: theme.borderRadiusMd,
          ),
          child: Text(
            withSubmenu
                ? 'Right-click: the submenu row is enabled'
                : 'Right-click anywhere on this card',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
        ),
      ),
    );
  }
}

/// The default context menu surface.
Widget _contextMenuDefault(BuildContext context) => const _ContextMenuSurface();
''',
    ),
    DocsExampleSource(
      name: 'With submenu',
      builder: '_contextMenuWithSubmenu',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/context_menu/context_menu.dart';

/// The right-click surface.
class _ContextMenuSurface extends StatelessWidget {
  const _ContextMenuSurface({this.withSubmenu = false});

  final bool withSubmenu;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Center(
      child: ContextMenu(
        items: <Widget>[
          MenuButton(child: const Text('Back'), onPressed: (_) {}),
          MenuButton(child: const Text('Reload'), onPressed: (_) {}),
          MenuButton(
            trailing: const MenuShortcut(shortcut: '⌘C'),
            child: const Text('Copy link'),
            onPressed: (_) {},
          ),
          const MenuSeparator(),
          MenuButton(
            trailing: const Icon(LucideIcons.chevronRight, size: 14),
            enabled: withSubmenu,
            child: const Text('More tools'),
            onPressed: (_) {},
          ),
          MenuButton(
            enabled: false,
            child: const Text('Inspect'),
            onPressed: (_) {},
          ),
        ],
        child: Container(
          width: 220,
          padding: EdgeInsetsDensity.pxAll(32),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.border),
            borderRadius: theme.borderRadiusMd,
          ),
          child: Text(
            withSubmenu
                ? 'Right-click: the submenu row is enabled'
                : 'Right-click anywhere on this card',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
        ),
      ),
    );
  }
}

/// A surface whose menu row opens a submenu.
Widget _contextMenuWithSubmenu(BuildContext context) =>
    const _ContextMenuSurface(withSubmenu: true);
''',
    ),
  ],
  'dropdown_menu': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_dropdownMenuDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/dropdown_menu/dropdown_menu.dart';

/// The menu surface, 220px wide like the docs page shows it.
class _DropdownMenuDropdown extends StatelessWidget {
  const _DropdownMenuDropdown({
    this.withShortcut = false,
    this.withCheckbox = false,
  });

  final bool withShortcut;
  final bool withCheckbox;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        child: DropdownMenu(
          children: <Widget>[
            MenuButton(child: const Text('Profile'), onPressed: (_) {}),
            MenuButton(child: const Text('Settings'), onPressed: (_) {}),
            const MenuSeparator(),
            if (withShortcut)
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘Q'),
                child: const Text('Sign out'),
                onPressed: (_) {},
              )
            else
              MenuButton(child: const Text('Sign out'), onPressed: (_) {}),
            if (withCheckbox) ...<Widget>[
              const MenuSeparator(),
              MenuButton(
                trailing: const Text('on'),
                child: const Text('Show status bar'),
                onPressed: (_) {},
              ),
              MenuButton(
                trailing: const Text('off'),
                child: const Text('Show bookmarks bar'),
                onPressed: (_) {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The default menu.
Widget _dropdownMenuDefault(BuildContext context) =>
    const _DropdownMenuDropdown();
''',
    ),
    DocsExampleSource(
      name: 'With shortcut',
      builder: '_dropdownMenuWithShortcut',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/dropdown_menu/dropdown_menu.dart';

/// The menu surface, 220px wide like the docs page shows it.
class _DropdownMenuDropdown extends StatelessWidget {
  const _DropdownMenuDropdown({
    this.withShortcut = false,
    this.withCheckbox = false,
  });

  final bool withShortcut;
  final bool withCheckbox;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        child: DropdownMenu(
          children: <Widget>[
            MenuButton(child: const Text('Profile'), onPressed: (_) {}),
            MenuButton(child: const Text('Settings'), onPressed: (_) {}),
            const MenuSeparator(),
            if (withShortcut)
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘Q'),
                child: const Text('Sign out'),
                onPressed: (_) {},
              )
            else
              MenuButton(child: const Text('Sign out'), onPressed: (_) {}),
            if (withCheckbox) ...<Widget>[
              const MenuSeparator(),
              MenuButton(
                trailing: const Text('on'),
                child: const Text('Show status bar'),
                onPressed: (_) {},
              ),
              MenuButton(
                trailing: const Text('off'),
                child: const Text('Show bookmarks bar'),
                onPressed: (_) {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A menu with keyboard shortcuts.
Widget _dropdownMenuWithShortcut(BuildContext context) =>
    const _DropdownMenuDropdown(withShortcut: true);
''',
    ),
    DocsExampleSource(
      name: 'With checkbox item',
      builder: '_dropdownMenuWithCheckboxItem',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/dropdown_menu/dropdown_menu.dart';

/// The menu surface, 220px wide like the docs page shows it.
class _DropdownMenuDropdown extends StatelessWidget {
  const _DropdownMenuDropdown({
    this.withShortcut = false,
    this.withCheckbox = false,
  });

  final bool withShortcut;
  final bool withCheckbox;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        child: DropdownMenu(
          children: <Widget>[
            MenuButton(child: const Text('Profile'), onPressed: (_) {}),
            MenuButton(child: const Text('Settings'), onPressed: (_) {}),
            const MenuSeparator(),
            if (withShortcut)
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘Q'),
                child: const Text('Sign out'),
                onPressed: (_) {},
              )
            else
              MenuButton(child: const Text('Sign out'), onPressed: (_) {}),
            if (withCheckbox) ...<Widget>[
              const MenuSeparator(),
              MenuButton(
                trailing: const Text('on'),
                child: const Text('Show status bar'),
                onPressed: (_) {},
              ),
              MenuButton(
                trailing: const Text('off'),
                child: const Text('Show bookmarks bar'),
                onPressed: (_) {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A menu with checkbox-style rows.
Widget _dropdownMenuWithCheckboxItem(BuildContext context) =>
    const _DropdownMenuDropdown(withCheckbox: true);
''',
    ),
  ],
  'menu': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';

/// Menu rows with a submenu and a disabled row.
Widget _default(BuildContext context) {
  return MenuPopup(
    width: 240,
    children: <Widget>[
      MenuGroup(
        autofocus: false,
        children: <Widget>[
          MenuButton(child: const Text('Cut'), onPressed: (_) {}),
          MenuButton(child: const Text('Copy'), onPressed: (_) {}),
          MenuButton(child: const Text('Paste'), onPressed: (_) {}),
          const MenuSeparator(),
          MenuButton(
            subMenu: <Widget>[
              MenuButton(child: const Text('Email'), onPressed: (_) {}),
              MenuButton(child: const Text('Link'), onPressed: (_) {}),
            ],
            onPressed: (_) {},
            child: const Text('Share'),
          ),
          MenuButton(
            enabled: false,
            onPressed: null,
            child: const Text('Delete'),
          ),
        ],
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With checkbox item',
      builder: '_withCheckboxItem',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';

/// A labelled group with a live checkbox row.
class _CheckboxExample extends StatefulWidget {
  const _CheckboxExample();

  @override
  State<_CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<_CheckboxExample> {
  bool _toolbar = true;

  @override
  Widget build(BuildContext context) {
    return MenuPopup(
      width: 240,
      children: <Widget>[
        MenuGroup(
          autofocus: false,
          children: <Widget>[
            const MenuLabel(child: Text('Options')),
            MenuCheckboxItem(
              value: _toolbar,
              onChanged: (BuildContext _, bool value) =>
                  setState(() => _toolbar = value),
              trailing: const MenuShortcut(shortcut: '⌘T'),
              child: const Text('Toolbar'),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _withCheckboxItem(BuildContext context) => const _CheckboxExample();
''',
    ),
    DocsExampleSource(
      name: 'With radio group',
      builder: '_withRadioGroup',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';

/// A live radio group.
class _RadioExample extends StatefulWidget {
  const _RadioExample();

  @override
  State<_RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<_RadioExample> {
  String _side = 'left';

  @override
  Widget build(BuildContext context) {
    return MenuPopup(
      width: 240,
      children: <Widget>[
        MenuGroup(
          autofocus: false,
          children: <Widget>[
            MenuRadioGroup<String>(
              value: _side,
              onChanged: (BuildContext _, String value) =>
                  setState(() => _side = value),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MenuRadioItem<String>(value: 'left', child: Text('Left')),
                  MenuRadioItem<String>(value: 'right', child: Text('Right')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _withRadioGroup(BuildContext context) => const _RadioExample();
''',
    ),
  ],
  'menubar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/menubar/menubar.dart';

/// File / Edit / View triggers, each with a submenu of menu rows.
Widget _default(BuildContext context) {
  return Menubar(
    children: <Widget>[
      MenuButton(
        subMenu: <Widget>[
          MenuButton(child: const Text('New'), onPressed: (_) {}),
          MenuButton(child: const Text('Open'), onPressed: (_) {}),
          const MenuSeparator(),
          MenuButton(
            trailing: const MenuShortcut(shortcut: '⌘S'),
            child: const Text('Save'),
            onPressed: (_) {},
          ),
        ],
        child: const Text('File'),
      ),
      MenuButton(
        subMenu: <Widget>[
          MenuButton(child: const Text('Cut'), onPressed: (_) {}),
          MenuButton(child: const Text('Copy'), onPressed: (_) {}),
        ],
        child: const Text('Edit'),
      ),
      MenuButton(
        subMenu: <Widget>[
          const MenuLabel(child: Text('Zoom')),
          MenuButton(child: const Text('100%'), onPressed: (_) {}),
          MenuButton(child: const Text('150%'), onPressed: (_) {}),
        ],
        child: const Text('View'),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With submenu',
      builder: '_withSubmenu',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/menubar/menubar.dart';

/// A nested submenu under the View trigger.
Widget _withSubmenu(BuildContext context) {
  return Menubar(
    children: <Widget>[
      MenuButton(
        subMenu: <Widget>[
          const MenuLabel(child: Text('Zoom')),
          MenuSub(
            trigger: const Text('Zoom level'),
            children: <Widget>[
              MenuButton(child: const Text('100%'), onPressed: (_) {}),
              MenuButton(child: const Text('150%'), onPressed: (_) {}),
            ],
          ),
        ],
        child: const Text('View'),
      ),
    ],
  );
}
''',
    ),
  ],
  'breadcrumb': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_breadcrumbDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/breadcrumb/breadcrumb.dart';

/// The default chevron trail.
Widget _breadcrumbDefault(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: Breadcrumb(
      children: <Widget>[Text('Home'), Text('Components'), Text('Breadcrumb')],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With slash',
      builder: '_breadcrumbSlash',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/breadcrumb/breadcrumb.dart';

/// The slash separator.
Widget _breadcrumbSlash(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: Breadcrumb(
      separator: Breadcrumb.slashSeparator,
      children: <Widget>[
        Text('src'),
        Text('components'),
        Text('breadcrumb.dart'),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Collapsed',
      builder: '_breadcrumbCollapsed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/breadcrumb/breadcrumb.dart';

/// A collapsed trail: the root collapses to an ellipsis crumb.
Widget _breadcrumbCollapsed(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Align(
        alignment: AlignmentDirectional.centerStart,
        child: Breadcrumb(
          separator: Breadcrumb.slashSeparator,
          children: <Widget>[
            Text('...'),
            Text('components'),
            Text('breadcrumb.dart'),
          ],
        ),
      ),
      Gap(spacing.lg),
      const Align(
        alignment: AlignmentDirectional.centerStart,
        child: Breadcrumb(
          padding: EdgeInsetsDensity.pxSymmetric(horizontal: 4),
          children: <Widget>[Text('Docs'), Text('Getting started')],
        ),
      ),
    ],
  );
}
''',
    ),
  ],
  'navigation_bar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/radix_icons.dart';
import 'package:<your_app>/ui/shadcn/components/navigation_bar/navigation_bar.dart';

/// Shared bar items for the horizontal examples.
List<NavigationBarItem> _barItems() => <NavigationBarItem>[
  const NavigationItem(label: Text('Home'), child: Icon(RadixIcons.home)),
  const NavigationItem(
    label: Text('Search'),
    child: Icon(RadixIcons.magnifyingGlass),
  ),
  const NavigationItem(label: Text('Settings'), child: Icon(RadixIcons.gear)),
  const NavigationItem(
    label: Text('Disabled'),
    enabled: false,
    child: Icon(RadixIcons.person),
  ),
];

/// An interactive horizontal bar; selection lives in this example's state.
class _InteractiveBar extends StatefulWidget {
  const _InteractiveBar({this.labelType});

  final NavigationLabelType? labelType;

  @override
  State<_InteractiveBar> createState() => _InteractiveBarState();
}

class _InteractiveBarState extends State<_InteractiveBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      index: _index,
      onSelected: (int value) => setState(() => _index = value),
      labelType: widget.labelType,
      children: _barItems(),
    );
  }
}

/// The default bar: only the selected item shows its label.
Widget _default(BuildContext context) =>
    const _InteractiveBar(labelType: NavigationLabelType.selected);
''',
    ),
    DocsExampleSource(
      name: 'With labels',
      builder: '_withLabels',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/radix_icons.dart';
import 'package:<your_app>/ui/shadcn/components/navigation_bar/navigation_bar.dart';

/// Shared bar items for the horizontal examples.
List<NavigationBarItem> _barItems() => <NavigationBarItem>[
  const NavigationItem(label: Text('Home'), child: Icon(RadixIcons.home)),
  const NavigationItem(
    label: Text('Search'),
    child: Icon(RadixIcons.magnifyingGlass),
  ),
  const NavigationItem(label: Text('Settings'), child: Icon(RadixIcons.gear)),
  const NavigationItem(
    label: Text('Disabled'),
    enabled: false,
    child: Icon(RadixIcons.person),
  ),
];

/// An interactive horizontal bar; selection lives in this example's state.
class _InteractiveBar extends StatefulWidget {
  const _InteractiveBar({this.labelType});

  final NavigationLabelType? labelType;

  @override
  State<_InteractiveBar> createState() => _InteractiveBarState();
}

class _InteractiveBarState extends State<_InteractiveBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      index: _index,
      onSelected: (int value) => setState(() => _index = value),
      labelType: widget.labelType,
      children: _barItems(),
    );
  }
}

/// A bar with every label visible.
Widget _withLabels(BuildContext context) =>
    const _InteractiveBar(labelType: NavigationLabelType.all);
''',
    ),
    DocsExampleSource(
      name: 'Sidebar',
      builder: '_sidebar',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/radix_icons.dart';
import 'package:<your_app>/ui/shadcn/components/navigation_bar/navigation_bar.dart';

/// Shared bar items for the horizontal examples.
List<NavigationBarItem> _barItems() => <NavigationBarItem>[
  const NavigationItem(label: Text('Home'), child: Icon(RadixIcons.home)),
  const NavigationItem(
    label: Text('Search'),
    child: Icon(RadixIcons.magnifyingGlass),
  ),
  const NavigationItem(label: Text('Settings'), child: Icon(RadixIcons.gear)),
  const NavigationItem(
    label: Text('Disabled'),
    enabled: false,
    child: Icon(RadixIcons.person),
  ),
];

/// A bounded sidebar with a label, a divider and a grouped collapsible.
class _SidebarDemo extends StatefulWidget {
  const _SidebarDemo();

  @override
  State<_SidebarDemo> createState() => _SidebarDemoState();
}

class _SidebarDemoState extends State<_SidebarDemo> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 320,
      child: NavigationBar(
        container: NavigationContainerType.sidebar,
        index: _index,
        onSelected: (int value) => setState(() => _index = value),
        children: <NavigationBarItem>[
          const NavigationLabel(child: Text('Main')),
          ..._barItems(),
          const NavigationDivider(),
          NavigationGroup(
            label: const Text('Account'),
            children: <Widget>[
              NavigationCollapsible(
                label: const Text('Profile'),
                leading: const Icon(RadixIcons.person),
                initialExpanded: true,
                children: <Widget>[
                  NavigationItem(
                    index: 4,
                    label: const Text('Details'),
                    child: const Icon(RadixIcons.idCard),
                  ),
                  NavigationItem(
                    index: 5,
                    label: Text('Security'),
                    child: const Icon(RadixIcons.lockClosed),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _sidebar(BuildContext context) => const _SidebarDemo();
''',
    ),
  ],
  'navigation_menu': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Bar',
      builder: '_bar',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/navigation_menu/navigation_menu.dart';

/// A menu bar with plain, dropdown and popover items.
Widget _bar(BuildContext context) {
  // Intrinsic width: a fixed box clipped the bar under real text metrics.
  return const FittedBox(
    fit: BoxFit.scaleDown,
    child: NavigationMenu(
      children: <Widget>[
        NavigationMenuItem(onPressed: _noop, child: Text('Home')),
        NavigationMenuItem(
          content: NavigationMenuContentList(
            children: <Widget>[
              NavigationMenuContent(
                title: Text('Web Apps'),
                content: Text('Ship in the browser'),
              ),
              NavigationMenuContent(
                title: Text('Mobile Apps'),
                content: Text('Ship on the go'),
              ),
            ],
          ),
          child: Text('Products'),
        ),
        NavigationMenuItem(
          content: Text('Company info here'),
          child: Text('About'),
        ),
      ],
    ),
  );
}

void _noop() {}
''',
    ),
    DocsExampleSource(
      name: 'Content list',
      builder: '_contentList',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/navigation_menu/navigation_menu.dart';

/// A standalone two-column content list.
Widget _contentList(BuildContext context) {
  return const SizedBox(
    width: 340,
    child: NavigationMenuContentList(
      crossAxisCount: 2,
      children: <Widget>[
        NavigationMenuContent(
          title: Text('Dashboard'),
          content: Text('Analytics and insights'),
        ),
        NavigationMenuContent(
          title: Text('Settings'),
          content: Text('Preferences'),
        ),
        NavigationMenuContent(
          title: Text('Billing'),
          content: Text('Plans and invoices'),
        ),
      ],
    ),
  );
}
''',
    ),
  ],
  'pagination': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Labelled',
      builder: '_labelled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/pagination/pagination.dart';

/// An interactive labelled pager; the page lives in this example's state.
class _LabelledPagination extends StatefulWidget {
  const _LabelledPagination();

  @override
  State<_LabelledPagination> createState() => _LabelledPaginationState();
}

class _LabelledPaginationState extends State<_LabelledPagination> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Pagination(
      page: _page,
      totalPages: 10,
      onPageChanged: (int page) => setState(() => _page = page),
    );
  }
}

Widget _labelled(BuildContext context) => const _LabelledPagination();
''',
    ),
    DocsExampleSource(
      name: 'Icon only',
      builder: '_iconOnly',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/pagination/pagination.dart';

/// Page buttons without the "Page x of y" label.
Widget _iconOnly(BuildContext context) {
  return const Pagination(
    page: 5,
    totalPages: 12,
    showLabel: false,
    onPageChanged: _noop,
  );
}

void _noop(int page) {}
''',
    ),
  ],
  'stepper': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/stepper/stepper.dart';

List<StepperStep> _steps() => const <StepperStep>[
  StepperStep(title: Text('Account'), content: Text('Email, password')),
  StepperStep(title: Text('Profile'), content: Text('Name, avatar')),
  StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
];

/// A stepper that moves when a step is activated; owns its index.
class _InteractiveStepper extends StatefulWidget {
  const _InteractiveStepper({this.direction = Axis.horizontal});

  final Axis direction;

  @override
  State<_InteractiveStepper> createState() => _InteractiveStepperState();
}

class _InteractiveStepperState extends State<_InteractiveStepper> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _current,
      onStepChanged: (int index) => setState(() => _current = index),
      direction: widget.direction,
      steps: _steps(),
    );
  }
}

/// Horizontal circle stepper.
Widget _default(BuildContext context) => const _InteractiveStepper();
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_vertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/stepper/stepper.dart';

List<StepperStep> _steps() => const <StepperStep>[
  StepperStep(title: Text('Account'), content: Text('Email, password')),
  StepperStep(title: Text('Profile'), content: Text('Name, avatar')),
  StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
];

/// A stepper that moves when a step is activated; owns its index.
class _InteractiveStepper extends StatefulWidget {
  const _InteractiveStepper({this.direction = Axis.horizontal});

  final Axis direction;

  @override
  State<_InteractiveStepper> createState() => _InteractiveStepperState();
}

class _InteractiveStepperState extends State<_InteractiveStepper> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _current,
      onStepChanged: (int index) => setState(() => _current = index),
      direction: widget.direction,
      steps: _steps(),
    );
  }
}

/// Vertical circle stepper.
Widget _vertical(BuildContext context) {
  return const _InteractiveStepper(direction: Axis.vertical);
}
''',
    ),
    DocsExampleSource(
      name: 'Sizes',
      builder: '_sizes',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/stepper/stepper.dart';

List<StepperStep> _steps() => const <StepperStep>[
  StepperStep(title: Text('Account'), content: Text('Email, password')),
  StepperStep(title: Text('Profile'), content: Text('Name, avatar')),
  StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
];

/// The three indicator sizes in one column.
Widget _sizes(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final StepperSize size in StepperSize.values) ...<Widget>[
        Text('${size.name} (${size.indicatorSize}px)'),
        Stepper(currentStep: 1, size: size, steps: _steps()),
        Gap(spacing.md),
      ],
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Failed step',
      builder: '_failed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/stepper/stepper.dart';

List<StepperStep> _steps() => const <StepperStep>[
  StepperStep(title: Text('Account'), content: Text('Email, password')),
  StepperStep(title: Text('Profile'), content: Text('Name, avatar')),
  StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
];

/// A controller-driven stepper with the first step flagged as failed.
class _FailedStepper extends StatefulWidget {
  const _FailedStepper();

  @override
  State<_FailedStepper> createState() => _FailedStepperState();
}

class _FailedStepperState extends State<_FailedStepper> {
  final StepperController _controller = StepperController(1);

  @override
  void initState() {
    super.initState();
    _controller.setStepState(0, StepperStepState.failed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(controller: _controller, steps: _steps());
  }
}

Widget _failed(BuildContext context) => const _FailedStepper();
''',
    ),
  ],
  'tabs': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/tabs/tabs.dart';

/// Interactive pill strip; owns its index.
class _InteractiveTabs extends StatefulWidget {
  const _InteractiveTabs();

  @override
  State<_InteractiveTabs> createState() => _InteractiveTabsState();
}

class _InteractiveTabsState extends State<_InteractiveTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Tabs(
      index: _index,
      onChanged: (int index) => setState(() => _index = index),
      children: const <TabItem>[
        TabItem(child: Text('Account')),
        TabItem(child: Text('Password')),
        TabItem(child: Text('Settings')),
      ],
    );
  }
}

Widget _default(BuildContext context) {
  // The strip sizes to its content; it scrolls instead of overflowing on a
  // 375-wide phone.
  return const SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: _InteractiveTabs(),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_disabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/tabs/tabs.dart';

/// Strip with no callback, so every tab is disabled.
Widget _disabled(BuildContext context) {
  return const Tabs(
    index: 0,
    children: <TabItem>[
      TabItem(child: Text('Account')),
      TabItem(child: Text('Password')),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Tab pane',
      builder: '_pane',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/tabs/tabs.dart';

/// Sortable IDE-style pane over a content card; owns its order. The fixed
/// height is inherent: the content card flexes inside the pane.
class _PaneDemo extends StatefulWidget {
  const _PaneDemo();

  @override
  State<_PaneDemo> createState() => _PaneDemoState();
}

class _PaneDemoState extends State<_PaneDemo> {
  int _focused = 1;
  List<TabPaneData<String>> _order = const <TabPaneData<String>>[
    TabPaneData<String>('main.dart'),
    TabPaneData<String>('tabs.dart'),
    TabPaneData<String>('README.md'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: TabPane<String>(
        items: _order,
        focused: _focused,
        onFocused: (int index) => setState(() => _focused = index),
        onSort: (List<TabPaneData<String>> next) =>
            setState(() => _order = next),
        itemBuilder:
            (BuildContext context, TabPaneData<String> item, int index) =>
                Text(item.data, overflow: TextOverflow.ellipsis),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Editor content'),
        ),
      ),
    );
  }
}

Widget _pane(BuildContext context) => const _PaneDemo();
''',
    ),
  ],
  'alert_dialog': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_alertDialogDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/alert_dialog/alert_dialog.dart';

/// The dialog body as shadcn composes it: a framed surface that carries the
/// widget, so the docs stage shows the composition without a route push.
Widget _alertDialogDialog(
  BuildContext context,
  String title,
  String description,
) {
  final theme = ShadcnTheme.of(context);
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
        boxShadow: theme.tokens.shadows.shadowLg,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsetsDensity.pxAll(24),
          child: AlertDialog(
            icon: const Icon(LucideIcons.circleAlert),
            title: Text(title),
            description: Text(description),
            actions: <Widget>[
              Button(
                size: ButtonSize.sm,
                variant: ButtonVariant.outline,
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              Button(
                size: ButtonSize.sm,
                variant: ButtonVariant.destructive,
                onPressed: () {},
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// The default dialog.
Widget _alertDialogDefault(BuildContext context) => _alertDialogDialog(
  context,
  'Are you absolutely sure?',
  'This permanently deletes the account.',
);
''',
    ),
    DocsExampleSource(
      name: 'Destructive',
      builder: '_alertDialogDestructive',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/alert_dialog/alert_dialog.dart';

/// The dialog body as shadcn composes it: a framed surface that carries the
/// widget, so the docs stage shows the composition without a route push.
Widget _alertDialogDialog(
  BuildContext context,
  String title,
  String description,
) {
  final theme = ShadcnTheme.of(context);
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
        boxShadow: theme.tokens.shadows.shadowLg,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsetsDensity.pxAll(24),
          child: AlertDialog(
            icon: const Icon(LucideIcons.circleAlert),
            title: Text(title),
            description: Text(description),
            actions: <Widget>[
              Button(
                size: ButtonSize.sm,
                variant: ButtonVariant.outline,
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              Button(
                size: ButtonSize.sm,
                variant: ButtonVariant.destructive,
                onPressed: () {},
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// The destructive dialog.
Widget _alertDialogDestructive(BuildContext context) => _alertDialogDialog(
  context,
  'Delete this project?',
  'This action cannot be undone. The project and its history are removed.',
);
''',
    ),
    DocsExampleSource(
      name: 'Live push',
      builder: '_alertDialogPushed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/alert_dialog/alert_dialog.dart';

/// A live push through `showAlertDialog`.
class _AlertDialogPushedDialog extends StatelessWidget {
  const _AlertDialogPushedDialog();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Button(
        onPressed: () => showAlertDialog<bool>(
          context: context,
          icon: const Icon(LucideIcons.triangleAlert),
          title: const Text('Delete this project?'),
          description: const Text(
            'This action cannot be undone. The project and its history are '
            'removed.',
          ),
          actions: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            Button(
              variant: ButtonVariant.destructive,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
        child: const Text('Show alert dialog'),
      ),
    );
  }
}

Widget _alertDialogPushed(BuildContext context) =>
    const _AlertDialogPushedDialog();
''',
    ),
  ],
  'dialog': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_dialogDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog_style.dart';

/// The trigger the example wraps in a [Builder], so it can reach the nearest
/// Navigator.
class _DialogTrigger extends StatelessWidget {
  const _DialogTrigger({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(
          label,
          style: TextStyle(color: theme.colors.primaryForeground),
        ),
      ),
    );
  }
}

/// The dialog card itself.
class _DialogDialogBody extends StatelessWidget {
  const _DialogDialogBody({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: theme.colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(theme.spacing.lg),
        Text(message, style: TextStyle(color: theme.colors.mutedForeground)),
      ],
    );
  }
}

/// A named example driven through a real route push.
class _DialogDialogExample extends StatelessWidget {
  const _DialogDialogExample({
    required this.label,
    this.barrierDismissible = true,
    this.fullScreen = false,
    this.theme,
  });

  final String label;
  final bool barrierDismissible;
  final bool fullScreen;
  final DialogTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) => _DialogTrigger(
          label: label,
          onPressed: () => showShadcnDialog<void>(
            context: context,
            barrierDismissible: barrierDismissible,
            fullScreen: fullScreen,
            theme: theme,
            builder: (context) => _DialogDialogBody(
              title: 'Delete this project?',
              message: 'This cannot be undone.',
            ),
          ),
        ),
      ),
    );
  }
}

/// The default modal dialog.
Widget _dialogDefault(BuildContext context) =>
    const _DialogDialogExample(label: 'Open dialog');
''',
    ),
    DocsExampleSource(
      name: 'Full screen',
      builder: '_dialogFullScreen',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog_style.dart';

/// The trigger the example wraps in a [Builder], so it can reach the nearest
/// Navigator.
class _DialogTrigger extends StatelessWidget {
  const _DialogTrigger({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(
          label,
          style: TextStyle(color: theme.colors.primaryForeground),
        ),
      ),
    );
  }
}

/// The dialog card itself.
class _DialogDialogBody extends StatelessWidget {
  const _DialogDialogBody({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: theme.colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(theme.spacing.lg),
        Text(message, style: TextStyle(color: theme.colors.mutedForeground)),
      ],
    );
  }
}

/// A named example driven through a real route push.
class _DialogDialogExample extends StatelessWidget {
  const _DialogDialogExample({
    required this.label,
    this.barrierDismissible = true,
    this.fullScreen = false,
    this.theme,
  });

  final String label;
  final bool barrierDismissible;
  final bool fullScreen;
  final DialogTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) => _DialogTrigger(
          label: label,
          onPressed: () => showShadcnDialog<void>(
            context: context,
            barrierDismissible: barrierDismissible,
            fullScreen: fullScreen,
            theme: theme,
            builder: (context) => _DialogDialogBody(
              title: 'Delete this project?',
              message: 'This cannot be undone.',
            ),
          ),
        ),
      ),
    );
  }
}

/// A full-screen dialog.
Widget _dialogFullScreen(BuildContext context) =>
    const _DialogDialogExample(label: 'Open full screen', fullScreen: true);
''',
    ),
    DocsExampleSource(
      name: 'Barrier locked',
      builder: '_dialogLocked',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog_style.dart';

/// The trigger the example wraps in a [Builder], so it can reach the nearest
/// Navigator.
class _DialogTrigger extends StatelessWidget {
  const _DialogTrigger({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(
          label,
          style: TextStyle(color: theme.colors.primaryForeground),
        ),
      ),
    );
  }
}

/// The dialog card itself.
class _DialogDialogBody extends StatelessWidget {
  const _DialogDialogBody({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: theme.colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(theme.spacing.lg),
        Text(message, style: TextStyle(color: theme.colors.mutedForeground)),
      ],
    );
  }
}

/// A named example driven through a real route push.
class _DialogDialogExample extends StatelessWidget {
  const _DialogDialogExample({
    required this.label,
    this.barrierDismissible = true,
    this.fullScreen = false,
    this.theme,
  });

  final String label;
  final bool barrierDismissible;
  final bool fullScreen;
  final DialogTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) => _DialogTrigger(
          label: label,
          onPressed: () => showShadcnDialog<void>(
            context: context,
            barrierDismissible: barrierDismissible,
            fullScreen: fullScreen,
            theme: theme,
            builder: (context) => _DialogDialogBody(
              title: 'Delete this project?',
              message: 'This cannot be undone.',
            ),
          ),
        ),
      ),
    );
  }
}

/// A barrier-locked dialog.
Widget _dialogLocked(BuildContext context) => const _DialogDialogExample(
  label: 'Open locked dialog',
  barrierDismissible: false,
);
''',
    ),
    DocsExampleSource(
      name: 'Themed',
      builder: '_dialogThemed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog.dart';
import 'package:<your_app>/ui/shadcn/components/dialog/dialog_style.dart';

/// The trigger the example wraps in a [Builder], so it can reach the nearest
/// Navigator.
class _DialogTrigger extends StatelessWidget {
  const _DialogTrigger({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(
          label,
          style: TextStyle(color: theme.colors.primaryForeground),
        ),
      ),
    );
  }
}

/// The dialog card itself.
class _DialogDialogBody extends StatelessWidget {
  const _DialogDialogBody({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: theme.colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(theme.spacing.lg),
        Text(message, style: TextStyle(color: theme.colors.mutedForeground)),
      ],
    );
  }
}

/// A named example driven through a real route push.
class _DialogDialogExample extends StatelessWidget {
  const _DialogDialogExample({
    required this.label,
    this.barrierDismissible = true,
    this.fullScreen = false,
    this.theme,
  });

  final String label;
  final bool barrierDismissible;
  final bool fullScreen;
  final DialogTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) => _DialogTrigger(
          label: label,
          onPressed: () => showShadcnDialog<void>(
            context: context,
            barrierDismissible: barrierDismissible,
            fullScreen: fullScreen,
            theme: theme,
            builder: (context) => _DialogDialogBody(
              title: 'Delete this project?',
              message: 'This cannot be undone.',
            ),
          ),
        ),
      ),
    );
  }
}

/// A dialog themed from the widget leg.
Widget _dialogThemed(BuildContext context) => _DialogDialogExample(
  label: 'Open themed dialog',
  theme: const DialogTheme(
    maxWidth: 320,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    shadows: <BoxShadow>[],
  ),
);
''',
    ),
  ],
  'drawer': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_drawerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/drawer/drawer.dart';

/// Panel body used by the drawer examples.
class _DrawerDrawerContent extends StatelessWidget {
  const _DrawerDrawerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Drawer content'),
        Gap(ShadcnTheme.of(context).spacing.lg),
        Button(
          size: ButtonSize.sm,
          onPressed: () => closeDrawer(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Opens a drawer at [position].
class _DrawerDrawerTrigger extends StatelessWidget {
  const _DrawerDrawerTrigger({required this.position, required this.label});

  final OverlayPosition position;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      onPressed: () => openDrawer<void>(
        context: context,
        position: position,
        builder: (BuildContext context) => const _DrawerDrawerContent(),
      ),
      child: Text(label),
    );
  }
}

/// Side drawers, one row (shadcn shows the four edges together).
Widget _drawerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.sm,
    runSpacing: spacing.sm,
    children: const <Widget>[
      _DrawerDrawerTrigger(position: OverlayPosition.start, label: 'left'),
      _DrawerDrawerTrigger(position: OverlayPosition.end, label: 'right'),
      _DrawerDrawerTrigger(position: OverlayPosition.top, label: 'top'),
      _DrawerDrawerTrigger(position: OverlayPosition.bottom, label: 'bottom'),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Sheet',
      builder: '_drawerSheet',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/drawer/drawer.dart';

/// Sheet body used by the sheet example.
class _DrawerSheetContent extends StatelessWidget {
  const _DrawerSheetContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Sheet content'),
        Gap(ShadcnTheme.of(context).spacing.lg),
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => closeSheet(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// The bottom sheet form.
Widget _drawerSheet(BuildContext context) {
  return Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () => openSheet<void>(
      context: context,
      draggable: true,
      builder: (BuildContext context) => const _DrawerSheetContent(),
    ),
    child: const Text('Open sheet'),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Themed',
      builder: '_drawerThemed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/drawer/drawer.dart';

/// Panel body used by the drawer examples.
class _DrawerDrawerContent extends StatelessWidget {
  const _DrawerDrawerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Drawer content'),
        Gap(ShadcnTheme.of(context).spacing.lg),
        Button(
          size: ButtonSize.sm,
          onPressed: () => closeDrawer(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// A drawer themed from the widget leg.
Widget _drawerThemed(BuildContext context) {
  return Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () => openDrawer<void>(
      context: context,
      theme: const DrawerTheme(
        maxSize: 280,
        background: ThemedColor.ref(ColorRef.card),
      ),
      builder: (BuildContext context) => const _DrawerDrawerContent(),
    ),
    child: const Text('Open themed drawer'),
  );
}
''',
    ),
  ],
  'gooey_toast': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Pill',
      builder: '_pill',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/gooey_toast/gooey_toast.dart';

/// A persistent pill toast, plus a button firing an info toast.
class _PillExample extends StatefulWidget {
  const _PillExample();

  @override
  State<_PillExample> createState() => _PillExampleState();
}

class _PillExampleState extends State<_PillExample> {
  final GooeyToastController _controller = GooeyToastController(
    defaultDuration: const Duration(minutes: 5),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showGooeyToast(
          const GooeyToastOptions(
            title: 'Saved to your workspace',
            description: 'Everything is in sync.',
            state: GooeyToastState.success,
            persistUntilDismissed: true,
          ),
          autoDismiss: false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: GooeyToastLayer(
        controller: _controller,
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () => _controller.showGooeyToast(
                const GooeyToastOptions(
                  title: 'FYI',
                  description: 'The body expands from the pill.',
                  state: GooeyToastState.info,
                ),
              ),
              child: const Text('Show info toast'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _pill(BuildContext context) => const _PillExample();
''',
    ),
    DocsExampleSource(
      name: 'Expanded',
      builder: '_expanded',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/gooey_toast/gooey_toast.dart';

/// A persistent toast with an expanded body, plus a button re-firing it.
class _ExpandedExample extends StatefulWidget {
  const _ExpandedExample();

  @override
  State<_ExpandedExample> createState() => _ExpandedExampleState();
}

class _ExpandedExampleState extends State<_ExpandedExample> {
  final GooeyToastController _controller = GooeyToastController(
    defaultDuration: const Duration(minutes: 5),
  );

  void _show() {
    _controller.showGooeyToast(
      GooeyToastOptions(
        title: 'Deploy finished',
        description: 'Three targets updated.',
        state: GooeyToastState.success,
        persistUntilDismissed: true,
        expandedChild: Text(
          'main, staging and edge are on build 482.',
          style: TextStyle(color: ShadcnTheme.of(context).colors.foreground),
        ),
      ),
      autoDismiss: false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _show();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: GooeyToastLayer(
        controller: _controller,
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: _show,
          child: const Text('Show expanded toast'),
        ),
      ),
    );
  }
}

Widget _expanded(BuildContext context) => const _ExpandedExample();
''',
    ),
  ],
  'hover_card': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/hover_card/hover_card.dart';

/// Sample card content.
Widget _card(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text('@shadcn'),
      Gap(theme.spacing.xs),
      Text(
        'Beautifully designed components.',
        style: TextStyle(color: theme.colors.mutedForeground),
      ),
    ],
  );
}

/// The default card after the hover delay.
Widget _default(BuildContext context) {
  return HoverCard(hoverBuilder: _card, child: const Text('@shadcn'));
}
''',
    ),
    DocsExampleSource(
      name: 'Rich content',
      builder: '_richContent',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/hover_card/hover_card.dart';

/// Rich content: title, bio and follower count.
Widget _richContent(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return HoverCard(
    hoverBuilder: (BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('@shadcn'),
        Gap(theme.spacing.xs),
        Text(
          'Beautifully designed components that you can copy and paste.',
          style: TextStyle(color: theme.colors.mutedForeground),
        ),
        Gap(theme.spacing.sm),
        Text(
          '12k followers',
          style: TextStyle(color: theme.colors.mutedForeground, fontSize: 12),
        ),
      ],
    ),
    child: const Text('@shadcn (rich)'),
  );
}
''',
    ),
  ],
  'popup': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/popup/popup.dart';

/// The profile card shown on the popup surface by both examples.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Ibrar Ali'),
              SizedBox(height: 2),
              Text('ibrar@example.com', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const MenuSeparator(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Signed in with a passkey',
            style: TextStyle(
              fontSize: 12,
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

/// The popup surface rendered inline.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 220,
    child: MenuPopup(children: <Widget>[_ProfileCard()]),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Anchored',
      builder: '_anchored',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';
import 'package:<your_app>/ui/shadcn/components/popup/popup.dart';

/// The profile card shown on the popup surface by both examples.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Ibrar Ali'),
              SizedBox(height: 2),
              Text('ibrar@example.com', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const MenuSeparator(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Signed in with a passkey',
            style: TextStyle(
              fontSize: 12,
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

/// A trigger that anchors the same surface with `showShadcnPopup`.
class _AnchoredDemo extends StatelessWidget {
  const _AnchoredDemo();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: () => showShadcnPopup(
        context: context,
        builder: (BuildContext context) => const _ProfileCard(),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.secondary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: const Text('Show popup'),
      ),
    );
  }
}

Widget _anchored(BuildContext context) => const _AnchoredDemo();
''',
    ),
  ],
  'refresh_trigger': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/refresh_trigger/refresh_trigger.dart';

/// A live pull-to-refresh list in a bounded box.
Widget _default(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 200,
    child: RefreshTrigger(
      onRefresh: () async {},
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text('Row $index'),
        ),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Refreshing',
      builder: '_refreshing',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/refresh_trigger/refresh_trigger.dart';

/// The pill indicator frozen in its refreshing stage.
Widget _refreshing(BuildContext context) {
  return const DefaultRefreshIndicator(
    stage: RefreshTriggerStage(
      TriggerStage.refreshing,
      AlwaysStoppedAnimation<double>(0.8),
      Axis.vertical,
      false,
    ),
  );
}
''',
    ),
  ],
  'tooltip': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tooltip/tooltip.dart';

/// Label tooltip after the default delay.
Widget _default(BuildContext context) {
  return _anchor(context, LucideIcons.info, 'Details');
}

Widget _anchor(
  BuildContext context,
  IconData icon,
  String label, {
  Duration waitDuration = kTooltipWaitDuration,
}) {
  final theme = ShadcnTheme.of(context);
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Tooltip(
      waitDuration: waitDuration,
      tooltip: (BuildContext context) => Text(label),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: theme.colors.foreground),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Instant',
      builder: '_instant',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tooltip/tooltip.dart';

/// Label tooltip with no delay.
Widget _instant(BuildContext context) {
  return _anchor(
    context,
    LucideIcons.zap,
    'Instant',
    waitDuration: Duration.zero,
  );
}

Widget _anchor(
  BuildContext context,
  IconData icon,
  String label, {
  Duration waitDuration = kTooltipWaitDuration,
}) {
  final theme = ShadcnTheme.of(context);
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Tooltip(
      waitDuration: waitDuration,
      tooltip: (BuildContext context) => Text(label),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: theme.colors.foreground),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Rich content',
      builder: '_rich',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tooltip/tooltip.dart';

/// Title plus description in one tooltip.
Widget _rich(BuildContext context) {
  return Tooltip(
    tooltip: (BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text('Deployment', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('Ships when the checks pass.'),
      ],
    ),
    child: Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: ShadcnTheme.of(context).colors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        LucideIcons.rocket,
        size: 16,
        color: ShadcnTheme.of(context).colors.foreground,
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Container',
      builder: '_container',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/tooltip/tooltip.dart';

/// The container on its own, without hover behaviour.
Widget _container(BuildContext context) {
  return const TooltipContainer(child: Text('Primary surface'));
}
''',
    ),
  ],
  'code_snippet': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_codeSnippetDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/code_snippet/code_snippet.dart';

/// A plain snippet.
Widget _codeSnippetDefault(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: CodeSnippet(code: Text('const greeting = "hello";')),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With actions',
      builder: '_codeSnippetWithActions',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/code_snippet/code_snippet.dart';

/// A small pill button for the snippet actions row.
class _CodeSnippetAction extends StatelessWidget {
  const _CodeSnippetAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // A real Button (keyboard, hover, focus ring, semantics) instead of a
    // hand-rolled GestureDetector pill, matching the README snippet.
    return Button(
      size: ButtonSize.sm,
      variant: ButtonVariant.ghost,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// A snippet with an actions row.
class _CodeSnippetWithActions extends StatefulWidget {
  const _CodeSnippetWithActions();

  @override
  State<_CodeSnippetWithActions> createState() =>
      _CodeSnippetWithActionsState();
}

class _CodeSnippetWithActionsState extends State<_CodeSnippetWithActions> {
  String _status = 'idle';

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CodeSnippet(
          actions: <Widget>[
            _CodeSnippetAction(
              label: 'Copy',
              onPressed: () => setState(() => _status = 'copied'),
            ),
            _CodeSnippetAction(
              label: 'Run',
              onPressed: () => setState(() => _status = 'running'),
            ),
          ],
          code: const Text('flutter run -d chrome'),
        ),
        Gap(spacing.sm),
        Text(
          _status,
          style: TextStyle(
            fontSize: 12,
            color: ShadcnTheme.of(context).colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

Widget _codeSnippetWithActions(BuildContext context) =>
    const _CodeSnippetWithActions();
''',
    ),
    DocsExampleSource(
      name: 'Long lines',
      builder: '_codeSnippetLongLines',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/code_snippet/code_snippet.dart';

/// A long line that scrolls inside its bounded box.
Widget _codeSnippetLongLines(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: SizedBox(
      width: 320,
      child: CodeSnippet(
        code: Text(
          'void main() { runApp(const MyApp(home: Center(child: Text("wide")))); }',
        ),
      ),
    ),
  );
}
''',
    ),
  ],
  'image': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_imageDefault',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/image/image.dart';

/// A 48x48 PNG decoded from memory: the preview never hits the network, so it
/// renders identically offline and inside a widget test.
const String _imagePhotoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAWElEQVR42u3OoRGAMBBFwdPURBHoFIaj'
    'KTS9hBL+ROTUzjz/ts7xxZ73js1x5eqIFRAQEBAQ0CKoczarYkBAQEBAQKugzhkQEBAQENAWUOMMCAgIC'
    'AhoQz/vbpR28UARAAAAAABJRU5ErkJggg==';

/// Local photo provider shared by the examples.
final ImageProvider _imagePhoto = MemoryImage(base64Decode(_imagePhotoBase64));

/// The default square avatar-shaped image.
Widget _imageDefault(BuildContext context) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: ShadcnImage(
      image: _imagePhoto,
      width: 96,
      height: 96,
      aspectRatio: 1,
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Rounded',
      builder: '_imageRounded',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/image/image.dart';

/// A 48x48 PNG decoded from memory: the preview never hits the network, so it
/// renders identically offline and inside a widget test.
const String _imagePhotoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAWElEQVR42u3OoRGAMBBFwdPURBHoFIaj'
    'KTS9hBL+ROTUzjz/ts7xxZ73js1x5eqIFRAQEBAQ0CKoczarYkBAQEBAQKugzhkQEBAQENAWUOMMCAgIC'
    'AhoQz/vbpR28UARAAAAAABJRU5ErkJggg==';

/// Local photo provider shared by the examples.
final ImageProvider _imagePhoto = MemoryImage(base64Decode(_imagePhotoBase64));

/// The default image with the theme border radius.
Widget _imageRounded(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: ShadcnImage(
      image: _imagePhoto,
      width: 96,
      height: 96,
      aspectRatio: 1,
      borderRadius: theme.borderRadiusMd,
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Slots',
      builder: '_imageSlots',
      code: r'''import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/image/image.dart';

/// A 48x48 PNG decoded from memory: the preview never hits the network, so it
/// renders identically offline and inside a widget test.
const String _imagePhotoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAWElEQVR42u3OoRGAMBBFwdPURBHoFIaj'
    'KTS9hBL+ROTUzjz/ts7xxZ73js1x5eqIFRAQEBAQ0CKoczarYkBAQEBAQKugzhkQEBAQENAWUOMMCAgIC'
    'AhoQz/vbpR28UARAAAAAABJRU5ErkJggg==';

/// Local photo provider shared by the examples.
final ImageProvider _imagePhoto = MemoryImage(base64Decode(_imagePhotoBase64));

/// The placeholder and error slots, and the theme legs.
Widget _imageSlots(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ShadcnImage(
        image: _imagePhoto,
        width: 96,
        height: 96,
        aspectRatio: 1,
        placeholder: const Center(
          child: Icon(LucideIcons.loaderCircle, size: 20),
        ),
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(LucideIcons.imageOff, size: 20)),
      ),
      Gap(spacing.lg),
      ShadcnImage(
        image: _imagePhoto,
        width: 96,
        height: 96,
        aspectRatio: 1,
        theme: const ImageTheme(borderRadius: BorderRadius.zero),
      ),
      Gap(spacing.lg),
      ComponentTheme<ImageTheme>(
        data: const ImageTheme(
          background: ThemedColor.ref(ColorRef.accent, alpha: 0.5),
        ),
        child: ShadcnImage(
          image: _imagePhoto,
          width: 96,
          height: 96,
          aspectRatio: 1,
        ),
      ),
    ],
  );
}
''',
    ),
  ],
  'markdown': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code:
          'import \'package:flutter/widgets.dart\';\nimport \'package:<your_app>/ui/shadcn/theme/theme.dart\';\nimport \'package:<your_app>/ui/shadcn/components/markdown/markdown.dart\';\n\nconst String _sample = \'\'\'\n## Release notes\n\nBuild 482 ships **faster cold start** and a *smaller bundle*.\n\n- faster cold start\n- smaller bundle\n\n> Quoted from the changelog.\n\n![build graph](https://example.com/graph.png "Build graph")\n\'\'\';\n\n/// Headings, emphasis, a list, a quote and a local image placeholder.\nWidget _default(BuildContext context) {\n  final ShadcnThemeData theme = ShadcnTheme.of(context);\n  return SizedBox(\n    width: 320,\n    child: Markdown(\n      data: _sample,\n      imageBuilder: (imageContext, url, alt) => SizedBox(\n        height: 64,\n        child: DecoratedBox(\n          decoration: BoxDecoration(\n            color: theme.colors.muted,\n            borderRadius: BorderRadius.circular(10),\n          ),\n          child: Center(\n            child: Text(\n              alt,\n              style: TextStyle(\n                color: theme.colors.mutedForeground,\n                fontSize: 12,\n              ),\n            ),\n          ),\n        ),\n      ),\n    ),\n  );\n}\n',
    ),
    DocsExampleSource(
      name: 'Streaming tail',
      builder: '_streamingTail',
      code:
          'import \'package:flutter/widgets.dart\';\nimport \'package:<your_app>/ui/shadcn/theme/theme.dart\';\nimport \'package:<your_app>/ui/shadcn/components/markdown/markdown.dart\';\n\n/// A mid-stream snapshot: only the stable prefix parses, followed by the\n/// streaming cursor. No timers; the settled text is derived with\n/// `computeStableMarkdownPrefixLength`, the helper the streaming\n/// `text_animate` component shares with this parser.\nconst String _streamSource = \'\'\'\nDrafting the release notes:\n\n- faster cold start\n- smaller bundle\n\n```dart\nvoid main() => print(\'\'\';\n\nWidget _streamingTail(BuildContext context) {\n  final String settled = _streamSource.substring(\n    0,\n    computeStableMarkdownPrefixLength(_streamSource),\n  );\n  final ShadcnThemeData theme = ShadcnTheme.of(context);\n  return SizedBox(\n    width: 320,\n    child: Column(\n      mainAxisSize: MainAxisSize.min,\n      crossAxisAlignment: CrossAxisAlignment.start,\n      children: <Widget>[\n        Markdown(data: settled),\n        Text(\'▍\', style: TextStyle(color: theme.colors.primary)),\n      ],\n    ),\n  );\n}\n',
    ),
  ],
  'alpha': <DocsExampleSource>[],
  'anchor': <DocsExampleSource>[],
  'app': <DocsExampleSource>[],
  'async': <DocsExampleSource>[],
  'backdrop_transform': <DocsExampleSource>[],
  'color': <DocsExampleSource>[],
  'color_field': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_colorFieldDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/color_field/color_field.dart';

/// A section label above a field.
class _ColorFieldLabel extends StatelessWidget {
  const _ColorFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}

/// The HSV saturation/value field.
Widget _colorFieldDefault(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _ColorFieldLabel('HSV field'),
      SizedBox(
        width: 240,
        height: 140,
        child: ColorField(
          color: Color(0xFF2563EB),
          saturationAxis: ColorFieldAxis.horizontal,
          valueAxis: ColorFieldAxis.vertical,
        ),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Hue',
      builder: '_colorFieldHue',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/color_field/color_field.dart';

/// A section label above a field.
class _ColorFieldLabel extends StatelessWidget {
  const _ColorFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}

/// The hue strip.
Widget _colorFieldHue(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _ColorFieldLabel('Hue strip'),
      SizedBox(
        width: 240,
        height: 24,
        child: ColorField(
          color: Color(0xFF2563EB),
          hueAxis: ColorFieldAxis.horizontal,
        ),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'HSL',
      builder: '_colorFieldHsl',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/color_field/color_field.dart';

/// A section label above a field.
class _ColorFieldLabel extends StatelessWidget {
  const _ColorFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}

/// The HSL lightness field.
Widget _colorFieldHsl(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _ColorFieldLabel('HSL field'),
      SizedBox(
        width: 240,
        height: 140,
        child: ColorField(
          color: Color(0x8022C55E),
          mode: ColorFieldMode.hsl,
          saturationAxis: ColorFieldAxis.horizontal,
          lightnessAxis: ColorFieldAxis.vertical,
        ),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Alpha',
      builder: '_colorFieldAlpha',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/color_field/color_field.dart';

/// A section label above a field.
class _ColorFieldLabel extends StatelessWidget {
  const _ColorFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}

/// The alpha ramp.
Widget _colorFieldAlpha(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _ColorFieldLabel('Alpha ramp'),
      SizedBox(
        width: 240,
        height: 24,
        child: ColorField(
          color: Color(0xFF2563EB),
          alphaAxis: ColorFieldAxis.horizontal,
        ),
      ),
    ],
  );
}
''',
    ),
  ],
  'color_input': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_colorInputDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_input/color_input.dart';

/// One trigger, with the scopes the colour machinery needs.
class _ColorInputColorInputExample extends StatefulWidget {
  const _ColorInputColorInputExample({
    this.mode,
    this.dialogTitle,
    this.showAlpha = false,
    this.showHistory = false,
    this.enabled = true,
  });

  final PromptMode? mode;
  final Widget? dialogTitle;
  final bool showAlpha;
  final bool showHistory;
  final bool enabled;

  @override
  State<_ColorInputColorInputExample> createState() =>
      _ColorInputColorInputExampleState();
}

class _ColorInputColorInputExampleState
    extends State<_ColorInputColorInputExample> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

  @override
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: RecentColorsScope(
        initialRecentColors: const <Color>[
          Color(0xFF2563EB),
          Color(0xFF22C55E),
          Color(0xFFE11D48),
        ],
        child: SizedBox(
          width: 240,
          child: ColorInput(
            value: _value,
            mode: widget.mode,
            dialogTitle: widget.dialogTitle,
            showAlpha: widget.showAlpha,
            showHistory: widget.showHistory,
            enabled: widget.enabled,
            onChanged: (ColorDerivative next) => setState(() => _value = next),
          ),
        ),
      ),
    );
  }
}

/// The default trigger, with the popover prompt.
Widget _colorInputDefault(BuildContext context) =>
    const _ColorInputColorInputExample();
''',
    ),
    DocsExampleSource(
      name: 'Dialog prompt',
      builder: '_colorInputDialog',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_input/color_input.dart';

/// One trigger, with the scopes the colour machinery needs.
class _ColorInputColorInputExample extends StatefulWidget {
  const _ColorInputColorInputExample({
    this.mode,
    this.dialogTitle,
    this.showAlpha = false,
    this.showHistory = false,
    this.enabled = true,
  });

  final PromptMode? mode;
  final Widget? dialogTitle;
  final bool showAlpha;
  final bool showHistory;
  final bool enabled;

  @override
  State<_ColorInputColorInputExample> createState() =>
      _ColorInputColorInputExampleState();
}

class _ColorInputColorInputExampleState
    extends State<_ColorInputColorInputExample> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

  @override
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: RecentColorsScope(
        initialRecentColors: const <Color>[
          Color(0xFF2563EB),
          Color(0xFF22C55E),
          Color(0xFFE11D48),
        ],
        child: SizedBox(
          width: 240,
          child: ColorInput(
            value: _value,
            mode: widget.mode,
            dialogTitle: widget.dialogTitle,
            showAlpha: widget.showAlpha,
            showHistory: widget.showHistory,
            enabled: widget.enabled,
            onChanged: (ColorDerivative next) => setState(() => _value = next),
          ),
        ),
      ),
    );
  }
}

/// The dialog prompt with a title.
Widget _colorInputDialog(BuildContext context) =>
    const _ColorInputColorInputExample(
      mode: PromptMode.dialog,
      dialogTitle: Text('Select a colour'),
    );
''',
    ),
    DocsExampleSource(
      name: 'Alpha + history',
      builder: '_colorInputAlphaHistory',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_input/color_input.dart';

/// One trigger, with the scopes the colour machinery needs.
class _ColorInputColorInputExample extends StatefulWidget {
  const _ColorInputColorInputExample({
    this.mode,
    this.dialogTitle,
    this.showAlpha = false,
    this.showHistory = false,
    this.enabled = true,
  });

  final PromptMode? mode;
  final Widget? dialogTitle;
  final bool showAlpha;
  final bool showHistory;
  final bool enabled;

  @override
  State<_ColorInputColorInputExample> createState() =>
      _ColorInputColorInputExampleState();
}

class _ColorInputColorInputExampleState
    extends State<_ColorInputColorInputExample> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

  @override
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: RecentColorsScope(
        initialRecentColors: const <Color>[
          Color(0xFF2563EB),
          Color(0xFF22C55E),
          Color(0xFFE11D48),
        ],
        child: SizedBox(
          width: 240,
          child: ColorInput(
            value: _value,
            mode: widget.mode,
            dialogTitle: widget.dialogTitle,
            showAlpha: widget.showAlpha,
            showHistory: widget.showHistory,
            enabled: widget.enabled,
            onChanged: (ColorDerivative next) => setState(() => _value = next),
          ),
        ),
      ),
    );
  }
}

/// Alpha plus the recent-colour history.
Widget _colorInputAlphaHistory(BuildContext context) =>
    const _ColorInputColorInputExample(showAlpha: true, showHistory: true);
''',
    ),
    DocsExampleSource(
      name: 'Disabled',
      builder: '_colorInputDisabled',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/primitives/form_core/object_form_field.dart';
import 'package:<your_app>/ui/shadcn/components/color/color.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';
import 'package:<your_app>/ui/shadcn/components/history/history.dart';
import 'package:<your_app>/ui/shadcn/components/color_input/color_input.dart';

/// One trigger, with the scopes the colour machinery needs.
class _ColorInputColorInputExample extends StatefulWidget {
  const _ColorInputColorInputExample({
    this.mode,
    this.dialogTitle,
    this.showAlpha = false,
    this.showHistory = false,
    this.enabled = true,
  });

  final PromptMode? mode;
  final Widget? dialogTitle;
  final bool showAlpha;
  final bool showHistory;
  final bool enabled;

  @override
  State<_ColorInputColorInputExample> createState() =>
      _ColorInputColorInputExampleState();
}

class _ColorInputColorInputExampleState
    extends State<_ColorInputColorInputExample> {
  ColorDerivative _value = ColorDerivative.fromColor(const Color(0xFF2563EB));

  @override
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: RecentColorsScope(
        initialRecentColors: const <Color>[
          Color(0xFF2563EB),
          Color(0xFF22C55E),
          Color(0xFFE11D48),
        ],
        child: SizedBox(
          width: 240,
          child: ColorInput(
            value: _value,
            mode: widget.mode,
            dialogTitle: widget.dialogTitle,
            showAlpha: widget.showAlpha,
            showHistory: widget.showHistory,
            enabled: widget.enabled,
            onChanged: (ColorDerivative next) => setState(() => _value = next),
          ),
        ),
      ),
    );
  }
}

/// The disabled trigger.
Widget _colorInputDisabled(BuildContext context) =>
    const _ColorInputColorInputExample(enabled: false);
''',
    ),
  ],
  'drawer_container': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_drawerContainerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/data.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/drawer_container/drawer_container.dart';

/// A framed box that shows the container's bounds.
class _DrawerContainerFrame extends StatelessWidget {
  const _DrawerContainerFrame({required this.child, this.width, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusMd,
      ),
      child: Padding(
        padding: EdgeInsetsDensity.pxAll(8),
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }
}

/// Drawer chrome at the four edges.
Widget _drawerContainerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.md,
    children: <Widget>[
      for (final position in const <OverlayPosition>[
        OverlayPosition.left,
        OverlayPosition.right,
        OverlayPosition.top,
        OverlayPosition.bottom,
      ])
        _DrawerContainerFrame(
          child: DrawerRawContainer(
            position: position,
            constraints: const BoxConstraints(maxWidth: 140, maxHeight: 120),
            child: const Center(child: Text('Drawer')),
          ),
        ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'With handle',
      builder: '_drawerContainerWithHandle',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/data.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/drawer_container/drawer_container.dart';

/// A framed box that shows the container's bounds.
class _DrawerContainerFrame extends StatelessWidget {
  const _DrawerContainerFrame({required this.child, this.width, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusMd,
      ),
      child: Padding(
        padding: EdgeInsetsDensity.pxAll(8),
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }
}

/// The sheet form, expanded along the cross axis.
Widget _drawerContainerWithHandle(BuildContext context) {
  return Wrap(
    spacing: ShadcnTheme.of(context).spacing.md,
    runSpacing: ShadcnTheme.of(context).spacing.md,
    children: const <Widget>[
      _DrawerContainerFrame(
        width: 220,
        height: 140,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          expands: true,
          child: Center(child: Text('Sheet')),
        ),
      ),
      _DrawerContainerFrame(
        width: 240,
        height: 120,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          crossAxisSize: FractionAxisSize(0.5),
          crossAxisAlignment: 0,
          child: Center(child: Text('Half width')),
        ),
      ),
      _DrawerContainerFrame(
        width: 240,
        height: 120,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          fadeAnimation: AlwaysStoppedAnimation<double>(1),
          child: Center(child: Text('With barrier')),
        ),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Data-driven',
      builder: '_drawerContainerDataDriven',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/data.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/drawer_container/drawer_container.dart';

/// A framed box that shows the container's bounds.
class _DrawerContainerFrame extends StatelessWidget {
  const _DrawerContainerFrame({required this.child, this.width, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusMd,
      ),
      child: Padding(
        padding: EdgeInsetsDensity.pxAll(8),
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }
}

/// A container driven by the ambient data scope.
Widget _drawerContainerDataDriven(BuildContext context) {
  return _DrawerContainerFrame(
    width: 240,
    height: 140,
    child: Data<DrawerContainerData>.inherit(
      data: DrawerContainerData(
        position: OverlayPosition.right,
        isSheet: true,
        padding: EdgeInsetsDensity.pxAll(12),
      ),
      child: DrawerContainer(
        size: FractionAxisSize(0.6),
        child: const Center(child: Text('Data-driven')),
      ),
    ),
  );
}
''',
    ),
  ],
  'error_system': <DocsExampleSource>[],
  'eye_dropper': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_eyeDropperDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';

/// A swatch the example can pick from.
class _EyeDropperSwatch extends StatelessWidget {
  const _EyeDropperSwatch(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const SizedBox(width: 120, height: 72),
    );
  }
}

/// The picker, with the live result echoed as text and a swatch.
class _EyeDropperPicker extends StatefulWidget {
  const _EyeDropperPicker({this.inline = false});

  final bool inline;

  @override
  State<_EyeDropperPicker> createState() => _EyeDropperPickerState();
}

class _EyeDropperPickerState extends State<_EyeDropperPicker> {
  Color? _picked;

  void _eyeDropperPick() async {
    final Color? color = await pickColorFromScreen(context);
    if (mounted) {
      setState(() => _picked = color);
    }
  }

  String _eyeDropperHex(Color color) {
    String byte(double channel) =>
        ((channel * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
    return '${byte(color.r)}${byte(color.g)}${byte(color.b)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return EyeDropperLayer(
      previewAlignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!widget.inline)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const _EyeDropperSwatch(Color(0xFF2563EB)),
                Gap(theme.spacing.sm),
                const _EyeDropperSwatch(Color(0xFF22C55E)),
              ],
            ),
          if (!widget.inline) Gap(theme.spacing.lg),
          GestureDetector(
            onTap: _eyeDropperPick,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.primary,
                borderRadius: theme.borderRadiusMd,
              ),
              child: Padding(
                padding: EdgeInsetsDensity.pxSymmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  _picked == null ? 'Pick a colour' : 'Pick again',
                  style: TextStyle(color: theme.colors.primaryForeground),
                ),
              ),
            ),
          ),
          Gap(theme.spacing.lg),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _picked ?? theme.colors.muted,
                  border: Border.all(color: theme.colors.border),
                  borderRadius: theme.borderRadiusSm,
                ),
                child: SizedBox(
                  width: theme.spacing.xl,
                  height: theme.spacing.xl,
                ),
              ),
              Gap(theme.spacing.sm),
              Text(
                _picked == null
                    ? 'no colour picked'
                    : '#${_eyeDropperHex(_picked!)}',
                style: TextStyle(color: theme.colors.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The default picker.
Widget _eyeDropperDefault(BuildContext context) => const _EyeDropperPicker();
''',
    ),
    DocsExampleSource(
      name: 'Inline value',
      builder: '_eyeDropperInline',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';

/// A swatch the example can pick from.
class _EyeDropperSwatch extends StatelessWidget {
  const _EyeDropperSwatch(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const SizedBox(width: 120, height: 72),
    );
  }
}

/// The picker, with the live result echoed as text and a swatch.
class _EyeDropperPicker extends StatefulWidget {
  const _EyeDropperPicker({this.inline = false});

  final bool inline;

  @override
  State<_EyeDropperPicker> createState() => _EyeDropperPickerState();
}

class _EyeDropperPickerState extends State<_EyeDropperPicker> {
  Color? _picked;

  void _eyeDropperPick() async {
    final Color? color = await pickColorFromScreen(context);
    if (mounted) {
      setState(() => _picked = color);
    }
  }

  String _eyeDropperHex(Color color) {
    String byte(double channel) =>
        ((channel * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
    return '${byte(color.r)}${byte(color.g)}${byte(color.b)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return EyeDropperLayer(
      previewAlignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!widget.inline)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const _EyeDropperSwatch(Color(0xFF2563EB)),
                Gap(theme.spacing.sm),
                const _EyeDropperSwatch(Color(0xFF22C55E)),
              ],
            ),
          if (!widget.inline) Gap(theme.spacing.lg),
          GestureDetector(
            onTap: _eyeDropperPick,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.primary,
                borderRadius: theme.borderRadiusMd,
              ),
              child: Padding(
                padding: EdgeInsetsDensity.pxSymmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  _picked == null ? 'Pick a colour' : 'Pick again',
                  style: TextStyle(color: theme.colors.primaryForeground),
                ),
              ),
            ),
          ),
          Gap(theme.spacing.lg),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _picked ?? theme.colors.muted,
                  border: Border.all(color: theme.colors.border),
                  borderRadius: theme.borderRadiusSm,
                ),
                child: SizedBox(
                  width: theme.spacing.xl,
                  height: theme.spacing.xl,
                ),
              ),
              Gap(theme.spacing.sm),
              Text(
                _picked == null
                    ? 'no colour picked'
                    : '#${_eyeDropperHex(_picked!)}',
                style: TextStyle(color: theme.colors.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The picker with the swatches hidden.
Widget _eyeDropperInline(BuildContext context) =>
    const _EyeDropperPicker(inline: true);
''',
    ),
  ],
  'formatter': <DocsExampleSource>[],
  'group': <DocsExampleSource>[],
  'history': <DocsExampleSource>[],
  'hsl': <DocsExampleSource>[],
  'hsv': <DocsExampleSource>[],
  'icon': <DocsExampleSource>[],
  'locale_utils': <DocsExampleSource>[],
  'media_query': <DocsExampleSource>[],
  'multiple_choice': <DocsExampleSource>[],
  'outlined_container': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_outlinedContainerDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/outlined_container/outlined_container.dart';

/// Token look: the theme border and card surface at the default radius.
Widget _outlinedContainerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return SizedBox(
    width: 320,
    child: OutlinedContainer(
      padding: EdgeInsets.all(spacing.lg),
      child: const Text('Outlined container'),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Rounded',
      builder: '_outlinedContainerRounded',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/outlined_container/outlined_container.dart';

/// A wider radius and denser padding.
Widget _outlinedContainerRounded(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: OutlinedContainer(
      padding: EdgeInsetsDensity.pxAll(20),
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Text('Rounded corners'),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Translucent',
      builder: '_outlinedContainerTranslucent',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/outlined_container/outlined_container.dart';

/// A translucent fill and a backdrop-blurred surface.
Widget _outlinedContainerTranslucent(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const SizedBox(
        width: 320,
        child: OutlinedContainer(
          padding: EdgeInsetsDensity.pxAll(16),
          backgroundColor: ThemedColor.ref(ColorRef.primary),
          surfaceOpacity: 0.12,
          child: Text('Translucent primary fill'),
        ),
      ),
      Gap(spacing.lg),
      const SizedBox(
        width: 320,
        child: OutlinedContainer(
          padding: EdgeInsetsDensity.pxAll(16),
          surfaceBlur: 12,
          surfaceOpacity: 0.6,
          child: Text('Backdrop blur'),
        ),
      ),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Dashed',
      builder: '_outlinedContainerDashed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/density.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/outlined_container/outlined_container.dart';

/// The dashed outline form.
Widget _outlinedContainerDashed(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return SizedBox(
    width: 320,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DashedContainer(
          child: Padding(
            padding: EdgeInsetsDensity.pxAll(16),
            child: const Text('Dashed container'),
          ),
        ),
        Gap(spacing.lg),
        const DashedLine(),
      ],
    ),
  );
}
''',
    ),
  ],
  'overlay_configuration': <DocsExampleSource>[],
  'page_route': <DocsExampleSource>[],
  'patch': <DocsExampleSource>[],
  'scrollable': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/scrollable/scrollable.dart';

/// A horizontal strip with edge fades.
Widget _default(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 72,
    child: FadedScrollableViewport(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Item ${index + 1}'),
        ),
      ),
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_vertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/scrollable/scrollable.dart';

/// A vertical list with edge fades.
Widget _vertical(BuildContext context) {
  return SizedBox(
    width: 280,
    height: 160,
    child: FadedScrollableViewport(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Row ${index + 1}'),
        ),
      ),
    ),
  );
}
''',
    ),
  ],
  'scrollable_client': <DocsExampleSource>[],
  'scrollview': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/scrollview/scrollview.dart';

/// A list wrapped in the middle-button autoscroll interceptor.
Widget _default(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    width: 360,
    height: 220,
    child: ScrollViewInterceptor(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int index = 1; index <= 30; index++)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Drag with the middle button · $index'),
              ),
            Gap(theme.spacing.lg),
          ],
        ),
      ),
    ),
  );
}
''',
    ),
  ],
  'selectable': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/selectable/selectable.dart';

/// Plain selectable text.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: SelectableText(
      'Select this text to see the custom selection styling.',
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Long text',
      builder: '_longText',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/selectable/selectable.dart';

/// A wrapping paragraph showing selection across lines.
Widget _longText(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: SelectableText(
      'Flutter widgets are built from smaller pieces until the whole screen '
      'reads as one surface. Drag across this paragraph to select words, '
      'lines, or the entire block with the custom caret and highlight.',
    ),
  );
}
''',
    ),
  ],
  'spell_check_suggestions_toolbar': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/spell_check_suggestions_toolbar/spell_check_suggestions_toolbar.dart';

void _noop() {}

/// Anchored toolbar with three replacement rows, one disabled.
Widget _default(BuildContext context) {
  return SizedBox(
    width: 280,
    height: 140,
    child: SpellCheckSuggestionsToolbar(
      anchors: TextSelectionToolbarAnchors(primaryAnchor: Offset(12, 12)),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(label: 'receipt', onPressed: _noop),
        ContextMenuButtonItem(label: 'receipts', onPressed: _noop),
        ContextMenuButtonItem(label: 'deceit', onPressed: null),
      ],
    ),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'No suggestions',
      builder: '_noSuggestions',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/components/spell_check_suggestions_toolbar/spell_check_suggestions_toolbar.dart';

/// The placeholder row shown when the service has no suggestion.
Widget _noSuggestions(BuildContext context) {
  return SizedBox(
    width: 280,
    height: 80,
    child: SpellCheckSuggestionsToolbar(
      anchors: TextSelectionToolbarAnchors(primaryAnchor: Offset(12, 12)),
      buttonItems: <ContextMenuButtonItem>[
        ContextMenuButtonItem(onPressed: null),
      ],
    ),
  );
}
''',
    ),
  ],
  'stage_container': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/stage_container/stage_container.dart';

/// The content the stage wraps; prints the resolved outer padding.
class _StageContent extends StatelessWidget {
  const _StageContent();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return StageContainer(
      builder: (BuildContext context, EdgeInsets padding) {
        return Container(
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colors.muted,
            border: Border.all(color: theme.colors.border),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: theme.colors.card,
            child: Text(
              'padding: ${padding.left.toStringAsFixed(0)} / '
              '${padding.right.toStringAsFixed(0)}',
              style: TextStyle(color: theme.colors.mutedForeground),
            ),
          ),
        );
      },
    );
  }
}

/// The stage at the available width.
Widget _default(BuildContext context) {
  return const _StageContent();
}
''',
    ),
    DocsExampleSource(
      name: 'Narrow',
      builder: '_narrow',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/stage_container/stage_container.dart';

/// The content the stage wraps; prints the resolved outer padding.
class _StageContent extends StatelessWidget {
  const _StageContent();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return StageContainer(
      builder: (BuildContext context, EdgeInsets padding) {
        return Container(
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colors.muted,
            border: Border.all(color: theme.colors.border),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: theme.colors.card,
            child: Text(
              'padding: ${padding.left.toStringAsFixed(0)} / '
              '${padding.right.toStringAsFixed(0)}',
              style: TextStyle(color: theme.colors.mutedForeground),
            ),
          ),
        );
      },
    );
  }
}

/// The stage inside a narrow column.
Widget _narrow(BuildContext context) {
  return const Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[SizedBox(width: 320, child: _StageContent())],
  );
}
''',
    ),
  ],
  'swiper': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_drawer',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/swiper/swiper.dart';

/// Drag towards the panel edge to reveal a drawer.
Widget _drawer(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 200,
    child: Swiper(
      position: OverlayPosition.left,
      builder: (BuildContext context) =>
          const _Panel(title: 'Drawer', hint: 'Swipe it away to dismiss'),
      child: const _SwipeSurface('Swipe right for a drawer'),
    ),
  );
}

/// A tappable-looking surface that carries the swipe hint.
class _SwipeSurface extends StatelessWidget {
  const _SwipeSurface(this.hint);

  final String hint;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.muted,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(hint, style: TextStyle(color: colors.mutedForeground)),
    );
  }
}

/// The overlay body used by both variants.
class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Gap(ShadcnTheme.of(context).spacing.sm),
          Text(hint, style: TextStyle(color: colors.mutedForeground)),
        ],
      ),
    );
  }
}
''',
    ),
    DocsExampleSource(
      name: 'Sheet',
      builder: '_sheet',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/foundation/gap.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/swiper/swiper.dart';

/// Drag up to reveal a sheet.
Widget _sheet(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 200,
    child: Swiper(
      position: OverlayPosition.bottom,
      variant: SwiperVariant.sheet,
      builder: (BuildContext context) =>
          const _Panel(title: 'Sheet', hint: 'Drag down to dismiss'),
      child: const _SwipeSurface('Swipe up for a sheet'),
    ),
  );
}

/// A tappable-looking surface that carries the swipe hint.
class _SwipeSurface extends StatelessWidget {
  const _SwipeSurface(this.hint);

  final String hint;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.muted,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(hint, style: TextStyle(color: colors.mutedForeground)),
    );
  }
}

/// The overlay body used by both variants.
class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Gap(ShadcnTheme.of(context).spacing.sm),
          Text(hint, style: TextStyle(color: colors.mutedForeground)),
        ],
      ),
    );
  }
}
''',
    ),
  ],
  'switcher': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/switcher/switcher.dart';

/// Horizontal pager driven by buttons; owns its index.
class _HorizontalSwitcher extends StatefulWidget {
  const _HorizontalSwitcher();

  @override
  State<_HorizontalSwitcher> createState() => _HorizontalSwitcherState();
}

class _HorizontalSwitcherState extends State<_HorizontalSwitcher> {
  int _index = 0;
  final List<int> _reported = <int>[];

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 240,
          height: 120,
          child: Switcher(
            index: _index,
            direction: AxisDirection.right,
            onIndexChanged: (int value) {
              _reported.add(value);
              setState(() => _index = value);
            },
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                ColoredBox(
                  color: i.isEven ? theme.colors.muted : theme.colors.accent,
                  child: Center(child: Text('page $i')),
                ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        Wrap(
          spacing: theme.spacing.sm,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              Button(
                size: ButtonSize.sm,
                variant: i == _index
                    ? ButtonVariant.primary
                    : ButtonVariant.outline,
                onPressed: () => setState(() => _index = i),
                child: Text('$i'),
              ),
          ],
        ),
        SizedBox(height: theme.spacing.sm),
        Text('reported: $_reported'),
      ],
    );
  }
}

Widget _default(BuildContext context) => const _HorizontalSwitcher();
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_vertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/button/button.dart';
import 'package:<your_app>/ui/shadcn/components/switcher/switcher.dart';

/// Vertical pager with a slower scoped curve.
Widget _vertical(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return ComponentTheme<SwitcherTheme>(
    data: const SwitcherTheme(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    child: SizedBox(
      width: 240,
      height: 100,
      child: Switcher(
        direction: AxisDirection.down,
        children: <Widget>[
          for (int i = 0; i < 2; i++)
            ColoredBox(
              color: i.isEven ? theme.colors.muted : theme.colors.accent,
              child: Center(child: Text('v$i')),
            ),
        ],
      ),
    ),
  );
}
''',
    ),
  ],
  'timeline_animation': <DocsExampleSource>[],
  'triple_dots': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_tripleDotsDefault',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/triple_dots/triple_dots.dart';

/// Counts, sizes and strokes in one row.
Widget _tripleDotsDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.xxl,
    runSpacing: spacing.md,
    alignment: WrapAlignment.center,
    children: const <Widget>[
      TripleDots(),
      TripleDots(count: 4, spacing: 4),
      TripleDots(size: 6),
    ],
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Vertical',
      builder: '_tripleDotsVertical',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/triple_dots/triple_dots.dart';

/// The dots stacked vertically.
Widget _tripleDotsVertical(BuildContext context) {
  return const Align(
    alignment: AlignmentDirectional.centerStart,
    child: TripleDots(direction: Axis.vertical),
  );
}
''',
    ),
    DocsExampleSource(
      name: 'Themed dots',
      builder: '_tripleDotsThemed',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/color_tokens.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/triple_dots/triple_dots.dart';

/// A scoped theme leg: coloured, smaller dots.
Widget _tripleDotsThemed(BuildContext context) {
  return ComponentTheme<TripleDotsTheme>(
    data: const TripleDotsTheme(
      color: ThemedColor.ref(ColorRef.primary),
      size: 5,
    ),
    child: const TripleDots(),
  );
}
''',
    ),
  ],
  'window': <DocsExampleSource>[
    DocsExampleSource(
      name: 'Default',
      builder: '_default',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/window/window.dart';

/// One draggable, resizable window; owns its controller.
class _SingleWindow extends StatefulWidget {
  const _SingleWindow();

  @override
  State<_SingleWindow> createState() => _SingleWindowState();
}

class _SingleWindowState extends State<_SingleWindow> {
  final WindowController _notes = WindowController(
    bounds: const Rect.fromLTWH(24, 20, 280, 190),
  );

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 300,
      child: WindowNavigator(
        initialWindows: <Window>[
          Window(
            controller: _notes,
            title: const Text('Notes'),
            content: Padding(
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
              child: const Text('Drag the title bar; resize from any edge.'),
            ),
          ),
        ],
        child: const SizedBox.expand(),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _SingleWindow();
''',
    ),
    DocsExampleSource(
      name: 'Maximized',
      builder: '_maximized',
      code: r'''import 'package:flutter/widgets.dart';
import 'package:<your_app>/ui/shadcn/theme/theme.dart';
import 'package:<your_app>/ui/shadcn/components/window/window.dart';

/// A maximized window next to a floating one; owns its controllers.
class _MaximizedWindow extends StatefulWidget {
  const _MaximizedWindow();

  @override
  State<_MaximizedWindow> createState() => _MaximizedWindowState();
}

class _MaximizedWindowState extends State<_MaximizedWindow> {
  final WindowController _main = WindowController(
    bounds: const Rect.fromLTWH(24, 20, 280, 190),
    maximized: const Rect.fromLTWH(0, 0, 1, 1),
  );
  final WindowController _inspector = WindowController(
    bounds: const Rect.fromLTWH(60, 60, 220, 150),
    alwaysOnTop: true,
  );

  @override
  void dispose() {
    _main.dispose();
    _inspector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 300,
      child: WindowNavigator(
        initialWindows: <Window>[
          Window(
            controller: _main,
            title: const Text('Editor'),
            content: Padding(
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
              child: const Text('Maximized; restore from the title bar.'),
            ),
          ),
          Window(
            controller: _inspector,
            title: const Text('Inspector'),
            content: Padding(
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
              child: const Text('Always on top.'),
            ),
          ),
        ],
        child: const SizedBox.expand(),
      ),
    );
  }
}

Widget _maximized(BuildContext context) => const _MaximizedWindow();
''',
    ),
  ],
};
