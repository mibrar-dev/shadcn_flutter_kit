// Gallery preview for the `eye_dropper` component: a small palette, a pick
// button and the live result, plus a dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'eye_dropper.dart';

/// Renders the eye-dropper gallery.
class EyeDropperPreview extends StatefulWidget {
  /// Creates the preview.
  const EyeDropperPreview({super.key});

  @override
  State<EyeDropperPreview> createState() => _EyeDropperPreviewState();
}

class _EyeDropperPreviewState extends State<EyeDropperPreview> {
  Color? _picked;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: EyeDropperLayer(
        previewAlignment: Alignment.topLeft,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _EyeDropperSwatch(Color(0xFF2563EB)),
                  Gap(8),
                  _EyeDropperSwatch(Color(0xFF22C55E)),
                ],
              ),
              const Gap(16),
              _FakeButton(
                label: _picked == null ? 'Pick a colour' : 'Pick again',
                onTap: () async {
                  final Color? color = await pickColorFromScreen(context);
                  if (mounted) {
                    setState(() => _picked = color);
                  }
                },
              ),
              const Gap(16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: _picked ?? theme.colors.muted,
                      border: Border.all(color: theme.colors.border),
                      borderRadius: theme.borderRadiusSm,
                    ),
                    child: const SizedBox(width: 24, height: 24),
                  ),
                  const Gap(8),
                  Text(
                    _picked == null ? 'no colour picked' : '#${_hex(_picked!)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _hex(Color color) {
    String byte(double channel) =>
        ((channel * 255).round() & 0xFF).toRadixString(16).padLeft(2, '0');
    return '${byte(color.r)}${byte(color.g)}${byte(color.b)}';
  }
}

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

class _FakeButton extends StatelessWidget {
  const _FakeButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(color: theme.colors.primaryForeground),
          ),
        ),
      ),
    );
  }
}
