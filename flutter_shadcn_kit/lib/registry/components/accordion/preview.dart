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
  return const SizedBox(
    width: 420,
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
  return const SizedBox(width: 420, child: _AccordionExpandedAccordion());
}

class _AccordionExpandedAccordion extends StatefulWidget {
  const _AccordionExpandedAccordion();

  @override
  State<_AccordionExpandedAccordion> createState() =>
      _AccordionExpandedAccordionState();
}

class _AccordionExpandedAccordionState
    extends State<_AccordionExpandedAccordion> {
  final GlobalKey<AccordionState> _key = GlobalKey<AccordionState>();

  @override
  void initState() {
    super.initState();
    // Opened after the first layout so the item identity exists.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _key.currentState?.toggle(const Key('styled'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Accordion(
      key: _key,
      items: <Widget>[
        const AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it accessible?')),
          content: Text(
            'Yes. It follows the WAI-ARIA disclosure pattern and responds '
            'to Enter and Space.',
          ),
        ),
        AccordionItem(
          key: const Key('styled'),
          trigger: const AccordionTrigger(child: Text('Is it styled?')),
          content: const Text(
            'Yes. Defaults come from the global tokens and every part is '
            'overridable through AccordionTheme.',
          ),
        ),
        const AccordionItem(
          trigger: AccordionTrigger(child: Text('Is it animated?')),
          content: Text('Yes. Items animate with the theme duration.'),
        ),
      ],
    );
  }
}

/// Two accordions stacked, so more than one can be open at a time.
Widget _accordionMultiple(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const SizedBox(width: 420, child: _AccordionTwoItemAccordion()),
      Gap(spacing.lg),
      const SizedBox(width: 420, child: _AccordionTwoItemAccordion()),
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
