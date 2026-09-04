import 'package:flutter/widgets.dart';

import '../../component_example_models.dart';
import 'dialog_example_1.dart';

const ComponentExample dialogExample1 = ComponentExample(
  title: 'Profile edit dialog',
  builder: _buildDialogExample1,
  code:
      "import 'package:docs/shadcn_ui.dart';\nimport 'package:docs/ui/shadcn/components/overlay/dialog/dialog.dart' as shadcn_dialog;\n\nclass DialogExample1 extends StatelessWidget {\n  const DialogExample1({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return PrimaryButton(\n      onPressed: () {\n        final controller = FormController();\n        shadcn_dialog.showDialog(\n          context: context,\n          builder: (context) {\n            return AlertDialog(\n              title: const Text('Edit profile'),\n              content: ConstrainedBox(\n                constraints: const BoxConstraints(maxWidth: 420),\n                child: Column(\n                  mainAxisSize: MainAxisSize.min,\n                  crossAxisAlignment: CrossAxisAlignment.start,\n                  children: [\n                    const Text(\n                      'Make changes to your profile here. Click save when you\\'re done.',\n                    ),\n                    const Gap(16),\n                    Form(\n                      controller: controller,\n                      child: const FormTableLayout(\n                        rows: [\n                          FormField<String>(\n                            key: FormKey(#name),\n                            label: Text('Name'),\n                            child: TextField(\n                              initialValue: 'M Ibrar',\n                              autofocus: true,\n                            ),\n                          ),\n                          FormField<String>(\n                            key: FormKey(#username),\n                            label: Text('Username'),\n                            child: TextField(\n                              initialValue: '@mibrar-dev',\n                            ),\n                          ),\n                        ],\n                      ),\n                    ),\n                  ],\n                ),\n              ),\n              actions: [\n                PrimaryButton(\n                  child: const Text('Save changes'),\n                  onPressed: () {\n                    Navigator.of(context).pop(controller.values);\n                  },\n                ),\n              ],\n            );\n          },\n        );\n      },\n      child: const Text('Edit Profile'),\n    );\n  }\n}",
);

Widget _buildDialogExample1(BuildContext context) {
  return const DialogExample1();
}

const List<ComponentExample> dialogExamples = [
  dialogExample1,
];
