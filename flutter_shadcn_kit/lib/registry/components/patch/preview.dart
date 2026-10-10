// Widgets-only preview gallery for the `patch` component.
//
// Taps increment a counter; the gap between taps and the distance between them
// both reset it.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'patch.dart';

/// Preview entry point used by the docs gallery.
class PatchPreview extends StatefulWidget {
  /// Creates the preview.
  const PatchPreview({super.key});

  @override
  State<PatchPreview> createState() => _PatchPreviewState();
}

class _PatchPreviewState extends State<PatchPreview> {
  int _clicks = 0;
  Offset? _lastPosition;

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClickDetector(
              onClick: (ClickDetails details) => setState(() {
                _clicks = details.clickCount;
                _lastPosition = details.localPosition;
              }),
              child: Container(
                width: 220,
                height: 120,
                alignment: Alignment.center,
                color: colors.muted,
                child: Text('clicks: $_clicks'),
              ),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.md),
            Text('last position: ${_lastPosition ?? '-'}'),
            SizedBox(height: ShadcnTheme.of(context).spacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Button(
                  variant: ButtonVariant.outline,
                  onPressed: () => setState(() => _clicks = 0),
                  child: const Text('reset'),
                ),
                SizedBox(width: ShadcnTheme.of(context).spacing.md),
                const Text('tap fast and near to count up'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
