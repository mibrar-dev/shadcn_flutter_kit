// Widgets-only preview gallery for the `media_query` component.
//
// The preview drives the width with an explicit `MediaQuery` override, so the
// four theme legs and both viewport directions are visible without a real
// device.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'media_query.dart';

/// Preview entry point used by the docs gallery.
class MediaQueryPreview extends StatefulWidget {
  /// Creates the preview.
  const MediaQueryPreview({super.key});

  @override
  State<MediaQueryPreview> createState() => _MediaQueryPreviewState();
}

class _MediaQueryPreviewState extends State<MediaQueryPreview> {
  double _width = 480;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return MediaQuery(
      data: MediaQueryData(size: Size(_width, 640)),
      child: ColoredBox(
        color: colors.background,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('viewport width: ${_width.round()}'),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              _widthSlider(),
              SizedBox(height: ShadcnTheme.of(context).spacing.xl),
              _visibility(),
              SizedBox(height: ShadcnTheme.of(context).spacing.xl),
              _visibility(
                minWidth: 600,
                alternateChild: const Text('below the min bound'),
                child: const Text('at or above the min bound'),
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              _visibility(
                maxWidth: 400,
                alternateChild: const Text('above the max bound'),
                child: const Text('at or below the max bound'),
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              const Text('scoped theme leg (min 600 / max 1000)'),
              ComponentTheme<MediaQueryVisibilityTheme>(
                data: const MediaQueryVisibilityTheme(
                  minWidth: 600,
                  maxWidth: 1000,
                ),
                child: MediaQueryVisibility(
                  alternateChild: const Text('scoped: outside 600..1000'),
                  child: const Text('scoped: inside 600..1000'),
                ),
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.xl),
              Builder(
                builder: (context) => ColoredBox(
                  color: ShadcnTheme.of(context).colors.background,
                  child: _visibility(
                    minWidth: 600,
                    alternateChild: const Text('dark: mobile'),
                    child: const Text('dark: desktop'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widthSlider() => GestureDetector(
    onHorizontalDragUpdate: (details) =>
        setState(() => _width = (_width + details.delta.dx).clamp(240, 1200)),
    child: Container(height: 8, color: ShadcnColors.lightFallback.muted),
  );

  Widget _visibility({
    double? minWidth,
    double? maxWidth,
    Widget? alternateChild,
    Widget? child,
  }) {
    return MediaQueryVisibility(
      minWidth: minWidth,
      maxWidth: maxWidth,
      alternateChild: alternateChild ?? const Text('collapsed (no alternate)'),
      child: child ?? const Text('always shown'),
    );
  }
}
