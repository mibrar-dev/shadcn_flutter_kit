// Gallery preview for the `alert_dialog` component: the static composition
// plus a live push through `showAlertDialog`, in light and dark.
// Widgets-only; the docs app embeds [AlertDialogPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'alert_dialog.dart';

/// Renders the alert dialog gallery.
class AlertDialogPreview extends StatefulWidget {
  /// Creates the preview.
  const AlertDialogPreview({super.key});

  @override
  State<AlertDialogPreview> createState() => _AlertDialogPreviewState();
}

class _AlertDialogPreviewState extends State<AlertDialogPreview> {
  bool _withIcon = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(
          color: ShadcnTheme.of(context).colors.foreground,
          fontSize: 13,
        ),
        child: ColoredBox(
          color: ShadcnTheme.of(context).colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  'Open',
                  Button(
                    onPressed: _show,
                    child: const Text('Show alert dialog'),
                  ),
                ),
                const Gap(24),
                _section(
                  'Composition',
                  Button(
                    size: ButtonSize.sm,
                    variant: ButtonVariant.outline,
                    onPressed: () => setState(() => _withIcon = !_withIcon),
                    child: Text(
                      _withIcon ? 'Header icon: on' : 'Header icon: off',
                    ),
                  ),
                ),
                const Gap(24),
                _section('Static body', _body()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _show() {
    showAlertDialog<bool>(
      context: context,
      icon: const Icon(LucideIcons.triangleAlert),
      title: const Text('Delete this project?'),
      description: const Text(
        'This action cannot be undone. The project and its history are removed.',
      ),
      actions: <Widget>[
        Button(
          variant: ButtonVariant.outline,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        Button(
          variant: ButtonVariant.destructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Widget _body() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ShadcnTheme.of(context).colors.background,
        borderRadius: ShadcnTheme.of(context).borderRadiusLg,
        border: Border.all(color: ShadcnTheme.of(context).colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AlertDialog(
          icon: _withIcon ? const Icon(LucideIcons.circleAlert) : null,
          title: const Text('Are you absolutely sure?'),
          description: const Text('This permanently deletes the account.'),
          actions: <Widget>[
            Button(
              size: ButtonSize.sm,
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Cancel'),
            ),
            Button(
              size: ButtonSize.sm,
              variant: ButtonVariant.destructive,
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ShadcnColors.darkFallback.background,
          borderRadius: ShadcnTheme.of(context).borderRadiusLg,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: const AlertDialog(
            title: Text('Dark alert'),
            description: Text('Tokens resolve against the dark palette.'),
            actions: <Widget>[
              Button(
                size: ButtonSize.sm,
                variant: ButtonVariant.ghost,
                onPressed: _noop,
                child: Text('Dismiss'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _noop() {}

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
