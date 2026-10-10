// Named examples for the `dialog` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// The example ships its own [Navigator], so the demo opens a real route no
// matter where the docs page mounts it.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'dialog.dart';
import 'dialog_style.dart';

/// The trigger the example wraps in a [Builder], so it can reach the nearest
/// Navigator.
class _DialogTrigger extends StatelessWidget {
  const _DialogTrigger({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDensity.pxSymmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(
          label,
          style: TextStyle(color: theme.colors.primaryForeground),
        ),
      ),
    );
  }
}

/// The dialog card itself.
class _DialogDialogBody extends StatelessWidget {
  const _DialogDialogBody({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: theme.colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(theme.spacing.lg),
        Text(message, style: TextStyle(color: theme.colors.mutedForeground)),
      ],
    );
  }
}

/// A named example driven through a real route push.
class _DialogDialogExample extends StatelessWidget {
  const _DialogDialogExample({
    required this.label,
    this.barrierDismissible = true,
    this.fullScreen = false,
    this.theme,
  });

  final String label;
  final bool barrierDismissible;
  final bool fullScreen;
  final DialogTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) => _DialogTrigger(
          label: label,
          onPressed: () => showShadcnDialog<void>(
            context: context,
            barrierDismissible: barrierDismissible,
            fullScreen: fullScreen,
            theme: theme,
            builder: (context) => _DialogDialogBody(
              title: 'Delete this project?',
              message: 'This cannot be undone.',
            ),
          ),
        ),
      ),
    );
  }
}

/// The default modal dialog.
Widget _dialogDefault(BuildContext context) =>
    const _DialogDialogExample(label: 'Open dialog');

/// A full-screen dialog.
Widget _dialogFullScreen(BuildContext context) =>
    const _DialogDialogExample(label: 'Open full screen', fullScreen: true);

/// A barrier-locked dialog.
Widget _dialogLocked(BuildContext context) => const _DialogDialogExample(
  label: 'Open locked dialog',
  barrierDismissible: false,
);

/// A dialog themed from the widget leg.
Widget _dialogThemed(BuildContext context) => _DialogDialogExample(
  label: 'Open themed dialog',
  theme: const DialogTheme(
    maxWidth: 320,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    shadows: <BoxShadow>[],
  ),
);

/// Named docs examples for `dialog`; the first entry is the default.
const List<ComponentPreview> dialogPreviews = <ComponentPreview>[
  ComponentPreview('Default', _dialogDefault),
  ComponentPreview('Full screen', _dialogFullScreen),
  ComponentPreview('Barrier locked', _dialogLocked),
  ComponentPreview('Themed', _dialogThemed),
];
