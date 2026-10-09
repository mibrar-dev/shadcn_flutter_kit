// Gallery preview for the `scrollable` component: vertical and horizontal
// fades plus the dark palette.
// Widgets-only; the docs app embeds [ScrollablePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'scrollable.dart';

/// Renders the scrollable gallery.
class ScrollablePreview extends StatelessWidget {
  /// Creates the preview.
  const ScrollablePreview({super.key});

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
                _section('Vertical', _vertical()),
                const Gap(24),
                _section('Horizontal', _horizontal()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _vertical() {
    return SizedBox(
      width: 280,
      height: 160,
      child: FadedScrollableViewport(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Row ${index + 1}'),
          ),
        ),
      ),
    );
  }

  Widget _horizontal() {
    return SizedBox(
      width: 280,
      height: 64,
      child: FadedScrollableViewport(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Item ${index + 1}'),
          ),
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: _vertical(),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
