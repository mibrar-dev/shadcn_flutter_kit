// Gallery preview for the `drawer` component: side drawers, a sheet, a nested
// drawer and a themed panel. Widgets-only; the docs app embeds
// [DrawerPreview] directly (it needs a `Navigator` ancestor).

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'drawer.dart';

/// Renders the drawer gallery.
class DrawerPreview extends StatelessWidget {
  /// Creates the preview.
  const DrawerPreview({super.key});

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
                _section('Drawers', _drawerButtons()),
                const Gap(24),
                _section('Sheet', _sheetButton()),
                const Gap(24),
                _section('Themed', _themedButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final OverlayPosition position in <OverlayPosition>[
          OverlayPosition.start,
          OverlayPosition.end,
          OverlayPosition.top,
          OverlayPosition.bottom,
        ])
          Builder(
            builder: (BuildContext context) => Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () => openDrawer<void>(
                context: context,
                position: position,
                builder: (BuildContext context) => _DrawerContent(),
              ),
              child: Text(position.name),
            ),
          ),
      ],
    );
  }

  Widget _sheetButton() {
    return Builder(
      builder: (BuildContext context) => Button(
        variant: ButtonVariant.secondary,
        size: ButtonSize.sm,
        onPressed: () => openSheet<void>(
          context: context,
          draggable: true,
          maxSize: 220,
          builder: (BuildContext context) => _SheetContent(),
        ),
        child: const Text('Open sheet'),
      ),
    );
  }

  Widget _themedButton() {
    return Builder(
      builder: (BuildContext context) => Button(
        variant: ButtonVariant.secondary,
        size: ButtonSize.sm,
        onPressed: () => openDrawer<void>(
          context: context,
          theme: const DrawerTheme(
            maxSize: 280,
            background: ThemedColor.ref(ColorRef.card),
          ),
          builder: (BuildContext context) => _DrawerContent(),
        ),
        child: const Text('Open themed drawer'),
      ),
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

/// Panel body used by the gallery drawers.
class _DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Drawer content'),
        const Gap(16),
        Button(
          size: ButtonSize.sm,
          onPressed: () => openDrawer<void>(
            context: context,
            position: OverlayPosition.bottom,
            builder: (BuildContext context) => _DrawerContent(),
          ),
          child: const Text('Open another'),
        ),
        const Gap(8),
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => closeDrawer(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Sheet body used by the gallery.
class _SheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Sheet content'),
        const Gap(16),
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
