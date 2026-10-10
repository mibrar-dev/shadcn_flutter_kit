// Widgets-only preview gallery for the `dot_indicator` component.
//
// Shows both axes, tap targets, a read-only run, a scoped theme leg, a custom
// dot builder and dark tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'dot_indicator.dart';

/// Preview entry point used by the docs gallery.
class DotIndicatorPreview extends StatefulWidget {
  /// Creates the preview.
  const DotIndicatorPreview({super.key});

  @override
  State<DotIndicatorPreview> createState() => _DotIndicatorPreviewState();
}

class _DotIndicatorPreviewState extends State<DotIndicatorPreview> {
  int _index = 0;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('index $_index'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            DotIndicator(
              index: _index,
              length: 5,
              onChanged: (int value) => setState(() => _index = value),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.lg),
            const Text('read-only (no click cursor, no tap target)'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            DotIndicator(index: 1, length: 5),
            SizedBox(height: ShadcnTheme.of(context).spacing.lg),
            const Text('vertical'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            DotIndicator(
              index: 0,
              length: 3,
              direction: Axis.vertical,
              onChanged: (int value) => setState(() => _index = value),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.lg),
            const Text('scoped theme leg (bigger, accent dots)'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            ComponentTheme<DotIndicatorTheme>(
              data: const DotIndicatorTheme(
                active: DotStyle(
                  background: StateValue(
                    rest: ThemedColor.ref(ColorRef.accent),
                  ),
                  size: 18,
                ),
                spacing: 14,
              ),
              child: DotIndicator(
                index: _index,
                length: 5,
                onChanged: (int value) => setState(() => _index = value),
              ),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.lg),
            const Text('custom builder'),
            SizedBox(height: ShadcnTheme.of(context).spacing.sm),
            DotIndicator(
              index: _index,
              length: 4,
              dotBuilder: (context, index, isActive) => SizedBox(
                width: isActive ? 24 : 8,
                height: ShadcnTheme.of(context).spacing.sm,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive
                        ? ShadcnTheme.of(context).colors.foreground
                        : ShadcnTheme.of(context).colors.mutedForeground,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.lg),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: Builder(
                builder: (context) => ColoredBox(
                  color: ShadcnTheme.of(context).colors.background,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: DotIndicator(index: 2, length: 5),
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
