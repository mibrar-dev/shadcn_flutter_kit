// Gallery preview for the `accordion` component: the classic three-question
// stack plus the dark palette.
// Widgets-only; the docs app embeds [AccordionPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'accordion.dart';

/// Renders the accordion gallery.
class AccordionPreview extends StatelessWidget {
  /// Creates the preview.
  const AccordionPreview({super.key});

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
                _section(context, 'Default', _stack()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stack() {
    return SizedBox(
      width: 420,
      child: const Accordion(
        items: <Widget>[
          AccordionItem(
            trigger: AccordionTrigger(child: Text('Is it accessible?')),
            content: Text(
              'Yes. It follows the WAI-ARIA disclosure pattern and responds '
              'to Enter and Space.',
            ),
          ),
          AccordionItem(
            trigger: AccordionTrigger(child: Text('Is it styled?')),
            content: Text(
              'Yes. Defaults come from the global tokens and every part is '
              'overridable through AccordionTheme.',
            ),
          ),
          AccordionItem(
            trigger: AccordionTrigger(child: Text('Is it animated?')),
            content: Text(
              'Yes. Items animate with the theme duration and curves.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: _stack(),
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
