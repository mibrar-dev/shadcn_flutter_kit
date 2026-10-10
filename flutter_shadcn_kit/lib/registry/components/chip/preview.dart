// Gallery preview for the `chip` component: static, pressable and removable
// chips plus the inner `ChipButton`, in light and dark.
// Widgets-only; the docs app embeds [ChipPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'chip.dart';

/// Renders the chip gallery.
class ChipPreview extends StatefulWidget {
  /// Creates the preview.
  const ChipPreview({super.key});

  @override
  State<ChipPreview> createState() => _ChipPreviewState();
}

class _ChipPreviewState extends State<ChipPreview> {
  final List<String> _tags = <String>['flutter', 'shadcn', 'widgets'];
  int _presses = 0;

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
                _section(context, 'Static', _static(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Pressable', _pressable()),
                Gap(theme.spacing.xl),
                _section(context, 'Removable', _removable()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _static(BuildContext context) {
    return Wrap(
      spacing: ShadcnTheme.of(context).spacing.sm,
      runSpacing: ShadcnTheme.of(context).spacing.sm,
      children: <Widget>[
        Chip(child: Text('static')),
        Chip(leading: Icon(LucideIcons.star, size: 12), child: Text('leading')),
        Chip(trailing: Icon(LucideIcons.x, size: 12), child: Text('trailing')),
      ],
    );
  }

  Widget _pressable() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Chip(
          onPressed: () => setState(() => _presses++),
          child: const Text('pressable'),
        ),
        Text('pressed $_presses times'),
      ],
    );
  }

  Widget _removable() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final String tag in _tags)
          Chip(
            trailing: ChipButton(
              onPressed: () => setState(() => _tags.remove(tag)),
              child: const Icon(LucideIcons.x, size: 12),
            ),
            child: Text(tag),
          ),
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
          child: Chip(child: Text('dark chip')),
        ),
      ),
    );
  }

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
