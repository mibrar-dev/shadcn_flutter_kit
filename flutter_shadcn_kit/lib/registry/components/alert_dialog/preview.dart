// Named examples for the `alert_dialog` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'alert_dialog.dart';

/// The dialog body as shadcn composes it: a framed surface that carries the
/// widget, so the docs stage shows the composition without a route push.
Widget _alertDialogDialog(
  BuildContext context,
  String title,
  String description,
) {
  final theme = ShadcnTheme.of(context);
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: theme.borderRadiusLg,
        border: Border.all(color: theme.colors.border),
        boxShadow: theme.tokens.shadows.shadowLg,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsetsDensity.pxAll(24),
          child: AlertDialog(
            icon: const Icon(LucideIcons.circleAlert),
            title: Text(title),
            description: Text(description),
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
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// The default dialog.
Widget _alertDialogDefault(BuildContext context) => _alertDialogDialog(
  context,
  'Are you absolutely sure?',
  'This permanently deletes the account.',
);

/// The destructive dialog.
Widget _alertDialogDestructive(BuildContext context) => _alertDialogDialog(
  context,
  'Delete this project?',
  'This action cannot be undone. The project and its history are removed.',
);

/// A live push through `showAlertDialog`.
class _AlertDialogPushedDialog extends StatelessWidget {
  const _AlertDialogPushedDialog();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Button(
        onPressed: () => showAlertDialog<bool>(
          context: context,
          icon: const Icon(LucideIcons.triangleAlert),
          title: const Text('Delete this project?'),
          description: const Text(
            'This action cannot be undone. The project and its history are '
            'removed.',
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
        ),
        child: const Text('Show alert dialog'),
      ),
    );
  }
}

Widget _alertDialogPushed(BuildContext context) =>
    const _AlertDialogPushedDialog();

/// Named docs examples for `alert_dialog`; the first entry is the default.
const List<ComponentPreview> alertDialogPreviews = <ComponentPreview>[
  ComponentPreview('Default', _alertDialogDefault),
  ComponentPreview('Destructive', _alertDialogDestructive),
  ComponentPreview('Live push', _alertDialogPushed),
];
