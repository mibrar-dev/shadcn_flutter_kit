// Gallery preview for the `switch` component: on/off, controlled and
// controller-driven modes, labels, disabled and dark.
// Widgets-only; the docs app embeds [SwitchPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'switch.dart';

/// Renders the switch gallery.
class SwitchPreview extends StatefulWidget {
  /// Creates the preview.
  const SwitchPreview({super.key});

  @override
  State<SwitchPreview> createState() => _SwitchPreviewState();
}

class _SwitchPreviewState extends State<SwitchPreview> {
  final SwitchController _controller = SwitchController(true);
  bool _controlled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(context, 'Controlled', _controlledRow()),
                Gap(theme.spacing.xl),
                _section(context, 'Controller', _controllerRow(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Disabled', _disabled(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlledRow() {
    return Switch(
      value: _controlled,
      onChanged: (value) => setState(() => _controlled = value),
      label: const Text('Airplane mode'),
    );
  }

  Widget _controllerRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Switch(
          controller: _controller,
          label: const Text('Driven by a controller'),
        ),
        Gap(ShadcnTheme.of(context).spacing.lg),
        Text('value: $_controller'),
      ],
    );
  }

  Widget _disabled(BuildContext context) {
    return Wrap(
      spacing: ShadcnTheme.of(context).spacing.xl,
      runSpacing: ShadcnTheme.of(context).spacing.md,
      children: <Widget>[
        Switch(value: true, label: Text('on')),
        Switch(value: false, label: Text('off')),
      ],
    );
  }

  Widget _dark(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: Padding(
          padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.lg),
          child: Switch(value: true, onChanged: _noop, label: Text('dark')),
        ),
      ),
    );
  }

  static void _noop(bool value) {}

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
