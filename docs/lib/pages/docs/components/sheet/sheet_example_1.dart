import 'package:docs/shadcn_ui.dart';
import 'package:flutter/material.dart' show showDialog;

class SheetExample1 extends StatefulWidget {
  const SheetExample1({super.key});

  @override
  State<SheetExample1> createState() => _SheetExample1State();
}

class _SheetExample1State extends State<SheetExample1> {
  final FormController controller = FormController();

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Profile updated'),
          content: Text('Content: ${controller.values}'),
          actions: [
            PrimaryButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 420),
      child: Form(
        controller: controller,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: const Text('Edit profile').large().medium(),
                ),
                TextButton(
                  density: ButtonDensity.icon,
                  child: const Icon(Icons.close),
                  onPressed: () => closeSheet(context),
                ),
              ],
            ),
            const Gap(8),
            const Text(
              'Make changes to your profile here. Click save when you\'re done.',
            ).muted(),
            const Gap(16),
            FormTableLayout(
              rows: [
                FormField<String>(
                  key: const FormKey(#name),
                  label: const Text('Name'),
                  validator:
                      const NotEmptyValidator() & const LengthValidator(min: 4),
                  child: const TextField(
                    initialValue: 'M Ibrar',
                    placeholder: Text('Your full name'),
                  ),
                ),
                FormField<String>(
                  key: const FormKey(#username),
                  label: const Text('Username'),
                  validator:
                      const NotEmptyValidator() & const LengthValidator(min: 4),
                  child: const TextField(
                    initialValue: '@mibrar-dev',
                    placeholder: Text('Your username'),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FormErrorBuilder(
                builder: (context, errors, child) {
                  return PrimaryButton(
                    onPressed: errors.isNotEmpty
                        ? null
                        : () async {
                            final result = await context.submitForm();
                            if (!context.mounted) return;
                            if (result.errors.isEmpty) {
                              await Future<void>.value(closeSheet(context));
                              if (!context.mounted) return;
                              _showConfirmation(context);
                            }
                          },
                    child: const Text('Save changes'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        openSheet(
          context: context,
          builder: _buildSheet,
          position: OverlayPosition.end,
        );
      },
      child: const Text('Open Sheet'),
    );
  }
}
