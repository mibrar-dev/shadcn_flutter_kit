// Gallery preview for the `alert` component: both variants, a dark palette
// and a themed override. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'alert.dart';

/// Renders the alert gallery.
class AlertPreview extends StatelessWidget {
  /// Creates the preview.
  const AlertPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 512,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Alert(
                  title: Text('Heads up'),
                  content: Text('You can install components from the CLI.'),
                ),
                const Gap(16),
                const Alert(
                  variant: AlertVariant.destructive,
                  title: Text('Session expired'),
                  content: Text('Please log in again to continue.'),
                ),
                const Gap(16),
                const Alert(
                  title: Text('Notification'),
                  content: Text('You have a new message.'),
                  trailing: Text('Now'),
                ),
                const Gap(32),
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: Builder(
                    builder: (context) => const Alert(
                      title: Text('Dark palette'),
                      content: Text('Token colours follow the preset.'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
