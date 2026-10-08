// Widgets-only preview gallery for the `backdrop_transform` component.
//
// The slider drives `t`, so the scale, the corner radius and the freed layout
// space can be inspected without a sheet.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'backdrop_transform.dart';

/// Preview entry point used by the docs gallery.
class BackdropTransformPreview extends StatefulWidget {
  /// Creates the preview.
  const BackdropTransformPreview({super.key});

  @override
  State<BackdropTransformPreview> createState() =>
      _BackdropTransformPreviewState();
}

class _BackdropTransformPreviewState extends State<BackdropTransformPreview> {
  double _t = 0.5;

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
    const ScaleBackdropTransform transform = ScaleBackdropTransform();
    const Size size = Size(300, 160);
    final Size freed = transform.resolveExtraSize(size, _t);
    return ColoredBox(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('t = ${_t.toStringAsFixed(2)}'),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) => setState(
                () => _t = (_t + details.delta.dx / 300).clamp(0.0, 1.0),
              ),
              onTapDown: (details) => setState(
                () => _t = (details.localPosition.dx / 300).clamp(0.0, 1.0),
              ),
              child: Container(
                height: 8,
                color: ShadcnTheme.of(context).colors.muted,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'freed ${freed.width.toStringAsFixed(1)}'
                        ' x ${freed.height.toStringAsFixed(1)}',
                      ),
                    ),
                    Positioned.fill(
                      child: transform.wrapBackdrop(
                        context,
                        ColoredBox(
                          color: colors.muted,
                          child: Center(
                            child: Text(
                              'scale ${transform.scaleAt(_t).toStringAsFixed(3)}',
                            ),
                          ),
                        ),
                        _t,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('no transform'),
            const SizedBox(height: 8),
            SizedBox(
              width: size.width,
              height: 60,
              child: BackdropTransform.none.wrapBackdrop(
                context,
                const ColoredBox(color: Color(0x22000000)),
                _t,
              ),
            ),
            const SizedBox(height: 16),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: Builder(
                builder: (context) => ColoredBox(
                  color: ShadcnTheme.of(context).colors.background,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'dark tokens / radiusXxl = '
                      '${ShadcnTheme.of(context).radiusXxl}',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
