// Named examples for the `eye_dropper` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// The eye-dropper runs inside its own [EyeDropperLayer], so a pick started in
// one example never leaks into another.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'eye_dropper.dart';

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

/// The picker with the swatches hidden.
Widget _eyeDropperInline(BuildContext context) =>
    const _EyeDropperPicker(inline: true);

/// Named docs examples for `eye_dropper`; the first entry is the default.
const List<ComponentPreview> eyeDropperPreviews = <ComponentPreview>[
  ComponentPreview('Default', _eyeDropperDefault),
  ComponentPreview('Inline value', _eyeDropperInline),
];
