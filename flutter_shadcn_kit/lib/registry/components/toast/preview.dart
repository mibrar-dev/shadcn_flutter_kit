// Gallery preview for the `toast` component: trigger buttons for every
// placement plus a persistent demo toast and the dark palette.
// Widgets-only; the docs app embeds [ToastPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'toast.dart';

/// Renders the toast gallery.
class ToastPreview extends StatefulWidget {
  /// Creates the preview.
  const ToastPreview({super.key});

  @override
  State<ToastPreview> createState() => _ToastPreviewState();
}

class _ToastPreviewState extends State<ToastPreview> {
  // Long default so the demo toast stays visible while the gallery is open.
  final ToastController _controller = ToastController(
    defaultDuration: const Duration(minutes: 5),
    singlePerSlot: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.topCenter,
          builder: (BuildContext context) =>
              const Text('Saved to your workspace.'),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: ToastLayer(
            controller: _controller,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _section('Placements', _placements()),
                  const Gap(24),
                  _section('Themed card', _themed()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placements() {
    const List<ToastPlacement> placements = <ToastPlacement>[
      ToastPlacement.topLeading,
      ToastPlacement.topCenter,
      ToastPlacement.topTrailing,
      ToastPlacement.bottomLeading,
      ToastPlacement.bottomCenter,
      ToastPlacement.bottomTrailing,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final ToastPlacement placement in placements)
          Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: () => _show(placement),
            child: Text(placement.name),
          ),
      ],
    );
  }

  Widget _themed() {
    return Button(
      variant: ButtonVariant.secondary,
      size: ButtonSize.sm,
      onPressed: () => _controller.showToast(
        placement: ToastPlacement.bottomCenter,
        builder: (BuildContext context) => const Text('Deployment started.'),
      ),
      child: const Text('Show themed toast'),
    );
  }

  void _show(ToastPlacement placement) {
    _controller.showToast(
      placement: placement,
      builder: (BuildContext context) => Text('Toast at ${placement.name}.'),
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
