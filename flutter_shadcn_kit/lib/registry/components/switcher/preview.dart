// Widgets-only preview gallery for the `switcher` component.
//
// Drives the position with buttons (external `index`) and with a real drag, on
// both axes, plus a scoped theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'switcher.dart';

/// Preview entry point used by the docs gallery.
class SwitcherPreview extends StatefulWidget {
  /// Creates the preview.
  const SwitcherPreview({super.key});

  @override
  State<SwitcherPreview> createState() => _SwitcherPreviewState();
}

class _SwitcherPreviewState extends State<SwitcherPreview> {
  int _index = 0;
  final List<int> _reported = <int>[];

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
    final List<Widget> pages = <Widget>[
      for (int i = 0; i < 3; i++)
        ColoredBox(
          color: i.isEven ? colors.muted : colors.accent,
          child: Center(child: Text('page $i')),
        ),
    ];
    return ColoredBox(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 240,
              height: 120,
              child: Switcher(
                index: _index,
                direction: AxisDirection.right,
                onIndexChanged: (int value) {
                  _reported.add(value);
                  setState(() => _index = value);
                },
                children: pages,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: <Widget>[
                for (int i = 0; i < 3; i++)
                  Button(
                    size: ButtonSize.sm,
                    variant: i == _index
                        ? ButtonVariant.primary
                        : ButtonVariant.outline,
                    onPressed: () => setState(() => _index = i),
                    child: Text('$i'),
                  ),
                Button(
                  size: ButtonSize.sm,
                  variant: ButtonVariant.ghost,
                  onPressed: () => _reported.clear(),
                  child: const Text('clear log'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('reported: $_reported'),
            const SizedBox(height: 16),
            const Text('vertical, slower curve'),
            ComponentTheme<SwitcherTheme>(
              data: const SwitcherTheme(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
              ),
              child: SizedBox(
                width: 240,
                height: 100,
                child: Switcher(
                  direction: AxisDirection.down,
                  children: <Widget>[
                    for (int i = 0; i < 2; i++)
                      ColoredBox(
                        color: i.isEven ? colors.muted : colors.accent,
                        child: Center(child: Text('v$i')),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Clickable(
              onPressed: () => setState(() => _index = _index),
              child: const Text('rebuild with the same index'),
            ),
            const SizedBox(height: 16),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: Builder(
                builder: (context) => ColoredBox(
                  color: ShadcnTheme.of(context).colors.background,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('dark tokens / index $_index'),
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
