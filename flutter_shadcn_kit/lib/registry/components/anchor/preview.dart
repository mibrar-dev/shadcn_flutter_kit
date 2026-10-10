// Widgets-only preview gallery for the `anchor` component.
//
// Two sibling scopes reuse the same anchor key, which the old
// process-wide `OverlayAnchorRegistry.global` could not express. Tapping a row
// resolves a `LinkedAnchor` from the row's own scope and reports the anchor box
// it found.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'anchor.dart';

/// Preview entry point used by the docs gallery.
class AnchorPreview extends StatefulWidget {
  /// Creates the preview.
  const AnchorPreview({super.key});

  @override
  State<AnchorPreview> createState() => _AnchorPreviewState();
}

class _AnchorPreviewState extends State<AnchorPreview> {
  String _report = 'tap a row';

  void _resolve(BuildContext rowContext, String label) {
    const LinkedAnchor anchor = LinkedAnchor('row-anchor');
    final Anchor resolved = anchor.resolve(rowContext);
    final AnchorSubscription subscription = resolved.subscribe();
    final RenderBox? box = subscription.currentAnchorBox;
    setState(() {
      _report = box == null
          ? '$label: no anchor'
          : '$label: ${box.size.width.toStringAsFixed(0)}'
                'x${box.size.height.toStringAsFixed(0)} '
                'visible=${subscription.isVisible} '
                'tracking=${subscription.supportsCompositeTracking}';
    });
    subscription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: _body(context),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_report),
            SizedBox(height: ShadcnTheme.of(context).spacing.md),
            // Both rows register the same key; only their own scope resolves it.
            for (final String label in <String>['first', 'second'])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OverlayAnchorScope(
                  child: Builder(
                    builder: (rowContext) => OverlayAnchor(
                      anchor: 'row-anchor',
                      child: Button(
                        variant: ButtonVariant.outline,
                        onPressed: () => _resolve(rowContext, label),
                        child: Text('$label row'),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: ShadcnTheme.of(context).spacing.md),
            Builder(
              builder: (context) => ColoredBox(
                color: ShadcnTheme.of(context).colors.background,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('dark tokens / $_report'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
