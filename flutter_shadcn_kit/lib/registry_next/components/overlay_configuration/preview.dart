// Gallery preview for the `overlay_configuration` component: every
// configuration through one `showOverlay` call site, plus an `OverlayController`
// demo. Widgets-only; ships its own navigator and overlay manager.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/overlay_manager.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'overlay_configuration.dart';

/// Renders the overlay-configuration gallery.
class OverlayConfigurationPreview extends StatelessWidget {
  /// Creates the preview.
  const OverlayConfigurationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 14),
        child: ShadcnLayer(
          child: Navigator(
            onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder: (_, _, _) => const _OverlayConfigGallery(),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayConfigGallery extends StatelessWidget {
  const _OverlayConfigGallery();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _OverlayConfigTrigger(
              label: 'Popover',
              configuration: const PopoverConfiguration(
                alignment: Alignment.bottomCenter,
              ),
            ),
            _OverlayConfigTrigger(
              label: 'Tooltip',
              configuration: const TooltipConfiguration(
                alignment: Alignment.topCenter,
              ),
            ),
            _OverlayConfigTrigger(
              label: 'Drawer',
              configuration: const DrawerConfiguration(
                position: OverlayPosition.end,
              ),
            ),
            _OverlayConfigTrigger(
              label: 'Sheet',
              configuration: const SheetConfiguration(maxSize: 220),
            ),
            _OverlayConfigTrigger(
              label: 'Dialog',
              configuration: const DialogConfiguration(),
            ),
            const _OverlayConfigControllerTrigger(),
          ],
        ),
      ),
    );
  }
}

class _OverlayConfigTrigger extends StatelessWidget {
  const _OverlayConfigTrigger({
    required this.label,
    required this.configuration,
  });

  final String label;
  final OverlayConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      onPressed: () => showOverlay<void>(
        context,
        configuration,
        builder: (BuildContext context) => const _OverlayConfigBody(),
      ),
      child: Text(label),
    );
  }
}

class _OverlayConfigControllerTrigger extends StatefulWidget {
  const _OverlayConfigControllerTrigger();

  @override
  State<_OverlayConfigControllerTrigger> createState() =>
      _OverlayConfigControllerTriggerState();
}

class _OverlayConfigControllerTriggerState
    extends State<_OverlayConfigControllerTrigger> {
  final OverlayController _controller = OverlayController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.secondary,
      size: ButtonSize.sm,
      onPressed: () => _controller.show<void>(
        context,
        const PopoverConfiguration(alignment: Alignment.center),
        builder: (BuildContext context) => const _OverlayConfigBody(),
      ),
      child: const Text('Controller'),
    );
  }
}

class _OverlayConfigBody extends StatelessWidget {
  const _OverlayConfigBody();

  @override
  Widget build(BuildContext context) {
    final OverlayConfiguration? configuration = OverlayConfiguration.maybeOf(
      context,
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Overlay content'),
          const Gap(8),
          Text(
            configuration == null
                ? 'no configuration'
                : configuration.runtimeType.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
