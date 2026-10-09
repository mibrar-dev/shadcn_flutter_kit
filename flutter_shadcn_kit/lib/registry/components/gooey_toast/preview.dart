// Gallery preview for the `gooey_toast` component: every state, position,
// shape, animation and body profile, plus a persistent demo toast.
// Widgets-only; the docs app embeds [GooeyToastPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'gooey_toast.dart';

/// Renders the gooey toast gallery.
class GooeyToastPreview extends StatefulWidget {
  /// Creates the preview.
  const GooeyToastPreview({super.key});

  @override
  State<GooeyToastPreview> createState() => _GooeyToastPreviewState();
}

class _GooeyToastPreviewState extends State<GooeyToastPreview> {
  // Long default so the demo toast stays visible while the gallery is open.
  final GooeyToastController _controller = GooeyToastController(
    defaultDuration: const Duration(minutes: 5),
    singlePerSlot: false,
  );

  // Style rows switch this widget-leg theme, so the change is visible live.
  GooeyToastTheme _theme = const GooeyToastTheme();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _controller.showGooeyToast(
        const GooeyToastOptions(
          title: 'Saved to your workspace',
          description: 'Everything is in sync.',
          state: GooeyToastState.success,
          persistUntilDismissed: true,
        ),
      );
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
          child: GooeyToastLayer(
            controller: _controller,
            theme: _theme,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _section('States', _states()),
                  const Gap(24),
                  _section('Positions', _positions()),
                  const Gap(24),
                  _section('Expand direction', _directions()),
                  const Gap(24),
                  _section('Animation styles', _animations()),
                  const Gap(24),
                  _section('Shape styles', _shapes()),
                  const Gap(24),
                  _section('Body animation', _bodies()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _states() {
    return _wrap(<Widget>[
      for (final GooeyToastState state in GooeyToastState.values)
        _button(state.name, () {
          _controller.showGooeyToast(
            GooeyToastOptions(
              title: 'State: ${state.name}',
              description: 'The tone and icon follow the state.',
              state: state,
              action: state == GooeyToastState.action
                  ? GooeyToastAction(label: 'Open', onPressed: () {})
                  : null,
            ),
          );
        }),
    ]);
  }

  Widget _positions() {
    return _wrap(<Widget>[
      for (final GooeyToastPosition position in GooeyToastPosition.values)
        _button('position: ${position.name}', () {
          _controller.showGooeyToast(
            GooeyToastOptions(
              title: 'Position: ${position.name}',
              description: 'Anchored to the ${position.name} edge.',
              position: position,
              state: GooeyToastState.info,
            ),
          );
        }),
    ]);
  }

  Widget _directions() {
    return _wrap(<Widget>[
      for (final GooeyToastExpandDirection direction
          in GooeyToastExpandDirection.values)
        _button('grow ${direction.name}', () {
          _controller.showGooeyToast(
            GooeyToastOptions(
              title: 'Grows ${direction.name}',
              description: 'The body expands from the pill.',
              expandDirection: direction,
              position: GooeyToastPosition.center,
              state: GooeyToastState.info,
            ),
          );
        }),
    ]);
  }

  Widget _animations() {
    return _wrap(<Widget>[
      for (final GooeyToastAnimationStyle style
          in GooeyToastAnimationStyle.values)
        _button(style.name, () {
          setState(() => _theme = GooeyToastTheme(animationStyle: style));
          _controller.showGooeyToast(
            GooeyToastOptions(
              title: 'Animation: ${style.name}',
              description: 'Morph profile of the silhouette.',
              state: GooeyToastState.info,
            ),
          );
        }),
    ]);
  }

  Widget _shapes() {
    return _wrap(<Widget>[
      for (final GooeyToastShapeStyle shape in GooeyToastShapeStyle.values)
        _button(shape.name, () {
          setState(() => _theme = GooeyToastTheme(shapeStyle: shape));
          _controller.showGooeyToast(
            GooeyToastOptions(
              title: 'Shape: ${shape.name}',
              description: 'Corner profile of the gooey shape.',
              state: GooeyToastState.warning,
            ),
          );
        }),
    ]);
  }

  Widget _bodies() {
    return _wrap(<Widget>[
      for (final GooeyToastBodyAnimationStyle body
          in GooeyToastBodyAnimationStyle.values)
        _button(body.name, () {
          setState(() => _theme = GooeyToastTheme(bodyAnimationStyle: body));
          _controller.showGooeyToast(
            GooeyToastOptions(
              title: 'Body: ${body.name}',
              description: 'Content animation of the expanded body.',
              state: GooeyToastState.action,
              action: GooeyToastAction(label: 'Reply', onPressed: () {}),
            ),
          );
        }),
    ]);
  }

  Widget _button(String label, VoidCallback onPressed) {
    return Button(
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _wrap(List<Widget> children) {
    return Wrap(spacing: 8, runSpacing: 8, children: children);
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
