// Gallery preview for the `scrollview` component: a list wrapped in the
// middle-button autoscroll interceptor.
// Widgets-only; the docs app embeds [ScrollviewPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'scrollview.dart';

/// Renders the scrollview gallery.
class ScrollviewPreview extends StatelessWidget {
  /// Creates the preview.
  const ScrollviewPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: Center(
            child: SizedBox(
              width: 360,
              height: 220,
              child: ScrollViewInterceptor(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (int index = 1; index <= 30; index++)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Drag with the middle button · $index'),
                        ),
                      Gap(theme.spacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
