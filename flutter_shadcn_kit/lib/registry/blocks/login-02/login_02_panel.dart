// The `login-02` block, part 2: the testimonial panel. Imported by
// `login_02.dart`; a block never imports another block.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';

/// The testimonial panel: muted fill, a token-drawn dot pattern, the product
/// mark and a quote. No images, so it works offline and in every preset.
class Login02Panel extends StatelessWidget {
  /// Creates the panel.
  const Login02Panel({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double spacing = theme.spacing.xl;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
      ),
      child: ClipRRect(
        borderRadius: theme.borderRadiusLg,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _DotPainter(color: theme.colors.mutedForeground),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing),
              // `max` + `spaceBetween` fills a bounded host (the app
              // screen or the 220px stacked panel) and shrink-wraps an
              // unbounded one (the intrinsic docs frame): no Spacer, which
              // would throw under unbounded height.
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: theme.colors.primary,
                          borderRadius: theme.borderRadiusSm,
                        ),
                        child: Icon(
                          LucideIcons.command,
                          size: 16,
                          color: theme.colors.primaryForeground,
                        ),
                      ),
                      Gap(theme.spacing.sm),
                      Text('Acme Inc', style: theme.typography.textSmall),
                    ],
                  ),
                  Gap(theme.spacing.xl),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '"The kit paid for itself the week we adopted it. '
                        'Every screen ships on-brand, light or dark."',
                        style: theme.typography.textLarge,
                      ),
                      Gap(theme.spacing.md),
                      Text(
                        'Sofia Davis — Design lead, Acme',
                        style: theme.typography.textSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A subtle dot grid at 8% opacity of the muted-foreground token.
class _DotPainter extends CustomPainter {
  const _DotPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dot = Paint()..color = color.withValues(alpha: 0.08);
    const double step = 22;
    for (double y = step / 2; y < size.height; y += step) {
      for (double x = step / 2; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1.2, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) => oldDelegate.color != color;
}
