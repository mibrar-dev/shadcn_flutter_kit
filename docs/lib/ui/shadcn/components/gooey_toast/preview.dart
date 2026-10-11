// Named examples for the `gooey_toast` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Each example
// owns its controller; the demo toast is persistent (`persistUntilDismissed`
// + `autoDismiss: false`) so no timer outlives the test.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'gooey_toast.dart';

/// A persistent pill toast, plus a button firing an info toast.
class _PillExample extends StatefulWidget {
  const _PillExample();

  @override
  State<_PillExample> createState() => _PillExampleState();
}

class _PillExampleState extends State<_PillExample> {
  final GooeyToastController _controller = GooeyToastController(
    defaultDuration: const Duration(minutes: 5),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.showGooeyToast(
          const GooeyToastOptions(
            title: 'Saved to your workspace',
            description: 'Everything is in sync.',
            state: GooeyToastState.success,
            persistUntilDismissed: true,
          ),
          autoDismiss: false,
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
      child: GooeyToastLayer(
        controller: _controller,
        child: Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () => _controller.showGooeyToast(
                const GooeyToastOptions(
                  title: 'FYI',
                  description: 'The body expands from the pill.',
                  state: GooeyToastState.info,
                ),
              ),
              child: const Text('Show info toast'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _pill(BuildContext context) => const _PillExample();

/// A persistent toast with an expanded body, plus a button re-firing it.
class _ExpandedExample extends StatefulWidget {
  const _ExpandedExample();

  @override
  State<_ExpandedExample> createState() => _ExpandedExampleState();
}

class _ExpandedExampleState extends State<_ExpandedExample> {
  final GooeyToastController _controller = GooeyToastController(
    defaultDuration: const Duration(minutes: 5),
  );

  void _show() {
    _controller.showGooeyToast(
      GooeyToastOptions(
        title: 'Deploy finished',
        description: 'Three targets updated.',
        state: GooeyToastState.success,
        persistUntilDismissed: true,
        expandedChild: Text(
          'main, staging and edge are on build 482.',
          style: TextStyle(color: ShadcnTheme.of(context).colors.foreground),
        ),
      ),
      autoDismiss: false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _show();
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
      child: GooeyToastLayer(
        controller: _controller,
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: _show,
          child: const Text('Show expanded toast'),
        ),
      ),
    );
  }
}

Widget _expanded(BuildContext context) => const _ExpandedExample();

/// Named docs examples for `gooey_toast`; the first entry is the default.
const List<ComponentPreview> gooeyToastPreviews = <ComponentPreview>[
  ComponentPreview('Pill', _pill),
  ComponentPreview('Expanded', _expanded),
];
