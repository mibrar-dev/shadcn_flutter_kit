// ignore_for_file: duplicate_import, unnecessary_import
// Example: Create / Edit Form Page with confirmation dialog
// Uses: Card, TextField, TextArea, Select, Button, Alert, Dialog, Text extensions

import 'package:flutter/material.dart' hide Card, TextField;
import '../registry/components/control/button/button.dart';
import '../registry/components/layout/card/card.dart';
import '../registry/components/display/text/text.dart';
import '../registry/components/form/text_field/text_field.dart';
import '../registry/components/form/text_area/text_area.dart';
import '../registry/components/form/select/select.dart';
import '../registry/components/overlay/dialog/dialog.dart' as shadcn_dialog;
import '../registry/components/layout/alert/alert.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedCategory;
  bool _saved = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _confirmDiscard() {
    shadcn_dialog.showDialog<void>(
      context: context,
      builder: (ctx) => Card(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Discard changes?').semiBold(),
            const SizedBox(height: 8),
            const Text('All unsaved changes will be lost. This cannot be undone.').muted().small(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                OutlineButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Keep editing'),
                ),
                const SizedBox(width: 8),
                DestructiveButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).maybePop();
                  },
                  child: const Text('Discard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GhostButton(
                  onPressed: _confirmDiscard,
                  leading: const Icon(Icons.arrow_back, size: 16),
                  child: const Text('Back'),
                ),
                const SizedBox(height: 16),

                const Text('Create project').semiBold(),
                const SizedBox(height: 4),
                const Text('Fill in the details to create a new project.').muted().small(),
                const SizedBox(height: 24),

                if (_saved) ...[
                  const Alert(
                    title: Text('Project saved!'),
                    content: Text('Your project has been created successfully.'),
                    leading: Icon(Icons.check_circle_outline),
                  ),
                  const SizedBox(height: 16),
                ],

                Card(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Project name').semiBold().small(),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        placeholder: const Text('e.g. Acme Website Redesign'),
                        features: [InputFeature.clear()],
                      ),
                      const SizedBox(height: 16),

                      const Text('Description').semiBold().small(),
                      const SizedBox(height: 6),
                      TextArea(
                        controller: _descController,
                        placeholder: const Text('Briefly describe the project goals...'),
                        minLines: 3,
                        maxLines: 6,
                      ),
                      const SizedBox(height: 16),

                      const Text('Category').semiBold().small(),
                      const SizedBox(height: 6),
                      Select<String>(
                        value: _selectedCategory,
                        onChanged: (v) => setState(() => _selectedCategory = v),
                        placeholder: const Text('Select a category'),
                        itemBuilder: (context, item) => Text(item),
                        popup: const SelectPopup(
                          items: SelectItemList(
                            children: [
                              SelectItemButton(value: 'design', child: Text('Design')),
                              SelectItemButton(value: 'engineering', child: Text('Engineering')),
                              SelectItemButton(value: 'marketing', child: Text('Marketing')),
                              SelectItemButton(value: 'research', child: Text('Research')),
                            ],
                          ),
                        ).call,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Spacer(),
                          OutlineButton(
                            onPressed: _confirmDiscard,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          PrimaryButton(
                            onPressed: () => setState(() => _saved = true),
                            child: const Text('Create project'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
