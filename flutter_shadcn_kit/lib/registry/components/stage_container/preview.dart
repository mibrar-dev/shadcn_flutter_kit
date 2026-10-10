// Gallery preview for the `stage_container` component: the same content at
// three container widths, printing the outer padding the stage resolves.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'stage_container.dart';

/// Renders the stage container gallery.
class StageContainerPreview extends StatelessWidget {
  /// Creates the preview.
  const StageContainerPreview({super.key});

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
                _StageDemo(width: 480, label: 'Narrow (480)'),
                Gap(theme.spacing.xl),
                _StageDemo(width: 800, label: 'Medium (800)'),
                Gap(theme.spacing.xl),
                _StageDemo(width: 1200, label: 'Wide (1200)'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StageDemo extends StatelessWidget {
  const _StageDemo({required this.width, required this.label});

  final double width;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        SizedBox(
          width: width,
          child: StageContainer(
            builder: (BuildContext context, EdgeInsets padding) {
              return Container(
                padding: padding,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.muted,
                  border: Border.all(color: colors.border),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: colors.card,
                  child: Text(
                    'padding: ${padding.left.toStringAsFixed(0)} / '
                    '${padding.right.toStringAsFixed(0)}',
                    style: TextStyle(color: colors.mutedForeground),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
