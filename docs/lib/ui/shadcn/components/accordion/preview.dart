// Named examples for the `accordion` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'accordion.dart';

/// The three classic questions, collapsed.
Widget _accordionDefault(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 420),
    child: Accordion(
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
          content: Text('Yes. Items animate with the theme duration.'),
        ),
      ],
    ),
  );
}

/// The second item is opened on the first frame.
Widget _accordionExpanded(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 420),
    child: Accordion(
      items: <Widget>[
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it accessible?')),
          content: Text(
            'Yes. It follows the WAI-ARIA disclosure pattern and responds '
            'to Enter and Space.',
          ),
        ),
        AccordionItem(
          expanded: true,
          trigger: AccordionTrigger(child: Text('Is it styled?')),
          content: Text(
            'Yes. Defaults come from the global tokens and every part is '
            'overridable through AccordionTheme.',
          ),
        ),
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it animated?')),
          content: Text('Yes. Items animate with the theme duration.'),
        ),
      ],
    ),
  );
}

/// Two accordions stacked, so more than one can be open at a time.
Widget _accordionMultiple(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _AccordionTwoItemAccordion(),
      ),
      Gap(spacing.lg),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _AccordionTwoItemAccordion(),
      ),
    ],
  );
}

class _AccordionTwoItemAccordion extends StatelessWidget {
  const _AccordionTwoItemAccordion();

  @override
  Widget build(BuildContext context) {
    return const Accordion(
      items: <Widget>[
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Shipping')),
          content: Text('Dispatched within two working days.'),
        ),
        AccordionItem(
          trigger: AccordionTrigger(child: Text('Returns')),
          content: Text('Free returns within 30 days.'),
        ),
      ],
    );
  }
}

/// Named docs examples for `accordion`; the first entry is the default.
const List<ComponentPreview> accordionPreviews = <ComponentPreview>[
  ComponentPreview('Default', _accordionDefault),
  ComponentPreview('Expanded', _accordionExpanded),
  ComponentPreview('Multiple', _accordionMultiple),
];
