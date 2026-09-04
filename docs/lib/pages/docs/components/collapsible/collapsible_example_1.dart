import 'package:flutter/widgets.dart';

import '../../../../ui/shadcn/components/layout/collapsible/collapsible.dart'
    as shadcn_collapsible;
import '../../../../ui/shadcn/components/layout/outlined_container/outlined_container.dart'
    as shadcn_outlined;
import '../../../../ui/shadcn/shared/primitives/text.dart';
import '../../../../ui/shadcn/shared/utils/util.dart';

class CollapsibleExample1 extends StatelessWidget {
  const CollapsibleExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn_collapsible.Collapsible(
      children: [
        const shadcn_collapsible.CollapsibleTrigger(
          child: Text('@mibrar-dev starred 3 repositories'),
        ),
        shadcn_outlined.OutlinedContainer(
          child: const Text('@mibrar-dev/shadcn_flutter_kit')
              .small()
              .mono()
              .withPadding(horizontal: 16, vertical: 8),
        ).withPadding(top: 8),
        shadcn_collapsible.CollapsibleContent(
          child: shadcn_outlined.OutlinedContainer(
            child: const Text('@flutter/flutter')
                .small()
                .mono()
                .withPadding(horizontal: 16, vertical: 8),
          ).withPadding(top: 8),
        ),
        shadcn_collapsible.CollapsibleContent(
          child: shadcn_outlined.OutlinedContainer(
            child: const Text('@dart-lang/sdk')
                .small()
                .mono()
                .withPadding(horizontal: 16, vertical: 8),
          ).withPadding(top: 8),
        ),
      ],
    );
  }
}
