import 'package:flutter/widgets.dart';

import '../../component_example_models.dart';
import '../../../../ui/shadcn/components/layout/collapsible/collapsible.dart'
    as shadcn_collapsible;
import '../../../../ui/shadcn/components/layout/outlined_container/outlined_container.dart'
    as shadcn_outlined;
import '../../../../ui/shadcn/shared/primitives/text.dart';
import '../../../../ui/shadcn/shared/utils/util.dart';

const ComponentExample collapsibleBasicExample = ComponentExample(
  title: 'Basic',
  builder: _buildCollapsibleBasicExample,
  code: '''Collapsible(
  children: [
    CollapsibleTrigger(child: Text('@mibrar-dev starred 3 repositories')),
    CollapsibleContent(
      child: OutlinedContainer(
        child: Text('@mibrar-dev/shadcn_flutter_kit')
            .small()
            .mono()
            .withPadding(horizontal: 16, vertical: 8),
      ),
    ),
  ],
)''',
);

Widget _buildCollapsibleBasicExample(BuildContext context) {
  return shadcn_collapsible.Collapsible(
    children: [
      const shadcn_collapsible.CollapsibleTrigger(
        child: Text('@mibrar-dev starred 3 repositories'),
      ),
      shadcn_collapsible.CollapsibleContent(
        child: shadcn_outlined.OutlinedContainer(
          child: const Text('@mibrar-dev/shadcn_flutter_kit')
              .small()
              .mono()
              .withPadding(horizontal: 16, vertical: 8),
        ).withPadding(top: 8),
      ),
    ],
  );
}
