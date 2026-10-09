// Gallery preview for the `border_loading` component.
//
// Widgets-only: one card per mode, a determinate progress driven by the
// child's own ticker and a scoped `ComponentTheme<BorderLoadingTheme>` leg.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'border_loading.dart';

/// Preview entry point used by the docs gallery.
class BorderLoadingPreview extends StatelessWidget {
  /// Creates the preview.
  const BorderLoadingPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _BorderLoadingPreviewBody(),
      ),
    );
  }
}

class _BorderLoadingPreviewBody extends StatelessWidget {
  const _BorderLoadingPreviewBody();

  Widget _card(String label, BorderLoading child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Wrap(
          spacing: 32,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: <Widget>[
            _card(
              'sweep',
              const BorderLoading(child: SizedBox(width: 120, height: 48)),
            ),
            _card(
              'tracer',
              const BorderLoading(
                mode: BorderLoadingMode.tracer,
                tracer: BorderTracerSpec(dashCount: 3),
                child: SizedBox(width: 120, height: 48),
              ),
            ),
            _card(
              'static',
              const BorderLoading(
                mode: BorderLoadingMode.staticBorder,
                child: SizedBox(width: 120, height: 48),
              ),
            ),
            _card(
              'theme leg',
              BorderLoading(
                theme: const BorderLoadingTheme(
                  strokeWidth: 4,
                  duration: Duration(seconds: 2),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: const SizedBox(width: 120, height: 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
