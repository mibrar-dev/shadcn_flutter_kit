// Gallery preview for the `outlined_container` component: token look,
// custom radius/padding, translucency, backdrop blur, dashed borders and the
// dark palette.
// Widgets-only; the docs app embeds [OutlinedContainerPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'outlined_container.dart';

/// Renders the outlined container gallery.
class OutlinedContainerPreview extends StatelessWidget {
  /// Creates the preview.
  const OutlinedContainerPreview({super.key});

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
                _section('Default', _default()),
                const Gap(24),
                _section('Radius and padding', _rounded()),
                const Gap(24),
                _section('Translucent', _translucent()),
                const Gap(24),
                _section('Blur', _blurred()),
                const Gap(24),
                _section('Dashed', _dashed()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _default() {
    return const SizedBox(
      width: 320,
      child: OutlinedContainer(
        padding: EdgeInsets.all(16),
        child: Text('Outlined container'),
      ),
    );
  }

  Widget _rounded() {
    return SizedBox(
      width: 320,
      child: OutlinedContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(24),
        child: const Text('Rounded corners'),
      ),
    );
  }

  Widget _translucent() {
    return SizedBox(
      width: 320,
      child: OutlinedContainer(
        padding: const EdgeInsets.all(16),
        backgroundColor: ThemedColor.ref(ColorRef.primary),
        surfaceOpacity: 0.12,
        child: const Text('Translucent primary fill'),
      ),
    );
  }

  Widget _blurred() {
    return SizedBox(
      width: 320,
      child: OutlinedContainer(
        padding: const EdgeInsets.all(16),
        surfaceBlur: 12,
        surfaceOpacity: 0.6,
        child: const Text('Backdrop blur'),
      ),
    );
  }

  Widget _dashed() {
    return const SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DashedContainer(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Dashed container'),
            ),
          ),
          Gap(16),
          DashedLine(),
        ],
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: _default(),
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
