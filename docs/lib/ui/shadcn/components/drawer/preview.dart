// Named examples for the `drawer` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'drawer.dart';

/// Panel body used by the drawer examples.
class _DrawerDrawerContent extends StatelessWidget {
  const _DrawerDrawerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Drawer content'),
        Gap(ShadcnTheme.of(context).spacing.lg),
        Button(
          size: ButtonSize.sm,
          onPressed: () => closeDrawer(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Sheet body used by the sheet example.
class _DrawerSheetContent extends StatelessWidget {
  const _DrawerSheetContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Sheet content'),
        Gap(ShadcnTheme.of(context).spacing.lg),
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => closeSheet(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Opens a drawer at [position].
class _DrawerDrawerTrigger extends StatelessWidget {
  const _DrawerDrawerTrigger({required this.position, required this.label});

  final OverlayPosition position;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      onPressed: () => openDrawer<void>(
        context: context,
        position: position,
        builder: (BuildContext context) => const _DrawerDrawerContent(),
      ),
      child: Text(label),
    );
  }
}

/// Side drawers, one row (shadcn shows the four edges together).
Widget _drawerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.sm,
    runSpacing: spacing.sm,
    children: const <Widget>[
      _DrawerDrawerTrigger(position: OverlayPosition.start, label: 'left'),
      _DrawerDrawerTrigger(position: OverlayPosition.end, label: 'right'),
      _DrawerDrawerTrigger(position: OverlayPosition.top, label: 'top'),
      _DrawerDrawerTrigger(position: OverlayPosition.bottom, label: 'bottom'),
    ],
  );
}

/// The bottom sheet form.
Widget _drawerSheet(BuildContext context) {
  return Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () => openSheet<void>(
      context: context,
      draggable: true,
      builder: (BuildContext context) => const _DrawerSheetContent(),
    ),
    child: const Text('Open sheet'),
  );
}

/// A drawer themed from the widget leg.
Widget _drawerThemed(BuildContext context) {
  return Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () => openDrawer<void>(
      context: context,
      theme: const DrawerTheme(
        maxSize: 280,
        background: ThemedColor.ref(ColorRef.card),
      ),
      builder: (BuildContext context) => const _DrawerDrawerContent(),
    ),
    child: const Text('Open themed drawer'),
  );
}

/// Named docs examples for `drawer`; the first entry is the default.
const List<ComponentPreview> drawerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _drawerDefault),
  ComponentPreview('Sheet', _drawerSheet),
  ComponentPreview('Themed', _drawerThemed),
];
