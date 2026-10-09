// Gallery preview for the `divider` component: both orientations, the label
// form, indents and the dark palette.
// Widgets-only; the docs app embeds [DividerPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'divider.dart';

/// Renders the divider gallery.
class DividerPreview extends StatelessWidget {
  /// Creates the preview.
  const DividerPreview({super.key});

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
                _section('Horizontal', const Divider()),
                const Gap(24),
                _section(
                  'Horizontal with label',
                  const Divider(label: Text('or continue with')),
                ),
                const Gap(24),
                _section(
                  'Label alignment',
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Divider(
                        labelAlignment: DividerLabelAlignment.start,
                        label: Text('start'),
                      ),
                      Gap(8),
                      Divider(label: Text('center')),
                      Gap(8),
                      Divider(
                        labelAlignment: DividerLabelAlignment.end,
                        label: Text('end'),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                _section('Indents and thickness', _custom()),
                const Gap(24),
                _section('Vertical', _vertical()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _custom() {
    return const SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(thickness: 3),
          Gap(8),
          Divider(indent: 40, endIndent: 40),
        ],
      ),
    );
  }

  Widget _vertical() {
    return SizedBox(
      height: 72,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          Text('left'),
          Divider(axis: Axis.vertical),
          Text('right'),
        ],
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: const SizedBox(width: 320, child: Divider(label: Text('dark'))),
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
