import 'package:flutter/widgets.dart';

import '../../component_example_models.dart';
import 'collapsible_basic_example.dart';
import 'collapsible_example_1.dart';
import 'collapsible_faq_example.dart';
import 'collapsible_icon_example.dart';

const ComponentExample collapsibleExample1 = ComponentExample(
  title: 'Repository list',
  builder: _buildCollapsibleExample1,
  code: "import 'package:docs/shadcn_ui.dart';\n\nclass CollapsibleExample1 extends StatelessWidget {\n  const CollapsibleExample1({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return Collapsible(\n      children: [\n        const CollapsibleTrigger(\n          child: Text('@mibrar-dev starred 3 repositories'),\n        ),\n        OutlinedContainer(\n          child: const Text('@mibrar-dev/shadcn_flutter_kit')\n              .small()\n              .mono()\n              .withPadding(horizontal: 16, vertical: 8),\n        ).withPadding(top: 8),\n        CollapsibleContent(\n          child: OutlinedContainer(\n            child: const Text('@flutter/flutter')\n                .small()\n                .mono()\n                .withPadding(horizontal: 16, vertical: 8),\n          ).withPadding(top: 8),\n        ),\n        CollapsibleContent(\n          child: OutlinedContainer(\n            child: const Text('@dart-lang/sdk')\n                .small()\n                .mono()\n                .withPadding(horizontal: 16, vertical: 8),\n          ).withPadding(top: 8),\n        ),\n      ],\n    );\n  }\n}",
);

Widget _buildCollapsibleExample1(BuildContext context) {
  return const CollapsibleExample1();
}

const List<ComponentExample> collapsibleExamples = [
  collapsibleBasicExample,
  collapsibleExample1,
  collapsibleFaqExample,
  collapsibleIconExample,
];
