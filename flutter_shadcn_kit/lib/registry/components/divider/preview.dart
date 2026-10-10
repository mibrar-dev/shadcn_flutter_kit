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
                _section(context, 'Horizontal', const Divider()),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'Horizontal with label',
                  const Divider(label: Text('or continue with')),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'Label alignment',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Divider(
                        labelAlignment: DividerLabelAlignment.start,
                        label: Text('start'),
                      ),
                      Gap(theme.spacing.sm),
                      Divider(label: Text('center')),
                      Gap(theme.spacing.sm),
                      Divider(
                        labelAlignment: DividerLabelAlignment.end,
                        label: Text('end'),
                      ),
                    ],
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(context, 'Indents and thickness', _custom(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Vertical', _vertical()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _custom(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(thickness: 3),
          Gap(ShadcnTheme.of(context).spacing.sm),
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

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
