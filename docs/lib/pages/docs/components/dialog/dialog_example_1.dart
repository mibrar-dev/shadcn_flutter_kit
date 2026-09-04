import 'package:docs/shadcn_ui.dart';
import 'package:docs/ui/shadcn/components/overlay/dialog/dialog.dart'
    as shadcn_dialog;

class DialogExample1 extends StatelessWidget {
  const DialogExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        final controller = FormController();
        shadcn_dialog.showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Edit profile'),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Make changes to your profile here. Click save when you\'re done.',
                    ),
                    const Gap(16),
                    Form(
                      controller: controller,
                      child: const FormTableLayout(
                        rows: [
                          FormField<String>(
                            key: FormKey(#name),
                            label: Text('Name'),
                            child: TextField(
                              initialValue: 'M Ibrar',
                              autofocus: true,
                            ),
                          ),
                          FormField<String>(
                            key: FormKey(#username),
                            label: Text('Username'),
                            child: TextField(
                              initialValue: '@mibrar-dev',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                PrimaryButton(
                  child: const Text('Save changes'),
                  onPressed: () {
                    Navigator.of(context).pop(controller.values);
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text('Edit Profile'),
    );
  }
}
