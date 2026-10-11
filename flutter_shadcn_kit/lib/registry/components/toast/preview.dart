// Named examples for the `toast` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example owns its controller; the demo toast is
// persistent (`autoDismiss: false`) so no timer outlives the test.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'toast.dart';

/// A persistent toast shown on mount, plus buttons for every placement.
class _DefaultToast extends StatefulWidget {
  const _DefaultToast();

  @override
  State<_DefaultToast> createState() => _DefaultToastState();
}

class _DefaultToastState extends State<_DefaultToast> {
  final ToastController _controller = ToastController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.topCenter,
          autoDismiss: false,
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
    final spacing = ShadcnTheme.of(context).spacing;
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: ToastLayer(
        controller: _controller,
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: <Widget>[
            for (final ToastPlacement placement in ToastPlacement.values)
              Button(
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                onPressed: () => _controller.showToast(
                  placement: placement,
                  builder: (BuildContext context) =>
                      Text('Toast at ${placement.name}.'),
                ),
                child: Text(placement.name),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultToast();

/// A persistent destructive toast tinted with the destructive token.
class _DestructiveToast extends StatefulWidget {
  const _DestructiveToast();

  @override
  State<_DestructiveToast> createState() => _DestructiveToastState();
}

class _DestructiveToastState extends State<_DestructiveToast> {
  final ToastController _controller = ToastController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.bottomCenter,
          autoDismiss: false,
          builder: (BuildContext context) =>
              const Text('Could not save the file.'),
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
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: ToastLayer(
        controller: _controller,
        theme: const ToastTheme(
          background: ThemedColor.ref(ColorRef.destructive),
          foreground: ThemedColor.ref(ColorRef.destructiveForeground),
        ),
        child: Button(
          variant: ButtonVariant.destructive,
          size: ButtonSize.sm,
          onPressed: () => _controller.showToast(
            placement: ToastPlacement.bottomCenter,
            autoDismiss: false,
            builder: (BuildContext context) =>
                const Text('Could not save the file.'),
          ),
          child: const Text('Show destructive toast'),
        ),
      ),
    );
  }
}

Widget _destructive(BuildContext context) => const _DestructiveToast();

/// A persistent toast with an inline action button.
class _ActionToast extends StatefulWidget {
  const _ActionToast();

  @override
  State<_ActionToast> createState() => _ActionToastState();
}

class _ActionToastState extends State<_ActionToast> {
  final ToastController _controller = ToastController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showToast(
          placement: ToastPlacement.bottomTrailing,
          autoDismiss: false,
          builder: _toastBody,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _toastBody(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.md,
      runSpacing: spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        const Text('Deployment started.'),
        Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.sm,
          onPressed: () {},
          child: const Text('View'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The fixed box is inherent: toasts position against the layer, so the
    // layer needs a stage of its own.
    return SizedBox(
      width: 360,
      height: 220,
      child: ToastLayer(
        controller: _controller,
        child: Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.sm,
          onPressed: () => _controller.showToast(
            placement: ToastPlacement.bottomTrailing,
            autoDismiss: false,
            builder: _toastBody,
          ),
          child: const Text('Show toast with action'),
        ),
      ),
    );
  }
}

Widget _withAction(BuildContext context) => const _ActionToast();

/// Named docs examples for `toast`; the first entry is the default.
const List<ComponentPreview> toastPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Destructive', _destructive),
  ComponentPreview('With action', _withAction),
];
