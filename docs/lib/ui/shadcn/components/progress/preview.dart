// Gallery preview for the `progress` component.
//
// Widgets-only, like the component itself. Shows determinate values,
// indeterminate mode, heights, sparks, a custom theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'progress.dart';

/// Preview entry point used by the docs gallery.
class ProgressPreview extends StatelessWidget {
  /// Creates the preview.
  const ProgressPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _ProgressPreviewBody(),
      ),
    );
  }
}

class _ProgressPreviewBody extends StatelessWidget {
  const _ProgressPreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Progress(value: 0.25, semanticsLabel: 'Quarter'),
              const SizedBox(height: 16),
              const Progress(value: 0.6),
              const SizedBox(height: 16),
              const Progress(value: 0.85, showSparks: true),
              const SizedBox(height: 16),
              const Progress(value: 0.4, height: 4),
              const SizedBox(height: 16),
              const Progress(value: 0.5, height: 14),
              const SizedBox(height: 16),
              const Progress(),
              const SizedBox(height: 16),
              const Progress(
                value: 0.7,
                color: Color(0xFF16A34A),
                backgroundColor: Color(0x3316A34A),
              ),
              const SizedBox(height: 16),
              ComponentTheme<ProgressTheme>(
                data: const ProgressTheme(
                  color: ThemedColor.ref(ColorRef.chart2),
                  height: 6,
                ),
                child: const Progress(value: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
