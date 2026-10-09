// Widgets-only preview gallery for the `tooltip` component.
//
// Shows the default label, an instant tooltip, a standalone container, a
// scoped theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'tooltip.dart';

/// Preview entry point used by the docs gallery.
class TooltipPreview extends StatelessWidget {
  /// Creates the preview.
  const TooltipPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _row(
              context,
              label: 'hover me (500 ms delay)',
              child: _anchor(context, LucideIcons.info, 'Details'),
            ),
            const SizedBox(height: 24),
            _row(
              context,
              label: 'hover me (instant)',
              child: _anchor(
                context,
                LucideIcons.zap,
                'Instant',
                waitDuration: Duration.zero,
              ),
            ),
            const SizedBox(height: 24),
            _row(
              context,
              label: 'scoped theme leg (accent surface)',
              child: ComponentTheme<TooltipTheme>(
                data: const TooltipTheme(
                  background: ThemedColor.ref(ColorRef.accent),
                  foreground: ThemedColor.ref(ColorRef.accentForeground),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: _anchor(context, LucideIcons.star, 'Accent surface'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('standalone TooltipContainer'),
            const SizedBox(height: 8),
            const TooltipContainer(child: Text('Primary surface')),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Row(
      children: <Widget>[
        child,
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: colors.mutedForeground)),
      ],
    );
  }

  Widget _anchor(
    BuildContext context,
    IconData icon,
    String label, {
    Duration waitDuration = kTooltipWaitDuration,
  }) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Tooltip(
      waitDuration: waitDuration,
      tooltip: (context) => Text(label),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: colors.foreground),
      ),
    );
  }
}
