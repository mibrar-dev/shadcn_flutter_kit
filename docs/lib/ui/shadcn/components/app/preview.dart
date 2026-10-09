// Gallery preview for the `app` component: a complete [ShadcnApp] with a
// small home page. Embedding starts a nested WidgetsApp, which is the only
// way to show the shell honestly; the docs gallery hosts this at root level.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/theme.dart';
import 'app.dart';

/// Renders the app-shell preview.
class AppPreview extends StatelessWidget {
  /// Creates the preview.
  const AppPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'ShadcnApp preview',
      home: Builder(
        builder: (BuildContext context) {
          final ShadcnThemeData theme = ShadcnTheme.of(context);
          return ColoredBox(
            color: theme.colors.background,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'ShadcnApp is wired and running.',
                    style: theme.typography.large.copyWith(
                      color: theme.colors.foreground,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    ShadcnLocalizations.of(context).dialogDismiss,
                    style: theme.typography.small.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
